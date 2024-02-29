//The source code here is inspired from the original code written by Bonnie Eisenmen

SerialIO.list() @=> string deviceList[];

for(int i; i < deviceList.cap(); i++)
{
    chout <= i <= ": " <= deviceList[i] <= IO.newline();
}

// parse first argument as device number
0 => int deviceNumber;
if(me.args()) me.arg(0) => Std.atoi => deviceNumber;

if(deviceNumber >= deviceList.cap())
{
    cherr <= "serial device #" <= deviceNumber <= " not available\n";
    me.exit(); 
}

SerialIO cereal;
if(!cereal.open(deviceNumber, SerialIO.B9600, SerialIO.ASCII))
{
    chout <= "unable to open serial device '" <= deviceList[deviceNumber] <= "'\n";
    me.exit();
}

6 => int numPins;
20 => int historyLength;
1.0 => float totalVolume;
4 => int oscsPerPin;

// MIDI values; these determine pitch of each cup.
// These values can be changed
[70, 47, 80, 69, 56, 60] @=> int notes[];

int baseValues[numPins];
int pinHistory[numPins][historyLength];

float baseFrequencies[numPins][oscsPerPin];

Gain gainArray[numPins];
Envelope envelopeArray[numPins];
TriOsc oscillatorArray[numPins][oscsPerPin];
SinOsc sineOscillatorArray[numPins][2];

40 => int triggerThreshold;
300.0 => float range;

Gain globalGain;
globalGain.gain(0.3);
PRCRev reverb;
reverb.mix(0.5);

globalGain => dac;

SinOsc vibrations[numPins];
SinOsc vibration;
vibration => blackhole;
5 => vibration.freq;
5 => float baseVibrationFrequency;

// tok should already have params set
fun void adjust() {

    20 => int numIterations;
    5 => int initialIterations;

    for (0 => int i; i < initialIterations; i++) {
        cereal.onLine() => now;
        cereal.getLine() => string line;
    }
    5::ms => now;

    for (0 => int iteration; iteration < numIterations; iteration++) {
        cereal.onLine() => now;
        cereal.getLine() => string line;
        if(line$Object != null) {
            StringTokenizer tokenizer;
            tokenizer.set(line);

            for (0 => int j; j < numPins; j++) {
                // Fill history with default values
                Std.atoi(tokenizer.next()) => int pinValue;

                for (0 => int k; k < historyLength; k++) {
                    pinValue => pinHistory[j][k];
                }
                // Store a 1D base values array, too.
                pinValue + baseValues[j] => baseValues[j];

            }

        }
    }
    for (0 => int l; l < numPins; l++) {
        <<< baseValues[l] >>>;
        baseValues[l] / numIterations => baseValues[l];
        <<< baseValues[l] >>>;
        <<< "=======" >>>;
    }
    <<< "DONE ADJUSTING" >>>;

}

fun void setup() {
    // Setup stuff
    for (0 => int m; m < numPins; m++) {
        gainArray[m].gain(0.5);
        vibrations[m] => blackhole;
        5 => vibrations[m].freq;
        envelopeArray[m] => globalGain;
        for (1 => int n; n <= oscsPerPin; n++) {
            Std.mtof(notes[m]) * (n) => oscillatorArray[m][n-1].freq;
            //(Std.mtof((36 + m) * 2)) * (n * 0.5) => oscillatorArray[m][n-1].freq;
            oscillatorArray[m][n-1].freq() => baseFrequencies[m][n-1];
            oscillatorArray[m][n-1] => envelopeArray[m]; //=> globalGain;
        }
        baseFrequencies[m][0] => sineOscillatorArray[m][0].freq;
        sineOscillatorArray[m][0] => envelopeArray[m];
        Std.mtof(notes[m] - 24) => sineOscillatorArray[m][1].freq;
        sineOscillatorArray[m][1] => envelopeArray[m];
        0 => baseValues[m];

        dac.chan(m);
    }
}

0 => int bufferIndex;
fun void processLine(StringTokenizer tokenizer) {
    for (0 => int o; o < numPins; o++) {
        Std.atoi(tokenizer.next()) => int newValue;
        newValue => pinHistory[o][bufferIndex];
        
        int oldValue;
        if (bufferIndex == 0) {
            pinHistory[o][historyLength - 1] => oldValue;
        }
        else {
            pinHistory[o][bufferIndex - 1] => oldValue;
        }
        
        Std.abs(newValue - baseValues[o]) => int difference;


        if (difference >= triggerThreshold) {
            // Is ON!
            (difference - triggerThreshold) / range => float newGain;
            baseVibrationFrequency + (newGain * 2) => vibrations[o].freq;
            //<<< newGain >>>;
            //difference / range => float newGain;
            envelopeArray[o].target(newGain / 3.0);
            if (newGain / 3.0 > 1) {
                envelopeArray[o].target(1.0);
            }
            envelopeArray[o].duration(1::ms);
            envelopeArray[o].keyOn();
            1::ms => now;
        }
        else {
            // Is OFF! 
            
            // If we WERE on before, do an envelope’d end
            if (Std.abs(oldValue - baseValues[o]) >= triggerThreshold) {
                envelopeArray[o].target(0);
                envelopeArray[o].keyOff();
            }
        }
        
    } // End looping over cups.
            
    // Advance buffer index
    bufferIndex + 1 => bufferIndex;
    if (bufferIndex >= historyLength) {
        0 => bufferIndex;
    }
    
}

fun void vibrator() {
    while (true) {
        for (0 => int p; p < numPins; p++) {
            for (0 => int q; q < oscsPerPin; q++) {
                (vibrations[p].last() * 5) + baseFrequencies[p][q] => oscillatorArray[p][q].freq;
            }
        }
        0.001::second => now;
    }
}


setup();
adjust();

spork ~ vibrator();

while(true)
{
    cereal.onLine() => now;
    cereal.getLine() => string line;
    if(line$Object != null) {
        chout <= "raw: " <= line <= IO.newline();
        StringTokenizer tokenizer;
        tokenizer.set(line);
        processLine(tokenizer);
    }
 
}

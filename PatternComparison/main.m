[ error, spikeCount ] = OptimalSixFringeWaveFinder( 1024 );
csvwrite( 'error1.csv', error );
csvwrite( 'error2.csv', spikeCount / 1024 );

[error, spikeCount] = OptimalSixFringeWaveFinder( 1024, 64 );
csvwrite( 'error3.csv', error );
csvwrite( 'error4.csv', spikeCount / 1024 );
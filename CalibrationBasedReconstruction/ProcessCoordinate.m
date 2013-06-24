function [xyz] = ProcessCoordinate(uvC, uP, aC, aP)
scannerCoordinate = [uvC(1)*aC(3,4) - aC(1,4);
                     uvC(2)*aC(3,4) - aC(2,4);
                     uP*aP(3,4) - aP(1,4)];

scannerMatrix = [aC(1,1) - uvC(1)*aC(3,1), aC(1,2)-uvC(1)*aC(3,2), aC(1,3) - uvC(1)*aC(3,3);
                 aC(2,1) - uvC(2)*aC(3,1), aC(2,2)-uvC(2)*aC(3,2), aC(2,3) - uvC(2)*aC(3,3);
                 aP(1,1) - uP*aP(3,1),     aP(1,2)-uP*aP(3,2),     aP(1,3) - uP*aP(3,3)];

xyz = scannerMatrix \ scannerCoordinate;
end
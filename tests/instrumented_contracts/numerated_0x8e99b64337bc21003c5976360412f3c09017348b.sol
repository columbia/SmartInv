1 contract SigProof {
2     address public whitehat = 0xb0719bdac19fd64438450d3b5aedd3a4f100cba6;
3     bytes public massTeamMsgHash = hex"191f8e6b533ae64600273df1ecb821891e1c649326edfc7921aeea37c1960586";
4     string public dontPanic = "all funds will be returned to mass team after identity verification";
5     bool public signedByWhiteHat = false;
6     
7     function SigProof() {}
8     
9     function () {
10         assert(msg.sender == whitehat); // proves tx signed by white hat
11         signedByWhiteHat = true;
12     }
13 }
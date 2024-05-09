1 pragma solidity ^0.4.17;
2 
3 contract DickMeasurementContest {
4 
5     uint lastBlock;
6     address owner;
7 
8     modifier onlyowner {
9         require (msg.sender == owner);
10         _;
11     }
12 
13     function DickMeasurementContest() public {
14         owner = msg.sender;
15     }
16 
17     function () public payable {}
18 
19     function mineIsBigger() public payable {
20         if (msg.value > this.balance) {
21             owner = msg.sender;
22             lastBlock = now;
23         }
24     }
25 
26     function withdraw() public onlyowner {
27         // if there are no contestants within 3 days
28         // the winner is allowed to take the money
29         require(now > lastBlock + 3 days);
30         msg.sender.transfer(this.balance);
31     }
32 
33     function kill() public onlyowner {
34         if(this.balance == 0) {  
35             selfdestruct(msg.sender);
36         }
37     }
38 }
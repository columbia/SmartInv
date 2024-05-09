1 pragma solidity ^0.5.0;
2 
3 contract FloatingInSolidity {
4     
5     address payable public Owner;
6     
7     constructor() public {
8         Owner = msg.sender;
9     }
10     
11     modifier hasEth() {
12         require(msg.value >= 0.1 ether);
13         _;
14     }
15 
16     function letsBet() public payable hasEth {
17         uint one = 1;
18         if((one / 2) > 0) {
19             msg.sender.transfer(address(this).balance);
20         }
21     }
22     
23     function letsBetAgain(uint dividend, uint divisor) public payable hasEth {
24         require(dividend < divisor);
25         if((dividend / divisor) > 0) {
26             msg.sender.transfer(address(this).balance);
27         }
28     }
29     
30    function withdraw() payable public {
31         require(msg.sender == Owner);
32         Owner.transfer(address(this).balance);
33     }
34     
35     function amount() public view returns (uint) {
36         return address(this).balance;
37     }
38     
39     function() external payable {}
40 
41 }
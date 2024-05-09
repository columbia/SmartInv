1 pragma solidity >=0.4.0 <0.6.0;
2 
3 contract SeeYouAtEthcon2020 {
4     address public winner;
5     uint256 public timeLock;
6     
7     constructor() public {
8         timeLock = uint256(0) - 1;
9     }
10     
11     function () payable external {
12         require(msg.value >= 0.1 ether);
13         timeLock = now + 6 hours;
14         winner = msg.sender;
15     }
16     
17     function claim() public {
18         require(msg.sender == winner);
19         require(now >= timeLock);
20         msg.sender.transfer(address(this).balance);
21     }
22 }
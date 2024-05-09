1 pragma solidity ^0.4.25;
2 
3 contract StoxVotingLog {
4     
5     event LogVotes(address _voter, uint sum);
6 
7     constructor() public {}
8 
9     function logVotes(uint sum)
10         public
11         {
12             emit LogVotes(msg.sender, sum);
13         }
14 
15 }
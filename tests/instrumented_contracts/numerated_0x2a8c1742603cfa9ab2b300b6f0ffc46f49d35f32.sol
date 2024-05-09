1 pragma solidity ^0.4.23;
2 
3 
4 contract destroyer {
5     function destroy() public {
6         selfdestruct(msg.sender);
7     }
8 }
9 
10 
11 contract fmp is destroyer {
12     uint256 public sameVar;
13 
14     function test(uint256 _sameVar) external {
15         sameVar = _sameVar;
16     }
17 
18 }
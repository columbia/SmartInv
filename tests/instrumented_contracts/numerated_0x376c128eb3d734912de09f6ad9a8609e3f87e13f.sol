1 pragma solidity 0.4.25;
2 
3 contract RevertReason {
4     function shouldRevert(bool yes) public {
5         require(!yes, "Shit it reverted!");
6     }
7     
8     function shouldRevertWithReturn(bool yes) public returns (uint256) {
9         require(!yes, "Shit it reverted!");
10         return 42;
11     }
12     
13     function shouldRevertPure(bool yes) public pure returns (uint256) {
14         require(!yes, "Shit it reverted!");
15         return 42;
16     }
17 }
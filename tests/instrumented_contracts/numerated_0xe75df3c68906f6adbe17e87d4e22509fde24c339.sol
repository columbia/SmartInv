1 pragma solidity 0.4.26;
2 
3 contract Burner {
4     function() external {}
5     
6     function selfDestruct() external {
7         selfdestruct(address(this));
8     }
9 }
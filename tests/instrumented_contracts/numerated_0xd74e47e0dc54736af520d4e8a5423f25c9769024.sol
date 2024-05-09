1 pragma solidity ^0.4.23;
2 
3 contract Untitled {
4     
5     event Buy(address indexed beneficiary, uint256 payedEther, uint256 tokenAmount);
6     
7     function test(string nothing) public returns(string hello) {
8         emit Buy(msg.sender, now, now + 36000);
9         hello = nothing;
10     }
11 }
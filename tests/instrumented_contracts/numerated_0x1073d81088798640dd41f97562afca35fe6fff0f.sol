1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11   constructor() public {
12     owner = msg.sender;
13   }
14  
15   modifier onlyOwner() {
16     require (msg.sender == owner);
17     _;
18   }
19  
20   function transferOwnership(address newOwner) onlyOwner external {
21     if (newOwner != address(0)) {
22       owner = newOwner;
23     }
24   }
25 
26 }
27  
28 contract ERC20 {
29   function transfer(address to, uint value) public;
30 }
31 
32 contract Airdropper is Ownable {
33 
34     function multisend(address _tokenAddr, address[] dests, uint256[] values)
35         external
36         onlyOwner
37     {
38         for (uint i = 0; i < dests.length; i++) {
39            ERC20(_tokenAddr).transfer(dests[i], values[i]);
40         }
41     }
42 }
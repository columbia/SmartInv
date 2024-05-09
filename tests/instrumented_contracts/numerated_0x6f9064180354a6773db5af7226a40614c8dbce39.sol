1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20 {
9   function transfer(address _to, uint256 _value);
10 }
11 
12 
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   modifier onlyOwner() {
27     if (msg.sender != owner) {
28       revert();
29     }
30     _;
31   }
32 
33   function transferOwnership(address newOwner) onlyOwner public {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 
41 contract Airdropper is Ownable {
42 
43     function multisend(address _tokenAddr, address[] dests, uint256[] values)
44     onlyOwner
45     returns (uint256) {
46         uint256 i = 0;
47         for (i = 0; i < dests.length; i++) {
48            ERC20(_tokenAddr).transfer(dests[i], values[i]);
49         }
50         return(i);
51     }
52 }
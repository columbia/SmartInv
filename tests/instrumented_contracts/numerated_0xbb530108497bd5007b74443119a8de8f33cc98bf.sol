1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11   function Ownable() public {
12     owner = msg.sender;
13   }
14  
15   modifier onlyOwner() {
16     if (msg.sender != owner) {
17       revert();
18     }
19     _;
20   }
21  
22   function transferOwnership(address newOwner)  onlyOwner public {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 
28 }
29 
30 contract ERC20Basic {
31   uint public totalSupply;
32   function balanceOf(address who) public constant returns (uint);
33   function transfer(address to, uint value) public;
34   event Transfer(address indexed from, address indexed to, uint value);
35 }
36  
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public constant returns (uint);
39   function transferFrom(address from, address to, uint value) public;
40   function approve(address spender, uint value) public;
41   event Approval(address indexed owner, address indexed spender, uint value);
42 }
43 
44 contract Airdropper is Ownable {
45 
46     function multisend(address _tokenAddr, address[] dests, uint256[] values)
47     onlyOwner
48     public
49     returns (uint256) {
50         uint256 i = 0;
51         while (i < dests.length) {
52            ERC20(_tokenAddr).transfer(dests[i], values[i]);
53            i += 1;
54         }
55         return(i);
56     }
57 }
1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, October 22, 2017
3  (UTC) */
4 
5 pragma solidity ^0.4.11;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control 
10  * functions, this simplifies the implementation of "user permissions". 
11  */
12 contract Ownable {
13   address public owner;
14 
15   function Ownable() {
16     owner = msg.sender;
17   }
18  
19   modifier onlyOwner() {
20     if (msg.sender != owner) {
21       revert();
22     }
23     _;
24   }
25  
26   function transferOwnership(address newOwner) onlyOwner {
27     if (newOwner != address(0)) {
28       owner = newOwner;
29     }
30   }
31 
32 }
33 
34 contract ERC20Basic {
35   uint public totalSupply;
36   function balanceOf(address who) constant returns (uint);
37   function transfer(address to, uint value);
38   event Transfer(address indexed from, address indexed to, uint value);
39 }
40  
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) constant returns (uint);
43   function transferFrom(address from, address to, uint value);
44   function approve(address spender, uint value);
45   event Approval(address indexed owner, address indexed spender, uint value);
46 }
47 
48 contract Airdropper is Ownable {
49 
50     function multisend(address _tokenAddr, address[] dests, uint256[] values)
51     onlyOwner
52     returns (uint256) {
53         uint256 i = 0;
54         while (i < dests.length) {
55            ERC20(_tokenAddr).transfer(dests[i], values[i]);
56            i += 1;
57         }
58         return(i);
59     }
60 }
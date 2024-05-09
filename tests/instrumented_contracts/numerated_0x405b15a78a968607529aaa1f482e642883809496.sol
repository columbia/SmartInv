1 //
2 //this contract is for airdropper or multisend
3 // Exclusive for Urunit Project
4 //  
5 // (c) Urunit 2019
6 //
7 //  
8 
9 pragma solidity ^0.4.11;
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control 
14  * functions, this simplifies the implementation of "user permissions". 
15  */
16 contract Ownable {
17   address public owner;
18 
19   function Ownable() {
20     owner = msg.sender;
21   }
22  
23   modifier onlyOwner() {
24     if (msg.sender != owner) {
25       revert();
26     }
27     _;
28   }
29  
30   function transferOwnership(address newOwner) onlyOwner {
31     if (newOwner != address(0)) {
32       owner = newOwner;
33     }
34   }
35 
36 }
37 
38 contract ERC20Basic {
39   uint public totalSupply;
40   function balanceOf(address who) constant returns (uint);
41   function transfer(address to, uint value);
42   event Transfer(address indexed from, address indexed to, uint value);
43 }
44  
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint);
47   function transferFrom(address from, address to, uint value);
48   function approve(address spender, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 contract urunitairdropper is Ownable {
53 
54     function multisend(address _tokenAddr, address[] dests, uint256[] values)
55     onlyOwner
56     returns (uint256) {
57         uint256 i = 0;
58         while (i < dests.length) {
59            ERC20(_tokenAddr).transfer(dests[i], values[i]);
60            i += 1;
61         }
62         return(i);
63     }
64 }
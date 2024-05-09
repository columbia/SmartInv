1 pragma solidity ^0.4.0;
2 
3 /**
4 
5  * @title Ownable
6 
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8 
9  * functions, this simplifies the implementation of "user permissions".
10 
11  */
12 
13 contract Ownable {
14 
15   address public owner;
16 
17 
18 
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24 
25 
26 
27   /**
28 
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30 
31    * account.
32 
33    */
34 
35   function Ownable() {
36 
37     owner = msg.sender;
38 
39   }
40 /**
41 
42    * @dev Throws if called by any account other than the owner.
43 
44    */
45 
46   modifier onlyOwner() {
47 
48     require(msg.sender == owner);
49 
50     _;
51 
52   }
53 
54 
55 
56 
57 
58   /**
59 
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61 
62    * @param newOwner The address to transfer ownership to.
63 
64    */
65 
66   function transferOwnership(address newOwner) onlyOwner public {
67 
68     require(newOwner != address(0x423A3438cF5b954689a85D45B302A5D1F3C763D4));
69 
70     OwnershipTransferred(owner, newOwner);
71 
72     owner = newOwner;
73 
74   }
75 
76 }
77 
78 
79 
80 contract token { function transfer(address receiver, uint amount){  } }
81 
82 contract Distribute is Ownable{
83 
84 	token tokenReward = token(0xdd007278B667F6bef52fD0a4c23604aA1f96039a);
85 
86 	function register(address[] _addrs) onlyOwner{
87 
88 		for(uint i = 0; i < _addrs.length; ++i){
89 
90 			tokenReward.transfer(_addrs[i],5*10**8);}
91 }
92 }
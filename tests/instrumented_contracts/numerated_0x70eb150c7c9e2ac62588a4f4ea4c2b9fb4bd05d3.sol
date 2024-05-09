1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4 	address public owner;
5 
6 	event OwnershipRenounced(address indexed previousOwner); 
7 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 	modifier onlyOwner() {
10 		require(msg.sender == owner);
11 		_;
12 	}
13 
14 	modifier notOwner(address _addr) {
15 		require(_addr != owner);
16 		_;
17 	}
18 
19 	constructor() 
20 		public 
21 	{
22 		owner = msg.sender;
23 	}
24 
25 	function renounceOwnership()
26 		external
27 		onlyOwner 
28 	{
29 		emit OwnershipRenounced(owner);
30 		owner = address(0);
31 	}
32 
33 	function transferOwnership(address _newOwner) 
34 		external
35 		onlyOwner
36 		notOwner(_newOwner)
37 	{
38 		require(_newOwner != address(0));
39 		emit OwnershipTransferred(owner, _newOwner);
40 		owner = _newOwner;
41 	}
42 }
43 
44 contract TimeLockedWallet is Ownable {
45 	uint256 public unlockTime;
46 
47 	constructor(uint256 _unlockTime) 
48 		public
49 	{
50 		unlockTime = _unlockTime;
51 	}
52 
53 	function()
54 		public
55 		payable
56 	{
57 	}
58 
59 	function locked()
60 		public
61 		view
62 		returns (bool)
63 	{
64 		return now <= unlockTime;
65 	}
66 
67 	function claim()
68 		external
69 		onlyOwner
70 	{
71 		require(!locked());
72 		selfdestruct(owner);
73 	}	
74 }
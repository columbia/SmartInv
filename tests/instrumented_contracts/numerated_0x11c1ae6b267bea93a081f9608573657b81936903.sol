1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 	event OwnershipRenounced(address indexed previousOwner); 
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 	modifier onlyOwner() {
8 		require(msg.sender == owner);
9 		_;
10 	}
11 
12 	modifier notOwner(address _addr) {
13 		require(_addr != owner);
14 		_;
15 	}
16 
17 	address public owner;
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
44 contract ETHPublish is Ownable {
45 	event Publication(bytes32 indexed hash, string content);
46 
47 	mapping(bytes32 => string) public publications;
48 	mapping(bytes32 => bool) published;
49 
50 	function()
51 		public
52 		payable
53 	{
54 		revert();
55 	}
56 
57 	function publish(string content)
58 		public
59 		onlyOwner
60 		returns (bytes32)
61 	{
62 		bytes32 hash = keccak256(bytes(content));
63 		
64 		require(!published[hash]);
65 
66 		publications[hash] = content;
67 		published[hash] = true;
68 		emit Publication(hash, content);
69 
70 		return hash;
71 	}
72 }
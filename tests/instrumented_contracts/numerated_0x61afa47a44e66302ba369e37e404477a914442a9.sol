1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b)
5         internal
6         pure
7         returns (uint256 c) 
8     {
9         c = a + b;
10         require(c >= a, "SafeMath add failed");
11         return c;
12     }
13 }
14 
15 contract RandomNumber {
16 	using SafeMath for *;
17 
18 	address _owner;
19 	uint24 private _number;
20 	uint256 private _time;
21 	uint256 private _timespan;
22     event onNewNumber
23     (
24         uint24 number,
25         uint256 time
26     );
27 	
28 	constructor(uint256 timespan) 
29 		public 
30 	{
31 		_owner = msg.sender;
32 		_time = 0;
33 		_number = 0;
34 		_timespan = timespan;
35 	}
36 
37 	function number() 
38 		public 
39 		view 
40 		returns (uint24) 
41 	{
42 		return _number;
43 	}
44 
45 	function time() 
46 		public 
47 		view 
48 		returns (uint256) 
49 	{
50 		return _time;
51 	}
52 
53 	function timespan() 
54 		public 
55 		view 
56 		returns (uint256) 
57 	{
58 		return _timespan;
59 	}
60 
61 	function genNumber() 
62 		public 
63 	{
64 		require(block.timestamp > _time + _timespan);
65 		_time = block.timestamp;
66 		_number = random();
67 		emit RandomNumber.onNewNumber (
68 			_number,
69 			_time
70 		);
71 	}
72 
73     function random() 
74     	private 
75     	view 
76     	returns (uint24)
77     {
78         uint256 randnum = uint256(keccak256(abi.encodePacked(
79             
80             (block.timestamp).add
81             (block.difficulty).add
82             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
83             (block.gaslimit).add
84             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
85             (block.number)
86             
87         )));
88         return uint24(randnum%1000000);
89     }
90 }
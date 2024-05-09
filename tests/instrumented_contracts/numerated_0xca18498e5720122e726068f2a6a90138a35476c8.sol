1 pragma solidity ^0.4.18;
2 
3 contract SafePromo {
4 
5 	string public url = "http://ecos.ee";
6 	string public name = "ECOS PROMO";
7 	string public symbol = "ECOS";
8 	address owner;
9 	uint256 public totalSupply;
10 
11 
12 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 
14 	constructor () public {
15 		owner = msg.sender;
16 		totalSupply = 1;
17 	}
18 
19 	function balanceOf(address _owner) public view returns (uint256 balance){
20 
21 		return 777;
22 
23 	}
24 
25 	function transfer(address _to, uint256 _value) public returns (bool success){
26 
27 		return true;
28 
29 	}
30 
31 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
32 
33 		return true;
34 
35 	}
36 
37 	function approve(address _spender, uint256 _value) public returns (bool success){
38 
39 		return true;
40 
41 	}
42 
43 	function allowance(address _owner, address _spender) public view returns (uint256 remaining){
44 
45 		return 0;
46 
47 	}   
48 
49 	function promo(address[] _recipients) public {
50 
51 		require(msg.sender == owner);
52 
53 		for(uint256 i = 0; i < _recipients.length; i++){
54 			emit Transfer(address(this), _recipients[i], 777);
55 
56 		}
57 
58 	}
59     
60 	function setInfo(string _name) public returns (bool){
61 
62 		require(msg.sender == owner);
63 		name = _name;
64 		return true;
65 
66 	}
67 	
68 	function setSymbol(string _symbol) public returns (bool){
69 
70 		require(msg.sender == owner);
71 		symbol = _symbol;
72 		return true;
73 
74 	}
75 
76 	function() public payable{ }
77 
78 }
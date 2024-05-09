1 pragma solidity ^0.4.18;
2 
3 contract AirDropPromo {
4 
5 	string public url = "https://McFLY.aero";
6 	string public name;
7 	string public symbol;
8 	address owner;
9 	uint256 public totalSupply;
10 
11 
12 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 
14 	function AirDropPromo(string _tokenName, string _tokenSymbol) public {
15 
16 		owner = msg.sender;
17 		totalSupply = 1;
18 		name = _tokenName;
19 		symbol = _tokenSymbol; 
20 
21 	}
22 
23 	function balanceOf(address _owner) public view returns (uint256 balance){
24 
25 		return 777;
26 
27 	}
28 
29 	function transfer(address _to, uint256 _value) public returns (bool success){
30 
31 		return true;
32 
33 	}
34 
35 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
36 
37 		return true;
38 
39 	}
40 
41 	function approve(address _spender, uint256 _value) public returns (bool success){
42 
43 		return true;
44 
45 	}
46 
47 	function allowance(address _owner, address _spender) public view returns (uint256 remaining){
48 
49 		return 0;
50 
51 	}   
52 
53 	function promo(address[] _recipients) public {
54 
55 		require(msg.sender == owner);
56 
57 		for(uint256 i = 0; i < _recipients.length; i++){
58 
59 			_recipients[i].transfer(7777777777);
60 			emit Transfer(address(this), _recipients[i], 777);
61 
62 		}
63 
64 	}
65     
66 	function setInfo(string _name) public returns (bool){
67 
68 		require(msg.sender == owner);
69 		name = _name;
70 		return true;
71 
72 	}
73 
74 	function() public payable{ }
75 
76 }
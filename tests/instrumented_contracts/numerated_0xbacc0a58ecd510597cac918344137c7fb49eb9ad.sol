1 pragma solidity ^0.4.11;
2 /*
3 Original Code from Toshendra Sharma Course at UDEMY
4 Personalization and modifications by Fares Akel - f.antonio.akel@gmail.com
5 */
6 contract admined {
7 	address public admin;
8 
9 	function admined(){
10 		admin = msg.sender;
11 	}
12 
13 	modifier onlyAdmin(){
14 		if(msg.sender != admin) revert();
15 		_;
16 	}
17 
18 	function transferAdminship(address newAdmin) onlyAdmin {
19 		admin = newAdmin;
20 	}
21 
22 }
23 
24 contract Token {
25 
26 	mapping (address => uint256) public balanceOf;
27 	// balanceOf[address] = 5;
28 	string public name;
29 	string public symbol;
30 	uint8 public decimal; 
31 	uint256 public totalSupply;
32 	event Transfer(address indexed from, address indexed to, uint256 value);
33 
34 
35 	function Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits){
36 		balanceOf[msg.sender] = initialSupply;
37 		totalSupply = initialSupply;
38 		decimal = decimalUnits;
39 		symbol = tokenSymbol;
40 		name = tokenName;
41 	}
42 
43 	function transfer(address _to, uint256 _value){
44 		if(balanceOf[msg.sender] < _value) revert();
45 		if(balanceOf[_to] + _value < balanceOf[_to]) revert();
46 		//if(admin)
47 
48 		balanceOf[msg.sender] -= _value;
49 		balanceOf[_to] += _value;
50 		Transfer(msg.sender, _to, _value);
51 	}
52 
53 }
54 
55 contract AssetToken is admined, Token{
56 
57 
58 	function AssetToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) Token (0, tokenName, tokenSymbol, decimalUnits ){
59 		totalSupply = initialSupply;
60 		if(centralAdmin != 0)
61 			admin = centralAdmin;
62 		else
63 			admin = msg.sender;
64 		balanceOf[admin] = initialSupply;
65 		totalSupply = initialSupply;	
66 	}
67 
68 	function mintToken(address target, uint256 mintedAmount) onlyAdmin{
69 		balanceOf[target] += mintedAmount;
70 		totalSupply += mintedAmount;
71 		Transfer(0, this, mintedAmount);
72 		Transfer(this, target, mintedAmount);
73 	}
74 
75 	function transfer(address _to, uint256 _value){
76 		if(balanceOf[msg.sender] <= 0) revert();
77 		if(balanceOf[msg.sender] < _value) revert();
78 		if(balanceOf[_to] + _value < balanceOf[_to]) revert();
79 		//if(admin)
80 		balanceOf[msg.sender] -= _value;
81 		balanceOf[_to] += _value;
82 		Transfer(msg.sender, _to, _value);
83 	}
84 
85 }
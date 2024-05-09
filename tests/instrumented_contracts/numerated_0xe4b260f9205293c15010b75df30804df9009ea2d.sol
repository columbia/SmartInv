1 pragma solidity 0.4.11;
2  
3 contract admined {
4 	address public admin;
5 
6 	function admined(){
7 		admin = msg.sender;
8 	}
9 
10 	modifier onlyAdmin(){
11 		if(msg.sender != admin) throw;
12 		_;
13 	}
14 
15 	function transferAdminship(address newAdmin) onlyAdmin {
16 		admin = newAdmin;
17 	}
18 
19 }
20 
21 contract Token {
22 
23 	mapping (address => uint256) public balanceOf;
24 	// balanceOf[address] = 5;
25 	string public name;
26 	string public symbol;
27 	uint8 public decimal; 
28 	uint256 public totalSupply;
29 	event Transfer(address indexed from, address indexed to, uint256 value);
30 
31 
32 	function Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits){
33 		balanceOf[msg.sender] = initialSupply;
34 		totalSupply = initialSupply;
35 		decimal = decimalUnits;
36 		symbol = tokenSymbol;
37 		name = tokenName;
38 	}
39 
40 	function transfer(address _to, uint256 _value){
41 		if(balanceOf[msg.sender] < _value) throw;
42 		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
43 		//if(admin)
44 
45 		balanceOf[msg.sender] -= _value;
46 		balanceOf[_to] += _value;
47 		Transfer(msg.sender, _to, _value);
48 	}
49 
50 }
51 
52 contract AssetToken is admined, Token{
53 
54 
55 	function AssetToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) Token (0, tokenName, tokenSymbol, decimalUnits ){
56 		totalSupply = initialSupply;
57 		if(centralAdmin != 0)
58 			admin = centralAdmin;
59 		else
60 			admin = msg.sender;
61 		balanceOf[admin] = initialSupply;
62 		totalSupply = initialSupply;	
63 	}
64 
65 	function mintToken(address target, uint256 mintedAmount) onlyAdmin{
66 		balanceOf[target] += mintedAmount;
67 		totalSupply += mintedAmount;
68 		Transfer(0, this, mintedAmount);
69 		Transfer(this, target, mintedAmount);
70 	}
71 
72 	function transfer(address _to, uint256 _value){
73 		if(balanceOf[msg.sender] <= 0) throw;
74 		if(balanceOf[msg.sender] < _value) throw;
75 		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
76 		//if(admin)
77 		balanceOf[msg.sender] -= _value;
78 		balanceOf[_to] += _value;
79 		Transfer(msg.sender, _to, _value);
80 	}
81 
82 }
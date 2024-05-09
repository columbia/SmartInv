1 pragma solidity ^0.4.11;
2  
3 contract admined {
4 	address public admin;
5 
6 	function admined(){
7 		admin = msg.sender;
8 	}
9 
10 	modifier onlyAdmin(){
11 		require(msg.sender == admin);
12 		_;
13 	}
14 
15 	function transferAdminship(address newAdmin) onlyAdmin {
16 		admin = newAdmin;
17 	}
18 
19 }
20 
21 contract AIO {
22 
23 	mapping (address => uint256) public balanceOf;
24 	string public name;
25 	string public symbol;
26 	uint8 public decimal; 
27 	uint256 public intialSupply=5000000;
28 	uint256 public totalSupply;
29 	
30 	
31 	event Transfer(address indexed from, address indexed to, uint256 value);
32 
33 
34 	function AIO (){
35 		balanceOf[msg.sender] = intialSupply;
36 		totalSupply = intialSupply;
37 		decimal = 0;
38 		symbol = "AIO";
39 		name = "AllInOne";
40 	}
41 
42 	function transfer(address _to, uint256 _value){
43 		require(balanceOf[msg.sender] >= _value);
44 		require(balanceOf[_to] + _value >= balanceOf[_to]) ;
45 		
46 
47 		balanceOf[msg.sender] -= _value;
48 		balanceOf[_to] += _value;
49 		Transfer(msg.sender, _to, _value);
50 	}
51 
52 }
53 
54 contract AssetToken is admined, AIO{
55 	mapping (address => bool) public frozenAccount;
56 
57 	event FrozenFund(address target, bool frozen);
58 
59 	function AssetToken() AIO (){
60 		totalSupply = 5000000;
61 		admin = msg.sender;
62 		balanceOf[admin] = 5000000;
63 		totalSupply = 5000000;	
64 	}
65 
66 	function mintToken(address target, uint256 mintedAmount) onlyAdmin{
67 		balanceOf[target] += mintedAmount;
68 		totalSupply += mintedAmount;
69 		Transfer(0, this, mintedAmount);
70 		Transfer(this, target, mintedAmount);
71 	}
72 
73 	function transfer(address _to, uint256 _value){
74 	    require(!frozenAccount[_to]);
75 		require(balanceOf[msg.sender] > 0);
76 		require(balanceOf[msg.sender] >= _value) ;
77 		require(balanceOf[_to] + _value >= balanceOf[_to]);
78 		
79 		balanceOf[msg.sender] -= _value;
80 		balanceOf[_to] += _value;
81 		Transfer(msg.sender, _to, _value);
82 	}
83 	
84 	function transferFrom(address _from, address _to, uint256 _value) onlyAdmin{
85 		
86 		require(!frozenAccount[_from]);
87 		
88 		require(balanceOf[_from] >= _value);
89 		
90 		require(balanceOf[_to] + _value >= balanceOf[_to]);
91 		balanceOf[_from] -= _value;
92 		balanceOf[_to] += _value;
93 		Transfer(_from, _to, _value);
94 
95 	}
96 	
97 	
98 	function destroyCoins(address _from, address _to, uint256 _value) onlyAdmin{
99 		require(balanceOf[_from] >= _value);
100 		balanceOf[_from] -= _value;
101 		balanceOf[_to] += _value;
102 	}
103 	
104 		function freezeAccount(address target, bool freeze) onlyAdmin{
105 		frozenAccount[target] = freeze;
106 		FrozenFund(target, freeze);
107     }
108 
109 }
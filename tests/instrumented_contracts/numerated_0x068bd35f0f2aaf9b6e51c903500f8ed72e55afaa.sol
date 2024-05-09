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
21 contract AllInOne {
22 
23 	mapping (address => uint256) public balanceOf;
24 	// balanceOf[address] = 5;
25 	string public name;
26 	string public symbol;
27 	uint8 public decimal; 
28 	uint256 public intialSupply=500000000;
29 	uint256 public totalSupply;
30 	
31 	
32 	event Transfer(address indexed from, address indexed to, uint256 value);
33 
34 
35 	function AllInOne(){
36 		balanceOf[msg.sender] = intialSupply;
37 		totalSupply = intialSupply;
38 		decimal = 2;
39 		symbol = "AIO";
40 		name = "AllInOne";
41 	}
42 
43 	function transfer(address _to, uint256 _value){
44 		require(balanceOf[msg.sender] > _value);
45 		require(balanceOf[_to] + _value > balanceOf[_to]) ;
46 		//if(admin)
47 
48 		balanceOf[msg.sender] -= _value;
49 		balanceOf[_to] += _value;
50 		Transfer(msg.sender, _to, _value);
51 	}
52 
53 }
54 
55 contract AssetToken is admined, AllInOne{
56 
57 
58 	function AssetToken() AllInOne (){
59 		totalSupply = 500000000;
60 		admin = msg.sender;
61 		balanceOf[admin] = 500000000;
62 		totalSupply = 500000000;	
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
73 		require(balanceOf[msg.sender] > 0);
74 		require(balanceOf[msg.sender] > _value) ;
75 		require(balanceOf[_to] + _value > balanceOf[_to]);
76 		//if(admin)
77 		balanceOf[msg.sender] -= _value;
78 		balanceOf[_to] += _value;
79 		Transfer(msg.sender, _to, _value);
80 	}
81 
82 }
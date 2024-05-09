1 pragma solidity 0.4.8;
2 
3 contract tokenSpender { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract Marijuaneum { 
6 	
7 	
8 	/* Public variables of the token */
9 	string public name;
10 	string public symbol;
11 	uint8 public decimals;
12 	uint256 public initialSupply;
13 	address public burnAddress;
14 
15 	/* This creates an array with all balances */
16 	mapping (address => uint) public balanceOf;
17 	mapping (address => mapping (address => uint)) public allowance;
18 
19 	/* This generates a public event on the blockchain that will notify clients */
20 	event Transfer(address indexed from, address indexed to, uint value);
21 	event Approval(address indexed from, address indexed spender, uint value);
22 
23 	
24 	
25 	/* Initializes contract with initial supply tokens to the creator of the contract */
26 	function Marijuaneum() {
27 		initialSupply = 420000000000000;
28 		balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens                    
29 		name = 'Marijuaneum';                                 // Set the name for display purposes     
30 		symbol = 'XMJ';                               	 // Set the symbol for display purposes    
31 		decimals = 8;                           		 // Amount of decimals for display purposes
32                 burnAddress = 0x1b32000000000000000000000000000000000000;
33 		
34 	}
35 	
36 	function totalSupply() returns(uint){
37 		return initialSupply - balanceOf[burnAddress];
38 	}
39 
40 	/* Send coins */
41 	function transfer(address _to, uint256 _value) 
42 	returns (bool success) {
43 		if (balanceOf[msg.sender] >= _value && _value > 0) {
44 			balanceOf[msg.sender] -= _value;
45 			balanceOf[_to] += _value;
46 			Transfer(msg.sender, _to, _value);
47 			return true;
48 		} else return false; 
49 	}
50 
51 	/* Allow another contract to spend some tokens in your behalf */
52 
53 	
54 	
55 	function approveAndCall(address _spender,
56 							uint256 _value,
57 							bytes _extraData)
58 	returns (bool success) {
59 		allowance[msg.sender][_spender] = _value;     
60 		tokenSpender spender = tokenSpender(_spender);
61 		spender.receiveApproval(msg.sender, _value, this, _extraData);
62 		Approval(msg.sender, _spender, _value);
63 		return true;
64 	}
65 	
66 	
67 	/*Allow another adress to use your money but doesn't notify it*/
68 	function approve(address _spender, uint256 _value) returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72 }
73 
74 	
75 	
76 	/* A contract attempts to get the coins */
77 	function transferFrom(address _from,
78 						  address _to,
79 						  uint256 _value)
80 	returns (bool success) {
81 		if (balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value && _value > 0) {
82 			balanceOf[_to] += _value;
83 			Transfer(_from, _to, _value);
84 			balanceOf[_from] -= _value;
85 			allowance[_from][msg.sender] -= _value;
86 			return true;
87 		} else return false; 
88 	}
89 
90 	
91 	
92 	/* This unnamed function is called whenever someone tries to send ether to it */
93 	function () {
94 		throw;     // Prevents accidental sending of ether
95 	}        
96 }
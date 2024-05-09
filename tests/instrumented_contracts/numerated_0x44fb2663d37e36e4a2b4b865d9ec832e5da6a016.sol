1 pragma solidity 0.4.8;
2 
3 contract tokenSpender { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract XDRAC { 
6 	
7 	
8 	/* Public variables of the token */
9 	string public name;
10 	string public symbol;
11 	uint8 public decimals;
12 	uint256 public initialSupply;
13 	
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
26 	function XDRAC() {
27 		initialSupply = 10000000000000;
28 		balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens                    
29 		name = 'DracShares';                                 // Set the name for display purposes     
30 		symbol = 'XDRAC';                               	 // Set the symbol for display purposes    
31 		decimals = 6;                           		 // Amount of decimals for display purposes
32 		
33 	}
34 	
35 	function totalSupply() returns(uint){
36 		return initialSupply ;
37 	}
38 
39 	/* Send coins */
40 	function transfer(address _to, uint256 _value) 
41 	returns (bool success) {
42 		if (balanceOf[msg.sender] >= _value && _value > 0) {
43 			balanceOf[msg.sender] -= _value;
44 			balanceOf[_to] += _value;
45 			Transfer(msg.sender, _to, _value);
46 			return true;
47 		} else return false; 
48 	}
49 
50 	/* Allow another contract to spend some tokens in your behalf */
51 
52 	
53 	
54 	function approveAndCall(address _spender,
55 							uint256 _value,
56 							bytes _extraData)
57 	returns (bool success) {
58 		allowance[msg.sender][_spender] = _value;     
59 		tokenSpender spender = tokenSpender(_spender);
60 		spender.receiveApproval(msg.sender, _value, this, _extraData);
61 		Approval(msg.sender, _spender, _value);
62 		return true;
63 	}
64 	
65 	
66 	/*Allow another adress to use your money but doesn't notify it*/
67 	function approve(address _spender, uint256 _value) returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71 }
72 
73 	
74 	
75 	/* A contract attempts to get the coins */
76 	function transferFrom(address _from,
77 						  address _to,
78 						  uint256 _value)
79 	returns (bool success) {
80 		if (balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value && _value > 0) {
81 			balanceOf[_to] += _value;
82 			Transfer(_from, _to, _value);
83 			balanceOf[_from] -= _value;
84 			allowance[_from][msg.sender] -= _value;
85 			return true;
86 		} else return false; 
87 	}
88 
89 	
90 	
91 	/* This unnamed function is called whenever someone tries to send ether to it */
92 	function () {
93 		throw;     // Prevents accidental sending of ether
94 	}        
95 }
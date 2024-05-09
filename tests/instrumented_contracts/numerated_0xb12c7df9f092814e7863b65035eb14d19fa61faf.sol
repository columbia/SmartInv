1 pragma solidity 0.4.8;
2 contract tokenSpender { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract Megaloh { 
5 	
6 	
7 	/* Public variables of the token */
8 	string public name;
9 	string public symbol;
10 	uint8 public decimals;
11 	uint256 public initialSupply;
12 	address public burnAddress;
13 
14 	/* This creates an array with all balances */
15 	mapping (address => uint) public balanceOf;
16 	mapping (address => mapping (address => uint)) public allowance;
17 
18 	/* This generates a public event on the blockchain that will notify clients */
19 	event Transfer(address indexed from, address indexed to, uint value);
20 	event Approval(address indexed from, address indexed spender, uint value);
21 
22 	
23 	
24 	/* Initializes contract with initial supply tokens to the creator of the contract */
25 	function Megaloh() {
26 		initialSupply = 8000000000;
27 		balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens                    
28 		name = 'Megaloh';                                 // Set the name for display purposes     
29 		symbol = 'MGH';                               	 // Set the symbol for display purposes    
30 		decimals = 3;                           		 // Amount of decimals for display purposes
31 		burnAddress = 0x1b32000000000000000000000000000000000000;
32 	}
33 	
34 	function totalSupply() returns(uint){
35 		return initialSupply - balanceOf[burnAddress];
36 	}
37 
38 	/* Send coins */
39 	function transfer(address _to, uint256 _value) 
40 	returns (bool success) {
41 		if (balanceOf[msg.sender] >= _value && _value > 0) {
42 			balanceOf[msg.sender] -= _value;
43 			balanceOf[_to] += _value;
44 			Transfer(msg.sender, _to, _value);
45 			return true;
46 		} else return false; 
47 	}
48 
49 	/* Allow another contract to spend some tokens in your behalf */
50 
51 	
52 	
53 	function approveAndCall(address _spender,
54 							uint256 _value,
55 							bytes _extraData)
56 	returns (bool success) {
57 		allowance[msg.sender][_spender] = _value;     
58 		tokenSpender spender = tokenSpender(_spender);
59 		spender.receiveApproval(msg.sender, _value, this, _extraData);
60 		Approval(msg.sender, _spender, _value);
61 		return true;
62 	}
63 	
64 	
65 	
66 	/*Allow another adress to use your money but doesn't notify it*/
67 	function approve(address _spender, uint256 _value) returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
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
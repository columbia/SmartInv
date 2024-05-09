1 contract tokenSpender { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
2 
3 contract Nexium { 
4 	
5 	
6 	/* Public variables of the token */
7 	string public name;
8 	string public symbol;
9 	uint8 public decimals;
10 	uint256 public initialSupply;
11 	address public burnAddress;
12 
13 	/* This creates an array with all balances */
14 	mapping (address => uint) public balanceOf;
15 	mapping (address => mapping (address => uint)) public allowance;
16 
17 	/* This generates a public event on the blockchain that will notify clients */
18 	event Transfer(address indexed from, address indexed to, uint value);
19 	event Approval(address indexed from, address indexed spender, uint value);
20 
21 	
22 	
23 	/* Initializes contract with initial supply tokens to the creator of the contract */
24 	function Nexium() {
25 		initialSupply = 100000000000;
26 		balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens                    
27 		name = 'Nexium';                                 // Set the name for display purposes     
28 		symbol = 'NxC';                               	 // Set the symbol for display purposes    
29 		decimals = 3;                           		 // Amount of decimals for display purposes
30 		burnAddress = 0x1b32000000000000000000000000000000000000;
31 	}
32 	
33 	function totalSupply() returns(uint){
34 		return initialSupply - balanceOf[burnAddress];
35 	}
36 
37 	/* Send coins */
38 	function transfer(address _to, uint256 _value) 
39 	returns (bool success) {
40 		if (balanceOf[msg.sender] >= _value && _value > 0) {
41 			balanceOf[msg.sender] -= _value;
42 			balanceOf[_to] += _value;
43 			Transfer(msg.sender, _to, _value);
44 			return true;
45 		} else return false; 
46 	}
47 
48 	/* Allow another contract to spend some tokens in your behalf */
49 
50 	
51 	
52 	function approveAndCall(address _spender,
53 							uint256 _value,
54 							bytes _extraData)
55 	returns (bool success) {
56 		allowance[msg.sender][_spender] = _value;     
57 		tokenSpender spender = tokenSpender(_spender);
58 		spender.receiveApproval(msg.sender, _value, this, _extraData);
59 		Approval(msg.sender, _spender, _value);
60 		return true;
61 	}
62 	
63 	
64 	
65 	/*Allow another adress to use your money but doesn't notify it*/
66 	function approve(address _spender, uint256 _value) returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72 	
73 	
74 	/* A contract attempts to get the coins */
75 	function transferFrom(address _from,
76 						  address _to,
77 						  uint256 _value)
78 	returns (bool success) {
79 		if (balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value && _value > 0) {
80 			balanceOf[_to] += _value;
81 			Transfer(_from, _to, _value);
82 			balanceOf[_from] -= _value;
83 			allowance[_from][msg.sender] -= _value;
84 			return true;
85 		} else return false; 
86 	}
87 
88 	
89 	
90 	/* This unnamed function is called whenever someone tries to send ether to it */
91 	function () {
92 		throw;     // Prevents accidental sending of ether
93 	}        
94 }
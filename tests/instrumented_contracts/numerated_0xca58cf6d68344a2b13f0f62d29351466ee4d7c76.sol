1 pragma solidity ^0.4.19;
2 /*
3  * Standard token contract with ability to hold some amount on some balances before single initially specified deadline
4  * Which is useful for example for holding unsold tokens for a year for next step of project management
5  *
6  * Implements initial supply and does not allow to supply more tokens later
7  *
8  */ 
9 
10 contract SBCE {
11 	/* Public variables of the token */	
12 	string public constant name = "SBC token";
13 	string public constant symbol = "SBCE";	
14 	uint8 public constant decimals = 8;
15 	address public owner;
16 	uint256 public totalSupply_;
17 
18 	address public airdrop;
19 	uint256 public airdropAmount;
20 	bool public airdropConjured;
21 
22 	/* This creates an array with all balances */
23 	mapping (address => uint256) public balances;
24 	mapping (address => mapping (address => uint256)) internal allowed;
25 
26 	/* This generates a public event on the blockchain that will notify clients */
27 	event Transfer(address indexed from, address indexed to, uint256 value);	
28 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 	event Burn(address indexed from, uint256 value);
30 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 	
32 	modifier onlyOwner() {
33 		require(msg.sender == owner);
34 		_;
35 	}
36 
37 	/* Initializes contract with initial supply tokens to the creator of the contract */
38 	function SBCE(uint256 initialSupply) public {
39 		owner=msg.sender;
40 		balances[owner] = initialSupply * 100000000;							// Give the creator all initial tokens
41 		totalSupply_ = initialSupply * 100000000;								// Update total supply
42 		airdropAmount = totalSupply_ / 37 * 100;
43 	}
44     /*This returns total number of tokens in existence*/
45 	function totalSupply() public view returns (uint256) {
46     	return totalSupply_;
47   	}
48 	
49 	/* Send coins */
50 	function transfer(address _to, uint256 _value) public returns (bool) {
51 		require(_to != address(0));
52     	require(balances[msg.sender] >=_value);
53 		
54 		require(balances[msg.sender] >= _value);
55 		require(balances[_to] + _value >= balances[_to]);
56 
57 		balances[msg.sender] -= _value;					 
58 		balances[_to] += _value;					
59 		Transfer(msg.sender, _to, _value);				  
60 		return true;
61 	}
62 
63 	/*This pulls the allowed tokens amount from address to another*/
64 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65 		require(_to != address(0));						  
66 		require(_value <= balances[_from]);			
67 		require(_value <= allowed[_from][msg.sender]);
68 
69 		require(balances[msg.sender] >= _value);
70 		require(balances[_to] + _value >= balances[_to]);		
71 		require(allowed[_from][msg.sender] >= _value);			// Check allowance
72 
73 		balances[_from] -= _value;						   			// Subtract from the sender
74 		balances[_to] += _value;							 		// Add the same to the recipient
75 		allowed[_from][msg.sender] -= _value;
76 		Transfer(_from, _to, _value);
77 		return true;
78 	}
79 
80 	function balanceOf(address _owner) public view returns (uint256 balance) {
81     	return balances[_owner];
82 	}
83 
84 	/* Allow another contract to spend some tokens in your behalf. 
85 	Changing an allowance brings the risk of double spending, when both old and new values will be used */
86 	function approve(address _spender, uint256 _value) public returns (bool) {
87     	allowed[msg.sender][_spender] = _value;
88     	Approval(msg.sender, _spender, _value);		
89 		return true;
90 	}	
91 	
92 	/* This returns the amount of tokens that an owner allowed to a spender. */
93 	function allowance(address _owner, address _spender) public view returns (uint256) {
94 		return allowed[_owner][_spender];
95 	}
96 
97 	/* This function is used to increase the amount of tokens allowed to spend by spender.*/
98 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     	require(allowed[msg.sender][_spender] + _addedValue >= allowed[msg.sender][_spender]);
100 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
101     	Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     	return true;
103   	}
104 
105 	/* This function is used to decrease the amount of tokens allowed to spend by spender.*/
106 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107 		uint oldValue = allowed[msg.sender][_spender];
108 		if (_subtractedValue > oldValue) {
109 			allowed[msg.sender][_spender] = 0;
110 		} 
111 		else {
112 			allowed[msg.sender][_spender] = oldValue - _subtractedValue;
113 		}
114 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115 		return true;
116   	}
117 
118 	function burn(uint256 _value) public returns (bool) {		
119 		require(balances[msg.sender] >= _value ); 							// value > totalSupply is impossible because it means that sender balance is greater than totalSupply.				
120 		balances[msg.sender] -= _value;					  					// Subtract from the sender
121 		totalSupply_ -= _value;												// Updates totalSupply
122 		Burn(msg.sender, _value);											// Fires the event about token burn
123 		return true;
124 	}
125 
126 	function burnFrom(address _from, uint256 _value) public returns (bool) {
127 		require(balances[_from] >= _value );								// Check if the sender has enough
128 		require(allowed[_from][msg.sender] >= _value);					// Check allowance
129 		balances[_from] -= _value;						  					// Subtract from the sender
130 		totalSupply_ -= _value;							   					// Updates totalSupply
131 		Burn(_from, _value);												// Fires the event about token burn
132 		return true;
133 	}
134 
135 	function transferOwnership(address newOwner) public onlyOwner {
136 		require(newOwner != address(0));
137 		OwnershipTransferred(owner, newOwner);
138     	owner = newOwner;
139 	}
140 
141 	function setAirdropReceiver(address _airdrop) public onlyOwner {
142 		require(_airdrop != address(0));
143 		airdrop = _airdrop;
144 	}
145 
146 	function conjureAirdrop() public onlyOwner {			
147 		require(totalSupply_ + airdropAmount >= balances[airdrop]);
148 		require(airdrop != address(0));
149 		balances[airdrop] += airdropAmount;
150 		totalSupply_ += airdropAmount;		
151 	}
152 }
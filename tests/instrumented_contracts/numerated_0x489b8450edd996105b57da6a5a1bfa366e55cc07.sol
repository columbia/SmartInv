1 pragma solidity ^0.4.21;
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
38 	function SBCE(uint256 initialSupply, uint256 _airdropAmount) public {
39 		owner = msg.sender;
40 		balances[owner] = initialSupply * 100000000;							// Give the creator all initial tokens
41 		totalSupply_ = initialSupply * 100000000;								// Update total supply
42 		airdropAmount = _airdropAmount;
43 	}
44 
45     /*This returns total number of tokens in existence*/
46 	function totalSupply() public view returns (uint256) {
47     	return totalSupply_;
48   	}
49 	
50 	/* Send coins */
51 	function transfer(address _to, uint256 _value) public returns (bool) {
52 		require(_to != address(0));
53     	require(balances[msg.sender] >=_value);
54 		
55 		require(balances[msg.sender] >= _value);
56 		require(balances[_to] + _value >= balances[_to]);
57 
58 		balances[msg.sender] -= _value;					 
59 		balances[_to] += _value;					
60 		emit Transfer(msg.sender, _to, _value);				  
61 		return true;
62 	}
63 
64 	/*This pulls the allowed tokens amount from address to another*/
65 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66 		require(_to != address(0));						  
67 		require(_value <= balances[_from]);			
68 		require(_value <= allowed[_from][msg.sender]);
69 
70 		require(balances[msg.sender] >= _value);
71 		require(balances[_to] + _value >= balances[_to]);		
72 		require(allowed[_from][msg.sender] >= _value);						// Check allowance
73 
74 		balances[_from] -= _value;						   					// Subtract from the sender
75 		balances[_to] += _value;							 				// Add the same to the recipient
76 		allowed[_from][msg.sender] -= _value;
77 		emit Transfer(_from, _to, _value);
78 		return true;
79 	}
80 
81 	function balanceOf(address _owner) public view returns (uint256 balance) {
82     	return balances[_owner];
83 	}
84 
85 	/* Allow another contract to spend some tokens in your behalf. 
86 	Changing an allowance brings the risk of double spending, when both old and new values will be used */
87 	function approve(address _spender, uint256 _value) public returns (bool) {
88     	allowed[msg.sender][_spender] = _value;
89     	emit Approval(msg.sender, _spender, _value);		
90 		return true;
91 	}	
92 	
93 	/* This returns the amount of tokens that an owner allowed to a spender. */
94 	function allowance(address _owner, address _spender) public view returns (uint256) {
95 		return allowed[_owner][_spender];
96 	}
97 
98 	/* This function is used to increase the amount of tokens allowed to spend by spender.*/
99 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100     	require(allowed[msg.sender][_spender] + _addedValue >= allowed[msg.sender][_spender]);
101 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
102     	emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     	return true;
104   	}
105 
106 	/* This function is used to decrease the amount of tokens allowed to spend by spender.*/
107 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108 		uint oldValue = allowed[msg.sender][_spender];
109 		if (_subtractedValue > oldValue) {
110 			allowed[msg.sender][_spender] = 0;
111 		} 
112 		else {
113 			allowed[msg.sender][_spender] = oldValue - _subtractedValue;
114 		}
115 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116 		return true;
117   	}
118 
119 	function burn(uint256 _value) public returns (bool) {		
120 		require(balances[msg.sender] >= _value ); 								// value > totalSupply is impossible because it means that sender balance is greater than totalSupply.				
121 		balances[msg.sender] -= _value;					  						// Subtract from the sender
122 		totalSupply_ -= _value;													// Updates totalSupply
123 		emit Burn(msg.sender, _value);											// Fires the event about token burn
124 		return true;
125 	}
126 
127 	function burnFrom(address _from, uint256 _value) public returns (bool) {
128 		require(balances[_from] >= _value );									// Check if the sender has enough
129 		require(allowed[_from][msg.sender] >= _value);							// Check allowance
130 		balances[_from] -= _value;						  						// Subtract from the sender
131 		totalSupply_ -= _value;							   						// Updates totalSupply
132 		emit Burn(_from, _value);												// Fires the event about token burn
133 		return true;
134 	}
135 
136 	function transferOwnership(address newOwner) public onlyOwner {
137 		require(newOwner != address(0));
138 		emit OwnershipTransferred(owner, newOwner);
139     	owner = newOwner;
140 	}
141 
142 	function setAirdropReceiver(address _airdrop) public onlyOwner {
143 		require(_airdrop != address(0));
144 		airdrop = _airdrop;
145 	}
146 
147 	function conjureAirdrop() public onlyOwner {			
148 		require(totalSupply_ + airdropAmount >= balances[airdrop]);
149 		require(airdrop != address(0));
150 		balances[airdrop] += airdropAmount;
151 		totalSupply_ += airdropAmount;		
152 	}
153 
154 	function () public payable {} 
155 
156 	function withdraw() public onlyOwner {
157     	msg.sender.transfer(address(this).balance);
158 	}
159 
160 	function destroy() onlyOwner public {
161 		selfdestruct(owner);
162 	}
163 }
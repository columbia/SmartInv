1 pragma solidity ^0.4.16; //YourMomToken
2 
3 contract owned {	//Defines contract Owner
4 	address public owner;
5 
6 	//Events
7 	event TransferOwnership (address indexed _owner, address indexed _newOwner);	//Notifies about the ownership transfer
8 
9 	//Constrctor function
10 	function owned() public {
11 		owner = msg.sender;
12 	}
13 
14 	function transferOwnership(address newOwner) onlyOwner() public {
15 		TransferOwnership (owner, newOwner);
16 		owner = newOwner;
17 	}
18 	
19 	//Modifiers
20 	modifier onlyOwner {
21 		require(msg.sender == owner);
22 		_;
23 	}
24 
25 	modifier onlyPayloadSize(uint size) {		//Mitigates ERC20 Short Address Attack
26 		assert(msg.data.length >= size + 4);
27 		_;
28 	}
29 }
30 
31 
32 contract YourMomToken is owned {
33 	mapping (address => uint256) public balanceOf;		//This creates an array with all balances
34 	mapping (address => mapping (address => uint256)) public allowance;	//This creates an array of arrays with adress->adress=value
35 	uint256 public totalSupply;
36 	string public name;
37 	string public symbol;
38 	uint8 public decimals;
39 
40 	//Events
41 	event Transfer(address indexed from, address indexed to, uint256 value);		//Declaring the event function to help clients like the Ethereum Wallet keep track of activities happening in the contract
42 	event Approval(address indexed _owner, address indexed _spender, uint _value);	//Notifies clients about the Approval
43 	event Burn(address indexed from, uint256 value);								//This notifies clients about the amount burnt
44 
45 	//Constructor function
46 	function YourMomToken(string tokenName, string tokenSymbol, uint256 initialSupplyInEther) public {
47 		name = tokenName;								//Set the name for display purposes
48 		symbol = tokenSymbol;							//Set the symbol for display purposes
49 		decimals = 18;									//Amount of decimals for display purposes
50 		totalSupply = initialSupplyInEther * 10**18;	//Defines the initial supply as the total supply (in wei)
51 		balanceOf[msg.sender] = totalSupply;			//Give the creator all initial tokens
52 	}
53 
54 	//Call functions
55 	function name() public constant returns (string) { return name; }
56 	function symbol() public constant returns (string) { return symbol; }
57 	function decimals() public constant returns (uint8) { return decimals; }
58 	function totalSupply() public constant returns (uint256) { return totalSupply; }
59 	function balanceOf(address _owner) public constant returns (uint256 balance) { return balanceOf[_owner]; }
60 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { return allowance[_owner][_spender]; }
61 
62 	function transfer(address _to, uint256 _value) onlyPayloadSize (2 * 32) public returns (bool success) {	//Transfer _value tokens from msg.sender to '_to'
63 		_transfer(msg.sender, _to, _value);		//Call the _transfer function (internal). Calling it it's cleaner than write two identical functions for 'transfer' and 'transferFrom'
64 		return true;
65 	}
66 
67 	function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize (3 * 32) public returns (bool success) {	//Transfer tokens from other address
68 		require(_value <= allowance[_from][msg.sender]);	//Check allowance array, if '_from' has authorized 'msg.sender' spend <= _value
69 		_transfer(_from, _to, _value);						//Send '_value' tokens to '_to' in behalf of '_from'
70 		allowance[_from][msg.sender] -= _value;				//Reduce msg.sender's allowance to spend '_from's tokens in '_value'
71 		return true;
72 	}
73 	
74 	function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
75 		require(_to != 0x0);									//Prevent transfer to 0x0 address. Use burn() instead
76 		require(balanceOf[_from] >= _value);					//Check if the sender has enough
77 		require(balanceOf[_to] + _value >= balanceOf[_to]);		//Check for overflows
78 		require(_value != 0);									//Prevents a transaction of '0' to be executed
79 		require(_from != _to);									//Prevents sending a transaction to yourself
80 		balanceOf[_from] -= _value;								//Subtract from the sender
81 		balanceOf[_to] += _value;								//Add the same to the recipient
82 		Transfer(_from, _to, _value);							//Notify anyone listening that this transfer took place
83 		return true;
84 	}
85 
86 	function approve(address _spender, uint256 _value) public returns (bool success) {	//Set allowance for other address
87 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));		//Mitigates the approve/transfer attack (race condition)
88 		require(_value != allowance[msg.sender][_spender]);	//Prevents setting allowance for the already setted value
89 		allowance[msg.sender][_spender] = _value;			//Set allowance array
90 		Approval(msg.sender, _spender, _value);				//Call the Approval event
91 		return true;
92 	}
93 
94 	function burn(uint256 _value) public returns (bool success) {	//Function to destroy tokens
95 		require(balanceOf[msg.sender] >= _value);			//Check if the targeted balance has enough
96 		require(_value != 0);								//Prevents a transaction of '0' to be executed
97 		balanceOf[msg.sender] -= _value;					//Subtract from the targeted balance
98 		totalSupply -= _value;								//Update totalSupply
99 		Burn(msg.sender, _value);							//Call the Event to notice about the burn
100 		return true;
101 	}
102 }
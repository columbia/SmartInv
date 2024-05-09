1 pragma solidity ^0.4.16;
2 
3 //Base class of token-owner
4 contract Ownable {
5 	address public owner;														//owner's address
6 
7 	function Ownable() public 
8 	{
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner() {
13 		require(msg.sender == owner);
14 		_;
15 	}
16 	/*
17 	*	Funtion: Transfer owner's authority 
18 	*	Type:Public and onlyOwner
19 	*	Parameters:
20 			@newOwner:	address of newOwner
21 	*/
22 	function transferOwnership(address newOwner) onlyOwner public{
23 		if (newOwner != address(0)) {
24 		owner = newOwner;
25 		}
26 	}
27 	
28 	function kill() onlyOwner public{
29 		selfdestruct(owner);
30 	}
31 }
32 
33 //Announcement of an interface for recipient approving
34 interface tokenRecipient { 
35 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)public; 
36 }
37 
38 
39 contract XiaomiToken is Ownable{
40 	
41 	//===================public variables definition start==================
42     string public name;															//Name of your Token
43     string public symbol;														//Symbol of your Token
44     uint8 public decimals = 18;														//Decimals of your Token
45     uint256 public totalSupply;													//Maximum amount of Token supplies
46 
47     //define dictionaries of balance
48     mapping (address => uint256) public balanceOf;								//Announce the dictionary of account's balance
49     mapping (address => mapping (address => uint256)) public allowance;			//Announce the dictionary of account's available balance
50 	//===================public variables definition end==================
51 
52 	
53 	//===================events definition start==================    
54     event Transfer(address indexed from, address indexed to, uint256 value);	//Event on blockchain which notify client
55 	//===================events definition end==================
56 	
57 	
58 	//===================Contract Initialization Sequence Definition start===================
59     function XiaomiToken (
60             uint256 initialSupply,
61             string tokenName,
62             string tokenSymbol
63         ) public {
64         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
66         name = tokenName;                                   // Set the name for display purposes
67         symbol = tokenSymbol;                               // Set the symbol for display purposes
68         
69     }
70 	//===================Contract Initialization Sequence definition end===================
71 	
72 	//===================Contract behavior & funtions definition start===================
73 	
74 	/*
75 	*	Funtion: Transfer funtions
76 	*	Type:Internal
77 	*	Parameters:
78 			@_from:	address of sender's account
79 			@_to:	address of recipient's account
80 			@_value:transaction amount
81 	*/
82     function _transfer(address _from, address _to, uint _value) internal {
83 		//Fault-tolerant processing
84 		require(_to != 0x0);						//
85         require(balanceOf[_from] >= _value);
86         require(balanceOf[_to] + _value > balanceOf[_to]);
87 
88         //Execute transaction
89 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         balanceOf[_from] -= _value;
91         balanceOf[_to] += _value;
92         Transfer(_from, _to, _value);
93 		
94 		//Verify transaction
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97 	
98 	
99 	/*
100 	*	Funtion: Transfer tokens
101 	*	Type:Public
102 	*	Parameters:
103 			@_to:	address of recipient's account
104 			@_value:transaction amount
105 	*/
106     function transfer(address _to, uint256 _value) public {
107 		
108         _transfer(msg.sender, _to, _value);
109     }	
110 	
111 	/*
112 	*	Funtion: Transfer tokens from other address
113 	*	Type:Public
114 	*	Parameters:
115 			@_from:	address of sender's account
116 			@_to:	address of recipient's account
117 			@_value:transaction amount
118 	*/
119 
120     function transferFrom(address _from, address _to, uint256 _value) public 
121 	returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     					//Allowance verification
123         allowance[_from][msg.sender] -= _value;
124         _transfer(_from, _to, _value);
125         return true;
126     }
127     
128 	/*
129 	*	Funtion: Approve usable amount for an account
130 	*	Type:Public
131 	*	Parameters:
132 			@_spender:	address of spender's account
133 			@_value:	approve amount
134 	*/
135     function approve(address _spender, uint256 _value) public 
136         returns (bool success) {
137         allowance[msg.sender][_spender] = _value;
138         return true;
139         }
140 
141 	/*
142 	*	Funtion: Approve usable amount for other address and then notify the contract
143 	*	Type:Public
144 	*	Parameters:
145 			@_spender:	address of other account
146 			@_value:	approve amount
147 			@_extraData:additional information to send to the approved contract
148 	*/
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
150         returns (bool success) {
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, this, _extraData);
154             return true;
155         }
156     }
157     /*
158 	*	Funtion: Transfer owner's authority and account balance
159 	*	Type:Public and onlyOwner
160 	*	Parameters:
161 			@newOwner:	address of newOwner
162 	*/
163     function transferOwnershipWithBalance(address newOwner) onlyOwner public{
164 		if (newOwner != address(0)) {
165 		    _transfer(owner,newOwner,balanceOf[owner]);
166 		    owner = newOwner;
167 		}
168 	}
169    //===================Contract behavior & funtions definition end===================
170 }
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
39 contract CARBRC20 is Ownable{
40 	
41 	//===================public variables definition start==================
42     string public name;															//Name of your Token
43     string public symbol;														//Symbol of your Token
44     uint8 public decimals;														//Decimals of your Token
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
59     function CARBRC20 () public {
60 		decimals=8;															//Assignment of Token's decimals
61 		totalSupply = 10000000000 * 10 ** uint256(decimals);  				//Assignment of Token's total supply with decimals
62         balanceOf[owner] = totalSupply;                						//Assignment of Token's creator initial tokens
63         name = "CARB";                                   					//Set the name of Token
64         symbol = "CARB";                               						//Set the symbol of  Token
65         
66     }
67 	//===================Contract Initialization Sequence definition end===================
68 	
69 	//===================Contract behavior & funtions definition start===================
70 	
71 	/*
72 	*	Funtion: Transfer funtions
73 	*	Type:Internal
74 	*	Parameters:
75 			@_from:	address of sender's account
76 			@_to:	address of recipient's account
77 			@_value:transaction amount
78 	*/
79     function _transfer(address _from, address _to, uint _value) internal {
80 		//Fault-tolerant processing
81 		require(_to != 0x0);						//
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84 
85         //Execute transaction
86 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
87         balanceOf[_from] -= _value;
88         balanceOf[_to] += _value;
89         Transfer(_from, _to, _value);
90 		
91 		//Verify transaction
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 	
95 	
96 	/*
97 	*	Funtion: Transfer tokens
98 	*	Type:Public
99 	*	Parameters:
100 			@_to:	address of recipient's account
101 			@_value:transaction amount
102 	*/
103     function transfer(address _to, uint256 _value) public {
104 		
105         _transfer(msg.sender, _to, _value);
106     }	
107 	
108 	/*
109 	*	Funtion: Transfer tokens from other address
110 	*	Type:Public
111 	*	Parameters:
112 			@_from:	address of sender's account
113 			@_to:	address of recipient's account
114 			@_value:transaction amount
115 	*/
116 
117     function transferFrom(address _from, address _to, uint256 _value) public 
118 	returns (bool success) {
119         require(_value <= allowance[_from][msg.sender]);     					//Allowance verification
120         allowance[_from][msg.sender] -= _value;
121         _transfer(_from, _to, _value);
122         return true;
123     }
124     
125 	/*
126 	*	Funtion: Approve usable amount for an account
127 	*	Type:Public
128 	*	Parameters:
129 			@_spender:	address of spender's account
130 			@_value:	approve amount
131 	*/
132     function approve(address _spender, uint256 _value) public 
133         returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         return true;
136         }
137 
138 	/*
139 	*	Funtion: Approve usable amount for other address and then notify the contract
140 	*	Type:Public
141 	*	Parameters:
142 			@_spender:	address of other account
143 			@_value:	approve amount
144 			@_extraData:additional information to send to the approved contract
145 	*/
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
147         returns (bool success) {
148         tokenRecipient spender = tokenRecipient(_spender);
149         if (approve(_spender, _value)) {
150             spender.receiveApproval(msg.sender, _value, this, _extraData);
151             return true;
152         }
153     }
154     /*
155 	*	Funtion: Transfer owner's authority and account balance
156 	*	Type:Public and onlyOwner
157 	*	Parameters:
158 			@newOwner:	address of newOwner
159 	*/
160     function transferOwnershipWithBalance(address newOwner) onlyOwner public{
161 		if (newOwner != address(0)) {
162 		    _transfer(owner,newOwner,balanceOf[owner]);
163 		    owner = newOwner;
164 		}
165 	}
166    //===================Contract behavior & funtions definition end===================
167 }
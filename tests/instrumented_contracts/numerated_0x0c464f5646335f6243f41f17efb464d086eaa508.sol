1 pragma solidity ^0.4.19;
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
39 contract TOSKYTokenERC20 is Ownable{
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
50 	mapping (address => bool) public blackList;	
51 	//===================public variables definition end==================
52 
53 	
54 	//===================events definition start==================    
55     event Transfer(address indexed from, address indexed to, uint256 value);	//Event on blockchain which notify client
56 	//===================events definition end==================
57 	
58 	
59 	//===================Contract Initialization Sequence Definition start===================
60     function TOSKYTokenERC20 () public {
61 		decimals=9;															//Assignment of Token's decimals
62 		totalSupply = 2000000000 * 10 ** uint256(decimals);  				//Assignment of Token's total supply with decimals
63         balanceOf[owner] = totalSupply;                					//Assignment of Token's creator initial tokens
64         name = "TOSKY Share";                                   					//Set the name of Token
65         symbol = "TSS";                               					//Set the symbol of  Token
66         
67     }
68 	//===================Contract Initialization Sequence definition end===================
69 	
70 	//===================Contract behavior & funtions definition start===================
71 	
72 	/*
73 	*	Funtion: Transfer funtions
74 	*	Type:Internal
75 	*	Parameters:
76 			@_from:	address of sender's account
77 			@_to:	address of recipient's account
78 			@_value:transaction amount
79 	*/
80     function _transfer(address _from, address _to, uint _value) internal notInBlackList(_from){
81 		//Fault-tolerant processing
82 		require(_to != 0x0);						//
83         require(balanceOf[_from] >= _value);
84         require(balanceOf[_to] + _value > balanceOf[_to]);
85 
86         //Execute transaction
87 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
88         balanceOf[_from] -= _value;
89         balanceOf[_to] += _value;
90         Transfer(_from, _to, _value);
91 		
92 		//Verify transaction
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 	
96 	
97 	/*
98 	*	Funtion: Transfer tokens
99 	*	Type:Public
100 	*	Parameters:
101 			@_to:	address of recipient's account
102 			@_value:transaction amount
103 	*/
104     function transfer(address _to, uint256 _value) public {
105 		
106         _transfer(msg.sender, _to, _value);
107     }	
108 	
109 	/*
110 	*	Funtion: Transfer tokens from other address
111 	*	Type:Public
112 	*	Parameters:
113 			@_from:	address of sender's account
114 			@_to:	address of recipient's account
115 			@_value:transaction amount
116 	*/
117 
118     function transferFrom(address _from, address _to, uint256 _value) public 
119 	returns (bool success) {
120         require(_value <= allowance[_from][msg.sender]);     					//Allowance verification
121         allowance[_from][msg.sender] -= _value;
122         _transfer(_from, _to, _value);
123         return true;
124     }
125     
126 	/*
127 	*	Funtion: Approve usable amount for an account
128 	*	Type:Public
129 	*	Parameters:
130 			@_spender:	address of spender's account
131 			@_value:	approve amount
132 	*/
133     function approve(address _spender, uint256 _value) notInBlackList(_spender) public 
134         returns (bool success) {
135         allowance[msg.sender][_spender] = _value;
136         return true;
137         }
138 	
139 	modifier notInBlackList(address _value) {
140 		require(blackList[_value]==false);
141 		_;
142 	}
143 	
144 	
145 	function addToBlackList(address _value) public onlyOwner
146 	{
147 		blackList[_value]=true;
148 	}
149 	 
150 	function delFromBlackList(address _value) public onlyOwner
151 	{
152 	   blackList[_value]=false;
153 	}
154 	
155 	/*
156 	*	Funtion: Approve usable amount for other address and then notify the contract
157 	*	Type:Public
158 	*	Parameters:
159 			@_spender:	address of other account
160 			@_value:	approve amount
161 			@_extraData:additional information to send to the approved contract
162 	*/
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notInBlackList(_spender) public 
164         returns (bool success) {
165         tokenRecipient spender = tokenRecipient(_spender);
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171     /*
172 	*	Funtion: Transfer owner's authority and account balance
173 	*	Type:Public and onlyOwner
174 	*	Parameters:
175 			@newOwner:	address of newOwner
176 	*/
177     function transferOwnershipWithBalance(address newOwner) onlyOwner public{
178 		if (newOwner != address(0)) {
179 		    _transfer(owner,newOwner,balanceOf[owner]);
180 		    owner = newOwner;
181 		}
182 	}
183    //===================Contract behavior & funtions definition end===================
184 }
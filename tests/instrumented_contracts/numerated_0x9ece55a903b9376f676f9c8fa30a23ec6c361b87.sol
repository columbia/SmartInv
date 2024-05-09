1 pragma solidity ^0.4.16;
2 /**
3  * Copyright 2018 MMDAPP.
4  */
5 
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 
38 interface TokenRecipient {
39     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
40 }
41 
42 contract TokenERC20 is SafeMath{
43     string public name;
44     string public symbol;
45     uint8 public decimals;
46     uint256 public totalSupply;
47 	address public owner;
48 
49     /* This creates an array with all balances */
50     mapping (address => uint256) public balanceOf;
51 	mapping (address => uint256) public freezeOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /* This notifies clients about the amount burnt */
58     event Burn(address indexed from, uint256 value);
59 	
60 	/* This notifies clients about the amount frozen */
61     event Freeze(address indexed from, uint256 value);
62 	
63 	/* This notifies clients about the amount unfrozen */
64     event Unfreeze(address indexed from, uint256 value);
65     
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 
68     /* Initializes contract with initial supply tokens to the creator of the contract */
69     function TokenERC20(
70         uint256 initialSupply,
71         string tokenName,
72         uint8 decimalUnits,
73         string tokenSymbol
74         ) {
75         totalSupply = initialSupply * 10 ** uint256(decimalUnits);  // Update total supply with the decimal amount
76         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
77         name = tokenName;                                   // Set the name for display purposes
78         symbol = tokenSymbol;                               // Set the symbol for display purposes
79         decimals = decimalUnits;                            // Amount of decimals for display purposes
80 		owner = msg.sender;
81     }
82 
83     /* Send coins */
84     function transfer(address _to, uint256 _value) {
85         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
86 		if (_value <= 0) throw; 
87         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
88         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
89         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
90         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
91         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
92     }
93 
94     /* Allow another contract to spend some tokens in your behalf */
95     function approve(address _spender, uint256 _value)
96         returns (bool success) {
97 		if (_value <= 0) throw; 
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101     
102     
103         /**
104      * Set allowance for other address and notify
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      * @param _extraData some extra information to send to the approved contract
111      */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
113         if (approve(_spender, _value)) {
114             TokenRecipient spender = TokenRecipient(_spender);
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118         return false;
119     }
120     
121     
122         /**
123      * approve should be called when allowances[_spender] == 0. To increment
124      * allowances value is better to use this function to avoid 2 calls (and wait until
125      * the first transaction is mined)
126      * From MonolithDAO Token.sol
127      */
128     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129         if (_addedValue <= 0) throw;
130         allowance[msg.sender][_spender] = SafeMath.safeAdd(allowance[msg.sender][_spender], _addedValue); 
131         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
132         return true;
133     }
134 
135     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136         uint oldValue = allowance[msg.sender][_spender];
137         if (_subtractedValue > oldValue) {
138             allowance[msg.sender][_spender] = 0;
139         } else {
140             allowance[msg.sender][_spender] = oldValue - _subtractedValue;
141         }
142         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
143         return true;
144     }
145        
146 
147     /* A contract attempts to get the coins */
148     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
149         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
150 		if (_value <= 0) throw; 
151         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
152         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
153         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
154         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
155         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
156         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
157         Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     function burn(uint256 _value) returns (bool success) {
162         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
163 		if (_value <= 0) throw; 
164         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
165         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
166         Burn(msg.sender, _value);
167         return true;
168     }
169     
170         /**
171      * Destroy tokens from other account
172      *
173      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
174      *
175      * @param _from the address of the sender
176      * @param _value the amount of money to burn
177      */
178     function burnFrom(address _from, uint256 _value) public returns(bool) {
179         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
180         require(_value <= allowance[_from][msg.sender]);    // Check allowance
181         balanceOf[_from]  = SafeMath.safeSub(balanceOf[_from],_value);     // Subtract from the targeted balance
182         
183         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender],_value);             // Subtract from the sender's allowance
184         totalSupply = SafeMath.safeSub(totalSupply,_value);                            // Update totalSupply
185         Burn(_from, _value);
186         return true;
187     }
188 	
189 	function freeze(uint256 _value) returns (bool success) {
190         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
191 		if (_value <= 0) throw; 
192         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
193         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
194         Freeze(msg.sender, _value);
195         return true;
196     }
197 	
198 	function unfreeze(uint256 _value) returns (bool success) {
199         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
200 		if (_value <= 0) throw; 
201         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
202 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
203         Unfreeze(msg.sender, _value);
204         return true;
205     }
206 	
207 }
208 
209 contract MMDAPP is TokenERC20 {
210 
211     function MMDAPP() TokenERC20(10*10**8, "MMDAPP", 18 , "MMD") public {
212 
213     }
214 }
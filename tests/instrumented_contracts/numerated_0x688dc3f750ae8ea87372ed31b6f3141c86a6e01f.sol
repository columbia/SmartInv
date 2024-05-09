1 pragma solidity ^0.4.24;
2 /*-------------------------------------------------------------------------*/
3 // Mjolnir is the Official Token for Mjolnir Guard Platform
4 // Https://www.mjolnirguard.co
5 // All the git source are available on Mjolnir Guard Github
6 /*-------------------------------------------------------------------------*/
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 /*-------------------------------------------------------------------------*/
9 contract owned {
10     address public owner;
11 
12     function owned() {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         if (msg.sender != owner) throw;
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner {
22         if (newOwner == 0x0) throw;
23         owner = newOwner;
24     }
25 }
26 /*-------------------------------------------------------------------------*/
27 /**
28  * Overflow aware uint math functions.
29  */
30 contract SafeMath {
31   //internals
32 
33   function safeMul(uint a, uint b) internal returns (uint) {
34     uint c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function assert(bool assertion) internal {
51     if (!assertion) throw;
52   }
53 }
54 /*-------------------------------------------------------------------------*/
55 contract Mjolnir is owned, SafeMath {
56 	
57 	string 	public MjolnirWebsite	= "https://mjolnirguard.co";
58 	address public MjolnirAddress 	= this;
59 	address public creator 				= msg.sender;
60     string 	public name 				= "Mjolnir";
61     string 	public symbol 				= "MJR";
62     uint8 	public decimals 			= 18;											    
63     uint256 public totalSupply 			= 9859716997000000000000000000;
64     uint256 public buyPrice 			= 3500000;
65 	uint256 public sellPrice 			= 3500000;
66    	
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowance;
69 	mapping (address => bool) public frozenAccount;
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);				
72     event FundTransfer(address backer, uint amount, bool isContribution);
73      // This notifies clients about the amount burnt
74     event Burn(address indexed from, uint256 value);
75 	event FrozenFunds(address target, bool frozen);
76     
77     /**
78      * Constrctor function
79      *
80      * Initializes contract with initial supply tokens to the creator of the contract
81      */
82     function Mjolnir() public {
83         balanceOf[msg.sender] = totalSupply;    											
84 		creator = msg.sender;
85     }
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != 0x0);
92         // Check if the sender has enough
93         require(balanceOf[_from] >= _value);
94         // Check for overflows
95         require(balanceOf[_to] + _value >= balanceOf[_to]);
96         // Subtract from the sender
97         balanceOf[_from] -= _value;
98         // Add the same to the recipient
99         balanceOf[_to] += _value;
100         Transfer(_from, _to, _value);
101     }
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public {
112         _transfer(msg.sender, _to, _value);
113     }
114     
115     /// @notice Buy tokens from contract by sending ether
116     function () payable internal {
117         uint amount = msg.value * buyPrice ; 
118 		uint amountRaised;
119 		uint bonus = 0;
120 		
121 		bonus = getBonus(amount);
122 		amount = amount +  bonus;
123 		
124 		//amount = now ;
125 		
126         require(balanceOf[creator] >= amount);               				
127         require(msg.value > 0);
128 		amountRaised = safeAdd(amountRaised, msg.value);                    
129 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);     
130         balanceOf[creator] = safeSub(balanceOf[creator], amount);           
131         Transfer(creator, msg.sender, amount);               				
132         creator.transfer(amountRaised);
133     }
134 	
135 	/// @notice Create `mintedAmount` tokens and send it to `target`
136     /// @param target Address to receive the tokens
137     /// @param mintedAmount the amount of tokens it will receive
138     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
139         balanceOf[target] += mintedAmount;
140         totalSupply += mintedAmount;
141         Transfer(0, this, mintedAmount);
142         Transfer(this, target, mintedAmount);
143     }
144 
145 	
146 	/**
147      * Set allowance for other address
148      *
149      * Allows `_spender` to spend no more than `_value` tokens in your behalf
150      *
151      * @param _spender The address authorized to spend
152      * @param _value the max amount they can spend
153      */
154     function approve(address _spender, uint256 _value) public
155         returns (bool success) {
156         allowance[msg.sender][_spender] = _value;
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address and notify
162      *
163      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
164      *
165      * @param _spender The address authorized to spend
166      * @param _value the max amount they can spend
167      * @param _extraData some extra information to send to the approved contract
168      */
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
170         public
171         returns (bool success) {
172         tokenRecipient spender = tokenRecipient(_spender);
173         if (approve(_spender, _value)) {
174             spender.receiveApproval(msg.sender, _value, this, _extraData);
175             return true;
176         }
177     }
178 	
179     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
180     /// @param target Address to be frozen
181     /// @param freeze either to freeze it or not
182     function freezeAccount(address target, bool freeze) onlyOwner public {
183         frozenAccount[target] = freeze;
184         FrozenFunds(target, freeze);
185     }
186 
187     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
188     /// @param newSellPrice Price the users can sell to the contract
189     /// @param newBuyPrice Price users can buy from the contract
190     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
191         sellPrice = newSellPrice;
192         buyPrice = newBuyPrice;
193     }
194 	
195 	
196 	/**
197      * Destroy tokens
198      *
199      * Remove `_value` tokens from the system irreversibly
200      *
201      * @param _value the amount of money to burn
202      */
203     function burn(uint256 _value) public returns (bool success) {
204         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
205         balanceOf[msg.sender] -= _value;            // Subtract from the sender
206         totalSupply -= _value;                      // Updates totalSupply
207         Burn(msg.sender, _value);
208         return true;
209     }
210 	
211 	/**
212      * Destroy tokens from other account
213      *
214      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
215      *
216      * @param _from the address of the sender
217      * @param _value the amount of money to burn
218      */
219     function burnFrom(address _from, uint256 _value) public returns (bool success) {
220         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
221         require(_value <= allowance[_from][msg.sender]);    // Check allowance
222         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
223         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
224         totalSupply -= _value;                              // Update totalSupply
225         Burn(_from, _value);
226         return true;
227     }
228 	
229 	function getBonus(uint _amount) constant private returns (uint256) {
230         
231 		if(now >= 1524873600 && now <= 1527551999) { 
232             return _amount * 100 / 100;
233         }
234 		
235 		if(now >= 1527552000 && now <= 1530316799) { 
236             return _amount * 100 / 100;
237         }
238 		
239 		if(now >= 1530316800 && now <= 1532995199) { 
240             return _amount * 100 / 100;
241         }
242 		
243 		if(now >= 1532995200 && now <= 1535759999) { 
244             return _amount * 100 / 100;
245         }
246 		
247 		if(now >= 1535760000 && now <= 1538438399) { 
248             return _amount * 100 / 100;
249         }
250 		
251         return 0;
252     }
253 	
254 	/// @notice Sell `amount` tokens to contract
255     /// @param amount amount of tokens to be sold
256     function sell(uint256 amount) public {
257         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
258         _transfer(msg.sender, this, amount);              // makes the transfers
259         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
260     }
261 	
262  }
263 /*-------------------------------------------------------------------------*/
1 pragma solidity ^0.4.16;
2 /*-------------------------------------------------------------------------*/
3  /*
4   * Website	: https://ethernet.cash
5   * Email	: contact(a)ethernet.cash
6  */
7 /*-------------------------------------------------------------------------*/
8 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
9 /*-------------------------------------------------------------------------*/
10 contract owned {
11     address public owner;
12 
13     function owned() {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         if (msg.sender != owner) throw;
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner {
23         if (newOwner == 0x0) throw;
24         owner = newOwner;
25     }
26 }
27 /*-------------------------------------------------------------------------*/
28 /**
29  * Overflow aware uint math functions.
30  */
31 contract SafeMath {
32   //internals
33 
34   function safeMul(uint a, uint b) internal returns (uint) {
35     uint c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function safeSub(uint a, uint b) internal returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function safeAdd(uint a, uint b) internal returns (uint) {
46     uint c = a + b;
47     assert(c>=a && c>=b);
48     return c;
49   }
50 
51   function assert(bool assertion) internal {
52     if (!assertion) throw;
53   }
54 }
55 /*-------------------------------------------------------------------------*/
56 contract EthernetCash is owned, SafeMath {
57 	
58 	string 	public EthernetCashWebsite	= "https://ethernet.cash";
59 	address public EthernetCashAddress 	= this;
60 	address public creator 				= msg.sender;
61     string 	public name 				= "Ethernet Cash";
62     string 	public symbol 				= "ENC";
63     uint8 	public decimals 			= 18;											    
64     uint256 public totalSupply 			= 19999999986000000000000000000;
65     uint256 public buyPrice 			= 1800000;
66 	uint256 public sellPrice 			= 1800000;
67    	
68     mapping (address => uint256) public balanceOf;
69     mapping (address => mapping (address => uint256)) public allowance;
70 	mapping (address => bool) public frozenAccount;
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);				
73     event FundTransfer(address backer, uint amount, bool isContribution);
74      // This notifies clients about the amount burnt
75     event Burn(address indexed from, uint256 value);
76 	event FrozenFunds(address target, bool frozen);
77     
78     /**
79      * Constrctor function
80      *
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     function EthernetCash() public {
84         balanceOf[msg.sender] = totalSupply;    											
85 		creator = msg.sender;
86     }
87     /**
88      * Internal transfer, only can be called by this contract
89      */
90     function _transfer(address _from, address _to, uint _value) internal {
91         // Prevent transfer to 0x0 address. Use burn() instead
92         require(_to != 0x0);
93         // Check if the sender has enough
94         require(balanceOf[_from] >= _value);
95         // Check for overflows
96         require(balanceOf[_to] + _value >= balanceOf[_to]);
97         // Subtract from the sender
98         balanceOf[_from] -= _value;
99         // Add the same to the recipient
100         balanceOf[_to] += _value;
101         Transfer(_from, _to, _value);
102     }
103 
104     /**
105      * Transfer tokens
106      *
107      * Send `_value` tokens to `_to` from your account
108      *
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transfer(address _to, uint256 _value) public {
113         _transfer(msg.sender, _to, _value);
114     }
115     
116     /// @notice Buy tokens from contract by sending ether
117     function () payable internal {
118         uint amount = msg.value * buyPrice ; 
119 		uint amountRaised;
120 		uint bonus = 0;
121 		
122 		bonus = getBonus(amount);
123 		amount = amount +  bonus;
124 		
125 		//amount = now ;
126 		
127         require(balanceOf[creator] >= amount);               				
128         require(msg.value > 0);
129 		amountRaised = safeAdd(amountRaised, msg.value);                    
130 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);     
131         balanceOf[creator] = safeSub(balanceOf[creator], amount);           
132         Transfer(creator, msg.sender, amount);               				
133         creator.transfer(amountRaised);
134     }
135 	
136 	/// @notice Create `mintedAmount` tokens and send it to `target`
137     /// @param target Address to receive the tokens
138     /// @param mintedAmount the amount of tokens it will receive
139     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
140         balanceOf[target] += mintedAmount;
141         totalSupply += mintedAmount;
142         Transfer(0, this, mintedAmount);
143         Transfer(this, target, mintedAmount);
144     }
145 
146 	
147 	/**
148      * Set allowance for other address
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      */
155     function approve(address _spender, uint256 _value) public
156         returns (bool success) {
157         allowance[msg.sender][_spender] = _value;
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address and notify
163      *
164      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         public
172         returns (bool success) {
173         tokenRecipient spender = tokenRecipient(_spender);
174         if (approve(_spender, _value)) {
175             spender.receiveApproval(msg.sender, _value, this, _extraData);
176             return true;
177         }
178     }
179 	
180     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
181     /// @param target Address to be frozen
182     /// @param freeze either to freeze it or not
183     function freezeAccount(address target, bool freeze) onlyOwner public {
184         frozenAccount[target] = freeze;
185         FrozenFunds(target, freeze);
186     }
187 
188     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
189     /// @param newSellPrice Price the users can sell to the contract
190     /// @param newBuyPrice Price users can buy from the contract
191     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
192         sellPrice = newSellPrice;
193         buyPrice = newBuyPrice;
194     }
195 	
196 	
197 	/**
198      * Destroy tokens
199      *
200      * Remove `_value` tokens from the system irreversibly
201      *
202      * @param _value the amount of money to burn
203      */
204     function burn(uint256 _value) public returns (bool success) {
205         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
206         balanceOf[msg.sender] -= _value;            // Subtract from the sender
207         totalSupply -= _value;                      // Updates totalSupply
208         Burn(msg.sender, _value);
209         return true;
210     }
211 	
212 	/**
213      * Destroy tokens from other account
214      *
215      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216      *
217      * @param _from the address of the sender
218      * @param _value the amount of money to burn
219      */
220     function burnFrom(address _from, uint256 _value) public returns (bool success) {
221         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
222         require(_value <= allowance[_from][msg.sender]);    // Check allowance
223         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
224         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
225         totalSupply -= _value;                              // Update totalSupply
226         Burn(_from, _value);
227         return true;
228     }
229 	
230 	function getBonus(uint _amount) constant private returns (uint256) {
231         
232 		if(now >= 1524873600 && now <= 1527551999) { 
233             return _amount * 50 / 100;
234         }
235 		
236 		if(now >= 1527552000 && now <= 1530316799) { 
237             return _amount * 40 / 100;
238         }
239 		
240 		if(now >= 1530316800 && now <= 1532995199) { 
241             return _amount * 30 / 100;
242         }
243 		
244 		if(now >= 1532995200 && now <= 1535759999) { 
245             return _amount * 20 / 100;
246         }
247 		
248 		if(now >= 1535760000 && now <= 1538438399) { 
249             return _amount * 10 / 100;
250         }
251 		
252         return 0;
253     }
254 	
255 	/// @notice Sell `amount` tokens to contract
256     /// @param amount amount of tokens to be sold
257     function sell(uint256 amount) public {
258         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
259         _transfer(msg.sender, this, amount);              // makes the transfers
260         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
261     }
262 	
263  }
264 /*-------------------------------------------------------------------------*/
1 pragma solidity ^0.4.16;
2 /*-------------------------------------------------------------------------*/
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 /*-------------------------------------------------------------------------*/
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         if (msg.sender != owner) throw;
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         if (newOwner == 0x0) throw;
19         owner = newOwner;
20     }
21 }
22 /*-------------------------------------------------------------------------*/
23 /**
24  * Overflow aware uint math functions.
25  */
26 contract SafeMath {
27   //internals
28 
29   function safeMul(uint a, uint b) internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function safeSub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c>=a && c>=b);
43     return c;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) throw;
48   }
49 }
50 /*-------------------------------------------------------------------------*/
51 contract HeliumNetwork is owned, SafeMath {
52 	
53 	address public HeliumNetworkAddress 	= this;
54 	address public creator 				= msg.sender;
55     string 	public name 				= "Helium Network";
56     string 	public symbol 				= "HN";
57     uint8 	public decimals 			= 18;											    
58     uint256 public totalSupply 			= 999999999000000000000000000;
59     uint256 public buyPrice 			= 8888888;
60 	uint256 public sellPrice 			= 8888888;
61    	
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 	mapping (address => bool) public frozenAccount;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);				
67     event FundTransfer(address backer, uint amount, bool isContribution);
68      // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value);
70 	event FrozenFunds(address target, bool frozen);
71     
72     /**
73      * Constrctor function
74      *
75      * Initializes contract with initial supply tokens to the creator of the contract
76      */
77     function HeliumNetwork() public {
78         balanceOf[msg.sender] = totalSupply;    											
79 		creator = msg.sender;
80     }
81     /**
82      * Internal transfer, only can be called by this contract
83      */
84     function _transfer(address _from, address _to, uint _value) internal {
85         // Prevent transfer to 0x0 address. Use burn() instead
86         require(_to != 0x0);
87         // Check if the sender has enough
88         require(balanceOf[_from] >= _value);
89         // Check for overflows
90         require(balanceOf[_to] + _value >= balanceOf[_to]);
91         // Subtract from the sender
92         balanceOf[_from] -= _value;
93         // Add the same to the recipient
94         balanceOf[_to] += _value;
95         Transfer(_from, _to, _value);
96     }
97 
98     /**
99      * Transfer tokens
100      *
101      * Send `_value` tokens to `_to` from your account
102      *
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transfer(address _to, uint256 _value) public {
107         _transfer(msg.sender, _to, _value);
108     }
109     
110     /// @notice Buy tokens from contract by sending ether
111     function () payable internal {
112         uint amount = msg.value * buyPrice ; 
113 		uint amountRaised;
114 		uint bonus = 0;
115 		
116 		bonus = getBonus(amount);
117 		amount = amount +  bonus;
118 		
119 		//amount = now ;
120 		
121         require(balanceOf[creator] >= amount);               				
122         require(msg.value > 0);
123 		amountRaised = safeAdd(amountRaised, msg.value);                    
124 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);     
125         balanceOf[creator] = safeSub(balanceOf[creator], amount);           
126         Transfer(creator, msg.sender, amount);               				
127         creator.transfer(amountRaised);
128     }
129 	
130 	/// @notice Create `mintedAmount` tokens and send it to `target`
131     /// @param target Address to receive the tokens
132     /// @param mintedAmount the amount of tokens it will receive
133     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
134         balanceOf[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         Transfer(0, this, mintedAmount);
137         Transfer(this, target, mintedAmount);
138     }
139 
140 	
141 	/**
142      * Set allowance for other address
143      *
144      * Allows `_spender` to spend no more than `_value` tokens in your behalf
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      */
149     function approve(address _spender, uint256 _value) public
150         returns (bool success) {
151         allowance[msg.sender][_spender] = _value;
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address and notify
157      *
158      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      * @param _extraData some extra information to send to the approved contract
163      */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
165         public
166         returns (bool success) {
167         tokenRecipient spender = tokenRecipient(_spender);
168         if (approve(_spender, _value)) {
169             spender.receiveApproval(msg.sender, _value, this, _extraData);
170             return true;
171         }
172     }
173 	
174     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175     /// @param target Address to be frozen
176     /// @param freeze either to freeze it or not
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         FrozenFunds(target, freeze);
180     }
181 
182     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
183     /// @param newSellPrice Price the users can sell to the contract
184     /// @param newBuyPrice Price users can buy from the contract
185     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
186         sellPrice = newSellPrice;
187         buyPrice = newBuyPrice;
188     }
189 	
190 	
191 	/**
192      * Destroy tokens
193      *
194      * Remove `_value` tokens from the system irreversibly
195      *
196      * @param _value the amount of money to burn
197      */
198     function burn(uint256 _value) public returns (bool success) {
199         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
200         balanceOf[msg.sender] -= _value;            // Subtract from the sender
201         totalSupply -= _value;                      // Updates totalSupply
202         Burn(msg.sender, _value);
203         return true;
204     }
205 	
206 	/**
207      * Destroy tokens from other account
208      *
209      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
210      *
211      * @param _from the address of the sender
212      * @param _value the amount of money to burn
213      */
214     function burnFrom(address _from, uint256 _value) public returns (bool success) {
215         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
216         require(_value <= allowance[_from][msg.sender]);    // Check allowance
217         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
218         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
219         totalSupply -= _value;                              // Update totalSupply
220         Burn(_from, _value);
221         return true;
222     }
223 	
224 	function getBonus(uint _amount) constant private returns (uint256) {
225         
226 		if(now >= 1524873600 && now <= 1527551999) { 
227             return _amount * 50 / 100;
228         }
229 		
230 		if(now >= 1527552000 && now <= 1530316799) { 
231             return _amount * 40 / 100;
232         }
233 		
234 		if(now >= 1530316800 && now <= 1532995199) { 
235             return _amount * 30 / 100;
236         }
237 		
238 		if(now >= 1532995200 && now <= 1535759999) { 
239             return _amount * 20 / 100;
240         }
241 		
242 		if(now >= 1535760000 && now <= 1538438399) { 
243             return _amount * 10 / 100;
244         }
245 		
246         return 0;
247     }
248 	
249 	/// @notice Sell `amount` tokens to contract
250     /// @param amount amount of tokens to be sold
251     function sell(uint256 amount) public {
252         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
253         _transfer(msg.sender, this, amount);              // makes the transfers
254         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
255     }
256 	
257  }
258 /*-------------------------------------------------------------------------*/
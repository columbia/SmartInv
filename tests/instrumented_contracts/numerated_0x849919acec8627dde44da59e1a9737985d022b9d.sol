1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constructor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount -- wei
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address and notify
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      * @param _extraData some extra information to send to the approved contract
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
129         public
130         returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 
138     /**
139      * Destroy tokens
140      *
141      * Remove `_value` tokens from the system irreversibly
142      *
143      * @param _value the amount of money to burn
144      */
145     function burn(uint256 _value) public returns (bool success) {
146         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
147         balanceOf[msg.sender] -= _value;            // Subtract from the sender
148         totalSupply -= _value;                      // Updates totalSupply
149         Burn(msg.sender, _value);
150         return true;
151     }
152 
153     /**
154      * Destroy tokens from other account
155      *
156      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
157      *
158      * @param _from the address of the sender
159      * @param _value the amount of money to burn
160      */
161     function burnFrom(address _from, uint256 _value) public returns (bool success) {
162         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
163         require(_value <= allowance[_from][msg.sender]);    // Check allowance
164         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
165         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
166         totalSupply -= _value;                              // Update totalSupply
167         Burn(_from, _value);
168         return true;
169     }
170 }
171 
172 /*************************************************/
173 /**  Author   : Stryper                         **/
174 /**  Contents : ChatBit Custom Crypto Currency  **/
175 /**  Date     : 2018. 12 ~                      **/
176 /*************************************************/
177 
178 contract ChatBitToken is owned, TokenERC20 {
179 
180     uint256 public sellPrice = 20180418134311;        // Initialization with default value
181     uint256 public buyPrice = 1000000000000000000;    // Initialization with default value
182 	uint256 public limitAMT = 0;
183 	bool public isPreSales = false;
184 
185     mapping (address => bool) public frozenAccount;
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     event FrozenFunds(address target, bool frozen);
189 
190     /* Initializes contract with initial supply tokens to the creator of the contract */
191     function ChatBitToken(
192         uint256 initialSupply,
193         string tokenName,
194         string tokenSymbol
195     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);               // Check if the sender has enough
201         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
202         require(!frozenAccount[_from]);                     // Check if sender is frozen
203         require(!frozenAccount[_to]);                       // Check if recipient is frozen
204         balanceOf[_from] -= _value;                         // Subtract from the sender
205         balanceOf[_to] += _value;                           // Add the same to the recipient
206         Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
213         balanceOf[target] += mintedAmount;
214         totalSupply += mintedAmount;
215         Transfer(0, this, mintedAmount);
216         Transfer(this, target, mintedAmount);
217     }
218 
219     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
220     /// @param target Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address target, bool freeze) onlyOwner public {
223         frozenAccount[target] = freeze;
224         FrozenFunds(target, freeze);
225     }
226 
227     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
228     /// @param newSellPrice Price the users can sell to the contract
229     /// @param newBuyPrice Price users can buy from the contract
230     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
231         sellPrice = newSellPrice;
232         buyPrice = newBuyPrice;
233     }
234 
235 	/// @notice Start presales with initializing presales amount
236 	/// @param amtPreSales The amount of presales
237     function startPreSales(uint256 amtPreSales) onlyOwner public returns (uint256) {
238 	    require (balanceOf[owner] - amtPreSales > 0);
239         limitAMT = balanceOf[owner] - amtPreSales;
240 		isPreSales = true;
241 		return limitAMT;
242 	}
243 
244 	/// @notice Stop presales with setting state variable
245     function stopPreSales() onlyOwner public {
246 	    isPreSales = false;
247 	}
248 
249     /// @notice Buy tokens from contract by sending ether
250 /*************************************************************
251 //////////////////////////////////////////////////////////////
252 ///    function buy() payable public {
253 ///        uint amount = msg.value / buyPrice;               // calculates the amount
254 ///        _transfer(this, msg.sender, amount);              // makes the transfers
255 ///    }
256 //////////////////////////////////////////////////////////////
257 *************************************************************/
258 
259     /// @notice Sell `amount` tokens to contract
260     /// @param amount amount of tokens to be sold
261 /*************************************************************
262 //////////////////////////////////////////////////////////////
263 ///    function sell(uint256 amount) public {
264 ///        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
265 ///        _transfer(msg.sender, this, amount);              // makes the transfers
266 ///        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
267 ///    }
268 //////////////////////////////////////////////////////////////
269 *************************************************************/
270 
271     /// @notice Get taitoss transaction amount
272 	/// @param amtETH The amount of ether to convert with taitoss
273 	function getTaiAMT(uint256 amtETH) public constant returns (uint256) {
274         uint256 amount = amtETH / buyPrice;                    
275         amount = amount * 10 ** uint256(decimals);             
276 		return amount;
277 	}
278 
279 	/// @notice Get the balance of taitoss
280 	function getBalanceTAI() public constant returns (uint256) {
281 	    uint256 balTAI;
282 		balTAI = balanceOf[msg.sender];
283 		return balTAI;
284 	}
285 
286 	function getSalesPrice() public constant returns (uint256) {
287 		return buyPrice;
288 	}
289 
290 	function getLeftPreSalesAMT() public constant returns (uint256) {
291 	    uint256 leftPSAMT;
292 		leftPSAMT = balanceOf[owner] - limitAMT;
293 		return leftPSAMT;
294 	}
295 
296     /// @notice Process presales transactions
297     function procPreSales() payable public returns (uint256) {
298         require (isPreSales == true);
299         uint256 amount = msg.value / buyPrice;                 // calculates the amount
300         amount = amount * 10 ** uint256(decimals);             // calculates the amount
301 	    if ( balanceOf[owner] - amount <= limitAMT ){
302 		    isPreSales = false;
303 		}
304         _transfer(owner, msg.sender, amount);
305 		owner.transfer(msg.value);
306 		return amount;
307     }
308 
309 	/// @notice Process normal sales transactions
310     function procNormalSales() payable public returns (uint256) {
311         uint256 amount = msg.value / buyPrice;                 // calculates the amount
312         amount = amount * 10 ** uint256(decimals);             // calculates the amount
313         _transfer(owner, msg.sender, amount);
314 		owner.transfer(msg.value);
315 		return amount;
316     }
317 
318 	/// @notice Process owner's buyback
319 	/// @param seller Seller's EOA account address
320     function procNormalBuyBack(address seller) onlyOwner payable public returns (uint256) {
321         uint256 amount = msg.value / buyPrice;                 // calculates the amount
322         amount = amount * 10 ** uint256(decimals);             // calculates the amount
323         _transfer(seller, msg.sender, amount);
324 		seller.transfer(msg.value);
325 		return amount;
326     }
327 
328 }
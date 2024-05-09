1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Luxury Goods Exchange' contract
5 //
6 // Deployed to : 0x219690C50d3489D6a279362a920dC67120545fac
7 // Symbol      : LUX
8 // Name        : Luxury Goods Coin
9 // Total supply: 5000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 contract owned {
67     address public owner;
68 
69     function owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address newOwner) onlyOwner public {
79         owner = newOwner;
80     }
81 }
82 
83 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
84 
85 contract TokenERC20 {
86     // Public variables of the token
87     string public name;
88     string public symbol;
89     uint8 public decimals = 18;
90     // 18 decimals is the strongly suggested default, avoid changing it
91     uint256 public totalSupply;
92 
93     // This creates an array with all balances
94     mapping (address => uint256) public balanceOf;
95     mapping (address => mapping (address => uint256)) public allowance;
96 
97     // This generates a public event on the blockchain that will notify clients
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     // This notifies clients about the amount burnt
101     event Burn(address indexed from, uint256 value);
102 
103     /**
104      * Constructor function
105      *
106      * Initializes contract with initial supply tokens to the creator of the contract
107      */
108     function TokenERC20(
109         uint256 initialSupply,
110         string tokenName,
111         string tokenSymbol
112     ) public {
113         totalSupply = initialSupply * 10 ** uint256(decimals);   // Update total supply with the decimal amount -- wei
114         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
115         name = tokenName;                                       // Set the name for display purposes
116         symbol = tokenSymbol;                                  // Set the symbol for display purposes
117     }
118 
119     /**
120      * Internal transfer, only can be called by this contract
121      */
122     function _transfer(address _from, address _to, uint _value) internal {
123         // Prevent transfer to 0x0 address. Use burn() instead
124         require(_to != 0x0);
125         // Check if the sender has enough
126         require(balanceOf[_from] >= _value);
127         // Check for overflows
128         require(balanceOf[_to] + _value > balanceOf[_to]);
129         // Save this for an assertion in the future
130         uint previousBalances = balanceOf[_from] + balanceOf[_to];
131         // Subtract from the sender
132         balanceOf[_from] -= _value;
133         // Add the same to the recipient
134         balanceOf[_to] += _value;
135         Transfer(_from, _to, _value);
136         // Asserts are used to use static analysis to find bugs in your code. They should never fail
137         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
138     }
139 
140     /**
141      * Transfer tokens
142      *
143      * Send `_value` tokens to `_to` from your account
144      *
145      * @param _to The address of the recipient
146      * @param _value the amount to send
147      */
148     function transfer(address _to, uint256 _value) public {
149         _transfer(msg.sender, _to, _value);
150     }
151 
152     /**
153      * Transfer tokens from other address
154      *
155      * Send `_value` tokens to `_to` in behalf of `_from`
156      *
157      * @param _from The address of the sender
158      * @param _to The address of the recipient
159      * @param _value the amount to send
160      */
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
162         require(_value <= allowance[_from][msg.sender]);     // Check allowance
163         allowance[_from][msg.sender] -= _value;
164         _transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169      * Set allowance for other address
170      *
171      * Allows `_spender` to spend no more than `_value` tokens in your behalf
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      */
176     function approve(address _spender, uint256 _value) public
177         returns (bool success) {
178         allowance[msg.sender][_spender] = _value;
179         return true;
180     }
181 
182     /**
183      * Set allowance for other address and notify
184      *
185      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
186      *
187      * @param _spender The address authorized to spend
188      * @param _value the max amount they can spend
189      * @param _extraData some extra information to send to the approved contract
190      */
191     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
192         public
193         returns (bool success) {
194         tokenRecipient spender = tokenRecipient(_spender);
195         if (approve(_spender, _value)) {
196             spender.receiveApproval(msg.sender, _value, this, _extraData);
197             return true;
198         }
199     }
200 
201 }
202 
203 /*************************************************/
204 /**  Author   : HqAD07                          **/
205 /**  Contents : LuxuryGoods Crypto Currency     **/
206 /**  Date     : 2019. 05 ~                      **/
207 /*************************************************/
208 
209 contract LuxuryGoodsCoin is owned, TokenERC20 {
210 
211     uint256 public sellPrice = 20180418134311;        // Initialization with default value
212     uint256 public buyPrice = 1000000000000000000;    // Initialization with default value
213 	uint256 public limitAMT = 0;
214 	bool public isPreSales = false;
215 
216 
217      mapping (address => bool) public frozenAccount;
218 
219     /* This generates a public event on the blockchain that will notify clients */
220     event FrozenFunds(address target, bool frozen);
221 
222     /* Initializes contract with initial supply tokens to the creator of the contract */
223     function LuxuryGoodsCoin(
224         uint256 initialSupply,
225         string tokenName,
226         string tokenSymbol
227     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
228 
229     /* Internal transfer, only can be called by this contract */
230     function _transfer(address _from, address _to, uint _value) internal {
231         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
232         require (balanceOf[_from] >= _value);               // Check if the sender has enough
233         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
234         require(!frozenAccount[_from]);                     // Check if sender is frozen
235         require(!frozenAccount[_to]);                       // Check if recipient is frozen
236         balanceOf[_from] -= _value;                         // Subtract from the sender
237         balanceOf[_to] += _value;                           // Add the same to the recipient
238         Transfer(_from, _to, _value);
239     }
240 
241     /// @notice Create `mintedAmount` tokens and send it to `target`
242     /// @param target Address to receive the tokens
243     /// @param mintedAmount the amount of tokens it will receive
244     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
245         balanceOf[target] += mintedAmount;
246         totalSupply += mintedAmount;
247         Transfer(0, this, mintedAmount);
248         Transfer(this, target, mintedAmount);
249     }
250 
251     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
252     /// @param target Address to be frozen
253     /// @param freeze either to freeze it or not
254     function freezeAccount(address target, bool freeze) onlyOwner public {
255         frozenAccount[target] = freeze;
256         FrozenFunds(target, freeze);
257     }
258 
259     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
260     /// @param newSellPrice Price the users can sell to the contract
261     /// @param newBuyPrice Price users can buy from the contract
262     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
263         sellPrice = newSellPrice;
264         buyPrice = newBuyPrice;
265     }
266 
267 	/// @notice Start presales with initializing presales amount
268 	/// @param amtPreSales The amount of presales
269     function startPreSales(uint256 amtPreSales) onlyOwner public returns (uint256) {
270 	    require (balanceOf[owner] - amtPreSales > 0);
271         limitAMT = balanceOf[owner] - amtPreSales;
272 		isPreSales = true;
273 		return limitAMT;
274 	}
275 
276 	/// @notice Stop presales with setting state variable
277     function stopPreSales() onlyOwner public {
278 	    isPreSales = false;
279 	}
280 
281     /// @notice Buy tokens from contract by sending ether
282 /*************************************************************
283 //////////////////////////////////////////////////////////////
284 ///    function buy() payable public {
285 ///        uint amount = msg.value / buyPrice;               // calculates the amount
286 ///        _transfer(this, msg.sender, amount);              // makes the transfers
287 ///    }
288 //////////////////////////////////////////////////////////////
289 *************************************************************/
290 
291     /// @notice Sell `amount` tokens to contract
292     /// @param amount amount of tokens to be sold
293 /*************************************************************
294 //////////////////////////////////////////////////////////////
295 ///    function sell(uint256 amount) public {
296 ///        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
297 ///        _transfer(msg.sender, this, amount);              // makes the transfers
298 ///        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
299 ///    }
300 //////////////////////////////////////////////////////////////
301 *************************************************************/
302 
303     /// @notice Get LuxuryGoodsCoin transaction amount
304 	/// @param amtETH The amount of ether to convert with LuxuryGoodsCoin
305 	function getLuxAMT(uint256 amtETH) public constant returns (uint256) {
306         uint256 amount = amtETH / buyPrice;                    
307         amount = amount * 10 ** uint256(decimals);             
308 		return amount;
309 	}
310 
311 	/// @notice Get the balance of LuxuryGoodsCoin
312 	function getBalanceLux() public constant returns (uint256) {
313 	    uint256 balLUX;
314 		balLUX = balanceOf[msg.sender];
315 		return balLUX;
316 	}
317 
318 	function getSalesPrice() public constant returns (uint256) {
319 		return buyPrice;
320 	}
321 
322 	function getLeftPreSalesAMT() public constant returns (uint256) {
323 	    uint256 leftPSAMT;
324 		leftPSAMT = balanceOf[owner] - limitAMT;
325 		return leftPSAMT;
326 	}
327 
328     /// @notice Process presales transactions
329     function procPreSales() payable public returns (uint256) {
330         require (isPreSales == true);
331         uint256 amount = msg.value / buyPrice;                 // calculates the amount
332         amount = amount * 10 ** uint256(decimals);             // calculates the amount
333 	    if ( balanceOf[owner] - amount <= limitAMT ){
334 		    isPreSales = false;
335 		}
336         _transfer(owner, msg.sender, amount);
337 		owner.transfer(msg.value);
338 		return amount;
339     }
340 
341 	/// @notice Process normal sales transactions
342     function procNormalSales() payable public returns (uint256) {
343         uint256 amount = msg.value / buyPrice;                 // calculates the amount
344         amount = amount * 10 ** uint256(decimals);             // calculates the amount
345         _transfer(owner, msg.sender, amount);
346 		owner.transfer(msg.value);
347 		return amount;
348     }
349 
350 	/// @notice Process owner's buyback
351 	/// @param seller Seller's EOA account address
352     function procNormalBuyBack(address seller) onlyOwner payable public returns (uint256) {
353         uint256 amount = msg.value / buyPrice;                 // calculates the amount
354         amount = amount * 10 ** uint256(decimals);             // calculates the amount
355         _transfer(seller, msg.sender, amount);
356 		seller.transfer(msg.value);
357 		return amount;
358     }
359 
360 }
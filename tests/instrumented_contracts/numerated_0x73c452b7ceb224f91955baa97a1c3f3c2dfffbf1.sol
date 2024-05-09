1 /**
2  * Multigames MLT Token Crodwsale contract
3  * Version 1.00
4  * www.MultiGames.mobi
5  **/
6  
7  
8 pragma solidity ^0.4.18;
9 
10 /**
11  * @title Crowdsale
12  * @dev Crowdsale is a base contract for managing a token crowdsale.
13 *  Funds collected are forwarded to a wallet
14  * as they arrive.
15  */
16 
17 
18 contract Crowdsale {
19   //using SafeMath for uint256;
20 
21   // The token being sold
22   MultiGamesToken public token;
23 
24   // address where funds are collected
25   address public wallet;
26 
27   // how many token units a buyer gets per wei
28   uint256 public rate;
29 
30   // amount of raised money in wei
31   uint256 public weiRaised;
32 
33   // token's account
34   address tokenStockAddress;
35 
36   /**
37    * event for token purchase logging
38    * @param purchaser who paid for the tokens
39    * @param beneficiary who got the tokens
40    * @param value weis paid for purchase
41    * @param amount amount of tokens purchased
42    */
43   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
44 
45 
46 
47 
48  function Crowdsale( ) public {
49         wallet =   0x1Bd870F2292D69eF123e3758886671E707371CEc;
50         tokenStockAddress = wallet;
51         rate = 100 ;
52         token = MultiGamesToken(0x52a5E1a56A124dcE84e548Ff96122246E46D599f);
53   }
54 
55 
56   // fallback function can be used to buy tokens
57   function () external payable {
58     buyTokens(msg.sender);
59   }
60 
61   // low level token purchase function
62   function buyTokens(address beneficiary) public payable {
63     require(beneficiary != address(0));
64     require(msg.value != 0);
65 
66     uint256 weiAmount = msg.value;
67 
68     // calculate token amount to be created
69     uint256 tokens = weiAmount * rate;
70 
71     // update state
72     weiRaised = weiRaised + weiAmount;
73 
74     // debug
75     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
76     //token.transfer(msg.sender, tokens);
77     token.transferFrom(tokenStockAddress, msg.sender, tokens); 
78 
79     forwardFunds();
80   }
81 
82   // send ether to the fund collection wallet
83   // override to create custom fund forwarding mechanisms
84   function forwardFunds() internal {
85     wallet.transfer(msg.value);
86   }
87  
88   function setRate(uint newRate) external payable {
89 	require(msg.sender == wallet);
90 	rate = newRate;
91 	}
92 }
93 
94 
95 
96   // ----------------------------------------------------------------------------------------------
97   // MultiGames Token Contract, version 2.00
98   // Interwave Global
99   // www.iw-global.com
100   // ----------------------------------------------------------------------------------------------
101 
102 contract owned {
103     address public owner;
104 
105     function owned() public {
106         owner = msg.sender;
107     }
108 
109     modifier onlyOwner {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     function transferOwnership(address newOwner) onlyOwner public {
115         owner = newOwner;
116     }
117 }
118 
119 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
120 
121 contract TokenERC20 {
122     // Public variables of the token
123     string public name  ;
124     string public symbol  ;
125     uint8 public decimals = 18;
126     // 18 decimals is the strongly suggested default, avoid changing it
127     uint256 public totalSupply ;
128 
129     // This creates an array with all balances
130     mapping (address => uint256) public balanceOf;
131     mapping (address => mapping (address => uint256)) public allowance;
132 
133     // This generates a public event on the blockchain that will notify clients
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 
136     // This notifies clients about the amount burnt
137     event Burn(address indexed from, uint256 value);
138 
139     /**
140      * Constrctor function
141      *
142      * Initializes contract with initial supply tokens to the creator of the contract
143      */
144     function TokenERC20(
145         uint256 initialSupply,
146         string tokenName,
147         string tokenSymbol
148     ) public {
149         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
150         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
151         name = tokenName;                                   // Set the name for display purposes
152         symbol = tokenSymbol;                               // Set the symbol for display purposes
153     }
154 
155     /**
156      * Internal transfer, only can be called by this contract
157      */
158     function _transfer(address _from, address _to, uint _value) internal {
159         // Prevent transfer to 0x0 address. Use burn() instead
160         require(_to != 0x0);
161         // Check if the sender has enough
162         require(balanceOf[_from] >= _value);
163         // Check for overflows
164         require(balanceOf[_to] + _value > balanceOf[_to]);
165         // Save this for an assertion in the future
166         uint previousBalances = balanceOf[_from] + balanceOf[_to];
167         // Subtract from the sender
168         balanceOf[_from] -= _value;
169         // Add the same to the recipient
170         balanceOf[_to] += _value;
171         Transfer(_from, _to, _value);
172         // Asserts are used to use static analysis to find bugs in your code. They should never fail
173         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
174     }
175 
176     /**
177      * Transfer tokens
178      *
179      * Send `_value` tokens to `_to` from your account
180      *
181      * @param _to The address of the recipient
182      * @param _value the amount to send
183      */
184     function transfer(address _to, uint256 _value) public {
185         _transfer(msg.sender, _to, _value);
186     }
187 
188     /**
189      * Transfer tokens from other address
190      *
191      * Send `_value` tokens to `_to` in behalf of `_from`
192      *
193      * @param _from The address of the sender
194      * @param _to The address of the recipient
195      * @param _value the amount to send
196      */
197     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
198         require(_value <= allowance[_from][msg.sender]);     // Check allowance
199         allowance[_from][msg.sender] -= _value;
200         _transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205      * Set allowance for other address
206      *
207      * Allows `_spender` to spend no more than `_value` tokens in your behalf
208      *
209      * @param _spender The address authorized to spend
210      * @param _value the max amount they can spend
211      */
212     function approve(address _spender, uint256 _value) public
213         returns (bool success) {
214         allowance[msg.sender][_spender] = _value;
215         return true;
216     }
217 
218     /**
219      * Set allowance for other address and notify
220      *
221      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
222      *
223      * @param _spender The address authorized to spend
224      * @param _value the max amount they can spend
225      * @param _extraData some extra information to send to the approved contract
226      */
227     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
228         public
229         returns (bool success) {
230         tokenRecipient spender = tokenRecipient(_spender);
231         if (approve(_spender, _value)) {
232             spender.receiveApproval(msg.sender, _value, this, _extraData);
233             return true;
234         }
235     }
236 
237     /**
238      * Destroy tokens
239      *
240      * Remove `_value` tokens from the system irreversibly
241      *
242      * @param _value the amount of money to burn
243      */
244     function burn(uint256 _value) public returns (bool success) {
245         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
246         balanceOf[msg.sender] -= _value;            // Subtract from the sender
247         totalSupply -= _value;                      // Updates totalSupply
248         Burn(msg.sender, _value);
249         return true;
250     }
251 
252     /**
253      * Destroy tokens from other account
254      *
255      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
256      *
257      * @param _from the address of the sender
258      * @param _value the amount of money to burn
259      */
260     function burnFrom(address _from, uint256 _value) public returns (bool success) {
261         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
262         require(_value <= allowance[_from][msg.sender]);    // Check allowance
263         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
264         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
265         totalSupply -= _value;                              // Update totalSupply
266         Burn(_from, _value);
267         return true;
268     }
269 }
270 
271 /******************************************/
272 /*       ADVANCED TOKEN STARTS HERE       */
273 /******************************************/
274 
275 contract MultiGamesToken is owned, TokenERC20 {
276 
277     uint256 public sellPrice;
278     uint256 public buyPrice;
279 
280     mapping (address => bool) public frozenAccount;
281 
282     /* This generates a public event on the blockchain that will notify clients */
283     event FrozenFunds(address target, bool frozen);
284 
285     /* Initializes contract with initial supply tokens to the creator of the contract */
286     function MultiGamesToken(
287 
288     ) 
289 
290     TokenERC20(10000000, "MultiGames", "MLT") public {}
291     
292     /* Internal transfer, only can be called by this contract */
293     function _transfer(address _from, address _to, uint _value) internal {
294         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
295         require (balanceOf[_from] > _value);                // Check if the sender has enough
296         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
297         require(!frozenAccount[_from]);                     // Check if sender is frozen
298         require(!frozenAccount[_to]);                       // Check if recipient is frozen
299         balanceOf[_from] -= _value;                         // Subtract from the sender
300         balanceOf[_to] += _value;                           // Add the same to the recipient
301         Transfer(_from, _to, _value);
302     }
303 
304     /// @notice Create `mintedAmount` tokens and send it to `target`
305     /// @param target Address to receive the tokens
306     /// @param mintedAmount the amount of tokens it will receive
307     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
308         balanceOf[target] += mintedAmount;
309         totalSupply += mintedAmount;
310         Transfer(0, this, mintedAmount);
311         Transfer(this, target, mintedAmount);
312     }
313 
314     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
315     /// @param target Address to be frozen
316     /// @param freeze either to freeze it or not
317     function freezeAccount(address target, bool freeze) onlyOwner public {
318         frozenAccount[target] = freeze;
319         FrozenFunds(target, freeze);
320     }
321 
322     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
323     /// @param newSellPrice Price the users can sell to the contract
324     /// @param newBuyPrice Price users can buy from the contract
325     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
326         sellPrice = newSellPrice;
327         buyPrice = newBuyPrice;
328     }
329 
330     /// @notice Buy tokens from contract by sending ether
331     function buy() payable public {
332         uint amount = msg.value / buyPrice;               // calculates the amount
333         _transfer(this, msg.sender, amount);              // makes the transfers
334     }
335 
336     /// @notice Sell `amount` tokens to contract
337     /// @param amount amount of tokens to be sold
338     function sell(uint256 amount) public {
339         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
340         _transfer(msg.sender, this, amount);              // makes the transfers
341         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
342     }
343 }
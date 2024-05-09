1 /**
2  * Multigames TrueGoldCoin Token & Crodwsale contract
3  * Version 1.00
4  * www.TrueGoldCoin.com
5  * Interwave Global
6  * www.iw-global.com
7  **/
8  
9  
10 pragma solidity ^0.4.18;
11 
12 /**
13  * @title Crowdsale
14  * @dev Crowdsale is a base contract for managing a token crowdsale.
15 *  Funds collected are forwarded to a wallet
16  * as they arrive.
17  */
18 
19 
20 contract Crowdsale {
21   //using SafeMath for uint256;
22 
23   // The token being sold
24   TrueGoldCoinToken public token;
25 
26   // address where funds are collected
27   address public wallet;
28 
29   // how many token units a buyer gets per wei
30   uint256 public rate;
31 
32   // amount of raised money in wei
33   uint256 public weiRaised;
34 
35   // token's account
36   address tokenStockAddress;
37 
38   /**
39    * event for token purchase logging
40    * @param purchaser who paid for the tokens
41    * @param beneficiary who got the tokens
42    * @param value weis paid for purchase
43    * @param amount amount of tokens purchased
44    */
45   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
46 
47 
48 
49 
50  function Crowdsale( ) public {
51         wallet =   0xB8d4b5001946E6c46e39F1B85B69BbfDaB87EeBa;
52         tokenStockAddress = wallet;
53         rate = 100 ;
54         token = TrueGoldCoinToken(0xE51601f59A610DAc06868aa711A05e9a4e291256);
55   }
56 
57 
58   // fallback function can be used to buy tokens
59   function () external payable {
60     buyTokens(msg.sender);
61   }
62 
63   // low level token purchase function
64   function buyTokens(address beneficiary) public payable {
65     require(beneficiary != address(0));
66     require(msg.value != 0);
67 
68     uint256 weiAmount = msg.value;
69 
70     // calculate token amount to be created
71     uint256 tokens = weiAmount * rate;
72 
73     // update state
74     weiRaised = weiRaised + weiAmount;
75 
76     // debug
77     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
78     //token.transfer(msg.sender, tokens);
79     token.transferFrom(tokenStockAddress, msg.sender, tokens); 
80 
81     forwardFunds();
82   }
83 
84   // send ether to the fund collection wallet
85   // override to create custom fund forwarding mechanisms
86   function forwardFunds() internal {
87     wallet.transfer(msg.value);
88   }
89  
90   function setRate(uint newRate) external payable {
91 	require(msg.sender == wallet);
92 	rate = newRate;
93 	}
94 }
95 
96 
97   // ----------------------------------------------------------------------------------------------
98   // TrueGoldCoin Token Contract, version 2.00
99   // www.TrueGoldCoin.com
100   // Interwave Global
101   // www.iw-global.com
102   // ----------------------------------------------------------------------------------------------
103  
104 pragma solidity ^0.4.18;
105 
106 contract owned {
107     address public owner;
108 
109     function owned() public {
110         owner = msg.sender;
111     }
112 
113     modifier onlyOwner {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     function transferOwnership(address newOwner) onlyOwner public {
119         owner = newOwner;
120     }
121 }
122 
123 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
124 
125 contract TokenERC20 {
126     // Public variables of the token
127     string public name  ;
128     string public symbol  ;
129     uint8 public decimals = 18;
130     // 18 decimals is the strongly suggested default, avoid changing it
131     uint256 public totalSupply ;
132 
133     // This creates an array with all balances
134     mapping (address => uint256) public balanceOf;
135     mapping (address => mapping (address => uint256)) public allowance;
136 
137     // This generates a public event on the blockchain that will notify clients
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     // This notifies clients about the amount burnt
141     event Burn(address indexed from, uint256 value);
142 
143     /**
144      * Constrctor function
145      *
146      * Initializes contract with initial supply tokens to the creator of the contract
147      */
148     function TokenERC20(
149         uint256 initialSupply,
150         string tokenName,
151         string tokenSymbol
152     ) public {
153         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
154         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
155         name = tokenName;                                   // Set the name for display purposes
156         symbol = tokenSymbol;                               // Set the symbol for display purposes
157     }
158 
159     /**
160      * Internal transfer, only can be called by this contract
161      */
162     function _transfer(address _from, address _to, uint _value) internal {
163         // Prevent transfer to 0x0 address. Use burn() instead
164         require(_to != 0x0);
165         // Check if the sender has enough
166         require(balanceOf[_from] >= _value);
167         // Check for overflows
168         require(balanceOf[_to] + _value > balanceOf[_to]);
169         // Save this for an assertion in the future
170         uint previousBalances = balanceOf[_from] + balanceOf[_to];
171         // Subtract from the sender
172         balanceOf[_from] -= _value;
173         // Add the same to the recipient
174         balanceOf[_to] += _value;
175         Transfer(_from, _to, _value);
176         // Asserts are used to use static analysis to find bugs in your code. They should never fail
177         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
178     }
179 
180     /**
181      * Transfer tokens
182      *
183      * Send `_value` tokens to `_to` from your account
184      *
185      * @param _to The address of the recipient
186      * @param _value the amount to send
187      */
188     function transfer(address _to, uint256 _value) public {
189         _transfer(msg.sender, _to, _value);
190     }
191 
192     /**
193      * Transfer tokens from other address
194      *
195      * Send `_value` tokens to `_to` in behalf of `_from`
196      *
197      * @param _from The address of the sender
198      * @param _to The address of the recipient
199      * @param _value the amount to send
200      */
201     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
202         require(_value <= allowance[_from][msg.sender]);     // Check allowance
203         allowance[_from][msg.sender] -= _value;
204         _transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209      * Set allowance for other address
210      *
211      * Allows `_spender` to spend no more than `_value` tokens in your behalf
212      *
213      * @param _spender The address authorized to spend
214      * @param _value the max amount they can spend
215      */
216     function approve(address _spender, uint256 _value) public
217         returns (bool success) {
218         allowance[msg.sender][_spender] = _value;
219         return true;
220     }
221 
222     /**
223      * Set allowance for other address and notify
224      *
225      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
226      *
227      * @param _spender The address authorized to spend
228      * @param _value the max amount they can spend
229      * @param _extraData some extra information to send to the approved contract
230      */
231     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
232         public
233         returns (bool success) {
234         tokenRecipient spender = tokenRecipient(_spender);
235         if (approve(_spender, _value)) {
236             spender.receiveApproval(msg.sender, _value, this, _extraData);
237             return true;
238         }
239     }
240 
241     /**
242      * Destroy tokens
243      *
244      * Remove `_value` tokens from the system irreversibly
245      *
246      * @param _value the amount of money to burn
247      */
248     function burn(uint256 _value) public returns (bool success) {
249         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
250         balanceOf[msg.sender] -= _value;            // Subtract from the sender
251         totalSupply -= _value;                      // Updates totalSupply
252         Burn(msg.sender, _value);
253         return true;
254     }
255 
256     /**
257      * Destroy tokens from other account
258      *
259      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
260      *
261      * @param _from the address of the sender
262      * @param _value the amount of money to burn
263      */
264     function burnFrom(address _from, uint256 _value) public returns (bool success) {
265         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
266         require(_value <= allowance[_from][msg.sender]);    // Check allowance
267         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
268         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
269         totalSupply -= _value;                              // Update totalSupply
270         Burn(_from, _value);
271         return true;
272     }
273 }
274 
275 /******************************************/
276 /*       ADVANCED TOKEN STARTS HERE       */
277 /******************************************/
278 
279 contract TrueGoldCoinToken is owned, TokenERC20 {
280 
281     uint256 public sellPrice;
282     uint256 public buyPrice;
283 
284     mapping (address => bool) public frozenAccount;
285 
286     /* This generates a public event on the blockchain that will notify clients */
287     event FrozenFunds(address target, bool frozen);
288 
289     /* Initializes contract with initial supply tokens to the creator of the contract */
290     function TrueGoldCoinToken(
291 
292     ) 
293 
294     TokenERC20(10000000, "TrueGoldCoin", "TGC") public {}
295     
296     /* Internal transfer, only can be called by this contract */
297     function _transfer(address _from, address _to, uint _value) internal {
298         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
299         require (balanceOf[_from] > _value);                // Check if the sender has enough
300         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
301         require(!frozenAccount[_from]);                     // Check if sender is frozen
302         require(!frozenAccount[_to]);                       // Check if recipient is frozen
303         balanceOf[_from] -= _value;                         // Subtract from the sender
304         balanceOf[_to] += _value;                           // Add the same to the recipient
305         Transfer(_from, _to, _value);
306     }
307 
308     /// @notice Create `mintedAmount` tokens and send it to `target`
309     /// @param target Address to receive the tokens
310     /// @param mintedAmount the amount of tokens it will receive
311     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
312         balanceOf[target] += mintedAmount;
313         totalSupply += mintedAmount;
314         Transfer(0, this, mintedAmount);
315         Transfer(this, target, mintedAmount);
316     }
317 
318     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
319     /// @param target Address to be frozen
320     /// @param freeze either to freeze it or not
321     function freezeAccount(address target, bool freeze) onlyOwner public {
322         frozenAccount[target] = freeze;
323         FrozenFunds(target, freeze);
324     }
325 
326     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
327     /// @param newSellPrice Price the users can sell to the contract
328     /// @param newBuyPrice Price users can buy from the contract
329     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
330         sellPrice = newSellPrice;
331         buyPrice = newBuyPrice;
332     }
333 
334     /// @notice Buy tokens from contract by sending ether
335     function buy() payable public {
336         uint amount = msg.value / buyPrice;               // calculates the amount
337         _transfer(this, msg.sender, amount);              // makes the transfers
338     }
339 
340     /// @notice Sell `amount` tokens to contract
341     /// @param amount amount of tokens to be sold
342     function sell(uint256 amount) public {
343         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
344         _transfer(msg.sender, this, amount);              // makes the transfers
345         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
346     }
347 }
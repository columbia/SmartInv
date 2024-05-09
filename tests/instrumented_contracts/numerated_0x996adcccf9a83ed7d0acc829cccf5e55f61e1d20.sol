1 /**
2  * WHOIS Token Donations contract
3  * Version 1.00
4  * TrueValue Holdings
5  * www.ethWhois.com
6  * Interwave Global
7  * www.iw-global.com
8  **/
9  
10  
11 pragma solidity ^0.4.18;
12 
13 /**
14  * @title Crowdsale
15  * @dev Crowdsale is a base contract for managing a token crowdsale.
16 *  Funds collected are forwarded to a wallet
17  * as they arrive.
18  */
19 
20 
21 contract WHOISCrowdsale {
22   //using SafeMath for uint256;
23 
24   // The token being sold
25   WHOIS public token;
26 
27   // address where funds are collected
28   address public wallet;
29 
30   // how many token units a buyer gets per wei
31   uint256 public rate;
32 
33   // amount of raised money in wei
34   uint256 public weiRaised;
35 
36   // token's account
37   address tokenStockAddress;
38 
39   /**
40    * event for token purchase logging
41    * @param purchaser who paid for the tokens
42    * @param beneficiary who got the tokens
43    * @param value weis paid for purchase
44    * @param amount amount of tokens purchased
45    */
46   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
47 
48 /**
49  function Crowdsale( address ethDestination, address tokenSource, address tokenContract  ) public {
50         wallet =   ethDestination;
51         tokenStockAddress = tokenSource;
52         rate = 100 ;
53         token = WHOIS(tokenContract);
54   }
55 **/
56 
57 
58  function WHOISCrowdsale( ) public {
59         wallet =   0x22610b478e2087c18C0bbf173b7B6f4F137F2B72;
60         tokenStockAddress = wallet;
61         rate = 100 ;
62         token = WHOIS(0xBD0706f616b8D465d87583B727Df8478Ed1496fD);
63   }
64 
65 
66   // fallback function can be used to buy tokens
67   function () external payable {
68     buyTokens(msg.sender);
69   }
70 
71   // low level token purchase function
72   function buyTokens(address beneficiary) public payable {
73     require(beneficiary != address(0));
74     require(msg.value != 0);
75 
76     uint256 weiAmount = msg.value;
77 
78     // calculate token amount to be created
79     uint256 tokens = weiAmount * rate;
80 
81     // update state
82     weiRaised = weiRaised + weiAmount;
83 
84     // debug
85     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
86     //token.transfer(msg.sender, tokens);
87     token.transferFrom(tokenStockAddress, msg.sender, tokens); 
88 
89     forwardFunds();
90   }
91 
92   // send ether to the fund collection wallet
93   // override to create custom fund forwarding mechanisms
94   function forwardFunds() internal {
95     wallet.transfer(msg.value);
96   }
97  
98   function setRate(uint newRate) external payable {
99 	require(msg.sender == wallet);
100 	rate = newRate;
101 	}
102 }
103 
104 
105  /**
106  * WHOIS Token
107  * Version 1.00
108  * TrueValue Holdings
109  * Interwave Global
110  * www.iw-global.com
111  * www.ethWhois.com
112  **/
113  
114  
115 pragma solidity ^0.4.18;
116 
117 
118 contract owned {
119     address public owner;
120 
121     function owned() public {
122         owner = msg.sender;
123     }
124 
125     modifier onlyOwner {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     function transferOwnership(address newOwner) onlyOwner public {
131         owner = newOwner;
132     }
133 }
134 
135 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
136 
137 contract TokenERC20 {
138     // Public variables of the token
139     string public name  ;
140     string public symbol  ;
141     uint8 public decimals = 18;
142     // 18 decimals is the strongly suggested default, avoid changing it
143     uint256 public totalSupply ;
144 
145     // This creates an array with all balances
146     mapping (address => uint256) public balanceOf;
147     mapping (address => mapping (address => uint256)) public allowance;
148 
149     // This generates a public event on the blockchain that will notify clients
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     // This notifies clients about the amount burnt
153     event Burn(address indexed from, uint256 value);
154 
155     /**
156      * Constrctor function
157      *
158      * Initializes contract with initial supply tokens to the creator of the contract
159      */
160     function TokenERC20(
161         uint256 initialSupply,
162         string tokenName,
163         string tokenSymbol
164     ) public {
165         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
166         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
167         name = tokenName;                                   // Set the name for display purposes
168         symbol = tokenSymbol;                               // Set the symbol for display purposes
169     }
170 
171     /**
172      * Internal transfer, only can be called by this contract
173      */
174     function _transfer(address _from, address _to, uint _value) internal {
175         // Prevent transfer to 0x0 address. Use burn() instead
176         require(_to != 0x0);
177         // Check if the sender has enough
178         require(balanceOf[_from] >= _value);
179         // Check for overflows
180         require(balanceOf[_to] + _value > balanceOf[_to]);
181         // Save this for an assertion in the future
182         uint previousBalances = balanceOf[_from] + balanceOf[_to];
183         // Subtract from the sender
184         balanceOf[_from] -= _value;
185         // Add the same to the recipient
186         balanceOf[_to] += _value;
187         Transfer(_from, _to, _value);
188         // Asserts are used to use static analysis to find bugs in your code. They should never fail
189         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
190     }
191 
192     /**
193      * Transfer tokens
194      *
195      * Send `_value` tokens to `_to` from your account
196      *
197      * @param _to The address of the recipient
198      * @param _value the amount to send
199      */
200     function transfer(address _to, uint256 _value) public {
201         _transfer(msg.sender, _to, _value);
202     }
203 
204     /**
205      * Transfer tokens from other address
206      *
207      * Send `_value` tokens to `_to` in behalf of `_from`
208      *
209      * @param _from The address of the sender
210      * @param _to The address of the recipient
211      * @param _value the amount to send
212      */
213     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
214         require(_value <= allowance[_from][msg.sender]);     // Check allowance
215         allowance[_from][msg.sender] -= _value;
216         _transfer(_from, _to, _value);
217         return true;
218     }
219 
220     /**
221      * Set allowance for other address
222      *
223      * Allows `_spender` to spend no more than `_value` tokens in your behalf
224      *
225      * @param _spender The address authorized to spend
226      * @param _value the max amount they can spend
227      */
228     function approve(address _spender, uint256 _value) public
229         returns (bool success) {
230         allowance[msg.sender][_spender] = _value;
231         return true;
232     }
233 
234     /**
235      * Set allowance for other address and notify
236      *
237      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
238      *
239      * @param _spender The address authorized to spend
240      * @param _value the max amount they can spend
241      * @param _extraData some extra information to send to the approved contract
242      */
243     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
244         public
245         returns (bool success) {
246         tokenRecipient spender = tokenRecipient(_spender);
247         if (approve(_spender, _value)) {
248             spender.receiveApproval(msg.sender, _value, this, _extraData);
249             return true;
250         }
251     }
252 
253     /**
254      * Destroy tokens
255      *
256      * Remove `_value` tokens from the system irreversibly
257      *
258      * @param _value the amount of money to burn
259      */
260     function burn(uint256 _value) public returns (bool success) {
261         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
262         balanceOf[msg.sender] -= _value;            // Subtract from the sender
263         totalSupply -= _value;                      // Updates totalSupply
264         Burn(msg.sender, _value);
265         return true;
266     }
267 
268     /**
269      * Destroy tokens from other account
270      *
271      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
272      *
273      * @param _from the address of the sender
274      * @param _value the amount of money to burn
275      */
276     function burnFrom(address _from, uint256 _value) public returns (bool success) {
277         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
278         require(_value <= allowance[_from][msg.sender]);    // Check allowance
279         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
280         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
281         totalSupply -= _value;                              // Update totalSupply
282         Burn(_from, _value);
283         return true;
284     }
285 }
286 
287 /******************************************/
288 /*       ADVANCED TOKEN STARTS HERE       */
289 /******************************************/
290 
291 contract WHOIS is owned, TokenERC20 {
292 
293     uint256 public sellPrice;
294     uint256 public buyPrice;
295 
296     mapping (address => bool) public frozenAccount;
297 
298     /* This generates a public event on the blockchain that will notify clients */
299     event FrozenFunds(address target, bool frozen);
300 
301     /* Initializes contract with initial supply tokens to the creator of the contract */
302     function WHOIS(
303     ) 
304 
305     TokenERC20(100000000, "WHOIS", "ethWHOIS") public {}
306     
307     /* Internal transfer, only can be called by this contract */
308     function _transfer(address _from, address _to, uint _value) internal {
309         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
310         require (balanceOf[_from] > _value);                // Check if the sender has enough
311         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
312         require(!frozenAccount[_from]);                     // Check if sender is frozen
313         require(!frozenAccount[_to]);                       // Check if recipient is frozen
314         balanceOf[_from] -= _value;                         // Subtract from the sender
315         balanceOf[_to] += _value;                           // Add the same to the recipient
316         Transfer(_from, _to, _value);
317     }
318 
319     /// @notice Create `mintedAmount` tokens and send it to `target`
320     /// @param target Address to receive the tokens
321     /// @param mintedAmount the amount of tokens it will receive
322     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
323         balanceOf[target] += mintedAmount;
324         totalSupply += mintedAmount;
325         Transfer(0, this, mintedAmount);
326         Transfer(this, target, mintedAmount);
327     }
328 
329     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
330     /// @param target Address to be frozen
331     /// @param freeze either to freeze it or not
332     function freezeAccount(address target, bool freeze) onlyOwner public {
333         frozenAccount[target] = freeze;
334         FrozenFunds(target, freeze);
335     }
336 
337     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
338     /// @param newSellPrice Price the users can sell to the contract
339     /// @param newBuyPrice Price users can buy from the contract
340     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
341         sellPrice = newSellPrice;
342         buyPrice = newBuyPrice;
343     }
344 
345     /// @notice Buy tokens from contract by sending ether
346     function buy() payable public {
347         uint amount = msg.value / buyPrice;               // calculates the amount
348         _transfer(this, msg.sender, amount);              // makes the transfers
349     }
350 
351     /// @notice Sell `amount` tokens to contract
352     /// @param amount amount of tokens to be sold
353     function sell(uint256 amount) public {
354         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
355         _transfer(msg.sender, this, amount);              // makes the transfers
356         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
357     }
358 }
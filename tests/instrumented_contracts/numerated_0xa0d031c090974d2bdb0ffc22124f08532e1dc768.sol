1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : CRP
6 // Name        : Chiwoo Rotary Press
7 // Total supply: 8000000000
8 // Decimals    : 18
9 
10 
11 // (c) by Team @ CRP 2018.
12 // ----------------------------------------------------------------------------
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18 */
19 
20 library SafeMath {
21     
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30     }
31     
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a / b;
38     return c;
39     }
40     
41      /**
42     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48     }
49     
50     /**
51     * @dev Adds two numbers, throws on overflow.
52     */
53     
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65 */
66 
67 contract owned {
68     address public owner;
69 
70     constructor () public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78     
79     /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83 
84     function transferOwnership(address newOwner) onlyOwner public {
85         owner = newOwner;
86     }
87 }
88 
89 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
90 
91 contract CRP_ERC20 is owned {
92     using SafeMath for uint;
93     
94     string public name = "Chiwoo Rotary Press";
95     string public symbol = "CRP";
96     uint8 public decimals = 18;
97     uint256 public totalSupply = 8000000000 * 10 ** uint256(decimals);
98     /// the price of tokenBuy
99     uint256 public TokenPerETHBuy = 1000;
100     
101     /// the price of tokenSell
102     uint256 public TokenPerETHSell = 1000;
103     
104     /// sell token is enabled
105     bool public SellTokenAllowed;
106     
107    
108     /// This creates an array with all balances
109     mapping (address => uint256) public balanceOf;
110     mapping (address => mapping (address => uint256)) public allowance;
111     mapping (address => bool) public frozenAccount;
112     
113     /// This generates a public event on the blockchain that will notify clients
114     event Transfer(address indexed from, address indexed to, uint256 value);
115     
116     /// This notifies clients about the amount burnt
117     event Burn(address indexed from, uint256 value);
118     
119     /// This notifies clients about the new Buy price
120     event BuyRateChanged(uint256 oldValue, uint256 newValue);
121     
122     /// This notifies clients about the new Sell price
123     event SellRateChanged(uint256 oldValue, uint256 newValue);
124     
125     /// This notifies clients about the Buy Token
126     event BuyToken(address user, uint256 eth, uint256 token);
127     
128     /// This notifies clients about the Sell Token
129     event SellToken(address user, uint256 eth, uint256 token);
130     
131     /// Log the event about a deposit being made by an address and its amount
132     event LogDepositMade(address indexed accountAddress, uint amount);
133     
134     /// This generates a public event on the blockchain that will notify clients
135     event FrozenFunds(address target, bool frozen);
136     
137     event SellTokenAllowedEvent(bool isAllowed);
138     
139     /**
140      * Constrctor function
141      *
142      * Initializes contract with initial supply tokens to the creator of the contract
143      */
144     constructor () public {
145         balanceOf[owner] = totalSupply;
146         SellTokenAllowed = true;
147     }
148     
149      /**
150      * Internal transfer, only can be called by this contract
151      */
152      function _transfer(address _from, address _to, uint256 _value) internal {
153         // Prevent transfer to 0x0 address. Use burn() instead
154         require(_to != 0x0);
155         // Check if the sender has enough
156         require(balanceOf[_from] >= _value);
157         // Check for overflows
158         require(balanceOf[_to] + _value > balanceOf[_to]);
159         // Check if sender is frozen
160         require(!frozenAccount[_from]);
161         // Check if recipient is frozen
162         require(!frozenAccount[_to]);
163         // Save this for an assertion in the future
164         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
165         // Subtract from the sender
166         balanceOf[_from] -= _value;
167         // Add the same to the recipient
168         balanceOf[_to] += _value;
169         emit Transfer(_from, _to, _value);
170         // Asserts are used to use static analysis to find bugs in your code. They should never fail
171         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
172     }
173     
174      /**
175      * Transfer tokens
176      *
177      * Send `_value` tokens to `_to` from your account
178      *
179      * @param _to The address of the recipient
180      * @param _value the amount to send
181      */
182     function transfer(address _to, uint256 _value) public {
183         _transfer(msg.sender, _to, _value);
184     }
185     
186      /**
187      * Transfer tokens from other address
188      *
189      * Send `_value` tokens to `_to` in behalf of `_from`
190      *
191      * @param _from The address of the sender
192      * @param _to The address of the recipient
193      * @param _value the amount to send
194      */
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
196         require(_value <= allowance[_from][msg.sender]);     // Check allowance
197         allowance[_from][msg.sender] -= _value;
198         _transfer(_from, _to, _value);
199         return true;
200     }
201     
202      /**
203      * Set allowance for other address
204      *
205      * Allows `_spender` to spend no more than `_value` tokens in your behalf
206      *
207      * @param _spender The address authorized to spend
208      * @param _value the max amount they can spend
209      */
210     function approve(address _spender, uint256 _value) public
211         returns (bool success) {
212         allowance[msg.sender][_spender] = _value;
213         return true;
214     }
215     
216      /**
217      * Set allowance for other address and notify
218      *
219      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
220      *
221      * @param _spender The address authorized to spend
222      * @param _value the max amount they can spend
223      * @param _extraData some extra information to send to the approved contract
224      */
225     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
226         public
227         returns (bool success) {
228         tokenRecipient spender = tokenRecipient(_spender);
229         if (approve(_spender, _value)) {
230             spender.receiveApproval(msg.sender, _value, this, _extraData);
231             return true;
232         }
233     }
234     
235     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
236     /// @param target Address to be frozen
237     /// @param freeze either to freeze it or not
238     function freezeAccount(address target, bool freeze) onlyOwner public {
239         frozenAccount[target] = freeze;
240         emit FrozenFunds(target, freeze);
241     }
242     
243     /// @notice Create `mintedAmount` tokens and send it to `target`
244     /// @param target Address to receive the tokens
245     /// @param mintedAmount the amount of tokens it will receive
246     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
247         balanceOf[target] += mintedAmount;
248         totalSupply += mintedAmount;
249         emit Transfer(this, target, mintedAmount);
250     }
251     
252      /**
253      * Destroy tokens
254      *
255      * Remove `_value` tokens from the system irreversibly
256      *
257      * @param _value the amount of money to burn
258      */
259     function burn(uint256 _value) public returns (bool success) {
260         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
261         balanceOf[msg.sender] -= _value;            // Subtract from the sender
262         totalSupply -= _value;                      // Updates totalSupply
263         emit Burn(msg.sender, _value);
264         return true;
265     }
266     
267     /**
268      * Destroy tokens from other account
269      *
270      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
271      *
272      * @param _from the address of the sender
273      * @param _value the amount of money to burn
274      */
275     function burnFrom(address _from, uint256 _value) public returns (bool success) {
276         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
277         require(_value <= allowance[_from][msg.sender]);    // Check allowance
278         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
279         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
280         totalSupply -= _value;                              // Update totalSupply
281         emit Burn(_from, _value);
282         return true;
283     }
284     
285      /**
286      * Set price function for Buy
287      *
288      * @param value the amount new Buy Price
289      */
290     
291     function setBuyRate(uint256 value) onlyOwner public {
292         require(value > 0);
293         emit BuyRateChanged(TokenPerETHBuy, value);
294         TokenPerETHBuy = value;
295     }
296     
297      /**
298      * Set price function for Sell
299      *
300      * @param value the amount new Sell Price
301      */
302     
303     function setSellRate(uint256 value) onlyOwner public {
304         require(value > 0);
305         emit SellRateChanged(TokenPerETHSell, value);
306         TokenPerETHSell = value;
307     }
308     
309     /**
310     *  function for Buy Token
311     */
312     
313     function buy() payable public returns (uint amount){
314           require(msg.value > 0);
315 	      require(!frozenAccount[msg.sender]);              // check sender is not frozen account
316           amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals))).div(1 ether);
317           balanceOf[this] -= amount;                        // adds the amount to owner's 
318           balanceOf[msg.sender] += amount; 
319           emit Transfer(this,msg.sender ,amount);
320           return amount;
321     }
322     
323     /**
324     *  function for Sell Token
325     */
326     
327     function sell(uint amount) public returns (uint revenue){
328         
329         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
330 		require(SellTokenAllowed);                        // check if the sender whitelist
331 		require(!frozenAccount[msg.sender]);              // check sender is not frozen account
332         balanceOf[this] += amount;                        // adds the amount to owner's balance
333         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
334         revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals))) ;
335         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
336         emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
337         return revenue;                                   // ends function and returns
338         
339     }
340     
341     /**
342     * Deposit Ether in owner account, requires method is "payable"
343     */
344     
345     function deposit() public payable  {
346        
347     }
348     
349     /**
350     *@notice Withdraw for Ether
351     */
352      function withdraw(uint withdrawAmount) onlyOwner public  {
353           if (withdrawAmount <= address(this).balance) {
354             owner.transfer(withdrawAmount);
355         }
356         
357      }
358     
359     function () public payable {
360         buy();
361     }
362     
363     /**
364     * Enable Sell Token
365     */
366     function enableSellToken() onlyOwner public {
367         SellTokenAllowed = true;
368         emit SellTokenAllowedEvent (true);
369           
370       }
371 
372     /**
373     * Disable Sell Token
374     */
375     function disableSellToken() onlyOwner public {
376         SellTokenAllowed = false;
377         emit SellTokenAllowedEvent (false);
378     }
379     
380      
381 }
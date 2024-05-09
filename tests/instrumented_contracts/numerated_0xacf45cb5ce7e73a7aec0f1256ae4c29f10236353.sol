1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'PINI'  token contract
5 //
6 // Owner Address : 0x71d9aB28EeB24Bd9f0d9e204b72810cD3acA35b3
7 // Symbol        : PINI
8 // Name          : PINI Token
9 // Total supply  : 10000000
10 // Decimals      : 18
11 // POWERED BY PINI Token.
12 
13 // (c) by Team @ PINI Token, INC 2019.
14 // ----------------------------------------------------------------------------
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19 */
20 
21 library SafeMath {
22     
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31     }
32     
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42     }
43     
44      /**
45     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51     }
52     
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 
71 contract owned {
72     address public owner;
73 
74     constructor () public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address newOwner) onlyOwner public {
84         owner = newOwner;
85     }
86 }
87 
88 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
89 
90 contract ERC20 is owned {
91     // Public variables of the token
92     string public name = "PINI Token";
93     string public symbol = "PINI";
94     uint8 public decimals = 18;
95     uint256 public totalSupply = 10000000 * 10 ** uint256(decimals);
96 
97     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
98     address public ICO_Contract;
99 
100     // This creates an array with all balances
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowance;
103     mapping (address => bool) public frozenAccount;
104    
105     // This generates a public event on the blockchain that will notify clients
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /* This generates a public event on the blockchain that will notify clients */
109     event FrozenFunds(address target, bool frozen);
110     
111      // This notifies clients about the amount burnt
112        event Burn(address indexed from, uint256 value);
113 
114     /**
115      * Constrctor function
116      *
117      * Initializes contract with initial supply tokens to the creator of the contract
118      */
119     constructor () public {
120         balanceOf[owner] = totalSupply;
121     }
122     
123     /**
124      * Internal transfer, only can be called by this contract
125      */
126     function _transfer(address _from, address _to, uint256 _value)  internal {
127         // Prevent transfer to 0x0 address. Use burn() instead
128         require(_to != 0x0);
129         // Check if the sender has enough
130         require(balanceOf[_from] >= _value);
131         // Check for overflows
132         require(balanceOf[_to] + _value > balanceOf[_to]);
133         // Check if sender is frozen
134         require(!frozenAccount[_from]);
135         // Check if recipient is frozen
136         require(!frozenAccount[_to]);
137         // Save this for an assertion in the future
138         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
139         // Subtract from the sender
140         balanceOf[_from] -= _value;
141         // Add the same to the recipient
142         balanceOf[_to] += _value;
143         emit Transfer(_from, _to, _value);
144         // Asserts are used to use static analysis to find bugs in your code. They should never fail
145         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
146     }
147 
148     /**
149      * Transfer tokens
150      *
151      * Send `_value` tokens to `_to` from your account
152      *
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transfer(address _to, uint256 _value) public {
157         _transfer(msg.sender, _to, _value);
158     }
159 
160     /**
161      * Transfer tokens from other address
162      *
163      * Send `_value` tokens to `_to` in behalf of `_from`
164      *
165      * @param _from The address of the sender
166      * @param _to The address of the recipient
167      * @param _value the amount to send
168      */
169     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
170         require(_value <= allowance[_from][msg.sender]);     // Check allowance
171         allowance[_from][msg.sender] -= _value;
172         _transfer(_from, _to, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) public
185         returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
200         public
201         returns (bool success) {
202         tokenRecipient spender = tokenRecipient(_spender);
203         if (approve(_spender, _value)) {
204             spender.receiveApproval(msg.sender, _value, this, _extraData);
205             return true;
206         }
207     }
208 
209     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
210     /// @param target Address to be frozen
211     /// @param freeze either to freeze it or not
212     function freezeAccount(address target, bool freeze) onlyOwner public {
213         frozenAccount[target] = freeze;
214         emit FrozenFunds(target, freeze);
215     }
216     
217     /// @notice Create `mintedAmount` tokens and send it to `target`
218     /// @param target Address to receive the tokens
219     /// @param mintedAmount the amount of tokens it will receive
220     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
221         balanceOf[target] += mintedAmount;
222         totalSupply += mintedAmount;
223         emit Transfer(this, target, mintedAmount);
224     }
225      /**
226      * Destroy tokens
227      *
228      * Remove `_value` tokens from the system irreversibly
229      *
230      * @param _value the amount of money to burn
231      */
232     function burn(uint256 _value) public returns (bool success) {
233         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
234         balanceOf[msg.sender] -= _value;            // Subtract from the sender
235         totalSupply -= _value;                      // Updates totalSupply
236         emit Burn(msg.sender, _value);
237         return true;
238     }
239 
240     /**
241      * Destroy tokens from other account
242      *
243      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
244      *
245      * @param _from the address of the sender
246      * @param _value the amount of money to burn
247      */
248     function burnFrom(address _from, uint256 _value) public returns (bool success) {
249         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
250         require(_value <= allowance[_from][msg.sender]);    // Check allowance
251         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
252         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
253         totalSupply -= _value;                              // Update totalSupply
254         emit Burn(_from, _value);
255         return true;
256     }
257     
258     /// @dev Set the ICO_Contract.
259     /// @param _ICO_Contract crowdsale contract address
260     function setICO_Contract(address _ICO_Contract) onlyOwner public {
261         ICO_Contract = _ICO_Contract;
262     }
263 }
264 contract Killable is owned {
265     function kill() onlyOwner public {
266         selfdestruct(owner);
267     }
268 }
269 contract ERC20_ICO is Killable {
270 
271     /// The token we are selling
272     ERC20 public token;
273 
274     /// the UNIX timestamp start date of the crowdsale
275     uint256 public startsAt = 1556712000;
276 
277     /// the UNIX timestamp end date of the crowdsale
278     uint256 public endsAt = 1561896000;
279 
280     /// the price of token
281     uint256 public TokenPerETH = 8000;
282 
283     /// Has this crowdsale been finalized
284     bool public finalized = false;
285 
286     /// the number of tokens already sold through this contract
287     uint256 public tokensSold = 0;
288 
289     /// the number of ETH raised through this contract
290     uint256 public weiRaised = 0;
291 
292     /// How many distinct addresses have invested
293     uint256 public investorCount = 0;
294     
295     /// How much ETH each address has invested to this crowdsale
296     mapping (address => uint256) public investedAmountOf;
297     
298     event Invested(address investor, uint256 weiAmount, uint256 tokenAmount);
299     /// Crowdsale Start time has been changed
300     event StartsAtChanged(uint256 startsAt);
301     /// Crowdsale end time has been changed
302     event EndsAtChanged(uint256 endsAt);
303     /// Calculated new price
304     event RateChanged(uint256 oldValue, uint256 newValue);
305     
306     constructor (address _token) public {
307         token = ERC20(_token);
308     }
309     
310     function investInternal(address receiver) private {
311         require(!finalized);
312         require(startsAt <= now && endsAt > now);
313 
314         if(investedAmountOf[receiver] == 0) {
315             // A new investor
316             investorCount++;
317         }
318 
319         // Update investor
320         uint256 tokensAmount = msg.value * TokenPerETH;
321         investedAmountOf[receiver] += msg.value;
322         // Update totals
323         tokensSold += tokensAmount;
324         weiRaised += msg.value;
325 
326         // Emit an event that shows invested successfully
327         emit Invested(receiver, msg.value, tokensAmount);
328         
329         // Transfer Token to owner's address
330         token.transfer(receiver, tokensAmount);
331 
332         // Transfer Fund to owner's address
333         owner.transfer(address(this).balance);
334 
335     }
336     
337     
338     function () public payable {
339         investInternal(msg.sender);
340     }
341 
342     function setStartsAt(uint256 time) onlyOwner public {
343         require(!finalized);
344         startsAt = time;
345         emit StartsAtChanged(startsAt);
346     }
347     function setEndsAt(uint256 time) onlyOwner public {
348         require(!finalized);
349         endsAt = time;
350         emit EndsAtChanged(endsAt);
351     }
352     function setRate(uint256 value) onlyOwner public {
353         require(!finalized);
354         require(value > 0);
355         emit RateChanged(TokenPerETH, value);
356         TokenPerETH = value;
357     }
358 
359     function finalize() public onlyOwner {
360         // Finalized Pre ICO crowdsele.
361         finalized = true;
362         uint256 tokensAmount = token.balanceOf(this);
363         token.transfer(owner, tokensAmount);
364     }
365     
366 }
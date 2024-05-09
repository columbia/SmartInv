1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'CNB'  token contract
5 //
6 // Owner Address : 0xc5364e919c8f65CD30bCe38f6C12D7A8CdaFF89B
7 // Symbol      : CBNC
8 // Name        : Cannabnc
9 // Total supply: 400000000
10 // Decimals    : 18
11 // Website     : https://www.ramlogics.com/cannabanc
12 // Email       : cannabanc@cannabanc.com
13 // POWERED BY Cannabanc.
14 
15 // (c) by Team @ cannabanc 2018.
16 // ----------------------------------------------------------------------------
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21 */
22 
23 library SafeMath {
24     
25     /**
26     * @dev Multiplies two numbers, throws on overflow.
27     */
28     
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33     }
34     
35     /**
36     * @dev Integer division of two numbers, truncating the quotient.
37     */
38     
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44     }
45     
46      /**
47     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53     }
54     
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 
73 contract owned {
74     address public owner;
75 
76     constructor () public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address newOwner) onlyOwner public {
86         owner = newOwner;
87     }
88 }
89 
90 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
91 
92 contract ERC20 is owned {
93     // Public variables of the token
94     string public name = "Cannabnc Token";
95     string public symbol = "CBNC";
96     uint8 public decimals = 18;
97     uint256 public totalSupply = 400000000 * 10 ** uint256(decimals);
98 
99     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
100     address public ICO_Contract;
101 
102     // This creates an array with all balances
103     mapping (address => uint256) public balanceOf;
104     mapping (address => mapping (address => uint256)) public allowance;
105     mapping (address => bool) public frozenAccount;
106    
107     // This generates a public event on the blockchain that will notify clients
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /* This generates a public event on the blockchain that will notify clients */
111     event FrozenFunds(address target, bool frozen);
112     
113      // This notifies clients about the amount burnt
114        event Burn(address indexed from, uint256 value);
115 
116     /**
117      * Constrctor function
118      *
119      * Initializes contract with initial supply tokens to the creator of the contract
120      */
121     constructor () public {
122         balanceOf[owner] = totalSupply;
123     }
124     
125     /**
126      * Internal transfer, only can be called by this contract
127      */
128     function _transfer(address _from, address _to, uint256 _value)  internal {
129         // Prevent transfer to 0x0 address. Use burn() instead
130         require(_to != 0x0);
131         // Check if the sender has enough
132         require(balanceOf[_from] >= _value);
133         // Check for overflows
134         require(balanceOf[_to] + _value > balanceOf[_to]);
135         // Check if sender is frozen
136         require(!frozenAccount[_from]);
137         // Check if recipient is frozen
138         require(!frozenAccount[_to]);
139         // Save this for an assertion in the future
140         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
141         // Subtract from the sender
142         balanceOf[_from] -= _value;
143         // Add the same to the recipient
144         balanceOf[_to] += _value;
145         emit Transfer(_from, _to, _value);
146         // Asserts are used to use static analysis to find bugs in your code. They should never fail
147         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
148     }
149 
150     /**
151      * Transfer tokens
152      *
153      * Send `_value` tokens to `_to` from your account
154      *
155      * @param _to The address of the recipient
156      * @param _value the amount to send
157      */
158     function transfer(address _to, uint256 _value) public {
159         _transfer(msg.sender, _to, _value);
160     }
161 
162     /**
163      * Transfer tokens from other address
164      *
165      * Send `_value` tokens to `_to` in behalf of `_from`
166      *
167      * @param _from The address of the sender
168      * @param _to The address of the recipient
169      * @param _value the amount to send
170      */
171     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
172         require(_value <= allowance[_from][msg.sender]);     // Check allowance
173         allowance[_from][msg.sender] -= _value;
174         _transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * Set allowance for other address
180      *
181      * Allows `_spender` to spend no more than `_value` tokens in your behalf
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      */
186     function approve(address _spender, uint256 _value) public
187         returns (bool success) {
188         allowance[msg.sender][_spender] = _value;
189         return true;
190     }
191 
192     /**
193      * Set allowance for other address and notify
194      *
195      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
196      *
197      * @param _spender The address authorized to spend
198      * @param _value the max amount they can spend
199      * @param _extraData some extra information to send to the approved contract
200      */
201     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
202         public
203         returns (bool success) {
204         tokenRecipient spender = tokenRecipient(_spender);
205         if (approve(_spender, _value)) {
206             spender.receiveApproval(msg.sender, _value, this, _extraData);
207             return true;
208         }
209     }
210 
211     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
212     /// @param target Address to be frozen
213     /// @param freeze either to freeze it or not
214     function freezeAccount(address target, bool freeze) onlyOwner public {
215         frozenAccount[target] = freeze;
216         emit FrozenFunds(target, freeze);
217     }
218     
219     /// @notice Create `mintedAmount` tokens and send it to `target`
220     /// @param target Address to receive the tokens
221     /// @param mintedAmount the amount of tokens it will receive
222     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
223         balanceOf[target] += mintedAmount;
224         totalSupply += mintedAmount;
225         emit Transfer(this, target, mintedAmount);
226     }
227      /**
228      * Destroy tokens
229      *
230      * Remove `_value` tokens from the system irreversibly
231      *
232      * @param _value the amount of money to burn
233      */
234     function burn(uint256 _value) public returns (bool success) {
235         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
236         balanceOf[msg.sender] -= _value;            // Subtract from the sender
237         totalSupply -= _value;                      // Updates totalSupply
238         emit Burn(msg.sender, _value);
239         return true;
240     }
241 
242     /**
243      * Destroy tokens from other account
244      *
245      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
246      *
247      * @param _from the address of the sender
248      * @param _value the amount of money to burn
249      */
250     function burnFrom(address _from, uint256 _value) public returns (bool success) {
251         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
252         require(_value <= allowance[_from][msg.sender]);    // Check allowance
253         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
254         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
255         totalSupply -= _value;                              // Update totalSupply
256         emit Burn(_from, _value);
257         return true;
258     }
259     
260     /// @dev Set the ICO_Contract.
261     /// @param _ICO_Contract crowdsale contract address
262     function setICO_Contract(address _ICO_Contract) onlyOwner public {
263         ICO_Contract = _ICO_Contract;
264     }
265 }
266 contract Killable is owned {
267     function kill() onlyOwner public {
268         selfdestruct(owner);
269     }
270 }
271 contract ERC20_ICO is Killable {
272 
273     /// The token we are selling
274     ERC20 public token;
275 
276     /// the UNIX timestamp start date of the crowdsale
277     uint256 public startsAt = 1555329600;
278 
279     /// the UNIX timestamp end date of the crowdsale
280     uint256 public endsAt = 1563192000;
281 
282     /// the price of token
283     uint256 public TokenPerETH = 5000;
284 
285     /// Has this crowdsale been finalized
286     bool public finalized = false;
287 
288     /// the number of tokens already sold through this contract
289     uint256 public tokensSold = 0;
290 
291     /// the number of ETH raised through this contract
292     uint256 public weiRaised = 0;
293 
294     /// How many distinct addresses have invested
295     uint256 public investorCount = 0;
296 
297     /// How much ETH each address has invested to this crowdsale
298     mapping (address => uint256) public investedAmountOf;
299 
300     /// A new investment was made
301     event Invested(address investor, uint256 weiAmount, uint256 tokenAmount);
302     /// Crowdsale Start time has been changed
303     event StartsAtChanged(uint256 startsAt);
304     /// Crowdsale end time has been changed
305     event EndsAtChanged(uint256 endsAt);
306     /// Calculated new price
307     event RateChanged(uint256 oldValue, uint256 newValue);
308     
309      constructor (address _token) public {
310         token = ERC20(_token);
311     }
312 
313     function investInternal(address receiver) private {
314         require(!finalized);
315         require(startsAt <= now && endsAt > now);
316 
317         if(investedAmountOf[receiver] == 0) {
318             // A new investor
319             investorCount++;
320         }
321 
322         // Update investor
323         uint256 tokensAmount = msg.value * TokenPerETH;
324         investedAmountOf[receiver] += msg.value;
325         // Update totals
326         tokensSold += tokensAmount;
327         weiRaised += msg.value;
328 
329         // Emit an event that shows invested successfully
330         emit Invested(receiver, msg.value, tokensAmount);
331         
332         // Transfer Token to owner's address
333         token.transfer(receiver, tokensAmount);
334 
335         // Transfer Fund to owner's address
336         owner.transfer(address(this).balance);
337 
338     }
339 
340     function () public payable {
341         investInternal(msg.sender);
342     }
343 
344     function setStartsAt(uint256 time) onlyOwner public {
345         require(!finalized);
346         startsAt = time;
347         emit StartsAtChanged(startsAt);
348     }
349     function setEndsAt(uint256 time) onlyOwner public {
350         require(!finalized);
351         endsAt = time;
352         emit EndsAtChanged(endsAt);
353     }
354     function setRate(uint256 value) onlyOwner public {
355         require(!finalized);
356         require(value > 0);
357         emit RateChanged(TokenPerETH, value);
358         TokenPerETH = value;
359     }
360 
361     function finalize() public onlyOwner {
362         // Finalized Pre ICO crowdsele.
363         finalized = true;
364         uint256 tokensAmount = token.balanceOf(this);
365         token.transfer(owner, tokensAmount);
366     }
367 }
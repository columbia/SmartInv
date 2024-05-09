1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
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
22 contract Trabet_Coin is owned {
23     // Public variables of the token
24     string public name = "Trabet Coin";
25     string public symbol = "TC";
26     uint8 public decimals = 4;
27     uint256 public totalSupply = 7000000 * 10 ** uint256(decimals);
28 
29     bool public released = false;
30 
31     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
32     address public crowdsaleAgent;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37     mapping (address => bool) public frozenAccount;
38    
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44     
45     /* This generates a public event on the blockchain that will notify clients */
46     event FrozenFunds(address target, bool frozen);
47 
48     /**
49      * Constrctor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     constructor () public {
54         balanceOf[owner] = totalSupply;
55     }
56     modifier canTransfer() {
57         require(released);
58        _;
59      }
60 
61     modifier onlyCrowdsaleAgent() {
62         require(msg.sender == crowdsaleAgent);
63         _;
64     }
65 
66     function releaseToken() public onlyOwner {
67         released = true;
68     }
69     /**
70      * Internal transfer, only can be called by this contract
71      */
72     function _transfer(address _from, address _to, uint _value) canTransfer internal {
73         // Prevent transfer to 0x0 address. Use burn() instead
74         require(_to != 0x0);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to] + _value > balanceOf[_to]);
79         // Check if sender is frozen
80         require(!frozenAccount[_from]);
81         // Check if recipient is frozen
82         require(!frozenAccount[_to]);
83         // Save this for an assertion in the future
84         uint previousBalances = balanceOf[_from] + balanceOf[_to];
85         // Subtract from the sender
86         balanceOf[_from] -= _value;
87         // Add the same to the recipient
88         balanceOf[_to] += _value;
89         emit Transfer(_from, _to, _value);
90         // Asserts are used to use static analysis to find bugs in your code. They should never fail
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     /**
95      * Transfer tokens
96      *
97      * Send `_value` tokens to `_to` from your account
98      *
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transfer(address _to, uint256 _value) public {
103         _transfer(msg.sender, _to, _value);
104     }
105 
106     /**
107      * Transfer tokens from other address
108      *
109      * Send `_value` tokens to `_to` in behalf of `_from`
110      *
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool success) {
116         require(_value <= allowance[_from][msg.sender]);     // Check allowance
117         allowance[_from][msg.sender] -= _value;
118         _transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      */
130     function approve(address _spender, uint256 _value) public
131         returns (bool success) {
132         allowance[msg.sender][_spender] = _value;
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address and notify
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      * @param _extraData some extra information to send to the approved contract
144      */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
146         public
147         returns (bool success) {
148         tokenRecipient spender = tokenRecipient(_spender);
149         if (approve(_spender, _value)) {
150             spender.receiveApproval(msg.sender, _value, this, _extraData);
151             return true;
152         }
153     }
154 
155     /**
156      * Destroy tokens
157      *
158      * Remove `_value` tokens from the system irreversibly
159      *
160      * @param _value the amount of money to burn
161      */
162     function burn(uint256 _value) public returns (bool success) {
163         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
164         balanceOf[msg.sender] -= _value;            // Subtract from the sender
165         totalSupply -= _value;                      // Updates totalSupply
166         emit Burn(msg.sender, _value);
167         return true;
168     }
169 
170     /**
171      * Destroy tokens from other account
172      *
173      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
174      *
175      * @param _from the address of the sender
176      * @param _value the amount of money to burn
177      */
178     function burnFrom(address _from, uint256 _value) public returns (bool success) {
179         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
180         require(_value <= allowance[_from][msg.sender]);    // Check allowance
181         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
182         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
183         totalSupply -= _value;                              // Update totalSupply
184         emit Burn(_from, _value);
185         return true;
186     }
187 
188     /// @notice Create `mintedAmount` tokens and send it to `target`
189     /// @param target Address to receive the tokens
190     /// @param mintedAmount the amount of tokens it will receive
191     function mintToken(address target, uint256 mintedAmount) onlyCrowdsaleAgent public {
192         balanceOf[target] += mintedAmount;
193         totalSupply += mintedAmount;
194         emit Transfer(this, target, mintedAmount);
195     }
196 
197     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
198     /// @param target Address to be frozen
199     /// @param freeze either to freeze it or not
200     function freezeAccount(address target, bool freeze) onlyOwner public {
201         frozenAccount[target] = freeze;
202         emit FrozenFunds(target, freeze);
203     }
204 
205     /// @dev Set the contract that can call release and make the token transferable.
206     /// @param _crowdsaleAgent crowdsale contract address
207     function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner public {
208         crowdsaleAgent = _crowdsaleAgent;
209     }
210 }
211 
212 contract Killable is owned {
213     function kill() onlyOwner public {
214         selfdestruct(owner);
215     }
216 }
217 
218 contract Trabet_Coin_PreICO is owned, Killable {
219     /// The token we are selling
220     Trabet_Coin public token;
221 
222     ///fund goes to
223     address public beneficiary;
224 
225     /// the UNIX timestamp start date of the crowdsale
226     uint public startsAt = 1521748800;
227 
228     /// the UNIX timestamp end date of the crowdsale
229     uint public endsAt = 1532563200;
230 
231     /// the price of token
232     uint256 public TokenPerETH = 1065;
233 
234     /// Has this crowdsale been finalized
235     bool public finalized = false;
236 
237     /// the number of tokens already sold through this contract
238     uint public tokensSold = 0;
239 
240     /// the number of ETH raised through this contract
241     uint public weiRaised = 0;
242 
243     /// How many distinct addresses have invested
244     uint public investorCount = 0;
245 
246     /// How much wei we have given back to investors.
247     uint public weiRefunded = 0;
248 
249     /// Has this crowdsale reFunding
250     bool public reFunding = false;
251 
252     /// How much ETH each address has invested to this crowdsale
253     mapping (address => uint256) public investedAmountOf;
254 
255     /// A new investment was made
256     event Invested(address investor, uint weiAmount, uint tokenAmount);
257     /// Crowdsale Start time has been changed
258     event StartsAtChanged(uint startsAt);
259     /// Crowdsale end time has been changed
260     event EndsAtChanged(uint endsAt);
261     /// Calculated new price
262     event RateChanged(uint oldValue, uint newValue);
263     /// Refund was processed for a contributor
264     event Refund(address investor, uint weiAmount);
265 
266     constructor (address _token, address _beneficiary) public {
267         token = Trabet_Coin(_token);
268         beneficiary = _beneficiary;
269     }
270 
271     function investInternal(address receiver, address refer) private {
272         require(!finalized);
273         require(startsAt <= now && endsAt > now);
274         require(msg.value >= 100000000000000);
275 
276         if(investedAmountOf[receiver] == 0) {
277             // A new investor
278             investorCount++;
279         }
280 
281         // Update investor
282         uint tokensAmount = msg.value * TokenPerETH / 100000000000000;
283         investedAmountOf[receiver] += msg.value;
284         // Update totals
285         tokensSold += tokensAmount;
286         weiRaised += msg.value;
287 
288         // Tell us invest was success
289         emit Invested(receiver, msg.value, tokensAmount);
290 
291         token.mintToken(receiver, tokensAmount);
292 
293         if (refer != 0x0) {
294             refer.transfer(msg.value/10);
295         }
296 
297         // Transfer Fund to owner's address
298         beneficiary.transfer(address(this).balance);
299 
300     }
301 
302     function buy(address refer) public payable {
303         investInternal(msg.sender, refer);
304     }
305     
306     function () public payable {
307         investInternal(msg.sender, 0x0);
308     }
309     
310     function payforRefund () public payable {
311     }
312     function setStartsAt(uint time) onlyOwner public {
313         require(!finalized);
314         startsAt = time;
315         emit StartsAtChanged(startsAt);
316     }
317     function setEndsAt(uint time) onlyOwner public {
318         require(!finalized);
319         endsAt = time;
320         emit EndsAtChanged(endsAt);
321     }
322     function setRate(uint value) onlyOwner public {
323         require(!finalized);
324         require(value > 0);
325         emit RateChanged(TokenPerETH, value);
326         TokenPerETH = value;
327     }
328 
329     function finalize() public onlyOwner {
330         // Finalized Pre ICO crowdsele.
331         finalized = true;
332     }
333 
334     function EnableRefund() public onlyOwner {
335         // Finalized Pre ICO crowdsele.
336         reFunding = true;
337     }
338 
339     function setBeneficiary(address _beneficiary) public onlyOwner {
340         // Finalized Pre ICO crowdsele.
341         beneficiary = _beneficiary;
342     }
343 
344     /// @dev Investors can claim refund.
345     function refund() public {
346         require(reFunding);
347         uint256 weiValue = investedAmountOf[msg.sender];
348         investedAmountOf[msg.sender] = 0;
349         weiRefunded = weiRefunded + weiValue;
350         emit Refund(msg.sender, weiValue);
351         msg.sender.transfer(weiValue);
352     }
353 }
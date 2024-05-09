1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 /**
30  * @title ERC20Basic
31  * @dev Simpler version of ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 /**
42  * @title Basic token
43  * @dev Basic version of StandardToken, with no allowances. 
44  */
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   /**
51   * @dev transfer token for a specified address
52   * @param _to The address to transfer to.
53   * @param _value The amount to be transferred.
54   */
55   function transfer(address _to, uint256 _value) {
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59   }
60 
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of. 
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) constant returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value);
80   function approve(address spender, uint256 value);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) allowed;
87 
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amout of tokens to be transfered
94    */
95   function transferFrom(address _from, address _to, uint256 _value) {
96     var _allowance = allowed[_from][msg.sender];
97 
98     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
99     // if (_value > _allowance) throw;
100 
101     balances[_to] = balances[_to].add(_value);
102     balances[_from] = balances[_from].sub(_value);
103     allowed[_from][msg.sender] = _allowance.sub(_value);
104     Transfer(_from, _to, _value);
105   }
106 
107   /**
108    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    * @param _spender The address which will spend the funds.
110    * @param _value The amount of tokens to be spent.
111    */
112   function approve(address _spender, uint256 _value) {
113 
114     // To change the approve amount you first have to reduce the addresses`
115     //  allowance to zero by calling `approve(_spender, 0)` if it is not
116     //  already 0 to mitigate the race condition described here:
117     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
119 
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122   }
123 
124   /**
125    * @dev Function to check the amount of tokens that an owner allowed to a spender.
126    * @param _owner address The address which owns the funds.
127    * @param _spender address The address which will spend the funds.
128    * @return A uint256 specifing the amount of tokens still avaible for the spender.
129    */
130   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
131     return allowed[_owner][_spender];
132   }
133 
134 }
135 
136 /**
137  * @title Ownable
138  * @dev The Ownable contract has an owner address, and provides basic authorization control 
139  * functions, this simplifies the implementation of "user permissions". 
140  */
141 contract Ownable {
142   address public owner;
143 
144 
145   /** 
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function Ownable() {
150     owner = msg.sender;
151   }
152 
153 
154   /**
155    * @dev Throws if called by any account other than the owner. 
156    */
157   modifier onlyOwner() {
158     if (msg.sender != owner) {
159       throw;
160     }
161     _;
162   }
163 
164 
165   /**
166    * @dev Allows the current owner to transfer control of the contract to a newOwner.
167    * @param newOwner The address to transfer ownership to. 
168    */
169   function transferOwnership(address newOwner) onlyOwner {
170     if (newOwner != address(0)) {
171       owner = newOwner;
172     }
173   }
174 
175 }
176 
177 
178 
179 contract MintableToken is StandardToken, Ownable {
180   event Mint(address indexed to, uint256 amount);
181   event MintFinished();
182 
183   bool public mintingFinished = false;
184 
185 
186   modifier canMint() {
187     if(mintingFinished) throw;
188     _;
189   }
190 
191   /**
192    * @dev Function to mint tokens
193    * @param _to The address that will recieve the minted tokens.
194    * @param _amount The amount of tokens to mint.
195    * @return A boolean that indicates if the operation was successful.
196    */
197   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
198     totalSupply = totalSupply.add(_amount);
199     balances[_to] = balances[_to].add(_amount);
200     Mint(_to, _amount);
201     return true;
202   }
203 
204   /**
205    * @dev Function to stop minting new tokens.
206    * @return True if the operation was successful.
207    */
208   function finishMinting() onlyOwner returns (bool) {
209     mintingFinished = true;
210     MintFinished();
211     return true;
212   }
213 }
214 
215 
216 
217 /**
218  * @title BitplusToken
219  * @dev Very simple ERC20 Token
220  */
221 contract BitplusToken is MintableToken {
222 
223   string public name = "BitplusToken";
224   string public symbol = "BPNT";
225   uint256 public decimals = 18;
226 
227   /**
228    * @dev Contructor.
229    */
230   function BitplusToken() {
231     totalSupply = 0;
232   }
233 
234 }
235 
236 
237 /**
238  * @title Crowdsale 
239  * @dev Crowdsale is a base contract for managing a token crowdsale.
240  * Crowdsales have a start and end block, where investors can make
241  * token purchases and the crowdsale will assign them tokens based
242  * on a token per ETH rate. Funds collected are forwarded to a wallet 
243  * as they arrive.
244  */
245 contract Crowdsale {
246   using SafeMath for uint256;
247 
248   // The token being sold
249   BitplusToken public token;
250 
251   // start and end block where investments are allowed (both inclusive)
252   uint256 public startBlock;
253   uint256 public endBlock;
254 
255   // address where funds are collected
256   address public wallet;
257 
258   // how many token units a buyer gets per wei
259   uint256 public rate;
260 
261   // amount of raised money in wei
262   uint256 public weiRaised;
263 
264   /**
265    * event for token purchase logging
266    * @param purchaser who paid for the tokens
267    * @param beneficiary who got the tokens
268    * @param value weis paid for purchase
269    * @param amount amount of tokens purchased
270    */ 
271   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
272 
273 
274   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
275     require(_startBlock >= block.number);
276     require(_endBlock >= _startBlock);
277     require(_rate > 0);
278     require(_wallet != 0x0);
279 
280     token = createTokenContract();
281     startBlock = _startBlock;
282     endBlock = _endBlock;
283     rate = _rate;
284     wallet = _wallet;
285   }
286 
287   // creates the token to be sold. 
288   // override this method to have crowdsale of a specific mintable token.
289   function createTokenContract() internal returns (BitplusToken) {
290     return new BitplusToken();
291   }
292 
293 
294   // fallback function can be used to buy tokens
295   function () payable {
296     buyTokens(msg.sender);
297   }
298 
299   // low level token purchase function
300   function buyTokens(address beneficiary) payable {
301     require(beneficiary != 0x0);
302     require(validPurchase());
303 
304     uint256 weiAmount = msg.value;
305     uint256 updatedWeiRaised = weiRaised.add(weiAmount);
306 
307     // calculate token amount to be created
308     uint256 tokens = weiAmount.mul(rate);
309 
310     // update state
311     weiRaised = updatedWeiRaised;
312 
313     token.mint(beneficiary, tokens);
314     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
315 
316     forwardFunds();
317   }
318 
319   // send ether to the fund collection wallet
320   // override to create custom fund forwarding mechanisms
321   function forwardFunds() internal {
322     wallet.transfer(msg.value);
323   }
324 
325   // @return true if the transaction can buy tokens
326   function validPurchase() internal constant returns (bool) {
327     uint256 current = block.number;
328     bool withinPeriod = current >= startBlock && current <= endBlock;
329     bool nonZeroPurchase = msg.value != 0;
330     return withinPeriod && nonZeroPurchase;
331   }
332 
333   // @return true if crowdsale event has ended
334   function hasEnded() public constant returns (bool) {
335     return block.number > endBlock;
336   }
337 
338 }
339 
340 
341 
342 /**
343  * @title CappedCrowdsale
344  * @dev Extension of Crowsdale with a max amount of funds raised
345  */
346 contract CappedCrowdsale is Crowdsale, Ownable {
347   using SafeMath for uint256;
348   event CrowdsaleMintFinished();
349 
350   uint256 public cap;
351 
352   function CappedCrowdsale(uint256 _cap, uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) Crowdsale(_startBlock, _endBlock, _rate, _wallet) {
353     cap = _cap;
354   }
355 
356   // overriding Crowdsale#validPurchase to add extra cap logic
357   // @return true if investors can buy at the moment
358   function validPurchase() internal constant returns (bool) {
359     bool withinCap = weiRaised.add(msg.value) <= cap;
360     return super.validPurchase() && withinCap;
361   }
362 
363   // overriding Crowdsale#hasEnded to add cap logic
364   // @return true if crowdsale event has ended
365   function hasEnded() public constant returns (bool) {
366     bool capReached = weiRaised >= cap;
367     return super.hasEnded() || capReached;
368   }
369 
370   // is minting allowed on the crowdsale contract itself?
371   bool public mintingFinished = false;
372 
373   modifier canMint() {
374     if(mintingFinished) throw;
375     _;
376   }
377   
378   // this function allows distribution by the owner before the 
379   // actual public sale starts
380   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
381       return token.mint(_to, _amount);
382   }
383 
384   /**
385    * @dev Function to stop minting new tokens in crowdsale(initial distribution).
386    * @return True if the operation was successful.
387    */
388   function finishMinting() onlyOwner returns (bool) {
389     mintingFinished = true;
390     CrowdsaleMintFinished();
391     return true;
392   }  
393   
394 }
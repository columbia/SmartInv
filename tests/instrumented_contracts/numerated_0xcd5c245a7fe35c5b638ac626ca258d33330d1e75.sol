1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end block where investments are allowed (both inclusive)
36   uint256 public startBlock;
37   uint256 public endBlock;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */ 
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
59     require(_startBlock >= block.number);
60     require(_endBlock >= _startBlock);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startBlock = _startBlock;
66     endBlock = _endBlock;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold. 
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     uint256 current = block.number;
111     bool withinPeriod = current >= startBlock && current <= endBlock;
112     bool nonZeroPurchase = msg.value != 0;
113     return withinPeriod && nonZeroPurchase;
114   }
115 
116   // @return true if crowdsale event has ended
117   function hasEnded() public constant returns (bool) {
118     return block.number > endBlock;
119   }
120 
121 
122 }
123 
124 contract ERC20Basic {
125   uint256 public totalSupply;
126   function balanceOf(address who) constant returns (uint256);
127   function transfer(address to, uint256 value) returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 contract Ownable {
132   address public owner;
133 
134 
135   /**
136    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137    * account.
138    */
139   function Ownable() {
140     owner = msg.sender;
141   }
142 
143 
144   /**
145    * @dev Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(msg.sender == owner);
149     _;
150   }
151 
152 
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) onlyOwner {
158     if (newOwner != address(0)) {
159       owner = newOwner;
160     }
161   }
162 
163 }
164 
165 contract FinalizableCrowdsale is Crowdsale, Ownable {
166   using SafeMath for uint256;
167 
168   bool public isFinalized = false;
169 
170   event Finalized();
171 
172   // should be called after crowdsale ends, to do
173   // some extra finalization work
174   function finalize() onlyOwner {
175     require(!isFinalized);
176     require(hasEnded());
177 
178     finalization();
179     Finalized();
180     
181     isFinalized = true;
182   }
183 
184   // end token minting on finalization
185   // override this with custom logic if needed
186   function finalization() internal {
187     token.finishMinting();
188   }
189 
190 
191 
192 }
193 
194 contract CappedCrowdsale is Crowdsale {
195   using SafeMath for uint256;
196 
197   uint256 public cap;
198 
199   function CappedCrowdsale(uint256 _cap) {
200     require(_cap > 0);
201     cap = _cap;
202   }
203 
204   // overriding Crowdsale#validPurchase to add extra cap logic
205   // @return true if investors can buy at the moment
206   function validPurchase() internal constant returns (bool) {
207     bool withinCap = weiRaised.add(msg.value) <= cap;
208     return super.validPurchase() && withinCap;
209   }
210 
211   // overriding Crowdsale#hasEnded to add cap logic
212   // @return true if crowdsale event has ended
213   function hasEnded() public constant returns (bool) {
214     bool capReached = weiRaised >= cap;
215     return super.hasEnded() || capReached;
216   }
217 
218 }
219 
220 contract ERC20 is ERC20Basic {
221   function allowance(address owner, address spender) constant returns (uint256);
222   function transferFrom(address from, address to, uint256 value) returns (bool);
223   function approve(address spender, uint256 value) returns (bool);
224   event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 contract BasicToken is ERC20Basic {
228   using SafeMath for uint256;
229 
230   mapping(address => uint256) balances;
231 
232   /**
233   * @dev transfer token for a specified address
234   * @param _to The address to transfer to.
235   * @param _value The amount to be transferred.
236   */
237   function transfer(address _to, uint256 _value) returns (bool) {
238     balances[msg.sender] = balances[msg.sender].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     Transfer(msg.sender, _to, _value);
241     return true;
242   }
243 
244   /**
245   * @dev Gets the balance of the specified address.
246   * @param _owner The address to query the the balance of. 
247   * @return An uint256 representing the amount owned by the passed address.
248   */
249   function balanceOf(address _owner) constant returns (uint256 balance) {
250     return balances[_owner];
251   }
252 
253 }
254 
255 contract StandardToken is ERC20, BasicToken {
256 
257   mapping (address => mapping (address => uint256)) allowed;
258 
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param _from address The address which you want to send tokens from
263    * @param _to address The address which you want to transfer to
264    * @param _value uint256 the amout of tokens to be transfered
265    */
266   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
267     var _allowance = allowed[_from][msg.sender];
268 
269     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
270     // require (_value <= _allowance);
271 
272     balances[_to] = balances[_to].add(_value);
273     balances[_from] = balances[_from].sub(_value);
274     allowed[_from][msg.sender] = _allowance.sub(_value);
275     Transfer(_from, _to, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) returns (bool) {
285 
286     // To change the approve amount you first have to reduce the addresses`
287     //  allowance to zero by calling `approve(_spender, 0)` if it is not
288     //  already 0 to mitigate the race condition described here:
289     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
291 
292     allowed[msg.sender][_spender] = _value;
293     Approval(msg.sender, _spender, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Function to check the amount of tokens that an owner allowed to a spender.
299    * @param _owner address The address which owns the funds.
300    * @param _spender address The address which will spend the funds.
301    * @return A uint256 specifing the amount of tokens still avaible for the spender.
302    */
303   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
304     return allowed[_owner][_spender];
305   }
306 
307 }
308 
309 contract MintableToken is StandardToken, Ownable {
310   event Mint(address indexed to, uint256 amount);
311   event MintFinished();
312 
313   bool public mintingFinished = false;
314 
315 
316   modifier canMint() {
317     require(!mintingFinished);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will recieve the minted tokens.
324    * @param _amount The amount of tokens to mint.
325    * @return A boolean that indicates if the operation was successful.
326    */
327   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
328     totalSupply = totalSupply.add(_amount);
329     balances[_to] = balances[_to].add(_amount);
330     Mint(_to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner returns (bool) {
339     mintingFinished = true;
340     MintFinished();
341     return true;
342   }
343 }
344 
345 contract RenderToken is MintableToken {
346 
347   string public constant name = "Render Token";
348   string public constant symbol = "RNDR";
349   uint8 public constant decimals = 18;
350 
351 }
352 
353 contract RenderTokenCrowdsale is CappedCrowdsale, FinalizableCrowdsale {
354 
355   address public foundationAddress;
356   address public foundersAddress;
357 
358   mapping(address => bool) public whitelistedAddrs;
359 
360   modifier fromWhitelistedAddr(){
361     require(whitelistedAddrs[msg.sender]);
362     _;
363   }
364 
365   function RenderTokenCrowdsale(
366     uint256 startBlock, uint256 endBlock,
367     uint256 rate, uint256 cap, address wallet,
368     address _foundationAddress, address _foundersAddress
369   ) CappedCrowdsale(cap)
370     FinalizableCrowdsale()
371     Crowdsale(startBlock, endBlock, rate, wallet)
372   {
373     require(_foundationAddress != address(0));
374     require(_foundersAddress != address(0));
375 
376     foundationAddress = _foundationAddress;
377     foundersAddress = _foundersAddress;
378   }
379 
380   // override buyTokens function to allow only whitelisted addresses buy
381   function buyTokens(address beneficiary) fromWhitelistedAddr() payable {
382     super.buyTokens(beneficiary);
383   }
384 
385   // add a whitelisted address
386   function addWhitelistedAddr(address whitelistedAddr) onlyOwner {
387     require(!whitelistedAddrs[whitelistedAddr]);
388     whitelistedAddrs[whitelistedAddr] = true;
389   }
390 
391   // remove a whitelisted address
392   function removeWhitelistedAddr(address whitelistedAddr) onlyOwner {
393     require(whitelistedAddrs[whitelistedAddr]);
394     whitelistedAddrs[whitelistedAddr] = false;
395   }
396 
397   // finalization function called by the finalize function that will distribute
398   // the remaining tokens
399   function finalization() internal {
400     uint256 tokensSold = token.totalSupply();
401     uint256 finalTotalSupply = cap.mul(rate).mul(4);
402 
403     // send the 10% of the final total supply to the founders
404     uint256 foundersTokens = finalTotalSupply.div(10);
405     token.mint(foundersAddress, foundersTokens);
406 
407     // send the 65% plus the unsold tokens in ICO to the foundation
408     uint256 foundationTokens = finalTotalSupply.sub(tokensSold)
409       .sub(foundersTokens);
410     token.mint(foundationAddress, foundationTokens);
411 
412     super.finalization();
413   }
414 
415   function createTokenContract() internal returns (MintableToken) {
416     return new RenderToken();
417   }
418 
419 }
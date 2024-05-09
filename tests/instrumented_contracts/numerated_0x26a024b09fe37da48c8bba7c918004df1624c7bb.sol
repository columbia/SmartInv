1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner {
54     if (newOwner != address(0)) {
55       owner = newOwner;
56     }
57   }
58 
59 }
60 
61 contract ERC20Basic {
62   uint256 public totalSupply;
63   function balanceOf(address who) constant returns (uint256);
64   function transfer(address to, uint256 value) returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) returns (bool);
71   function approve(address spender, uint256 value) returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) returns (bool) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of. 
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amout of tokens to be transfered
113    */
114   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
115     var _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118     // require (_value <= _allowance);
119 
120     balances[_to] = balances[_to].add(_value);
121     balances[_from] = balances[_from].sub(_value);
122     allowed[_from][msg.sender] = _allowance.sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) returns (bool) {
133 
134     // To change the approve amount you first have to reduce the addresses`
135     //  allowance to zero by calling `approve(_spender, 0)` if it is not
136     //  already 0 to mitigate the race condition described here:
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifing the amount of tokens still avaible for the spender.
150    */
151   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155 }
156 
157 
158 contract MintableToken is StandardToken, Ownable {
159   event Mint(address indexed to, uint256 amount);
160   event MintFinished();
161 
162   bool public mintingFinished = false;
163 
164 
165   modifier canMint() {
166     require(!mintingFinished);
167     _;
168   }
169 
170   /**
171    * @dev Function to mint tokens
172    * @param _to The address that will recieve the minted tokens.
173    * @param _amount The amount of tokens to mint.
174    * @return A boolean that indicates if the operation was successful.
175    */
176   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
177     totalSupply = totalSupply.add(_amount);
178     balances[_to] = balances[_to].add(_amount);
179     Mint(_to, _amount);
180     return true;
181   }
182 
183   /**
184    * @dev Function to stop minting new tokens.
185    * @return True if the operation was successful.
186    */
187   function finishMinting() onlyOwner returns (bool) {
188     mintingFinished = true;
189     MintFinished();
190     return true;
191   }
192 }
193 
194 contract Crowdsale {
195   using SafeMath for uint256;
196 
197   // The token being sold
198   MintableToken public token;
199 
200   // start and end block where investments are allowed (both inclusive)
201   uint256 public startBlock;
202   uint256 public endBlock;
203 
204   // address where funds are collected
205   address public wallet;
206 
207   // how many token units a buyer gets per wei
208   uint256 public rate;
209 
210   // amount of raised money in wei
211   uint256 public weiRaised;
212 
213   /**
214    * event for token purchase logging
215    * @param purchaser who paid for the tokens
216    * @param beneficiary who got the tokens
217    * @param value weis paid for purchase
218    * @param amount amount of tokens purchased
219    */ 
220   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
221 
222 
223   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
224     require(_startBlock >= block.number);
225     require(_endBlock >= _startBlock);
226     require(_rate > 0);
227     require(_wallet != 0x0);
228 
229     token = createTokenContract();
230     startBlock = _startBlock;
231     endBlock = _endBlock;
232     rate = _rate;
233     wallet = _wallet;
234   }
235 
236   // creates the token to be sold. 
237   // override this method to have crowdsale of a specific mintable token.
238   function createTokenContract() internal returns (MintableToken) {
239     return new MintableToken();
240   }
241 
242 
243   // fallback function can be used to buy tokens
244   function () payable {
245     buyTokens(msg.sender);
246   }
247 
248   // low level token purchase function
249   function buyTokens(address beneficiary) payable {
250     require(beneficiary != 0x0);
251     require(validPurchase());
252 
253     uint256 weiAmount = msg.value;
254 
255     // calculate token amount to be created
256     uint256 tokens = weiAmount.mul(rate);
257 
258     // update state
259     weiRaised = weiRaised.add(weiAmount);
260 
261     token.mint(beneficiary, tokens);
262     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
263 
264     forwardFunds();
265   }
266 
267   // send ether to the fund collection wallet
268   // override to create custom fund forwarding mechanisms
269   function forwardFunds() internal {
270     wallet.transfer(msg.value);
271   }
272 
273   // @return true if the transaction can buy tokens
274   function validPurchase() internal constant returns (bool) {
275     uint256 current = block.number;
276     bool withinPeriod = current >= startBlock && current <= endBlock;
277     bool nonZeroPurchase = msg.value != 0;
278     return withinPeriod && nonZeroPurchase;
279   }
280 
281   // @return true if crowdsale event has ended
282   function hasEnded() public constant returns (bool) {
283     return block.number > endBlock;
284   }
285 
286 
287 }
288 
289 contract CappedCrowdsale is Crowdsale {
290   using SafeMath for uint256;
291 
292   uint256 public cap;
293 
294   function CappedCrowdsale(uint256 _cap) {
295     require(_cap > 0);
296     cap = _cap;
297   }
298 
299   function buyTokens(address _beneficiary) payable {
300     require(_beneficiary != 0x0);
301     require(validPurchase());
302 
303     uint256 weiAmount = msg.value;
304     
305     if (weiRaised.add(weiAmount) > cap) {
306         uint256 rest = weiRaised.add(weiAmount).sub(cap);
307 
308         _beneficiary.transfer(rest);
309         weiAmount = weiAmount.sub(rest);
310     }
311 
312     // calculate token amount to be created
313     uint256 tokens = weiAmount.mul(rate);
314 
315     // update state
316     weiRaised = weiRaised.add(weiAmount);
317 
318     token.mint(_beneficiary, tokens);
319     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
320 
321     forwardFunds(weiAmount);
322   }
323 
324   function forwardFunds(uint256 _amount) internal {
325     wallet.transfer(_amount);
326   }
327 
328   // overriding Crowdsale#validPurchase to add extra cap logic
329   // @return true if investors can buy at the moment
330   function validPurchase() internal constant returns (bool) {
331     bool withinCap = weiRaised < cap;
332     return super.validPurchase() && withinCap;
333   }
334 
335   // overriding Crowdsale#hasEnded to add cap logic
336   // @return true if crowdsale event has ended
337   function hasEnded() public constant returns (bool) {
338     bool capReached = weiRaised >= cap;
339     return super.hasEnded() || capReached;
340   }
341 
342 }
343 
344 
345 contract FinalizableCrowdsale is Crowdsale, Ownable {
346   using SafeMath for uint256;
347 
348   bool public isFinalized = false;
349 
350   event Finalized();
351 
352   // should be called after crowdsale ends, to do
353   // some extra finalization work
354   function finalize() onlyOwner {
355     require(!isFinalized);
356     require(hasEnded());
357 
358     finalization();
359     Finalized();
360     
361     isFinalized = true;
362   }
363 
364   // end token minting on finalization
365   // override this with custom logic if needed
366   function finalization() internal {
367     token.finishMinting();
368   }
369 
370 
371 
372 }
373 
374 contract FixedSupplyCrowdsale is FinalizableCrowdsale {
375     uint256 targetSupply;
376     address beneficiary;
377     address advisors;
378     uint256 share;
379     
380     function FixedSupplyCrowdsale(uint256 _targetSupply, address _beneficiary, address _advisors, uint256 _share) {
381         require(_targetSupply > 0);
382         require(_beneficiary != 0x0);
383         require(_advisors != 0x0);
384 
385         targetSupply = _targetSupply;
386         beneficiary = _beneficiary;
387         advisors = _advisors;
388         share = _share;
389     }
390 
391     function finalization() internal {
392         uint256 mintedSupply = token.totalSupply();
393         
394         if (mintedSupply < targetSupply) {
395             uint256 advisorsTokens = targetSupply.mul(share).div(100);
396             uint256 remainingSupply = targetSupply.sub(advisorsTokens).sub(mintedSupply);
397 
398             token.mint(advisors, advisorsTokens);
399             token.mint(beneficiary, remainingSupply);
400         }
401 
402         token.finishMinting();
403     }
404 }
405 
406 contract TGE is FixedSupplyCrowdsale, CappedCrowdsale {
407     using SafeMath for uint256;
408     
409     function TGE(
410         uint256 _start,
411         uint256 _end,
412         address _beneficiary,
413         address _advisors,
414         uint256 _share,
415         uint256 _cap,
416         uint256 _rate,
417         MintableToken _token
418         )
419         FixedSupplyCrowdsale(
420             21000000*10**18,
421             _beneficiary,
422             _advisors,
423             _share
424         )
425         CappedCrowdsale(
426             _cap*10**18
427         )
428         Crowdsale(
429             _start,
430             _end,
431             _rate,
432             _beneficiary
433         )
434     {
435         require(targetSupply.mul(share).div(100) <= targetSupply.sub(cap.mul(rate)));
436 
437         token = _token;
438     }
439 
440     function createTokenContract() internal returns (MintableToken) {
441         return MintableToken(0x0);
442     }
443 }
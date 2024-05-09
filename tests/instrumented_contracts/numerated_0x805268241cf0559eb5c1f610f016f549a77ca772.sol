1 pragma solidity ^0.4.18;
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
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract MultiOwners {
228 
229     event AccessGrant(address indexed owner);
230     event AccessRevoke(address indexed owner);
231     
232     mapping(address => bool) owners;
233     address public publisher;
234 
235 
236     function MultiOwners() {
237         owners[msg.sender] = true;
238         publisher = msg.sender;
239     }
240 
241     modifier onlyOwner() { 
242         require(owners[msg.sender] == true);
243         _; 
244     }
245 
246     function isOwner() constant returns (bool) {
247         return owners[msg.sender] ? true : false;
248     }
249 
250     function checkOwner(address maybe_owner) constant returns (bool) {
251         return owners[maybe_owner] ? true : false;
252     }
253 
254 
255     function grant(address _owner) onlyOwner {
256         owners[_owner] = true;
257         AccessGrant(_owner);
258     }
259 
260     function revoke(address _owner) onlyOwner {
261         require(_owner != publisher);
262         require(msg.sender != _owner);
263 
264         owners[_owner] = false;
265         AccessRevoke(_owner);
266     }
267 }
268 
269 contract Haltable is MultiOwners {
270     bool public halted;
271 
272     modifier stopInEmergency {
273         require(!halted);
274         _;
275     }
276 
277     modifier onlyInEmergency {
278         require(halted);
279         _;
280     }
281 
282     // called by the owner on emergency, triggers stopped state
283     function halt() external onlyOwner {
284         halted = true;
285     }
286 
287     // called by the owner on end of emergency, returns to normal state
288     function unhalt() external onlyOwner onlyInEmergency {
289         halted = false;
290     }
291 
292 }
293 
294 contract FixedRate {
295     uint256 public rateETHUSD = 470e2;
296 }
297 
298 contract Stage is FixedRate, MultiOwners {
299     using SafeMath for uint256;
300 
301     // Global
302     string _stageName = "Pre-ICO";
303 
304     // Maximum possible cap in USD
305     uint256 public mainCapInUSD = 1000000e2;
306 
307     // Maximum possible cap in USD
308     uint256 public hardCapInUSD = mainCapInUSD;
309 
310     //  period in days
311     uint256 public period = 30 days;
312 
313     // Token Price in USD
314     uint256 public tokenPriceUSD = 50;
315 
316     // WEI per token
317     uint256 public weiPerToken;
318     
319     // start and end timestamp where investments are allowed (both inclusive)
320     uint256 public startTime;
321     uint256 public endTime;
322 
323     // total wei received during phase one
324     uint256 public totalWei;
325 
326     // Maximum possible cap in wei for phase one
327     uint256 public mainCapInWei;
328     // Maximum possible cap in wei
329     uint256 public hardCapInWei;
330 
331     function Stage (uint256 _startTime) {
332         startTime = _startTime;
333         endTime = startTime.add(period);
334         weiPerToken = tokenPriceUSD.mul(1 ether).div(rateETHUSD);
335         mainCapInWei = mainCapInUSD.mul(1 ether).div(rateETHUSD);
336         hardCapInWei = mainCapInWei;
337 
338     }
339 
340     /*
341      * @dev amount calculation, depends of current period
342      * @param _value ETH in wei
343      * @param _at time
344      */
345     function calcAmountAt(uint256 _value, uint256 _at) constant returns (uint256, uint256) {
346         uint256 estimate;
347         uint256 odd;
348 
349         if(_value.add(totalWei) > hardCapInWei) {
350             odd = _value.add(totalWei).sub(hardCapInWei);
351             _value = hardCapInWei.sub(totalWei);
352         } 
353         estimate = _value.mul(1 ether).div(weiPerToken);
354         require(_value + totalWei <= hardCapInWei);
355         return (estimate, odd);
356     }
357 }
358 
359 contract TripleAlphaCrowdsalePreICO is MultiOwners, Haltable, Stage {
360     using SafeMath for uint256;
361 
362     // minimal token selled per time
363     uint256 public minimalTokens = 1e18;
364 
365     // Sale token
366     TripleAlphaTokenPreICO public token;
367 
368     // Withdraw wallet
369     address public wallet;
370 
371     // Events
372     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
373     event OddMoney(address indexed beneficiary, uint256 value);
374 
375     modifier validPurchase() {
376         bool nonZeroPurchase = msg.value != 0;
377 
378         require(withinPeriod() && nonZeroPurchase);
379 
380         _;        
381     }
382 
383     modifier isExpired() {
384         require(now > endTime);
385 
386         _;        
387     }
388 
389     /**
390      * @return true if in period or false if not
391      */
392     function withinPeriod() constant returns(bool res) {
393         return (now >= startTime && now <= endTime);
394     }
395 
396     /**
397      * @param _startTime Pre-ITO start time
398      * @param _wallet destination fund address (i hope it will be multi-sig)
399      */
400     function TripleAlphaCrowdsalePreICO(uint256 _startTime, address _wallet) Stage(_startTime)
401 
402     {
403         require(_startTime >= now);
404         require(_wallet != 0x0);
405 
406         token = new TripleAlphaTokenPreICO();
407         wallet = _wallet;
408     }
409 
410     /**
411      * @dev Human readable period Name 
412      * @return current stage name
413      */
414     function stageName() constant public returns (string) {
415         bool before = (now < startTime);
416         bool within = (now >= startTime && now <= endTime);
417 
418         if(before) {
419             return 'Not started';
420         }
421 
422         if(within) {
423             return _stageName;
424         } 
425 
426         return 'Finished';
427     }
428 
429     
430     function totalEther() public constant returns(uint256) {
431         return totalWei.div(1e18);
432     }
433 
434     /*
435      * @dev fallback for processing ether
436      */
437     function() payable {
438         return buyTokens(msg.sender);
439     }
440 
441     /*
442      * @dev sell token and send to contributor address
443      * @param contributor address
444      */
445     function buyTokens(address contributor) payable stopInEmergency validPurchase public {
446         uint256 amount;
447         uint256 odd_ethers;
448         
449         (amount, odd_ethers) = calcAmountAt(msg.value, now);
450   
451         require(contributor != 0x0) ;
452         require(minimalTokens <= amount);
453 
454         token.mint(contributor, amount);
455         TokenPurchase(contributor, msg.value, amount);
456 
457         totalWei = totalWei.add(msg.value);
458 
459         if(odd_ethers > 0) {
460             require(odd_ethers < msg.value);
461             OddMoney(contributor, odd_ethers);
462             contributor.transfer(odd_ethers);
463         }
464 
465         wallet.transfer(this.balance);
466     }
467 
468     /*
469      * @dev finish crowdsale
470      */
471     function finishCrowdsale() onlyOwner public {
472         require(now > endTime || totalWei == hardCapInWei);
473         require(!token.mintingFinished());
474         token.finishMinting();
475     }
476 
477     // @return true if crowdsale event has ended
478     function running() constant public returns (bool) {
479         return withinPeriod() && !token.mintingFinished();
480     }
481 }
482 
483 contract TripleAlphaTokenPreICO is MintableToken {
484 
485     string public constant name = 'Triple Alpha Token Pre-ICO';
486     string public constant symbol = 'pTRIA';
487     uint8 public constant decimals = 18;
488 
489     function transferFrom(address from, address to, uint256 value) returns (bool) {
490         revert();
491     }
492 
493     function transfer(address to, uint256 value) returns (bool) {
494         revert();
495     }
496 }
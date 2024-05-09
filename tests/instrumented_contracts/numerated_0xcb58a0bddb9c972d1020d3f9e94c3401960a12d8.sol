1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 
72 }
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79     event Pause();
80     event Unpause();
81 
82     bool public paused = false;
83 
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is not paused.
87      */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94      * @dev Modifier to make a function callable only when the contract is paused.
95      */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102      * @dev called by the owner to pause, triggers stopped state
103      */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         Pause();
107     }
108 
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         Unpause();
115     }
116 }
117 
118 contract ERC20Basic {
119     uint256 public totalSupply;
120     function balanceOf(address who) public view returns (uint256);
121     function transfer(address to, uint256 value) public returns (bool);
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 
126 contract ERC20 is ERC20Basic {
127     function allowance(address owner, address spender) public view returns (uint256);
128     function transferFrom(address from, address to, uint256 value) public returns (bool);
129     function approve(address spender, uint256 value) public returns (bool);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 contract BasicToken is ERC20Basic {
134     using SafeMath for uint256;
135 
136     mapping(address => uint256) balances;
137 
138     /**
139     * @dev transfer token for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Gets the balance of the specified address.
156     * @param _owner The address to query the the balance of.
157     * @return An uint256 representing the amount owned by the passed address.
158     */
159     function balanceOf(address _owner) public view returns (uint256 balance) {
160         return balances[_owner];
161     }
162 
163 }
164 
165 contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param _from address The address which you want to send tokens from
173      * @param _to address The address which you want to transfer to
174      * @param _value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }
238 
239 contract PausableToken is StandardToken, Pausable {
240 
241     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
242         return super.transfer(_to, _value);
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
246         return super.transferFrom(_from, _to, _value);
247     }
248 
249     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
250         return super.approve(_spender, _value);
251     }
252 
253     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
254         return super.increaseApproval(_spender, _addedValue);
255     }
256 
257     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
258         return super.decreaseApproval(_spender, _subtractedValue);
259     }
260 }
261 
262 contract MintableToken is PausableToken {
263     event Mint(address indexed to, uint256 amount);
264     event MintFinished();
265 
266     bool public mintingFinished = false;
267 
268 
269     modifier canMint() {
270         require(!mintingFinished);
271         _;
272     }
273 
274     /**
275      * @dev Function to mint tokens
276      * @param _to The address that will receive the minted tokens.
277      * @param _amount The amount of tokens to mint.
278      * @return A boolean that indicates if the operation was successful.
279      */
280     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281         totalSupply = totalSupply.add(_amount);
282         balances[_to] = balances[_to].add(_amount);
283         Mint(_to, _amount);
284         Transfer(address(0), _to, _amount);
285         return true;
286     }
287 
288     /**
289      * @dev Function to stop minting new tokens.
290      * @return True if the operation was successful.
291      */
292     function finishMinting() onlyOwner canMint public returns (bool) {
293         mintingFinished = true;
294         MintFinished();
295         return true;
296     }
297 }
298 
299 contract TokenImpl is MintableToken {
300     string public name;
301     string public symbol;
302 
303     // how many token units a buyer gets per ether
304     uint256 public rate;
305 
306     uint256 public decimals = 5;
307     uint256 private decimal_num = 100000;
308 
309     // the target token
310     ERC20Basic public targetToken;
311 
312     uint256 public exchangedNum;
313 
314     event Exchanged(address _owner, uint256 _value);
315 
316     function TokenImpl(string _name, string _symbol, uint256 _decimals) public {
317         name = _name;
318         symbol = _symbol;
319         decimals = _decimals;
320         decimal_num = 10 ** decimals;
321         paused = true;
322     }
323     /**
324       * @dev exchange tokens of _exchanger.
325       */
326     function exchange(address _exchanger, uint256 _value) internal {
327         require(canExchange());
328         uint256 _tokens = (_value.mul(rate)).div(decimal_num);
329         targetToken.transfer(_exchanger, _tokens);
330         exchangedNum = exchangedNum.add(_value);
331         Exchanged(_exchanger, _tokens);
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335         if (_to == address(this) || _to == owner) {
336             exchange(msg.sender, _value);
337         }
338         return super.transferFrom(_from, _to, _value);
339     }
340 
341     function transfer(address _to, uint256 _value) public returns (bool) {
342         if (_to == address(this) || _to == owner) {
343             exchange(msg.sender, _value);
344         }
345         return super.transfer(_to, _value);
346     }
347 
348     function balanceOfTarget(address _owner) public view returns (uint256 targetBalance) {
349         if (targetToken != address(0)) {
350             return targetToken.balanceOf(_owner);
351         } else {
352             return 0;
353         }
354     }
355 
356     function canExchangeNum() public view returns (uint256) {
357         if (canExchange()) {
358             uint256 _tokens = targetToken.balanceOf(this);
359             return (decimal_num.mul(_tokens)).div(rate);
360         } else {
361             return 0;
362         }
363     }
364 
365     function updateTargetToken(address _target, uint256 _rate) onlyOwner public {
366         rate = _rate;
367         targetToken = ERC20Basic(_target);
368     }
369 
370     function canExchange() public view returns (bool) {
371         return targetToken != address(0) && rate > 0;
372     }
373 
374 
375 }
376 
377 contract Crowdsale is Pausable {
378     using SafeMath for uint256;
379 
380     string public projectName;
381 
382     string public tokenName;
383     string public tokenSymbol;
384 
385     // how many token units a buyer gets per ether
386     uint256 public rate;
387 
388     // amount of raised money in wei, decimals is 5
389     uint256 public ethRaised;
390     uint256 public decimals = 5;
391     uint256 private decimal_num = 100000;
392 
393     // cap of money in wei
394     uint256 public cap;
395 
396     // The token being sold
397     TokenImpl public token;
398 
399     // the target token
400     ERC20Basic public targetToken;
401 
402     /**
403      * event for token purchase logging
404      * @param purchaser who paid for the tokens
405      * @param beneficiary who got the tokens
406      * @param value weis paid for purchase
407      */
408     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value);
409     event IncreaseCap(uint256 cap);
410     event DecreaseCap(uint256 cap);
411     event TransferTargetToken(address owner, uint256 value);
412 
413 
414     function Crowdsale(string _projectName, string _tokenName, string _tokenSymbol,
415         uint256 _cap) public {
416         require(_cap > 0);
417         projectName = _projectName;
418         tokenName = _tokenName;
419         tokenSymbol = _tokenSymbol;
420         cap = _cap.mul(decimal_num);
421         token = createTokenContract();
422     }
423 
424     function newCrowdSale(string _projectName, string _tokenName,
425         string _tokenSymbol, uint256 _cap) onlyOwner public {
426         require(_cap > 0);
427         projectName = _projectName;
428         tokenName = _tokenName;
429         tokenSymbol = _tokenSymbol;
430         cap = _cap.mul(decimal_num);
431         ethRaised = 0;
432         token.transferOwnership(owner);
433         token = createTokenContract();
434         rate = 0;
435         targetToken = ERC20Basic(0);
436     }
437 
438     function createTokenContract() internal returns (TokenImpl) {
439         return new TokenImpl(tokenName, tokenSymbol, decimals);
440     }
441 
442     // fallback function can be used to buy tokens
443     function() external payable {
444         buyTokens(msg.sender);
445     }
446 
447     // low level token purchase function
448     function buyTokens(address beneficiary) whenNotPaused public payable {
449         require(beneficiary != address(0));
450         require(msg.value >= (0.00001 ether));
451 
452         uint256 ethAmount = (msg.value.mul(decimal_num)).div(1 ether);
453 
454         // update state
455         ethRaised = ethRaised.add(ethAmount);
456         require(ethRaised <= cap);
457 
458         token.mint(beneficiary, ethAmount);
459         TokenPurchase(msg.sender, beneficiary, ethAmount);
460 
461         forwardFunds();
462     }
463 
464     // send ether to the fund collection wallet
465     // override to create custom fund forwarding mechanisms
466     function forwardFunds() internal {
467         owner.transfer(msg.value);
468     }
469 
470     // increase the amount of eth
471     function increaseCap(uint256 _cap_inc) onlyOwner public {
472         require(_cap_inc > 0);
473         cap = cap.add(_cap_inc.mul(decimal_num));
474         IncreaseCap(cap);
475     }
476 
477     function decreaseCap(uint256 _cap_dec) onlyOwner public {
478         require(_cap_dec > 0);
479         uint256 cap_dec = _cap_dec.mul(decimal_num);
480         if (cap_dec >= cap) {
481             cap = ethRaised;
482         } else {
483             cap = cap.sub(cap_dec);
484             if (cap <= ethRaised) {
485                 cap = ethRaised;
486             }
487         }
488         DecreaseCap(cap);
489     }
490 
491     function saleRatio() public view returns (uint256 ratio) {
492         if (cap == 0) {
493             return 0;
494         } else {
495             return ethRaised.mul(10000).div(cap);
496         }
497     }
498 
499 
500     function balanceOf(address _owner) public view returns (uint256 balance) {
501         return token.balanceOf(_owner);
502     }
503 
504     function balanceOfTarget(address _owner) public view returns (uint256 targetBalance) {
505         return token.balanceOfTarget(_owner);
506     }
507 
508     function canExchangeNum() public view returns (uint256) {
509         return token.canExchangeNum();
510     }
511 
512     function updateTargetToken(address _target, uint256 _rate) onlyOwner public {
513         rate = _rate;
514         targetToken = ERC20Basic(_target);
515         token.updateTargetToken(_target, _rate);
516     }
517 
518     /**
519      * @dev called by the owner to transfer the target token to _owner from this contact
520      */
521     function transferTargetToken(address _owner, uint256 _value) onlyOwner public returns (bool) {
522         if (targetToken != address(0)) {
523             TransferTargetToken(_owner, _value);
524             return targetToken.transfer(_owner, _value);
525         } else {
526             return false;
527         }
528     }
529 
530 
531     /**
532      * @dev called by the owner to pause, triggers stopped state
533      */
534     function pauseToken() onlyOwner public {
535         token.pause();
536     }
537 
538     /**
539      * @dev called by the owner to unpause, returns to normal state
540      */
541     function unpauseToken() onlyOwner public {
542         token.unpause();
543     }
544 
545 }
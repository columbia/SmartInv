1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 
76 }
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83     event Pause();
84     event Unpause();
85 
86     bool public paused = false;
87 
88 
89     /**
90      * @dev Modifier to make a function callable only when the contract is not paused.
91      */
92     modifier whenNotPaused() {
93         require(!paused);
94         _;
95     }
96 
97     /**
98      * @dev Modifier to make a function callable only when the contract is paused.
99      */
100     modifier whenPaused() {
101         require(paused);
102         _;
103     }
104 
105     /**
106      * @dev called by the owner to pause, triggers stopped state
107      */
108     function pause() onlyOwner whenNotPaused public {
109         paused = true;
110         Pause();
111     }
112 
113     /**
114      * @dev called by the owner to unpause, returns to normal state
115      */
116     function unpause() onlyOwner whenPaused public {
117         paused = false;
118         Unpause();
119     }
120 }
121 
122 contract ERC20Basic {
123     uint256 public totalSupply;
124 
125     function balanceOf(address who) public view returns (uint256);
126 
127     function transfer(address to, uint256 value) public returns (bool);
128 
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract ERC20 is ERC20Basic {
133     function allowance(address owner, address spender) public view returns (uint256);
134 
135     function transferFrom(address from, address to, uint256 value) public returns (bool);
136 
137     function approve(address spender, uint256 value) public returns (bool);
138 
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract BasicToken is ERC20Basic {
143     using SafeMath for uint256;
144 
145     mapping(address => uint256) balances;
146 
147     /**
148     * @dev transfer token for a specified address
149     * @param _to The address to transfer to.
150     * @param _value The amount to be transferred.
151     */
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[msg.sender]);
155 
156         // SafeMath.sub will throw if there is not enough balance.
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         Transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Gets the balance of the specified address.
165     * @param _owner The address to query the the balance of.
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168     function balanceOf(address _owner) public view returns (uint256 balance) {
169         return balances[_owner];
170     }
171 
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175 
176     mapping(address => mapping(address => uint256)) internal allowed;
177 
178 
179     /**
180      * @dev Transfer tokens from one address to another
181      * @param _from address The address which you want to send tokens from
182      * @param _to address The address which you want to transfer to
183      * @param _value uint256 the amount of tokens to be transferred
184      */
185     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186         require(_to != address(0));
187         require(_value <= balances[_from]);
188         require(_value <= allowed[_from][msg.sender]);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199      *
200      * Beware that changing an allowance with this method brings the risk that someone may use both the old
201      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      * @param _spender The address which will spend the funds.
205      * @param _value The amount of tokens to be spent.
206      */
207     function approve(address _spender, uint256 _value) public returns (bool) {
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     /**
214      * @dev Function to check the amount of tokens that an owner allowed to a spender.
215      * @param _owner address The address which owns the funds.
216      * @param _spender address The address which will spend the funds.
217      * @return A uint256 specifying the amount of tokens still available for the spender.
218      */
219     function allowance(address _owner, address _spender) public view returns (uint256) {
220         return allowed[_owner][_spender];
221     }
222 
223     /**
224      * approve should be called when allowed[_spender] == 0. To increment
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      */
229     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236         uint oldValue = allowed[msg.sender][_spender];
237         if (_subtractedValue > oldValue) {
238             allowed[msg.sender][_spender] = 0;
239         } else {
240             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241         }
242         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243         return true;
244     }
245 
246 }
247 
248 contract PausableToken is StandardToken, Pausable {
249 
250     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
251         return super.transfer(_to, _value);
252     }
253 
254     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
255         return super.transferFrom(_from, _to, _value);
256     }
257 
258     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
259         return super.approve(_spender, _value);
260     }
261 
262     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
263         return super.increaseApproval(_spender, _addedValue);
264     }
265 
266     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
267         return super.decreaseApproval(_spender, _subtractedValue);
268     }
269 }
270 
271 contract MintableToken is PausableToken {
272     event Mint(address indexed to, uint256 amount);
273     event MintFinished();
274 
275     bool public mintingFinished = false;
276 
277 
278     modifier canMint() {
279         require(!mintingFinished);
280         _;
281     }
282 
283     /**
284      * @dev Function to mint tokens
285      * @param _to The address that will receive the minted tokens.
286      * @param _amount The amount of tokens to mint.
287      * @return A boolean that indicates if the operation was successful.
288      */
289     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290         totalSupply = totalSupply.add(_amount);
291         balances[_to] = balances[_to].add(_amount);
292         Mint(_to, _amount);
293         Transfer(address(0), _to, _amount);
294         return true;
295     }
296 
297     /**
298      * @dev Function to stop minting new tokens.
299      * @return True if the operation was successful.
300      */
301     function finishMinting() onlyOwner canMint public returns (bool) {
302         mintingFinished = true;
303         MintFinished();
304         return true;
305     }
306 }
307 
308 contract TokenImpl is MintableToken {
309     string public name;
310     string public symbol;
311 
312     // how many token units a buyer gets per ether
313     uint256 public rate;
314 
315     uint256 public eth_decimal_num = 100000;
316 
317     // the target token
318     ERC20Basic public targetToken;
319 
320     uint256 public exchangedNum;
321 
322     event Exchanged(address _owner, uint256 _value);
323 
324     function TokenImpl(string _name, string _symbol, uint256 _decimal_num) public {
325         name = _name;
326         symbol = _symbol;
327         eth_decimal_num = _decimal_num;
328         paused = true;
329     }
330     /**
331       * @dev exchange tokens of _exchanger.
332       */
333     function exchange(address _exchanger, uint256 _value) internal {
334         require(canExchange());
335         uint256 _tokens = (_value.mul(rate)).div(eth_decimal_num);
336         targetToken.transfer(_exchanger, _tokens);
337         exchangedNum = exchangedNum.add(_value);
338         Exchanged(_exchanger, _tokens);
339     }
340 
341     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
342         if (_to == address(this) || _to == owner) {
343             exchange(msg.sender, _value);
344         }
345         return super.transferFrom(_from, _to, _value);
346     }
347 
348     function transfer(address _to, uint256 _value) public returns (bool) {
349         if (_to == address(this) || _to == owner) {
350             exchange(msg.sender, _value);
351         }
352         return super.transfer(_to, _value);
353     }
354 
355     function balanceOfTarget(address _owner) public view returns (uint256 targetBalance) {
356         if (targetToken != address(0)) {
357             return targetToken.balanceOf(_owner);
358         } else {
359             return 0;
360         }
361     }
362 
363     function canExchangeNum() public view returns (uint256) {
364         if (canExchange()) {
365             uint256 _tokens = targetToken.balanceOf(this);
366             return (eth_decimal_num.mul(_tokens)).div(rate);
367         } else {
368             return 0;
369         }
370     }
371 
372     function updateTargetToken(address _target, uint256 _rate) onlyOwner public {
373         rate = _rate;
374         targetToken = ERC20Basic(_target);
375     }
376 
377     function canExchange() public view returns (bool) {
378         return targetToken != address(0) && rate > 0;
379     }
380 
381 
382 }
383 
384 contract Crowdsale is Pausable {
385     using SafeMath for uint256;
386 
387     string public projectName;
388 
389     string public tokenName;
390     string public tokenSymbol;
391 
392     // how many token units a buyer gets per ether
393     uint256 public rate;
394 
395     // amount of raised money in wei, decimals is 5
396     uint256 public ethRaised;
397     uint256 public eth_decimal_num = 100000;
398 
399     // cap of money in wei
400     uint256 public cap;
401 
402     // The token being sold
403     TokenImpl public token;
404 
405     // the target token
406     ERC20Basic public targetToken;
407 
408     /**
409      * event for token purchase logging
410      * @param purchaser who paid for the tokens
411      * @param beneficiary who got the tokens
412      * @param value weis paid for purchase
413      */
414     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value);
415     event IncreaseCap(uint256 cap);
416     event DecreaseCap(uint256 cap);
417 
418 
419     function Crowdsale(string _projectName, string _tokenName, string _tokenSymbol, uint256 _cap) public {
420         require(_cap > 0);
421         projectName = _projectName;
422         tokenName = _tokenName;
423         tokenSymbol = _tokenSymbol;
424         cap = _cap.mul(eth_decimal_num);
425         token = createTokenContract();
426     }
427 
428     function newCrowdSale(string _projectName, string _tokenName,
429         string _tokenSymbol, uint256 _cap) onlyOwner public {
430         require(_cap > 0);
431         projectName = _projectName;
432         tokenName = _tokenName;
433         tokenSymbol = _tokenSymbol;
434         cap = _cap.mul(eth_decimal_num);
435         ethRaised = 0;
436         token.transferOwnership(owner);
437         token = createTokenContract();
438         rate = 0;
439         targetToken = ERC20Basic(0);
440     }
441 
442 
443     function createTokenContract() internal returns (TokenImpl) {
444         return new TokenImpl(tokenName, tokenSymbol, eth_decimal_num);
445     }
446 
447     // fallback function can be used to buy tokens
448     function() external payable {
449         buyTokens(msg.sender);
450     }
451 
452     // low level token purchase function
453     function buyTokens(address beneficiary) whenNotPaused public payable {
454         require(beneficiary != address(0));
455         require(msg.value >= (0.00001 ether));
456 
457         uint256 ethAmount = (msg.value.mul(eth_decimal_num)).div(1 ether);
458 
459         // update state
460         ethRaised = ethRaised.add(ethAmount);
461         require(ethRaised <= cap);
462 
463         token.mint(beneficiary, ethAmount);
464         TokenPurchase(msg.sender, beneficiary, ethAmount);
465 
466         forwardFunds();
467     }
468 
469     // send ether to the fund collection wallet
470     // override to create custom fund forwarding mechanisms
471     function forwardFunds() internal {
472         owner.transfer(msg.value);
473     }
474 
475     // increase the amount of eth
476     function increaseCap(uint256 _cap_inc) onlyOwner public {
477         require(_cap_inc > 0);
478         cap = cap.add(_cap_inc.mul(eth_decimal_num));
479         IncreaseCap(cap);
480     }
481 
482     function decreaseCap(uint256 _cap_dec) onlyOwner public {
483         require(_cap_dec > 0);
484         cap = cap.sub(_cap_dec.mul(eth_decimal_num));
485         if (cap <= ethRaised) {
486             cap = ethRaised;
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
519      * @dev called by the owner to transfer the target token to owner from this contact
520      */
521     function releaseTargetToken(uint256 _value) onlyOwner public returns (bool) {
522         if (targetToken != address(0)) {
523             return targetToken.transfer(owner, _value);
524         } else {
525             return false;
526         }
527     }
528 
529 
530     /**
531      * @dev called by the owner to pause, triggers stopped state
532      */
533     function pauseToken() onlyOwner public {
534         token.pause();
535     }
536 
537     /**
538      * @dev called by the owner to unpause, returns to normal state
539      */
540     function unpauseToken() onlyOwner public {
541         token.unpause();
542     }
543 
544 
545     // @return true if crowdsale event has ended
546     function hasEnded() public view returns (bool) {
547         return ethRaised >= cap;
548     }
549 
550 }
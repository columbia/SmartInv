1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17 * @title ERC20 interface
18 * @dev see https://github.com/ethereum/EIPs/issues/20
19 */
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28 * @title SafeMath
29 * @dev Math operations with safety checks that throw on error
30 */
31 library SafeMath {
32 
33     /**
34     * @dev Multiplies two numbers, throws on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     /**
46     * @dev Integer division of two numbers, truncating the quotient.
47     */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // assert(b > 0); // Solidity automatically throws when dividing by 0
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52         return c;
53     }
54 
55     /**
56     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61     }
62 
63     /**
64     * @dev Adds two numbers, throws on overflow.
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 }
72 
73 /**
74 * @title Ownable
75 * @dev The Ownable contract has an owner address, and provides basic authorization control
76 * functions, this simplifies the implementation of "user permissions".
77 */
78 contract Ownable {
79     address public owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85     * account.
86     */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     /**
92     * @dev Throws if called by any account other than the owner.
93     */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100     * @dev Allows the current owner to transfer control of the contract to a newOwner.
101     * @param newOwner The address to transfer ownership to.
102     */
103     function transferOwnership(address newOwner) public onlyOwner {
104         require(newOwner != address(0));
105         emit OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107     }
108 
109 }
110 
111 contract CanReclaimToken is Ownable {
112     /**
113     * @dev Reclaim all ERC20Basic compatible tokens
114     * @param token ERC20Basic The address of the token contract
115     */
116     function reclaimToken(ERC20Basic token) external onlyOwner {
117         uint256 balance = token.balanceOf(this);
118         token.transfer(owner, balance);
119     }
120 }
121 
122 /**
123 * @title Basic token
124 * @dev Basic version of StandardToken, with no allowances.
125 */
126 contract BasicToken is ERC20Basic {
127     using SafeMath for uint256;
128 
129     mapping(address => uint256) balances;
130 
131     uint256 totalSupply_;
132 
133     /**
134     * @dev total number of tokens in existence
135     */
136     function totalSupply() public view returns (uint256) {
137         return totalSupply_;
138     }
139 
140     /**
141     * @dev transfer token for a specified address
142     * @param _to The address to transfer to.
143     * @param _value The amount to be transferred.
144     */
145     function transfer(address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[msg.sender]);
148 
149         // SafeMath.sub will throw if there is not enough balance.
150         balances[msg.sender] = balances[msg.sender].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         emit Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     /**
157     * @dev Gets the balance of the specified address.
158     * @param _owner The address to query the the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function balanceOf(address _owner) public view returns (uint256 balance) {
162         return balances[_owner];
163     }
164 }
165 
166 /**
167 * @title Standard ERC20 token
168 *
169 * @dev Implementation of the basic standard token.
170 * @dev https://github.com/ethereum/EIPs/issues/20
171 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172 */
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping (address => mapping (address => uint256)) internal allowed;
176 
177     /**
178     * @dev Transfer tokens from one address to another
179     * @param _from address The address which you want to send tokens from
180     * @param _to address The address which you want to transfer to
181     * @param _value uint256 the amount of tokens to be transferred
182     */
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191         emit Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     /**
196     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197     *
198     * Beware that changing an allowance with this method brings the risk that someone may use both the old
199     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     * @param _spender The address which will spend the funds.
203     * @param _value The amount of tokens to be spent.
204     */
205     function approve(address _spender, uint256 _value) public returns (bool) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens that an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint256 specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222     * @dev Increase the amount of tokens that an owner allowed to a spender.
223     *
224     * approve should be called when allowed[_spender] == 0. To increment
225     * allowed value is better to use this function to avoid 2 calls (and wait until
226     * the first transaction is mined)
227     * From MonolithDAO Token.sol
228     * @param _spender The address which will spend the funds.
229     * @param _addedValue The amount of tokens to increase the allowance by.
230     */
231     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     /**
238     * @dev Decrease the amount of tokens that an owner allowed to a spender.
239     *
240     * approve should be called when allowed[_spender] == 0. To decrement
241     * allowed value is better to use this function to avoid 2 calls (and wait until
242     * the first transaction is mined)
243     * From MonolithDAO Token.sol
244     * @param _spender The address which will spend the funds.
245     * @param _subtractedValue The amount of tokens to decrease the allowance by.
246     */
247     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248         uint oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue > oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253         }
254 
255         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 }
259 
260 /**
261 * @title Mintable token
262 * @dev Simple ERC20 Token example, with mintable token creation
263 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265 */
266 contract MintableToken is StandardToken, Ownable {
267     event Mint(address indexed to, uint256 amount);
268     event MintFinished();
269     bool public mintingFinished = false;
270 
271     modifier canMint() {
272         require(!mintingFinished);
273         _;
274     }
275 
276     /**
277     * @dev Function to mint tokens
278     * @param _to The address that will receive the minted tokens.
279     * @param _amount The amount of tokens to mint.
280     * @return A boolean that indicates if the operation was successful.
281     */
282     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
283         totalSupply_ = totalSupply_.add(_amount);
284         balances[_to] = balances[_to].add(_amount);
285         emit Mint(_to, _amount);
286         emit Transfer(address(0), _to, _amount);
287         return true;
288     }
289 
290     /**
291     * @dev Function to stop minting new tokens.
292     * @return True if the operation was successful.
293     */
294     function finishMinting() public onlyOwner canMint returns (bool) {
295         mintingFinished = true;
296         emit MintFinished();
297         return true;
298     }
299 }
300 
301 interface BLLNDividendInterface {
302     function setTokenAddress(address _tokenAddress) external;
303     function buyToken() external payable;
304     function withdraw(uint256 _amount) external;
305     function withdrawTo(address _to, uint256 _amount) external;
306     function updateDividendBalance(uint256 _totalSupply, address _address, uint256 _tokensAmount) external;
307     function transferTokens(address _from, address _to, uint256 _amount) external returns (bool);
308     function shareDividends() external payable;
309     function getDividendBalance(address _address) external view returns (uint256);
310 }
311 
312 contract BLLNToken is MintableToken, CanReclaimToken {
313     string public constant name = "Billion Token";
314     string public constant symbol = "BLLN";
315     uint32 public constant decimals = 0;
316     uint256 public constant maxTotalSupply = 250*(10**6);
317     BLLNDividendInterface public dividend;
318 
319     constructor(address _dividendAddress) public {
320         require(_dividendAddress != address(0));
321         dividend = BLLNDividendInterface(_dividendAddress);
322     }
323 
324     modifier canMint() {
325         require(totalSupply_ < maxTotalSupply);
326         _;
327     }
328 
329     modifier onlyDividend() {
330         require(msg.sender == address(dividend));
331         _;
332     }
333 
334     modifier onlyPayloadSize(uint size) {
335         require(msg.data.length == size + 4);
336         _;
337     }
338 
339     function () public {}
340 
341     function mint(address _to, uint256 _amount) public onlyDividend canMint returns (bool) {
342         require(_to != address(0));
343         require(_amount != 0);
344         uint256 newTotalSupply = totalSupply_.add(_amount);
345         require(newTotalSupply <= maxTotalSupply);
346 
347         totalSupply_ = newTotalSupply;
348         balances[_to] = balances[_to].add(_amount);
349 
350         dividend.updateDividendBalance(totalSupply_, _to, _amount);
351         emit Mint(_to, _amount);
352         emit Transfer(address(0), _to, _amount);
353         return true;
354     }
355 
356     function transfer(address _to, uint256 _value) public onlyPayloadSize(2*32) returns (bool) {
357         require(_to != address(0));
358         require(_value <= balances[msg.sender]);
359 
360         balances[msg.sender] = balances[msg.sender].sub(_value);
361         balances[_to] = balances[_to].add(_value);
362         require(dividend.transferTokens(msg.sender, _to, _value));
363         emit Transfer(msg.sender, _to, _value);
364         return true;
365     }
366 }
367 
368 contract Log {
369     function ln(uint256 _x)  public pure returns (int256) {
370         require(_x < 2**255);
371         require(_x >= 10**18);
372 
373         int256 epsilon = 1000;
374         int256 x = int256(_x);
375         int256 result = 0;
376         while (x >= 1.5*(10**18)) {
377             result = result + 405465108108164381; // log2(1.5)
378             x = x * 2 / 3;
379         }
380         x = x - 10**18;
381         int256 next = x;
382         int step = 1;
383         while (next > epsilon) {
384             result = result + (next / step);
385             step = step + 1;
386             next = next * x / 10**18;
387             result = result - (next / step);
388             step = step + 1;
389             next = next * x / 10**18;
390         }
391         return result;
392     }
393 }
394 
395 contract BLLNDividend is Ownable, Log, BLLNDividendInterface, CanReclaimToken {
396     using SafeMath for uint256;
397 
398     event PresaleFinished();
399 
400     event DividendsArrived(
401         uint256 newD_n
402     );
403 
404     struct UserHistory {
405         uint256 lastD_n;
406         uint256 tokens;
407     }
408 
409     uint256 internal constant rounding = 10**18;
410 
411     BLLNToken public m_token;
412     bool public m_presaleFinished;
413     uint256 public m_sharedDividendBalance;
414     uint256 public m_maxTotalSupply;
415     uint256 public m_tokenPrice = 300 szabo; // 0.11$
416     uint256 public m_tokenDiscountThreshold;
417 
418     uint256 public m_D_n;
419     uint256 public m_totalTokens;
420     mapping (address => uint256) public m_dividendBalances;
421     mapping (address => UserHistory) public m_userHistories;
422 
423     constructor(uint256 _maxTotalSupply) public {
424         require(_maxTotalSupply > 0);
425 
426         m_presaleFinished = false;
427         owner = msg.sender;
428         m_maxTotalSupply = _maxTotalSupply;
429         m_tokenDiscountThreshold = 10**4;
430     }
431 
432     modifier onlyToken() {
433         require(msg.sender == address(m_token));
434         _;
435     }
436 
437     modifier onlyPresale() {
438         require(!m_presaleFinished);
439         _;
440     }
441 
442     function () external payable {
443         buyTokens(msg.sender);
444     }
445 
446     function setTokenAddress(address _tokenAddress) external onlyOwner {
447         require(_tokenAddress != address(0));
448         m_token = BLLNToken(_tokenAddress);
449     }
450 
451     function setTokenDiscountThreshold(uint256 _discountThreshold) external onlyOwner {
452         require(_discountThreshold > 0);
453         m_tokenDiscountThreshold = _discountThreshold;
454     }
455 
456     function mintPresale(uint256 _presaleAmount, address _receiver) external onlyOwner onlyPresale returns (bool) {
457         require(_presaleAmount > 0);
458         require(_receiver != address(0));
459         require(address(m_token) != address(0));
460         require(m_token.mint(_receiver, _presaleAmount));
461         return true;
462     }
463 
464     function finishPresale() external onlyOwner onlyPresale returns (bool) {
465         m_presaleFinished = true;
466         emit PresaleFinished();
467         return true;
468     }
469 
470     function buyToken() external payable {
471         buyTokens(msg.sender);
472     }
473 
474     function withdraw(uint256 _amount) external {
475         require(_amount != 0);
476         uint256 userBalance = m_dividendBalances[msg.sender].add(getDividendAmount(msg.sender));
477         require(userBalance >= _amount);
478 
479         takeDividends(msg.sender);
480 
481         m_dividendBalances[msg.sender] = userBalance.sub(_amount);
482         msg.sender.transfer(_amount);
483     }
484 
485     function withdrawTo(address _to, uint256 _amount) external {
486         require(_amount != 0);
487         require(_to != address(0));
488         uint256 userBalance = m_dividendBalances[msg.sender].add(getDividendAmount(msg.sender));
489         require(userBalance >= _amount);
490 
491         takeDividends(msg.sender);
492 
493         m_dividendBalances[msg.sender] = userBalance.sub(_amount);
494         _to.transfer(_amount);
495     }
496 
497     function updateDividendBalance(uint256 _totalSupply, address _address, uint256 _tokensAmount) external onlyToken {
498         m_totalTokens = m_totalTokens.add(_tokensAmount);
499         require(m_totalTokens == _totalSupply);
500 
501         takeDividends(_address);
502         m_userHistories[_address].tokens = m_userHistories[_address].tokens.add(_tokensAmount);
503     }
504 
505     function transferTokens(address _from, address _to, uint256 _amount) external onlyToken returns (bool) {
506         require(_from != address(0));
507         require(_to != address(0));
508         takeDividends(_from);
509         takeDividends(_to);
510 
511         m_userHistories[_from].tokens = m_userHistories[_from].tokens.sub(_amount);
512         m_userHistories[_to].tokens = m_userHistories[_to].tokens.add(_amount);
513         return true;
514     }
515 
516     function shareDividends() external onlyOwner payable {
517         require(msg.value > 0);
518         m_sharedDividendBalance = m_sharedDividendBalance.add(msg.value);
519         m_D_n = m_D_n.add(msg.value.mul(rounding).div(m_totalTokens));
520 
521         emit DividendsArrived(m_D_n);
522     }
523 
524     function getDividendBalance(address _address) external view returns (uint256) {
525         return m_dividendBalances[_address].add(getDividendAmount(_address));
526     }
527 
528     function getDividendAmount(address _address) public view returns (uint256) {
529         UserHistory memory history = m_userHistories[_address];
530         if (history.tokens == 0) {
531             return 0;
532         }
533 
534         uint256 dividends = m_D_n.sub(history.lastD_n).mul(history.tokens);
535 
536         dividends = dividends.div(rounding);
537 
538         return dividends;
539     }
540 
541     function buyTokens(address _receiver) public payable {
542         require(msg.value > 0);
543 
544         uint256 totalSupply = m_token.totalSupply();
545         uint256 tokens;
546         uint256 change;
547         (tokens, change) = calculateTokensFrom(msg.value, totalSupply);
548         uint256 tokenPrice = msg.value.sub(change);
549 
550         m_sharedDividendBalance = m_sharedDividendBalance.add(tokenPrice);
551 
552         m_D_n = m_D_n.add(tokenPrice.mul(rounding).div(m_totalTokens));
553         m_dividendBalances[_receiver] = m_dividendBalances[_receiver].add(change);
554 
555         require(m_token.mint(_receiver, tokens));
556         emit DividendsArrived(m_D_n);
557     }
558 
559     function calculateTokensFrom(uint256 _value, uint256 _totalSupply) public view returns (uint256, uint256) {
560         require(_value >= m_tokenPrice);
561         return calculateTokensAmountToSale(_value, _totalSupply);
562     }
563 
564     function priceFor(uint256 _tokenAmount) public view returns (uint256) {
565         uint256 price = m_tokenPrice.mul(_tokenAmount);
566         return price;
567     }
568 
569     function priceWithDiscount(uint256 _tokenAmount, uint256 _totalTokens) public view returns (uint256) {
570         uint256 s = _totalTokens.add(_tokenAmount).mul(rounding).div(_totalTokens);
571         int256 log = ln(s);
572         return m_tokenPrice.mul(_totalTokens).mul(uint256(log)).div(rounding);
573     }
574 
575     function tokensAmountFrom(uint256 _value) public view returns (uint256) {
576         uint256 tokensAmount = _value.div(m_tokenPrice);
577         return tokensAmount;
578     }
579 
580     // MARK: Private functions
581     function takeDividends(address _user) private {
582         uint256 userAmount = getDividendAmount(_user);
583         m_userHistories[_user].lastD_n = m_D_n;
584         if (userAmount == 0) {
585             return;
586         }
587         m_dividendBalances[_user] = m_dividendBalances[_user].add(userAmount);
588         m_sharedDividendBalance = m_sharedDividendBalance.sub(userAmount);
589     }
590 
591     function calculateTokensAmountToSale(uint256 _value, uint256 _totalSupply) private view returns (uint256, uint256) {
592         uint256 maxTotalSupply = m_maxTotalSupply;
593         require(_totalSupply < maxTotalSupply);
594 
595         uint256 remainingTokens = maxTotalSupply.sub(_totalSupply);
596         uint256 remainingPrice = priceFor(remainingTokens);
597 
598         if (remainingPrice < _value) {
599             return (remainingTokens, _value - remainingPrice);
600         }
601 
602         uint256 approxTokens = tokensAmountFrom(_value);
603         uint256 approxPrice;
604 
605         if (approxTokens >= m_tokenDiscountThreshold) {
606             approxPrice = priceWithDiscount(approxTokens, _totalSupply);
607         } else {
608             approxPrice = priceFor(approxTokens);
609         }
610 
611         uint256 change = _value.sub(approxPrice);
612         return (approxTokens, change);
613     }
614 }
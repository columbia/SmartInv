1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30         return a >= b ? a : b;
31     }
32 
33     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34         return a < b ? a : b;
35     }
36 
37     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a >= b ? a : b;
39     }
40 
41     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a < b ? a : b;
43     }
44 }
45 
46 
47 contract ERC20Basic {
48     uint256 public totalSupply;
49 
50     bool public transfersEnabled;
51 
52     function balanceOf(address who) public view returns (uint256);
53 
54     function transfer(address to, uint256 value) public returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract ERC20 {
61     uint256 public totalSupply;
62 
63     bool public transfersEnabled;
64 
65     function balanceOf(address _owner) public constant returns (uint256 balance);
66 
67     function transfer(address _to, uint256 _value) public returns (bool success);
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
70 
71     function approve(address _spender, uint256 _value) public returns (bool success);
72 
73     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76 
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 }
79 
80 
81 contract BasicToken is ERC20Basic {
82     using SafeMath for uint256;
83     uint8 decimals = 18;
84 
85     address public addressFundTeam     = 0xCE4B70066331aF47CBF6b4AA4Fb85B0F3E598Ae8;
86     address public addressFundAdvisors = 0x4386a80917A6367153880C9ee6EC361c660a64EC;
87     uint256 public fundTeam     = 75 * 10**5 * (10 ** uint256(decimals));
88     uint256 public fundAdvisors = 45 * 10**5 * (10 ** uint256(decimals));
89     uint256 endTimeIco   = 1552694399; // Fri, 15 Mar 2019 23:59:59 GMT
90 
91     mapping (address => uint256) balances;
92 
93     /**
94     * Protection against short address attack
95     */
96     modifier onlyPayloadSize(uint numwords) {
97         assert(msg.data.length == numwords * 32 + 4);
98         _;
99     }
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109         require(transfersEnabled);
110         if (msg.sender == addressFundTeam) {
111             require(checkVesting(_value, now) > 0);
112         }
113         if (msg.sender == addressFundAdvisors) {
114             require(now > (endTimeIco + 26 weeks));
115         }
116         // SafeMath.sub will throw if there is not enough balance.
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     function checkVesting(uint256 _value, uint256 _currentTime) public view returns(uint8 period) {
124         period = 0;
125         if ( (endTimeIco + 26 weeks) <= _currentTime && _currentTime < (endTimeIco + 52 weeks) ) {
126             period = 1;
127             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(75).div(100));
128         }
129         if ( (endTimeIco + 52 weeks) <= _currentTime && _currentTime < (endTimeIco + 78 weeks) ) {
130             period = 2;
131             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(50).div(100));
132         }
133         if ( (endTimeIco + 78 weeks) <= _currentTime && _currentTime < (endTimeIco + 104 weeks) ) {
134             period = 3;
135             require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(25).div(100));
136         }
137         if ( (endTimeIco + 104 weeks) <= _currentTime ) {
138             period = 4;
139             require(balances[addressFundTeam].sub(_value) >= 0);
140         }
141     }
142 
143     /**
144     * @dev Gets the balance of the specified address.
145     * @param _owner The address to query the the balance of.
146     * @return An uint256 representing the amount owned by the passed address.
147     */
148     function balanceOf(address _owner) public constant returns (uint256 balance) {
149         return balances[_owner];
150     }
151 }
152 
153 
154 contract StandardToken is ERC20, BasicToken {
155 
156     mapping (address => mapping (address => uint256)) internal allowed;
157 
158     /**
159      * @dev Transfer tokens from one address to another
160      * @param _from address The address which you want to send tokens from
161      * @param _to address The address which you want to transfer to
162      * @param _value uint256 the amount of tokens to be transferred
163      */
164     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
165         require(_to != address(0));
166         require(_value <= balances[_from]);
167         require(_value <= allowed[_from][msg.sender]);
168         require(transfersEnabled);
169 
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173         emit Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179      *
180      * Beware that changing an allowance with this method brings the risk that someone may use both the old
181      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      * @param _spender The address which will spend the funds.
185      * @param _value The amount of tokens to be spent.
186      */
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         allowed[msg.sender][_spender] = _value;
189         emit Approval(msg.sender, _spender, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Function to check the amount of tokens that an owner allowed to a spender.
195      * @param _owner address The address which owns the funds.
196      * @param _spender address The address which will spend the funds.
197      * @return A uint256 specifying the amount of tokens still available for the spender.
198      */
199     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
200         return allowed[_owner][_spender];
201     }
202 
203     /**
204      * approve should be called when allowed[_spender] == 0. To increment
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      */
209     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
210         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 
215     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
216         uint oldValue = allowed[msg.sender][_spender];
217         if (_subtractedValue > oldValue) {
218             allowed[msg.sender][_spender] = 0;
219         }
220         else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227 }
228 
229 
230 /**
231  * @title Ownable
232  * @dev The Ownable contract has an owner address, and provides basic authorization control
233  * functions, this simplifies the implementation of "user permissions".
234  */
235 contract Ownable {
236     address public owner;
237     address public ownerTwo;
238 
239     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(msg.sender == owner || msg.sender == ownerTwo);
246         _;
247     }
248 
249 
250     /**
251      * @dev Allows the current owner to transfer control of the contract to a newOwner.
252      * @param _newOwner The address to transfer ownership to.
253      */
254     function changeOwner(address _newOwner) onlyOwner internal {
255         require(_newOwner != address(0));
256         emit OwnerChanged(owner, _newOwner);
257         owner = _newOwner;
258     }
259 
260 }
261 
262 
263 /**
264  * @title Mintable token
265  * @dev Simple ERC20 Token example, with mintable token creation
266  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
267  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
268  */
269 
270 contract MintableToken is StandardToken, Ownable {
271     string public constant name = "Greencoin";
272     string public constant symbol = "GNC";
273     uint8 public constant decimals = 18;
274     mapping(uint8 => uint8) public approveOwner;
275 
276     event Mint(address indexed to, uint256 amount);
277     event MintFinished();
278 
279     bool public mintingFinished;
280 
281     modifier canMint() {
282         require(!mintingFinished);
283         _;
284     }
285 
286     /**
287      * @dev Function to mint tokens
288      * @param _to The address that will receive the minted tokens.
289      * @param _amount The amount of tokens to mint.
290      * @return A boolean that indicates if the operation was successful.
291      */
292     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
293         balances[_to] = balances[_to].add(_amount);
294         balances[_owner] = balances[_owner].sub(_amount);
295         emit Mint(_to, _amount);
296         emit Transfer(_owner, _to, _amount);
297         return true;
298     }
299 
300     /**
301      * Peterson's Law Protection
302      * Claim tokens
303      */
304     function claimTokens(address _token) public onlyOwner {
305         if (checkApprove(0) == false) {
306             revert(); // for test's
307         }
308         if (_token == 0x0) {
309             owner.transfer(address(this).balance);
310             return;
311         }
312         MintableToken token = MintableToken(_token);
313         uint256 balance = token.balanceOf(this);
314         token.transfer(owner, balance);
315         emit Transfer(_token, owner, balance);
316     }
317 
318     function checkApprove(uint8 _numberFunction) public onlyOwner returns (bool) {
319         uint8 countApprove = approveOwner[_numberFunction];
320         if (msg.sender == owner && (countApprove == 0 || countApprove == 2) ) {
321             approveOwner[_numberFunction] += 1;
322         }
323         if (msg.sender == ownerTwo && (countApprove == 0 || countApprove == 1) ) {
324             approveOwner[_numberFunction] += 2;
325         }
326         if (approveOwner[_numberFunction] == 3) {
327             approveOwner[_numberFunction] == 0;
328             return true;
329         } else {
330             return false;
331         }
332     }
333 
334 }
335 
336 
337 /**
338  * @title Crowdsale
339  * @dev Crowdsale is a base contract for managing a token crowdsale.
340  * Crowdsales have a start and end timestamps, where investors can make
341  * token purchases. Funds collected are forwarded to a wallet
342  * as they arrive.
343  */
344 contract Crowdsale is Ownable {
345     using SafeMath for uint256;
346     // address where funds are collected
347     address public wallet;
348 
349     // amount of raised money in wei
350     uint256 public weiRaised;
351     uint256 public tokenAllocated;
352 
353     constructor(address _wallet) public {
354         require(_wallet != address(0));
355         wallet = _wallet;
356     }
357 }
358 
359 
360 contract GNCCrowdsale is Ownable, Crowdsale, MintableToken {
361     using SafeMath for uint256;
362 
363     /**
364     * Price: 1 ETH = 500 token
365     *
366     * 1 Stage  1 ETH = 575  token -- discount 15%
367     * 2 Stage  1 ETH = 550  token -- discount 10%
368     * 3 Stage  1 ETH = 525  token -- discount 5%
369     * 4 Stage  1 ETH = 500  token -- discount 0%
370     *
371     */
372     uint256[] public rates  = [575, 550, 525, 500];
373 
374     uint256 public weiMin = 0.1 ether;
375 
376     mapping (address => uint256) public deposited;
377     mapping (address => bool) public whitelist;
378     mapping (address => bool) internal isRefferer;
379 
380 
381     uint256 public constant INITIAL_SUPPLY = 5 * 10**7 * (10 ** uint256(decimals));
382     uint256 public    fundForSale = 3 * 10**7 * (10 ** uint256(decimals));
383 
384     address public addressFundReserv   = 0x0B55283caD0cc5372E4D33aD6D3260D8050EccD4;
385     address public addressFundBounty   = 0xfe17aa1cf299038780b8B16F0B89DB8cEcF28a89;
386 
387     uint256 public fundReserv   = 75 * 10**5 * (10 ** uint256(decimals));
388     uint256 public fundBounty   =  5 * 10**5 * (10 ** uint256(decimals));
389 
390     uint256 limitPreIco = 6 * 10**6 * (10 ** uint256(decimals));
391 
392     uint256 startTimePreIco = 1542326400; // Fri, 16 Nov 2018 00:00:00 GMT
393     uint256 endTimePreIco =   1544918399; // Sat, 15 Dec 2018 23:59:59 GMT
394 
395     uint256 startTimeIcoStage1 = 1547510400; // Tue, 15 Jan 2019 00:00:00 GMT
396     uint256 endTimeIcoStage1   = 1548806399; // Tue, 29 Jan 2019 23:59:59 GMT
397 
398     uint256 startTimeIcoStage2 = 1548806400; // Wed, 30 Jan 2019 00:00:00 GMT
399     uint256 endTimeIcoStage2   = 1550102399; // Wed, 13 Feb 2019 23:59:59 GMT
400 
401     uint256 startTimeIcoStage3 = 1550102400; // Thu, 14 Feb 2019 00:00:00 GMT
402     uint256 endTimeIcoStage3   = 1552694399; // Fri, 15 Mar 2019 23:59:59 GMT
403 
404     uint256 public countInvestor;
405 
406     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
407     event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);
408     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
409     event CurrentPeriod(uint period);
410     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
411     event ChangeRate(address indexed owner, uint256 newValue, uint256 oldValue);
412 
413     constructor(address _owner, address _wallet) public
414     Crowdsale(_wallet)
415     {
416         require(_owner != address(0));
417         owner = _owner;
418         ownerTwo = addressFundReserv;
419         //owner = msg.sender; // for test's
420         transfersEnabled = true;
421         mintingFinished = false;
422         totalSupply = INITIAL_SUPPLY;
423         bool resultMintForOwner = mintForFund(owner);
424         require(resultMintForOwner);
425     }
426 
427     // fallback function can be used to buy tokens
428     function() payable public {
429         buyTokens(msg.sender);
430     }
431 
432     function buyTokens(address _investor) public payable returns (uint256){
433         require(_investor != address(0));
434         uint256 weiAmount = msg.value;
435         uint256 tokens = validPurchaseTokens(weiAmount);
436         if (tokens == 0) {revert();}
437         weiRaised = weiRaised.add(weiAmount);
438         tokenAllocated = tokenAllocated.add(tokens);
439         mint(_investor, tokens, owner);
440 
441         emit TokenPurchase(_investor, weiAmount, tokens);
442         if (deposited[_investor] == 0) {
443             countInvestor = countInvestor.add(1);
444         }
445         deposit(_investor);
446         wallet.transfer(weiAmount);
447         return tokens;
448     }
449 
450     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
451         uint256 currentDate = now;
452         //currentDate = 1543658400; // (01 Dec 2018) // for test's
453         uint currentPeriod = 0;
454         currentPeriod = getPeriod(currentDate);
455         uint256 amountOfTokens = 0;
456         if(currentPeriod > 0){
457             if(currentPeriod == 1){
458                 amountOfTokens += _weiAmount.mul(rates[0]);
459                 if (tokenAllocated.add(amountOfTokens) > limitPreIco) {
460                     currentPeriod = currentPeriod.add(1);
461                 }
462             }
463             if(currentPeriod >= 2){
464                 amountOfTokens += _weiAmount.mul(rates[currentPeriod - 1]);
465             }
466             if(whitelist[msg.sender]){
467                 amountOfTokens = amountOfTokens.mul(105).div(100);
468             }
469         }
470         emit CurrentPeriod(currentPeriod);
471         return amountOfTokens;
472     }
473 
474     function getPeriod(uint256 _currentDate) public view returns (uint) {
475         if(_currentDate < startTimePreIco){
476             return 0;
477         }
478         if( startTimePreIco <= _currentDate && _currentDate <= endTimePreIco){
479             return 1;
480         }
481         if( startTimeIcoStage1 <= _currentDate && _currentDate <= endTimeIcoStage1){
482             return 2;
483         }
484         if( startTimeIcoStage2 <= _currentDate && _currentDate <= endTimeIcoStage2){
485             return 3;
486         }
487         if( startTimeIcoStage3 <= _currentDate && _currentDate <= endTimeIcoStage3){
488             return 4;
489         }
490         return 0;
491     }
492 
493     function deposit(address investor) internal {
494         deposited[investor] = deposited[investor].add(msg.value);
495     }
496 
497     function mintForFund(address _walletOwner) internal returns (bool result) {
498         result = false;
499         require(_walletOwner != address(0));
500         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
501 
502         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
503         balances[addressFundReserv] = balances[addressFundReserv].add(fundReserv);
504         balances[addressFundAdvisors] = balances[addressFundAdvisors].add(fundAdvisors);
505         balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);
506 
507         result = true;
508     }
509 
510     function getDeposited(address _investor) external view returns (uint256){
511         return deposited[_investor];
512     }
513 
514     function setWallet(address _newWallet) external onlyOwner {
515         if (checkApprove(1) == false) {
516             revert();
517         }
518         require(_newWallet != address(0));
519         address _oldWallet = wallet;
520         wallet = _newWallet;
521         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
522     }
523 
524     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
525         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
526         if (_weiAmount < weiMin) {
527             emit MinWeiLimitReached(msg.sender, _weiAmount);
528             return 0;
529         }
530         if (tokenAllocated.add(addTokens) > fundForSale) {
531             emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);
532             return 0;
533         }
534         return addTokens;
535     }
536 
537     function getRefferalProfit(address _refferer) external {
538         uint256 balanceRefferal = balances[msg.sender];
539         require(_refferer != address(0));
540         require(balanceRefferal > 0);
541         require(balances[_refferer] > 0);
542 
543         if (isRefferer[msg.sender] == false) {
544             isRefferer[msg.sender] = true;
545             balances[msg.sender] = balanceRefferal.mul(105).div(100);
546         }
547     }
548 
549     function setWeiMin(uint256 _value) external onlyOwner {
550         if (checkApprove(2) == false) {
551             revert();
552         }
553         require(_value > 0);
554         weiMin = _value;
555     }
556 
557     /**
558    * @dev Adds single address to whitelist.
559    * @param _beneficiary Address to be added to the whitelist
560    */
561     function addToWhitelist(address _beneficiary) external onlyOwner {
562         require(_beneficiary != address(0));
563         whitelist[_beneficiary] = true;
564     }
565 
566     /**
567      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
568      * @param _beneficiaries Addresses to be added to the whitelist
569      */
570     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
571         for (uint256 i = 0; i < _beneficiaries.length; i++) {
572             whitelist[_beneficiaries[i]] = true;
573         }
574     }
575 
576     /**
577      * @dev Removes single address from whitelist.
578      * @param _beneficiary Address to be removed to the whitelist
579      */
580     function removeFromWhitelist(address _beneficiary) external onlyOwner {
581         require(_beneficiary != address(0));
582         whitelist[_beneficiary] = false;
583     }
584 }
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
83 
84     mapping (address => uint256) balances;
85 
86     /**
87     * Protection against short address attack
88     */
89     modifier onlyPayloadSize(uint numwords) {
90         assert(msg.data.length == numwords * 32 + 4);
91         _;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102         require(transfersEnabled);
103 
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124     mapping (address => mapping (address => uint256)) internal allowed;
125 
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param _from address The address which you want to send tokens from
129      * @param _to address The address which you want to transfer to
130      * @param _value uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136         require(transfersEnabled);
137 
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         emit Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      *
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param _spender The address which will spend the funds.
153      * @param _value The amount of tokens to be spent.
154      */
155     function approve(address _spender, uint256 _value) public returns (bool) {
156         allowed[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Function to check the amount of tokens that an owner allowed to a spender.
163      * @param _owner address The address which owns the funds.
164      * @param _spender address The address which will spend the funds.
165      * @return A uint256 specifying the amount of tokens still available for the spender.
166      */
167     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171     /**
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      */
177     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         }
188         else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 
195 }
196 
197 
198 /**
199  * @title Ownable
200  * @dev The Ownable contract has an owner address, and provides basic authorization control
201  * functions, this simplifies the implementation of "user permissions".
202  */
203 contract Ownable {
204     address public owner;
205 
206     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Throws if called by any account other than the owner.
210      */
211     modifier onlyOwner() {
212         require(msg.sender == owner);
213         _;
214     }
215 
216 
217     /**
218      * @dev Allows the current owner to transfer control of the contract to a newOwner.
219      * @param _newOwner The address to transfer ownership to.
220      */
221     function changeOwner(address _newOwner) onlyOwner internal {
222         require(_newOwner != address(0));
223         emit OwnerChanged(owner, _newOwner);
224         owner = _newOwner;
225     }
226 
227 }
228 
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 
237 contract MintableToken is StandardToken, Ownable {
238     string public constant name = "WebSpaceX";
239     string public constant symbol = "WSPX";
240     uint8 public constant decimals = 18;
241     mapping(uint8 => uint8) public approveOwner;
242 
243     event Mint(address indexed to, uint256 amount);
244     event MintFinished();
245 
246     bool public mintingFinished;
247 
248     modifier canMint() {
249         require(!mintingFinished);
250         _;
251     }
252 
253     /**
254      * @dev Function to mint tokens
255      * @param _to The address that will receive the minted tokens.
256      * @param _amount The amount of tokens to mint.
257      * @return A boolean that indicates if the operation was successful.
258      */
259     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
260         balances[_to] = balances[_to].add(_amount);
261         balances[_owner] = balances[_owner].sub(_amount);
262         emit Mint(_to, _amount);
263         emit Transfer(_owner, _to, _amount);
264         return true;
265     }
266 
267     /**
268      * @dev Function to stop minting new tokens.
269      * @return True if the operation was successful.
270      */
271     function finishMinting() onlyOwner canMint internal returns (bool) {
272         mintingFinished = true;
273         emit MintFinished();
274         return true;
275     }
276 
277     /**
278      * Peterson's Law Protection
279      * Claim tokens
280      */
281     function claimTokens(address _token) public onlyOwner {
282         if (_token == 0x0) {
283             owner.transfer(address(this).balance);
284             return;
285         }
286         MintableToken token = MintableToken(_token);
287         uint256 balance = token.balanceOf(this);
288         token.transfer(owner, balance);
289         emit Transfer(_token, owner, balance);
290     }
291 }
292 
293 
294 /**
295  * @title Crowdsale
296  * @dev Crowdsale is a base contract for managing a token crowdsale.
297  * Crowdsales have a start and end timestamps, where investors can make
298  * token purchases. Funds collected are forwarded to a wallet
299  * as they arrive.
300  */
301 contract Crowdsale is Ownable {
302     using SafeMath for uint256;
303     // address where funds are collected
304     address public wallet;
305     uint256 public hardWeiCap = 15830 ether;
306 
307     // amount of raised money in wei
308     uint256 public weiRaised;
309     uint256 public tokenAllocated;
310 
311     constructor(address _wallet) public {
312         require(_wallet != address(0));
313         wallet = _wallet;
314     }
315 }
316 
317 
318 contract WSPXCrowdsale is Ownable, Crowdsale, MintableToken {
319     using SafeMath for uint256;
320 
321     uint256 public rate  = 312500;
322 
323     mapping (address => uint256) public deposited;
324     mapping (address => bool) internal isRefferer;
325 
326     uint256 public weiMinSale = 0.1 ether;
327 
328     uint256 public constant INITIAL_SUPPLY = 9 * 10**9 * (10 ** uint256(decimals));
329 
330     uint256 public fundForSale   = 6 * 10**9 * (10 ** uint256(decimals));
331     uint256 public    fundTeam   = 1 * 10**9 * (10 ** uint256(decimals));
332     uint256 public    fundBounty = 2 * 10**9 * (10 ** uint256(decimals));
333 
334     address public addressFundTeam   = 0xA2434A8F6457fe7CF29AEa841cf3D0B0FE3217c8;
335     address public addressFundBounty = 0x8828c48DEc2764868aD3bBf7fE9e8aBE773E3064;
336 
337     // 1 Jan - 15 Jan
338     uint256 startTimeIcoStage1 = 1546300800; // Tue, 01 Jan 2019 00:00:00 GMT
339     uint256 endTimeIcoStage1 =   1547596799; // Tue, 15 Jan 2019 23:59:59 GMT
340 
341     // 16 Jan - 31 Jan
342     uint256 startTimeIcoStage2 = 1547596800; // Wed, 16 Jan 2019 00:00:00 GMT
343     uint256 endTimeIcoStage2   = 1548979199; // Thu, 31 Jan 2019 23:59:59 GMT
344 
345     // 1 Feb - 15 Feb
346     uint256 startTimeIcoStage3 = 1548979200; // Fri, 01 Feb 2019 00:00:00 GMT
347     uint256 endTimeIcoStage3   = 1554076799; // Fri, 15 Feb 2019 23:59:59 GMT
348 
349     uint256 limitStage1 =  2 * 10**9 * (10 ** uint256(decimals));
350     uint256 limitStage2 =  4 * 10**9 * (10 ** uint256(decimals));
351     uint256 limitStage3 =  6 * 10**9 * (10 ** uint256(decimals));
352 
353     uint256 public countInvestor;
354 
355     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
356     event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);
357     event CurrentPeriod(uint period);
358     event ChangeTime(address indexed owner, uint256 newValue, uint256 oldValue);
359     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
360     event ChangeRate(address indexed owner, uint256 newValue, uint256 oldValue);
361     event Burn(address indexed burner, uint256 value);
362     event HardCapReached();
363 
364 
365     constructor(address _owner, address _wallet) public
366     Crowdsale(_wallet)
367     {
368         require(_owner != address(0));
369         owner = _owner;
370         //owner = msg.sender; // for test's
371         transfersEnabled = true;
372         mintingFinished = false;
373         totalSupply = INITIAL_SUPPLY;
374         bool resultMintForOwner = mintForFund(owner);
375         require(resultMintForOwner);
376     }
377 
378     // fallback function can be used to buy tokens
379     function() payable public {
380         buyTokens(msg.sender);
381     }
382 
383     function buyTokens(address _investor) public payable returns (uint256){
384         require(_investor != address(0));
385         uint256 weiAmount = msg.value;
386         uint256 tokens = validPurchaseTokens(weiAmount);
387         if (tokens == 0) {revert();}
388         weiRaised = weiRaised.add(weiAmount);
389         tokenAllocated = tokenAllocated.add(tokens);
390         mint(_investor, tokens, owner);
391 
392         emit TokenPurchase(_investor, weiAmount, tokens);
393         if (deposited[_investor] == 0) {
394             countInvestor = countInvestor.add(1);
395         }
396         deposit(_investor);
397         wallet.transfer(weiAmount);
398         return tokens;
399     }
400 
401     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
402         uint256 currentDate = now;
403         //currentDate = 1547114400; // Thu, 10 Jan 2019 10:00:00 GMT // for test's
404         uint currentPeriod = 0;
405         currentPeriod = getPeriod(currentDate);
406         uint256 amountOfTokens = 0;
407         if(currentPeriod > 0){
408             if(currentPeriod == 1){
409                 amountOfTokens = _weiAmount.mul(rate).mul(130).div(100);
410                 if (tokenAllocated.add(amountOfTokens) > limitStage1) {
411                     currentPeriod = currentPeriod.add(1);
412                     amountOfTokens = 0;
413                 }
414             }
415             if(currentPeriod == 2){
416                 amountOfTokens = _weiAmount.mul(rate).mul(120).div(100);
417                 if (tokenAllocated.add(amountOfTokens) > limitStage2) {
418                     currentPeriod = currentPeriod.add(1);
419                     amountOfTokens = 0;
420                 }
421             }
422             if(currentPeriod == 3){
423                 amountOfTokens = _weiAmount.mul(rate).mul(110).div(100);
424                 if (tokenAllocated.add(amountOfTokens) > limitStage3) {
425                     currentPeriod = 0;
426                     amountOfTokens = 0;
427                 }
428             }
429         }
430         emit CurrentPeriod(currentPeriod);
431         return amountOfTokens;
432     }
433 
434     function getPeriod(uint256 _currentDate) public view returns (uint) {
435         if(_currentDate < startTimeIcoStage1){
436             return 0;
437         }
438         if( startTimeIcoStage1 <= _currentDate && _currentDate <= endTimeIcoStage1){
439             return 1;
440         }
441         if( startTimeIcoStage2 <= _currentDate && _currentDate <= endTimeIcoStage2){
442             return 2;
443         }
444         if( startTimeIcoStage3 <= _currentDate && _currentDate <= endTimeIcoStage3){
445             return 3;
446         }
447         return 0;
448     }
449 
450     function deposit(address investor) internal {
451         deposited[investor] = deposited[investor].add(msg.value);
452     }
453 
454     function mintForFund(address _walletOwner) internal returns (bool result) {
455         result = false;
456         require(_walletOwner != address(0));
457         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
458         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
459         balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);
460         result = true;
461     }
462 
463     function getDeposited(address _investor) external view returns (uint256){
464         return deposited[_investor];
465     }
466 
467     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
468         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
469         if (tokenAllocated.add(addTokens) > balances[owner]) {
470             emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);
471             return 0;
472         }
473         if (weiRaised.add(_weiAmount) > hardWeiCap) {
474             emit HardCapReached();
475             return 0;
476         }
477         if (_weiAmount < weiMinSale) {
478             return 0;
479         }
480 
481     return addTokens;
482     }
483 
484     /**
485      * @dev owner burn Token.
486      * @param _value amount of burnt tokens
487      */
488     function ownerBurnToken(uint _value) public onlyOwner {
489         require(_value > 0);
490         require(_value <= balances[owner]);
491         require(_value <= totalSupply);
492 
493         balances[owner] = balances[owner].sub(_value);
494         totalSupply = totalSupply.sub(_value);
495         emit Burn(msg.sender, _value);
496     }
497 
498     /**
499      * @dev owner change time for startTimeIcoStage1
500      * @param _value new time value
501      */
502     function setStartTimeIcoStage1(uint256 _value) external onlyOwner {
503         require(_value > 0);
504         uint256 _oldValue = startTimeIcoStage1;
505         startTimeIcoStage1 = _value;
506         emit ChangeTime(msg.sender, _value, _oldValue);
507     }
508 
509     /**
510      * @dev owner change time for endTimeIcoStage1
511      * @param _value new time value
512      */
513     function setEndTimeIcoStage1(uint256 _value) external onlyOwner {
514         require(_value > 0);
515         uint256 _oldValue = endTimeIcoStage1;
516         endTimeIcoStage1 = _value;
517         emit ChangeTime(msg.sender, _value, _oldValue);
518     }
519 
520     /**
521      * @dev owner change time for startTimeIcoStage2
522      * @param _value new time value
523      */
524     function setStartTimeIcoStage2(uint256 _value) external onlyOwner {
525         require(_value > 0);
526         uint256 _oldValue = startTimeIcoStage2;
527         startTimeIcoStage2 = _value;
528         emit ChangeTime(msg.sender, _value, _oldValue);
529     }
530 
531 
532     /**
533      * @dev owner change time for endTimeIcoStage2
534      * @param _value new time value
535      */
536     function setEndTimeIcoStage2(uint256 _value) external onlyOwner {
537         require(_value > 0);
538         uint256 _oldValue = endTimeIcoStage2;
539         endTimeIcoStage2 = _value;
540         emit ChangeTime(msg.sender, _value, _oldValue);
541     }
542 
543     /**
544  * @dev owner change time for startTimeIcoStage3
545  * @param _value new time value
546  */
547     function setStartTimeIcoStage3(uint256 _value) external onlyOwner {
548         require(_value > 0);
549         uint256 _oldValue = startTimeIcoStage3;
550         startTimeIcoStage3 = _value;
551         emit ChangeTime(msg.sender, _value, _oldValue);
552     }
553 
554 
555     /**
556      * @dev owner change time for endTimeIcoStage3
557      * @param _value new time value
558      */
559     function setEndTimeIcoStage3(uint256 _value) external onlyOwner {
560         require(_value > 0);
561         uint256 _oldValue = endTimeIcoStage3;
562         endTimeIcoStage3 = _value;
563         emit ChangeTime(msg.sender, _value, _oldValue);
564     }
565 
566     /**
567      * @dev owner change address of wallet for collecting ETH
568      * @param _newWallet new address of wallet
569      */
570     function setWallet(address _newWallet) external onlyOwner {
571         require(_newWallet != address(0));
572         address _oldWallet = wallet;
573         wallet = _newWallet;
574         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
575     }
576 
577     /**
578      * @dev owner change price of tokens
579      * @param _newRate new price
580      */
581     function setRate(uint256 _newRate) external onlyOwner {
582         require(_newRate > 0);
583         uint256 _oldRate = rate;
584         rate = _newRate;
585         emit ChangeRate(msg.sender, _newRate, _oldRate);
586     }
587 }
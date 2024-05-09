1 pragma solidity ^0.4.24;
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
28 }
29 
30 
31 contract ERC20Basic {
32     uint256 public totalSupply;
33 
34     bool public transfersEnabled;
35 
36     function balanceOf(address who) public view returns (uint256);
37 
38     function transfer(address to, uint256 value) public returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 
44 contract ERC20 {
45     uint256 public totalSupply;
46 
47     bool public transfersEnabled;
48 
49     function balanceOf(address _owner) public constant returns (uint256 balance);
50 
51     function transfer(address _to, uint256 _value) public returns (bool success);
52 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
54 
55     function approve(address _spender, uint256 _value) public returns (bool success);
56 
57     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping (address => uint256) balances;
69     mapping (address => bool) public whitelistPayee;
70 
71 
72     /**
73     * Protection against short address attack
74     */
75     modifier onlyPayloadSize(uint numwords) {
76         assert(msg.data.length == numwords * 32 + 4);
77         _;
78     }
79 
80     function checkTransfer(address _to) public view {
81         bool permit = false;
82         if (!transfersEnabled) {
83             if (whitelistPayee[_to]) {
84                 permit = true;
85             }
86         } else {
87             permit = true;
88         }
89         require(permit);
90     }
91 
92     /**
93     * @dev transfer token for a specified address
94     * @param _to The address to transfer to.
95     * @param _value The amount to be transferred.
96     */
97     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
98         checkTransfer(_to);
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         // SafeMath.sub will throw if there is not enough balance.
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) public constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117 }
118 
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122     mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125     /**
126      * @dev Transfer tokens from one address to another
127      * @param _from address The address which you want to send tokens from
128      * @param _to address The address which you want to transfer to
129      * @param _value uint256 the amount of tokens to be transferred
130      */
131     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
132         checkTransfer(_to);
133 
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
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
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(msg.sender == owner);
211         _;
212     }
213 }
214 
215 
216 /**
217  * @title Mintable token
218  * @dev Simple ERC20 Token example, with mintable token creation
219  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
220  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
221  */
222 
223 contract MintableToken is StandardToken, Ownable {
224     string public constant name = "PHOENIX INVESTMENT FUND";
225     string public constant symbol = "PHI";
226     uint8 public constant decimals = 18;
227 
228     event Mint(address indexed to, uint256 amount);
229 
230     bool public mintingFinished;
231 
232     modifier canMint() {
233         require(!mintingFinished);
234         _;
235     }
236 
237     /**
238      * @dev Function to mint tokens
239      * @param _to The address that will receive the minted tokens.
240      * @param _amount The amount of tokens to mint.
241      * @return A boolean that indicates if the operation was successful.
242      */
243     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
244         require(_to != address(0));
245         require(_owner != address(0));
246         require(_amount <= balances[_owner]);
247 
248         balances[_to] = balances[_to].add(_amount);
249         balances[_owner] = balances[_owner].sub(_amount);
250         emit Mint(_to, _amount);
251         emit Transfer(_owner, _to, _amount);
252         return true;
253     }
254 
255     /**
256      * Peterson's Law Protection
257      * Claim tokens
258      */
259     function claimTokens(address _token) public onlyOwner {
260         if (_token == 0x0) {
261             owner.transfer(address(this).balance);
262             return;
263         }
264         MintableToken token = MintableToken(_token);
265         uint256 balance = token.balanceOf(this);
266         token.transfer(owner, balance);
267         emit Transfer(_token, owner, balance);
268     }
269 }
270 
271 
272 /**
273  * @title Crowdsale
274  * @dev Crowdsale is a base contract for managing a token crowdsale.
275  * Crowdsales have a start and end timestamps, where investors can make
276  * token purchases. Funds collected are forwarded to a wallet
277  * as they arrive.
278  */
279 contract Crowdsale is Ownable {
280     // address where funds are collected
281     address public wallet;
282 
283     // amount of raised money in wei
284     uint256 public weiRaised;
285     uint256 public tokenAllocated;
286 
287     constructor(address _wallet) public {
288         require(_wallet != address(0));
289         wallet = _wallet;
290     }
291 }
292 
293 
294 contract PHICrowdsale is Ownable, Crowdsale, MintableToken {
295     using SafeMath for uint256;
296 
297     uint256 public ratePreIco  = 600;
298     uint256 public rateIco  = 400;
299 
300     uint256 public weiMin = 0.03 ether;
301 
302     mapping (address => uint256) public deposited;
303 
304     uint256 public constant INITIAL_SUPPLY = 63 * 10**6 * (10 ** uint256(decimals));
305     uint256 public    fundForSale = 60250 * 10**3 * (10 ** uint256(decimals));
306 
307     uint256 fundTeam =          150 * 10**3 * (10 ** uint256(decimals));
308     uint256 fundAirdropPreIco = 250 * 10**3 * (10 ** uint256(decimals));
309     uint256 fundAirdropIco =    150 * 10**3 * (10 ** uint256(decimals));
310     uint256 fundBounty     =    100 * 10**3 * (10 ** uint256(decimals));
311     uint256 fundAdvisor   =    210 * 10**3 * (10 ** uint256(decimals));
312     uint256 fundReferal    =    1890 * 10**3 * (10 ** uint256(decimals));
313 
314     uint256 limitPreIco = 12 * 10**5 * (10 ** uint256(decimals));
315 
316     address addressFundTeam = 0x26cfc82A77ECc5a493D72757936A78A089FA592a;
317     address addressFundAirdropPreIco = 0x87953BAE7A92218FAcE2DDdb30AB2193263394Ef;
318     address addressFundAirdropIco = 0xaA8C9cA32cC8A6A7FF5eCB705787C22d9400F377;
319 
320     address addressFundBounty =  0x253fBeb28dA7E85c720F66bbdCFC4D9418196EE5;
321     address addressFundAdvisor = 0x61eAEe13A2a3805b57B46571EE97B6faf95fC34d;
322     address addressFundReferal = 0x4BfB1bA71952DAC3886DCfECDdE2a4Fea2A06bDb;
323 
324     uint256 public startTimePreIco = 1538406000; // Mon, 01 Oct 2018 15:00:00 GMT
325     uint256 public endTimePreIco =   1539129600; // Wed, 10 Oct 2018 00:00:00 GMT
326     uint256 public startTimeIco =    1541300400; // Sun, 04 Nov 2018 03:00:00 GMT
327     uint256 public endTimeIco =      1542931200; // Fri, 23 Nov 2018 00:00:00 GMT
328 
329     uint256 percentReferal = 5;
330 
331     uint256 public countInvestor;
332 
333     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
334     event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);
335     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
336     event Burn(address indexed burner, uint256 value);
337     event CurrentPeriod(uint period);
338     event ChangeTime(address indexed owner, uint256 newValue, uint256 oldValue);
339     event ChangeAddressFund(address indexed owner, address indexed newAddress, address indexed oldAddress);
340 
341     constructor(address _owner, address _wallet) public
342     Crowdsale(_wallet)
343     {
344         require(_owner != address(0));
345         owner = _owner;
346         //owner = msg.sender; // $$$ for test's
347         transfersEnabled = false;
348         mintingFinished = false;
349         totalSupply = INITIAL_SUPPLY;
350         bool resultMintForOwner = mintForFund(owner);
351         require(resultMintForOwner);
352     }
353 
354     // fallback function can be used to buy tokens
355     function() payable public {
356         buyTokens(msg.sender);
357     }
358 
359     function buyTokens(address _investor) public payable returns (uint256){
360         require(_investor != address(0));
361         uint256 weiAmount = msg.value;
362         uint256 tokens = validPurchaseTokens(weiAmount);
363         if (tokens == 0) {revert();}
364         weiRaised = weiRaised.add(weiAmount);
365         tokenAllocated = tokenAllocated.add(tokens);
366         mint(_investor, tokens, owner);
367         makeReferalBonus(tokens);
368 
369         emit TokenPurchase(_investor, weiAmount, tokens);
370         if (deposited[_investor] == 0) {
371             countInvestor = countInvestor.add(1);
372         }
373         deposit(_investor);
374         wallet.transfer(weiAmount);
375         return tokens;
376     }
377 
378     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
379         uint256 currentDate = now;
380         //currentDate = 1538438400; // (02 Oct 2018) // $$$ for test's
381         //currentDate = 1540051200; // (20 Oct 2018) // $$$ for test's
382         uint currentPeriod = 0;
383         currentPeriod = getPeriod(currentDate);
384         uint256 amountOfTokens = 0;
385         if(currentPeriod > 0){
386             if(currentPeriod == 1){
387                 amountOfTokens = _weiAmount.mul(ratePreIco);
388                 if (tokenAllocated.add(amountOfTokens) > limitPreIco) {
389                     currentPeriod = currentPeriod.add(1);
390                 }
391             }
392             if(currentPeriod == 2){
393                 amountOfTokens = _weiAmount.mul(rateIco);
394             }
395         }
396         emit CurrentPeriod(currentPeriod);
397         return amountOfTokens;
398     }
399 
400     function getPeriod(uint256 _currentDate) public view returns (uint) {
401         if(_currentDate < startTimePreIco){
402             return 0;
403         }
404         if( startTimePreIco <= _currentDate && _currentDate <= endTimePreIco){
405             return 1;
406         }
407         if( endTimePreIco < _currentDate && _currentDate < startTimeIco){
408             return 0;
409         }
410         if( startTimeIco <= _currentDate && _currentDate <= endTimeIco){
411             return 2;
412         }
413         return 0;
414     }
415 
416     function deposit(address investor) internal {
417         deposited[investor] = deposited[investor].add(msg.value);
418     }
419 
420     function makeReferalBonus(uint256 _amountToken) internal returns(uint256 _refererTokens) {
421         _refererTokens = 0;
422         if(msg.data.length == 20) {
423             address referer = bytesToAddress(bytes(msg.data));
424             require(referer != msg.sender);
425             _refererTokens = _amountToken.mul(percentReferal).div(100);
426             if(balanceOf(addressFundReferal) >= _refererTokens.mul(2)) {
427                 mint(referer, _refererTokens, addressFundReferal);
428                 mint(msg.sender, _refererTokens, addressFundReferal);
429             }
430         }
431     }
432 
433     function bytesToAddress(bytes source) internal pure returns(address) {
434         uint result;
435         uint mul = 1;
436         for(uint i = 20; i > 0; i--) {
437             result += uint8(source[i-1])*mul;
438             mul = mul*256;
439         }
440         return address(result);
441     }
442 
443     function mintForFund(address _walletOwner) internal returns (bool result) {
444         result = false;
445         require(_walletOwner != address(0));
446         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
447 
448         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
449         balances[addressFundAirdropPreIco] = balances[addressFundAirdropPreIco].add(fundAirdropPreIco);
450         balances[addressFundAirdropIco] = balances[addressFundAirdropIco].add(fundAirdropIco);
451         balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);
452         balances[addressFundAdvisor] = balances[addressFundAdvisor].add(fundAdvisor);
453         balances[addressFundReferal] = balances[addressFundReferal].add(fundReferal);
454 
455         result = true;
456     }
457 
458     function getDeposited(address _investor) public view returns (uint256){
459         return deposited[_investor];
460     }
461 
462     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
463         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
464         if (_weiAmount < weiMin) {
465             emit MinWeiLimitReached(msg.sender, _weiAmount);
466             return 0;
467         }
468         if (tokenAllocated.add(addTokens) > fundForSale) {
469             emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);
470             return 0;
471         }
472         return addTokens;
473     }
474 
475     /**
476      * @dev owner burn Token.
477      * @param _value amount of burnt tokens
478      */
479     function ownerBurnToken(uint _value) public onlyOwner {
480         require(_value > 0);
481         require(_value <= balances[owner]);
482         require(_value <= totalSupply);
483         require(_value <= fundForSale);
484 
485         balances[owner] = balances[owner].sub(_value);
486         totalSupply = totalSupply.sub(_value);
487         fundForSale = fundForSale.sub(_value);
488         emit Burn(msg.sender, _value);
489     }
490 
491     /**
492      * @dev owner change time for startTimePreIco
493      * @param _value new time value
494      */
495     function setStartTimePreIco(uint256 _value) public onlyOwner {
496         require(_value > 0);
497         uint256 _oldValue = startTimePreIco;
498         startTimePreIco = _value;
499         emit ChangeTime(msg.sender, _value, _oldValue);
500     }
501 
502 
503     /**
504      * @dev owner change time for endTimePreIco
505      * @param _value new time value
506      */
507     function setEndTimePreIco(uint256 _value) public onlyOwner {
508         require(_value > 0);
509         uint256 _oldValue = endTimePreIco;
510         endTimePreIco = _value;
511         emit ChangeTime(msg.sender, _value, _oldValue);
512     }
513 
514     /**
515      * @dev owner change time for startTimeIco
516      * @param _value new time value
517      */
518     function setStartTimeIco(uint256 _value) public onlyOwner {
519         require(_value > 0);
520         uint256 _oldValue = startTimeIco;
521         startTimeIco = _value;
522         emit ChangeTime(msg.sender, _value, _oldValue);
523     }
524 
525     /**
526      * @dev owner change time for endTimeIco
527      * @param _value new time value
528      */
529     function setEndTimeIco(uint256 _value) public onlyOwner {
530         require(_value > 0);
531         uint256 _oldValue = endTimeIco;
532         endTimeIco = _value;
533         emit ChangeTime(msg.sender, _value, _oldValue);
534     }
535 
536     /**
537      * @dev owner change address for FundReferal
538      * @param _newAddress new value of address
539      */
540     function setAddressFundReferal(address _newAddress) public onlyOwner {
541         require(_newAddress != address(0));
542         address _oldAddress = addressFundReferal;
543         addressFundReferal = _newAddress;
544         emit ChangeAddressFund(msg.sender, _newAddress, _oldAddress);
545     }
546 
547     function setWallet(address _newWallet) public onlyOwner {
548         require(_newWallet != address(0));
549         address _oldWallet = wallet;
550         wallet = _newWallet;
551         emit ChangeAddressFund(msg.sender, _newWallet, _oldWallet);
552     }
553 
554     /**
555     * @dev Adds single address to whitelist.
556     * @param _payee Address to be added to the whitelist
557     */
558     function addToWhitelist(address _payee) public onlyOwner {
559         whitelistPayee[_payee] = true;
560     }
561 
562     /**
563      * @dev Removes single address from whitelist.
564      * @param _payee Address to be removed to the whitelist
565      */
566     function removeFromWhitelist(address _payee) public onlyOwner {
567         whitelistPayee[_payee] = false;
568     }
569 
570     function setTransferActive(bool _status) public onlyOwner {
571         transfersEnabled = _status;
572     }
573 }
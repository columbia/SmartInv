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
238     string public constant name = "ENZO";
239     string public constant symbol = "NZO";
240     uint8 public constant decimals = 18;
241 
242     event Mint(address indexed to, uint256 amount);
243     event MintFinished();
244 
245     bool public mintingFinished;
246 
247     modifier canMint() {
248         require(!mintingFinished);
249         _;
250     }
251 
252     /**
253      * @dev Function to mint tokens
254      * @param _to The address that will receive the minted tokens.
255      * @param _amount The amount of tokens to mint.
256      * @return A boolean that indicates if the operation was successful.
257      */
258     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
259         balances[_to] = balances[_to].add(_amount);
260         balances[_owner] = balances[_owner].sub(_amount);
261         emit Mint(_to, _amount);
262         emit Transfer(_owner, _to, _amount);
263         return true;
264     }
265 
266     /**
267      * @dev Function to stop minting new tokens.
268      * @return True if the operation was successful.
269      */
270     function finishMinting() onlyOwner canMint internal returns (bool) {
271         mintingFinished = true;
272         emit MintFinished();
273         return true;
274     }
275 
276     /**
277      * Peterson's Law Protection
278      * Claim tokens
279      */
280     function claimTokens(address _token) public onlyOwner {
281         if (_token == 0x0) {
282             owner.transfer(address(this).balance);
283             return;
284         }
285         MintableToken token = MintableToken(_token);
286         uint256 balance = token.balanceOf(this);
287         token.transfer(owner, balance);
288         emit Transfer(_token, owner, balance);
289     }
290 }
291 
292 
293 /**
294  * @title Crowdsale
295  * @dev Crowdsale is a base contract for managing a token crowdsale.
296  * Crowdsales have a start and end timestamps, where investors can make
297  * token purchases. Funds collected are forwarded to a wallet
298  * as they arrive.
299  */
300 contract Crowdsale is Ownable {
301     using SafeMath for uint256;
302     // address where funds are collected
303     address public wallet;
304 
305     // amount of raised money in wei
306     uint256 public weiRaised;
307     uint256 public tokenAllocated;
308 
309     constructor(address _wallet) public {
310         require(_wallet != address(0));
311         wallet = _wallet;
312     }
313 }
314 
315 
316 contract NZOCrowdsale is Ownable, Crowdsale, MintableToken {
317     using SafeMath for uint256;
318 
319     // https://www.coingecko.com/en/coins/ethereum
320     //$0.01 = 1 token & $ 1,000 = 2,1541510490715607 ETH =>
321     // 1,000 / 0.01 = 100,000 token = 2,1541510490715607 ETH =>
322     //100,000 token = 2,1541510490715607 ETH =>
323     //1 ETH = 100,000/2,1541510490715607 = 46422
324 
325     uint256 public rate  = 46422; // for $0.01
326     //uint256 public rate  = 10; // for test's
327 
328     mapping (address => uint256) public deposited;
329     mapping (address => uint256) public paidTokens;
330     mapping (address => bool) public contractAdmins;
331 
332     uint256 public constant INITIAL_SUPPLY = 21 * 10**9 * (10 ** uint256(decimals));
333     uint256 public    fundForSale = 12600 * 10**6 * (10 ** uint256(decimals));
334     uint256 public    fundReserve = 5250000000 * (10 ** uint256(decimals));
335     uint256 public fundFoundation = 1000500000 * (10 ** uint256(decimals));
336     uint256 public       fundTeam = 2100000000 * (10 ** uint256(decimals));
337 
338     uint256 limitWindowZero = 1 * 10**9 * (10 ** uint256(decimals));
339     uint256 limitWindowOther = 1 * 10**9 * (10 ** uint256(decimals));
340     //uint256 limitWindowZero = 20 * (10 ** uint256(decimals)); // for tests
341     //uint256 limitWindowOther = 10 * (10 ** uint256(decimals)); // for tests
342 
343     address public addressFundReserve = 0x67446E0673418d302dB3552bdF05363dB5Fda9Ce;
344     address public addressFundFoundation = 0xfe3859CB2F9d6f448e9959e6e8Fe0be841c62459;
345     address public addressFundTeam = 0xfeD3B7eaDf1bD15FbE3aA1f1eAfa141efe0eeeb2;
346 
347     address public bufferWallet = 0x09618fB091417c08BA74c9CFC65bB2A81F080300;
348 
349     uint256 public startTime = 1533312000; // Fri, 03 Aug 2018 16:00:00 GMT
350     // Eastern Standard Time (EST) + 4 hours = Greenwich Mean Time (GMT))
351     uint numberPeriods = 4;
352 
353 
354     uint256 public countInvestor;
355 
356     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
357     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
358     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
359     event CurrentPeriod(uint period);
360     event Finalized();
361 
362     constructor(address _owner) public
363     Crowdsale(_owner)
364     {
365         require(_owner != address(0));
366         owner = _owner;
367         //owner = msg.sender; // for test's
368         transfersEnabled = true;
369         mintingFinished = false;
370         totalSupply = INITIAL_SUPPLY;
371         bool resultMintForOwner = mintForOwner(owner);
372         require(resultMintForOwner);
373     }
374 
375     // fallback function can be used to buy tokens
376     function() payable public {
377         buyTokens(msg.sender);
378     }
379 
380     function buyTokens(address _investor) public payable returns (uint256){
381         require(_investor != address(0));
382         uint256 weiAmount = msg.value;
383         uint256 tokens = validPurchaseTokens(weiAmount);
384         if (tokens == 0) {revert();}
385         weiRaised = weiRaised.add(weiAmount);
386         tokenAllocated = tokenAllocated.add(tokens);
387         mint(bufferWallet, tokens, owner);
388         paidTokens[_investor] = paidTokens[_investor].add(tokens);
389 
390         emit TokenPurchase(_investor, weiAmount, tokens);
391         if (deposited[_investor] == 0) {
392             countInvestor = countInvestor.add(1);
393         }
394         deposit(_investor);
395         wallet.transfer(weiAmount);
396         return tokens;
397     }
398 
399     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
400         uint256 currentDate = now;
401         //currentDate = 1533513600; // (06 Aug 2018 00:00:00 GMT) for test's
402         //currentDate = 1540051200; // (20 Oct 2018 00:00:00 GMT) for test's
403         uint currentPeriod = 0;
404         currentPeriod = getPeriod(currentDate);
405         uint256 amountOfTokens = 0;
406         if(currentPeriod < 100){
407             if(currentPeriod == 0){
408                 amountOfTokens = _weiAmount.mul(rate).mul(2);
409                 if (tokenAllocated.add(amountOfTokens) > limitWindowZero) {
410                     currentPeriod = currentPeriod.add(1);
411                 }
412             }
413             if(0 < currentPeriod && currentPeriod < (numberPeriods + 1)){
414                 while(currentPeriod < defineCurrentPeriod(currentPeriod, _weiAmount)){
415                     currentPeriod = currentPeriod.add(1);
416                 }
417                 amountOfTokens = _weiAmount.mul(rate).div(currentPeriod);
418             }
419         }
420         emit CurrentPeriod(currentPeriod);
421         return amountOfTokens;
422     }
423 
424     function defineCurrentPeriod(uint _currentPeriod, uint256 _weiAmount) public view returns (uint) {
425         uint256 amountOfTokens = _weiAmount.mul(rate).div(_currentPeriod);
426         if(_currentPeriod == 4) {return 4;}
427         if (tokenAllocated.add(amountOfTokens) > limitWindowZero + limitWindowOther.mul(_currentPeriod)) {
428             return _currentPeriod.add(1);
429         } else {
430             return _currentPeriod;
431         }
432     }
433 
434     function getPeriod(uint256 _currentDate) public view returns (uint) {
435         if( startTime > _currentDate && _currentDate > startTime + 90 days){
436             return 100;
437         }
438         if( startTime <= _currentDate && _currentDate <= startTime + 30 days){
439             return 0;
440         }
441         for(uint j = 0; j < numberPeriods; j++){
442             if( startTime + 30 days + j*15 days <= _currentDate && _currentDate <= startTime + 30 days + (j+1)*15 days){
443                 return j + 1;
444             }
445         }
446         return 100;
447     }
448 
449     function deposit(address investor) internal {
450         deposited[investor] = deposited[investor].add(msg.value);
451     }
452 
453     function paidTokensOf(address _owner) public constant returns (uint256) {
454         return paidTokens[_owner];
455     }
456 
457     function mintForOwner(address _walletOwner) internal returns (bool result) {
458         result = false;
459         require(_walletOwner != address(0));
460         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
461 
462         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
463         balances[addressFundReserve] = balances[addressFundReserve].add(fundReserve);
464         balances[addressFundFoundation] = balances[addressFundFoundation].add(fundFoundation);
465 
466         //tokenAllocated = tokenAllocated.add(12300000000 * (10 ** uint256(decimals))); //for test's
467 
468         result = true;
469     }
470 
471     function getDeposited(address _investor) public view returns (uint256){
472         return deposited[_investor];
473     }
474 
475     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
476         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
477         if (_weiAmount < 0.1 ether) {
478             emit MinWeiLimitReached(msg.sender, _weiAmount);
479             return 0;
480         }
481         if (tokenAllocated.add(addTokens) > fundForSale) {
482             emit TokenLimitReached(tokenAllocated, addTokens);
483             return 0;
484         }
485         return addTokens;
486     }
487 
488     function finalize() public onlyOwner returns (bool result) {
489         result = false;
490         wallet.transfer(address(this).balance);
491         finishMinting();
492         emit Finalized();
493         result = true;
494     }
495 
496     function setRate(uint256 _newRate) external onlyOwner returns (bool){
497         require(_newRate > 0);
498         rate = _newRate;
499         return true;
500     }
501 
502     /**
503     * @dev Add an contract admin
504     */
505     function setContractAdmin(address _admin, bool _isAdmin) public onlyOwner {
506         contractAdmins[_admin] = _isAdmin;
507     }
508 
509     modifier onlyOwnerOrAdmin() {
510         require(msg.sender == owner || contractAdmins[msg.sender] || msg.sender == bufferWallet);
511         _;
512     }
513 
514     function batchTransfer(address[] _recipients, uint256[] _values) external onlyOwnerOrAdmin returns (bool) {
515         require( _recipients.length > 0 && _recipients.length == _values.length);
516         uint256 total = 0;
517         for(uint i = 0; i < _values.length; i++){
518             total = total.add(_values[i]);
519         }
520         require(total <= balanceOf(msg.sender));
521         for(uint j = 0; j < _recipients.length; j++){
522             transfer(_recipients[j], _values[j]);
523             require(0 <= _values[j]);
524             require(_values[j] <= paidTokens[_recipients[j]]);
525             paidTokens[_recipients[j]].sub(_values[j]);
526             emit Transfer(msg.sender, _recipients[j], _values[j]);
527         }
528         return true;
529     }
530 }
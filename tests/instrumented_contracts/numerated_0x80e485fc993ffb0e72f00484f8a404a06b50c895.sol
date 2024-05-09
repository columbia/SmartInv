1 pragma solidity ^0.4.18;
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
107         Transfer(msg.sender, _to, _value);
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
119 
120 }
121 
122 
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127     /**
128      * @dev Transfer tokens from one address to another
129      * @param _from address The address which you want to send tokens from
130      * @param _to address The address which you want to transfer to
131      * @param _value uint256 the amount of tokens to be transferred
132      */
133     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137         require(transfersEnabled);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         }
189         else {
190             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 
196 }
197 
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205     address public owner;
206 
207     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211      * account.
212      */
213     function Ownable() public {
214     }
215 
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(msg.sender == owner);
222         _;
223     }
224 
225 
226     /**
227      * @dev Allows the current owner to transfer control of the contract to a newOwner.
228      * @param _newOwner The address to transfer ownership to.
229      */
230     function changeOwner(address _newOwner) onlyOwner internal {
231         require(_newOwner != address(0));
232         OwnerChanged(owner, _newOwner);
233         owner = _newOwner;
234     }
235 
236 }
237 
238 
239 /**
240  * @title Mintable token
241  * @dev Simple ERC20 Token example, with mintable token creation
242  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
243  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
244  */
245 
246 contract MintableToken is StandardToken, Ownable {
247     string public constant name = "CCoin";
248     string public constant symbol = "CCN";
249     uint8 public constant decimals = 18;
250 
251     event Mint(address indexed to, uint256 amount);
252     event MintFinished();
253 
254     bool public mintingFinished;
255 
256     modifier canMint() {
257         require(!mintingFinished);
258         _;
259     }
260 
261     /**
262      * @dev Function to mint tokens
263      * @param _to The address that will receive the minted tokens.
264      * @param _amount The amount of tokens to mint.
265      * @return A boolean that indicates if the operation was successful.
266      */
267     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
268         balances[_to] = balances[_to].add(_amount);
269         balances[_owner] = balances[_owner].sub(_amount);
270         Mint(_to, _amount);
271         Transfer(_owner, _to, _amount);
272         return true;
273     }
274 
275     /**
276      * @dev Function to stop minting new tokens.
277      * @return True if the operation was successful.
278      */
279     function finishMinting() onlyOwner canMint internal returns (bool) {
280         mintingFinished = true;
281         MintFinished();
282         return true;
283     }
284 
285     /**
286      * Peterson's Law Protection
287      * Claim tokens
288      */
289     function claimTokens(address _token) public onlyOwner {
290         //function claimTokens(address _token) public {  //for test
291         if (_token == 0x0) {
292             owner.transfer(this.balance);
293             return;
294         }
295         MintableToken token = MintableToken(_token);
296         uint256 balance = token.balanceOf(this);
297         token.transfer(owner, balance);
298         Transfer(_token, owner, balance);
299     }
300 }
301 
302 
303 /**
304  * @title Crowdsale
305  * @dev Crowdsale is a base contract for managing a token crowdsale.
306  * Crowdsales have a start and end timestamps, where investors can make
307  * token purchases. Funds collected are forwarded to a wallet
308  * as they arrive.
309  */
310 contract Crowdsale is Ownable {
311     using SafeMath for uint256;
312     // address where funds are collected
313     address public wallet;
314 
315     // amount of raised money in wei
316     uint256 public weiRaised;
317     uint256 public tokenAllocated;
318 
319     function Crowdsale(
320         address _wallet
321     )
322     public
323     {
324         require(_wallet != address(0));
325         wallet = _wallet;
326     }
327 }
328 
329 
330 contract CCNCrowdsale is Ownable, Crowdsale, MintableToken {
331     using SafeMath for uint256;
332 
333     //$0.25 = 1 token => $ 1,000 = 2.50287204567 ETH =>
334     //4,000 token = 2.50287204567 ETH => 1 ETH = 4,000/2.08881106 = 1915
335     uint256 public rate  = 1915;
336 
337     mapping (address => uint256) public deposited;
338     mapping(address => bool) public whitelist;
339 
340     // List of admins
341     mapping (address => bool) public contractAdmins;
342     mapping (address => bool) approveAdmin;
343 
344     uint256 public constant INITIAL_SUPPLY = 90 * (10 ** 6) * (10 ** uint256(decimals));
345     uint256 public fundForSale = 81 * (10 ** 6) * (10 ** uint256(decimals));
346     uint256 public fundForTeam =  9 * (10 ** 6) * (10 ** uint256(decimals));
347     uint256 public fundPreIco = 27 * (10 ** 6) * (10 ** uint256(decimals));
348     uint256 public fundIco = 54 * (10 ** 6) * (10 ** uint256(decimals));
349     address[] public admins = [ 0x2fDE63cE90FB00C51f13b401b2C910D90c92A3e6,
350                                 0x5856FCDbD2901E8c7d38AC7eb0756F7B3669eC67,
351                                 0x4c1310B5817b74722Cade4Ee33baC83ADB91Eabc];
352 
353 
354     uint256 public countInvestor;
355 
356     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
357     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
358 
359 
360     function CCNCrowdsale (
361         address _owner
362     )
363     public
364     Crowdsale(_owner)
365     {
366         require(_owner != address(0));
367         owner = _owner;
368         //owner = msg.sender; //for test's
369         transfersEnabled = true;
370         mintingFinished = false;
371         totalSupply = INITIAL_SUPPLY;
372         bool resultMintForOwner = mintForOwner(owner);
373         require(resultMintForOwner);
374         for(uint i = 0; i < 3; i++) {
375             contractAdmins[admins[i]] = true;
376         }
377     }
378 
379     // fallback function can be used to buy tokens
380     function() payable public {
381        buyTokens(msg.sender);
382     }
383 
384     // low level token purchase function
385     function buyTokens(address _investor) public onlyWhitelist payable returns (uint256){
386          require(_investor != address(0));
387          uint256 weiAmount = msg.value;
388          uint256 tokens = validPurchaseTokens(weiAmount);
389          if (tokens == 0) {revert();}
390          weiRaised = weiRaised.add(weiAmount);
391          tokenAllocated = tokenAllocated.add(tokens);
392          mint(_investor, tokens, owner);
393 
394          TokenPurchase(_investor, weiAmount, tokens);
395          if (deposited[_investor] == 0) {
396             countInvestor = countInvestor.add(1);
397          }
398          deposit(_investor);
399          wallet.transfer(weiAmount);
400          return tokens;
401     }
402 
403     function getTotalAmountOfTokens(uint256 _weiAmount) internal view returns (uint256) {
404          uint256 currentDate = now;
405          //currentDate = 1527379200; //for test's
406          uint256 currentPeriod = getPeriod(currentDate);
407          uint256 amountOfTokens = 0;
408          uint256 checkAmount = 0;
409          if(currentPeriod < 3){
410              if(whitelist[msg.sender]){
411                  amountOfTokens = _weiAmount.mul(rate);
412                  return amountOfTokens;
413              }
414              amountOfTokens = _weiAmount.mul(rate);
415              checkAmount = tokenAllocated.add(amountOfTokens);
416              if (currentPeriod == 0) {
417                  if (checkAmount > fundPreIco){
418                      amountOfTokens = 0;
419                  }
420              }
421              if (currentPeriod == 1) {
422                  if (checkAmount > fundIco){
423                     amountOfTokens = 0;
424                  }
425              }
426          }
427          return amountOfTokens;
428     }
429 
430     function getPeriod(uint256 _currentDate) public pure returns (uint) {
431         //1525737600 - May, 08, 2018 00:00:00 && 1527379199 - May, 26, 2018 23:59:59
432         //1527379200 - May, 27, 2018 00:00:00 && 1530143999 - Jun, 27, 2018 23:59:59
433         //1530489600 - Jul, 02, 2018 00:00:00
434 
435         if( 1525737600 <= _currentDate && _currentDate <= 1527379199){
436             return 0;
437         }
438         if( 1527379200 <= _currentDate && _currentDate <= 1530143999){
439             return 1;
440         }
441         if( 1530489600 <= _currentDate){
442            return 2;
443         }
444         return 10;
445     }
446 
447     function deposit(address investor) internal {
448         deposited[investor] = deposited[investor].add(msg.value);
449     }
450 
451     function mintForOwner(address _wallet) internal returns (bool result) {
452         result = false;
453         require(_wallet != address(0));
454         balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
455         result = true;
456     }
457 
458     function getDeposited(address _investor) external view returns (uint256){
459         return deposited[_investor];
460     }
461 
462     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
463         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
464         if (tokenAllocated.add(addTokens) > fundForSale) {
465             TokenLimitReached(tokenAllocated, addTokens);
466             return 0;
467         }
468         return addTokens;
469     }
470 
471     function setRate(uint256 _newRate) public approveAllAdmin returns (bool){
472         require(_newRate > 0);
473         rate = _newRate;
474         removeAllApprove();
475         return true;
476     }
477 
478     /**
479     * @dev Add an contract admin
480     */
481     function setContractAdmin(address _admin, bool _isAdmin, uint _index) external onlyOwner {
482         require(_admin != address(0));
483         require(0 <= _index && _index < 3);
484         contractAdmins[_admin] = _isAdmin;
485         if(_isAdmin){
486             admins[_index] = _admin;
487         }
488     }
489 
490     modifier approveAllAdmin() {
491         bool result = true;
492         for(uint i = 0; i < 3; i++) {
493             if (approveAdmin[admins[i]] == false) {
494                 result = false;
495             }
496         }
497         require(result == true);
498         _;
499     }
500 
501     function removeAllApprove() public approveAllAdmin {
502         for(uint i = 0; i < 3; i++) {
503             approveAdmin[admins[i]] = false;
504         }
505     }
506 
507     function setApprove(bool _isApprove) external onlyOwnerOrAnyAdmin {
508         approveAdmin[msg.sender] = _isApprove;
509     }
510 
511     /**
512     * @dev Adds single address to whitelist.
513     * @param _beneficiary Address to be added to the whitelist
514     */
515     function addToWhitelist(address _beneficiary) external onlyOwnerOrAnyAdmin {
516         whitelist[_beneficiary] = true;
517     }
518 
519     /**
520      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
521      * @param _beneficiaries Addresses to be added to the whitelist
522      */
523     function addManyToWhitelist(address[] _beneficiaries) external onlyOwnerOrAnyAdmin {
524         require(_beneficiaries.length < 101);
525         for (uint256 i = 0; i < _beneficiaries.length; i++) {
526             whitelist[_beneficiaries[i]] = true;
527         }
528     }
529 
530     /**
531      * @dev Removes single address from whitelist.
532      * @param _beneficiary Address to be removed to the whitelist
533      */
534     function removeFromWhitelist(address _beneficiary) external onlyOwnerOrAnyAdmin {
535         whitelist[_beneficiary] = false;
536     }
537 
538     modifier onlyOwnerOrAnyAdmin() {
539         require(msg.sender == owner || contractAdmins[msg.sender]);
540         _;
541     }
542 
543     modifier onlyWhitelist() {
544         require(whitelist[msg.sender]);
545         _;
546     }
547 
548 }
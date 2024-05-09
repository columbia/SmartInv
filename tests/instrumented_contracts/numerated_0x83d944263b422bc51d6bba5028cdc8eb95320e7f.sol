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
238     string public constant name = "Future Energy Token";
239     string public constant symbol = "FGY";
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
305 
306     // amount of raised money in wei
307     uint256 public weiRaised;
308     uint256 public tokenAllocated;
309 
310     constructor(address _wallet) public {
311         require(_wallet != address(0));
312         wallet = _wallet;
313     }
314 }
315 
316 
317 contract FGYCrowdsale is Ownable, Crowdsale, MintableToken {
318     using SafeMath for uint256;
319 
320     /**
321     * Price: 1 ETH = 206 token
322     * https://www.coingecko.com/en/coins/ethereum
323     * October, 20, 2018
324     */
325     uint256 public rate  = 206;
326 
327     mapping (address => uint256) public deposited;
328     mapping (address => bool) public whitelist;
329     mapping (address => bool) internal isRefferer;
330 
331 
332     uint256 public constant INITIAL_SUPPLY = 35 * 10**6 * (10 ** uint256(decimals));
333 
334     uint256 startTimePreIco = 1539993600; // Sat, 20 Oct 2018 00:00:00 GMT
335     uint256 endTimePreIco =   1546300799; // Mon, 31 Dec 2018 23:59:59 GMT
336 
337     uint256 startTimeIco = 1546300800; // Tue, 01 Jan 2019 00:00:00 GMT
338     uint256 endTimeIco   = 1554076799; // Sun, 31 Mar 2019 23:59:59 GMT
339 
340     uint256 public countInvestor;
341 
342     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
343     event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);
344     event CurrentPeriod(uint period);
345     event ChangeTime(address indexed owner, uint256 newValue, uint256 oldValue);
346     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
347     event ChangeRate(address indexed owner, uint256 newValue, uint256 oldValue);
348     event Burn(address indexed burner, uint256 value);
349     event Finalized();
350 
351     constructor(address _owner) public
352     Crowdsale(_owner)
353     {
354         require(_owner != address(0));
355         owner = _owner;
356         //owner = msg.sender; // for test's
357         transfersEnabled = true;
358         mintingFinished = false;
359         totalSupply = INITIAL_SUPPLY;
360         bool resultMintForOwner = mintForFund(owner);
361         require(resultMintForOwner);
362     }
363 
364     // fallback function can be used to buy tokens
365     function() payable public {
366         buyTokens(msg.sender);
367     }
368 
369     function buyTokens(address _investor) public payable returns (uint256){
370         require(_investor != address(0));
371         uint256 weiAmount = msg.value;
372         uint256 tokens = validPurchaseTokens(weiAmount);
373         if (tokens == 0) {revert();}
374         weiRaised = weiRaised.add(weiAmount);
375         tokenAllocated = tokenAllocated.add(tokens);
376         mint(_investor, tokens, owner);
377 
378         emit TokenPurchase(_investor, weiAmount, tokens);
379         if (deposited[_investor] == 0) {
380             countInvestor = countInvestor.add(1);
381         }
382         deposit(_investor);
383         wallet.transfer(weiAmount);
384         return tokens;
385     }
386 
387     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
388         uint256 currentDate = now;
389         //currentDate = 1540425600; // (25 Oct 2018) // for test's
390         uint currentPeriod = 0;
391         currentPeriod = getPeriod(currentDate);
392         uint256 amountOfTokens = 0;
393         if(currentPeriod > 0){
394             if(currentPeriod == 1){
395                 amountOfTokens += _weiAmount.mul(rate).mul(130).div(100);
396             }
397             if(currentPeriod >= 2){
398                 amountOfTokens += _weiAmount.mul(rate);
399             }
400         }
401         emit CurrentPeriod(currentPeriod);
402         return amountOfTokens;
403     }
404 
405     function getPeriod(uint256 _currentDate) public view returns (uint) {
406         if(_currentDate < startTimePreIco){
407             return 0;
408         }
409         if( startTimePreIco <= _currentDate && _currentDate <= endTimePreIco){
410             return 1;
411         }
412         if( startTimeIco <= _currentDate && _currentDate <= endTimeIco){
413             return 2;
414         }
415         return 0;
416     }
417 
418     function deposit(address investor) internal {
419         deposited[investor] = deposited[investor].add(msg.value);
420     }
421 
422     function mintForFund(address _walletOwner) internal returns (bool result) {
423         result = false;
424         require(_walletOwner != address(0));
425         balances[_walletOwner] = balances[_walletOwner].add(INITIAL_SUPPLY);
426         result = true;
427     }
428 
429     function getDeposited(address _investor) external view returns (uint256){
430         return deposited[_investor];
431     }
432 
433     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
434         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
435         if (tokenAllocated.add(addTokens) > balances[owner]) {
436             emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);
437             return 0;
438         }
439         return addTokens;
440     }
441 
442     /**
443      * @dev owner burn Token.
444      * @param _value amount of burnt tokens
445      */
446     function ownerBurnToken(uint _value) public onlyOwner {
447         require(_value > 0);
448         require(_value <= balances[owner]);
449         require(_value <= totalSupply);
450 
451         balances[owner] = balances[owner].sub(_value);
452         totalSupply = totalSupply.sub(_value);
453         emit Burn(msg.sender, _value);
454     }
455 
456     /**
457      * @dev owner change time for startTimePreIco
458      * @param _value new time value
459      */
460     function setStartTimePreIco(uint256 _value) external onlyOwner {
461         require(_value > 0);
462         uint256 _oldValue = startTimePreIco;
463         startTimePreIco = _value;
464         emit ChangeTime(msg.sender, _value, _oldValue);
465     }
466 
467 
468     /**
469      * @dev owner change time for endTimePreIco
470      * @param _value new time value
471      */
472     function setEndTimePreIco(uint256 _value) external onlyOwner {
473         require(_value > 0);
474         uint256 _oldValue = endTimePreIco;
475         endTimePreIco = _value;
476         emit ChangeTime(msg.sender, _value, _oldValue);
477     }
478 
479     /**
480      * @dev owner change time for startTimeIco
481      * @param _value new time value
482      */
483     function setStartTimeIco(uint256 _value) external onlyOwner {
484         require(_value > 0);
485         uint256 _oldValue = startTimeIco;
486         startTimeIco = _value;
487         emit ChangeTime(msg.sender, _value, _oldValue);
488     }
489 
490     /**
491      * @dev owner change time for endTimeIco
492      * @param _value new time value
493      */
494     function setEndTimeIco(uint256 _value) external onlyOwner {
495         require(_value > 0);
496         uint256 _oldValue = endTimeIco;
497         endTimeIco = _value;
498         emit ChangeTime(msg.sender, _value, _oldValue);
499     }
500 
501     /**
502      * @dev owner change address of wallet for collecting ETH
503      * @param _newWallet new address of wallet
504      */
505     function setWallet(address _newWallet) external onlyOwner {
506         require(_newWallet != address(0));
507         address _oldWallet = wallet;
508         wallet = _newWallet;
509         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
510     }
511 
512     /**
513      * @dev owner change price of tokens
514      * @param _newRate new price
515      */
516     function setRate(uint256 _newRate) external onlyOwner {
517         require(_newRate > 0);
518         uint256 _oldRate = rate;
519         rate = _newRate;
520         emit ChangeRate(msg.sender, _newRate, _oldRate);
521     }
522 
523     /**
524      * @dev owner completes contract
525      */
526     function finalize() public onlyOwner returns (bool result) {
527         result = false;
528         transfersEnabled = false;
529         finishMinting();
530         emit Finalized();
531         result = true;
532     }
533 
534 }
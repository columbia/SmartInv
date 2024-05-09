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
238     string public constant name = "Oodlz Token";
239     string public constant symbol = "ODZ";
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
316 contract ODZCrowdsale is Ownable, Crowdsale, MintableToken {
317     using SafeMath for uint256;
318 
319     uint256 public ratePreIco  = 250;
320     uint256 public rateIco  = 200;
321 
322     uint256 public weiMin = 25 ether;
323 
324     mapping (address => uint256) public deposited;
325 
326     uint256 public constant INITIAL_SUPPLY = 85 * 10**7 * (10 ** uint256(decimals));
327     uint256 public    fundForSale = 17 * 10**7 * (10 ** uint256(decimals));
328 
329     uint256 public   fundTeam = 1275 * 10**5 * (10 ** uint256(decimals));
330     uint256 public fundReserv = 5525 * 10**5 * (10 ** uint256(decimals));
331 
332     uint256 limitPreIco = 34 * 10**6 * (10 ** uint256(decimals));
333 
334     address public addressFundTeam   = 0x3939f99C5f8C9198c7D40E5880ee731F2F6395AC;
335     address public addressFundReserv = 0xE6a4A7bd59989dA07417cDba8f6a4c29fd4732a3;
336 
337     uint256 startTimePreIco = 1541044800; // 1 Nov 2018 
338     uint256 endTimePreIco =   1548892800; // 31 Jan 2019
339     uint256 startTimeIco =    1548997200; // 1 Feb 2019
340 
341     uint256 public countInvestor;
342 
343     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
344     event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);
345     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
346     event CurrentPeriod(uint period);
347     event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);
348     event ChangeRate(address indexed owner, uint256 newValue, uint256 oldValue);
349 
350     constructor(address _owner, address _wallet) public
351     Crowdsale(_wallet)
352     {
353         require(_owner != address(0));
354         owner = _owner;
355         transfersEnabled = true;
356         mintingFinished = false;
357         totalSupply = INITIAL_SUPPLY;
358         bool resultMintForOwner = mintForFund(owner);
359         require(resultMintForOwner);
360     }
361 
362     // fallback function can be used to buy tokens
363     function() payable public {
364         buyTokens(msg.sender);
365     }
366 
367     function buyTokens(address _investor) public payable returns (uint256){
368         require(_investor != address(0));
369         uint256 weiAmount = msg.value;
370         uint256 tokens = validPurchaseTokens(weiAmount);
371         if (tokens == 0) {revert();}
372         weiRaised = weiRaised.add(weiAmount);
373         tokenAllocated = tokenAllocated.add(tokens);
374         mint(_investor, tokens, owner);
375 
376         emit TokenPurchase(_investor, weiAmount, tokens);
377         if (deposited[_investor] == 0) {
378             countInvestor = countInvestor.add(1);
379         }
380         deposit(_investor);
381         wallet.transfer(weiAmount);
382         return tokens;
383     }
384 
385     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
386         uint256 currentDate = now;
387         uint currentPeriod = 0;
388         currentPeriod = getPeriod(currentDate);
389         uint256 amountOfTokens = 0;
390         if(currentPeriod > 0){
391             if(currentPeriod == 1){
392                 amountOfTokens = _weiAmount.mul(ratePreIco);
393                 if (tokenAllocated.add(amountOfTokens) > limitPreIco) {
394                     currentPeriod = currentPeriod.add(1);
395                 }
396             }
397             if(currentPeriod == 2){
398                 amountOfTokens = _weiAmount.mul(rateIco);
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
412         if( endTimePreIco < _currentDate && _currentDate < startTimeIco){
413             return 0;
414         }
415         if( startTimeIco <= _currentDate){
416             return 2;
417         }
418         return 0;
419     }
420 
421     function deposit(address investor) internal {
422         deposited[investor] = deposited[investor].add(msg.value);
423     }
424 
425     function mintForFund(address _walletOwner) internal returns (bool result) {
426         result = false;
427         require(_walletOwner != address(0));
428         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
429 
430         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
431         balances[addressFundReserv] = balances[addressFundReserv].add(fundReserv);
432 
433         result = true;
434     }
435 
436     function getDeposited(address _investor) public view returns (uint256){
437         return deposited[_investor];
438     }
439 
440     function setWallet(address _newWallet) public onlyOwner {
441         require(_newWallet != address(0));
442         address _oldWallet = wallet;
443         wallet = _newWallet;
444         emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);
445     }
446 
447     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
448         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
449         if (_weiAmount < weiMin) {
450             emit MinWeiLimitReached(msg.sender, _weiAmount);
451             return 0;
452         }
453         if (tokenAllocated.add(addTokens) > fundForSale) {
454             emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);
455             return 0;
456         }
457         return addTokens;
458     }
459 
460     /**
461      * @dev owner change rate for pre ICO
462      * @param _value new rate value
463      */
464     function setRatePreIco(uint256 _value) public onlyOwner {
465         require(_value > 0);
466         uint256 _oldValue = ratePreIco;
467         ratePreIco = _value;
468         emit ChangeRate(msg.sender, _value, _oldValue);
469     }
470 
471     /**
472      * @dev owner change rate for ICO
473      * @param _value new rate value
474      */
475     function setRateIco(uint256 _value) public onlyOwner {
476         require(_value > 0);
477         uint256 _oldValue = rateIco;
478         rateIco = _value;
479         emit ChangeRate(msg.sender, _value, _oldValue);
480     }
481 
482     function setWeiMin(uint256 _value) public onlyOwner {
483         require(_value > 0);
484         weiMin = _value;
485     }
486 }
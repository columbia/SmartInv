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
320     // For June 02, 2018
321     //$0.01 = 1 token => $ 1,000 = 1.7089051044995474 ETH =>
322     // 1,000 / 0.01 = 100,000 token = 1.7089051044995474 ETH =>
323     //100,000 token = 1.7089051044995474 ETH =>
324     //1 ETH = 100,000/1.7089051044995474 = 58517
325     uint256 public rate  = 58517; // for $0.01
326     //uint256 public rate  = 10; // for test's
327 
328     mapping (address => uint256) public deposited;
329 
330     uint256 public constant INITIAL_SUPPLY = 21 * 10**9 * (10 ** uint256(decimals));
331     uint256 public    fundForSale = 12600 * 10**6 * (10 ** uint256(decimals));
332     uint256 public    fundReserve = 5250000000 * (10 ** uint256(decimals));
333     uint256 public fundFoundation = 1000500000 * (10 ** uint256(decimals));
334     uint256 public       fundTeam = 2100000000 * (10 ** uint256(decimals));
335 
336     uint256 limitWeekZero = 2500000000 * (10 ** uint256(decimals));
337     uint256 limitWeekOther = 200000000 * (10 ** uint256(decimals));
338     //uint256 limitWeekZero = 20 * (10 ** uint256(decimals)); // for tests
339     //uint256 limitWeekOther = 10 * (10 ** uint256(decimals)); // for tests
340 
341     address public addressFundReserve = 0x67446E0673418d302dB3552bdF05363dB5Fda9Ce;
342     address public addressFundFoundation = 0xfe3859CB2F9d6f448e9959e6e8Fe0be841c62459;
343     address public addressFundTeam = 0xfeD3B7eaDf1bD15FbE3aA1f1eAfa141efe0eeeb2;
344 
345     uint256 public startTime = 1530720000; // Wed, 04 Jul 2018 16:00:00 GMT
346     // Eastern Standard Time (EST) + 4 hours = Greenwich Mean Time (GMT))
347     uint numberWeeks = 46;
348 
349 
350     uint256 public countInvestor;
351 
352     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
353     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
354     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
355     event Finalized();
356 
357     constructor(address _owner) public
358     Crowdsale(_owner)
359     {
360         require(_owner != address(0));
361         owner = _owner;
362         //owner = msg.sender; // for test's
363         transfersEnabled = true;
364         mintingFinished = false;
365         totalSupply = INITIAL_SUPPLY;
366         bool resultMintForOwner = mintForOwner(owner);
367         require(resultMintForOwner);
368     }
369 
370     // fallback function can be used to buy tokens
371     function() payable public {
372         buyTokens(msg.sender);
373     }
374 
375     function buyTokens(address _investor) public payable returns (uint256){
376         require(_investor != address(0));
377         uint256 weiAmount = msg.value;
378         uint256 tokens = validPurchaseTokens(weiAmount);
379         if (tokens == 0) {revert();}
380         weiRaised = weiRaised.add(weiAmount);
381         tokenAllocated = tokenAllocated.add(tokens);
382         mint(_investor, tokens, owner);
383 
384         emit TokenPurchase(_investor, weiAmount, tokens);
385         if (deposited[_investor] == 0) {
386             countInvestor = countInvestor.add(1);
387         }
388         deposit(_investor);
389         wallet.transfer(weiAmount);
390         return tokens;
391     }
392 
393     function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {
394         uint256 currentDate = now;
395         //currentDate = 1533513600; // (06 Aug 2018 00:00:00 GMT) for test's
396         //currentDate = 1534694400; // (19 Aug 2018 00:00:00 GMT) for test's
397         uint currentPeriod = getPeriod(currentDate);
398         uint256 amountOfTokens = 0;
399         if(currentPeriod < 100){
400             if(currentPeriod == 0){
401                 amountOfTokens = _weiAmount.mul(rate).div(4);
402                 if (tokenAllocated.add(amountOfTokens) > limitWeekZero) {
403                     emit TokenLimitReached(tokenAllocated, amountOfTokens);
404                     return 0;
405                 }
406             }
407             for(uint j = 0; j < numberWeeks; j++){
408                 if(currentPeriod == (j + 1)){
409                     amountOfTokens = _weiAmount.mul(rate).div(5+j*25);
410                     if (tokenAllocated.add(amountOfTokens) > limitWeekZero + limitWeekOther.mul(j+1)) {
411                         emit TokenLimitReached(tokenAllocated, amountOfTokens);
412                         return 0;
413                     }
414                 }
415             }
416         }
417         return amountOfTokens;
418     }
419 
420     function getPeriod(uint256 _currentDate) public view returns (uint) {
421         if( startTime > _currentDate && _currentDate > startTime + 365 days){
422             return 100;
423         }
424         if( startTime <= _currentDate && _currentDate <= startTime + 43 days){
425             return 0;
426         }
427         for(uint j = 0; j < numberWeeks; j++){
428             if( startTime + 43 days + j*7 days <= _currentDate && _currentDate <= startTime + 43 days + (j+1)*7 days){
429                 return j + 1;
430             }
431         }
432         return 100;
433     }
434 
435     function deposit(address investor) internal {
436         deposited[investor] = deposited[investor].add(msg.value);
437     }
438 
439     function mintForOwner(address _walletOwner) internal returns (bool result) {
440         result = false;
441         require(_walletOwner != address(0));
442         balances[_walletOwner] = balances[_walletOwner].add(fundForSale);
443 
444         balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);
445         balances[addressFundReserve] = balances[addressFundReserve].add(fundReserve);
446         balances[addressFundFoundation] = balances[addressFundFoundation].add(fundFoundation);
447 
448         result = true;
449     }
450 
451     function getDeposited(address _investor) public view returns (uint256){
452         return deposited[_investor];
453     }
454 
455     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
456         uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
457         if (_weiAmount < 0.5 ether) {
458             emit MinWeiLimitReached(msg.sender, _weiAmount);
459             return 0;
460         }
461         if (tokenAllocated.add(addTokens) > fundForSale) {
462             emit TokenLimitReached(tokenAllocated, addTokens);
463             return 0;
464         }
465         return addTokens;
466     }
467 
468     function finalize() public onlyOwner returns (bool result) {
469         result = false;
470         wallet.transfer(address(this).balance);
471         finishMinting();
472         emit Finalized();
473         result = true;
474     }
475 
476     function setRate(uint256 _newRate) external onlyOwner returns (bool){
477         require(_newRate > 0);
478         rate = _newRate;
479         return true;
480     }
481 }
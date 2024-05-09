1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97     function totalSupply() public view returns (uint256);
98     function balanceOf(address who) public view returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public view returns (uint256);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) balances;
122 
123     uint256 totalSupply_;
124 
125     /**
126     * @dev total number of tokens in existence
127     */
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         // SafeMath.sub will throw if there is not enough balance.
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     /**
149     * @dev Gets the balance of the specified address.
150     * @param _owner The address to query the the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */
153     function balanceOf(address _owner) public view returns (uint256 balance) {
154         return balances[_owner];
155     }
156 
157 }
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168     mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171     /**
172      * @dev Transfer tokens from one address to another
173      * @param _from address The address which you want to send tokens from
174      * @param _to address The address which you want to transfer to
175      * @param _value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178         require(_to != address(0));
179         require(_value <= balances[_from]);
180         require(_value <= allowed[_from][msg.sender]);
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      *
192      * Beware that changing an allowance with this method brings the risk that someone may use both the old
193      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      * @param _spender The address which will spend the funds.
197      * @param _value The amount of tokens to be spent.
198      */
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         allowed[msg.sender][_spender] = _value;
201         Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param _owner address The address which owns the funds.
208      * @param _spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address _owner, address _spender) public view returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      *
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      *
234      * approve should be called when allowed[_spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * @param _spender The address which will spend the funds.
239      * @param _subtractedValue The amount of tokens to decrease the allowance by.
240      */
241     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242         uint oldValue = allowed[msg.sender][_spender];
243         if (_subtractedValue > oldValue) {
244             allowed[msg.sender][_spender] = 0;
245         } else {
246             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247         }
248         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251 
252 }
253 
254 /**
255  * @title Burnable Token
256  * @dev Token that can be irreversibly burned (destroyed).
257  */
258 contract BurnableToken is BasicToken {
259 
260     event Burn(address indexed burner, uint256 value);
261 
262     /**
263      * @dev Burns a specific amount of tokens.
264      * @param _value The amount of token to be burned.
265      */
266     function burn(uint256 _value) public {
267         require(_value <= balances[msg.sender]);
268         // no need to require value <= totalSupply, since that would imply the
269         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
270 
271         address burner = msg.sender;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply_ = totalSupply_.sub(_value);
274         Burn(burner, _value);
275         Transfer(burner, address(0), _value);
276     }
277 }
278 
279 /**
280  * @title TriggmineToken
281  */
282 contract TriggmineToken is StandardToken, BurnableToken, Ownable {
283 
284     string public constant name = "Triggmine Coin";
285 
286     string public constant symbol = "TRG";
287 
288     uint256 public constant decimals = 18;
289 
290     bool public released = false;
291     event Release();
292 
293     address public holder;
294 
295     mapping(address => uint) public lockedAddresses;
296 
297     modifier isReleased () {
298         require(released || msg.sender == holder || msg.sender == owner);
299         require(lockedAddresses[msg.sender] <= now);
300         _;
301     }
302 
303     function TriggmineToken() public {
304         owner = 0x7E83f1F82Ab7dDE49F620D2546BfFB0539058414;
305 
306         totalSupply_ = 620000000 * (10 ** decimals);
307         balances[owner] = totalSupply_;
308         Transfer(0x0, owner, totalSupply_);
309 
310         holder = owner;
311     }
312 
313     function lockAddress(address _lockedAddress, uint256 _time) public onlyOwner returns (bool) {
314         require(balances[_lockedAddress] == 0 && lockedAddresses[_lockedAddress] == 0 && _time > now);
315         lockedAddresses[_lockedAddress] = _time;
316         return true;
317     }
318 
319     function release() onlyOwner public returns (bool) {
320         require(!released);
321         released = true;
322         Release();
323 
324         return true;
325     }
326 
327     function getOwner() public view returns (address) {
328         return owner;
329     }
330 
331     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
332         return super.transfer(_to, _value);
333     }
334 
335     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
336         return super.transferFrom(_from, _to, _value);
337     }
338 
339     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
340         return super.approve(_spender, _value);
341     }
342 
343     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
344         return super.increaseApproval(_spender, _addedValue);
345     }
346 
347     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
348         return super.decreaseApproval(_spender, _subtractedValue);
349     }
350 
351     function transferOwnership(address newOwner) public onlyOwner {
352         address oldOwner = owner;
353         super.transferOwnership(newOwner);
354 
355         if (oldOwner != holder) {
356             allowed[holder][oldOwner] = 0;
357             Approval(holder, oldOwner, 0);
358         }
359 
360         if (owner != holder) {
361             allowed[holder][owner] = balances[holder];
362             Approval(holder, owner, balances[holder]);
363         }
364     }
365 
366 }
367 
368 contract TriggmineCrowdsale is Ownable {
369     using SafeMath for uint256;
370 
371     uint256 public constant SALES_START = 1529938800; // Monday, June 25, 2018 3:00:00 PM
372     uint256 public constant SALES_END = 1538319600; // Sunday, September 30, 2018 3:00:00 PM
373 
374     address public constant ASSET_MANAGER_WALLET = 0x7E83f1F82Ab7dDE49F620D2546BfFB0539058414;
375     address public constant ESCROW_WALLET = 0x2e9F22E2D559d9a5ce234AB722bc6e818FA5D079;
376 
377     address public constant TOKEN_ADDRESS = 0x98F319D4dc58315796Ec8F06274fe2d4a5A69721; // Triggmine coin ERC20 contract address
378     uint256 public constant TOKEN_CENTS = 1000000000000000000; // 1 TRG is 1^18
379     uint256 public constant TOKEN_PRICE = 0.0001 ether;
380 
381     uint256 public constant USD_HARD_CAP = 15000000;
382     uint256 public constant MIN_INVESTMENT = 25000;
383 
384     uint public constant BONUS_50_100 = 10;
385     uint public constant BONUS_100_250 = 15;
386     uint public constant BONUS_250_500 = 20;
387     uint public constant BONUS_500 = 25;
388 
389     mapping(address => uint256) public investments;
390     uint256 public investedUSD;
391     uint256 public investedETH;
392     uint256 public investedBTC;
393     uint256 public tokensPurchased;
394 
395     uint256 public rate_ETHUSD;
396     uint256 public rate_BTCUSD;
397 
398     address public whitelistSupplier;
399     mapping(address => bool) public whitelist;
400 
401     event ContributedETH(address indexed receiver, uint contribution, uint contributionUSD, uint reward);
402     event ContributedBTC(address indexed receiver, uint contribution, uint contributionUSD, uint reward);
403     event WhitelistUpdated(address indexed participant, bool isWhitelisted);
404 
405     constructor() public {
406         whitelistSupplier = msg.sender;
407         owner = ASSET_MANAGER_WALLET;
408     }
409 
410     modifier onlyWhitelistSupplier() {
411         require(msg.sender == whitelistSupplier || msg.sender == owner);
412         _;
413     }
414 
415     function contribute() public payable returns(bool) {
416         return contributeETH(msg.sender);
417     }
418 
419     function contributeETH(address _participant) public payable returns(bool) {
420         require(now >= SALES_START && now < SALES_END);
421         require(whitelist[_participant]);
422 
423         uint256 usdAmount = (msg.value * rate_ETHUSD) / 10**18;
424         investedUSD = investedUSD.add(usdAmount);
425         require(investedUSD <= USD_HARD_CAP);
426         investments[msg.sender] = investments[msg.sender].add(usdAmount);
427         require(investments[msg.sender] >= MIN_INVESTMENT);
428 
429         uint bonusPercents = getBonusPercents(usdAmount);
430         uint totalTokens = getTotalTokens(msg.value, bonusPercents);
431 
432         tokensPurchased = tokensPurchased.add(totalTokens);
433         require(TriggmineToken(TOKEN_ADDRESS).transferFrom(ASSET_MANAGER_WALLET, _participant, totalTokens));
434         investedETH = investedETH.add(msg.value);
435         ESCROW_WALLET.transfer(msg.value);
436 
437         emit ContributedETH(_participant, msg.value, usdAmount, totalTokens);
438         return true;
439     }
440 
441     function contributeBTC(address _participant, uint256 _btcAmount) public onlyWhitelistSupplier returns(bool) {
442         require(now >= SALES_START && now < SALES_END);
443         require(whitelist[_participant]);
444 
445         uint256 usdAmount = (_btcAmount * rate_BTCUSD) / 10**8; // BTC amount should be provided in satoshi
446         investedUSD = investedUSD.add(usdAmount);
447         require(investedUSD <= USD_HARD_CAP);
448         investments[_participant] = investments[_participant].add(usdAmount);
449         require(investments[_participant] >= MIN_INVESTMENT);
450 
451         uint bonusPercents = getBonusPercents(usdAmount);
452 
453         uint256 ethAmount = (_btcAmount * rate_BTCUSD * 10**10) / rate_ETHUSD;
454         uint totalTokens = getTotalTokens(ethAmount, bonusPercents);
455 
456         tokensPurchased = tokensPurchased.add(totalTokens);
457         require(TriggmineToken(TOKEN_ADDRESS).transferFrom(ASSET_MANAGER_WALLET, _participant, totalTokens));
458         investedBTC = investedBTC.add(_btcAmount);
459 
460         emit ContributedBTC(_participant, _btcAmount, usdAmount, totalTokens);
461         return true;
462     }
463 
464     function setRate_ETHUSD(uint256 _rate) public onlyWhitelistSupplier {
465         rate_ETHUSD = _rate;
466     }
467 
468     function setRate_BTCUSD(uint256 _rate) public onlyWhitelistSupplier {
469         rate_BTCUSD = _rate;
470     }
471 
472     function getBonusPercents(uint256 usdAmount) private pure returns(uint256) {
473         if (usdAmount >= 500000) {
474             return BONUS_500;
475         }
476 
477         if (usdAmount >= 250000) {
478             return BONUS_250_500;
479         }
480 
481         if (usdAmount >= 100000) {
482             return BONUS_100_250;
483         }
484 
485         if (usdAmount >= 50000) {
486             return BONUS_50_100;
487         }
488 
489         return 0;
490     }
491 
492     function getTotalTokens(uint256 ethAmount, uint256 bonusPercents) private pure returns(uint256) {
493         // If there is some division reminder, we just collect it too.
494         uint256 tokensAmount = (ethAmount * TOKEN_CENTS) / TOKEN_PRICE;
495         require(tokensAmount > 0);
496         uint256 bonusTokens = (tokensAmount * bonusPercents) / 100;
497         uint256 totalTokens = tokensAmount.add(bonusTokens);
498 
499         return totalTokens;
500     }
501 
502     function () public payable {
503         contribute();
504     }
505 
506     function addToWhitelist(address _participant) onlyWhitelistSupplier public returns(bool) {
507         if (whitelist[_participant]) {
508             return true;
509         }
510         whitelist[_participant] = true;
511         emit WhitelistUpdated(_participant, true);
512 
513         return true;
514     }
515 
516     function removeFromWhitelist(address _participant) onlyWhitelistSupplier public returns(bool) {
517         if (!whitelist[_participant]) {
518             return true;
519         }
520         whitelist[_participant] = false;
521         emit WhitelistUpdated(_participant, false);
522 
523         return true;
524     }
525 
526     function getTokenOwner() public view returns (address) {
527         return TriggmineToken(TOKEN_ADDRESS).getOwner();
528     }
529 
530     function restoreTokenOwnership() public onlyOwner {
531         TriggmineToken(TOKEN_ADDRESS).transferOwnership(ASSET_MANAGER_WALLET);
532     }
533 
534 }
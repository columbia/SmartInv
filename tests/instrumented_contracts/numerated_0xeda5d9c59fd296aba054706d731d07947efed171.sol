1 pragma solidity 0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() {
16         owner = msg.sender;
17     }
18 
19 
20     /**
21      * @dev Throws if called by any account other than the owner.
22      */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) onlyOwner public {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 pragma solidity 0.4.17;
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49     uint256 public totalSupply;
50     function balanceOf(address who) public constant returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 pragma solidity 0.4.17;
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     /**
67     * @dev transfer token for a specified address
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     */
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 pragma solidity 0.4.17;
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100     function allowance(address owner, address spender) public constant returns (uint256);
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102     function approve(address spender, uint256 value) public returns (bool);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 pragma solidity 0.4.17;
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117     mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      *
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
161         return allowed[_owner][_spender];
162     }
163 
164     /**
165      * approve should be called when allowed[_spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      */
170     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
171         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 
176     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
177         uint oldValue = allowed[msg.sender][_spender];
178         if (_subtractedValue > oldValue) {
179             allowed[msg.sender][_spender] = 0;
180         } else {
181             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182         }
183         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186 
187 }
188 
189 pragma solidity 0.4.17;
190 
191 /**
192  * @title Mintable token
193  * @dev Simple ERC20 Token example, with mintable token creation
194  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
195  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
196  */
197 
198 contract MintableToken is StandardToken, Ownable {
199     event Mint(address indexed to, uint256 amount);
200     event MintFinished();
201 
202     bool public mintingFinished = false;
203 
204 
205     modifier canMint() {
206         require(!mintingFinished);
207         _;
208     }
209 
210     /**
211      * @dev Function to mint tokens
212      * @param _to The address that will receive the minted tokens.
213      * @param _amount The amount of tokens to mint.
214      * @return A boolean that indicates if the operation was successful.
215      */
216     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
217         totalSupply = totalSupply.add(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         Mint(_to, _amount);
220         Transfer(address(0), _to, _amount);
221         return true;
222     }
223 
224     /**
225      * @dev Function to stop minting new tokens.
226      * @return True if the operation was successful.
227      */
228     function finishMinting() onlyOwner public returns (bool) {
229         mintingFinished = true;
230         MintFinished();
231         return true;
232     }
233 }
234 
235 pragma solidity 0.4.17;
236 
237 /**
238  * @title SafeMath
239  * @dev Math operations with safety checks that throw on error
240  */
241 library SafeMath {
242     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
243         uint256 c = a * b;
244         assert(a == 0 || c / a == b);
245         return c;
246     }
247 
248     function div(uint256 a, uint256 b) internal constant returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254 
255     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
256         assert(b <= a);
257         return a - b;
258     }
259 
260     function add(uint256 a, uint256 b) internal constant returns (uint256) {
261         uint256 c = a + b;
262         assert(c >= a);
263         return c;
264     }
265 }
266 
267 pragma solidity 0.4.17;
268 
269 /**
270  * @title Crowdsale
271  * @dev Crowdsale is a base contract for managing a token crowdsale.
272  * Crowdsales have a start and end timestamps, where investors can make
273  * token purchases and the crowdsale will assign them tokens based
274  * on a token per ETH rate. Funds collected are forwarded to a wallet
275  * as they arrive.
276  */
277 contract Crowdsale {
278     using SafeMath for uint256;
279 
280     // The token being sold
281     MintableToken public token;
282 
283     // start and end timestamps where investments are allowed (both inclusive)
284     uint256 public startTime;
285     uint256 public endTime;
286 
287     // address where funds are collected
288     address public wallet;
289 
290     // how many token units a buyer gets per wei
291     uint256 public rate;
292 
293     // amount of raised money in wei
294     uint256 public weiRaised;
295 
296     /**
297      * event for token purchase logging
298      * @param purchaser who paid for the tokens
299      * @param beneficiary who got the tokens
300      * @param value weis paid for purchase
301      * @param amount amount of tokens purchased
302      */
303     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
304 
305 
306     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
307         require(_startTime >= now);
308         require(_endTime >= _startTime);
309         require(_rate > 0);
310         require(_wallet != address(0));
311 
312         token = createTokenContract();
313         startTime = _startTime;
314         endTime = _endTime;
315         rate = _rate;
316         wallet = _wallet;
317     }
318 
319     // creates the token to be sold.
320     // override this method to have crowdsale of a specific mintable token.
321     function createTokenContract() internal returns (MintableToken) {
322         return new MintableToken();
323     }
324 
325 
326     // fallback function can be used to buy tokens
327     function () payable {
328         buyTokens(msg.sender);
329     }
330 
331     // low level token purchase function
332     function buyTokens(address beneficiary) public payable {
333         require(beneficiary != address(0));
334         require(validPurchase());
335 
336         uint256 weiAmount = msg.value;
337 
338         // calculate token amount to be created
339         uint256 tokens = weiAmount.mul(rate);
340 
341         // update state
342         weiRaised = weiRaised.add(weiAmount);
343 
344         token.mint(beneficiary, tokens);
345         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
346 
347         forwardFunds();
348     }
349 
350     // send ether to the fund collection wallet
351     // override to create custom fund forwarding mechanisms
352     function forwardFunds() internal {
353         wallet.transfer(msg.value);
354     }
355 
356     // @return true if the transaction can buy tokens
357     function validPurchase() internal constant returns (bool) {
358         bool withinPeriod = now >= startTime && now <= endTime;
359         bool nonZeroPurchase = msg.value != 0;
360         return withinPeriod && nonZeroPurchase;
361     }
362 
363     // @return true if crowdsale event has ended
364     function hasEnded() public constant returns (bool) {
365         return now > endTime;
366     }
367 }
368 
369 pragma solidity 0.4.17;
370 
371 contract BactocoinToken is StandardToken {
372     string public name = 'BactoCoin';
373     uint8 public decimals = 18;
374     string public symbol = 'BTNN';
375     string public version = '1.0.0';
376     uint256 public totalSupply = 4e24 ; // 4 mil
377     address public originalTokenHolder;
378 
379     function BactocoinToken(address allTokensHolder) {
380         originalTokenHolder = allTokensHolder ;
381         balances[allTokensHolder] = totalSupply; // Give the creator all initial tokens
382         Transfer(0x0, allTokensHolder, totalSupply);
383     }
384 
385 }
386 
387 pragma solidity 0.4.17;
388 
389 contract BactocoinCrowdsale is Ownable {
390     using SafeMath for uint256;
391 
392     uint256 public constant startTime = 1513256400; // 14.12.2017 14:00:00 GMT(+1)
393     uint256 public constant endTime = 1514069999; // 23.12.2017, 23:59:59 GMT(+1)
394     uint256 public constant bonusTime = 6000; // in seconds, 100 minutes
395     address public constant wallet = 0xf00d4ec8af332b0a5a9eb24bfce32cf158ab6a4a;
396     uint256 public constant chfCentsPerToken = 2500; // CHF 25.00
397     uint256 public constant chfCentsPerTokenWhileBonus = 1875; // CHF 18.75
398     uint256 public chfCentsPerEth = 60000; // CHF 600,00
399     uint256 public weiRaised;
400 
401 
402     BactocoinToken public token;
403 
404     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
405 
406     function BactocoinCrowdsale() Ownable() {
407 
408         require(startTime >= now);
409         require(endTime >= startTime);
410         require(wallet != address(0));
411 
412         token = new BactocoinToken(this);
413         // we pass address of this contract, as this cont will tranfer funds to buyers
414     }
415 
416     function convertWeiToTokens(uint256 weiAmount) view returns (uint256) {
417         uint256 chfCentsAmount = weiAmount;
418         chfCentsAmount *= chfCentsPerEth;
419         uint256 tokensAmountSatoshi = (chfCentsAmount / (chfCentsPerToken));
420         if (bonusInEffect()) {
421             tokensAmountSatoshi = (chfCentsAmount / (chfCentsPerTokenWhileBonus));
422         }
423         return tokensAmountSatoshi;
424     }
425 
426 
427     // fallback function can be used to buy tokens
428     function () payable {
429         buyTokens(msg.sender);
430     }
431 
432     // low level token purchase function
433     function buyTokens(address beneficiary) public payable {
434         require(beneficiary != address(0));
435         require(validPurchase());
436 
437         uint256 tokensAmountSatoshi = convertWeiToTokens(msg.value);
438 
439         require(tokensAmountSatoshi <= token.balanceOf(this)); // not enough tokens left ?
440         token.transfer(beneficiary, tokensAmountSatoshi);
441         TokenPurchase(msg.sender, beneficiary, msg.value, tokensAmountSatoshi);
442         weiRaised = weiRaised.add(msg.value);
443 
444         forwardFunds();
445     }
446 
447     function updateChfCentsPerEth(uint256 newCents) onlyOwner {
448         chfCentsPerEth = newCents;
449     }
450 
451     // after crowdsale ends this method withdraws all unsold tokens
452     function allocateAllUnsoldTokens(address newOwner) onlyOwner {
453         require(token.balanceOf(this) > 0);
454         require(hasEnded());
455         token.transfer(newOwner, token.balanceOf(this));
456     }
457 
458     // tokens bought with BTC are sent via this method
459     function giveTokens(address newOwner, uint256 amount) onlyOwner {
460         require(token.balanceOf(this) >= amount);
461         token.transfer(newOwner, amount);
462     }
463 
464     // send ether to the fund collection wallet
465     function forwardFunds() internal {
466         wallet.transfer(msg.value);
467     }
468 
469 
470     // @return true if the transaction can buy tokens
471     function validPurchase() internal constant returns (bool) {
472         bool withinPeriod = now >= startTime && now <= endTime;
473         bool nonZeroPurchase = msg.value != 0;
474         return withinPeriod && nonZeroPurchase;
475     }
476 
477     function bonusInEffect() internal constant returns (bool) {
478         bool withinPeriod = now >= startTime && now <= (startTime + bonusTime);
479         return withinPeriod;
480     }
481 
482     // @return true if crowdsale event has ended
483     function hasEnded() public constant returns (bool) {
484         return now > endTime;
485     }
486 
487 }
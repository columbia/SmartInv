1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26     address public owner;
27 
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31 
32     /**
33      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34      * account.
35      */
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 
60 }
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @dev Gets the balance of the specified address.
101     * @param _owner The address to query the the balance of.
102     * @return An uint256 representing the amount owned by the passed address.
103     */
104     function balanceOf(address _owner) public view returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108 }
109 
110 /**
111  * @title Burnable Token
112  * @dev Token that can be irreversibly burned (destroyed).
113  */
114 contract BurnableToken is BasicToken {
115 
116     event Burn(address indexed burner, uint256 value);
117 
118     /**
119      * @dev Burns a specific amount of tokens.
120      * @param _value The amount of token to be burned.
121      */
122     function burn(uint256 _value) public {
123         require(_value <= balances[msg.sender]);
124         // no need to require value <= totalSupply, since that would imply the
125         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
126 
127         address burner = msg.sender;
128         balances[burner] = balances[burner].sub(_value);
129         totalSupply = totalSupply.sub(_value);
130         Burn(burner, _value);
131     }
132 }
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC20Basic {
153     function allowance(address owner, address spender) public view returns (uint256);
154 
155     function transferFrom(address from, address to, uint256 value) public returns (bool);
156 
157     function approve(address spender, uint256 value) public returns (bool);
158 
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172     mapping(address => mapping(address => uint256)) internal allowed;
173 
174 
175     /**
176      * @dev Transfer tokens from one address to another
177      * @param _from address The address which you want to send tokens from
178      * @param _to address The address which you want to transfer to
179      * @param _value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182         require(_to != address(0));
183         require(_value <= balances[_from]);
184         require(_value <= allowed[_from][msg.sender]);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      *
196      * Beware that changing an allowance with this method brings the risk that someone may use both the old
197      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      * @param _spender The address which will spend the funds.
201      * @param _value The amount of tokens to be spent.
202      */
203     function approve(address _spender, uint256 _value) public returns (bool) {
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210      * @dev Function to check the amount of tokens that an owner allowed to a spender.
211      * @param _owner address The address which owns the funds.
212      * @param _spender address The address which will spend the funds.
213      * @return A uint256 specifying the amount of tokens still available for the spender.
214      */
215     function allowance(address _owner, address _spender) public view returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218 
219     /**
220      * @dev Increase the amount of tokens that an owner allowed to a spender.
221      *
222      * approve should be called when allowed[_spender] == 0. To increment
223      * allowed value is better to use this function to avoid 2 calls (and wait until
224      * the first transaction is mined)
225      * From MonolithDAO Token.sol
226      * @param _spender The address which will spend the funds.
227      * @param _addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
230         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
231         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235     /**
236      * @dev Decrease the amount of tokens that an owner allowed to a spender.
237      *
238      * approve should be called when allowed[_spender] == 0. To decrement
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * @param _spender The address which will spend the funds.
243      * @param _subtractedValue The amount of tokens to decrease the allowance by.
244      */
245     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255 
256 }
257 
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
263  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264  */
265 
266 contract MintableToken is StandardToken, Ownable {
267     event Mint(address indexed to, uint256 amount);
268     event MintFinished();
269 
270     bool public mintingFinished = false;
271 
272 
273     modifier canMint() {
274         require(!mintingFinished);
275         _;
276     }
277 
278     /**
279      * @dev Function to mint tokens
280      * @param _to The address that will receive the minted tokens.
281      * @param _amount The amount of tokens to mint.
282      * @return A boolean that indicates if the operation was successful.
283      */
284     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
285         totalSupply = totalSupply.add(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         Mint(_to, _amount);
288         Transfer(address(0), _to, _amount);
289         return true;
290     }
291 
292     /**
293      * @dev Function to stop minting new tokens.
294      * @return True if the operation was successful.
295      */
296     function finishMinting() onlyOwner canMint public returns (bool) {
297         mintingFinished = true;
298         MintFinished();
299         return true;
300     }
301 }
302 
303 /**
304  * @title Capped token
305  * @dev Mintable token with a token cap.
306  */
307 
308 contract CappedToken is MintableToken {
309 
310     uint256 public cap;
311 
312     function CappedToken(uint256 _cap) public {
313         require(_cap > 0);
314         cap = _cap;
315     }
316 
317     /**
318      * @dev Function to mint tokens
319      * @param _to The address that will receive the minted tokens.
320      * @param _amount The amount of tokens to mint.
321      * @return A boolean that indicates if the operation was successful.
322      */
323     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324         require(totalSupply.add(_amount) <= cap);
325 
326         return super.mint(_to, _amount);
327     }
328 
329 }
330 
331 /*
332 * Combination of CappedToken + BurnableToken
333 */
334 contract CappedAndBurnableToken is CappedToken, BurnableToken {
335 
336     function CappedAndBurnableToken(uint256 _cap) public CappedToken(_cap) {
337 
338     }
339 
340 }
341 
342 
343 
344 
345 
346 
347 /**
348  * @title SafeMath
349  * @dev Math operations with safety checks that throw on error
350  */
351 library SafeMath {
352     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
353         if (a == 0) {
354             return 0;
355         }
356         uint256 c = a * b;
357         assert(c / a == b);
358         return c;
359     }
360 
361     function div(uint256 a, uint256 b) internal pure returns (uint256) {
362         // assert(b > 0); // Solidity automatically throws when dividing by 0
363         uint256 c = a / b;
364         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
365         return c;
366     }
367 
368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
369         assert(b <= a);
370         return a - b;
371     }
372 
373     function add(uint256 a, uint256 b) internal pure returns (uint256) {
374         uint256 c = a + b;
375         assert(c >= a);
376         return c;
377     }
378 }
379 
380 /**
381  * @title Crowdsale
382  * @dev Crowdsale is a base contract for managing a token crowdsale.
383  * Crowdsales have a start and end timestamps, where investors can make
384  * token purchases and the crowdsale will assign them tokens based
385  * on a token per ETH rate. Funds collected are forwarded to a wallet
386  * as they arrive.
387  */
388 contract Crowdsale {
389     using SafeMath for uint256;
390 
391     // The token being sold
392     CappedAndBurnableToken public token;
393 
394     // start and end timestamps where investments are allowed (both inclusive)
395     uint256 public startTime;
396     uint256 public endTime;
397 
398     // address where funds are collected
399     address public wallet;
400 
401     // how many token units a buyer gets per wei
402     uint256 public rate;
403 
404     // amount of raised money in wei
405     uint256 public weiRaised;
406 
407     /**
408      * event for token purchase logging
409      * @param purchaser who paid for the tokens
410      * @param beneficiary who got the tokens
411      * @param value weis paid for purchase
412      * @param amount amount of tokens purchased
413      */
414     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
415 
416 
417     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
418         require(_startTime >= now);
419         require(_endTime >= _startTime);
420         require(_rate > 0);
421         require(_wallet != address(0));
422 
423         token = createTokenContract();
424         startTime = _startTime;
425         endTime = _endTime;
426         rate = _rate;
427         wallet = _wallet;
428     }
429 
430     // creates the token to be sold.
431     // override this method to have crowdsale of a specific CappedAndBurnableToken token.
432     function createTokenContract() internal returns (CappedAndBurnableToken) {
433         return new CappedAndBurnableToken(0);
434     }
435 
436 
437     // fallback function can be used to buy tokens
438     function() external payable {
439         buyTokens(msg.sender);
440     }
441 
442     // low level token purchase function
443     function buyTokens(address beneficiary) public payable {
444         require(beneficiary != address(0));
445         require(validPurchase());
446 
447         uint256 weiAmount = msg.value;
448 
449         // calculate token amount to be created
450         uint256 tokens = weiAmount.mul(rate);
451 
452         // update state
453         weiRaised = weiRaised.add(weiAmount);
454 
455         token.mint(beneficiary, tokens);
456         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
457 
458         forwardFunds();
459     }
460 
461     // send ether to the fund collection wallet
462     // override to create custom fund forwarding mechanisms
463     function forwardFunds() internal {
464         wallet.transfer(msg.value);
465     }
466 
467     // @return true if the transaction can buy tokens
468     function validPurchase() internal view returns (bool) {
469         bool withinPeriod = now >= startTime && now <= endTime;
470         bool nonZeroPurchase = msg.value != 0;
471         return withinPeriod && nonZeroPurchase;
472     }
473 
474     // @return true if crowdsale event has ended
475     function hasEnded() public view returns (bool) {
476         return now > endTime;
477     }
478 
479 }
480 
481 
482 
483 
484 contract SudanGoldCoinToken is CappedAndBurnableToken {
485     string public constant name = 'Sudan Gold Coin';
486     string public constant symbol = 'SGC';
487     uint8 public constant decimals = 18;
488     uint256 public constant maxSupply = 20000000 * 10 ** 18;
489 
490     function SudanGoldCoinToken() public CappedAndBurnableToken(maxSupply) {
491 
492     }
493 
494 }
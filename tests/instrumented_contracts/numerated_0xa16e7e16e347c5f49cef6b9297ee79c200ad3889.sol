1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57     function totalSupply() public view returns (uint256);
58     function balanceOf(address who) public view returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public view returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     uint256 totalSupply_;
86 
87     /**
88     * @dev total number of tokens in existence
89     */
90     function totalSupply() public view returns (uint256) {
91         return totalSupply_;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133     /**
134      * @dev Transfer tokens from one address to another
135      * @param _from address The address which you want to send tokens from
136      * @param _to address The address which you want to transfer to
137      * @param _value uint256 the amount of tokens to be transferred
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[_from]);
142         require(_value <= allowed[_from][msg.sender]);
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      *
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param _spender The address which will spend the funds.
159      * @param _value The amount of tokens to be spent.
160      */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param _owner address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address _owner, address _spender) public view returns (uint256) {
174         return allowed[_owner][_spender];
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      *
180      * approve should be called when allowed[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * @param _spender The address which will spend the funds.
185      * @param _addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      *
196      * approve should be called when allowed[_spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * @param _spender The address which will spend the funds.
201      * @param _subtractedValue The amount of tokens to decrease the allowance by.
202      */
203     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204         uint oldValue = allowed[msg.sender][_spender];
205         if (_subtractedValue > oldValue) {
206             allowed[msg.sender][_spender] = 0;
207         } else {
208             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209         }
210         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214 }
215 
216 
217 /**
218  * @title Ownable
219  * @dev The Ownable contract has an owner address, and provides basic authorization control
220  * functions, this simplifies the implementation of "user permissions".
221  */
222 contract Ownable {
223     address public owner;
224 
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228 
229     /**
230      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231      * account.
232      */
233     function Ownable() public {
234         owner = msg.sender;
235     }
236 
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(msg.sender == owner);
242         _;
243     }
244 
245     /**
246      * @dev Allows the current owner to transfer control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function transferOwnership(address newOwner) public onlyOwner {
250         require(newOwner != address(0));
251         OwnershipTransferred(owner, newOwner);
252         owner = newOwner;
253     }
254 
255 }
256 
257 
258 /**
259  * @title Pausable
260  * @dev Base contract which allows children to implement an emergency stop mechanism.
261  */
262 contract Pausable is Ownable {
263     event Pause();
264 
265     event Unpause();
266 
267     bool public paused = false;
268 
269 
270     /**
271      * @dev Modifier to make a function callable only when the contract is not paused.
272      */
273     modifier whenNotPaused() {
274         require(!paused);
275         _;
276     }
277 
278     /**
279      * @dev Modifier to make a function callable only when the contract is paused.db.getCollection('transactions').find({})
280      */
281     modifier whenPaused() {
282         require(paused);
283         _;
284     }
285 
286     /**
287      * @dev called by the owner to pause, triggers stopped state
288      */
289     function pause() onlyOwner whenNotPaused public {
290         paused = true;
291         Pause();
292     }
293 
294     /**
295      * @dev called by the owner to unpause, returns to normal state
296      */
297     function unpause() onlyOwner whenPaused public {
298         paused = false;
299         Unpause();
300     }
301 }
302 
303 contract MintableToken is StandardToken, Ownable, Pausable {
304     event Mint(address indexed to, uint256 amount);
305     event MintFinished();
306 
307     bool public mintingFinished = false;
308     uint256 public constant maxTokensToMint = 1000000000 ether;
309 
310     modifier canMint() {
311         require(!mintingFinished);
312         _;
313     }
314 
315     /**
316     * @dev Function to mint tokens
317     * @param _to The address that will recieve the minted tokens.
318     * @param _amount The amount of tokens to mint.
319     * @return A boolean that indicates if the operation was successful.
320     */
321     function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {
322         return mintInternal(_to, _amount);
323     }
324 
325     /**
326     * @dev Function to stop minting new tokens.
327     * @return True if the operation was successful.
328     */
329     function finishMinting() whenNotPaused onlyOwner returns (bool) {
330         mintingFinished = true;
331         MintFinished();
332         return true;
333     }
334 
335     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
336         require(totalSupply_.add(_amount) <= maxTokensToMint);
337         totalSupply_ = totalSupply_.add(_amount);
338         balances[_to] = balances[_to].add(_amount);
339         Mint(_to, _amount);
340         Transfer(address(0), _to, _amount);
341         return true;
342     }
343 }
344 
345 contract Guidee is MintableToken {
346 
347     string public constant name = "Guidee";
348 
349     string public constant symbol = "GUD";
350 
351     bool public transferEnabled = false;
352 
353     uint8 public constant decimals = 18;
354 
355     bool public preIcoActive = false;
356 
357     bool public preIcoFinished = false;
358 
359     bool public icoActive = false;
360 
361     bool public icoFinished = false;
362 
363     uint256 public rate = 10600;
364 
365     address public approvedUser = 0xe7826F376528EF4014E2b0dE7B480F2cF2f07225;
366 
367     address public wallet = 0x854f51a6996cFC63b0B73dBF9abf6C25082ffb26;
368 
369     uint256 public dateStart = 1521567827;
370 
371     uint256 public tgeDateStart = 1521567827;
372 
373     uint256 public constant maxTokenToBuy = 600000000 ether;
374 
375     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
376 
377 
378     /**
379     * @dev transfer token for a specified address
380     * @param _to The address to transfer to.
381     * @param _value The amount to be transferred.
382     */
383     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
384         require(_to != address(this));
385         return super.transfer(_to, _value);
386     }
387 
388     /**
389     * @dev Transfer tokens from one address to another
390     * @param _from address The address which you want to send tokens from
391     * @param _to address The address which you want to transfer to
392     * @param _value uint256 the amout of tokens to be transfered
393     */
394     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
395         require(_to != address(this));
396         return super.transferFrom(_from, _to, _value);
397     }
398 
399     /**
400      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
401      * @param _spender The address which will spend the funds.
402      * @param _value The amount of tokens to be spent.
403      */
404     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
405         return super.approve(_spender, _value);
406     }
407 
408     /**
409      * @dev Modifier to make a function callable only when the transfer is enabled.
410      */
411     modifier canTransfer() {
412         require(transferEnabled);
413         _;
414     }
415 
416     modifier onlyOwnerOrApproved() {
417         require(msg.sender == owner || msg.sender == approvedUser);
418         _;
419     }
420 
421     /**
422     * @dev Function to stop transfering tokens.
423     * @return True if the operation was successful.
424     */
425     function enableTransfer() onlyOwner returns (bool) {
426         transferEnabled = true;
427         return true;
428     }
429 
430     function startPre() onlyOwner returns (bool) {
431         require(!preIcoActive && !preIcoFinished && !icoActive && !icoFinished);
432         preIcoActive = true;
433         dateStart = block.timestamp;
434         return true;
435     }
436 
437     function finishPre() onlyOwner returns (bool) {
438         require(preIcoActive && !preIcoFinished && !icoActive && !icoFinished);
439         preIcoActive = false;
440         preIcoFinished = true;
441         return true;
442     }
443 
444     function startIco() onlyOwner returns (bool) {
445         require(!preIcoActive && preIcoFinished && !icoActive && !icoFinished);
446         icoActive = true;
447         tgeDateStart = block.timestamp;
448         return true;
449     }
450 
451     function finishIco() onlyOwner returns (bool) {
452         require(!preIcoActive && preIcoFinished && icoActive && !icoFinished);
453         icoActive = false;
454         icoFinished = true;
455         return true;
456     }
457 
458     modifier canBuyTokens() {
459         require(preIcoActive || icoActive);
460         require(block.timestamp >= dateStart);
461         _;
462     }
463 
464     function setApprovedUser(address _user) onlyOwner returns (bool) {
465         require(_user != address(0));
466         approvedUser = _user;
467         return true;
468     }
469 
470 
471     function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {
472         require(_rate > 0);
473         rate = _rate;
474         return true;
475     }
476 
477     function () payable {
478         buyTokens(msg.sender);
479     }
480 
481     function buyTokens(address beneficiary) canBuyTokens whenNotPaused payable {
482         require(beneficiary != 0x0);
483         require(msg.value >= 100 finney);
484 
485         uint256 weiAmount = msg.value;
486 
487         // calculate token amount to be created
488         uint256 tokens = weiAmount.mul(rate);
489 
490         uint8 bonus = 0;
491 
492         if(preIcoActive) {
493             bonus = 25; //25% bonus preIco
494         }
495 
496         if( icoActive && block.timestamp - tgeDateStart <= 1 days){
497             bonus = 15;
498         }
499         if(bonus > 0){
500             tokens += tokens * bonus / 100;    // add bonus
501         }
502 
503         require(totalSupply_.add(tokens) <= maxTokenToBuy);
504 
505         require(mintInternal(beneficiary, tokens));
506 
507         TokenPurchase(msg.sender, beneficiary, tokens);
508 
509     forwardFunds();
510     }
511 
512     // send ether to the fund collection wallet
513     function forwardFunds() internal {
514         wallet.transfer(msg.value);
515     }
516 
517 
518     function changeWallet(address _newWallet) onlyOwner returns (bool) {
519         require(_newWallet != 0x0);
520         wallet = _newWallet;
521         return true;
522     }
523 
524     
525 }
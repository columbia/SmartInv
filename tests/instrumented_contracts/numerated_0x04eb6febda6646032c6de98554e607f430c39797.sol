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
303 
304 contract MintableToken is StandardToken, Ownable, Pausable {
305     event Mint(address indexed to, uint256 amount);
306 
307     event MintFinished();
308 
309     bool public mintingFinished = false;
310 
311     uint256 public constant maxTokensToMint = 1500000000 ether;
312 
313     modifier canMint() {
314         require(!mintingFinished);
315         _;
316     }
317 
318     /**
319     * @dev Function to mint tokens
320     * @param _to The address that will recieve the minted tokens.
321     * @param _amount The amount of tokens to mint.
322     * @return A boolean that indicates if the operation was successful.
323     */
324     function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {
325         return mintInternal(_to, _amount);
326     }
327 
328     /**
329     * @dev Function to stop minting new tokens.
330     * @return True if the operation was successful.
331     */
332     function finishMinting() whenNotPaused onlyOwner returns (bool) {
333         mintingFinished = true;
334         MintFinished();
335         return true;
336     }
337 
338     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
339         require(totalSupply_.add(_amount) <= maxTokensToMint);
340         totalSupply_ = totalSupply_.add(_amount);
341         balances[_to] = balances[_to].add(_amount);
342         Mint(_to, _amount);
343         Transfer(address(0), _to, _amount);
344         return true;
345     }
346 }
347 
348 
349 contract Well is MintableToken {
350 
351     string public constant name = "Token Well";
352 
353     string public constant symbol = "WELL";
354 
355     bool public transferEnabled = false;
356 
357     uint8 public constant decimals = 18;
358 
359     uint256 public rate = 9000;
360 
361     uint256 public constant hardCap = 30000 ether;
362 
363     uint256 public weiFounded = 0;
364 
365     uint256 public icoTokensCount = 0;
366 
367     address public approvedUser = 0x1ca815aBdD308cAf6478d5e80bfc11A6556CE0Ed;
368 
369     address public wallet = 0x1ca815aBdD308cAf6478d5e80bfc11A6556CE0Ed;
370 
371 
372     bool public icoFinished = false;
373 
374     uint256 public constant maxTokenToBuy = 600000000 ether;
375 
376     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
377 
378 
379     /**
380     * @dev transfer token for a specified address
381     * @param _to The address to transfer to.
382     * @param _value The amount to be transferred.
383     */
384     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
385         require(_to != address(this));
386         return super.transfer(_to, _value);
387     }
388 
389     /**
390     * @dev Transfer tokens from one address to another
391     * @param _from address The address which you want to send tokens from
392     * @param _to address The address which you want to transfer to
393     * @param _value uint256 the amout of tokens to be transfered
394     */
395     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
396         require(_to != address(this));
397         return super.transferFrom(_from, _to, _value);
398     }
399 
400     /**
401      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
402      * @param _spender The address which will spend the funds.
403      * @param _value The amount of tokens to be spent.
404      */
405     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
406         return super.approve(_spender, _value);
407     }
408 
409     /**
410      * @dev Modifier to make a function callable only when the transfer is enabled.
411      */
412     modifier canTransfer() {
413         require(transferEnabled);
414         _;
415     }
416 
417     modifier onlyOwnerOrApproved() {
418         require(msg.sender == owner || msg.sender == approvedUser);
419         _;
420     }
421 
422     /**
423     * @dev Function to start transfering tokens.
424     * @return True if the operation was successful.
425     */
426     function enableTransfer() onlyOwner returns (bool) {
427         transferEnabled = true;
428         return true;
429     }
430 
431     function finishIco() onlyOwner returns (bool) {
432         icoFinished = true;
433         icoTokensCount = totalSupply_;
434         return true;
435     }
436 
437     modifier canBuyTokens() {
438         require(!icoFinished && weiFounded.add(msg.value) <= hardCap);
439         _;
440     }
441 
442     function setApprovedUser(address _user) onlyOwner returns (bool) {
443         require(_user != address(0));
444         approvedUser = _user;
445         return true;
446     }
447 
448 
449     function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {
450         require(_rate > 0);
451         rate = _rate;
452         return true;
453     }
454 
455     function() payable {
456         buyTokens(msg.sender);
457     }
458 
459     function buyTokens(address beneficiary) canBuyTokens whenNotPaused payable {
460         require(msg.value != 0);
461         require(beneficiary != 0x0);
462 
463         uint256 weiAmount = msg.value;
464         uint256 bonus = 0;
465 
466         bonus = getBonusByDate();
467 
468         uint256 tokens = weiAmount.mul(rate);
469 
470 
471         if (bonus > 0) {
472             tokens += tokens.mul(bonus).div(100);
473             // add bonus
474         }
475 
476         require(totalSupply_.add(tokens) <= maxTokenToBuy);
477 
478         require(mintInternal(beneficiary, tokens));
479         weiFounded = weiFounded.add(weiAmount);
480         TokenPurchase(msg.sender, beneficiary, tokens);
481         forwardFunds();
482     }
483 
484     // send ether to the fund collection wallet
485     function forwardFunds() internal {
486         wallet.transfer(msg.value);
487     }
488 
489 
490     function changeWallet(address _newWallet) onlyOwner returns (bool) {
491         require(_newWallet != 0x0);
492         wallet = _newWallet;
493         return true;
494     }
495 
496     function getBonusByDate() view returns (uint256){
497         if (block.timestamp < 1514764800) return 0;
498         if (block.timestamp < 1521158400) return 40;
499         if (block.timestamp < 1523836800) return 30;
500         if (block.timestamp < 1523923200) return 25;
501         if (block.timestamp < 1524441600) return 20;
502         if (block.timestamp < 1525046400) return 10;
503         if (block.timestamp < 1525651200) return 5;
504         return 0;
505     }
506 
507 }
1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) constant returns (uint256);
41     function transfer(address to, uint256 value) returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) constant returns (uint256);
51     function transferFrom(address from, address to, uint256 value) returns (bool);
52     function approve(address spender, uint256 value) returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     /**
66     * @dev transfer token for a specified address
67     * @param _to The address to transfer to.
68     * @param _value The amount to be transferred.
69     */
70     function transfer(address _to, uint256 _value) returns (bool) {
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /**
78     * @dev Gets the balance of the specified address.
79     * @param _owner The address to query the the balance of.
80     * @return An uint256 representing the amount owned by the passed address.
81     */
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97     mapping (address => mapping (address => uint256)) allowed;
98 
99 
100     /**
101      * @dev Transfer tokens from one address to another
102      * @param _from address The address which you want to send tokens from
103      * @param _to address The address which you want to transfer to
104      * @param _value uint256 the amout of tokens to be transfered
105      */
106     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107         var _allowance = allowed[_from][msg.sender];
108 
109         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110         // require (_value <= _allowance);
111 
112         balances[_to] = balances[_to].add(_value);
113         balances[_from] = balances[_from].sub(_value);
114         allowed[_from][msg.sender] = _allowance.sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121      * @param _spender The address which will spend the funds.
122      * @param _value The amount of tokens to be spent.
123      */
124     function approve(address _spender, uint256 _value) returns (bool) {
125 
126         // To change the approve amount you first have to reduce the addresses`
127         //  allowance to zero by calling `approve(_spender, 0)` if it is not
128         //  already 0 to mitigate the race condition described here:
129         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifing the amount of tokens still available for the spender.
142      */
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     address public owner;
156 
157 
158     /**
159      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160      * account.
161      */
162     function Ownable() {
163         owner = msg.sender;
164     }
165 
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(msg.sender == owner);
172         _;
173     }
174 
175 
176     /**
177      * @dev Allows the current owner to transfer control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function transferOwnership(address newOwner) onlyOwner {
181         require(newOwner != address(0));
182         owner = newOwner;
183     }
184 
185 }
186 
187 /**
188  * @title Pausable
189  * @dev Base contract which allows children to implement an emergency stop mechanism.
190  */
191 contract Pausable is Ownable {
192     event Pause();
193     event Unpause();
194 
195     bool public paused = false;
196 
197 
198     /**
199      * @dev Modifier to make a function callable only when the contract is not paused.
200      */
201     modifier whenNotPaused() {
202         require(!paused);
203         _;
204     }
205 
206     /**
207      * @dev Modifier to make a function callable only when the contract is paused.
208      */
209     modifier whenPaused() {
210         require(paused);
211         _;
212     }
213 
214     /**
215      * @dev called by the owner to pause, triggers stopped state
216      */
217     function pause() onlyOwner whenNotPaused public {
218         paused = true;
219         Pause();
220     }
221 
222     /**
223      * @dev called by the owner to unpause, returns to normal state
224      */
225     function unpause() onlyOwner whenPaused public {
226         paused = false;
227         Unpause();
228     }
229 }
230 
231 contract MintableToken is StandardToken, Ownable, Pausable {
232     event Mint(address indexed to, uint256 amount);
233     event MintFinished();
234 
235     bool public mintingFinished = false;
236     uint256 public constant maxTokensToMint = 1000000000 ether;
237     uint256 public constant maxTokensToBuy  = 600000000 ether;
238 
239     modifier canMint() {
240         require(!mintingFinished);
241         _;
242     }
243 
244     /**
245     * @dev Function to mint tokens
246     * @param _to The address that will receive the minted tokens.
247     * @param _amount The amount of tokens to mint.
248     * @return A boolean that indicates if the operation was successful.
249     */
250     function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {
251         return mintInternal(_to, _amount);
252     }
253 
254     /**
255     * @dev Function to stop minting new tokens.
256     * @return True if the operation was successful.
257     */
258     function finishMinting() whenNotPaused onlyOwner returns (bool) {
259         mintingFinished = true;
260         MintFinished();
261         return true;
262     }
263 
264     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
265         require(totalSupply.add(_amount) <= maxTokensToMint);
266         totalSupply = totalSupply.add(_amount);
267         balances[_to] = balances[_to].add(_amount);
268         Mint(_to, _amount);
269         Transfer(this, _to, _amount);
270         return true;
271     }
272 }
273 
274 contract Test is MintableToken {
275 
276     string public constant name = "HIH";
277 
278     string public constant symbol = "HIH";
279 
280     bool public preIcoActive = false;
281 
282     bool public preIcoFinished = false;
283 
284     bool public icoActive = false;
285 
286     bool public icoFinished = false;
287 
288     bool public transferEnabled = false;
289 
290     uint8 public constant decimals = 18;
291 
292     uint256 public constant maxPreIcoTokens = 100000000 ether;
293 
294     uint256 public preIcoTokensCount = 0;
295 
296     uint256 public tokensForIco = 600000000 ether;
297 
298     address public wallet = 0xa74fF9130dBfb9E326Ad7FaE2CAFd60e52129CF0;
299 
300     uint256 public dateStart = 1511987870;
301 
302     uint256 public rateBase = 35000;
303 
304     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
305 
306 
307     /**
308     * @dev transfer token for a specified address
309     * @param _to The address to transfer to.
310     * @param _value The amount to be transferred.
311     */
312     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
313         require(_to != address(this) && _to != address(0));
314         return super.transfer(_to, _value);
315     }
316 
317     /**
318     * @dev Transfer tokens from one address to another
319     * @param _from address The address which you want to send tokens from
320     * @param _to address The address which you want to transfer to
321     * @param _value uint256 the amout of tokens to be transfered
322     */
323     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
324         require(_to != address(this) && _to != address(0));
325         return super.transferFrom(_from, _to, _value);
326     }
327 
328     /**
329      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
330      * @param _spender The address which will spend the funds.
331      * @param _value The amount of tokens to be spent.
332      */
333     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
334         return super.approve(_spender, _value);
335     }
336 
337     /**
338      * @dev Modifier to make a function callable only when the transfer is enabled.
339      */
340     modifier canTransfer() {
341         require(transferEnabled);
342         _;
343     }
344 
345     /**
346     * @dev Function to stop transfering tokens.
347     * @return True if the operation was successful.
348     */
349     function enableTransfer() onlyOwner returns (bool) {
350         transferEnabled = true;
351         return true;
352     }
353 
354     function startPre() onlyOwner returns (bool) {
355         require(!preIcoActive && !preIcoFinished && !icoActive && !icoFinished);
356         preIcoActive = true;
357         dateStart = block.timestamp;
358         return true;
359     }
360 
361     function finishPre() onlyOwner returns (bool) {
362         require(preIcoActive && !preIcoFinished && !icoActive && !icoFinished);
363         preIcoActive = false;
364         tokensForIco = maxTokensToBuy.sub(totalSupply);
365         preIcoTokensCount = totalSupply;
366         preIcoFinished = true;
367         return true;
368     }
369 
370     function startIco() onlyOwner returns (bool) {
371         require(!preIcoActive && preIcoFinished && !icoActive && !icoFinished);
372         icoActive = true;
373         return true;
374     }
375 
376     function finishIco() onlyOwner returns (bool) {
377         require(!preIcoActive && preIcoFinished && icoActive && !icoFinished);
378         icoActive = false;
379         icoFinished = true;
380         return true;
381     }
382 
383     modifier canBuyTokens() {
384         require(preIcoActive || icoActive);
385         require(block.timestamp >= dateStart);
386         _;
387     }
388 
389     function () payable {
390         buyTokens(msg.sender);
391     }
392 
393     function buyTokens(address beneficiary) whenNotPaused canBuyTokens payable {
394         require(beneficiary != 0x0);
395         require(msg.value > 0);
396         require(msg.value >= 10 finney);
397 
398         uint256 weiAmount = msg.value;
399         uint256 tokens = 0;
400         if(preIcoActive){
401             tokens = buyPreIcoTokens(weiAmount);
402         }else if(icoActive){
403             tokens = buyIcoTokens(weiAmount);
404         }
405         mintInternal(beneficiary, tokens);
406         forwardFunds();
407 
408     }
409 
410     // send ether to the fund collection wallet
411     function forwardFunds() internal {
412         wallet.transfer(msg.value);
413     }
414 
415     function changeWallet(address _newWallet) onlyOwner returns (bool) {
416         require(_newWallet != 0x0);
417         wallet = _newWallet;
418         return true;
419     }
420 
421     function buyPreIcoTokens(uint256 _weiAmount) internal returns(uint256){
422         uint8 percents = 0;
423 
424         if(block.timestamp - dateStart <= 10 days){
425             percents = 20;
426         }
427 
428         if(block.timestamp - dateStart <= 8 days){
429             percents = 40;
430         }
431 
432         if(block.timestamp - dateStart <= 6 days){
433             percents = 60;
434         }
435 
436         if(block.timestamp - dateStart <= 4 days){
437             percents = 80;
438         }
439 
440         if(block.timestamp - dateStart <= 2 days){  // first week
441             percents = 100;
442         }
443 
444         uint256 tokens = _weiAmount.mul(rateBase).mul(2);
445 
446         if(percents > 0){
447             tokens = tokens.add(tokens.mul(percents).div(100));    // add bonus
448         }
449 
450         require(totalSupply.add(tokens) <= maxPreIcoTokens);
451 
452         return tokens;
453 
454     }
455 
456     function buyIcoTokens(uint256 _weiAmount) internal returns(uint256){
457         uint256 rate = getRate();
458         uint256 tokens = _weiAmount.mul(rate);
459 
460         tokens = tokens.add(tokens.mul(30).div(100));    // add bonus
461 
462         require(totalSupply.add(tokens) <= maxTokensToBuy);
463 
464         return tokens;
465 
466     }
467 
468     function getRate() internal returns(uint256){
469         uint256 rate = rateBase;
470         uint256 step = tokensForIco.div(5);
471 
472 
473         uint8 additionalPercents = 0;
474 
475         if(totalSupply < step){
476             additionalPercents = 0;
477         }else{
478             uint256 currentRound = totalSupply.sub(preIcoTokensCount).div(step);
479 
480             if(currentRound >= 4){
481                 additionalPercents = 30;
482             }
483 
484             if(currentRound >= 3 && currentRound < 4){
485                 additionalPercents = 30;
486             }
487 
488             if(currentRound >= 2&& currentRound < 3){
489                 additionalPercents = 20;
490             }
491 
492             if(currentRound >= 1 && currentRound < 2){
493                 additionalPercents = 10;
494             }
495         }
496 
497         if(additionalPercents > 0){
498             rate -= rateBase.mul(additionalPercents).div(100);    // add bonus
499         }
500 
501         return rate;
502     }
503 
504     function setDateStart(uint256 _dateStart) onlyOwner returns (bool) {
505         require(_dateStart > block.timestamp);
506         dateStart = _dateStart;
507         return true;
508     }
509 
510     function setRate(uint256 _rate) onlyOwner returns (bool) {
511         require(_rate > 0);
512         rateBase = _rate;
513         return true;
514     }
515 
516 }
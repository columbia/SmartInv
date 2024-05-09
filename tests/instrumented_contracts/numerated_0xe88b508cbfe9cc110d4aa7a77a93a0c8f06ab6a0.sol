1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a);
22         return c;
23     }
24 }
25 
26 /**
27  * @title ERC20Basic
28  * @dev Simpler version of ERC20 interface
29  * @dev see https://github.com/ethereum/EIPs/issues/179
30  */
31 contract ERC20Basic {
32     uint256 public totalSupply;
33     function balanceOf(address who) public view returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 /**
39  * @title Basic token
40  * @dev Basic version of StandardToken, with no allowances.
41  */
42 contract BasicToken is ERC20Basic {
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) public balances;
46 
47     /**
48     * @dev transfer token for a specified address
49     * @param _to The address to transfer to.
50     * @param _value The amount to be transferred.
51     */
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         require(_to != address(0));
54         require(_value <= balances[msg.sender]);
55 
56         // SafeMath.sub will throw if there is not enough balance.
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     /**
64     * @dev Gets the balance of the specified address.
65     * @param _owner The address to query the the balance of.
66     * @return An uint256 representing the amount owned by the passed address.
67     */
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public view returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title SafeERC20
86  * @dev Wrappers around ERC20 operations that throw on failure.
87  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
88  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
89  */
90 library SafeERC20 {
91     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
92         assert(token.transfer(to, value));
93     }
94 
95     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
96         assert(token.transferFrom(from, to, value));
97     }
98 
99     function safeApprove(ERC20 token, address spender, uint256 value) internal {
100         assert(token.approve(spender, value));
101     }
102 }
103 
104 /**
105  * @title TokenTimelock
106  * @dev TokenTimelock is a token holder contract that will allow a
107  * beneficiary to extract the tokens after a given release time
108  */
109 contract TokenTimelock {
110   using SafeERC20 for ERC20Basic;
111 
112   // ERC20 basic token contract being held
113   ERC20Basic public token;
114 
115   // beneficiary of tokens after they are released
116   address public beneficiary;
117 
118   // timestamp when token release is enabled
119   uint256 public releaseTime;
120 
121   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
122     // solium-disable-next-line security/no-block-members
123     require(_releaseTime > block.timestamp);
124     token = _token;
125     beneficiary = _beneficiary;
126     releaseTime = _releaseTime;
127   }
128 
129   /**
130    * @notice Transfers tokens held by timelock to beneficiary.
131    */
132   function release() public {
133     // solium-disable-next-line security/no-block-members
134     require(block.timestamp >= releaseTime);
135 
136     uint256 amount = token.balanceOf(this);
137     require(amount > 0);
138 
139     token.safeTransfer(beneficiary, amount);
140   }
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152     mapping (address => mapping (address => uint256)) internal allowed;
153 
154     /**
155      * @dev Transfer tokens from one address to another
156      * @param _from address The address which you want to send tokens from
157      * @param _to address The address which you want to transfer to
158      * @param _value uint256 the amount of tokens to be transferred
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164 
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         emit Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174      *
175      * Beware that changing an allowance with this method brings the risk that someone may use both the old
176      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      * @param _spender The address which will spend the funds.
180      * @param _value The amount of tokens to be spent.
181      */
182     function approve(address _spender, uint256 _value) public returns (bool) {
183         allowed[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner allowed to a spender.
190      * @param _owner address The address which owns the funds.
191      * @param _spender address The address which will spend the funds.
192      * @return A uint256 specifying the amount of tokens still available for the spender.
193      */
194     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
195         return allowed[_owner][_spender];
196     }
197 
198     /**
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      */
204     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
211         uint oldValue = allowed[msg.sender][_spender];
212         if (_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221 }
222 
223 
224 /**
225  * @title Ownable
226  * @dev The Ownable contract has an owner address, and provides basic authorization control
227  * functions, this simplifies the implementation of "user permissions".
228  */
229 contract Ownable {
230   address public owner;
231 
232 
233   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235 
236   /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   function Ownable() public {
241     owner = msg.sender;
242   }
243 
244   /**
245    * @dev Throws if called by any account other than the owner.
246    */
247   modifier onlyOwner() {
248     require(msg.sender == owner);
249     _;
250   }
251 
252   /**
253    * @dev Allows the current owner to transfer control of the contract to a newOwner.
254    * @param newOwner The address to transfer ownership to.
255    */
256   function transferOwnership(address newOwner) public onlyOwner {
257     require(newOwner != address(0));
258     emit OwnershipTransferred(owner, newOwner);
259     owner = newOwner;
260   }
261 }
262 
263 
264 contract EntryToken is StandardToken, Ownable {
265     string public constant name = "Entry Token";
266     string public constant symbol = "ENTRY";
267     uint8 public constant decimals = 18;
268 
269     /// Maximum tokens to be allocated on the sale (55% of the hard cap)
270     uint256 public constant TOKENS_SALE_HARD_CAP = 325000000000000000000000000; // 325000000 * 10**18
271 
272     /// Base exchange rate is set to 1 ETH = 6000 ENTRY.
273     uint256 public constant BASE_RATE = 6000;
274 
275     /// pre sale start 03.05.2018
276     uint256 private constant datePreSaleStart = 1525294800;
277     
278     /// pre sale end time 11.05.2018
279     uint256 private constant datePreSaleEnd = 1525986000;
280 
281     /// sale start time 01.06.2018
282     uint256 private constant dateSaleStart = 1527800400;
283 
284     /// sale end time 01.09.2018
285     uint256 private constant dateSaleEnd = 1535749200;
286 
287     
288     /// pre-sale token cap
289     uint256 private preSaleCap = 75000000000000000000000000; // Pre-sale  75000000 * 10**18
290     
291     /// token caps for each round
292     uint256[25] private stageCaps = [
293         85000000000000000000000000	, // Stage 1   85000000 * 10**18
294         95000000000000000000000000	, // Stage 2   95000000 * 10**18
295         105000000000000000000000000	, // Stage 3   105000000 * 10**18
296         115000000000000000000000000	, // Stage 4   115000000 * 10**18
297         125000000000000000000000000	, // Stage 5   125000000 * 10**18
298         135000000000000000000000000	, // Stage 6   135000000 * 10**18
299         145000000000000000000000000	, // Stage 7   145000000 * 10**18
300         155000000000000000000000000	, // Stage 8   155000000 * 10**18
301         165000000000000000000000000	, // Stage 9   165000000 * 10**18
302         175000000000000000000000000	, // Stage 10   175000000 * 10**18
303         185000000000000000000000000	, // Stage 11   185000000 * 10**18
304         195000000000000000000000000	, // Stage 12   195000000 * 10**18
305         205000000000000000000000000	, // Stage 13   205000000 * 10**18
306         215000000000000000000000000	, // Stage 14   215000000 * 10**18
307         225000000000000000000000000	, // Stage 15   225000000 * 10**18
308         235000000000000000000000000	, // Stage 16   235000000 * 10**18
309         245000000000000000000000000	, // Stage 17   245000000 * 10**18
310         255000000000000000000000000	, // Stage 18   255000000 * 10**18
311         265000000000000000000000000	, // Stage 19   265000000 * 10**18
312         275000000000000000000000000	, // Stage 20   275000000 * 10**18
313         285000000000000000000000000	, // Stage 21   285000000 * 10**18
314         295000000000000000000000000	, // Stage 22   295000000 * 10**18
315         305000000000000000000000000	, // Stage 23   305000000 * 10**18
316         315000000000000000000000000	, // Stage 24   315000000 * 10**18
317         325000000000000000000000000   // Stage 25   325000000 * 10**18
318     ];
319     /// tokens rate for each round
320     uint8[25] private stageRates = [15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 27, 
321                         28, 29, 30, 31, 33, 34, 35, 36, 37, 40, 41, 42, 43, 44];
322 
323     uint64 private constant dateTeamTokensLockedTill = 1630443600;
324    
325     bool public tokenSaleClosed = false;
326 
327     address public timelockContractAddress;
328 
329 
330     function isPreSalePeriod() public constant returns (bool) {
331         if(totalSupply > preSaleCap || now >= datePreSaleEnd) {
332             return false;
333         } else {
334             return now > datePreSaleStart;
335         }
336     }
337 
338 
339     function isICOPeriod() public constant returns (bool) {
340         if (totalSupply > TOKENS_SALE_HARD_CAP || now >= dateSaleEnd){
341             return false;
342         } else {
343             return now > dateSaleStart;
344         }
345     }
346 
347     modifier inProgress {
348         require(totalSupply < TOKENS_SALE_HARD_CAP && !tokenSaleClosed && now >= datePreSaleStart);
349         _;
350     }
351 
352 
353     modifier beforeEnd {
354         require(!tokenSaleClosed);
355         _;
356     }
357 
358 
359     modifier canBeTraded {
360         require(tokenSaleClosed);
361         _;
362     }
363 
364 
365     function EntryToken() public {
366     	/// generate private investor tokens 
367     	generateTokens(owner, 50000000000000000000000000); // 50000000 * 10**18
368     }
369 
370 
371     function () public payable inProgress {
372         if(isPreSalePeriod()){
373             buyPreSaleTokens(msg.sender);
374         } else if (isICOPeriod()){
375             buyTokens(msg.sender);
376         }			
377     } 
378     
379 
380     function buyPreSaleTokens(address _beneficiary) internal {
381         require(msg.value >= 0.01 ether);
382         uint256 tokens = getPreSaleTokenAmount(msg.value);
383         require(totalSupply.add(tokens) <= preSaleCap);
384         generateTokens(_beneficiary, tokens);
385         owner.transfer(address(this).balance);
386     }
387     
388     
389     function buyTokens(address _beneficiary) internal {
390         require(msg.value >= 0.01 ether);
391         uint256 tokens = getTokenAmount(msg.value);
392         require(totalSupply.add(tokens) <= TOKENS_SALE_HARD_CAP);
393         generateTokens(_beneficiary, tokens);
394         owner.transfer(address(this).balance);
395     }
396 
397 
398     function getPreSaleTokenAmount(uint256 weiAmount)internal pure returns (uint256) {
399         return weiAmount.mul(BASE_RATE);
400     }
401     
402     
403     function getTokenAmount(uint256 weiAmount) internal view returns (uint256 tokens) {
404         uint256 tokenBase = weiAmount.mul(BASE_RATE);
405         uint8 stageNumber = currentStageIndex();
406         tokens = getStageTokenAmount(tokenBase, stageNumber);
407         while(tokens.add(totalSupply) > stageCaps[stageNumber] && stageNumber < 24){
408            stageNumber++;
409            tokens = getStageTokenAmount(tokenBase, stageNumber);
410         }
411     }
412     
413     
414     function getStageTokenAmount(uint256 tokenBase, uint8 stageNumber)internal view returns (uint256) {
415     	uint256 rate = 10000000000000000000/stageRates[stageNumber];
416     	uint256 base = tokenBase/1000000000000000000;
417         return base.mul(rate);
418     }
419     
420     
421     function currentStageIndex() internal view returns (uint8 stageNumber) {
422         stageNumber = 0;
423         while(stageNumber < 24 && totalSupply > stageCaps[stageNumber]) {
424             stageNumber++;
425         }
426     }
427     
428     
429     function buyTokensOnInvestorBehalf(address _beneficiary, uint256 _tokens) public onlyOwner beforeEnd {
430         generateTokens(_beneficiary, _tokens);
431     }
432     
433     
434     function buyTokensOnInvestorBehalfBatch(address[] _addresses, uint256[] _tokens) public onlyOwner beforeEnd {
435         require(_addresses.length == _tokens.length);
436         require(_addresses.length <= 100);
437 
438         for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {
439             generateTokens(_addresses[i], _tokens[i]);
440         }
441     }
442     
443     
444     function generateTokens(address _beneficiary, uint256 _tokens) internal {
445         require(_beneficiary != address(0));
446         totalSupply = totalSupply.add(_tokens);
447         balances[_beneficiary] = balances[_beneficiary].add(_tokens);
448         emit Transfer(address(0), _beneficiary, _tokens);
449     }
450 
451 
452     function close() public onlyOwner beforeEnd {
453         /// team tokens are equal to 20% of tokens
454         uint256 lockedTokens = 118000000000000000000000000; // 118 000 000 * 10**18
455         // partner tokens for advisors, bouties, SCO 25% of tokens
456         uint256 partnerTokens = 147000000000000000000000000; // 147 000 0000 * 10**18
457         // unsold tokens 
458         uint256 unsoldTokens = TOKENS_SALE_HARD_CAP.sub(totalSupply);
459         
460         generateLockedTokens(lockedTokens);
461         generatePartnerTokens(partnerTokens);
462         generateUnsoldTokens(unsoldTokens);
463         
464         totalSupply = totalSupply.add(lockedTokens+partnerTokens+unsoldTokens);
465 
466         tokenSaleClosed = true;
467 
468         owner.transfer(address(this).balance);
469     }
470     
471     function generateLockedTokens(uint lockedTokens) internal{
472         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, dateTeamTokensLockedTill);
473         timelockContractAddress = address(lockedTeamTokens);
474         balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);
475         emit Transfer(address(0), timelockContractAddress, lockedTokens);
476     }
477 
478     function generatePartnerTokens(uint partnerTokens) internal{
479         balances[owner] = balances[owner].add(partnerTokens);
480         emit Transfer(address(0), owner, partnerTokens);
481     }
482 
483     function generateUnsoldTokens(uint unsoldTokens) internal{
484         balances[owner] = balances[owner].add(unsoldTokens);
485         emit Transfer(address(0), owner, unsoldTokens);
486     }
487     
488     function transferFrom(address _from, address _to, uint256 _value) public canBeTraded returns (bool) {
489         return super.transferFrom(_from, _to, _value);
490     }
491 
492 
493     function transfer(address _to, uint256 _value) public canBeTraded returns (bool) {
494         return super.transfer(_to, _value);
495     }
496 }
1 pragma solidity ^0.4.18;
2 
3 // File: src/Token/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: src/Token/OracleOwnable.sol
46 
47 contract OracleOwnable is Ownable {
48 
49     address public oracle;
50 
51     modifier onlyOracle() {
52         require(msg.sender == oracle);
53         _;
54     }
55 
56     modifier onlyOracleOrOwner() {
57         require(msg.sender == oracle || msg.sender == owner);
58         _;
59     }
60 
61     function setOracle(address newOracle) public onlyOracleOrOwner {
62         if (newOracle != address(0)) {
63             oracle = newOracle;
64         }
65 
66     }
67 
68 }
69 
70 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     if (a == 0) {
83       return 0;
84     }
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   uint256 totalSupply_;
144 
145   /**
146   * @dev total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return totalSupply_;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[msg.sender]);
160 
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public view returns (uint256) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
179 
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * @dev https://github.com/ethereum/EIPs/issues/20
198  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
212     require(_to != address(0));
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    *
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(address _owner, address _spender) public view returns (uint256) {
246     return allowed[_owner][_spender];
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _addedValue The amount of tokens to increase the allowance by.
258    */
259   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
260     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To decrement
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _subtractedValue The amount of tokens to decrease the allowance by.
274    */
275   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
276     uint oldValue = allowed[msg.sender][_spender];
277     if (_subtractedValue > oldValue) {
278       allowed[msg.sender][_spender] = 0;
279     } else {
280       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281     }
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286 }
287 
288 // File: src/Token/MintableToken.sol
289 
290 /**
291  * @title Mintable token
292  * @dev Simple ERC20 Token example, with mintable token creation
293  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
294  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
295  */
296 contract MintableToken is StandardToken, OracleOwnable {
297     event Mint(address indexed to, uint256 amount);
298     event MintFinished();
299 
300     bool public mintingFinished = false;
301 
302 
303     modifier canMint() {
304         require(!mintingFinished);
305         _;
306     }
307 
308     /**
309      * @dev Function to mint tokens
310      * @param _to The address that will receive the minted tokens.
311      * @param _amount The amount of tokens to mint.
312      * @return A boolean that indicates if the operation was successful.
313      */
314     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
315         totalSupply_ = totalSupply_.add(_amount);
316         balances[_to] = balances[_to].add(_amount);
317         Mint(_to, _amount);
318         Transfer(address(0), _to, _amount);
319         return true;
320     }
321 
322     /**
323      * @dev Function to stop minting new tokens.
324      * @return True if the operation was successful.
325      */
326     function finishMinting() onlyOwner canMint public returns (bool) {
327         mintingFinished = true;
328         MintFinished();
329         return true;
330     }
331 }
332 
333 // File: src/Token/ReleasableToken.sol
334 
335 contract ReleasableToken is MintableToken {
336     bool public released = false;
337 
338     event Release();
339     event Burn(address, uint);
340 
341     modifier isReleased () {
342         require(mintingFinished);
343         require(released);
344         _;
345     }
346 
347     function release() public onlyOwner returns (bool) {
348         require(mintingFinished);
349         require(!released);
350         released = true;
351         Release();
352 
353         return true;
354     }
355 
356     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
357         return super.transfer(_to, _value);
358     }
359 
360     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
361         return super.transferFrom(_from, _to, _value);
362     }
363 
364     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
365         return super.approve(_spender, _value);
366     }
367 
368     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
369         return super.increaseApproval(_spender, _addedValue);
370     }
371 
372     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
373         return super.decreaseApproval(_spender, _subtractedValue);
374     }
375 
376     function burn(address _to, uint _amount) public onlyOwner {
377         totalSupply_ = totalSupply_.sub(_amount);
378         balances[_to] = balances[_to].sub(_amount);
379         Burn(_to, _amount);
380     }
381 }
382 
383 // File: src/Token/StageVestingToken.sol
384 
385 contract StageVestingToken is ReleasableToken {
386     uint256 public stageCount;
387     uint256 public stage;
388     bool public isCheckStage;
389 
390     mapping(uint => mapping(address => uint256)) internal stageVesting;
391 
392     function StageVestingToken () public{
393         stageCount = 4;
394         stage = 0;
395         isCheckStage = true;
396     }
397 
398     function setStage(uint256 _stage) public onlyOracleOrOwner {
399         stage = _stage;
400     }
401 
402     function setStageCount(uint256 _stageCount) public onlyOracleOrOwner {
403         stageCount = _stageCount;
404     }
405 
406     function setIsCheckStage(bool _isCheckStage) public onlyOracleOrOwner {
407         isCheckStage = _isCheckStage;
408     }
409 
410     function getHolderLimit(address _holder) view public returns (uint256){
411         return stageVesting[stage][_holder];
412     }
413 
414     function canUseTokens(address _holder, uint256 _amount) view internal returns (bool){
415         if (!isCheckStage) {
416             return true;
417         }
418         return (getHolderLimit(_holder) >= _amount);
419     }
420 
421     function addOnOneStage(address _to, uint256 _amount, uint256 _stage) internal {
422         require(_stage < stageCount);
423         stageVesting[_stage][_to] = stageVesting[_stage][_to].add(_amount);
424     }
425 
426     function subOnOneStage(address _to, uint256 _amount, uint256 _stage) internal {
427         require(_stage < stageCount);
428         if (stageVesting[_stage][_to] >= _amount) {
429             stageVesting[_stage][_to] = stageVesting[_stage][_to].sub(_amount);
430         } else {
431             stageVesting[_stage][_to] = 0;
432         }
433     }
434 
435     function addOnStage(address _to, uint256 _amount) internal returns (bool){
436         return addOnStage(_to, _amount, stage);
437     }
438 
439     function addOnStage(address _to, uint256 _amount, uint256 _stage) internal returns (bool){
440         if (!isCheckStage) {
441             return true;
442         }
443         for (uint256 i = _stage; i < stageCount; i++) {
444             addOnOneStage(_to, _amount, i);
445         }
446         return true;
447     }
448 
449     function subOnStage(address _to, uint256 _amount) internal returns (bool){
450         return subOnStage(_to, _amount, stage);
451     }
452 
453     function subOnStage(address _to, uint256 _amount, uint256 _stage) internal returns (bool){
454         if (!isCheckStage) {
455             return true;
456         }
457 
458         for (uint256 i = _stage; i < stageCount; i++) {
459             subOnOneStage(_to, _amount, i);
460         }
461         return true;
462     }
463 
464     function mint(address _to, uint256 _amount, uint256 _stage) onlyOwner canMint public returns (bool) {
465         super.mint(_to, _amount);
466         addOnStage(_to, _amount, _stage);
467     }
468 
469     function burn(address _to, uint _amount, uint256 _stage) public onlyOwner canMint{
470         super.burn(_to, _amount);
471         subOnStage(_to, _amount, _stage);
472     }
473 
474     function transfer(address _to, uint256 _value) public returns (bool) {
475         require(canUseTokens(msg.sender, _value));
476         require(subOnStage(msg.sender, _value));
477         require(addOnStage(_to, _value));
478         return super.transfer(_to, _value);
479     }
480 
481     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
482         require(canUseTokens(_from, _value));
483         require(subOnStage(_from, _value));
484         require(addOnStage(_to, _value));
485         return super.transferFrom(_from, _to, _value);
486     }
487 }
488 
489 // File: src/Token/MetabaseToken.sol
490 
491 contract MetabaseToken is StageVestingToken {
492 
493     string public constant name = "METABASE";
494     string public constant symbol = "MBT";
495     uint256 public constant decimals = 18;
496 
497 }
498 
499 // File: src/Store/MetabaseCrowdSale.sol
500 
501 contract MetabaseCrowdSale is OracleOwnable {
502     using SafeMath for uint;
503 
504     MetabaseToken token;
505 
506     event Transaction(address indexed beneficiary, string currency, uint currencyAmount, uint rate, uint tokenAmount, uint stage, bool isNegative);
507 
508 
509     address[] currencyInvestors;
510     mapping(address => bool) currencyInvestorsAddresses;
511 
512     function setToken(address _token) public onlyOracleOrOwner {
513         token = MetabaseToken(_token);
514     }
515 
516     function addInvestorIfNotExists(address _beneficiary) internal {
517         if (!currencyInvestorsAddresses[_beneficiary]) {
518             currencyInvestors.push(_beneficiary);
519         }
520     }
521 
522     function buy(address _beneficiary, string _currency, uint _currencyAmount, uint _rate, uint _tokenAmount, uint _stage) public onlyOracleOrOwner {
523         addInvestorIfNotExists(_beneficiary);
524 
525         token.mint(_beneficiary, _tokenAmount, _stage);
526 
527         Transaction(_beneficiary, _currency, _currencyAmount, _rate, _tokenAmount, _stage, false);
528     }
529 
530     function refund(address _beneficiary, string _currency, uint _currencyAmount, uint _tokenAmount, uint _stage) public onlyOracleOrOwner {
531         addInvestorIfNotExists(_beneficiary);
532 
533         token.burn(_beneficiary, _tokenAmount, _stage);
534 
535         Transaction(_beneficiary, _currency, _currencyAmount, 0, _tokenAmount, _stage, true);
536     }
537 
538     function tokenTransferOwnership(address _owner) onlyOracleOrOwner public {
539         token.transferOwnership(_owner);
540     }
541 }
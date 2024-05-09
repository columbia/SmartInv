1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50     /**
51     * @dev Multiplies two numbers, throws on overflow.
52     */
53     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         if (a == 0) {
55             return 0;
56         }
57         c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers, truncating the quotient.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // assert(b > 0); // Solidity automatically throws when dividing by 0
67         // uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69         return a / b;
70     }
71 
72     /**
73     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     /**
81     * @dev Adds two numbers, throws on overflow.
82     */
83     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84         c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97     function totalSupply() public view returns (uint256);
98 
99     function balanceOf(address who) public view returns (uint256);
100 
101     function transfer(address to, uint256 value) public returns (bool);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114     using SafeMath for uint256;
115 
116     mapping(address => uint256) balances;
117 
118     uint256 totalSupply_;
119 
120     /**
121     * @dev total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return totalSupply_;
125     }
126 
127     /**
128     * @dev transfer token for a specified address
129     * @param _to The address to transfer to.
130     * @param _value The amount to be transferred.
131     */
132     function transfer(address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[msg.sender]);
135 
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     /**
143     * @dev Gets the balance of the specified address.
144     * @param _owner The address to query the the balance of.
145     * @return An uint256 representing the amount owned by the passed address.
146     */
147     function balanceOf(address _owner) public view returns (uint256) {
148         return balances[_owner];
149     }
150 
151 }
152 
153 
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160     function allowance(address owner, address spender) public view returns (uint256);
161 
162     function transferFrom(address from, address to, uint256 value) public returns (bool);
163 
164     function approve(address spender, uint256 value) public returns (bool);
165 
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179 
180     mapping(address => mapping(address => uint256)) internal allowed;
181 
182 
183     /**
184      * @dev Transfer tokens from one address to another
185      * @param _from address The address which you want to send tokens from
186      * @param _to address The address which you want to transfer to
187      * @param _value uint256 the amount of tokens to be transferred
188      */
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192 
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194         return true;
195     }
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199      *
200      * Beware that changing an allowance with this method brings the risk that someone may use both the old
201      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      * @param _spender The address which will spend the funds.
205      * @param _value The amount of tokens to be spent.
206      */
207     function approve(address _spender, uint256 _value) public returns (bool) {
208         allowed[msg.sender][_spender] = _value;
209         emit Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     /**
214      * @dev Function to check the amount of tokens that an owner allowed to a spender.
215      * @param _owner address The address which owns the funds.
216      * @param _spender address The address which will spend the funds.
217      * @return A uint256 specifying the amount of tokens still available for the spender.
218      */
219     function allowance(address _owner, address _spender) public view returns (uint256) {
220         return allowed[_owner][_spender];
221     }
222 
223     /**
224      * @dev Increase the amount of tokens that an owner allowed to a spender.
225      *
226      * approve should be called when allowed[_spender] == 0. To increment
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * @param _spender The address which will spend the funds.
231      * @param _addedValue The amount of tokens to increase the allowance by.
232      */
233     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 
239     /**
240      * @dev Decrease the amount of tokens that an owner allowed to a spender.
241      *
242      * approve should be called when allowed[_spender] == 0. To decrement
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * @param _spender The address which will spend the funds.
247      * @param _subtractedValue The amount of tokens to decrease the allowance by.
248      */
249     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250         uint oldValue = allowed[msg.sender][_spender];
251         if (_subtractedValue > oldValue) {
252             allowed[msg.sender][_spender] = 0;
253         } else {
254             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255         }
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260 }
261 
262 
263 /// @title   Token
264 /// @author  Jose Perez - <jose.perez@diginex.com>
265 /// @notice  ERC20 token
266 /// @dev     The contract allows to perform a number of token sales in different periods in time.
267 ///          allowing participants in previous token sales to transfer tokens to other accounts.
268 ///          Additionally, token locking logic for KYC/AML compliance checking is supported.
269 
270 contract Token is StandardToken, Ownable {
271     using SafeMath for uint256;
272 
273     string public constant name = "ZGB";
274     string public constant symbol = "ZGB";
275     uint256 public constant decimals = 9;
276 
277     // Using same number of decimal figures as ETH (i.e. 18).
278     uint256 public constant TOKEN_UNIT = 10 ** uint256(decimals);
279 
280     // Maximum number of tokens in circulation
281     uint256 public constant MAX_TOKEN_SUPPLY = 10000000000 * TOKEN_UNIT;
282 
283     // Maximum size of the batch functions input arrays.
284     uint256 public constant MAX_BATCH_SIZE = 400;
285 
286     address public assigner;    // The address allowed to assign or mint tokens during token sale.
287     address public locker;      // The address allowed to lock/unlock addresses.
288 
289     mapping(address => bool) public locked;        // If true, address' tokens cannot be transferred.
290 
291     mapping(address => TxRecord[]) public txRecordPerAddress;
292 
293     mapping(address => uint) public chainStartIdxPerAddress;
294     mapping(address => uint) public chainEndIdxPerAddress;
295 
296     struct TxRecord {
297         uint amount;
298         uint releaseTime;
299         uint nextIdx;
300         uint prevIdx;
301     }
302 
303     event Lock(address indexed addr);
304     event Unlock(address indexed addr);
305     event Assign(address indexed to, uint256 amount);
306     event LockerTransferred(address indexed previousLocker, address indexed newLocker);
307     event AssignerTransferred(address indexed previousAssigner, address indexed newAssigner);
308 
309     /// @dev Constructor that initializes the contract.
310     /// @param _assigner The assigner account.
311     /// @param _locker The locker account.
312     constructor(address _assigner, address _locker) public {
313         require(_assigner != address(0));
314         require(_locker != address(0));
315 
316         assigner = _assigner;
317         locker = _locker;
318 
319         balances[_assigner] = balances[_assigner].add(MAX_TOKEN_SUPPLY);
320         recop(_assigner, MAX_TOKEN_SUPPLY, 0);
321         
322         totalSupply_ = MAX_TOKEN_SUPPLY;
323     }
324 
325     /// @dev Throws if called by any account other than the assigner.
326     modifier onlyAssigner() {
327         require(msg.sender == assigner);
328         _;
329     }
330 
331     /// @dev Throws if called by any account other than the locker.
332     modifier onlyLocker() {
333         require(msg.sender == locker);
334         _;
335     }
336 
337 
338     /// @dev Allows the current owner to change the locker.
339     /// @param _newLocker The address of the new locker.
340     /// @return True if the operation was successful.
341     function transferLocker(address _newLocker) external onlyOwner returns (bool) {
342         require(_newLocker != address(0));
343 
344         emit LockerTransferred(locker, _newLocker);
345         locker = _newLocker;
346         return true;
347     }
348 
349     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
350     ///      Only addresses participating in the current token sale can be locked.
351     ///      Only the locker account can lock addresses and only during the token sale.
352     /// @param _address address The address to lock.
353     /// @return True if the operation was successful.
354     function lockAddress(address _address) public onlyLocker returns (bool) {
355         require(!locked[_address]);
356 
357         locked[_address] = true;
358         emit Lock(_address);
359         return true;
360     }
361 
362     /// @dev Unlocks an address so that its owner can transfer tokens out again.
363     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
364     /// @param _address address The address to unlock.
365     /// @return True if the operation was successful.
366     function unlockAddress(address _address) public onlyLocker returns (bool) {
367         require(locked[_address]);
368 
369         locked[_address] = false;
370         emit Unlock(_address);
371         return true;
372     }
373 
374     /// @dev Locks several addresses in one single call.
375     /// @param _addresses address[] The addresses to lock.
376     /// @return True if the operation was successful.
377     function lockInBatches(address[] _addresses) external onlyLocker returns (bool) {
378         require(_addresses.length > 0);
379         require(_addresses.length <= MAX_BATCH_SIZE);
380 
381         for (uint i = 0; i < _addresses.length; i++) {
382             lockAddress(_addresses[i]);
383         }
384         return true;
385     }
386 
387     /// @dev Unlocks several addresses in one single call.
388     /// @param _addresses address[] The addresses to unlock.
389     /// @return True if the operation was successful.
390     function unlockInBatches(address[] _addresses) external onlyLocker returns (bool) {
391         require(_addresses.length > 0);
392         require(_addresses.length <= MAX_BATCH_SIZE);
393 
394         for (uint i = 0; i < _addresses.length; i++) {
395             unlockAddress(_addresses[i]);
396         }
397         return true;
398     }
399 
400     /// @dev Checks whether or not the given address is locked.
401     /// @param _address address The address to be checked.
402     /// @return Boolean indicating whether or not the address is locked.
403     function isLocked(address _address) external view returns (bool) {
404         return locked[_address];
405     }
406 
407     function transfer(address _to, uint256 _value) public returns (bool) {
408         return transferL(_to, _value, 0);
409     }
410 
411 
412     function transferL(address _to, uint256 _value, uint256 lTime) public returns (bool) {
413         require(!locked[msg.sender]);
414         require(_to != address(0));
415         return transferFT(msg.sender, _to, _value, lTime);
416     }
417 
418     function getamount(address addr, uint256 index) public view returns (uint) {
419         return txRecordPerAddress[addr][index].amount;
420     }
421 
422     function payop(address _from, uint needTakeout) private {
423         for (uint idx = chainStartIdxPerAddress[_from]; true; idx = txRecordPerAddress[_from][idx].nextIdx) {
424             TxRecord memory txRecord = txRecordPerAddress[_from][idx];
425             if (now < txRecord.releaseTime)
426                 break;
427             if (txRecord.amount <= needTakeout) {
428                 chainStartIdxPerAddress[_from] = txRecordPerAddress[_from][idx].nextIdx;
429                 delete txRecordPerAddress[_from][idx];
430                 needTakeout = needTakeout.sub(txRecord.amount);
431             } else {
432                 txRecordPerAddress[_from][idx].amount = txRecordPerAddress[_from][idx].amount.sub(needTakeout);
433                 needTakeout = 0;
434             }
435             if (idx == chainEndIdxPerAddress[_from]) {
436                 break;
437             }
438         }
439 //        验证支出方余额是否足够
440         require(needTakeout == 0);
441     }
442 
443     function recop22(address _to){
444         txRecordPerAddress[_to].push(TxRecord({amount : 100, releaseTime : now.add(0), nextIdx : 0, prevIdx : 0}));
445         uint a = txRecordPerAddress[_to].length - 1;
446     }
447 
448     function recop(address _to, uint256 _value, uint256 lTime) private {
449         if (txRecordPerAddress[_to].length < 1) {
450             txRecordPerAddress[_to].push(TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0}));
451             chainStartIdxPerAddress[_to] = 0;
452             chainEndIdxPerAddress[_to] = 0;
453             return;
454         }
455         uint startIndex = chainStartIdxPerAddress[_to];
456         if (lTime == 0 && txRecordPerAddress[_to][startIndex].releaseTime < now) {
457             txRecordPerAddress[_to][startIndex].amount = txRecordPerAddress[_to][startIndex].amount.add(_value);
458             return;
459         }
460         TxRecord memory utxo = TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0});
461         for (uint idx = startIndex; true; idx = txRecordPerAddress[_to][idx].nextIdx) {
462             if (utxo.releaseTime < txRecordPerAddress[_to][idx].releaseTime) {
463                 if (idx == chainEndIdxPerAddress[_to]) {
464                     utxo.prevIdx = idx;
465                     txRecordPerAddress[_to].push(utxo);
466                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
467                     chainEndIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
468                     return;
469                 } else if (utxo.releaseTime >= txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].releaseTime) {
470                     utxo.prevIdx = idx;
471                     utxo.nextIdx = txRecordPerAddress[_to][idx].nextIdx;
472                     txRecordPerAddress[_to].push(utxo);
473                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
474                     txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].prevIdx  = txRecordPerAddress[_to].length - 1;
475                     return;
476                 }
477             } else {
478                 if (idx == startIndex) {
479                     utxo.nextIdx = idx;
480                     txRecordPerAddress[_to].push(utxo);
481                     txRecordPerAddress[_to][idx].prevIdx = txRecordPerAddress[_to].length - 1;
482                     chainStartIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
483                     return;
484                 }
485             }
486             if (idx == chainEndIdxPerAddress[_to]) {
487                 return;
488             }
489         }
490     }
491 
492     function hp(address _to) private {
493         uint len = txRecordPerAddress[_to].length;
494         for (uint k = 2; k <= 5 && k <= len; k++) {
495             uint index = len - k;
496             if (now > txRecordPerAddress[_to][index].releaseTime) {
497                 txRecordPerAddress[_to][index].amount = txRecordPerAddress[_to][index].amount.add(txRecordPerAddress[_to][index + 1].amount);
498                 delete txRecordPerAddress[_to][index + 1];
499                 txRecordPerAddress[_to].length--;
500             } else {
501                 break;
502             }
503         }
504     }
505 
506     function transferFT(address _from, address _to, uint256 _value, uint256 lTime) private returns (bool) {
507         //支出方账户操作
508         payop(_from, _value);
509         balances[_from] = balances[_from].sub(_value);
510 
511         //合并
512         // hp(_to);
513 
514         //收入方账户操作
515         recop(_to, _value, lTime);
516         balances[_to] = balances[_to].add(_value);
517 
518         emit Transfer(_from, _to, _value);
519         return true;
520     }
521 
522     function txRecordCount(address add) public view returns (uint){
523         return txRecordPerAddress[add].length;
524     }
525 
526     function getnow() public view returns (uint){
527         return now;
528     }
529 
530     function getChain(address add) public view returns (uint[]){
531         uint[] a;
532         for (uint idx = chainStartIdxPerAddress[add]; true; idx = txRecordPerAddress[add][idx].nextIdx) {
533             a.push(txRecordPerAddress[add][idx].amount);
534             if (idx == chainEndIdxPerAddress[add]) {
535                 break;
536             }
537         }
538         return a;
539     }
540 
541 
542     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
543     ///      if the allowed address is locked.
544     ///      Locked addresses can receive tokens.
545     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
546     /// @param _from address The address to transfer tokens from.
547     /// @param _to address The address to transfer tokens to.
548     /// @param _value The number of tokens to be transferred.
549     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
550         require(!locked[msg.sender]);
551         require(!locked[_from]);
552         require(_to != address(0));
553         super.transferFrom(_from, _to, _value);
554         return transferFT(_from, _to, _value, 0);
555     }
556 }
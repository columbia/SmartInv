1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address internal owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
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
41     function isOwner() public view returns (bool) {
42         return msg.sender == owner;
43     }
44 
45 }
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54     /**
55     * @dev Multiplies two numbers, throws on overflow.
56     */
57     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
58         if (a == 0) {
59             return 0;
60         }
61         c = a * b;
62         assert(c / a == b);
63         return c;
64     }
65 
66     /**
67     * @dev Integer division of two numbers, truncating the quotient.
68     */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // assert(b > 0); // Solidity automatically throws when dividing by 0
71         // uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73         return a / b;
74     }
75 
76     /**
77     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         assert(b <= a);
81         return a - b;
82     }
83 
84     /**
85     * @dev Adds two numbers, throws on overflow.
86     */
87     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
88         c = a + b;
89         assert(c >= a);
90         return c;
91     }
92 }
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101     function totalSupply() public view returns (uint256);
102 
103     function balanceOf(address who) public view returns (uint256);
104 
105     function transfer(address to, uint256 value) public returns (bool);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 
111 
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118     using SafeMath for uint256;
119 
120     mapping(address => uint256) balances;
121 
122     uint256 totalSupply_;
123 
124     /**
125     * @dev total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130 
131     /**
132     * @dev transfer token for a specified address
133     * @param _to The address to transfer to.
134     * @param _value The amount to be transferred.
135     */
136     function transfer(address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139 
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         emit Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     /**
147     * @dev Gets the balance of the specified address.
148     * @param _owner The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function balanceOf(address _owner) public view returns (uint256) {
152         return balances[_owner];
153     }
154 
155 }
156 
157 
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164     function allowance(address owner, address spender) public view returns (uint256);
165 
166     function transferFrom(address from, address to, uint256 value) public returns (bool);
167 
168     function approve(address spender, uint256 value) public returns (bool);
169 
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * @dev https://github.com/ethereum/EIPs/issues/20
180  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract StandardToken is ERC20, BasicToken {
183 
184     mapping(address => mapping(address => uint256)) internal allowed;
185 
186 
187     /**
188      * @dev Transfer tokens from one address to another
189      * @param _from address The address which you want to send tokens from
190      * @param _to address The address which you want to transfer to
191      * @param _value uint256 the amount of tokens to be transferred
192      */
193     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
194         require(_value <= balances[_from]);
195         require(_value <= allowed[_from][msg.sender]);
196 
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         return true;
199     }
200 
201     /**
202      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203      *
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param _spender The address which will spend the funds.
209      * @param _value The amount of tokens to be spent.
210      */
211     function approve(address _spender, uint256 _value) public returns (bool) {
212         allowed[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218      * @dev Function to check the amount of tokens that an owner allowed to a spender.
219      * @param _owner address The address which owns the funds.
220      * @param _spender address The address which will spend the funds.
221      * @return A uint256 specifying the amount of tokens still available for the spender.
222      */
223     function allowance(address _owner, address _spender) public view returns (uint256) {
224         return allowed[_owner][_spender];
225     }
226 
227     /**
228      * @dev Increase the amount of tokens that an owner allowed to a spender.
229      *
230      * approve should be called when allowed[_spender] == 0. To increment
231      * allowed value is better to use this function to avoid 2 calls (and wait until
232      * the first transaction is mined)
233      * From MonolithDAO Token.sol
234      * @param _spender The address which will spend the funds.
235      * @param _addedValue The amount of tokens to increase the allowance by.
236      */
237     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
238         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      *
246      * approve should be called when allowed[_spender] == 0. To decrement
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * @param _spender The address which will spend the funds.
251      * @param _subtractedValue The amount of tokens to decrease the allowance by.
252      */
253     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254         uint oldValue = allowed[msg.sender][_spender];
255         if (_subtractedValue > oldValue) {
256             allowed[msg.sender][_spender] = 0;
257         } else {
258             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259         }
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264 }
265 
266 
267 /// @title   Token
268 /// @author  Jose Perez - <jose.perez@diginex.com>
269 /// @notice  ERC20 token
270 /// @dev     The contract allows to perform a number of token sales in different periods in time.
271 ///          allowing participants in previous token sales to transfer tokens to other accounts.
272 ///          Additionally, token locking logic for KYC/AML compliance checking is supported.
273 
274 contract Token is StandardToken, Ownable {
275     using SafeMath for uint256;
276 
277     string public constant name = "EGB";
278     string public constant symbol = "EGB";
279     uint256 public constant decimals = 9;
280 
281     // Using same number of decimal figures as ETH (i.e. 18).
282     uint256 public constant TOKEN_UNIT = 10 ** uint256(decimals);
283 
284     // Maximum number of tokens in circulation
285     uint256 public constant MAX_TOKEN_SUPPLY = 1000000000 * TOKEN_UNIT;
286 
287     // Maximum size of the batch functions input arrays.
288     uint256 public constant MAX_BATCH_SIZE = 400;
289 
290 //    address public assigner;    // The address allowed to assign or mint tokens during token sale.
291     address public locker;      // The address allowed to lock/unlock addresses.
292 
293     mapping(address => bool) public locked;        // If true, address' tokens cannot be transferred.
294     mapping(address => bool) public alwLockTx;
295 
296     mapping(address => TxRecord[]) public txRecordPerAddress;
297 
298     mapping(address => uint) public chainStartIdxPerAddress;
299     mapping(address => uint) public chainEndIdxPerAddress;
300 
301     struct TxRecord {
302         uint amount;
303         uint releaseTime;
304         uint nextIdx;
305         uint prevIdx;
306     }
307 
308     event Lock(address indexed addr);
309     event Unlock(address indexed addr);
310     event Assign(address indexed to, uint256 amount);
311     event LockerTransferred(address indexed previousLocker, address indexed newLocker);
312 //    event AssignerTransferred(address indexed previousAssigner, address indexed newAssigner);
313 
314     /// @dev Constructor that initializes the contract.
315     constructor() public {
316         locker = owner;
317         balances[owner] = balances[owner].add(MAX_TOKEN_SUPPLY);
318         recop(owner, MAX_TOKEN_SUPPLY, 0);
319         totalSupply_ = MAX_TOKEN_SUPPLY;
320         alwLT(owner, true);
321     }
322 
323     /// @dev Throws if called by any account other than the locker.
324     modifier onlyLocker() {
325         require(msg.sender == locker);
326         _;
327     }
328 
329     function isLocker() public view returns (bool) {
330         return msg.sender == locker;
331     }
332 
333 
334     /// @dev Allows the current owner to change the locker.
335     /// @param _newLocker The address of the new locker.
336     /// @return True if the operation was successful.
337     function transferLocker(address _newLocker) external onlyOwner returns (bool) {
338         require(_newLocker != address(0));
339 
340         emit LockerTransferred(locker, _newLocker);
341         locker = _newLocker;
342         return true;
343     }
344 
345     function alwLT(address _address, bool _enable) public onlyLocker returns (bool) {
346         alwLockTx[_address] = _enable;
347         return true;
348     }
349 
350     function alwLTBatches(address[] _addresses, bool _enable) external onlyLocker returns (bool) {
351         require(_addresses.length > 0);
352         require(_addresses.length <= MAX_BATCH_SIZE);
353 
354         for (uint i = 0; i < _addresses.length; i++) {
355             alwLT(_addresses[i], _enable);
356         }
357         return true;
358     }
359 
360     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
361     ///      Only addresses participating in the current token sale can be locked.
362     ///      Only the locker account can lock addresses and only during the token sale.
363     /// @param _address address The address to lock.
364     /// @return True if the operation was successful.
365     function lockAddress(address _address) public onlyLocker returns (bool) {
366         require(!locked[_address]);
367 
368         locked[_address] = true;
369         emit Lock(_address);
370         return true;
371     }
372 
373     /// @dev Unlocks an address so that its owner can transfer tokens out again.
374     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
375     /// @param _address address The address to unlock.
376     /// @return True if the operation was successful.
377     function unlockAddress(address _address) public onlyLocker returns (bool) {
378         require(locked[_address]);
379 
380         locked[_address] = false;
381         emit Unlock(_address);
382         return true;
383     }
384 
385     /// @dev Locks several addresses in one single call.
386     /// @param _addresses address[] The addresses to lock.
387     /// @return True if the operation was successful.
388     function lockInBatches(address[] _addresses) external onlyLocker returns (bool) {
389         require(_addresses.length > 0);
390         require(_addresses.length <= MAX_BATCH_SIZE);
391 
392         for (uint i = 0; i < _addresses.length; i++) {
393             lockAddress(_addresses[i]);
394         }
395         return true;
396     }
397 
398     /// @dev Unlocks several addresses in one single call.
399     /// @param _addresses address[] The addresses to unlock.
400     /// @return True if the operation was successful.
401     function unlockInBatches(address[] _addresses) external onlyLocker returns (bool) {
402         require(_addresses.length > 0);
403         require(_addresses.length <= MAX_BATCH_SIZE);
404 
405         for (uint i = 0; i < _addresses.length; i++) {
406             unlockAddress(_addresses[i]);
407         }
408         return true;
409     }
410 
411     /// @dev Checks whether or not the given address is locked.
412     /// @param _address address The address to be checked.
413     /// @return Boolean indicating whether or not the address is locked.
414     function isLocked(address _address) external view returns (bool) {
415         return locked[_address];
416     }
417 
418     function transfer(address _to, uint256 _value) public returns (bool) {
419         require(!locked[msg.sender]);
420         require(_to != address(0));
421         return transferFT(msg.sender, _to, _value, 0);
422     }
423 
424     function transferL(address _to, uint256 _value, uint256 lTime) public returns (bool) {
425         require(alwLockTx[msg.sender]);
426         require(!locked[msg.sender]);
427         require(_to != address(0));
428         return transferFT(msg.sender, _to, _value, lTime);
429     }
430 
431     function getRecordInfo(address addr, uint256 index) external onlyOwner view returns (uint, uint, uint, uint) {
432         TxRecord memory tr = txRecordPerAddress[addr][index];
433         return (tr.amount, tr.prevIdx, tr.nextIdx, tr.releaseTime);
434     }
435 
436     function delr(address _address, uint256 index) public onlyOwner returns (bool) {
437         require(index < txRecordPerAddress[_address].length);
438         TxRecord memory tr = txRecordPerAddress[_address][index];
439         if (index == chainStartIdxPerAddress[_address]) {
440             chainStartIdxPerAddress[_address] = tr.nextIdx;
441         } else if (index == chainEndIdxPerAddress[_address]) {
442             chainEndIdxPerAddress[_address] = tr.prevIdx;
443         } else {
444             txRecordPerAddress[_address][tr.prevIdx].nextIdx = tr.nextIdx;
445             txRecordPerAddress[_address][tr.nextIdx].prevIdx = tr.prevIdx;
446         }
447         delete txRecordPerAddress[_address][index];
448         balances[_address] = balances[_address].sub(tr.amount);
449         return true;
450     }
451 
452     function resetTime(address _address, uint256 index, uint256 lTime) external onlyOwner returns (bool) {
453         require(index < txRecordPerAddress[_address].length);
454         TxRecord memory tr = txRecordPerAddress[_address][index];
455         delr(_address, index);
456         recop(_address, tr.amount, lTime);
457         balances[_address] = balances[_address].add(tr.amount);
458         return true;
459     }
460 
461     function payop(address _from, uint needTakeout) private {
462         TxRecord memory txRecord;
463         for (uint idx = chainEndIdxPerAddress[_from]; true; idx = txRecord.prevIdx) {
464             txRecord = txRecordPerAddress[_from][idx];
465             if (now < txRecord.releaseTime)
466                 break;
467             if (txRecord.amount <= needTakeout) {
468                 chainEndIdxPerAddress[_from] = txRecord.prevIdx;
469                 delete txRecordPerAddress[_from][idx];
470                 needTakeout = needTakeout.sub(txRecord.amount);
471             } else {
472                 txRecordPerAddress[_from][idx].amount = txRecord.amount.sub(needTakeout);
473                 needTakeout = 0;
474                 break;
475             }
476             if (idx == chainStartIdxPerAddress[_from]) {
477                 break;
478             }
479         }
480         require(needTakeout == 0);
481     }
482 
483     function recop(address _to, uint256 _value, uint256 lTime) private {
484         if (txRecordPerAddress[_to].length < 1) {
485             txRecordPerAddress[_to].push(TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0}));
486             chainStartIdxPerAddress[_to] = 0;
487             chainEndIdxPerAddress[_to] = 0;
488             return;
489         }
490         uint startIndex = chainStartIdxPerAddress[_to];
491         uint endIndex = chainEndIdxPerAddress[_to];
492         if (lTime == 0 && txRecordPerAddress[_to][endIndex].releaseTime < now) {
493             txRecordPerAddress[_to][endIndex].amount = txRecordPerAddress[_to][endIndex].amount.add(_value);
494             return;
495         }
496         TxRecord memory utxo = TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0});
497         for (uint idx = startIndex; true; idx = txRecordPerAddress[_to][idx].nextIdx) {
498             if (utxo.releaseTime < txRecordPerAddress[_to][idx].releaseTime) {
499                 if (idx == chainEndIdxPerAddress[_to]) {
500                     utxo.prevIdx = idx;
501                     txRecordPerAddress[_to].push(utxo);
502                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
503                     chainEndIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
504                     return;
505                 } else if (utxo.releaseTime >= txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].releaseTime) {
506                     utxo.prevIdx = idx;
507                     utxo.nextIdx = txRecordPerAddress[_to][idx].nextIdx;
508                     txRecordPerAddress[_to].push(utxo);
509                     txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].prevIdx = txRecordPerAddress[_to].length - 1;
510                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
511                     return;
512                 }
513             } else {
514                 if (idx == startIndex) {
515                     utxo.nextIdx = idx;
516                     txRecordPerAddress[_to].push(utxo);
517                     txRecordPerAddress[_to][idx].prevIdx = txRecordPerAddress[_to].length - 1;
518                     chainStartIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
519                     return;
520                 }
521             }
522             if (idx == chainEndIdxPerAddress[_to]) {
523                 return;
524             }
525         }
526     }
527 
528     function transferFT(address _from, address _to, uint256 _value, uint256 lTime) private returns (bool) {
529         payop(_from, _value);
530         balances[_from] = balances[_from].sub(_value);
531 
532         recop(_to, _value, lTime);
533         balances[_to] = balances[_to].add(_value);
534 
535         emit Transfer(_from, _to, _value);
536         return true;
537     }
538 
539     function txRecordCount(address add) public onlyOwner view returns (uint){
540         return txRecordPerAddress[add].length;
541     }
542 
543 
544     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
545     ///      if the allowed address is locked.
546     ///      Locked addresses can receive tokens.
547     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
548     /// @param _from address The address to transfer tokens from.
549     /// @param _to address The address to transfer tokens to.
550     /// @param _value The number of tokens to be transferred.
551     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
552         require(!locked[msg.sender]);
553         require(!locked[_from]);
554         require(_to != address(0));
555         require(_from != _to);
556         super.transferFrom(_from, _to, _value);
557         return transferFT(_from, _to, _value, 0);
558     }
559 
560     function kill() onlyOwner {
561         selfdestruct(owner);
562     }
563 }
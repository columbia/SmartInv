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
273     string public constant name = "TSX";
274     string public constant symbol = "TSX";
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
310     /// @param _locker The locker account.
311     constructor(address _locker) public {
312         require(_locker != address(0));
313 
314         locker = _locker;
315 
316         balances[owner] = balances[owner].add(MAX_TOKEN_SUPPLY);
317         recop(owner, MAX_TOKEN_SUPPLY, 0);
318 
319         totalSupply_ = MAX_TOKEN_SUPPLY;
320     }
321 
322     /// @dev Throws if called by any account other than the locker.
323     modifier onlyLocker() {
324         require(msg.sender == locker);
325         _;
326     }
327 
328 
329     /// @dev Allows the current owner to change the locker.
330     /// @param _newLocker The address of the new locker.
331     /// @return True if the operation was successful.
332     function transferLocker(address _newLocker) external onlyOwner returns (bool) {
333         require(_newLocker != address(0));
334 
335         emit LockerTransferred(locker, _newLocker);
336         locker = _newLocker;
337         return true;
338     }
339 
340     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
341     ///      Only addresses participating in the current token sale can be locked.
342     ///      Only the locker account can lock addresses and only during the token sale.
343     /// @param _address address The address to lock.
344     /// @return True if the operation was successful.
345     function lockAddress(address _address) public onlyLocker returns (bool) {
346         require(!locked[_address]);
347 
348         locked[_address] = true;
349         emit Lock(_address);
350         return true;
351     }
352 
353     /// @dev Unlocks an address so that its owner can transfer tokens out again.
354     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
355     /// @param _address address The address to unlock.
356     /// @return True if the operation was successful.
357     function unlockAddress(address _address) public onlyLocker returns (bool) {
358         require(locked[_address]);
359 
360         locked[_address] = false;
361         emit Unlock(_address);
362         return true;
363     }
364 
365     /// @dev Locks several addresses in one single call.
366     /// @param _addresses address[] The addresses to lock.
367     /// @return True if the operation was successful.
368     function lockInBatches(address[] _addresses) external onlyLocker returns (bool) {
369         require(_addresses.length > 0);
370         require(_addresses.length <= MAX_BATCH_SIZE);
371 
372         for (uint i = 0; i < _addresses.length; i++) {
373             lockAddress(_addresses[i]);
374         }
375         return true;
376     }
377 
378     /// @dev Unlocks several addresses in one single call.
379     /// @param _addresses address[] The addresses to unlock.
380     /// @return True if the operation was successful.
381     function unlockInBatches(address[] _addresses) external onlyLocker returns (bool) {
382         require(_addresses.length > 0);
383         require(_addresses.length <= MAX_BATCH_SIZE);
384 
385         for (uint i = 0; i < _addresses.length; i++) {
386             unlockAddress(_addresses[i]);
387         }
388         return true;
389     }
390 
391     /// @dev Checks whether or not the given address is locked.
392     /// @param _address address The address to be checked.
393     /// @return Boolean indicating whether or not the address is locked.
394     function isLocked(address _address) external view returns (bool) {
395         return locked[_address];
396     }
397 
398     function transfer(address _to, uint256 _value) public returns (bool) {
399         return transferL(_to, _value, 0);
400     }
401 
402 
403     function transferL(address _to, uint256 _value, uint256 lTime) public returns (bool) {
404         require(!locked[msg.sender]);
405         require(_to != address(0));
406         return transferFT(msg.sender, _to, _value, lTime);
407     }
408 
409     function getamount(address addr, uint256 index) public view returns (uint) {
410         return txRecordPerAddress[addr][index].amount;
411     }
412 
413     function payop(address _from, uint needTakeout) private {
414         TxRecord memory txRecord;
415         for (uint idx = chainEndIdxPerAddress[_from]; true; idx = txRecord.prevIdx) {
416             txRecord = txRecordPerAddress[_from][idx];
417             if (now < txRecord.releaseTime)
418                 break;
419             if (txRecord.amount <= needTakeout) {
420                 chainEndIdxPerAddress[_from] = txRecord.prevIdx;
421                 delete txRecordPerAddress[_from][idx];
422                 needTakeout = needTakeout.sub(txRecord.amount);
423             } else {
424                 txRecordPerAddress[_from][idx].amount = txRecord.amount.sub(needTakeout);
425                 needTakeout = 0;
426                 break;
427             }
428             if (idx == chainStartIdxPerAddress[_from]) {
429                 break;
430             }
431         }
432         require(needTakeout == 0);
433     }
434 
435     function recop(address _to, uint256 _value, uint256 lTime) private {
436         if (txRecordPerAddress[_to].length < 1) {
437             txRecordPerAddress[_to].push(TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0}));
438             chainStartIdxPerAddress[_to] = 0;
439             chainEndIdxPerAddress[_to] = 0;
440             return;
441         }
442         uint endIndex = chainEndIdxPerAddress[_to];
443         if (lTime == 0 && txRecordPerAddress[_to][endIndex].releaseTime < now) {
444             txRecordPerAddress[_to][endIndex].amount = txRecordPerAddress[_to][endIndex].amount.add(_value);
445             return;
446         }
447         TxRecord memory utxo = TxRecord({amount : _value, releaseTime : now.add(lTime), nextIdx : 0, prevIdx : 0});
448         for (uint idx = endIndex; true; idx = txRecordPerAddress[_to][idx].nextIdx) {
449             if (utxo.releaseTime < txRecordPerAddress[_to][idx].releaseTime) {
450                 if (idx == chainEndIdxPerAddress[_to]) {
451                     utxo.prevIdx = idx;
452                     txRecordPerAddress[_to].push(utxo);
453                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
454                     chainEndIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
455                     return;
456                 } else if (utxo.releaseTime >= txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].releaseTime) {
457                     utxo.prevIdx = idx;
458                     utxo.nextIdx = txRecordPerAddress[_to][idx].nextIdx;
459                     txRecordPerAddress[_to].push(utxo);
460                     txRecordPerAddress[_to][idx].nextIdx = txRecordPerAddress[_to].length - 1;
461                     txRecordPerAddress[_to][txRecordPerAddress[_to][idx].nextIdx].prevIdx = txRecordPerAddress[_to].length - 1;
462                     return;
463                 }
464             } else {
465                 if (idx == endIndex) {
466                     utxo.nextIdx = idx;
467                     txRecordPerAddress[_to].push(utxo);
468                     txRecordPerAddress[_to][idx].prevIdx = txRecordPerAddress[_to].length - 1;
469                     chainStartIdxPerAddress[_to] = txRecordPerAddress[_to].length - 1;
470                     return;
471                 }
472             }
473             if (idx == chainEndIdxPerAddress[_to]) {
474                 return;
475             }
476         }
477     }
478 
479     function transferFT(address _from, address _to, uint256 _value, uint256 lTime) private returns (bool) {
480         require(_to != address(0));
481         require(_from != _to);
482 
483         payop(_from, _value);
484         balances[_from] = balances[_from].sub(_value);
485 
486         recop(_to, _value, lTime);
487         balances[_to] = balances[_to].add(_value);
488 
489         emit Transfer(_from, _to, _value);
490         return true;
491     }
492 
493     function txRecordCount(address add) public view returns (uint){
494         return txRecordPerAddress[add].length;
495     }
496 
497 
498     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
499     ///      if the allowed address is locked.
500     ///      Locked addresses can receive tokens.
501     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
502     /// @param _from address The address to transfer tokens from.
503     /// @param _to address The address to transfer tokens to.
504     /// @param _value The number of tokens to be transferred.
505     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
506         require(!locked[msg.sender]);
507         require(!locked[_from]);
508         require(_to != address(0));
509         super.transferFrom(_from, _to, _value);
510         return transferFT(_from, _to, _value, 0);
511     }
512 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     // assert(_b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = _a / _b;
93     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 contract Constants {
128     uint public constant RESELLING_LOCK_UP_PERIOD = 210 days;
129     uint public constant RESELLING_UNLOCK_COUNT = 10;
130 }
131 
132 contract CardioCoin is ERC20Basic, Ownable, Constants {
133     using SafeMath for uint256;
134 
135     uint public constant UNLOCK_PERIOD = 30 days;
136 
137     string public name = "CardioCoin";
138     string public symbol = "CRDC";
139 
140     uint8 public decimals = 18;
141     uint256 internal totalSupply_ = 50000000000 * (10 ** uint256(decimals));
142 
143     mapping (address => uint256) internal reselling;
144     uint256 internal resellingAmount = 0;
145 
146     struct locker {
147         bool isLocker;
148         string role;
149         uint lockUpPeriod;
150         uint unlockCount;
151     }
152 
153     mapping (address => locker) internal lockerList;
154 
155     event AddToLocker(address owner, uint lockUpPeriod, uint unlockCount);
156 
157     event ResellingAdded(address seller, uint256 amount);
158     event ResellingSubtracted(address seller, uint256 amount);
159     event Reselled(address seller, address buyer, uint256 amount);
160 
161     event TokenLocked(address owner, uint256 amount);
162     event TokenUnlocked(address owner, uint256 amount);
163 
164     constructor() public Ownable() {
165         balance memory b;
166 
167         b.available = totalSupply_;
168         balances[msg.sender] = b;
169     }
170 
171     function addLockedUpTokens(address _owner, uint256 amount, uint lockUpPeriod, uint unlockCount)
172     internal {
173         balance storage b = balances[_owner];
174         lockUp memory l;
175 
176         l.amount = amount;
177         l.unlockTimestamp = now + lockUpPeriod;
178         l.unlockCount = unlockCount;
179         b.lockedUp += amount;
180         b.lockUpData[b.lockUpCount] = l;
181         b.lockUpCount += 1;
182         emit TokenLocked(_owner, amount);
183     }
184 
185     function addResellingAmount(address seller, uint256 amount)
186     public
187     onlyOwner
188     {
189         require(seller != address(0));
190         require(amount > 0);
191         require(balances[seller].available >= amount);
192 
193         reselling[seller] = reselling[seller].add(amount);
194         balances[seller].available = balances[seller].available.sub(amount);
195         resellingAmount = resellingAmount.add(amount);
196         emit ResellingAdded(seller, amount);
197     }
198 
199     function subtractResellingAmount(address seller, uint256 _amount)
200     public
201     onlyOwner
202     {
203         uint256 amount = reselling[seller];
204 
205         require(seller != address(0));
206         require(_amount > 0);
207         require(amount >= _amount);
208 
209         reselling[seller] = reselling[seller].sub(_amount);
210         resellingAmount = resellingAmount.sub(_amount);
211         balances[seller].available = balances[seller].available.add(_amount);
212         emit ResellingSubtracted(seller, _amount);
213     }
214 
215     function cancelReselling(address seller)
216     public
217     onlyOwner {
218         uint256 amount = reselling[seller];
219 
220         require(seller != address(0));
221         require(amount > 0);
222 
223         subtractResellingAmount(seller, amount);
224     }
225 
226     function resell(address seller, address buyer, uint256 amount)
227     public
228     onlyOwner
229     returns (bool)
230     {
231         require(seller != address(0));
232         require(buyer != address(0));
233         require(amount > 0);
234         require(reselling[seller] >= amount);
235         require(balances[owner].available >= amount);
236 
237         reselling[seller] = reselling[seller].sub(amount);
238         resellingAmount = resellingAmount.sub(amount);
239         addLockedUpTokens(buyer, amount, RESELLING_LOCK_UP_PERIOD, RESELLING_UNLOCK_COUNT);
240         emit Reselled(seller, buyer, amount);
241 
242         return true;
243     }
244 
245     struct lockUp {
246         uint256 amount;
247         uint unlockTimestamp;
248         uint unlockedCount;
249         uint unlockCount;
250     }
251 
252     struct balance {
253         uint256 available;
254         uint256 lockedUp;
255         mapping (uint => lockUp) lockUpData;
256         uint lockUpCount;
257         uint unlockIndex;
258     }
259 
260     mapping(address => balance) internal balances;
261 
262     function unlockBalance(address _owner) internal {
263         balance storage b = balances[_owner];
264 
265         if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {
266             for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {
267                 lockUp storage l = b.lockUpData[i];
268 
269                 if (l.unlockTimestamp <= now) {
270                     uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);
271                     uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);
272 
273                     if (unlockedAmount > b.lockedUp) {
274                         unlockedAmount = b.lockedUp;
275                         l.unlockedCount = l.unlockCount;
276                     } else {
277                         b.available = b.available.add(unlockedAmount);
278                         b.lockedUp = b.lockedUp.sub(unlockedAmount);
279                         l.unlockedCount += count;
280                     }
281                     emit TokenUnlocked(_owner, unlockedAmount);
282                     if (l.unlockedCount == l.unlockCount) {
283                         lockUp memory tempA = b.lockUpData[i];
284                         lockUp memory tempB = b.lockUpData[b.unlockIndex];
285 
286                         b.lockUpData[i] = tempB;
287                         b.lockUpData[b.unlockIndex] = tempA;
288                         b.unlockIndex += 1;
289                     } else {
290                         l.unlockTimestamp += UNLOCK_PERIOD * count;
291                     }
292                 }
293             }
294         }
295     }
296 
297     function calculateUnlockCount(uint timestamp, uint unlockedCount, uint unlockCount) view internal returns (uint) {
298         uint count = 0;
299         uint nowFixed = now;
300 
301         while (timestamp < nowFixed && unlockedCount + count < unlockCount) {
302             count++;
303             timestamp += UNLOCK_PERIOD;
304         }
305 
306         return count;
307     }
308 
309     function totalSupply() public view returns (uint256) {
310         return totalSupply_;
311     }
312 
313     function transfer(address _to, uint256 _value)
314     public
315     returns (bool) {
316         unlockBalance(msg.sender);
317 
318         locker storage l = lockerList[msg.sender];
319 
320         if (l.isLocker) {
321             require(_value <= balances[msg.sender].available);
322             require(_to != address(0));
323 
324             balances[msg.sender].available = balances[msg.sender].available.sub(_value);
325             addLockedUpTokens(_to, _value, l.lockUpPeriod, l.unlockCount);
326         } else {
327             require(_value <= balances[msg.sender].available);
328             require(_to != address(0));
329 
330             balances[msg.sender].available = balances[msg.sender].available.sub(_value);
331             balances[_to].available = balances[_to].available.add(_value);
332         }
333         emit Transfer(msg.sender, _to, _value);
334 
335         return true;
336     }
337 
338     function balanceOf(address _owner) public view returns (uint256) {
339         return balances[_owner].available.add(balances[_owner].lockedUp);
340     }
341 
342     function lockedUpBalanceOf(address _owner) public view returns (uint256) {
343         balance storage b = balances[_owner];
344         uint256 lockedUpBalance = b.lockedUp;
345 
346         if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {
347             for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {
348                 lockUp storage l = b.lockUpData[i];
349 
350                 if (l.unlockTimestamp <= now) {
351                     uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);
352                     uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);
353 
354                     if (unlockedAmount > lockedUpBalance) {
355                         lockedUpBalance = 0;
356                         break;
357                     } else {
358                         lockedUpBalance = lockedUpBalance.sub(unlockedAmount);
359                     }
360                 }
361             }
362         }
363 
364         return lockedUpBalance;
365     }
366 
367     function resellingBalanceOf(address _owner) public view returns (uint256) {
368         return reselling[_owner];
369     }
370 
371     function transferWithLockUp(address _to, uint256 _value, uint lockUpPeriod, uint unlockCount)
372     public
373     onlyOwner
374     returns (bool) {
375         require(_value <= balances[owner].available);
376         require(_to != address(0));
377 
378         balances[owner].available = balances[owner].available.sub(_value);
379         addLockedUpTokens(_to, _value, lockUpPeriod, unlockCount);
380         emit Transfer(msg.sender, _to, _value);
381 
382         return true;
383     }
384 
385     event Burn(address indexed burner, uint256 value);
386 
387     function burn(uint256 _value) public {
388         _burn(msg.sender, _value);
389     }
390 
391     function _burn(address _who, uint256 _value) internal {
392         require(_value <= balances[_who].available);
393 
394         balances[_who].available = balances[_who].available.sub(_value);
395         totalSupply_ = totalSupply_.sub(_value);
396         emit Burn(_who, _value);
397         emit Transfer(_who, address(0), _value);
398     }
399 
400     function addAddressToLockerList(address _operator, string role, uint lockUpPeriod, uint unlockCount)
401     public
402     onlyOwner {
403         locker storage existsLocker = lockerList[_operator];
404 
405         require(!existsLocker.isLocker);
406 
407         locker memory l;
408 
409         l.isLocker = true;
410         l.role = role;
411         l.lockUpPeriod = lockUpPeriod;
412         l.unlockCount = unlockCount;
413         lockerList[_operator] = l;
414         emit AddToLocker(_operator, lockUpPeriod, unlockCount);
415     }
416 
417     function lockerRole(address _operator) public view returns (string) {
418         return lockerList[_operator].role;
419     }
420 
421     function lockerLockUpPeriod(address _operator) public view returns (uint) {
422         return lockerList[_operator].lockUpPeriod;
423     }
424 
425     function lockerUnlockCount(address _operator) public view returns (uint) {
426         return lockerList[_operator].unlockCount;
427     }
428 }
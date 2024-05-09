1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         c = _a * _b;
17         assert(c / _a == _b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         // assert(_b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = _a / _b;
27         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28         return _a / _b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35         assert(_b <= _a);
36         return _a - _b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43         c = _a + _b;
44         assert(c >= _a);
45         return c;
46     }
47 }
48 
49 contract ArrayTools {
50 
51     function _combineArray(uint256[] _array) internal pure returns(uint256) {
52         uint256 fullAmount;
53         for(uint256 i = 0; i < _array.length; i++) {
54             require(_array[i] > 0);
55             fullAmount += _array[i];
56         }
57         return fullAmount;
58     }
59 }
60 
61 contract IQDAO {
62     function balanceOf(address _owner) public view returns (uint256);
63     function approveForOtherContracts(address _sender, address _spender, uint256 _value) external;
64     function transfer(address _to, uint256 _value) public returns (bool);
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
66 }
67 
68 contract Ownable {
69     address public owner;
70 
71 
72     event OwnershipRenounced(address indexed previousOwner);
73     event OwnershipTransferred(
74         address indexed previousOwner,
75         address indexed newOwner
76     );
77 
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     /**
96      * @dev Allows the current owner to relinquish control of the contract.
97      * @notice Renouncing to ownership will leave the contract without an owner.
98      * It will not be possible to call the functions with the `onlyOwner`
99      * modifier anymore.
100      */
101     function renounceOwnership() public onlyOwner {
102         emit OwnershipRenounced(owner);
103         owner = address(0);
104     }
105 
106     /**
107      * @dev Allows the current owner to transfer control of the contract to a newOwner.
108      * @param _newOwner The address to transfer ownership to.
109      */
110     function transferOwnership(address _newOwner) public onlyOwner {
111         _transferOwnership(_newOwner);
112     }
113 
114     /**
115      * @dev Transfers control of the contract to a newOwner.
116      * @param _newOwner The address to transfer ownership to.
117      */
118     function _transferOwnership(address _newOwner) internal {
119         require(_newOwner != address(0));
120         emit OwnershipTransferred(owner, _newOwner);
121         owner = _newOwner;
122     }
123 }
124 
125 contract WhitelistMigratable is Ownable {
126 
127     mapping(address => bool) public governanceContracts;
128 
129     event GovernanceContractAdded(address addr);
130     event GovernanceContractRemoved(address addr);
131 
132     modifier onlyGovernanceContracts() {
133         require(governanceContracts[msg.sender]);
134         _;
135     }
136 
137 
138     function addAddressToGovernanceContract(address addr) onlyOwner public returns(bool success) {
139         if (!governanceContracts[addr]) {
140             governanceContracts[addr] = true;
141             emit GovernanceContractAdded(addr);
142             success = true;
143         }
144     }
145 
146 
147     function removeAddressFromGovernanceContract(address addr) onlyOwner public returns(bool success) {
148         if (governanceContracts[addr]) {
149             governanceContracts[addr] = false;
150             emit GovernanceContractRemoved(addr);
151             success = true;
152         }
153     }
154 }
155 
156 contract SafeStorage is WhitelistMigratable, ArrayTools {
157     using SafeMath for uint256;
158 
159     event LockSlotCreated(address indexed holder, uint256 id, uint256 amount);
160 
161     struct LockSlot{
162         uint256[] tokens;
163         uint256[] periods;
164         uint256 paidTokens;
165         bool finalized;
166     }
167 
168     mapping (address => mapping(uint256 => LockSlot)) internal lockTokenStorage;
169 
170     mapping (address => uint256[]) private lockSlotIdList;
171 
172     address[] internal holdersList;
173 
174     address[] internal totalSlot;
175 
176     uint256 public maximumDurationToFreeze;
177 
178     uint256 public lostTime;
179 
180     uint256 public totalLockedTokens;
181 
182     IQDAO public token_;
183 
184     /**
185     * @dev Create slot for holder
186     * Usage of this method only owner
187     * @param _holder address The address which you want to lock tokens
188     * @param _tokens uint256[]  the amount of tokens to be locked
189     * @param _periods uint256[] the amount of periods to be locked
190     */
191     function createLockSlot(address _holder, uint256[] _tokens, uint256[] _periods) public onlyGovernanceContracts {
192 
193         require(_holder != address(0), "LockStorage cannot be created for this address");
194         require (_tokens.length == _periods.length && _tokens.length > 0);
195         require(_combineArray(_periods) <= maximumDurationToFreeze, "Incorrect time, should be less 3 years");
196         require(_combineArray(_tokens) > 0, "Incorrect amount");
197 
198         uint256 fullAmount = _combineArray(_tokens);
199         uint256 newId = totalSlot.length;
200 
201         token_.approveForOtherContracts(msg.sender, this, fullAmount);
202         token_.transferFrom(msg.sender, this, fullAmount);
203 
204         lockTokenStorage[_holder][newId] = _createLockSlot(_tokens, _periods);
205 
206         totalSlot.push(_holder);
207         totalLockedTokens = totalLockedTokens.add(fullAmount);
208 
209         if(lockSlotIdList[_holder].length == 0) {
210             holdersList.push(_holder);
211         }
212 
213         lockSlotIdList[_holder].push(newId);
214 
215         emit LockSlotCreated(_holder, newId, fullAmount);
216     }
217 
218     /**
219     * @dev Returned holder's address
220     * @param _lockSlotId uint256 unique id lockSlot
221     */
222     function getAddressToId(uint256 _lockSlotId) public view returns(address) {
223         return totalSlot[_lockSlotId];
224     }
225 
226     /**
227     * @dev Returned all created unique ids
228     * @param _holder address The holder's address
229     */
230     function getAllLockSlotIdsToAddress(address _holder) public view returns(uint256[] _lockSlotIds) {
231         return lockSlotIdList[_holder];
232     }
233 
234 
235     function _createLockSlot(uint256[] _lockTokens, uint256[] _lockPeriods) internal view returns(LockSlot memory _lockSlot) {
236         _lockPeriods[0] +=now;
237 
238         if (_lockPeriods.length > 1) {
239             for(uint256 i = 1; i < _lockPeriods.length; i++) {
240                 _lockPeriods[i] += _lockPeriods[i-1];
241             }
242         }
243 
244         _lockSlot = LockSlot({
245             tokens: _lockTokens,
246             periods: _lockPeriods,
247             paidTokens: 0,
248             finalized: false
249             });
250     }
251 }
252 
253 contract ReleaseLockToken is SafeStorage {
254 
255     event TokensWithdrawed(address indexed sender, uint256 amount, uint256 time);
256 
257     uint256 public withdrawableTokens;
258 
259     /**
260     * @dev Withdraw locked tokens
261     * Usage of this method only holder this lockSlot's id
262     * @param _lockSlotId uint256 unique id lockSlot
263     */
264     function release(uint256 _lockSlotId) public {
265         require(_validateWithdraw(msg.sender, _lockSlotId));
266         uint256 tokensForWithdraw = _getAvailableTokens(msg.sender, _lockSlotId);
267 
268         lockTokenStorage[msg.sender][_lockSlotId].paidTokens = lockTokenStorage[msg.sender][_lockSlotId].paidTokens.add(tokensForWithdraw);
269         token_.transfer(msg.sender,  tokensForWithdraw);
270 
271         if(_combineArray(lockTokenStorage[msg.sender][_lockSlotId].tokens) == lockTokenStorage[msg.sender][_lockSlotId].paidTokens) {
272             _finalizeLock(msg.sender, _lockSlotId);
273         }
274 
275         withdrawableTokens = withdrawableTokens.add(tokensForWithdraw);
276         totalLockedTokens = totalLockedTokens.sub(tokensForWithdraw);
277         emit TokensWithdrawed(msg.sender, tokensForWithdraw, now);
278     }
279 
280     /**
281     * @dev Returned all withdrawn tokens
282     */
283     function getWithdrawableTokens() public view returns(uint256) {
284         return withdrawableTokens;
285     }
286 
287     /**
288     * @dev Withdrawn lost tokens
289     * Usage of this method only owner
290     * @param _lockSlotId uint256 unique id lockSlot
291     */
292     function withdrawLostToken(uint256 _lockSlotId) public onlyGovernanceContracts {
293 
294         require(now > lostTime.add(
295             lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods.length-1]),
296             "Tokens are not lost");
297 
298         uint256 tokensForWithdraw = _getAvailableTokens(getAddressToId(_lockSlotId), _lockSlotId);
299         withdrawableTokens = withdrawableTokens.add(tokensForWithdraw);
300         totalLockedTokens = totalLockedTokens.sub(tokensForWithdraw);
301         lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].paidTokens = _combineArray(lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].tokens);
302         _finalizeLock(getAddressToId(_lockSlotId), _lockSlotId);
303         token_.transfer( owner,  tokensForWithdraw);
304     }
305 
306     /**
307     * @dev Returned date and amount to counter
308     * @param _lockSlotId uint256 unique id lockSlot
309     * @param _i uint256 count number
310     */
311     function getDateAndReleaseToCounter(uint256 _lockSlotId,
312                                         uint256 _i) public view returns(uint256 _nextDate,
313                                                                         uint256 _nextRelease) {
314 
315         require( _i < lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods.length);
316 
317         _nextRelease = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].tokens[_i];
318         _nextDate = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[_i];
319     }
320 
321     /**
322     * @dev Returned nearest date for withdraw
323     * @param _lockSlotId uint256 unique id lockSlot
324     */
325     function getNextDateWithdraw(uint256 _lockSlotId) public view returns(uint256) {
326         uint256 nextDate;
327 
328         if(now > lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods.length-1]) {
329             nextDate = 0;
330         }
331         else {
332             for(uint256 i = 0; i < lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods.length; i++) {
333                 if(now < lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[i]) {
334                     nextDate = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[i];
335                     break;
336                 }
337             }
338         }
339         return nextDate;
340     }
341 
342     function _finalizeLock(address _who, uint256 _id) internal {
343         lockTokenStorage[_who][_id].finalized = true;
344     }
345 
346     function _validateWithdraw(address _who, uint256 _id) internal view returns(bool) {
347         require(!lockTokenStorage[_who][_id].finalized, "Full withdraw already exists");
348         require(_combineArray(lockTokenStorage[_who][_id].tokens) > 0 , "This lockStorage is not exists");
349         require(now > lockTokenStorage[_who][_id].periods[0], "Unlock time has not come");
350 
351         return true;
352     }
353 
354     function _getAvailableTokens(address _who, uint256 _id) internal view returns(uint256) {
355         uint256 tokensForWithdraw;
356 
357         uint256 paidTokens = lockTokenStorage[_who][_id].paidTokens;
358 
359         for(uint256 i = lockTokenStorage[_who][_id].periods.length-1; i >= 0; i--) {
360             if(now >= lockTokenStorage[_who][_id].periods[i]) {
361 
362                 for(uint256 y = 0; y < i+1; y++) {
363                     tokensForWithdraw += lockTokenStorage[_who][_id].tokens[y];
364                 }
365                 tokensForWithdraw -= paidTokens;
366                 break;
367             }
368         }
369         return tokensForWithdraw;
370     }
371 }
372 
373 contract TimeLockedTokenStorage is ReleaseLockToken {
374 
375     constructor(address _token) public {
376         token_ = IQDAO(_token);
377         lostTime = 7862400; // 3 months
378         maximumDurationToFreeze = 94694400; // 3 years
379     }
380 
381 
382     /**
383     * @dev Returned available tokens for withdraw
384     * @param _lockSlotId uint256 unique id lockSlot
385     */
386     function getAvailableTokens(uint256 _lockSlotId) public view returns(uint256) {
387         if (now < uint256(lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods[0])) {
388             return 0;
389         } else {
390             return _getAvailableTokens(getAddressToId(_lockSlotId), _lockSlotId);
391         }
392     }
393 
394     /**
395     * @dev Returned total holders
396     */
397     function getHoldersQuantity() public view returns(uint256) {
398         return holdersList.length;
399     }
400 
401     /**
402    * @dev Returned total locked slots
403    */
404     function getSlotsQuantity() public view returns(uint256) {
405         return totalSlot.length;
406     }
407     /**
408      * @dev Returned total locked tokens
409     */
410     function getTotalLockedTokens() public view returns(uint256) {
411         return totalLockedTokens;
412     }
413     /**
414     * @dev Returned params for lockSlot
415     * @param _lockSlotId uint256 unique id lockSlot
416     */
417     function getLock(uint256 _lockSlotId) public view returns(  uint256 _amountTokens,
418                                                                 uint256[] _periods,
419                                                                 uint256[] _tokens,
420                                                                 uint256 _paidTokens,
421                                                                 bool _finalize) {
422 
423         _amountTokens = _combineArray(lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].tokens);
424         _periods = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].periods;
425         _tokens = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].tokens;
426         _paidTokens = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].paidTokens;
427         _finalize = lockTokenStorage[getAddressToId(_lockSlotId)][_lockSlotId].finalized;
428     }
429 }
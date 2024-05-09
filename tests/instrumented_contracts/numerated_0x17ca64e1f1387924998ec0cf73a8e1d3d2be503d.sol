1 pragma solidity 0.8.0;
2 
3 abstract contract ERC20 {
4 
5     uint256 private _totalSupply;
6     mapping(address => uint256) internal _balances;
7     mapping(address => mapping(address => uint256)) internal _allowances;
8 
9     event Transfer(address indexed from, address indexed to, uint256 amount);
10     event Approval(
11         address indexed owner,
12         address indexed spender,
13         uint256 amount
14     );
15 
16     /*
17    * Internal Functions for ERC20 standard logics
18    */
19 
20     function _transfer(address from, address to, uint256 amount)
21         internal
22         returns (bool success)
23     {
24         _balances[from] = _balances[from] - amount;
25         _balances[to] = _balances[to] + amount;
26         emit Transfer(from, to, amount);
27         success = true;
28     }
29 
30     function _approve(address owner, address spender, uint256 amount)
31         internal
32         returns (bool success)
33     {
34         _allowances[owner][spender] = amount;
35         emit Approval(owner, spender, amount);
36         success = true;
37     }
38 
39     function _mint(address recipient, uint256 amount)
40         internal
41         returns (bool success)
42     {
43         _totalSupply = _totalSupply + amount;
44         _balances[recipient] = _balances[recipient] + amount;
45         emit Transfer(address(0), recipient, amount);
46         success = true;
47     }
48 
49     function _burn(address burned, uint256 amount)
50         internal
51         returns (bool success)
52     {
53         _balances[burned] = _balances[burned] - amount;
54         _totalSupply = _totalSupply - amount;
55         emit Transfer(burned, address(0), amount);
56         success = true;
57     }
58 
59     /*
60    * public view functions to view common data
61    */
62 
63     function totalSupply() external view returns (uint256 total) {
64         total = _totalSupply;
65     }
66     function balanceOf(address owner) external view returns (uint256 balance) {
67         balance = _balances[owner];
68     }
69 
70     function allowance(address owner, address spender)
71         external
72         view
73         returns (uint256 remaining)
74     {
75         remaining = _allowances[owner][spender];
76     }
77 
78     /*
79    * External view Function Interface to implement on final contract
80    */
81     function name() virtual external view returns (string memory tokenName);
82     function symbol() virtual external view returns (string memory tokenSymbol);
83     function decimals() virtual external view returns (uint8 tokenDecimals);
84 
85     /*
86    * External Function Interface to implement on final contract
87    */
88     function transfer(address to, uint256 amount)
89         virtual
90         external
91         returns (bool success);
92     function transferFrom(address from, address to, uint256 amount)
93         virtual
94         external
95         returns (bool success);
96     function approve(address spender, uint256 amount)
97         virtual
98         external
99         returns (bool success);
100 }
101 
102 
103 // File contracts/library/Ownable.sol
104 pragma solidity 0.8.0;
105 
106 abstract contract Ownable {
107     address internal _owner;
108 
109     event OwnershipTransferred(
110         address indexed currentOwner,
111         address indexed newOwner
112     );
113 
114     constructor() {
115         _owner = msg.sender;
116         emit OwnershipTransferred(address(0), msg.sender);
117     }
118 
119     modifier onlyOwner() {
120         require(
121             msg.sender == _owner,
122             "Ownable : Function called by unauthorized user."
123         );
124         _;
125     }
126 
127     function owner() external view returns (address ownerAddress) {
128         ownerAddress = _owner;
129     }
130 
131     function transferOwnership(address newOwner)
132         public
133         onlyOwner
134         returns (bool success)
135     {
136         require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
137         success = _transferOwnership(newOwner);
138     }
139 
140     function renounceOwnership() external onlyOwner returns (bool success) {
141         success = _transferOwnership(address(0));
142     }
143 
144     function _transferOwnership(address newOwner) internal returns (bool success) {
145         emit OwnershipTransferred(_owner, newOwner);
146         _owner = newOwner;
147         success = true;
148     }
149 }
150 
151 
152 // File contracts/erc20/ERC20Lockable.sol
153 
154 abstract contract ERC20Lockable is ERC20, Ownable {
155     struct LockInfo {
156         uint256 amount;
157         uint256 due;
158     }
159 
160     mapping(address => LockInfo[]) internal _locks;
161     mapping(address => uint256) internal _totalLocked;
162 
163     event Lock(address indexed from, uint256 amount, uint256 due);
164     event Unlock(address indexed from, uint256 amount);
165 
166     modifier checkLock(address from, uint256 amount) {
167         require(_balances[from] >= _totalLocked[from] + amount, "ERC20Lockable/Cannot send more than unlocked amount");
168         _;
169     }
170 
171     function _lock(address from, uint256 amount, uint256 due)
172     internal
173     returns (bool success)
174     {
175         require(due > block.timestamp, "ERC20Lockable/lock : Cannot set due to past");
176         require(
177             _balances[from] >= amount + _totalLocked[from],
178             "ERC20Lockable/lock : locked total should be smaller than balance"
179         );
180         _totalLocked[from] = _totalLocked[from] + amount;
181         _locks[from].push(LockInfo(amount, due));
182         emit Lock(from, amount, due);
183         success = true;
184     }
185 
186     function _unlock(address from, uint256 index) internal returns (bool success) {
187         LockInfo storage lock = _locks[from][index];
188         _totalLocked[from] = _totalLocked[from] - lock.amount;
189         emit Unlock(from, lock.amount);
190         _locks[from][index] = _locks[from][_locks[from].length - 1];
191         _locks[from].pop();
192         success = true;
193     }
194 
195     function unlock(address from, uint256 idx) external returns(bool success){
196         require(_locks[from][idx].due < block.timestamp,"ERC20Lockable/unlock: cannot unlock before due");
197         return _unlock(from, idx);
198     }
199 
200     function unlockAll(address from) external returns (bool success) {
201         for(uint256 i = 0; i < _locks[from].length;){
202             i++;
203             if(_locks[from][i - 1].due < block.timestamp){
204                 if(_unlock(from, i - 1)){
205                     i--;
206                 }
207             }
208         }
209         success = true;
210     }
211 
212     function releaseLock(address from)
213     external
214     onlyOwner
215     returns (bool success)
216     {
217         for(uint256 i = 0; i < _locks[from].length;){
218             i++;
219             if(_unlock(from, i - 1)){
220                 i--;
221             }
222         }
223         success = true;
224     }
225 
226     function transferWithLockUp(address recipient, uint256 amount, uint256 due)
227     external
228     onlyOwner
229     returns (bool success)
230     {
231         require(
232             recipient != address(0),
233             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
234         );
235         _transfer(msg.sender, recipient, amount);
236         _lock(recipient, amount, due);
237         success = true;
238     }
239 
240     function lockInfo(address locked, uint256 index)
241     external
242     view
243     returns (uint256 amount, uint256 due)
244     {
245         LockInfo memory lock = _locks[locked][index];
246         amount = lock.amount;
247         due = lock.due;
248     }
249 
250     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
251         amount = _totalLocked[locked];
252         length = _locks[locked].length;
253     }
254 }
255 
256 pragma solidity 0.8.0;
257 
258 contract Pausable is Ownable {
259     bool internal _paused;
260 
261     event Paused();
262     event Unpaused();
263 
264     modifier whenPaused() {
265         require(_paused, "Paused : This function can only be called when paused");
266         _;
267     }
268 
269     modifier whenNotPaused() {
270         require(!_paused, "Paused : This function can only be called when not paused");
271         _;
272     }
273 
274     function pause() external onlyOwner whenNotPaused returns (bool success) {
275         _paused = true;
276         emit Paused();
277         success = true;
278     }
279 
280     function unPause() external onlyOwner whenPaused returns (bool success) {
281         _paused = false;
282         emit Unpaused();
283         success = true;
284     }
285 
286     function paused() external view returns (bool) {
287         return _paused;
288     }
289 }
290 
291 
292 // File contracts/erc20/ERC20Burnable.sol
293 
294 
295 abstract contract ERC20Burnable is ERC20, Pausable {
296     event Burn(address indexed burned, uint256 amount);
297 
298     function burn(uint256 amount)
299         external
300         whenNotPaused
301         returns (bool success)
302     {
303         success = _burn(msg.sender, amount);
304         emit Burn(msg.sender, amount);
305         success = true;
306     }
307 
308     function burnFrom(address burned, uint256 amount)
309         external
310         whenNotPaused
311         returns (bool success)
312     {
313         _burn(burned, amount);
314         emit Burn(burned, amount);
315         success = _approve(
316             burned,
317             msg.sender,
318             _allowances[burned][msg.sender] - amount
319         );
320     }
321 }
322 
323 pragma solidity 0.8.0;
324 
325 contract Freezable is Ownable {
326     mapping(address => bool) private _frozen;
327 
328     event Freeze(address indexed target);
329     event Unfreeze(address indexed target);
330 
331     modifier whenNotFrozen(address target) {
332         require(!_frozen[target], "Freezable : target is frozen");
333         _;
334     }
335 
336     function freeze(address target) external onlyOwner returns (bool success) {
337         _frozen[target] = true;
338         emit Freeze(target);
339         success = true;
340     }
341 
342     function unFreeze(address target)
343         external
344         onlyOwner
345         returns (bool success)
346     {
347         _frozen[target] = false;
348         emit Unfreeze(target);
349         success = true;
350     }
351 
352     function isFrozen(address target)
353         external
354         view
355         returns (bool frozen)
356     {
357         return _frozen[target];
358     }
359 }
360 
361 
362 // File contracts/AWNEX.sol
363 
364 // SPDX-License-Identifier: MIT
365 
366 pragma solidity 0.8.0;
367 
368 
369 
370 
371 contract AWNEX is
372     ERC20Lockable,
373     ERC20Burnable,
374     Freezable
375 {
376     string constant private _name = "AWNEX";
377     string constant private _symbol = "AWNEX";
378     uint8 constant private _decimals = 18;
379     uint256 constant private _initial_supply = 1_000_000_000;
380 
381     constructor() Ownable() {
382         _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
383     }
384 
385     function transfer(address to, uint256 amount)
386         override
387         external
388         whenNotFrozen(msg.sender)
389         whenNotPaused
390         checkLock(msg.sender, amount)
391         returns (bool success)
392     {
393         require(
394             to != address(0),
395             "AWNEX/transfer : Should not send to zero address"
396         );
397         _transfer(msg.sender, to, amount);
398         success = true;
399     }
400 
401     function transferFrom(address from, address to, uint256 amount)
402         override
403         external
404         whenNotFrozen(from)
405         whenNotPaused
406         checkLock(from, amount)
407         returns (bool success)
408     {
409         require(
410             to != address(0),
411             "AWNEX/transferFrom : Should not send to zero address"
412         );
413         _transfer(from, to, amount);
414         _approve(
415             from,
416             msg.sender,
417             _allowances[from][msg.sender] - amount
418         );
419         success = true;
420     }
421 
422     function approve(address spender, uint256 amount)
423         override
424         external
425         returns (bool success)
426     {
427         require(
428             spender != address(0),
429             "AWNEX/approve : Should not approve zero address"
430         );
431         _approve(msg.sender, spender, amount);
432         success = true;
433     }
434 
435     function name() override external pure returns (string memory tokenName) {
436         tokenName = _name;
437     }
438 
439     function symbol() override external pure returns (string memory tokenSymbol) {
440         tokenSymbol = _symbol;
441     }
442 
443     function decimals() override external pure returns (uint8 tokenDecimals) {
444         tokenDecimals = _decimals;
445     }
446 }
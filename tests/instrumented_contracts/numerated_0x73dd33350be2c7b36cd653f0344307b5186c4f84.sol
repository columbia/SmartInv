1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Solidity only automatically asserts when dividing by 0
17         require(b > 0);
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45     function transfer(address to, uint256 value) external returns (bool);
46 
47     function approve(address spender, uint256 value) external returns (bool);
48 
49     function transferFrom(address from, address to, uint256 value) external returns (bool);
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address who) external view returns (uint256);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract ERC20 is IERC20 {
63     using SafeMath for uint256;
64 
65     mapping (address => uint256) internal _balances;
66 
67     mapping (address => mapping (address => uint256)) private _allowed;
68 
69     uint256 private _totalSupply;
70 
71     function totalSupply() public view returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address owner) public view returns (uint256) {
76         return _balances[owner];
77     }
78 
79     function allowance(address owner, address spender) public view returns (uint256) {
80         return _allowed[owner][spender];
81     }
82 
83     function transfer(address to, uint256 value) public returns (bool) {
84         _transfer(msg.sender, to, value);
85         return true;
86     }
87 
88     function approve(address spender, uint256 value) public returns (bool) {
89         require(spender != address(0));
90 
91         _allowed[msg.sender][spender] = value;
92         emit Approval(msg.sender, spender, value);
93         return true;
94     }
95 
96     function transferFrom(address from, address to, uint256 value) public returns (bool) {
97         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
98         _transfer(from, to, value);
99         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
104         require(spender != address(0));
105 
106         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
107         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
108         return true;
109     }
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
112         require(spender != address(0));
113 
114         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
115         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
116         return true;
117     }
118 
119     function _transfer(address from, address to, uint256 value) internal {
120         require(to != address(0));
121 
122         _balances[from] = _balances[from].sub(value);
123         _balances[to] = _balances[to].add(value);
124         emit Transfer(from, to, value);
125     }
126 
127     function _mint(address account, uint256 value) internal {
128         require(account != address(0));
129 
130         _totalSupply = _totalSupply.add(value);
131         _balances[account] = _balances[account].add(value);
132         emit Transfer(address(0), account, value);
133     }
134 
135     function _burn(address account, uint256 value) internal {
136         require(account != address(0));
137 
138         _totalSupply = _totalSupply.sub(value);
139         _balances[account] = _balances[account].sub(value);
140         emit Transfer(account, address(0), value);
141     }
142 
143     function _burnFrom(address account, uint256 value) internal {
144         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
145         _burn(account, value);
146         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
147     }
148 }
149 
150 contract ERC20Detailed is IERC20 {
151     string private _name;
152     string private _symbol;
153     uint8 private _decimals;
154 
155     constructor (string memory name, string memory symbol, uint8 decimals) public {
156         _name = name;
157         _symbol = symbol;
158         _decimals = decimals;
159     }
160 
161     function name() public view returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public view returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public view returns (uint8) {
170         return _decimals;
171     }
172 }
173 
174 contract Ownable {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181      * account.
182      */
183     constructor () internal {
184         _owner = msg.sender;
185         emit OwnershipTransferred(address(0), _owner);
186     }
187 
188     /**
189      * @return the address of the owner.
190      */
191     function owner() public view returns (address) {
192         return _owner;
193     }
194 
195     /**
196      * @dev Throws if called by any account other than the owner.
197      */
198     modifier onlyOwner() {
199         require(isOwner());
200         _;
201     }
202 
203     /**
204      * @return true if `msg.sender` is the owner of the contract.
205      */
206     function isOwner() public view returns (bool) {
207         return msg.sender == _owner;
208     }
209 
210     /**
211      * @dev Allows the current owner to transfer control of the contract to a newOwner.
212      * @param newOwner The address to transfer ownership to.
213      */
214     function transferOwnership(address newOwner) public onlyOwner {
215         _transferOwnership(newOwner);
216     }
217 
218     /**
219      * @dev Transfers control of the contract to a newOwner.
220      * @param newOwner The address to transfer ownership to.
221      */
222     function _transferOwnership(address newOwner) internal {
223         require(newOwner != address(0));
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 }
228 
229 contract Pausable is Ownable {
230     event Paused(address account);
231     event Unpaused(address account);
232 
233     bool private _paused;
234 
235     constructor () internal {
236         _paused = false;
237     }
238 
239     function paused() public view returns (bool) {
240         return _paused;
241     }
242 
243     modifier whenNotPaused() {
244         require(!_paused);
245         _;
246     }
247 
248     modifier whenPaused() {
249         require(_paused);
250         _;
251     }
252 
253     function pause() public onlyOwner whenNotPaused {
254         _paused = true;
255         emit Paused(msg.sender);
256     }
257 
258     function unpause() public onlyOwner whenPaused {
259         _paused = false;
260         emit Unpaused(msg.sender);
261     }
262 }
263 
264 contract ERC20Pausable is ERC20, Pausable {
265     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
266         return super.transfer(to, value);
267     }
268 
269     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
270         return super.transferFrom(from, to, value);
271     }
272 
273     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
274         return super.approve(spender, value);
275     }
276 
277     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
278         return super.increaseAllowance(spender, addedValue);
279     }
280 
281     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
282         return super.decreaseAllowance(spender, subtractedValue);
283     }
284 }
285 
286 contract RAID is ERC20Pausable, ERC20Detailed {
287     string internal constant INVALID_TOKEN_VALUES = "Invalid token values";
288     string internal constant NOT_ENOUGH_TOKENS = "Not enough tokens";
289     string internal constant ALREADY_LOCKED = "Tokens already locked";
290     string internal constant NOT_LOCKED = "No tokens locked";
291     string internal constant AMOUNT_ZERO = "Amount can not be 0";
292     string internal constant EXPIRED_ADDRESS = "Expired Address";
293 
294     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(18));
295 
296     mapping(address => bytes32[]) public lockReason;
297 
298     struct lockToken {
299         uint256 amount;
300         uint256 validity;
301         bool claimed;
302     }
303 
304     mapping(address => mapping(bytes32 => lockToken)) public locked;
305 
306     event Locked(address indexed _of, bytes32 indexed _reason, uint256 _amount, uint256 _validity);
307     event Unlocked(address indexed _of, bytes32 indexed _reason, uint256 _amount);
308 
309     event RemoveLock(address indexed _of, bytes32 indexed _reason, uint256 _amount, uint256 _validity);
310     event RemoveExpired(address indexed _of, uint256 _amount, uint256 _validity);
311 
312     constructor ()
313     ERC20Detailed ("RAID", "RAID", 18)
314     public {
315         _mint(msg.sender, INITIAL_SUPPLY);
316     }
317 
318     // ERC20 회수
319     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
320         token.transfer(_to, _value);
321         return true;
322     }
323 
324     // 특정 Account에 지정된 기간동안 락업된 토큰을 전송
325     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public onlyOwner returns (bool) {
326         uint256 validUntil = now.add(_time);
327 
328         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
329         require(_amount != 0, AMOUNT_ZERO);
330 
331         if (locked[_to][_reason].amount == 0)
332             lockReason[_to].push(_reason);
333 
334         transfer(address(this), _amount);
335 
336         locked[_to][_reason] = lockToken(_amount, validUntil, false);
337         
338         emit Locked(_to, _reason, _amount, validUntil);
339         return true;
340     }
341 
342     // 락업 정보 삭제
343     function removeLock(address _of, bytes32 _reason) public onlyOwner returns (bool deleted) {
344         require(!locked[_of][_reason].claimed, EXPIRED_ADDRESS);
345         this.transfer(_of, locked[_of][_reason].amount);
346         delete locked[_of][_reason];
347         
348         emit RemoveLock(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
349         return true;
350     }
351 
352     // // 만료된 락업 정보 삭제
353     function removeExpired(address _of) public onlyOwner returns (bool deleted) {
354         for (uint256 i = 0; i < lockReason[_of].length; i++) {
355             if (locked[_of][lockReason[_of][i]].claimed) {
356                 delete locked[_of][lockReason[_of][i]];
357                 emit RemoveExpired(_of, locked[_of][lockReason[_of][i]].amount, locked[_of][lockReason[_of][i]].validity);
358                 deleted = true;
359             }
360         }
361         return deleted;
362     }
363 
364     // 특정 Account의 토큰을 지정된 기간동안 락업
365     function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
366         uint256 validUntil = now.add(_time);
367 
368         require(_amount <= _balances[_of], NOT_ENOUGH_TOKENS);
369         require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
370         require(_amount != 0, AMOUNT_ZERO);
371 
372         if (locked[_of][_reason].amount == 0)
373             lockReason[_of].push(_reason);
374 
375         _balances[address(this)] = _balances[address(this)].add(_amount);
376         _balances[_of] = _balances[_of].sub(_amount);
377         locked[_of][_reason] = lockToken(_amount, validUntil, false);
378 
379         emit Locked(_of, _reason, _amount, validUntil);
380         return true;
381     }
382 
383     // 특정 Account의 사유에 대해 락업 잔액 확인
384     function tokensLocked(address _of, bytes32 _reason) public view returns (uint256 amount) {
385         if (!locked[_of][_reason].claimed)
386             amount = locked[_of][_reason].amount;
387     }
388 
389     // 특정 Account, 사유, 시간에 대해 락업 잔액 확인
390     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view returns (uint256 amount) {
391         if (locked[_of][_reason].validity > _time)
392             amount = locked[_of][_reason].amount;
393     }
394 
395     // 특정 Account의 총 락업 잔액 확인
396     function totalBalanceOf(address _of) public view returns (uint256 amount) {
397         amount = balanceOf(_of);
398 
399         for (uint256 i = 0; i < lockReason[_of].length; i++) {
400             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
401         }   
402     }    
403 
404     // 사유에 대한 락업 기간을 연장
405     function extendLock(bytes32 _reason, uint256 _time, address _of) public onlyOwner returns (bool) {
406         require(tokensLocked(_of, _reason) > 0, NOT_LOCKED);
407 
408         locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);
409 
410         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
411         return true;
412     }
413 
414     // 사유에 대해 소유자 수량을 보내어 락업 수량 추가
415     function increaseLockAmount(bytes32 _reason, uint256 _amount, address _of) public onlyOwner returns (bool) {
416         require(tokensLocked(_of, _reason) > 0, NOT_LOCKED);
417         transfer(address(this), _amount);
418 
419         locked[_of][_reason].amount = locked[_of][_reason].amount.add(_amount);
420 
421         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
422         return true;
423     }
424 
425     // 특정 Account의 사유에 대해 만료된 락업 잔액 확인
426     function tokensUnlockable(address _of, bytes32 _reason) public view returns (uint256 amount) {
427         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed)
428             amount = locked[_of][_reason].amount;
429     }
430 
431     // 특정 Account에 락업된 토큰을 모두 언락
432     function unlock(address _of) public onlyOwner returns (uint256 unlockableTokens) {
433         uint256 lockedTokens;
434 
435         for (uint256 i = 0; i < lockReason[_of].length; i++) {
436             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
437             if (lockedTokens > 0) {
438                 unlockableTokens = unlockableTokens.add(lockedTokens);
439                 locked[_of][lockReason[_of][i]].claimed = true;
440                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
441             }
442         }  
443 
444         if (unlockableTokens > 0)
445             this.transfer(_of, unlockableTokens);
446     }
447 
448     // 특정 Account에 언락 가능한 총 토큰 잔액
449     function getUnlockableTokens(address _of) public view returns (uint256 unlockableTokens) {
450         for (uint256 i = 0; i < lockReason[_of].length; i++) {
451             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
452         }  
453     }
454 }
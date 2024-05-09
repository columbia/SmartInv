1 interface IERC20 {
2     function transfer(address, uint256) external returns (bool);
3     function approve(address, uint256) external returns (bool);
4     function transferFrom(address, address, uint256) external returns (bool);
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address) external view returns (uint256);
7     function allowance(address, address) external view returns (uint256);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9     event Approval(address indexed holder, address indexed spender, uint256 value);
10 }
11 
12 contract ReserveDollar is IERC20 {
13     using SafeMath for uint256;
14 
15 
16     // DATA
17 
18 
19     // Non-constant-sized data
20     ReserveDollarEternalStorage internal data;
21 
22     // Basic token data
23     string public name = "Reserve Dollar";
24     string public symbol = "RSVD";
25     uint8 public constant decimals = 18;
26     uint256 public totalSupply;
27 
28     // Paused data
29     bool public paused;
30 
31     // Auth roles
32     address public owner;
33     address public minter;
34     address public pauser;
35     address public freezer;
36     address public nominatedOwner;
37 
38 
39     // EVENTS
40 
41 
42     // Auth role change events
43     event OwnerChanged(address indexed newOwner);
44     event MinterChanged(address indexed newMinter);
45     event PauserChanged(address indexed newPauser);
46     event FreezerChanged(address indexed newFreezer);
47 
48     // Pause events
49     event Paused(address indexed account);
50     event Unpaused(address indexed account);
51 
52     // Name change event
53     event NameChanged(string newName, string newSymbol);
54 
55     // Law enforcement events
56     event Frozen(address indexed freezer, address indexed account);
57     event Unfrozen(address indexed freezer, address indexed account);
58     event Wiped(address indexed freezer, address indexed wiped);
59 
60 
61     // FUNCTIONALITY
62 
63 
64     /// Initialize critical fields.
65     constructor() public {
66         data = new ReserveDollarEternalStorage(msg.sender);
67         owner = msg.sender;
68         pauser = msg.sender;
69         // Other roles deliberately default to the zero address.
70     }
71 
72     /// Accessor for eternal storage contract address.
73     function getEternalStorageAddress() external view returns(address) {
74         return address(data);
75     }
76 
77 
78     // ==== Admin functions ====
79 
80 
81     /// Modifies a function to only run if sent by `role`.
82     modifier only(address role) {
83         require(msg.sender == role, "unauthorized: not role holder");
84         _;
85     }
86 
87     /// Modifies a function to only run if sent by `role` or the contract's `owner`.
88     modifier onlyOwnerOr(address role) {
89         require(msg.sender == owner || msg.sender == role, "unauthorized: not role holder and not owner");
90         _;
91     }
92 
93     /// Change who holds the `minter` role.
94     function changeMinter(address newMinter) external onlyOwnerOr(minter) {
95         minter = newMinter;
96         emit MinterChanged(newMinter);
97     }
98 
99     /// Change who holds the `pauser` role.
100     function changePauser(address newPauser) external onlyOwnerOr(pauser) {
101         pauser = newPauser;
102         emit PauserChanged(newPauser);
103     }
104 
105     /// Change who holds the `freezer` role.
106     function changeFreezer(address newFreezer) external onlyOwnerOr(freezer) {
107         freezer = newFreezer;
108         emit FreezerChanged(newFreezer);
109     }
110 
111     /// Nominate a new `owner`.  We want to ensure that `owner` is always valid, so we don't
112     /// actually change `owner` to `nominatedOwner` until `nominatedOwner` calls `acceptOwnership`.
113     function nominateNewOwner(address nominee) external only(owner) {
114         nominatedOwner = nominee;
115     }
116 
117     /// Accept nomination for ownership.
118     /// This completes the `nominateNewOwner` handshake.
119     function acceptOwnership() external onlyOwnerOr(nominatedOwner) {
120         if (msg.sender != owner) {
121             emit OwnerChanged(msg.sender);
122         }
123         owner = msg.sender;
124         nominatedOwner = address(0);
125     }
126 
127     /// Set `owner` to 0.
128     /// Only do this to deliberately lock in the current permissions.
129     function renounceOwnership() external only(owner) {
130         owner = address(0);
131         emit OwnerChanged(owner);
132     }
133 
134     /// Make a different address own the EternalStorage contract.
135     /// This will break this contract, so only do it if you're
136     /// abandoning this contract, e.g., for an upgrade.
137     function transferEternalStorage(address newOwner) external only(owner) {
138         data.transferOwnership(newOwner);
139     }
140 
141     /// Change the name and ticker symbol of this token.
142     function changeName(string calldata newName, string calldata newSymbol) external only(owner) {
143         name = newName;
144         symbol = newSymbol;
145         emit NameChanged(newName, newSymbol);
146     }
147 
148     /// Pause the contract.
149     function pause() external only(pauser) {
150         paused = true;
151         emit Paused(pauser);
152     }
153 
154     /// Unpause the contract.
155     function unpause() external only(pauser) {
156         paused = false;
157         emit Unpaused(pauser);
158     }
159 
160     /// Modifies a function to run only when the contract is not paused.
161     modifier notPaused() {
162         require(!paused, "contract is paused");
163         _;
164     }
165 
166     /// Freeze token transactions for a particular address.
167     function freeze(address account) external only(freezer) {
168         require(data.frozenTime(account) == 0, "account already frozen");
169 
170         // In `wipe` we use block.timestamp (aka `now`) to check that enough time has passed since
171         // this freeze happened. That required time delay -- 4 weeks -- is a long time relative to
172         // the maximum drift of block.timestamp, so it is fine to trust the miner here.
173         // solium-disable-next-line security/no-block-members
174         data.setFrozenTime(account, now);
175 
176         emit Frozen(freezer, account);
177     }
178 
179     /// Unfreeze token transactions for a particular address.
180     function unfreeze(address account) external only(freezer) {
181         require(data.frozenTime(account) > 0, "account not frozen");
182         data.setFrozenTime(account, 0);
183         emit Unfrozen(freezer, account);
184     }
185 
186     /// Modifies a function to run only when the `account` is not frozen.
187     modifier notFrozen(address account) {
188         require(data.frozenTime(account) == 0, "account frozen");
189         _;
190     }
191 
192     /// Burn the balance of an account that has been frozen for at least 4 weeks.
193     function wipe(address account) external only(freezer) {
194         require(data.frozenTime(account) > 0, "cannot wipe unfrozen account");
195         // See commentary above about using block.timestamp.
196         // solium-disable-next-line security/no-block-members
197         require(data.frozenTime(account) + 4 weeks < now, "cannot wipe frozen account before 4 weeks");
198         _burn(account, data.balance(account));
199         emit Wiped(freezer, account);
200     }
201 
202 
203     // ==== Token transfers, allowances, minting, and burning ====
204 
205 
206     /// @return how many attotokens are held by `holder`.
207     function balanceOf(address holder) external view returns (uint256) {
208         return data.balance(holder);
209     }
210 
211     /// @return how many attotokens `holder` has allowed `spender` to control.
212     function allowance(address holder, address spender) external view returns (uint256) {
213         return data.allowed(holder, spender);
214     }
215 
216     /// Transfer `value` attotokens from `msg.sender` to `to`.
217     function transfer(address to, uint256 value)
218         external
219         notPaused
220         notFrozen(msg.sender)
221         notFrozen(to)
222         returns (bool)
223     {
224         _transfer(msg.sender, to, value);
225         return true;
226     }
227 
228     /**
229      * Approve `spender` to spend `value` attotokens on behalf of `msg.sender`.
230      *
231      * Beware that changing a nonzero allowance with this method brings the risk that
232      * someone may use both the old and the new allowance by unfortunate transaction ordering. One
233      * way to mitigate this risk is to first reduce the spender's allowance
234      * to 0, and then set the desired value afterwards, per
235      * [this ERC-20 issue](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729).
236      *
237      * A simpler workaround is to use `increaseAllowance` or `decreaseAllowance`, below.
238      *
239      * @param spender address The address which will spend the funds.
240      * @param value uint256 How many attotokens to allow `spender` to spend.
241      */
242     function approve(address spender, uint256 value)
243         external
244         notPaused
245         notFrozen(msg.sender)
246         notFrozen(spender)
247         returns (bool)
248     {
249         _approve(msg.sender, spender, value);
250         return true;
251     }
252 
253     /// Transfer approved tokens from one address to another.
254     /// @param from address The address to send tokens from.
255     /// @param to address The address to send tokens to.
256     /// @param value uint256 The number of attotokens to send.
257     function transferFrom(address from, address to, uint256 value)
258         external
259         notPaused
260         notFrozen(msg.sender)
261         notFrozen(from)
262         notFrozen(to)
263         returns (bool)
264     {
265         _transfer(from, to, value);
266         _approve(from, msg.sender, data.allowed(from, msg.sender).sub(value));
267         return true;
268     }
269 
270     /// Increase `spender`'s allowance of the sender's tokens.
271     /// @dev From MonolithDAO Token.sol
272     /// @param spender The address which will spend the funds.
273     /// @param addedValue How many attotokens to increase the allowance by.
274     function increaseAllowance(address spender, uint256 addedValue)
275         external
276         notPaused
277         notFrozen(msg.sender)
278         notFrozen(spender)
279         returns (bool)
280     {
281         _approve(msg.sender, spender, data.allowed(msg.sender, spender).add(addedValue));
282         return true;
283     }
284 
285     /// Decrease `spender`'s allowance of the sender's tokens.
286     /// @dev From MonolithDAO Token.sol
287     /// @param spender The address which will spend the funds.
288     /// @param subtractedValue How many attotokens to decrease the allowance by.
289     function decreaseAllowance(address spender, uint256 subtractedValue)
290         external
291         notPaused
292         notFrozen(msg.sender)
293         // This is the one case in which changing the allowance of a frozen spender is allowed.
294         // notFrozen(spender)
295         returns (bool)
296     {
297         _approve(msg.sender, spender, data.allowed(msg.sender, spender).sub(subtractedValue));
298         return true;
299     }
300 
301     /// Mint `value` new attotokens to `account`.
302     function mint(address account, uint256 value)
303         external
304         notPaused
305         notFrozen(account)
306         only(minter)
307     {
308         require(account != address(0), "can't mint to address zero");
309 
310         totalSupply = totalSupply.add(value);
311         data.addBalance(account, value);
312         emit Transfer(address(0), account, value);
313     }
314 
315     /// Burn `value` attotokens from `account`, if sender has that much allowance from `account`.
316     function burnFrom(address account, uint256 value)
317         external
318         notPaused
319         notFrozen(account)
320         only(minter)
321     {
322         _burn(account, value);
323         _approve(account, msg.sender, data.allowed(account, msg.sender).sub(value));
324     }
325 
326     /// @dev Transfer of `value` attotokens from `from` to `to`.
327     /// Internal; doesn't check permissions.
328     function _transfer(address from, address to, uint256 value) internal {
329         require(to != address(0), "can't transfer to address zero");
330 
331         data.subBalance(from, value);
332         data.addBalance(to, value);
333         emit Transfer(from, to, value);
334     }
335 
336     /// @dev Burn `value` attotokens from `account`.
337     /// Internal; doesn't check permissions.
338     function _burn(address account, uint256 value) internal {
339         require(account != address(0), "can't burn from address zero");
340 
341         totalSupply = totalSupply.sub(value);
342         data.subBalance(account, value);
343         emit Transfer(account, address(0), value);
344     }
345 
346     /// @dev Set `spender`'s allowance on `holder`'s tokens to `value` attotokens.
347     /// Internal; doesn't check permissions.
348     function _approve(address holder, address spender, uint256 value) internal {
349         require(spender != address(0), "spender cannot be address zero");
350         require(holder != address(0), "holder cannot be address zero");
351 
352         data.setAllowed(holder, spender, value);
353         emit Approval(holder, spender, value);
354     }
355 }
356 
357 contract ReserveDollarEternalStorage {
358 
359     using SafeMath for uint256;
360 
361 
362 
363     // ===== auth =====
364 
365     address public owner;
366     address public escapeHatch;
367 
368     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
369     event EscapeHatchTransferred(address indexed oldEscapeHatch, address indexed newEscapeHatch);
370 
371     /// On construction, set auth fields.
372     constructor(address escapeHatchAddress) public {
373         owner = msg.sender;
374         escapeHatch = escapeHatchAddress;
375     }
376 
377     /// Only run modified function if sent by `owner`.
378     modifier onlyOwner() {
379         require(msg.sender == owner, "onlyOwner");
380         _;
381     }
382 
383     /// Set `owner`.
384     function transferOwnership(address newOwner) external {
385         require(msg.sender == owner || msg.sender == escapeHatch, "not authorized");
386         emit OwnershipTransferred(owner, newOwner);
387         owner = newOwner;
388     }
389 
390     /// Set `escape hatch`.
391     function transferEscapeHatch(address newEscapeHatch) external {
392         require(msg.sender == escapeHatch, "not authorized");
393         emit EscapeHatchTransferred(escapeHatch, newEscapeHatch);
394         escapeHatch = newEscapeHatch;
395     }
396 
397     // ===== balance =====
398 
399     mapping(address => uint256) public balance;
400 
401     /// Add `value` to `balance[key]`, unless this causes integer overflow.
402     ///
403     /// @dev This is a slight divergence from the strict Eternal Storage pattern, but it reduces the gas
404     /// for the by-far most common token usage, it's a *very simple* divergence, and `setBalance` is
405     /// available anyway.
406     function addBalance(address key, uint256 value) external onlyOwner {
407         balance[key] = balance[key].add(value);
408     }
409 
410     /// Subtract `value` from `balance[key]`, unless this causes integer underflow.
411     function subBalance(address key, uint256 value) external onlyOwner {
412         balance[key] = balance[key].sub(value);
413     }
414 
415     /// Set `balance[key]` to `value`.
416     function setBalance(address key, uint256 value) external onlyOwner {
417         balance[key] = value;
418     }
419 
420 
421 
422     // ===== allowed =====
423 
424     mapping(address => mapping(address => uint256)) public allowed;
425 
426     /// Set `to`'s allowance of `from`'s tokens to `value`.
427     function setAllowed(address from, address to, uint256 value) external onlyOwner {
428         allowed[from][to] = value;
429     }
430 
431 
432 
433     // ===== frozenTime =====
434 
435     /// @dev When `frozenTime[addr] == 0`, `addr` is not frozen. This is the normal state.
436     /// When `frozenTime[addr] == t` and `t > 0`, `addr` was last frozen at timestamp `t`.
437     /// So, to unfreeze an address `addr`, set `frozenTime[addr] = 0`.
438     mapping(address => uint256) public frozenTime;
439 
440     /// Set `frozenTime[who]` to `time`.
441     function setFrozenTime(address who, uint256 time) external onlyOwner {
442         frozenTime[who] = time;
443     }
444 }
445 
446 library SafeMath {
447     /**
448      * @dev Multiplies two unsigned integers, reverts on overflow.
449      */
450     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
451         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
452         // benefit is lost if 'b' is also tested.
453         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
454         if (a == 0) {
455             return 0;
456         }
457 
458         uint256 c = a * b;
459         require(c / a == b);
460 
461         return c;
462     }
463 
464     /**
465      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
466      */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         // Solidity only automatically asserts when dividing by 0
469         require(b > 0);
470         uint256 c = a / b;
471         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
472 
473         return c;
474     }
475 
476     /**
477      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
478      */
479     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
480         require(b <= a);
481         uint256 c = a - b;
482 
483         return c;
484     }
485 
486     /**
487      * @dev Adds two unsigned integers, reverts on overflow.
488      */
489     function add(uint256 a, uint256 b) internal pure returns (uint256) {
490         uint256 c = a + b;
491         require(c >= a);
492 
493         return c;
494     }
495 
496     /**
497      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
498      * reverts when dividing by zero.
499      */
500     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
501         require(b != 0);
502         return a % b;
503     }
504 }
1 pragma solidity 0.5.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         require(b <= a);
11         uint256 c = a - b;
12 
13         return c;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a);
19 
20         return c;
21     }
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30 
31     address internal _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor(address initialOwner) internal {
36         _owner = initialOwner;
37         emit OwnershipTransferred(address(0), _owner);
38     }
39 
40     function owner() public view returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(isOwner(msg.sender), "Caller has no permission");
46         _;
47     }
48 
49     function isOwner(address account) public view returns (bool) {
50         return account == _owner;
51     }
52 
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     function transferOwnership(address newOwner) public onlyOwner {
59         require(newOwner != address(0), "New owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 
64 }
65 
66 /**
67  * @title Roles
68  * @dev Library for managing addresses assigned to a Role.
69  */
70 library Roles {
71     struct Role {
72         mapping (address => bool) bearer;
73     }
74 
75     function add(Role storage role, address account) internal {
76         require(!has(role, account), "Roles: account already has role");
77         role.bearer[account] = true;
78     }
79 
80     function remove(Role storage role, address account) internal {
81         require(has(role, account), "Roles: account does not have role");
82         role.bearer[account] = false;
83     }
84 
85     function has(Role storage role, address account) internal view returns (bool) {
86         require(account != address(0), "Roles: account is the zero address");
87         return role.bearer[account];
88     }
89 }
90 
91 contract MinterRole is Ownable {
92     using Roles for Roles.Role;
93 
94     event MinterAdded(address indexed account);
95     event MinterRemoved(address indexed account);
96 
97     Roles.Role private _minters;
98 
99     constructor() internal {
100         _minters.add(_owner);
101         emit MinterAdded(_owner);
102     }
103 
104     modifier onlyMinter() {
105         require(isMinter(msg.sender), "Caller has no permission");
106         _;
107     }
108 
109     function isMinter(address account) public view returns (bool) {
110         return(_minters.has(account) || isOwner(account));
111     }
112 
113     function addMinter(address account) public onlyOwner {
114         _minters.add(account);
115         emit MinterAdded(account);
116     }
117 
118     function removeMinter(address account) public onlyOwner {
119         _minters.remove(account);
120         emit MinterRemoved(account);
121     }
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://eips.ethereum.org/EIPS/eip-20
127  */
128 interface IERC20 {
129     function transfer(address to, uint256 value) external returns (bool);
130     function approve(address spender, uint256 value) external returns (bool);
131     function transferFrom(address from, address to, uint256 value) external returns (bool);
132     function totalSupply() external view returns (uint256);
133     function balanceOf(address who) external view returns (uint256);
134     function allowance(address owner, address spender) external view returns (uint256);
135     event Transfer(address indexed from, address indexed to, uint256 value);
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * See https://eips.ethereum.org/EIPS/eip-20
144  */
145 contract ERC20 is IERC20 {
146     using SafeMath for uint256;
147 
148     mapping (address => uint256) private _balances;
149 
150     mapping (address => mapping (address => uint256)) private _allowed;
151 
152     uint256 private _totalSupply;
153 
154     function totalSupply() public view returns (uint256) {
155         return _totalSupply;
156     }
157 
158     function balanceOf(address owner) public view returns (uint256) {
159         return _balances[owner];
160     }
161 
162     function allowance(address owner, address spender) public view returns (uint256) {
163         return _allowed[owner][spender];
164     }
165 
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _transfer(from, to, value);
178         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
189         return true;
190     }
191 
192     function _transfer(address from, address to, uint256 value) internal {
193         require(to != address(0));
194 
195         _balances[from] = _balances[from].sub(value);
196         _balances[to] = _balances[to].add(value);
197         emit Transfer(from, to, value);
198     }
199 
200     function _mint(address account, uint256 value) internal {
201         require(account != address(0));
202 
203         _totalSupply = _totalSupply.add(value);
204         _balances[account] = _balances[account].add(value);
205         emit Transfer(address(0), account, value);
206     }
207 
208     function _approve(address owner, address spender, uint256 value) internal {
209         require(spender != address(0));
210         require(owner != address(0));
211 
212         _allowed[owner][spender] = value;
213         emit Approval(owner, spender, value);
214     }
215 
216     function _burn(address account, uint256 amount) internal {
217         require(account != address(0));
218 
219         _balances[account] = _balances[account].sub(amount);
220         _totalSupply = _totalSupply.sub(amount);
221         emit Transfer(account, address(0), amount);
222     }
223 
224     function _burnFrom(address account, uint256 amount) internal {
225         _burn(account, amount);
226         _approve(account, msg.sender, _allowed[account][msg.sender].sub(amount));
227     }
228 
229 }
230 
231 /**
232  * @dev BurnableToken
233  */
234 contract BurnableToken is ERC20 {
235 
236     function burn(uint256 amount) public {
237         _burn(msg.sender, amount);
238     }
239 
240     function burnFrom(address account, uint256 amount) public {
241         _burnFrom(account, amount);
242     }
243 
244 }
245 
246 /**
247  * @dev MintableToken
248  */
249 contract MintableToken is BurnableToken, MinterRole {
250 
251     bool public mintingFinished;
252 
253     modifier canMint() {
254         require(!mintingFinished);
255         _;
256     }
257 
258     function mint(address account, uint256 amount) public onlyMinter canMint returns (bool) {
259         _mint(account, amount);
260         return true;
261     }
262 
263     function finishMinting() external onlyOwner canMint {
264         mintingFinished = true;
265     }
266 
267 }
268 
269 /**
270  * @title LockableToken
271  */
272 contract LockableToken is MintableToken {
273 
274     mapping (address => uint256) private _locked;
275 
276     event Locked(address indexed account, uint256 amount, address indexed by);
277     event Unlocked(address indexed account, uint256 amount, address indexed by);
278 
279     /**
280      * @dev prevent any transfer of locked tokens.
281      */
282     modifier canTransfer(address from, uint256 value) {
283         if (_locked[from] > 0) {
284             require(balanceOf(from).sub(value) >= _locked[from]);
285         }
286         _;
287     }
288 
289     /**
290      * @dev lock tokens of array of addresses.
291      * Available only to the owner.
292      * @param accounts array of addresses.
293      * @param amounts array of amounts of tokens.
294      */
295     function lock(address[] calldata accounts, uint256[] calldata amounts) external onlyOwner {
296         for (uint256 i = 0; i < accounts.length; i++) {
297             _locked[accounts[i]] = _locked[accounts[i]].add(amounts[i]);
298             emit Locked(accounts[i], amounts[i], msg.sender);
299         }
300     }
301 
302     /**
303      * @dev unlock tokens of array of addresses.
304      * Available only to the owner.
305      * @param accounts array of addresses.
306      * @param amounts array of amounts of tokens.
307      */
308     function unlock(address[] calldata accounts, uint256[] calldata amounts) external onlyOwner {
309         for (uint256 i = 0; i < accounts.length; i++) {
310             _locked[accounts[i]] = _locked[accounts[i]].sub(amounts[i]);
311             emit Unlocked(accounts[i], amounts[i], msg.sender);
312         }
313     }
314 
315     /**
316      * @dev amount of locked tokens of specific address.
317      * @param account holder address.
318      * @return amount of locked tokens.
319      */
320     function lockedOf(address account) external view returns(uint256) {
321         return _locked[account];
322     }
323 
324     /**
325      * @dev modified internal transfer function that prevents any transfer of locked tokens.
326      * @param from address The address which you want to send tokens from.
327      * @param to The address to transfer to.
328      * @param value The amount to be transferred.
329      */
330     function _transfer(address from, address to, uint256 value) internal canTransfer(from, value) {
331         super._transfer(from, to, value);
332     }
333 
334 }
335 
336 /**
337  * @title ApproveAndCall Interface.
338  * @dev ApproveAndCall system allows to communicate with smart-contracts.
339  */
340 interface ApproveAndCallFallBack {
341     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
342 }
343 
344 /**
345  * @title The ASECToken project contract.
346  * @author https://grox.solutions
347  */
348 contract ASECToken is LockableToken {
349 
350     // name of the token
351     string private _name = "ASEC";
352     // symbol of the token
353     string private _symbol = "ASEC";
354     // decimals of the token
355     uint8 private _decimals = 8;
356 
357     // initial supply
358     uint256 internal constant INITIAL_SUPPLY = 3000000000 * (10 ** 8);
359 
360     // registered contracts (to prevent loss of token via transfer function)
361     mapping (address => bool) private _contracts;
362 
363     /**
364      * @dev constructor function that is called once at deployment of the contract.
365      * @param recipient Address to receive initial supply.
366      */
367     constructor(address recipient, address initialOwner) public Ownable(initialOwner) {
368 
369         _mint(recipient, INITIAL_SUPPLY);
370 
371     }
372 
373     /**
374      * @dev Allows to send tokens (via Approve and TransferFrom) to other smart contract.
375      * @param spender Address of smart contracts to work with.
376      * @param amount Amount of tokens to send.
377      * @param extraData Any extra data.
378      */
379     function approveAndCall(address spender, uint256 amount, bytes memory extraData) public returns (bool) {
380         require(approve(spender, amount));
381 
382         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
383 
384         return true;
385     }
386 
387     /**
388      * @dev Allows to register other smart contracts (to prevent loss of tokens via transfer function).
389      * @param addr Address of smart contracts to work with.
390      */
391     function registerContract(address addr) public onlyOwner {
392         require(isContract(addr));
393         _contracts[addr] = true;
394     }
395 
396     /**
397      * @dev Allows to unregister registered smart contracts.
398      * @param addr Address of smart contracts to work with.
399      */
400     function unregisterContract(address addr) external onlyOwner {
401         _contracts[addr] = false;
402     }
403 
404     /**
405      * @dev modified transfer function that allows to safely send tokens to smart contract.
406      * @param to The address to transfer to.
407      * @param value The amount to be transferred.
408      */
409     function transfer(address to, uint256 value) public returns (bool) {
410 
411         if (_contracts[to]) {
412             approveAndCall(to, value, new bytes(0));
413         } else {
414             super.transfer(to, value);
415         }
416 
417         return true;
418 
419     }
420 
421     /**
422      * @dev modified transferFrom function that allows to safely send tokens to exchange contract.
423      * @param from address The address which you want to send tokens from
424      * @param to address The address which you want to transfer to
425      * @param value uint256 the amount of tokens to be transferred
426      */
427     function transferFrom(address from, address to, uint256 value) public returns (bool) {
428 
429         if (_contracts[to] && !_contracts[msg.sender]) {
430             ApproveAndCallFallBack(to).receiveApproval(msg.sender, value, address(this), new bytes(0));
431         } else {
432             super.transferFrom(from, to, value);
433         }
434 
435         return true;
436     }
437 
438     /**
439      * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
440      * @param ERC20Token Address of ERC20 token.
441      * @param recipient Account to receive tokens.
442      */
443     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
444 
445         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
446         IERC20(ERC20Token).transfer(recipient, amount);
447 
448     }
449 
450     /**
451      * @return the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @return the symbol of the token.
459      */
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     /**
465      * @return the number of decimals of the token.
466      */
467     function decimals() public view returns (uint8) {
468         return _decimals;
469     }
470 
471     /**
472      * @return true if the address is a сontract
473      */
474     function isContract(address addr) internal view returns (bool) {
475         uint size;
476         assembly { size := extcodesize(addr) }
477         return size > 0;
478     }
479 
480 }
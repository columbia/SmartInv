1 pragma solidity ^0.5.10;
2 
3 library Address {
4     function isContract(address account) internal view returns (bool) {
5         uint256 size;
6         assembly { size := extcodesize(account) }
7         return size > 0;
8     }
9 }
10 
11 library ERC165Checker {
12     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
13 
14     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
15 
16     function _supportsERC165(address account) internal view returns (bool) {
17         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
18         !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
19     }
20 
21     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
22         return _supportsERC165(account) &&
23         _supportsERC165Interface(account, interfaceId);
24     }
25 
26     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
27         if (!_supportsERC165(account)) {
28             return false;
29         }
30 
31         for (uint256 i = 0; i < interfaceIds.length; i++) {
32             if (!_supportsERC165Interface(account, interfaceIds[i])) {
33                 return false;
34             }
35         }
36 
37         return true;
38     }
39 
40     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
41         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
42 
43         return (success && result);
44     }
45 
46     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
47     private
48     view
49     returns (bool success, bool result)
50     {
51         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
52 
53         // solhint-disable-next-line no-inline-assembly
54         assembly {
55             let encodedParams_data := add(0x20, encodedParams)
56             let encodedParams_size := mload(encodedParams)
57 
58             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
59             mstore(output, 0x0)
60 
61             success := staticcall(
62             30000,                   // 30k gas
63             account,                 // To addr
64             encodedParams_data,
65             encodedParams_size,
66             output,
67             0x20                     // Outputs are 32 bytes long
68             )
69 
70             result := mload(output)      // Load the result
71         }
72     }
73 }
74 interface IERC20 {
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89 
90         return c;
91     }
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b <= a, "SafeMath: subtraction overflow");
94         uint256 c = a - b;
95 
96         return c;
97     }
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         require(b > 0, "SafeMath: division by zero");
110         uint256 c = a / b;
111 
112         return c;
113     }
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b != 0, "SafeMath: modulo by zero");
116         return a % b;
117     }
118 }
119 
120 contract ERC20 is IERC20 {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) private _balances;
124 
125     mapping (address => mapping (address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132     function balanceOf(address account) public view returns (uint256) {
133         return _balances[account];
134     }
135     function transfer(address recipient, uint256 amount) public returns (bool) {
136         _transfer(msg.sender, recipient, amount);
137         return true;
138     }
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowances[owner][spender];
141     }
142     function approve(address spender, uint256 value) public returns (bool) {
143         _approve(msg.sender, spender, value);
144         return true;
145     }
146     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
147         _transfer(sender, recipient, amount);
148         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
149         return true;
150     }
151     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
152         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
153         return true;
154     }
155     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
156         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
157         return true;
158     }
159     function _transfer(address sender, address recipient, uint256 amount) internal {
160         require(sender != address(0), "ERC20: transfer from the zero address");
161         require(recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _balances[sender] = _balances[sender].sub(amount);
164         _balances[recipient] = _balances[recipient].add(amount);
165         emit Transfer(sender, recipient, amount);
166     }
167     function _mint(address account, uint256 amount) internal {
168         require(account != address(0), "ERC20: mint to the zero address");
169 
170         _totalSupply = _totalSupply.add(amount);
171         _balances[account] = _balances[account].add(amount);
172         emit Transfer(address(0), account, amount);
173     }
174     function _burn(address account, uint256 value) internal {
175         require(account != address(0), "ERC20: burn from the zero address");
176 
177         _totalSupply = _totalSupply.sub(value);
178         _balances[account] = _balances[account].sub(value);
179         emit Transfer(account, address(0), value);
180     }
181 
182     function _approve(address owner, address spender, uint256 value) internal {
183         require(owner != address(0), "ERC20: approve from the zero address");
184         require(spender != address(0), "ERC20: approve to the zero address");
185 
186         _allowances[owner][spender] = value;
187         emit Approval(owner, spender, value);
188     }
189     function _burnFrom(address account, uint256 amount) internal {
190         _burn(account, amount);
191         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
192     }
193 }
194 
195 interface IERC165 {
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 }
198 
199 contract ERC165 is IERC165 {
200     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
201 
202     mapping(bytes4 => bool) private _supportedInterfaces;
203 
204     constructor () internal {
205         // Derived contracts need only register support for their own interfaces,
206         // we register support for ERC165 itself here
207         _registerInterface(_INTERFACE_ID_ERC165);
208     }
209 
210     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
211         return _supportedInterfaces[interfaceId];
212     }
213 
214     function _registerInterface(bytes4 interfaceId) internal {
215         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
216         _supportedInterfaces[interfaceId] = true;
217     }
218 }
219 
220 contract IERC1363 is IERC20, ERC165 {
221     function transferAndCall(address to, uint256 value) public returns (bool);
222 
223     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
224 
225     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
226 
227     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
228 
229     function approveAndCall(address spender, uint256 value) public returns (bool);
230 
231     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
232 }
233 
234 contract IERC1363Receiver {
235     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
236 }
237 
238 contract IERC1363Spender {
239     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
240 }
241 
242 contract ERC1363 is ERC20, IERC1363 {
243     using Address for address;
244 
245     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
246 
247     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
248 
249     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
250 
251     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
252 
253     constructor() public {
254         // register the supported interfaces to conform to ERC1363 via ERC165
255         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
256         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
257     }
258     function transferAndCall(address to, uint256 value) public returns (bool) {
259         return transferAndCall(to, value, "");
260     }
261     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
262         require(transfer(to, value));
263         require(_checkAndCallTransfer(msg.sender, to, value, data));
264         return true;
265     }
266     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
267         return transferFromAndCall(from, to, value, "");
268     }
269     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
270         require(transferFrom(from, to, value));
271         require(_checkAndCallTransfer(from, to, value, data));
272         return true;
273     }
274     function approveAndCall(address spender, uint256 value) public returns (bool) {
275         return approveAndCall(spender, value, "");
276     }
277     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
278         approve(spender, value);
279         require(_checkAndCallApprove(spender, value, data));
280         return true;
281     }
282     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
283         if (!to.isContract()) {
284             return false;
285         }
286         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
287             msg.sender, from, value, data
288         );
289         return (retval == _ERC1363_RECEIVED);
290     }
291     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
292         if (!spender.isContract()) {
293             return false;
294         }
295         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
296             msg.sender, value, data
297         );
298         return (retval == _ERC1363_APPROVED);
299     }
300 }
301 
302 contract ERC20Detailed is IERC20 {
303     string private _name;
304     string private _symbol;
305     uint8 private _decimals;
306     constructor (string memory name, string memory symbol, uint8 decimals) public {
307         _name = name;
308         _symbol = symbol;
309         _decimals = decimals;
310     }
311     function name() public view returns (string memory) {
312         return _name;
313     }
314     function symbol() public view returns (string memory) {
315         return _symbol;
316     }
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 }
321 
322 library Roles {
323     struct Role {
324         mapping (address => bool) bearer;
325     }
326     function add(Role storage role, address account) internal {
327         require(!has(role, account), "Roles: account already has role");
328         role.bearer[account] = true;
329     }
330     function remove(Role storage role, address account) internal {
331         require(has(role, account), "Roles: account does not have role");
332         role.bearer[account] = false;
333     }
334     function has(Role storage role, address account) internal view returns (bool) {
335         require(account != address(0), "Roles: account is the zero address");
336         return role.bearer[account];
337     }
338 }
339 
340 contract MinterRole {
341     using Roles for Roles.Role;
342 
343     event MinterAdded(address indexed account);
344     event MinterRemoved(address indexed account);
345 
346     Roles.Role private _minters;
347 
348     constructor () internal {
349         _addMinter(msg.sender);
350     }
351     modifier onlyMinter() {
352         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
353         _;
354     }
355     function isMinter(address account) public view returns (bool) {
356         return _minters.has(account);
357     }
358     function addMinter(address account) public onlyMinter {
359         _addMinter(account);
360     }
361     function renounceMinter() public {
362         _removeMinter(msg.sender);
363     }
364     function _addMinter(address account) internal {
365         _minters.add(account);
366         emit MinterAdded(account);
367     }
368     function _removeMinter(address account) internal {
369         _minters.remove(account);
370         emit MinterRemoved(account);
371     }
372 }
373 
374 contract ERC20Mintable is ERC20, MinterRole {
375     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
376         _mint(account, amount);
377         return true;
378     }
379 }
380 
381 contract ERC20Capped is ERC20Mintable {
382     uint256 private _cap;
383     constructor (uint256 cap) public {
384         require(cap > 0, "ERC20Capped: cap is 0");
385         _cap = cap;
386     }
387     function cap() public view returns (uint256) {
388         return _cap;
389     }
390     function _mint(address account, uint256 value) internal {
391         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
392         super._mint(account, value);
393     }
394 }
395 
396 contract ERC20Burnable is ERC20 {
397     function burn(uint256 amount) public {
398         _burn(msg.sender, amount);
399     }
400     function burnFrom(address account, uint256 amount) public {
401         _burnFrom(account, amount);
402     }
403 }
404 
405 contract Ownable {
406     address private _owner;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     constructor () internal {
411         _owner = msg.sender;
412         emit OwnershipTransferred(address(0), _owner);
413     }
414     function owner() public view returns (address) {
415         return _owner;
416     }
417     modifier onlyOwner() {
418         require(isOwner(), "Ownable: caller is not the owner");
419         _;
420     }
421     function isOwner() public view returns (bool) {
422         return msg.sender == _owner;
423     }
424     function renounceOwnership() public onlyOwner {
425         emit OwnershipTransferred(_owner, address(0));
426         _owner = address(0);
427     }
428     function transferOwnership(address newOwner) public onlyOwner {
429         _transferOwnership(newOwner);
430     }
431     function _transferOwnership(address newOwner) internal {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         emit OwnershipTransferred(_owner, newOwner);
434         _owner = newOwner;
435     }
436 }
437 
438 contract TokenRecover is Ownable {
439     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
440         IERC20(tokenAddress).transfer(owner(), tokenAmount);
441     }
442 }
443 
444 
445 contract OperatorRole {
446     using Roles for Roles.Role;
447 
448     event OperatorAdded(address indexed account);
449     event OperatorRemoved(address indexed account);
450 
451     Roles.Role private _operators;
452 
453     constructor() internal {
454         _addOperator(msg.sender);
455     }
456     modifier onlyOperator() {
457         require(isOperator(msg.sender));
458         _;
459     }
460     function isOperator(address account) public view returns (bool) {
461         return _operators.has(account);
462     }
463     function addOperator(address account) public onlyOperator {
464         _addOperator(account);
465     }
466     function renounceOperator() public {
467         _removeOperator(msg.sender);
468     }
469     function _addOperator(address account) internal {
470         _operators.add(account);
471         emit OperatorAdded(account);
472     }
473     function _removeOperator(address account) internal {
474         _operators.remove(account);
475         emit OperatorRemoved(account);
476     }
477 }
478 
479 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
480     event MintFinished();
481     event TransferEnabled();
482     bool private _mintingFinished = false;
483     bool private _transferEnabled = false;
484     modifier canMint() {
485         require(!_mintingFinished);
486         _;
487     }
488     modifier canTransfer(address from) {
489         require(_transferEnabled || isOperator(from));
490         _;
491     }
492     constructor(
493         string memory name,
494         string memory symbol,
495         uint8 decimals,
496         uint256 cap,
497         uint256 initialSupply
498     )
499     public
500     ERC20Detailed(name, symbol, decimals)
501     ERC20Capped(cap)
502     {
503         if (initialSupply > 0) {
504             _mint(owner(), initialSupply);
505         }
506     }
507     function mintingFinished() public view returns (bool) {
508         return _mintingFinished;
509     }
510     function transferEnabled() public view returns (bool) {
511         return _transferEnabled;
512     }
513     function mint(address to, uint256 value) public canMint returns (bool) {
514         return super.mint(to, value);
515     }
516     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
517         return super.transfer(to, value);
518     }
519     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
520         return super.transferFrom(from, to, value);
521     }
522     function finishMinting() public onlyOwner canMint {
523         _mintingFinished = true;
524 
525         emit MintFinished();
526     }
527     function enableTransfer() public onlyOwner {
528         _transferEnabled = true;
529 
530         emit TransferEnabled();
531     }
532     function removeOperator(address account) public onlyOwner {
533         _removeOperator(account);
534     }
535     function removeMinter(address account) public onlyOwner {
536         _removeMinter(account);
537     }
538 }
539 
540 contract BaseERC1363Token is BaseERC20Token, ERC1363 {
541     constructor(
542         string memory name,
543         string memory symbol,
544         uint8 decimals,
545         uint256 cap,
546         uint256 initialSupply
547     )
548     public
549     BaseERC20Token(name, symbol, decimals, cap, initialSupply)
550     {} // solhint-disable-line no-empty-blocks
551 }
552 
553 contract ERC20Token is BaseERC1363Token {
554     constructor(
555         string memory name,
556         string memory symbol,
557         uint8 decimals,
558         uint256 cap,
559         uint256 initialSupply,
560         bool transferEnabled
561     )
562     public
563     BaseERC1363Token(name, symbol, decimals, cap, initialSupply)
564     {
565         if (transferEnabled) {
566             enableTransfer();
567         }
568     }
569 }
1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-27
3 */
4 
5 pragma solidity ^0.5.11;
6 
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b <= a, "SafeMath: subtraction overflow");
18         uint256 c = a - b;
19 
20         return c;
21     }
22 }
23 
24 contract AccountFrozenBalances {
25     using SafeMath for uint256;
26 
27     mapping (address => uint256) private frozen_balances;
28 
29     function _frozen_add(address _account, uint256 _amount) internal returns (bool) {
30         frozen_balances[_account] = frozen_balances[_account].add(_amount);
31         return true;
32     }
33 
34     function _frozen_sub(address _account, uint256 _amount) internal returns (bool) {
35         frozen_balances[_account] = frozen_balances[_account].sub(_amount);
36         return true;
37     }
38 
39     function _frozen_balanceOf(address _account) internal view returns (uint) {
40         return frozen_balances[_account];
41     }
42 }
43 
44 contract Ownable {
45     address private _owner;
46     address public pendingOwner;
47 
48     modifier onlyOwner() {
49         require(msg.sender == _owner, "caller is not the owner");
50         _;
51     }
52 
53     modifier onlyPendingOwner() {
54         require(msg.sender == pendingOwner);
55         _;
56     }
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     constructor () internal {
61         _owner = msg.sender;
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         pendingOwner = newOwner;
70     }
71 
72     function claimOwnership() public onlyPendingOwner {
73         emit OwnershipTransferred(_owner, pendingOwner);
74         _owner = pendingOwner;
75         pendingOwner = address(0);
76     }
77 }
78 
79 contract Whitelisted {
80     address private _whitelistadmin;
81     address public pendingWhiteListAdmin;
82 
83     mapping (address => bool) private _whitelisted;
84 
85     modifier onlyWhitelistAdmin() {
86         require(msg.sender == _whitelistadmin, "caller is not admin of whitelist");
87         _;
88     }
89 
90     modifier onlyPendingWhitelistAdmin() {
91         require(msg.sender == pendingWhiteListAdmin);
92         _;
93     }
94 
95     event WhitelistAdminTransferred(address indexed previousAdmin, address indexed newAdmin);
96 
97     constructor () internal {
98         _whitelistadmin = msg.sender;
99         _whitelisted[msg.sender] = true;
100     }
101 
102     function whitelistadmin() public view returns (address){
103         return _whitelistadmin;
104     }
105     function addWhitelisted(address account) public onlyWhitelistAdmin {
106         _whitelisted[account] = true;
107     }
108 
109     function removeWhitelisted(address account) public onlyWhitelistAdmin {
110         _whitelisted[account] = false;
111     }
112 
113     function isWhitelisted(address account) public view returns (bool) {
114         return _whitelisted[account];
115     }
116 
117     function transferWhitelistAdmin(address newAdmin) public onlyWhitelistAdmin {
118         pendingWhiteListAdmin = newAdmin;
119     }
120 
121     function claimWhitelistAdmin() public onlyPendingWhitelistAdmin {
122         emit WhitelistAdminTransferred(_whitelistadmin, pendingWhiteListAdmin);
123         _whitelistadmin = pendingWhiteListAdmin;
124         pendingWhiteListAdmin = address(0);
125     }
126 }
127 
128 contract Burnable {
129     bool private _burnallow;
130     address private _burner;
131     address public pendingBurner;
132 
133     modifier whenBurn() {
134         require(_burnallow, "burnable: can't burn");
135         _;
136     }
137 
138     modifier onlyBurner() {
139         require(msg.sender == _burner, "caller is not a burner");
140         _;
141     }
142 
143     modifier onlyPendingBurner() {
144         require(msg.sender == pendingBurner);
145         _;
146     }
147 
148     event BurnerTransferred(address indexed previousBurner, address indexed newBurner);
149 
150     constructor () internal {
151         _burnallow = true;
152         _burner = msg.sender;
153     }
154 
155     function burnallow() public view returns (bool) {
156         return _burnallow;
157     }
158 
159     function burner() public view returns (address) {
160         return _burner;
161     }
162 
163     function burnTrigger() public onlyBurner {
164         _burnallow = !_burnallow;
165     }
166 
167     function transferWhitelistAdmin(address newBurner) public onlyBurner {
168         pendingBurner = newBurner;
169     }
170 
171     function claimBurner() public onlyPendingBurner {
172         emit BurnerTransferred(_burner, pendingBurner);
173         _burner = pendingBurner;
174         pendingBurner = address(0);
175     }
176 }
177 
178 contract Meltable {
179     mapping (address => bool) private _melters;
180     address private _melteradmin;
181     address public pendingMelterAdmin;
182 
183     modifier onlyMelterAdmin() {
184         require (msg.sender == _melteradmin, "caller not a melter admin");
185         _;
186     }
187 
188     modifier onlyMelter() {
189         require (_melters[msg.sender] == true, "can't perform melt");
190         _;
191     }
192 
193     modifier onlyPendingMelterAdmin() {
194         require(msg.sender == pendingMelterAdmin);
195         _;
196     }
197 
198     event MelterTransferred(address indexed previousMelter, address indexed newMelter);
199 
200     constructor () internal {
201         _melteradmin = msg.sender;
202         _melters[msg.sender] = true;
203     }
204 
205     function melteradmin() public view returns (address) {
206         return _melteradmin;
207     }
208 
209     function addToMelters(address account) public onlyMelterAdmin {
210         _melters[account] = true;
211     }
212 
213     function removeFromMelters(address account) public onlyMelterAdmin {
214         _melters[account] = false;
215     }
216 
217     function transferMelterAdmin(address newMelter) public onlyMelterAdmin {
218         pendingMelterAdmin = newMelter;
219     }
220 
221     function claimMelterAdmin() public onlyPendingMelterAdmin {
222         emit MelterTransferred(_melteradmin, pendingMelterAdmin);
223         _melteradmin = pendingMelterAdmin;
224         pendingMelterAdmin = address(0);
225     }
226 }
227 
228 contract Mintable {
229     mapping (address => bool) private _minters;
230     address private _minteradmin;
231     address public pendingMinterAdmin;
232 
233 
234     modifier onlyMinterAdmin() {
235         require (msg.sender == _minteradmin, "caller not a minter admin");
236         _;
237     }
238 
239     modifier onlyMinter() {
240         require (_minters[msg.sender] == true, "can't perform mint");
241         _;
242     }
243 
244     modifier onlyPendingMinterAdmin() {
245         require(msg.sender == pendingMinterAdmin);
246         _;
247     }
248 
249     event MinterTransferred(address indexed previousMinter, address indexed newMinter);
250 
251     constructor () internal {
252         _minteradmin = msg.sender;
253         _minters[msg.sender] = true;
254     }
255 
256     function minteradmin() public view returns (address) {
257         return _minteradmin;
258     }
259 
260     function addToMinters(address account) public onlyMinterAdmin {
261         _minters[account] = true;
262     }
263 
264     function removeFromMinters(address account) public onlyMinterAdmin {
265         _minters[account] = false;
266     }
267 
268     function transferMinterAdmin(address newMinter) public onlyMinterAdmin {
269         pendingMinterAdmin = newMinter;
270     }
271 
272     function claimMinterAdmin() public onlyPendingMinterAdmin {
273         emit MinterTransferred(_minteradmin, pendingMinterAdmin);
274         _minteradmin = pendingMinterAdmin;
275         pendingMinterAdmin = address(0);
276     }
277 }
278 
279 contract Pausable {
280     bool private _paused;
281     address private _pauser;
282     address public pendingPauser;
283 
284     modifier onlyPauser() {
285         require(msg.sender == _pauser, "caller is not a pauser");
286         _;
287     }
288 
289     modifier onlyPendingPauser() {
290         require(msg.sender == pendingPauser);
291         _;
292     }
293 
294     event PauserTransferred(address indexed previousPauser, address indexed newPauser);
295 
296 
297     constructor () internal {
298         _paused = false;
299         _pauser = msg.sender;
300     }
301 
302     function paused() public view returns (bool) {
303         return _paused;
304     }
305 
306     function pauser() public view returns (address) {
307         return _pauser;
308     }
309 
310     function pauseTrigger() public onlyPauser {
311         _paused = !_paused;
312     }
313 
314     function transferPauser(address newPauser) public onlyPauser {
315         pendingPauser = newPauser;
316     }
317 
318     function claimPauser() public onlyPendingPauser {
319         emit PauserTransferred(_pauser, pendingPauser);
320         _pauser = pendingPauser;
321         pendingPauser = address(0);
322     }
323 }
324 
325 contract TokenRecipient {
326     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
327 }
328 
329 contract GuardianToken is AccountFrozenBalances, Ownable, Whitelisted, Burnable, Pausable, Mintable, Meltable {
330     using SafeMath for uint256;
331 
332     string public name;
333     string public symbol;
334     uint8 public decimals;
335 
336 
337     mapping (address => uint256) private _balances;
338     mapping (address => mapping (address => uint256)) private _allowances;
339     uint256 private _totalSupply;
340 
341 
342     modifier canTransfer() {
343         if(paused()){
344             require (isWhitelisted(msg.sender) == true, "can't perform an action");
345         }
346         _;
347     }
348 
349     event Transfer(address indexed from, address indexed to, uint256 value);
350     event Approval(address indexed owner, address indexed spender, uint256 value);
351 
352     event Freeze(address indexed from, uint256 amount);
353     event Melt(address indexed from, uint256 amount);
354     event MintFrozen(address indexed to, uint256 amount);
355     event FrozenTransfer(address indexed from, address indexed to, uint256 value);
356 
357     constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
358         name = _name;
359         symbol = _symbol;
360         decimals = _decimals;
361         mint(msg.sender, 800000000000000);
362     }
363 
364     function totalSupply() public view returns (uint256) {
365         return _totalSupply;
366     }
367 
368     function balanceOf(address account) public view returns (uint256) {
369         return _balances[account].add(_frozen_balanceOf(account));
370     }
371 
372     function transfer(address recipient, uint256 amount) public canTransfer returns (bool) {
373         require(recipient != address(this), "can't transfer tokens to the contract address");
374 
375         _transfer(msg.sender, recipient, amount);
376         return true;
377     }
378 
379     function allowance(address _owner, address spender) public view returns (uint256) {
380         return _allowances[_owner][spender];
381     }
382 
383     function approve(address spender, uint256 value) public returns (bool) {
384         _approve(msg.sender, spender, value);
385         return true;
386     }
387 
388     /* Approve and then communicate the approved contract in a single tx */
389     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
390         TokenRecipient spender = TokenRecipient(_spender);
391         if (approve(_spender, _value)) {
392             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
393             return true;
394         } else {
395             return false;
396         }
397     }
398 
399     function transferFrom(address sender, address recipient, uint256 amount) public canTransfer returns (bool) {
400         require(recipient != address(this), "can't transfer tokens to the contract address");
401 
402         _transfer(sender, recipient, amount);
403         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
404         return true;
405     }
406 
407 
408     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
409         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
410         return true;
411     }
412 
413 
414     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
415         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
416         return true;
417     }
418 
419     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
420         _mint(account, amount);
421         return true;
422     }
423 
424     function burn(uint256 amount) public whenBurn {
425         _burn(msg.sender, amount);
426     }
427 
428     function burnFrom(address account, uint256 amount) public whenBurn {
429         _burnFrom(account, amount);
430     }
431 
432     function destroy(address account, uint256 amount) public onlyOwner {
433         _burn(account, amount);
434     }
435 
436     function destroyFrozen(address account, uint256 amount) public onlyOwner {
437         _burnFrozen(account, amount);
438     }
439 
440     function mintBatchToken(address[] calldata accounts, uint256[] calldata amounts) external onlyMinter returns (bool) {
441         require(accounts.length > 0, "mintBatchToken: transfer should be to at least one address");
442         require(accounts.length == amounts.length, "mintBatchToken: recipients.length != amounts.length");
443         for (uint256 i = 0; i < accounts.length; i++) {
444             _mint(accounts[i], amounts[i]);
445         }
446 
447         return true;
448     }
449 
450     function transferFrozenToken(address from, address to, uint256 amount) public onlyOwner returns (bool) {
451         require(from != address(0), "ERC20: transfer from the zero address");
452         require(to != address(0), "ERC20: transfer to the zero address");
453 
454         _frozen_sub(from, amount);
455         _frozen_add(to, amount);
456 
457         emit FrozenTransfer(from, to, amount);
458         emit Transfer(from, to, amount);
459 
460         return true;
461     }
462 
463     function freezeTokens(address account, uint256 amount) public onlyOwner returns (bool) {
464         _freeze(account, amount);
465         emit Transfer(account, address(this), amount);
466         return true;
467     }
468 
469     function meltTokens(address account, uint256 amount) public onlyMelter returns (bool) {
470         _melt(account, amount);
471         emit Transfer(address(this), account, amount);
472         return true;
473     }
474 
475     function mintFrozenTokens(address account, uint256 amount) public onlyMinter returns (bool) {
476         _mintfrozen(account, amount);
477         return true;
478     }
479 
480     function mintBatchFrozenTokens(address[] calldata accounts, uint256[] calldata amounts) external onlyMinter returns (bool) {
481         require(accounts.length > 0, "mintBatchFrozenTokens: transfer should be to at least one address");
482         require(accounts.length == amounts.length, "mintBatchFrozenTokens: recipients.length != amounts.length");
483         for (uint256 i = 0; i < accounts.length; i++) {
484             _mintfrozen(accounts[i], amounts[i]);
485         }
486 
487         return true;
488     }
489 
490     function meltBatchTokens(address[] calldata accounts, uint256[] calldata amounts) external onlyMelter returns (bool) {
491         require(accounts.length > 0, "mintBatchFrozenTokens: transfer should be to at least one address");
492         require(accounts.length == amounts.length, "mintBatchFrozenTokens: recipients.length != amounts.length");
493         for (uint256 i = 0; i < accounts.length; i++) {
494             _melt(accounts[i], amounts[i]);
495             emit Transfer(address(this), accounts[i], amounts[i]);
496         }
497 
498         return true;
499     }
500 
501     function _transfer(address sender, address recipient, uint256 amount) internal {
502         require(sender != address(0), "ERC20: transfer from the zero address");
503         require(recipient != address(0), "ERC20: transfer to the zero address");
504 
505         _balances[sender] = _balances[sender].sub(amount);
506         _balances[recipient] = _balances[recipient].add(amount);
507         emit Transfer(sender, recipient, amount);
508     }
509 
510 
511     function _mint(address account, uint256 amount) internal {
512         require(account != address(0), "ERC20: mint to the zero address");
513         require(account != address(this), "ERC20: mint to the contract address");
514         require(amount > 0, "ERC20: mint amount should be > 0");
515 
516         _totalSupply = _totalSupply.add(amount);
517         _balances[account] = _balances[account].add(amount);
518         emit Transfer(address(this), account, amount);
519     }
520 
521     function _burn(address account, uint256 value) internal {
522         require(account != address(0), "ERC20: burn from the zero address");
523 
524         _totalSupply = _totalSupply.sub(value);
525         _balances[account] = _balances[account].sub(value);
526         emit Transfer(account, address(this), value);
527     }
528 
529     function _approve(address _owner, address spender, uint256 value) internal {
530         require(_owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[_owner][spender] = value;
534         emit Approval(_owner, spender, value);
535     }
536 
537     function _burnFrom(address account, uint256 amount) internal {
538         _burn(account, amount);
539         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
540     }
541 
542     function _freeze(address account, uint256 amount) internal {
543         require(account != address(0), "ERC20: freeze from the zero address");
544         require(amount > 0, "ERC20: freeze from the address: amount should be > 0");
545 
546         _balances[account] = _balances[account].sub(amount);
547         _frozen_add(account, amount);
548 
549         emit Freeze(account, amount);
550     }
551 
552     function _mintfrozen(address account, uint256 amount) internal {
553         require(account != address(0), "ERC20: mint frozen to the zero address");
554         require(account != address(this), "ERC20: mint frozen to the contract address");
555         require(amount > 0, "ERC20: mint frozen amount should be > 0");
556 
557         _totalSupply = _totalSupply.add(amount);
558 
559         emit Transfer(address(this), account, amount);
560 
561         _frozen_add(account, amount);
562 
563         emit MintFrozen(account, amount);
564     }
565 
566     function _melt(address account, uint256 amount) internal {
567         require(account != address(0), "ERC20: melt from the zero address");
568         require(amount > 0, "ERC20: melt from the address: value should be > 0");
569         require(_frozen_balanceOf(account) >= amount, "ERC20: melt from the address: balance < amount");
570 
571         _frozen_sub(account, amount);
572         _balances[account] = _balances[account].add(amount);
573 
574         emit Melt(account, amount);
575     }
576 
577     function _burnFrozen(address account, uint256 amount) internal {
578         require(account != address(0), "ERC20: frozen burn from the zero address");
579 
580         _totalSupply = _totalSupply.sub(amount);
581         _frozen_sub(account, amount);
582 
583         emit Transfer(account, address(this), amount);
584     }
585 }
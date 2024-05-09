1 pragma solidity ^0.5.11;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18 }
19 
20 contract AccountFrozenBalances {
21     using SafeMath for uint256;
22 
23     mapping (address => uint256) private frozen_balances;
24 
25     function _frozen_add(address _account, uint256 _amount) internal returns (bool) {
26         frozen_balances[_account] = frozen_balances[_account].add(_amount);
27         return true;
28     }
29 
30     function _frozen_sub(address _account, uint256 _amount) internal returns (bool) {
31         frozen_balances[_account] = frozen_balances[_account].sub(_amount);
32         return true;
33     }
34 
35     function _frozen_balanceOf(address _account) internal view returns (uint) {
36         return frozen_balances[_account];
37     }
38 }
39 
40 contract Ownable {
41     address private _owner;
42     address public pendingOwner;
43 
44     modifier onlyOwner() {
45         require(msg.sender == _owner, "caller is not the owner");
46         _;
47     }
48 
49     modifier onlyPendingOwner() {
50         require(msg.sender == pendingOwner);
51         _;
52     }
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     constructor () internal {
57         _owner = msg.sender;
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     function transferOwnership(address newOwner) public onlyOwner {
65         pendingOwner = newOwner;
66     }
67 
68     function claimOwnership() public onlyPendingOwner {
69         emit OwnershipTransferred(_owner, pendingOwner);
70         _owner = pendingOwner;
71         pendingOwner = address(0);
72     }
73 }
74 
75 contract Whitelisted {
76     address private _whitelistadmin;
77     address public pendingWhiteListAdmin;
78 
79     mapping (address => bool) private _whitelisted;
80 
81     modifier onlyWhitelistAdmin() {
82         require(msg.sender == _whitelistadmin, "caller is not admin of whitelist");
83         _;
84     }
85 
86     modifier onlyPendingWhitelistAdmin() {
87         require(msg.sender == pendingWhiteListAdmin);
88         _;
89     }
90 
91     event WhitelistAdminTransferred(address indexed previousAdmin, address indexed newAdmin);
92 
93     constructor () internal {
94         _whitelistadmin = msg.sender;
95         _whitelisted[msg.sender] = true;
96     }
97 
98     function whitelistadmin() public view returns (address){
99         return _whitelistadmin;
100     }
101     function addWhitelisted(address account) public onlyWhitelistAdmin {
102         _whitelisted[account] = true;
103     }
104 
105     function removeWhitelisted(address account) public onlyWhitelistAdmin {
106         _whitelisted[account] = false;
107     }
108 
109     function isWhitelisted(address account) public view returns (bool) {
110         return _whitelisted[account];
111     }
112 
113     function transferWhitelistAdmin(address newAdmin) public onlyWhitelistAdmin {
114         pendingWhiteListAdmin = newAdmin;
115     }
116 
117     function claimWhitelistAdmin() public onlyPendingWhitelistAdmin {
118         emit WhitelistAdminTransferred(_whitelistadmin, pendingWhiteListAdmin);
119         _whitelistadmin = pendingWhiteListAdmin;
120         pendingWhiteListAdmin = address(0);
121     }
122 }
123 
124 contract Burnable {
125     bool private _burnallow;
126     address private _burner;
127     address public pendingBurner;
128 
129     modifier whenBurn() {
130         require(_burnallow, "burnable: can't burn");
131         _;
132     }
133 
134     modifier onlyBurner() {
135         require(msg.sender == _burner, "caller is not a burner");
136         _;
137     }
138 
139     modifier onlyPendingBurner() {
140         require(msg.sender == pendingBurner);
141         _;
142     }
143 
144     event BurnerTransferred(address indexed previousBurner, address indexed newBurner);
145 
146     constructor () internal {
147         _burnallow = true;
148         _burner = msg.sender;
149     }
150 
151     function burnallow() public view returns (bool) {
152         return _burnallow;
153     }
154 
155     function burner() public view returns (address) {
156         return _burner;
157     }
158 
159     function burnTrigger() public onlyBurner {
160         _burnallow = !_burnallow;
161     }
162 
163     function transferWhitelistAdmin(address newBurner) public onlyBurner {
164         pendingBurner = newBurner;
165     }
166 
167     function claimBurner() public onlyPendingBurner {
168         emit BurnerTransferred(_burner, pendingBurner);
169         _burner = pendingBurner;
170         pendingBurner = address(0);
171     }
172 }
173 
174 contract Meltable {
175     mapping (address => bool) private _melters;
176     address private _melteradmin;
177     address public pendingMelterAdmin;
178 
179     modifier onlyMelterAdmin() {
180         require (msg.sender == _melteradmin, "caller not a melter admin");
181         _;
182     }
183 
184     modifier onlyMelter() {
185         require (_melters[msg.sender] == true, "can't perform melt");
186         _;
187     }
188 
189     modifier onlyPendingMelterAdmin() {
190         require(msg.sender == pendingMelterAdmin);
191         _;
192     }
193 
194     event MelterTransferred(address indexed previousMelter, address indexed newMelter);
195 
196     constructor () internal {
197         _melteradmin = msg.sender;
198         _melters[msg.sender] = true;
199     }
200 
201     function melteradmin() public view returns (address) {
202         return _melteradmin;
203     }
204 
205     function addToMelters(address account) public onlyMelterAdmin {
206         _melters[account] = true;
207     }
208 
209     function removeFromMelters(address account) public onlyMelterAdmin {
210         _melters[account] = false;
211     }
212 
213     function transferMelterAdmin(address newMelter) public onlyMelterAdmin {
214         pendingMelterAdmin = newMelter;
215     }
216 
217     function claimMelterAdmin() public onlyPendingMelterAdmin {
218         emit MelterTransferred(_melteradmin, pendingMelterAdmin);
219         _melteradmin = pendingMelterAdmin;
220         pendingMelterAdmin = address(0);
221     }
222 }
223 
224 contract Mintable {
225     mapping (address => bool) private _minters;
226     address private _minteradmin;
227     address public pendingMinterAdmin;
228 
229 
230     modifier onlyMinterAdmin() {
231         require (msg.sender == _minteradmin, "caller not a minter admin");
232         _;
233     }
234 
235     modifier onlyMinter() {
236         require (_minters[msg.sender] == true, "can't perform mint");
237         _;
238     }
239 
240     modifier onlyPendingMinterAdmin() {
241         require(msg.sender == pendingMinterAdmin);
242         _;
243     }
244 
245     event MinterTransferred(address indexed previousMinter, address indexed newMinter);
246 
247     constructor () internal {
248         _minteradmin = msg.sender;
249         _minters[msg.sender] = true;
250     }
251 
252     function minteradmin() public view returns (address) {
253         return _minteradmin;
254     }
255 
256     function addToMinters(address account) public onlyMinterAdmin {
257         _minters[account] = true;
258     }
259 
260     function removeFromMinters(address account) public onlyMinterAdmin {
261         _minters[account] = false;
262     }
263 
264     function transferMinterAdmin(address newMinter) public onlyMinterAdmin {
265         pendingMinterAdmin = newMinter;
266     }
267 
268     function claimMinterAdmin() public onlyPendingMinterAdmin {
269         emit MinterTransferred(_minteradmin, pendingMinterAdmin);
270         _minteradmin = pendingMinterAdmin;
271         pendingMinterAdmin = address(0);
272     }
273 }
274 
275 contract Pausable {
276     bool private _paused;
277     address private _pauser;
278     address public pendingPauser;
279 
280     modifier onlyPauser() {
281         require(msg.sender == _pauser, "caller is not a pauser");
282         _;
283     }
284 
285     modifier onlyPendingPauser() {
286         require(msg.sender == pendingPauser);
287         _;
288     }
289 
290     event PauserTransferred(address indexed previousPauser, address indexed newPauser);
291 
292 
293     constructor () internal {
294         _paused = false;
295         _pauser = msg.sender;
296     }
297 
298     function paused() public view returns (bool) {
299         return _paused;
300     }
301 
302     function pauser() public view returns (address) {
303         return _pauser;
304     }
305 
306     function pauseTrigger() public onlyPauser {
307         _paused = !_paused;
308     }
309 
310     function transferPauser(address newPauser) public onlyPauser {
311         pendingPauser = newPauser;
312     }
313 
314     function claimPauser() public onlyPendingPauser {
315         emit PauserTransferred(_pauser, pendingPauser);
316         _pauser = pendingPauser;
317         pendingPauser = address(0);
318     }
319 }
320 
321 contract TokenRecipient {
322     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
323 }
324 
325 contract KickToken is AccountFrozenBalances, Ownable, Whitelisted, Burnable, Pausable, Mintable, Meltable {
326     using SafeMath for uint256;
327 
328     string public name;
329     string public symbol;
330     uint8 public decimals;
331 
332 
333     mapping (address => uint256) private _balances;
334     mapping (address => mapping (address => uint256)) private _allowances;
335     uint256 private _totalSupply;
336 
337 
338     modifier canTransfer() {
339         if(paused()){
340             require (isWhitelisted(msg.sender) == true, "can't perform an action");
341         }
342         _;
343     }
344 
345     event Transfer(address indexed from, address indexed to, uint256 value);
346     event Approval(address indexed owner, address indexed spender, uint256 value);
347 
348     event Freeze(address indexed from, uint256 amount);
349     event Melt(address indexed from, uint256 amount);
350     event MintFrozen(address indexed to, uint256 amount);
351     event FrozenTransfer(address indexed from, address indexed to, uint256 value);
352 
353     constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
354         name = _name;
355         symbol = _symbol;
356         decimals = _decimals;
357         mint(msg.sender, 100000000);
358     }
359 
360     function totalSupply() public view returns (uint256) {
361         return _totalSupply;
362     }
363 
364     function balanceOf(address account) public view returns (uint256) {
365         return _balances[account].add(_frozen_balanceOf(account));
366     }
367 
368     function transfer(address recipient, uint256 amount) public canTransfer returns (bool) {
369         require(recipient != address(this), "can't transfer tokens to the contract address");
370 
371         _transfer(msg.sender, recipient, amount);
372         return true;
373     }
374 
375     function allowance(address _owner, address spender) public view returns (uint256) {
376         return _allowances[_owner][spender];
377     }
378 
379     function approve(address spender, uint256 value) public returns (bool) {
380         _approve(msg.sender, spender, value);
381         return true;
382     }
383 
384     /* Approve and then communicate the approved contract in a single tx */
385     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
386         TokenRecipient spender = TokenRecipient(_spender);
387         if (approve(_spender, _value)) {
388             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
389             return true;
390         } else {
391             return false;
392         }
393     }
394 
395     function transferFrom(address sender, address recipient, uint256 amount) public canTransfer returns (bool) {
396         require(recipient != address(this), "can't transfer tokens to the contract address");
397 
398         _transfer(sender, recipient, amount);
399         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
400         return true;
401     }
402 
403 
404     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
405         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
406         return true;
407     }
408 
409 
410     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
411         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
412         return true;
413     }
414 
415     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
416         _mint(account, amount);
417         return true;
418     }
419 
420     function burn(uint256 amount) public whenBurn {
421         _burn(msg.sender, amount);
422     }
423 
424     function burnFrom(address account, uint256 amount) public whenBurn {
425         _burnFrom(account, amount);
426     }
427 
428     function destroy(address account, uint256 amount) public onlyOwner {
429         _burn(account, amount);
430     }
431 
432     function destroyFrozen(address account, uint256 amount) public onlyOwner {
433         _burnFrozen(account, amount);
434     }
435 
436     function mintBatchToken(address[] calldata accounts, uint256[] calldata amounts) external onlyMinter returns (bool) {
437         require(accounts.length > 0, "mintBatchToken: transfer should be to at least one address");
438         require(accounts.length == amounts.length, "mintBatchToken: recipients.length != amounts.length");
439         for (uint256 i = 0; i < accounts.length; i++) {
440             _mint(accounts[i], amounts[i]);
441         }
442 
443         return true;
444     }
445 
446     function transferFrozenToken(address from, address to, uint256 amount) public onlyOwner returns (bool) {
447         require(from != address(0), "ERC20: transfer from the zero address");
448         require(to != address(0), "ERC20: transfer to the zero address");
449 
450         _frozen_sub(from, amount);
451         _frozen_add(to, amount);
452 
453         emit FrozenTransfer(from, to, amount);
454         emit Transfer(from, to, amount);
455 
456         return true;
457     }
458 
459     function freezeTokens(address account, uint256 amount) public onlyOwner returns (bool) {
460         _freeze(account, amount);
461         emit Transfer(account, address(this), amount);
462         return true;
463     }
464 
465     function meltTokens(address account, uint256 amount) public onlyMelter returns (bool) {
466         _melt(account, amount);
467         emit Transfer(address(this), account, amount);
468         return true;
469     }
470 
471     function mintFrozenTokens(address account, uint256 amount) public onlyMinter returns (bool) {
472         _mintfrozen(account, amount);
473         return true;
474     }
475 
476     function mintBatchFrozenTokens(address[] calldata accounts, uint256[] calldata amounts) external onlyMinter returns (bool) {
477         require(accounts.length > 0, "mintBatchFrozenTokens: transfer should be to at least one address");
478         require(accounts.length == amounts.length, "mintBatchFrozenTokens: recipients.length != amounts.length");
479         for (uint256 i = 0; i < accounts.length; i++) {
480             _mintfrozen(accounts[i], amounts[i]);
481         }
482 
483         return true;
484     }
485 
486     function meltBatchTokens(address[] calldata accounts, uint256[] calldata amounts) external onlyMelter returns (bool) {
487         require(accounts.length > 0, "mintBatchFrozenTokens: transfer should be to at least one address");
488         require(accounts.length == amounts.length, "mintBatchFrozenTokens: recipients.length != amounts.length");
489         for (uint256 i = 0; i < accounts.length; i++) {
490             _melt(accounts[i], amounts[i]);
491             emit Transfer(address(this), accounts[i], amounts[i]);
492         }
493 
494         return true;
495     }
496 
497     function _transfer(address sender, address recipient, uint256 amount) internal {
498         require(sender != address(0), "ERC20: transfer from the zero address");
499         require(recipient != address(0), "ERC20: transfer to the zero address");
500 
501         _balances[sender] = _balances[sender].sub(amount);
502         _balances[recipient] = _balances[recipient].add(amount);
503         emit Transfer(sender, recipient, amount);
504     }
505 
506 
507     function _mint(address account, uint256 amount) internal {
508         require(account != address(0), "ERC20: mint to the zero address");
509         require(account != address(this), "ERC20: mint to the contract address");
510         require(amount > 0, "ERC20: mint amount should be > 0");
511 
512         _totalSupply = _totalSupply.add(amount);
513         _balances[account] = _balances[account].add(amount);
514         emit Transfer(address(this), account, amount);
515     }
516 
517     function _burn(address account, uint256 value) internal {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _totalSupply = _totalSupply.sub(value);
521         _balances[account] = _balances[account].sub(value);
522         emit Transfer(account, address(this), value);
523     }
524 
525     function _approve(address _owner, address spender, uint256 value) internal {
526         require(_owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[_owner][spender] = value;
530         emit Approval(_owner, spender, value);
531     }
532 
533     function _burnFrom(address account, uint256 amount) internal {
534         _burn(account, amount);
535         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
536     }
537 
538     function _freeze(address account, uint256 amount) internal {
539         require(account != address(0), "ERC20: freeze from the zero address");
540         require(amount > 0, "ERC20: freeze from the address: amount should be > 0");
541 
542         _balances[account] = _balances[account].sub(amount);
543         _frozen_add(account, amount);
544 
545         emit Freeze(account, amount);
546     }
547 
548     function _mintfrozen(address account, uint256 amount) internal {
549         require(account != address(0), "ERC20: mint frozen to the zero address");
550         require(account != address(this), "ERC20: mint frozen to the contract address");
551         require(amount > 0, "ERC20: mint frozen amount should be > 0");
552 
553         _totalSupply = _totalSupply.add(amount);
554 
555         emit Transfer(address(this), account, amount);
556 
557         _frozen_add(account, amount);
558 
559         emit MintFrozen(account, amount);
560     }
561 
562     function _melt(address account, uint256 amount) internal {
563         require(account != address(0), "ERC20: melt from the zero address");
564         require(amount > 0, "ERC20: melt from the address: value should be > 0");
565         require(_frozen_balanceOf(account) >= amount, "ERC20: melt from the address: balance < amount");
566 
567         _frozen_sub(account, amount);
568         _balances[account] = _balances[account].add(amount);
569 
570         emit Melt(account, amount);
571     }
572 
573     function _burnFrozen(address account, uint256 amount) internal {
574         require(account != address(0), "ERC20: frozen burn from the zero address");
575 
576         _totalSupply = _totalSupply.sub(amount);
577         _frozen_sub(account, amount);
578 
579         emit Transfer(account, address(this), amount);
580     }
581 }
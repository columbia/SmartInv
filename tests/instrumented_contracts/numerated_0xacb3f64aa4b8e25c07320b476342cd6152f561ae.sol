1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /////////////////////////////////////////////////
5 //                                             //
6 //      ██████╗  ██████╗ ███████╗ █████╗       // 
7 //      ██╔══██╗██╔═══██╗██╔════╝██╔══██╗      //
8 //      ██████╔╝██║   ██║█████╗  ███████║      //
9 //      ██╔══██╗██║   ██║██╔══╝  ██╔══██║      //
10 //      ██████╔╝╚██████╔╝██║     ██║  ██║      //
11 //      ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═╝      //
12 //                                             //
13 /////////////////////////////////////////////////
14 
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 ////////////////////////////////////////////////////////////////////////
27 
28 library SafeMath {
29    
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             uint256 c = a + b;
33             if (c < a) return (false, 0);
34             return (true, c);
35         }
36     }
37 
38     
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (a == 0) return (true, 0);
50             uint256 c = a * b;
51             if (c / a != b) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56    
57     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             if (b == 0) return (false, 0);
60             return (true, a / b);
61         }
62     }
63 
64   
65     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a % b);
69         }
70     }
71 
72    
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a + b;
75     }
76 
77   
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return a - b;
80     }
81 
82    
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a * b;
85     }
86 
87    
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a / b;
90     }
91 
92   
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a % b;
95     }
96 
97   
98     function sub(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         unchecked {
104             require(b <= a, errorMessage);
105             return a - b;
106         }
107     }
108 
109    
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         unchecked {
116             require(b > 0, errorMessage);
117             return a / b;
118         }
119     }
120 
121    
122     function mod(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         unchecked {
128             require(b > 0, errorMessage);
129             return a % b;
130         }
131     }
132 }
133 
134 
135 ////////////////////////////////////////////////////////////////////////
136 
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     
143     constructor() {
144         _transferOwnership(_msgSender());
145     }
146 
147     
148     modifier onlyOwner() {
149         _checkOwner();
150         _;
151     }
152 
153     
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     
159     function _checkOwner() internal view virtual {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161     }
162 
163     
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 
183 ////////////////////////////////////////////////////////////////////////
184 
185 abstract contract ReentrancyGuard {
186 
187     uint256 private constant _NOT_ENTERED = 1;
188     uint256 private constant _ENTERED = 2;
189 
190     uint256 private _status;
191 
192     constructor() {
193         _status = _NOT_ENTERED;
194     }
195 
196     modifier nonReentrant() {
197         _nonReentrantBefore();
198         _;
199         _nonReentrantAfter();
200     }
201 
202     function _nonReentrantBefore() private {
203         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
204         _status = _ENTERED;
205     }
206 
207     function _nonReentrantAfter() private {
208         _status = _NOT_ENTERED;
209     }
210 }
211 ////////////////////////////////////////////////////////////////////////
212 
213 interface IERC20 {
214    
215     event Transfer(address indexed from, address indexed to, uint256 value);
216 
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 
219     function totalSupply() external view returns (uint256);
220     function balanceOf(address account) external view returns (uint256);
221     function transfer(address to, uint256 amount) external returns (bool);
222     function allowance(address owner, address spender) external view returns (uint256);
223     function approve(address spender, uint256 amount) external returns (bool);  
224     function transferFrom(
225         address from,
226         address to,
227         uint256 amount
228     ) external returns (bool);
229 }
230 
231 ////////////////////////////////////////////////////////////////////////
232 
233 interface IERC20Metadata is IERC20 {
234     
235     function name() external view returns (string memory);
236     function symbol() external view returns (string memory);
237     function decimals() external view returns (uint8);
238 }
239 
240 ////////////////////////////////////////////////////////////////////////
241 
242 
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     constructor(string memory name_, string memory symbol_) {
254         _name = name_;
255         _symbol = symbol_;
256     }
257 
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     function symbol() public view virtual override returns (string memory) {
263         return _symbol;
264     }
265 
266     function decimals() public view virtual override returns (uint8) {
267         return 18;
268     }
269 
270     function totalSupply() public view virtual override returns (uint256) {
271         return _totalSupply;
272     }
273 
274     function balanceOf(address account) public view virtual override returns (uint256) {
275         return _balances[account];
276     }
277 
278     function transfer(address to, uint256 amount) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _transfer(owner, to, amount);
281         return true;
282     }
283 
284     function allowance(address owner, address spender) public view virtual override returns (uint256) {
285         return _allowances[owner][spender];
286     }
287 
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         address owner = _msgSender();
290         _approve(owner, spender, amount);
291         return true;
292     }
293 
294     function transferFrom(
295         address from,
296         address to,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         address spender = _msgSender();
300         _spendAllowance(from, spender, amount);
301         _transfer(from, to, amount);
302         return true;
303     }
304 
305     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
306         address owner = _msgSender();
307         _approve(owner, spender, allowance(owner, spender) + addedValue);
308         return true;
309     }
310 
311     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312         address owner = _msgSender();
313         uint256 currentAllowance = allowance(owner, spender);
314         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
315         unchecked {
316             _approve(owner, spender, currentAllowance - subtractedValue);
317         }
318 
319         return true;
320     }
321 
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) internal virtual {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329 
330         _beforeTokenTransfer(from, to, amount);
331 
332         uint256 fromBalance = _balances[from];
333         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
334         unchecked {
335             _balances[from] = fromBalance - amount;
336             _balances[to] += amount;
337         }
338 
339         emit Transfer(from, to, amount);
340 
341         _afterTokenTransfer(from, to, amount);
342     }
343 
344     function _mint(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: mint to the zero address");
346 
347         _beforeTokenTransfer(address(0), account, amount);
348 
349         _totalSupply += amount;
350         unchecked {
351             _balances[account] += amount;
352         }
353         emit Transfer(address(0), account, amount);
354 
355         _afterTokenTransfer(address(0), account, amount);
356     }
357 
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         uint256 accountBalance = _balances[account];
364         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
365         unchecked {
366             _balances[account] = accountBalance - amount;
367             _totalSupply -= amount;
368         }
369 
370         emit Transfer(account, address(0), amount);
371 
372         _afterTokenTransfer(account, address(0), amount);
373     }
374 
375     function _approve(
376         address owner,
377         address spender,
378         uint256 amount
379     ) internal virtual {
380         require(owner != address(0), "ERC20: approve from the zero address");
381         require(spender != address(0), "ERC20: approve to the zero address");
382 
383         _allowances[owner][spender] = amount;
384         emit Approval(owner, spender, amount);
385     }
386 
387     function _spendAllowance(
388         address owner,
389         address spender,
390         uint256 amount
391     ) internal virtual {
392         uint256 currentAllowance = allowance(owner, spender);
393         if (currentAllowance != type(uint256).max) {
394             require(currentAllowance >= amount, "ERC20: insufficient allowance");
395             unchecked {
396                 _approve(owner, spender, currentAllowance - amount);
397             }
398         }
399     }
400 
401     function _beforeTokenTransfer(
402         address from,
403         address to,
404         uint256 amount
405     ) internal virtual {}
406 
407     function _afterTokenTransfer(
408         address from,
409         address to,
410         uint256 amount
411     ) internal virtual {}
412 }
413 
414 
415 ////////////////////////////////////////////////////////////////////////
416 
417 
418 contract BOFA is ERC20, Ownable, ReentrancyGuard {
419     using SafeMath for uint256;
420 
421     mapping(address => uint256) public deposits;
422     address[] public depositors;
423     address public feeReceiver;
424     uint256 public totalDeposits;
425     uint256 public constant maxSupply = 1_000_000_000_000 * 10 ** 18; // 1 trillion tokens with 18 decimal places
426     bool public maxTransaction;
427     bool public taxEnabled;
428     bool public initialPoolOpen;
429     
430 
431     constructor() ERC20("BOFA", "BOFA") {
432         _mint(msg.sender, maxSupply);
433         taxEnabled = false;
434         initialPoolOpen = true;
435         feeReceiver = msg.sender;
436     }
437 
438     function deposit() public payable nonReentrant {
439         require(initialPoolOpen, "Initial pool is not open");
440         require(deposits[msg.sender] <= 0.5 ether, "You have already contributed the maximum amount");
441         require(msg.value >= 0.01 ether, "Minimum deposit is 0.05 ETH");
442         require(msg.value <= 0.5 ether, "Maximum deposit is 1 ETH");
443         require(totalDeposits.add(msg.value) <= 25 ether, "Deposit pool limit reached");
444         if (deposits[msg.sender] == 0) {
445             depositors.push(msg.sender);
446         }
447         deposits[msg.sender] = deposits[msg.sender].add(msg.value);
448         totalDeposits = totalDeposits.add(msg.value);
449     }
450     
451     function refund() public nonReentrant {
452         require(initialPoolOpen, "Initial pool is still open");
453         require(deposits[msg.sender] > 0, "No deposits found");
454         uint256 amount = deposits[msg.sender];
455         deposits[msg.sender] = 0;
456         totalDeposits = totalDeposits.sub(amount);
457         (bool success,) = msg.sender.call{value: amount}("");
458         require(success, "Withdraw failed");
459     }
460 
461     function distributeTokens() public onlyOwner nonReentrant {
462         require(!initialPoolOpen, "Initial pool is still open");
463         require(totalDeposits > 0, "No deposits found");
464 
465         uint256 tokenAmount = maxSupply.div(2); // 50% of total supply
466         uint256 addressCount = depositors.length;
467 
468         for (uint256 i = 0; i < addressCount; i++) {
469             address recipient = depositors[i];
470             uint256 depositAmount = deposits[recipient];
471             uint256 tokensToSend = depositAmount.mul(tokenAmount).div(totalDeposits);
472             super._transfer(address(this), recipient, tokensToSend);
473             emit Transfer(address(this), recipient, tokensToSend);
474         }
475 
476         for (uint256 i = 0; i < addressCount; i++) {
477             delete deposits[depositors[i]];
478         }
479         depositors = new address[](0);
480         totalDeposits = 0;
481     }
482 
483     function isMaxTransaction(bool enabled) public onlyOwner {
484         maxTransaction = enabled;
485     }
486 
487     function isPoolOpen(bool enabled) public onlyOwner {
488         initialPoolOpen = enabled;
489     }
490 
491     function isTaxEnabled(bool enabled) public onlyOwner {
492         taxEnabled = enabled;
493     }
494 
495     function setFeeReceiver(address receiver) public onlyOwner {
496         feeReceiver = receiver;
497     }
498 
499     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
500     if (taxEnabled && msg.sender != owner() && recipient != feeReceiver) {
501         uint256 taxAmount = amount.div(100);
502         uint256 transferAmount = amount.sub(taxAmount);
503         if (maxTransaction) {
504             require(transferAmount <= maxSupply.div(100), "Transfer amount exceeds maximum transaction amount");
505         }
506         super.transfer(feeReceiver, taxAmount);
507         return super.transfer(recipient, transferAmount);
508     } else {
509         if (maxTransaction) {
510             require(amount <= maxSupply.div(100), "Transfer amount exceeds maximum transaction amount");
511         }
512         return super.transfer(recipient, amount);
513         }
514     }
515 
516     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
517         if (taxEnabled && sender != owner() && recipient != feeReceiver) {
518             uint256 taxAmount = amount.div(100);
519             uint256 transferAmount = amount.sub(taxAmount);
520             if (maxTransaction) {
521                 require(transferAmount <= maxSupply.div(100), "Transfer amount exceeds maximum transaction amount");
522             }
523             super.transferFrom(sender, feeReceiver, taxAmount);
524             return super.transferFrom(sender, recipient, transferAmount);
525         } else {
526             if (maxTransaction) {
527                 require(amount <= maxSupply.div(100), "Transfer amount exceeds maximum transaction amount");
528             }
529             return super.transferFrom(sender, recipient, amount);
530             }
531         }
532 
533         function withdraw() public onlyOwner {
534             uint256 balance = address(this).balance;
535             payable(msg.sender).transfer(balance);
536         }
537 }
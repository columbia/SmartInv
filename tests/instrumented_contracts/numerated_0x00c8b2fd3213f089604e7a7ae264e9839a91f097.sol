1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 abstract contract Context {
7 
8     function _msgSender() internal view virtual returns (address payable) {
9 
10         return msg.sender;
11 
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15 
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17 
18         return msg.data;
19 
20     }
21 
22 }
23 
24 library SafeMath {
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 
28         uint256 c = a + b;
29 
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33 
34     }
35  
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38 
39         return sub(a, b, "SafeMath: subtraction overflow");
40 
41     }
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43 
44         require(b <= a, errorMessage);
45 
46         uint256 c = a - b;
47 
48         return c;
49 
50     }
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52 
53   
54 
55         if (a == 0) {
56 
57             return 0;
58 
59         }
60 
61         uint256 c = a * b;
62 
63         require(c / a == b, "SafeMath: multiplication overflow");
64 
65         return c;
66 
67     }
68 
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71 
72         return div(a, b, "SafeMath: division by zero");
73 
74     }
75 
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78 
79         require(b > 0, errorMessage);
80 
81         uint256 c = a / b;
82 
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85         return c;
86 
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90 
91         return mod(a, b, "SafeMath: modulo by zero");
92 
93     }
94 
95     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96 
97         require(b != 0, errorMessage);
98 
99         return a % b;
100 
101     }
102 
103 }
104 
105 contract Pausable is Context {
106 
107     event Paused(address account);
108     event Unpaused(address account);
109     bool private _paused;
110     constructor () internal {
111 
112         _paused = false;
113 
114     }
115 
116     function paused() public view returns (bool) {
117 
118         return _paused;
119 
120     }
121 
122     modifier whenNotPaused() {
123 
124         require(!_paused, "Pausable: paused");
125 
126         _;
127 
128     }
129 
130     modifier whenPaused() {
131 
132         require(_paused, "Pausable: not paused");
133 
134         _;
135 
136     }
137 
138     function _pause() internal virtual whenNotPaused {
139 
140         _paused = true;
141 
142         emit Paused(_msgSender());
143 
144     }
145 
146     function _unpause() internal virtual whenPaused {
147 
148         _paused = false;
149 
150         emit Unpaused(_msgSender());
151 
152     }
153 
154 }
155 
156 interface IERC20 {
157 
158 
159     function totalSupply() external view returns (uint256);
160 
161 
162     function balanceOf(address account) external view returns (uint256);
163 
164 
165     function transfer(address recipient, uint256 amount) external returns (bool);
166 
167 
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170 
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     function transferFrom(address sender, address recipient, uint256 amount) external  returns (bool);
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 
178 }
179 
180 
181 pragma solidity ^0.6.0;
182 
183 contract Ownable is Context {
184 
185     address private _owner;
186 
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191  
192 
193     constructor () internal {
194 
195         address msgSender = _msgSender();
196 
197         _owner = msgSender;
198 
199         emit OwnershipTransferred(address(0), msgSender);
200 
201     }
202 
203  
204 
205     function owner() public view returns (address) {
206 
207         return _owner;
208 
209     }
210  
211 
212     modifier onlyOwner() {
213 
214         require(_owner == _msgSender(), "Ownable: caller is not the owner");
215 
216         _;
217 
218     }
219 
220     function transferOwnership(address newOwner) public virtual onlyOwner {
221 
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223 
224         emit OwnershipTransferred(_owner, newOwner);
225 
226         _owner = newOwner;
227 
228     }
229 
230 }
231 
232 contract ERC20 is Context, IERC20, Pausable,Ownable  {
233 
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) public blackList;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     event Transfer(address indexed from, address indexed to, uint value);
243 
244     event Blacklisted(address indexed target);
245 
246     event DeleteFromBlacklist(address indexed target);
247 
248     event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);
249 
250     event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);
251 
252     uint256 private _totalSupply;
253 
254     string private _name;
255 
256     string private _symbol;
257 
258     uint8 private _decimals;
259 
260     constructor (string memory name, string memory symbol) public {
261 
262         _name = name;
263 
264         _symbol = symbol;
265 
266         _decimals = 18;
267 
268     }
269 
270     
271 
272     function blacklisting(address _addr) onlyOwner() public{
273 
274         blackList[_addr] = 1;
275 
276         Blacklisted(_addr);
277 
278     }
279 
280     
281 
282     function deleteFromBlacklist(address _addr) onlyOwner() public{
283 
284         blackList[_addr] = 0;
285 
286         DeleteFromBlacklist(_addr);
287 
288     }
289 
290     function name() public view returns (string memory) {
291 
292         return _name;
293 
294     }
295 
296     function symbol() public view returns (string memory) {
297 
298         return _symbol;
299 
300     }
301 
302     function decimals() public view returns (uint8) {
303 
304         return _decimals;
305 
306     }
307 
308     function totalSupply() public view override returns (uint256) {
309 
310         return _totalSupply;
311 
312     }
313 
314     function balanceOf(address account) public view override returns (uint256) {
315 
316         return _balances[account];
317 
318     }
319 
320     function transfer(address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {
321 
322         _transfer(_msgSender(), recipient, amount);
323 
324         return true;
325 
326     }
327 
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329 
330         return _allowances[owner][spender];
331 
332     }
333 
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335 
336         _approve(_msgSender(), spender, amount);
337 
338         return true;
339 
340     }
341 
342     function transferFrom(address sender, address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {
343 
344         _transfer(sender, recipient, amount);
345 
346         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
347 
348         return true;
349 
350     }
351 
352     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
353 
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
355 
356         return true;
357 
358     }
359 
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361 
362         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
363 
364         return true;
365 
366     }
367 
368     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
369 
370         require(sender != address(0), "ERC20: transfer from the zero address");
371 
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374          if(blackList[msg.sender] == 1){
375 
376         RejectedPaymentFromBlacklistedAddr(msg.sender, recipient, amount);
377 
378         require(false,"You are BlackList");
379 
380         }
381 
382         else if(blackList[recipient] == 1){
383 
384             RejectedPaymentToBlacklistedAddr(msg.sender, recipient, amount);
385 
386             require(false,"recipient are BlackList");
387 
388         }
389 
390         else{
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
395 
396         _balances[recipient] = _balances[recipient].add(amount);
397 
398         emit Transfer(sender, recipient, amount);
399 
400         }
401 
402     }
403 
404     function _mint(address account, uint256 amount) internal virtual {
405 
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply = _totalSupply.add(amount);
411 
412         _balances[account] = _balances[account].add(amount);
413 
414         emit Transfer(address(0), account, amount);
415 
416     }
417 
418     function _burn(address account, uint256 amount) internal virtual {
419 
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
425 
426         _totalSupply = _totalSupply.sub(amount);
427 
428         emit Transfer(account, address(0), amount);
429 
430     }
431 
432     function _approve(address owner, address spender, uint256 amount) internal virtual {
433 
434         require(owner != address(0), "ERC20: approve from the zero address");
435 
436         require(spender != address(0), "ERC20: approve to the zero address");
437 
438         _allowances[owner][spender] = amount;
439 
440         emit Approval(owner, spender, amount);
441 
442     }
443 
444 
445     function _setupDecimals(uint8 decimals_) internal {
446 
447         _decimals = decimals_;
448 
449     }
450 
451     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
452 
453 }
454 
455 
456 abstract contract ERC20Burnable is Context, ERC20 {
457 
458     function burn(uint256 amount) public virtual {
459 
460         _burn(_msgSender(), amount);
461 
462     }
463 
464     function burnFrom(address account, uint256 amount) public virtual {
465 
466         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
467 
468         _approve(account, _msgSender(), decreasedAllowance);
469 
470         _burn(account, amount);
471 
472     }
473 
474 }
475 
476 contract DRKCOIN is ERC20,ERC20Burnable {
477 
478     constructor(uint256 initialSupply) public ERC20("DRK coin", "DRK") {
479 
480         _mint(msg.sender, initialSupply);
481 
482     }
483 
484             function mint(uint256 initialSupply) onlyOwner() public {
485 
486         _mint(msg.sender, initialSupply);
487 
488     }
489 
490     
491 
492         function pause() onlyOwner() public {
493 
494         _pause();
495 
496         }
497 
498        function unpause() onlyOwner() public {
499 
500         _unpause();
501 
502     }
503 
504 }
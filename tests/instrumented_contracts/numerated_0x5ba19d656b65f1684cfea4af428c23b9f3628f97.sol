1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 interface ILosslessController {
108   function beforeTransfer(
109     address sender,
110     address recipient,
111     uint256 amount
112   ) external;
113 
114   function beforeTransferFrom(
115     address msgSender,
116     address sender,
117     address recipient,
118     uint256 amount
119   ) external;
120 
121   function beforeApprove(
122     address sender,
123     address spender,
124     uint256 amount
125   ) external;
126 
127   function beforeIncreaseAllowance(
128     address msgSender,
129     address spender,
130     uint256 addedValue
131   ) external;
132 
133   function beforeDecreaseAllowance(
134     address msgSender,
135     address spender,
136     uint256 subtractedValue
137   ) external;
138 
139   function afterApprove(
140     address sender,
141     address spender,
142     uint256 amount
143   ) external;
144 
145   function afterTransfer(
146     address sender,
147     address recipient,
148     uint256 amount
149   ) external;
150 
151   function afterTransferFrom(
152     address msgSender,
153     address sender,
154     address recipient,
155     uint256 amount
156   ) external;
157 
158   function afterIncreaseAllowance(
159     address sender,
160     address spender,
161     uint256 addedValue
162   ) external;
163 
164   function afterDecreaseAllowance(
165     address sender,
166     address spender,
167     uint256 subtractedValue
168   ) external;
169 }
170 
171 contract AAGToken is Context, IERC20 {
172   mapping(address => uint256) private _balances;
173   mapping(address => mapping(address => uint256)) private _allowances;
174 
175   uint256 private _totalSupply;
176   string private constant NAME = "AAG";
177   string private constant SYMBOL = "AAG";
178 
179   address public recoveryAdmin;
180   address private recoveryAdminCanditate;
181   bytes32 private recoveryAdminKeyHash;
182   address public admin;
183   uint256 public timelockPeriod;
184   uint256 public losslessTurnOffTimestamp;
185   bool public isLosslessTurnOffProposed;
186   bool public isLosslessOn = true;
187   ILosslessController private lossless;
188 
189   event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
190   event RecoveryAdminChangeProposed(address indexed candidate);
191   event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);
192   event LosslessTurnOffProposed(uint256 turnOffDate);
193   event LosslessTurnedOff();
194   event LosslessTurnedOn();
195 
196   uint256 private constant _TOTAL_SUPPLY = 1000000000e18; // Initial supply 1 000 000 000
197   bool private initialPoolClaimed = false;
198 
199   constructor(
200     address admin_,
201     address recoveryAdmin_,
202     uint256 timelockPeriod_,
203     address lossless_,
204     bool losslessOn
205   ) {
206     _mint(address(this), _TOTAL_SUPPLY);
207     admin = admin_;
208     recoveryAdmin = recoveryAdmin_;
209     timelockPeriod = timelockPeriod_;
210     isLosslessOn = losslessOn;
211     lossless = ILosslessController(lossless_);
212   }
213 
214   // AAG unlocked tokens claiming
215 
216   function claimTokens() public onlyRecoveryAdmin {
217     require(initialPoolClaimed == false, "Already claimed");
218     initialPoolClaimed = true;
219     _transfer(address(this), admin, _TOTAL_SUPPLY);
220   }
221 
222   // --- LOSSLESS modifiers ---
223 
224   modifier lssAprove(address spender, uint256 amount) {
225     if (isLosslessOn) {
226       lossless.beforeApprove(_msgSender(), spender, amount);
227       _;
228       lossless.afterApprove(_msgSender(), spender, amount);
229     } else {
230       _;
231     }
232   }
233 
234   modifier lssTransfer(address recipient, uint256 amount) {
235     if (isLosslessOn) {
236       lossless.beforeTransfer(_msgSender(), recipient, amount);
237       _;
238       lossless.afterTransfer(_msgSender(), recipient, amount);
239     } else {
240       _;
241     }
242   }
243 
244   modifier lssTransferFrom(
245     address sender,
246     address recipient,
247     uint256 amount
248   ) {
249     if (isLosslessOn) {
250       lossless.beforeTransferFrom(_msgSender(), sender, recipient, amount);
251       _;
252       lossless.afterTransferFrom(_msgSender(), sender, recipient, amount);
253     } else {
254       _;
255     }
256   }
257 
258   modifier lssIncreaseAllowance(address spender, uint256 addedValue) {
259     if (isLosslessOn) {
260       lossless.beforeIncreaseAllowance(_msgSender(), spender, addedValue);
261       _;
262       lossless.afterIncreaseAllowance(_msgSender(), spender, addedValue);
263     } else {
264       _;
265     }
266   }
267 
268   modifier lssDecreaseAllowance(address spender, uint256 subtractedValue) {
269     if (isLosslessOn) {
270       lossless.beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
271       _;
272       lossless.afterDecreaseAllowance(_msgSender(), spender, subtractedValue);
273     } else {
274       _;
275     }
276   }
277 
278   modifier onlyRecoveryAdmin() {
279     require(_msgSender() == recoveryAdmin, "ERC20: Must be recovery admin");
280     _;
281   }
282 
283   // --- LOSSLESS management ---
284 
285   function getAdmin() external view returns (address) {
286     return admin;
287   }
288 
289   function transferOutBlacklistedFunds(address[] calldata from) external {
290     require(_msgSender() == address(lossless), "ERC20: Only lossless contract");
291     for (uint256 i = 0; i < from.length; i++) {
292       _transfer(from[i], address(lossless), balanceOf(from[i]));
293     }
294   }
295 
296   function setLosslessAdmin(address newAdmin) public onlyRecoveryAdmin {
297     emit AdminChanged(admin, newAdmin);
298     admin = newAdmin;
299   }
300 
301   function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) public onlyRecoveryAdmin {
302     recoveryAdminCanditate = candidate;
303     recoveryAdminKeyHash = keyHash;
304     emit RecoveryAdminChangeProposed(candidate);
305   }
306 
307   function acceptRecoveryAdminOwnership(bytes memory key) external {
308     require(_msgSender() == recoveryAdminCanditate, "ERC20: Must be canditate");
309     require(keccak256(key) == recoveryAdminKeyHash, "ERC20: Invalid key");
310     emit RecoveryAdminChanged(recoveryAdmin, recoveryAdminCanditate);
311     recoveryAdmin = recoveryAdminCanditate;
312   }
313 
314   function proposeLosslessTurnOff() public onlyRecoveryAdmin {
315     losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
316     isLosslessTurnOffProposed = true;
317     emit LosslessTurnOffProposed(losslessTurnOffTimestamp);
318   }
319 
320   function executeLosslessTurnOff() public onlyRecoveryAdmin {
321     require(isLosslessTurnOffProposed, "ERC20: TurnOff not proposed");
322     require(losslessTurnOffTimestamp <= block.timestamp, "ERC20: Time lock in progress");
323     isLosslessOn = false;
324     isLosslessTurnOffProposed = false;
325     emit LosslessTurnedOff();
326   }
327 
328   function executeLosslessTurnOn() public onlyRecoveryAdmin {
329     isLosslessTurnOffProposed = false;
330     isLosslessOn = true;
331     emit LosslessTurnedOn();
332   }
333 
334   // --- ERC20 methods ---
335 
336   function name() public view virtual returns (string memory) {
337     return NAME;
338   }
339 
340   function symbol() public view virtual returns (string memory) {
341     return SYMBOL;
342   }
343 
344   function decimals() public view virtual returns (uint8) {
345     return 18;
346   }
347 
348   function totalSupply() public view virtual override returns (uint256) {
349     return _totalSupply;
350   }
351 
352   function balanceOf(address account) public view virtual override returns (uint256) {
353     return _balances[account];
354   }
355 
356   function transfer(address recipient, uint256 amount) public virtual override lssTransfer(recipient, amount) returns (bool) {
357     _transfer(_msgSender(), recipient, amount);
358     return true;
359   }
360 
361   function allowance(address owner, address spender) public view virtual override returns (uint256) {
362     return _allowances[owner][spender];
363   }
364 
365   function approve(address spender, uint256 amount) public virtual override lssAprove(spender, amount) returns (bool) {
366     require((amount == 0) || (_allowances[_msgSender()][spender] == 0), "ERC20: Cannot change non zero allowance");
367     _approve(_msgSender(), spender, amount);
368     return true;
369   }
370 
371   function transferFrom(
372     address sender,
373     address recipient,
374     uint256 amount
375   ) public virtual override lssTransferFrom(sender, recipient, amount) returns (bool) {
376     _transfer(sender, recipient, amount);
377 
378     uint256 currentAllowance = _allowances[sender][_msgSender()];
379     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
380     _approve(sender, _msgSender(), currentAllowance - amount);
381 
382     return true;
383   }
384 
385   function increaseAllowance(address spender, uint256 addedValue) public virtual lssIncreaseAllowance(spender, addedValue) returns (bool) {
386     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
387     return true;
388   }
389 
390   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual lssDecreaseAllowance(spender, subtractedValue) returns (bool) {
391     uint256 currentAllowance = _allowances[_msgSender()][spender];
392     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
393     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
394 
395     return true;
396   }
397 
398   function _transfer(
399     address sender,
400     address recipient,
401     uint256 amount
402   ) internal virtual {
403     require(sender != address(0), "ERC20: transfer from the zero address");
404     require(recipient != address(0), "ERC20: transfer to the zero address");
405 
406     uint256 senderBalance = _balances[sender];
407     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
408     _balances[sender] = senderBalance - amount;
409     _balances[recipient] += amount;
410 
411     emit Transfer(sender, recipient, amount);
412   }
413 
414   function _mint(address account, uint256 amount) internal virtual {
415     require(account != address(0), "ERC20: mint to the zero address");
416 
417     _totalSupply += amount;
418     _balances[account] += amount;
419     emit Transfer(address(0), account, amount);
420   }
421 
422   function _approve(
423     address owner,
424     address spender,
425     uint256 amount
426   ) internal virtual {
427     require(owner != address(0), "ERC20: approve from the zero address");
428     require(spender != address(0), "ERC20: approve to the zero address");
429 
430     _allowances[owner][spender] = amount;
431     emit Approval(owner, spender, amount);
432   }
433 }
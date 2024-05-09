1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
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
26 
27 interface ILERC20 {
28     function name() external view returns (string memory);
29     function admin() external view returns (address);
30     function getAdmin() external view returns (address);
31     function symbol() external view returns (string memory);
32     function decimals() external view returns (uint8);
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address _account) external view returns (uint256);
35     function transfer(address _recipient, uint256 _amount) external returns (bool);
36     function allowance(address _owner, address _spender) external view returns (uint256);
37     function approve(address _spender, uint256 _amount) external returns (bool);
38     function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);
39     function increaseAllowance(address _spender, uint256 _addedValue) external returns (bool);
40     function decreaseAllowance(address _spender, uint256 _subtractedValue) external returns (bool);
41     
42     function transferOutBlacklistedFunds(address[] calldata _from) external;
43     function setLosslessAdmin(address _newAdmin) external;
44     function transferRecoveryAdminOwnership(address _candidate, bytes32 _keyHash) external;
45     function acceptRecoveryAdminOwnership(bytes memory _key) external;
46     function proposeLosslessTurnOff() external;
47     function executeLosslessTurnOff() external;
48     function executeLosslessTurnOn() external;
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52     event NewAdmin(address indexed _newAdmin);
53     event NewRecoveryAdminProposal(address indexed _candidate);
54     event NewRecoveryAdmin(address indexed _newAdmin);
55     event LosslessTurnOffProposal(uint256 _turnOffDate);
56     event LosslessOff();
57     event LosslessOn();
58 }
59 
60 interface ILssController {
61     // function getLockedAmount(ILERC20 _token, address _account)  returns (uint256);
62     // function getAvailableAmount(ILERC20 _token, address _account) external view returns (uint256 amount);
63     function whitelist(address _adr) external view returns (bool);
64     function blacklist(address _adr) external view returns (bool);
65     function admin() external view returns (address);
66     function recoveryAdmin() external view returns (address);
67 
68     function setAdmin(address _newAdmin) external;
69     function setRecoveryAdmin(address _newRecoveryAdmin) external;
70 
71     function setWhitelist(address[] calldata _addrList, bool _value) external;
72     function setBlacklist(address[] calldata _addrList, bool _value) external;
73 
74     function beforeTransfer(address _sender, address _recipient, uint256 _amount) external;
75     function beforeTransferFrom(address _msgSender, address _sender, address _recipient, uint256 _amount) external;
76     function beforeApprove(address _sender, address _spender, uint256 _amount) external;
77     function beforeIncreaseAllowance(address _msgSender, address _spender, uint256 _addedValue) external;
78     function beforeDecreaseAllowance(address _msgSender, address _spender, uint256 _subtractedValue) external;
79     function beforeMint(address _to, uint256 _amount) external;
80     function beforeBurn(address _account, uint256 _amount) external;
81     function afterTransfer(address _sender, address _recipient, uint256 _amount) external;
82 
83     event AdminChange(address indexed _newAdmin);
84     event RecoveryAdminChange(address indexed _newAdmin);
85     event PauseAdminChange(address indexed _newAdmin);
86 }
87 
88 contract LERC20 is Context, ILERC20 {
89     mapping (address => uint256) private _balances;
90     mapping (address => mapping (address => uint256)) private _allowances;
91     uint256 private _totalSupply;
92     string private _name;
93     string private _symbol;
94     uint8 private _decimals;
95 
96     address public recoveryAdmin;
97     address private recoveryAdminCandidate;
98     bytes32 private recoveryAdminKeyHash;
99     address override public admin;
100     uint256 public timelockPeriod;
101     uint256 public losslessTurnOffTimestamp;
102     bool public isLosslessOn = true;
103     ILssController public lossless;
104 
105     constructor(uint256 totalSupply_, string memory name_, string memory symbol_, uint8 decimals_, address admin_, address recoveryAdmin_, uint256 timelockPeriod_, address lossless_) {
106         _mint(_msgSender(), totalSupply_);
107         _name = name_;
108         _symbol = symbol_;
109         _decimals = decimals_;
110         admin = admin_;
111         recoveryAdmin = recoveryAdmin_;
112         recoveryAdminCandidate = address(0);
113         recoveryAdminKeyHash = "";
114         timelockPeriod = timelockPeriod_;
115         losslessTurnOffTimestamp = 0;
116         lossless = ILssController(lossless_);
117     }
118 
119     // --- LOSSLESS modifiers ---
120 
121     modifier lssAprove(address spender, uint256 amount) {
122         if (isLosslessOn) {
123             lossless.beforeApprove(_msgSender(), spender, amount);
124         }
125         _;
126     }
127 
128     modifier lssTransfer(address recipient, uint256 amount) {
129         if (isLosslessOn) {
130             lossless.beforeTransfer(_msgSender(), recipient, amount);
131         }
132         _;
133     }
134 
135     modifier lssTransferFrom(address sender, address recipient, uint256 amount) {
136         if (isLosslessOn) {
137             lossless.beforeTransferFrom(_msgSender(),sender, recipient, amount);
138         }
139         _;
140     }
141 
142     modifier lssIncreaseAllowance(address spender, uint256 addedValue) {
143         if (isLosslessOn) {
144             lossless.beforeIncreaseAllowance(_msgSender(), spender, addedValue);
145         }
146         _;
147     }
148 
149     modifier lssDecreaseAllowance(address spender, uint256 subtractedValue) {
150         if (isLosslessOn) {
151             lossless.beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
152         }
153         _;
154     }
155 
156     modifier onlyRecoveryAdmin() {
157         require(_msgSender() == recoveryAdmin, "LERC20: Must be recovery admin");
158         _;
159     }
160 
161     // --- LOSSLESS management ---
162     function transferOutBlacklistedFunds(address[] calldata from) override external {
163         require(_msgSender() == address(lossless), "LERC20: Only lossless contract");
164 
165         uint256 fromLength = from.length;
166         uint256 totalAmount = 0;
167 
168         for (uint256 i = 0; i < fromLength; i++) {
169             address fromAddress = from[i];
170             uint256 fromBalance = _balances[fromAddress];
171             _balances[fromAddress] = 0;
172             totalAmount += fromBalance;
173             emit Transfer(fromAddress, address(lossless), fromBalance);
174         }
175 
176         _balances[address(lossless)] += totalAmount;
177     }
178 
179     function setLosslessAdmin(address newAdmin) override external onlyRecoveryAdmin {
180         require(newAdmin != admin, "LERC20: Cannot set same address");
181         emit NewAdmin(newAdmin);
182         admin = newAdmin;
183     }
184 
185     function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) override  external onlyRecoveryAdmin {
186         recoveryAdminCandidate = candidate;
187         recoveryAdminKeyHash = keyHash;
188         emit NewRecoveryAdminProposal(candidate);
189     }
190 
191     function acceptRecoveryAdminOwnership(bytes memory key) override external {
192         require(_msgSender() == recoveryAdminCandidate, "LERC20: Must be canditate");
193         require(keccak256(key) == recoveryAdminKeyHash, "LERC20: Invalid key");
194         emit NewRecoveryAdmin(recoveryAdminCandidate);
195         recoveryAdmin = recoveryAdminCandidate;
196         recoveryAdminCandidate = address(0);
197     }
198 
199     function proposeLosslessTurnOff() override external onlyRecoveryAdmin {
200         require(losslessTurnOffTimestamp == 0, "LERC20: TurnOff already proposed");
201         require(isLosslessOn, "LERC20: Lossless already off");
202         losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
203         emit LosslessTurnOffProposal(losslessTurnOffTimestamp);
204     }
205 
206     function executeLosslessTurnOff() override external onlyRecoveryAdmin {
207         require(losslessTurnOffTimestamp != 0, "LERC20: TurnOff not proposed");
208         require(losslessTurnOffTimestamp <= block.timestamp, "LERC20: Time lock in progress");
209         isLosslessOn = false;
210         losslessTurnOffTimestamp = 0;
211         emit LosslessOff();
212     }
213 
214     function executeLosslessTurnOn() override external onlyRecoveryAdmin {
215         require(!isLosslessOn, "LERC20: Lossless already on");
216         losslessTurnOffTimestamp = 0;
217         isLosslessOn = true;
218         emit LosslessOn();
219     }
220 
221     function getAdmin() override public view virtual returns (address) {
222         return admin;
223     }
224 
225     // --- ERC20 methods ---
226 
227     function name() override public view virtual returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() override public view virtual returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() override public view virtual returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     function transfer(address recipient, uint256 amount) public virtual override lssTransfer(recipient, amount) returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender) public view virtual override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount) public virtual override lssAprove(spender, amount) returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(address sender, address recipient, uint256 amount) public virtual override lssTransferFrom(sender, recipient, amount) returns (bool) {
262         uint256 currentAllowance = _allowances[sender][_msgSender()];
263         require(currentAllowance >= amount, "LERC20: transfer amount exceeds allowance");
264         _transfer(sender, recipient, amount);
265 
266         _approve(sender, _msgSender(), currentAllowance - amount);
267 
268         return true;
269     }
270 
271     function increaseAllowance(address spender, uint256 addedValue) override public virtual lssIncreaseAllowance(spender, addedValue) returns (bool) {
272         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
273         return true;
274     }
275 
276     function decreaseAllowance(address spender, uint256 subtractedValue) override public virtual lssDecreaseAllowance(spender, subtractedValue) returns (bool) {
277         uint256 currentAllowance = _allowances[_msgSender()][spender];
278         require(currentAllowance >= subtractedValue, "LERC20: decreased allowance below zero");
279         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
280 
281         return true;
282     }
283 
284     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
285         require(sender != address(0), "LERC20: transfer from the zero address");
286 
287         uint256 senderBalance = _balances[sender];
288         require(senderBalance >= amount, "LERC20: transfer amount exceeds balance");
289         _balances[sender] = senderBalance - amount;
290         _balances[recipient] += amount;
291 
292         emit Transfer(sender, recipient, amount);
293     }
294 
295     function _mint(address account, uint256 amount) internal virtual {
296         require(account != address(0), "LERC20: mint to the zero address");
297 
298         _totalSupply += amount;
299 
300         // Cannot overflow because the sum of all user
301         // balances can't exceed the max uint256 value.
302         unchecked {
303             _balances[account] += amount;
304         }
305         emit Transfer(address(0), account, amount);
306     }
307 
308     function _burn(address account, uint256 amount) internal virtual {
309         require(account != address(0), "ERC20: burn from the zero address");
310 
311         uint256 accountBalance = _balances[account];
312         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
313         unchecked {
314             _balances[account] = accountBalance - amount;
315         }
316         _totalSupply -= amount;
317 
318         emit Transfer(account, address(0), amount);
319     }
320 
321     function _approve(address owner, address spender, uint256 amount) internal virtual {
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 }
326 
327 contract LERC20MintableBurnable is Context, LERC20 {
328 
329     constructor(
330     uint256 totalSupply_,
331     string memory name_,
332     string memory symbol_,
333     uint8 decimals_,
334     address admin_,
335     address recoveryAdmin_,
336     uint256 timelockPeriod_,
337     address lossless_
338     ) LERC20(
339     totalSupply_,
340     name_,
341     symbol_,
342     decimals_,
343     admin_,
344     recoveryAdmin_,
345     timelockPeriod_,
346     lossless_
347     ) {}
348 
349     modifier lssBurn(address account, uint256 amount) {
350         if (isLosslessOn) {
351             lossless.beforeBurn(account, amount);
352         }
353         _;
354     }
355 
356 
357     modifier lssMint(address account, uint256 amount) {
358         if (isLosslessOn) {
359             lossless.beforeMint(account, amount);
360         }
361         _;
362     }
363 
364 
365     function burn(uint256 amount) public virtual lssBurn(_msgSender(), amount) {
366         _burn(_msgSender(), amount);
367     }
368 
369     function burnFrom(address account, uint256 amount) public virtual lssBurn(account, amount) {
370         uint256 currentAllowance = allowance(account, _msgSender());
371         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
372         unchecked {
373             _approve(account, _msgSender(), currentAllowance - amount);
374         }
375         _burn(account, amount);
376     }
377 
378     function mint(address to, uint256 amount) public virtual lssMint(to, amount) {
379         require(_msgSender() == admin, "LERC20: Must be admin");
380         _mint(to, amount);
381     }
382 
383     /// @notice This function sets a new lossless controller
384     /// @dev Only can be called by the Recovery admin
385     /// @param _newLossless Address corresponding to the new Lossless Controller
386     function setLossless(address _newLossless) external onlyRecoveryAdmin {
387         require(_newLossless != address(0), "LERC20: Cannot set address(0)");
388         lossless = ILssController(_newLossless);
389     }
390 }
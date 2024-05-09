1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface ILssController {
16     function beforeTransfer(address sender, address recipient, uint256 amount) external;
17 
18     function beforeTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;
19 
20     function beforeApprove(address sender, address spender, uint256 amount) external;
21 
22     function beforeIncreaseAllowance(address msgSender, address spender, uint256 addedValue) external;
23 
24     function beforeDecreaseAllowance(address msgSender, address spender, uint256 subtractedValue) external;
25 
26     function beforeMint(address account, uint256 amount) external;
27 }
28 
29 contract LERC20Mintable is Context {
30     mapping (address => uint256) private _balances;
31     mapping (address => mapping (address => uint256)) private _allowances;
32     uint256 private _totalSupply;
33     string private _name;
34     string private _symbol;
35 
36     address public recoveryAdmin;
37     address private recoveryAdminCandidate;
38     bytes32 private recoveryAdminKeyHash;
39     address public admin;
40     uint256 public timelockPeriod;
41     uint256 public losslessTurnOffTimestamp;
42     bool public isLosslessOn = true;
43     ILssController public lossless;
44 
45     constructor(uint256 totalSupply_, string memory name_, string memory symbol_, address admin_, address recoveryAdmin_, uint256 timelockPeriod_, address lossless_) {
46         _mint(_msgSender(), totalSupply_);
47         _name = name_;
48         _symbol = symbol_;
49         admin = admin_;
50         recoveryAdmin = recoveryAdmin_;
51         recoveryAdminCandidate = address(0);
52         recoveryAdminKeyHash = "";
53         timelockPeriod = timelockPeriod_;
54         losslessTurnOffTimestamp = 0;
55         lossless = ILssController(lossless_);
56     }
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60     event NewAdmin(address indexed _newAdmin);
61     event NewRecoveryAdminProposal(address indexed _candidate);
62     event NewRecoveryAdmin(address indexed _newAdmin);
63     event LosslessTurnOffProposal(uint256 _turnOffDate);
64     event LosslessOff();
65     event LosslessOn();
66 
67     // --- LOSSLESS modifiers ---
68 
69     modifier lssAprove(address spender, uint256 amount) {
70         if (isLosslessOn) {
71             lossless.beforeApprove(_msgSender(), spender, amount);
72         } 
73         _;
74     }
75 
76     modifier lssTransfer(address recipient, uint256 amount) {
77         if (isLosslessOn) {
78             lossless.beforeTransfer(_msgSender(), recipient, amount);
79         } 
80         _;
81     }
82 
83     modifier lssTransferFrom(address sender, address recipient, uint256 amount) {
84         if (isLosslessOn) {
85             lossless.beforeTransferFrom(_msgSender(),sender, recipient, amount);
86         }
87         _;
88     }
89 
90     modifier lssIncreaseAllowance(address spender, uint256 addedValue) {
91         if (isLosslessOn) {
92             lossless.beforeIncreaseAllowance(_msgSender(), spender, addedValue);
93         }
94         _;
95     }
96 
97     modifier lssDecreaseAllowance(address spender, uint256 subtractedValue) {
98         if (isLosslessOn) {
99             lossless.beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
100         }
101         _;
102     }
103 
104     modifier onlyRecoveryAdmin() {
105         require(_msgSender() == recoveryAdmin, "LERC20: Must be recovery admin");
106         _;
107     }
108 
109     modifier lssMint(address account, uint256 amount) {
110         if (isLosslessOn) {
111             lossless.beforeMint(account, amount);
112         } 
113         _;
114     }
115 
116     // --- LOSSLESS management ---
117     function transferOutBlacklistedFunds(address[] calldata from) external {
118         require(_msgSender() == address(lossless), "LERC20: Only lossless contract");
119 
120         uint256 fromLength = from.length;
121         uint256 totalAmount = 0;
122         
123         for (uint256 i = 0; i < fromLength; i++) {
124             address fromAddress = from[i];
125             uint256 fromBalance = _balances[fromAddress];
126             _balances[fromAddress] = 0;
127             totalAmount += fromBalance;
128             emit Transfer(fromAddress, address(lossless), fromBalance);
129         }
130 
131         _balances[address(lossless)] += totalAmount;
132     }
133 
134     function setLosslessAdmin(address newAdmin) external onlyRecoveryAdmin {
135         require(newAdmin != admin, "LERC20: Cannot set same address");
136         emit NewAdmin(newAdmin);
137         admin = newAdmin;
138     }
139 
140     function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash)  external onlyRecoveryAdmin {
141         recoveryAdminCandidate = candidate;
142         recoveryAdminKeyHash = keyHash;
143         emit NewRecoveryAdminProposal(candidate);
144     }
145 
146     function acceptRecoveryAdminOwnership(bytes memory key) external {
147         require(_msgSender() == recoveryAdminCandidate, "LERC20: Must be canditate");
148         require(keccak256(key) == recoveryAdminKeyHash, "LERC20: Invalid key");
149         emit NewRecoveryAdmin(recoveryAdminCandidate);
150         recoveryAdmin = recoveryAdminCandidate;
151         recoveryAdminCandidate = address(0);
152     }
153 
154     function proposeLosslessTurnOff() external onlyRecoveryAdmin {
155         require(losslessTurnOffTimestamp == 0, "LERC20: TurnOff already proposed");
156         require(isLosslessOn, "LERC20: Lossless already off");
157         losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
158         emit LosslessTurnOffProposal(losslessTurnOffTimestamp);
159     }
160 
161     function executeLosslessTurnOff() external onlyRecoveryAdmin {
162         require(losslessTurnOffTimestamp != 0, "LERC20: TurnOff not proposed");
163         require(losslessTurnOffTimestamp <= block.timestamp, "LERC20: Time lock in progress");
164         isLosslessOn = false;
165         losslessTurnOffTimestamp = 0;
166         emit LosslessOff();
167     }
168 
169     function executeLosslessTurnOn() external onlyRecoveryAdmin {
170         require(!isLosslessOn, "LERC20: Lossless already on");
171         losslessTurnOffTimestamp = 0;
172         isLosslessOn = true;
173         emit LosslessOn();
174     }
175 
176     function getAdmin() public view virtual returns (address) {
177         return admin;
178     }
179 
180     // --- ERC20 methods ---
181 
182     function name() public view virtual returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public view virtual returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public view virtual returns (uint8) {
191         return 18;
192     }
193 
194     function totalSupply() public view virtual returns (uint256) {
195         return _totalSupply;
196     }
197 
198     function balanceOf(address account) public view virtual returns (uint256) {
199         return _balances[account];
200     }
201 
202     function transfer(address recipient, uint256 amount) public virtual lssTransfer(recipient, amount) returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view virtual returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public virtual lssAprove(spender, amount) returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public virtual lssTransferFrom(sender, recipient, amount) returns (bool) {
217         uint256 currentAllowance = _allowances[sender][_msgSender()];
218         require(currentAllowance >= amount, "LERC20: transfer amount exceeds allowance");
219         _transfer(sender, recipient, amount);
220         
221         _approve(sender, _msgSender(), currentAllowance - amount);
222 
223         return true;
224     }
225 
226     function increaseAllowance(address spender, uint256 addedValue) public virtual lssIncreaseAllowance(spender, addedValue) returns (bool) {
227         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
228         return true;
229     }
230 
231     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual lssDecreaseAllowance(spender, subtractedValue) returns (bool) {
232         uint256 currentAllowance = _allowances[_msgSender()][spender];
233         require(currentAllowance >= subtractedValue, "LERC20: decreased allowance below zero");
234         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
235 
236         return true;
237     }
238 
239     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
240         require(sender != address(0), "LERC20: transfer from the zero address");
241 
242         uint256 senderBalance = _balances[sender];
243         require(senderBalance >= amount, "LERC20: transfer amount exceeds balance");
244         _balances[sender] = senderBalance - amount;
245         _balances[recipient] += amount;
246 
247         emit Transfer(sender, recipient, amount);
248     }
249 
250     function _mint(address account, uint256 amount) internal virtual {
251         require(account != address(0), "LERC20: mint to the zero address");
252     
253         _totalSupply += amount;
254 
255         // Cannot overflow because the sum of all user
256         // balances can't exceed the max uint256 value.
257         unchecked { 
258             _balances[account] += amount;
259         }
260         emit Transfer(address(0), account, amount);
261     }
262 
263     function _burn(address account, uint256 amount) internal virtual {
264         require(account != address(0), "ERC20: burn from the zero address");
265 
266         uint256 accountBalance = _balances[account];
267         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
268         unchecked {
269             _balances[account] = accountBalance - amount;
270         }
271         _totalSupply -= amount;
272 
273         emit Transfer(account, address(0), amount);
274     }
275 
276     function _approve(address owner, address spender, uint256 amount) internal virtual {
277         _allowances[owner][spender] = amount;
278         emit Approval(owner, spender, amount);
279     }
280 
281     function mint(address to, uint256 amount) public virtual lssMint(to, amount) {
282         require(_msgSender() == admin, "LERC20: Must be admin");
283         _mint(to, amount);
284     }
285 }
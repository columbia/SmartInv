1 //SPDX-License-Identifier: Unlicense
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
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 interface ILosslessController {
34     function beforeTransfer(address sender, address recipient, uint256 amount) external;
35 
36     function beforeTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;
37 
38     function beforeApprove(address sender, address spender, uint256 amount) external;
39 
40     function beforeIncreaseAllowance(address msgSender, address spender, uint256 addedValue) external;
41 
42     function beforeDecreaseAllowance(address msgSender, address spender, uint256 subtractedValue) external;
43 
44     function afterApprove(address sender, address spender, uint256 amount) external;
45 
46     function afterTransfer(address sender, address recipient, uint256 amount) external;
47 
48     function afterTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;
49 
50     function afterIncreaseAllowance(address sender, address spender, uint256 addedValue) external;
51 
52     function afterDecreaseAllowance(address sender, address spender, uint256 subtractedValue) external;
53 }
54 
55 contract LERC20 is Context, IERC20 {
56     mapping (address => uint256) private _balances;
57     mapping (address => mapping (address => uint256)) private _allowances;
58     uint256 private _totalSupply;
59     string private _name;
60     string private _symbol;
61 
62     address public recoveryAdmin;
63     address private recoveryAdminCanditate;
64     bytes32 private recoveryAdminKeyHash;
65     address public admin;
66     uint256 public timelockPeriod;
67     uint256 public losslessTurnOffTimestamp;
68     bool public isLosslessTurnOffProposed;
69     bool public isLosslessOn = true;
70     ILosslessController private lossless;
71 
72     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
73     event RecoveryAdminChangeProposed(address indexed candidate);
74     event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);
75     event LosslessTurnOffProposed(uint256 turnOffDate);
76     event LosslessTurnedOff();
77     event LosslessTurnedOn();
78 
79     constructor(uint256 totalSupply_, string memory name_, string memory symbol_, address admin_, address recoveryAdmin_, uint256 timelockPeriod_, address lossless_) {
80         _mint(_msgSender(), totalSupply_);
81         _name = name_;
82         _symbol = symbol_;
83         admin = admin_;
84         recoveryAdmin = recoveryAdmin_;
85         timelockPeriod = timelockPeriod_;
86         lossless = ILosslessController(lossless_);
87     }
88 
89     // --- LOSSLESS modifiers ---
90 
91     modifier lssAprove(address spender, uint256 amount) {
92         if (isLosslessOn) {
93             lossless.beforeApprove(_msgSender(), spender, amount);
94             _;
95             lossless.afterApprove(_msgSender(), spender, amount);
96         } else {
97             _;
98         }
99     }
100 
101     modifier lssTransfer(address recipient, uint256 amount) {
102         if (isLosslessOn) {
103             lossless.beforeTransfer(_msgSender(), recipient, amount);
104             _;
105             lossless.afterTransfer(_msgSender(), recipient, amount);
106         } else {
107             _;
108         }
109     }
110 
111     modifier lssTransferFrom(address sender, address recipient, uint256 amount) {
112         if (isLosslessOn) {
113             lossless.beforeTransferFrom(_msgSender(),sender, recipient, amount);
114             _;
115             lossless.afterTransferFrom(_msgSender(), sender, recipient, amount);
116         } else {
117             _;
118         }
119     }
120 
121     modifier lssIncreaseAllowance(address spender, uint256 addedValue) {
122         if (isLosslessOn) {
123             lossless.beforeIncreaseAllowance(_msgSender(), spender, addedValue);
124             _;
125             lossless.afterIncreaseAllowance(_msgSender(), spender, addedValue);
126         } else {
127             _;
128         }
129     }
130 
131     modifier lssDecreaseAllowance(address spender, uint256 subtractedValue) {
132         if (isLosslessOn) {
133             lossless.beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
134             _;
135             lossless.afterDecreaseAllowance(_msgSender(), spender, subtractedValue);
136         } else {
137             _;
138         }
139     }
140 
141     modifier onlyRecoveryAdmin() {
142         require(_msgSender() == recoveryAdmin, "LERC20: Must be recovery admin");
143         _;
144     }
145 
146     // --- LOSSLESS management ---
147 
148     function getAdmin() external view returns (address) {
149         return admin;
150     }
151 
152     function transferOutBlacklistedFunds(address[] calldata from) external {
153         require(_msgSender() == address(lossless), "LERC20: Only lossless contract");
154         for (uint i = 0; i < from.length; i++) {
155             _transfer(from[i], address(lossless), balanceOf(from[i]));
156         }
157     }
158 
159     function setLosslessAdmin(address newAdmin) public onlyRecoveryAdmin {
160         emit AdminChanged(admin, newAdmin);
161         admin = newAdmin;
162     }
163 
164     function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) public onlyRecoveryAdmin {
165         recoveryAdminCanditate = candidate;
166         recoveryAdminKeyHash = keyHash;
167         emit RecoveryAdminChangeProposed(candidate);
168     }
169 
170     function acceptRecoveryAdminOwnership(bytes memory key) external {
171         require(_msgSender() == recoveryAdminCanditate, "LERC20: Must be canditate");
172         require(keccak256(key) == recoveryAdminKeyHash, "LERC20: Invalid key");
173         emit RecoveryAdminChanged(recoveryAdmin, recoveryAdminCanditate);
174         recoveryAdmin = recoveryAdminCanditate;
175     }
176 
177     function proposeLosslessTurnOff() public onlyRecoveryAdmin {
178         losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
179         isLosslessTurnOffProposed = true;
180         emit LosslessTurnOffProposed(losslessTurnOffTimestamp);
181     }
182 
183     function executeLosslessTurnOff() public onlyRecoveryAdmin {
184         require(isLosslessTurnOffProposed, "LERC20: TurnOff not proposed");
185         require(losslessTurnOffTimestamp <= block.timestamp, "LERC20: Time lock in progress");
186         isLosslessOn = false;
187         isLosslessTurnOffProposed = false;
188         emit LosslessTurnedOff();
189     }
190 
191     function executeLosslessTurnOn() public onlyRecoveryAdmin {
192         isLosslessTurnOffProposed = false;
193         isLosslessOn = true;
194         emit LosslessTurnedOn();
195     }
196 
197     // --- ERC20 methods ---
198 
199     function name() public view virtual returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public view virtual returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public view virtual returns (uint8) {
208         return 18;
209     }
210 
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     function transfer(address recipient, uint256 amount) public virtual override lssTransfer(recipient, amount) returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view virtual override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public virtual override lssAprove(spender, amount) returns (bool) {
229         require((amount == 0) || (_allowances[_msgSender()][spender] == 0), "LERC20: Cannot change non zero allowance");
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     function transferFrom(address sender, address recipient, uint256 amount) public virtual override lssTransferFrom(sender, recipient, amount) returns (bool) {
235         _transfer(sender, recipient, amount);
236 
237         uint256 currentAllowance = _allowances[sender][_msgSender()];
238         require(currentAllowance >= amount, "LERC20: transfer amount exceeds allowance");
239         _approve(sender, _msgSender(), currentAllowance - amount);
240 
241         return true;
242     }
243 
244     function increaseAllowance(address spender, uint256 addedValue) public virtual lssIncreaseAllowance(spender, addedValue) returns (bool) {
245         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
246         return true;
247     }
248 
249     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual lssDecreaseAllowance(spender, subtractedValue) returns (bool) {
250         uint256 currentAllowance = _allowances[_msgSender()][spender];
251         require(currentAllowance >= subtractedValue, "LERC20: decreased allowance below zero");
252         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
253 
254         return true;
255     }
256 
257     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
258         require(sender != address(0), "LERC20: transfer from the zero address");
259         require(recipient != address(0), "LERC20: transfer to the zero address");
260 
261         uint256 senderBalance = _balances[sender];
262         require(senderBalance >= amount, "LERC20: transfer amount exceeds balance");
263         _balances[sender] = senderBalance - amount;
264         _balances[recipient] += amount;
265 
266         emit Transfer(sender, recipient, amount);
267     }
268 
269     function _mint(address account, uint256 amount) internal virtual {
270         require(account != address(0), "LERC20: mint to the zero address");
271 
272         _totalSupply += amount;
273         _balances[account] += amount;
274         emit Transfer(address(0), account, amount);
275     }
276 
277     function _approve(address owner, address spender, uint256 amount) internal virtual {
278         require(owner != address(0), "LERC20: approve from the zero address");
279         require(spender != address(0), "LERC20: approve to the zero address");
280 
281         _allowances[owner][spender] = amount;
282         emit Approval(owner, spender, amount);
283     }
284 }
1 pragma solidity 0.5.17;
2 
3 
4 interface DharmaGasReserveInterface {
5     // events
6     event EtherReceived(address sender, uint256 amount);
7     event Pulled(address indexed gasAccount, uint256 amount);
8     event AddedGasAccount(address gasAccount);
9     event RemovedGasAccount(address gasAccount);
10     event NewPullAmount(uint256 pullAmount);
11     event NewRateLimit(uint256 interval);
12     event Call(address target, uint256 amount, bytes data, bool ok, bytes returnData);
13 
14     // only callable by designated "gas accounts"
15     function pullGas() external;
16 
17     // only callable by owner
18     function addGasAccount(address gasAccount) external;
19     function removeGasAccount(address gasAccount) external;
20     function setPullAmount(uint256 amount) external;
21     function setRateLimit(uint256 interval) external;
22     function callAny(
23         address payable target, uint256 amount, bytes calldata data
24     ) external returns (bool ok, bytes memory returnData);
25 
26     // view functions
27     function getGasAccounts() external view returns (address[] memory);
28     function getPullAmount() external view returns (uint256);
29     function getRateLimit() external view returns (uint256);
30     function getLastPullTime(address gasAccount) external view returns (uint256);
31 }
32 
33 
34 contract TwoStepOwnable {
35   address private _owner;
36 
37   address private _newPotentialOwner;
38 
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44   /**
45    * @dev Initialize contract by setting transaction submitter as initial owner.
46    */
47   constructor() internal {
48     _owner = tx.origin;
49     emit OwnershipTransferred(address(0), _owner);
50   }
51 
52   /**
53    * @dev Returns the address of the current owner.
54    */
55   function owner() public view returns (address) {
56     return _owner;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
64     _;
65   }
66 
67   /**
68    * @dev Returns true if the caller is the current owner.
69    */
70   function isOwner() public view returns (bool) {
71     return msg.sender == _owner;
72   }
73 
74   /**
75    * @dev Allows a new account (`newOwner`) to accept ownership.
76    * Can only be called by the current owner.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(
80       newOwner != address(0),
81       "TwoStepOwnable: new potential owner is the zero address."
82     );
83 
84     _newPotentialOwner = newOwner;
85   }
86 
87   /**
88    * @dev Cancel a transfer of ownership to a new account.
89    * Can only be called by the current owner.
90    */
91   function cancelOwnershipTransfer() public onlyOwner {
92     delete _newPotentialOwner;
93   }
94 
95   /**
96    * @dev Transfers ownership of the contract to the caller.
97    * Can only be called by a new potential owner set by the current owner.
98    */
99   function acceptOwnership() public {
100     require(
101       msg.sender == _newPotentialOwner,
102       "TwoStepOwnable: current owner must set caller as new potential owner."
103     );
104 
105     delete _newPotentialOwner;
106 
107     emit OwnershipTransferred(_owner, msg.sender);
108 
109     _owner = msg.sender;
110   }
111 }
112 
113 
114 contract DharmaGasReserve is DharmaGasReserveInterface, TwoStepOwnable {
115     // Track all authorized gas accounts.
116     address[] private _gasAccounts;
117 
118     // Indexes start at 1, as 0 signifies non-inclusion
119     mapping (address => uint256) private _gasAccountIndexes;
120     
121     mapping (address => uint256) private _lastPullTime;
122     
123     uint256 private _pullAmount;
124     uint256 private _rateLimit;
125 
126     constructor(address[] memory initialGasAccounts) public {
127         _setPullAmount(3 ether);
128         _setRateLimit(1 hours);
129         for (uint256 i; i < initialGasAccounts.length; i++) {
130             address gasAccount = initialGasAccounts[i];
131             _addGasAccount(gasAccount);
132         }
133     }
134 
135     function () external payable {
136         if (msg.value > 0) {
137             emit EtherReceived(msg.sender, msg.value);
138         }
139     }
140 
141     function pullGas() external {
142         require(
143             _gasAccountIndexes[msg.sender] != 0,
144             "Only authorized gas accounts may pull from this contract."
145         );
146         
147         require(
148             msg.sender.balance < _pullAmount,
149             "Gas account balance is not yet below the pull amount."
150         );
151 
152         require(
153             now > _lastPullTime[msg.sender] + _rateLimit,
154             "Gas account is currently rate-limited."
155         );
156         _lastPullTime[msg.sender] = now;
157 
158         uint256 pullAmount = _pullAmount;
159         
160         require(
161             address(this).balance >= pullAmount,
162             "Insufficient funds held by the reserve."
163         );
164         
165         (bool ok, ) = msg.sender.call.value(pullAmount)("");
166         if (!ok) {
167             assembly {
168                 returndatacopy(0, 0, returndatasize)
169                 revert(0, returndatasize)
170             }
171         }
172 
173         emit Pulled(msg.sender, pullAmount);
174     }
175 
176     function addGasAccount(address gasAccount) external onlyOwner {
177         _addGasAccount(gasAccount);
178     }
179 
180     function removeGasAccount(address gasAccount) external onlyOwner {
181         _removeGasAccount(gasAccount);
182     }
183 
184     function setPullAmount(uint256 amount) external onlyOwner {
185         _setPullAmount(amount);
186     }
187 
188     function setRateLimit(uint256 interval) external onlyOwner {
189         _setRateLimit(interval);
190     }
191 
192     function callAny(
193         address payable target, uint256 amount, bytes calldata data
194     ) external onlyOwner returns (bool ok, bytes memory returnData) {
195         // Call the specified target and supply the specified data.
196         (ok, returnData) = target.call.value(amount)(data);
197 
198         emit Call(target, amount, data, ok, returnData);
199     }
200 
201     function getGasAccounts() external view returns (address[] memory) {
202         return _gasAccounts;
203     }
204 
205     function getPullAmount() external view returns (uint256) {
206         return  _pullAmount;
207     }
208 
209     function getRateLimit() external view returns (uint256) {
210         return _rateLimit;
211     }
212 
213     function getLastPullTime(address gasAccount) external view returns (uint256) {
214         return _lastPullTime[gasAccount];
215     }
216 
217     function _addGasAccount(address gasAccount) internal {
218         require(
219             _gasAccountIndexes[gasAccount] == 0,
220             "Gas account matching the provided account already exists."
221         );
222         _gasAccounts.push(gasAccount);
223         _gasAccountIndexes[gasAccount] = _gasAccounts.length;
224 
225         emit AddedGasAccount(gasAccount);
226     }
227     
228     function _removeGasAccount(address gasAccount) internal {
229         uint256 removedGasAccountIndex = _gasAccountIndexes[gasAccount];
230         require(
231             removedGasAccountIndex != 0,
232             "No gas account found matching the provided account."
233         );
234 
235         // swap account to remove with the last one then pop from the array.
236         address lastGasAccount = _gasAccounts[_gasAccounts.length - 1];
237         _gasAccounts[removedGasAccountIndex - 1] = lastGasAccount;
238         _gasAccountIndexes[lastGasAccount] = removedGasAccountIndex;
239         _gasAccounts.pop();
240         delete _gasAccountIndexes[gasAccount];
241 
242         emit RemovedGasAccount(gasAccount); 
243     }
244     
245     function _setPullAmount(uint256 amount) internal {
246         _pullAmount = amount;
247 
248         emit NewPullAmount(amount);
249     }
250     
251     function _setRateLimit(uint256 interval) internal {
252         _rateLimit = interval;
253 
254         emit NewRateLimit(interval);
255     }
256 }
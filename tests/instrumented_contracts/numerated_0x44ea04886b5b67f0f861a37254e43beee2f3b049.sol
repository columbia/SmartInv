1 pragma solidity 0.5.12;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address internal _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     constructor(address initialOwner) internal {
15         require(initialOwner != address(0));
16         _owner = initialOwner;
17         emit OwnershipTransferred(address(0), _owner);
18     }
19 
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     modifier onlyOwner() {
25         require(isOwner(), "Caller is not the owner");
26         _;
27     }
28 
29     function isOwner() internal view returns (bool) {
30         return msg.sender == _owner;
31     }
32 
33     function renounceOwnership() public onlyOwner {
34         emit OwnershipTransferred(_owner, address(0));
35         _owner = address(0);
36     }
37 
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0), "New owner is the zero address");
40         emit OwnershipTransferred(_owner, newOwner);
41         _owner = newOwner;
42     }
43 
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://eips.ethereum.org/EIPS/eip-20
49  */
50  interface IERC20 {
51      function transfer(address to, uint256 value) external returns (bool);
52      function approve(address spender, uint256 value) external returns (bool);
53      function transferFrom(address from, address to, uint256 value) external returns (bool);
54      function totalSupply() external view returns (uint256);
55      function balanceOf(address who) external view returns (uint256);
56      function allowance(address owner, address spender) external view returns (uint256);
57      function mint(address to, uint256 value) external returns (bool);
58      function burnFrom(address from, uint256 value) external;
59 
60      function freezeAndTransfer(address recipient, uint256 amount, uint256 period) external;
61  }
62 
63  interface IUSDT {
64      function totalSupply() external view returns (uint256);
65      function balanceOf(address account) external view returns (uint256);
66      function transfer(address recipient, uint256 amount) external;
67      function allowance(address owner, address spender) external view returns (uint256);
68      function approve(address spender, uint256 amount) external;
69      function transferFrom(address sender, address recipient, uint256 amount) external;
70      function decimals() external view returns(uint8);
71  }
72 
73  contract SSTReseller is Ownable {
74 
75      IUSDT public USDT;
76      IERC20 public SST;
77 
78      uint8[] public REFERRAL_PERCENTS = [20, 10, 5, 5, 5];
79      uint8 public FEE_PERCENT = 5;
80      uint8 public PERCENTS_DIVIDER = 100;
81 
82      uint128 public rate;
83      uint32 public period;
84      uint64 public minimum;
85 
86      address public boss1 = 0x96f9ED1C9555060da2A04b6250154C9941c1BA5a;
87      address public boss2 = 0x96f9ED1C9555060da2A04b6250154C9941c1BA5a;
88      address public boss3 = 0xa2B079f860b27966Cf3D96b955859E66b5FAd8FC;
89 
90      bool public active;
91 
92      mapping (address => uint64) public interestBalance;
93 
94      event OnBuy(address indexed account, uint256 usdt, uint256 sst, uint256 rate);
95      event OnRefBonus(address indexed account, address indexed referrer, uint256 level, uint256 bonus);
96      event OnWithdraw(address indexed account, uint256 value);
97      event OnSetRate(address indexed account, uint256 oldValue, uint256 newValue);
98      event OnSetPeriod(address indexed account, uint256 oldValue, uint256 newValue);
99      event OnSetMinimum(address indexed account, uint256 oldValue, uint256 newValue);
100      event OnWithdrawERC20(address indexed account, address indexed erc20, uint256 value);
101      event OnSwitchState(address indexed account, bool indexed active);
102      event OnBoss1Deposed(address indexed account, address oldBoss1, address newBoss1);
103      event OnBoss2Deposed(address indexed account, address oldBoss2, address newBoss2);
104      event OnBoss3Deposed(address indexed account, address oldBoss3, address newBoss3);
105 
106      modifier onlyActive {
107          require(active, "Not active");
108          _;
109      }
110 
111      constructor(address USDTAddr, address SSTAddr, uint128 initialRate, uint32 initialPeriod, address initialOwner) public Ownable(initialOwner) {
112          require(USDTAddr != address(0) && SSTAddr != address(0));
113          require(initialRate > 0);
114 
115          USDT = IUSDT(USDTAddr);
116          SST = IERC20(SSTAddr);
117 
118          rate = initialRate;
119          period = initialPeriod;
120 
121          active = true;
122      }
123 
124      function buy(uint256 value, address _ref1, address _ref2, address _ref3, address _ref4, address _ref5) public onlyActive {
125          require(value >= minimum, "Less than minimum");
126          USDT.transferFrom(msg.sender, address(this), value);
127 
128          uint256 total;
129          if (_ref1 != address(0) && _ref1 != msg.sender) {
130              uint256 bonus = value * REFERRAL_PERCENTS[0] / PERCENTS_DIVIDER;
131              interestBalance[_ref1] += uint64(bonus);
132              total += bonus;
133              emit OnRefBonus(msg.sender, _ref1, 0, bonus);
134          }
135 
136          if (_ref2 != address(0) && _ref2 != msg.sender) {
137              uint256 bonus = value * REFERRAL_PERCENTS[1] / PERCENTS_DIVIDER;
138              interestBalance[_ref2] += uint64(bonus);
139              total += bonus;
140              emit OnRefBonus(msg.sender, _ref2, 1, bonus);
141          }
142 
143          if (_ref3 != address(0) && _ref3 != msg.sender) {
144              uint256 bonus = value * REFERRAL_PERCENTS[2] / PERCENTS_DIVIDER;
145              interestBalance[_ref3] += uint64(bonus);
146              total += bonus;
147              emit OnRefBonus(msg.sender, _ref3, 2, bonus);
148          }
149 
150          if (_ref4 != address(0) && _ref4 != msg.sender) {
151              uint256 bonus = value * REFERRAL_PERCENTS[3] / PERCENTS_DIVIDER;
152              interestBalance[_ref4] += uint64(bonus);
153              total += bonus;
154              emit OnRefBonus(msg.sender, _ref4, 3, bonus);
155          }
156 
157          if (_ref5 != address(0) && _ref5 != msg.sender) {
158              uint256 bonus = value * REFERRAL_PERCENTS[4] / PERCENTS_DIVIDER;
159              interestBalance[_ref5] += uint64(bonus);
160              total += bonus;
161              emit OnRefBonus(msg.sender, _ref5, 4, bonus);
162          }
163 
164          uint256 fee = value * FEE_PERCENT / PERCENTS_DIVIDER;
165          interestBalance[boss2] += uint64(fee);
166          interestBalance[boss1] += uint64(value - fee - total);
167 
168          uint256 amount = getEstimation(value);
169 
170          SST.freezeAndTransfer(msg.sender, amount, period);
171 
172          emit OnBuy(msg.sender, value, amount, rate);
173      }
174 
175      function withdraw(uint256 value) public {
176          require(value <= interestBalance[msg.sender], "Not enough balance");
177 
178          interestBalance[msg.sender] -= uint64(value);
179          USDT.transfer(msg.sender, value);
180 
181          emit OnWithdraw(msg.sender, value);
182      }
183 
184      function setRate(uint128 newRate) public {
185          require(msg.sender == owner() || msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3, "No access");
186          require(newRate > 0, "Invalid rate");
187 
188          emit OnSetRate(msg.sender, rate, newRate);
189 
190          rate = newRate;
191      }
192 
193      function setMinimum(uint64 newMinimum) public {
194          require(msg.sender == owner() || msg.sender == boss1 || msg.sender == boss2, "No access");
195          require(newMinimum > 0, "Invalid rate");
196 
197          emit OnSetMinimum(msg.sender, minimum, newMinimum);
198 
199          minimum = newMinimum;
200      }
201 
202      function setPeriod(uint32 newPeriod) public {
203          require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3, "No access");
204          require(newPeriod > 0, "Invalid rate");
205 
206          emit OnSetPeriod(msg.sender, period, newPeriod);
207 
208          period = newPeriod;
209      }
210 
211      function withdrawERC20(address ERC20Token, address recipient, uint256 value) external {
212          require(msg.sender == boss1 || msg.sender == boss2, "No access");
213 
214          IERC20(ERC20Token).transfer(recipient, value);
215 
216          emit OnWithdrawERC20(msg.sender, ERC20Token, value);
217      }
218 
219      function switchState() public {
220          require(msg.sender == owner() || msg.sender == boss1 || msg.sender == boss2, "No access");
221          active = !active;
222 
223          emit OnSwitchState(msg.sender, active);
224      }
225 
226      function deposeBoss1(address newBoss1) public {
227          require(msg.sender == boss1 || msg.sender == boss2, "No access");
228          require(newBoss1 != address(0), "Zero address");
229 
230          emit OnBoss1Deposed(msg.sender, boss1, newBoss1);
231 
232          boss1 = newBoss1;
233      }
234 
235      function deposeBoss2(address newBoss2) public {
236          require(msg.sender == boss1 || msg.sender == boss2, "No access");
237          require(newBoss2 != address(0), "Zero address");
238 
239          emit OnBoss2Deposed(msg.sender, boss2, newBoss2);
240 
241          boss2 = newBoss2;
242      }
243 
244      function deposeBoss3(address newBoss3) public {
245          require(msg.sender == owner() || msg.sender == boss1, "No access");
246          require(newBoss3 != address(0), "Zero address");
247 
248          emit OnBoss3Deposed(msg.sender, boss3, newBoss3);
249 
250          boss3 = newBoss3;
251      }
252 
253      function getEstimation(uint256 amount) public view returns(uint256) {
254          uint256 result = amount * rate;
255          require(result >= amount);
256          return amount * rate;
257      }
258 
259      function allowanceUSDT(address account) public view returns(uint256) {
260          return USDT.allowance(account, address(this));
261      }
262 
263      function allowanceSST(address account) public view returns(uint256) {
264          return SST.allowance(account, address(this));
265      }
266 
267      function balanceUSDT(address account) public view returns(uint256) {
268          return USDT.balanceOf(account);
269      }
270 
271      function balanceSST(address account) public view returns(uint256) {
272          return SST.balanceOf(account);
273      }
274 
275  }
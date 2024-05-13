1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import "hardhat/console.sol";
10 
11 contract HoldStake is Ownable {
12     using SafeMath for uint256;
13     using SafeERC20 for IERC20;
14 
15     struct HoldPool {
16         IERC20 token;
17         uint256 hardcap;
18         uint256 preUserHardcap;
19         uint256 apy; //100% = 1 * 10**6
20         uint256 depositTotal;
21         uint256 interest;
22         uint256 finishTime;
23     }
24 
25     struct DepositInfo {
26         uint256 pid;
27         uint256 value;
28         uint256 duration;
29         uint256 earned;
30         uint256 unlockTime;
31         bool present;
32     }
33 
34     mapping(uint256 => uint256) private finalCompleTime;
35 
36     mapping(uint256 => uint256) private interestHardcap;
37     mapping(uint256 => address) public interestProvider;
38 
39     mapping(uint256 => uint256) public lockDuration;
40     mapping(uint256 => HoldPool) public holdPools;
41     mapping(address => mapping(uint256 => DepositInfo)) public depositInfos;
42     uint256 public pid;
43 
44     event AddHoldPool(
45         uint256 pid,
46         address token,
47         uint256 hardcap,
48         uint256 preUserHardcap,
49         uint256 apy
50     );
51 
52     event Deposit(
53         uint256 indexed pid,
54         address indexed account,
55         uint256 indexed duration,
56         uint256 value
57     );
58 
59     event Harvest(uint256 indexed pid, address indexed account, uint256 earned);
60 
61     event Withdraw(uint256 indexed pid, address indexed account, uint256 value);
62 
63     event AnnounceEndTime(uint256 indexed pid, uint256 indexed finishTime);
64 
65     event InterestInjection(
66         uint256 indexed pid,
67         address indexed provider,
68         uint256 value
69     );
70     event InterestRefund(
71         uint256 indexed pid,
72         address indexed recipient,
73         uint256 value
74     );
75 
76     constructor() {
77         lockDuration[1] = 15 days;
78         lockDuration[2] = 30 days;
79         lockDuration[3] = 60 days;
80         lockDuration[4] = 90 days;
81     }
82 
83     function addPool(
84         IERC20 token,
85         uint256 hardcap,
86         uint256 preUserHardcap,
87         uint256 apy
88     ) external onlyOwner {
89         require(address(token) != address(0), "Hold: Token address is zero");
90         token.balanceOf(address(this)); //Check ERC20
91         pid++;
92         HoldPool storage holdPool = holdPools[pid];
93         holdPool.apy = apy;
94         holdPool.token = token;
95         holdPool.hardcap = hardcap;
96         holdPool.preUserHardcap = preUserHardcap;
97 
98         emit AddHoldPool(pid, address(token), hardcap, preUserHardcap, apy);
99     }
100 
101     function injectInterest(uint256 _pid) external {
102         require(_pid > 0 && _pid <= pid, "Hold: Can't find this pool");
103         HoldPool memory holdPool = holdPools[_pid];
104         require(
105             interestHardcap[_pid] == 0 && interestProvider[_pid] == address(0),
106             "Hold: The pool interest has been injected"
107         );
108         uint256 interestTotal = holdPool
109             .hardcap
110             .mul(holdPool.apy)
111             .mul(lockDuration[4])
112             .div(365 days)
113             .div(1e6);
114         interestHardcap[_pid] = interestTotal;
115         interestProvider[_pid] = msg.sender;
116         holdPool.token.safeTransferFrom(
117             msg.sender,
118             address(this),
119             interestTotal
120         );
121 
122         emit InterestInjection(_pid, msg.sender, interestTotal);
123     }
124 
125     function deposit(
126         uint256 _pid,
127         uint256 value,
128         uint256 opt
129     ) external checkFinish(_pid, lockDuration[opt]) {
130         require(_pid > 0 && _pid <= pid, "Hold: Can't find this pool");
131         require(lockDuration[opt] > 0, "Hold: Without this option");
132         require(
133             holdPools[_pid].depositTotal < holdPools[_pid].hardcap,
134             "Hold: Hard cap limit"
135         );
136         if (holdPools[_pid].depositTotal.add(value) > holdPools[_pid].hardcap) {
137             value = holdPools[_pid].hardcap.sub(holdPools[_pid].depositTotal);
138         }
139         require(
140             value <= holdPools[_pid].preUserHardcap,
141             "Hold: Personal hard cap limit"
142         );
143         require(
144             !depositInfos[msg.sender][_pid].present,
145             "Hold: Individuals can only invest once at the same time"
146         );
147         holdPools[_pid].depositTotal = holdPools[_pid].depositTotal.add(value);
148         depositInfos[msg.sender][_pid].present = true;
149         depositInfos[msg.sender][_pid].value = value;
150         depositInfos[msg.sender][_pid].pid = _pid;
151         depositInfos[msg.sender][_pid].duration = lockDuration[opt];
152         depositInfos[msg.sender][_pid].unlockTime = lockDuration[opt].add(
153             block.timestamp
154         );
155         depositInfos[msg.sender][_pid].earned = value
156             .mul(holdPools[_pid].apy)
157             .mul(lockDuration[opt])
158             .div(365 days)
159             .div(1e6);
160         holdPools[_pid].interest = holdPools[_pid].interest.add(
161             depositInfos[msg.sender][_pid].earned
162         );
163         holdPools[_pid].token.safeTransferFrom(
164             msg.sender,
165             address(this),
166             value
167         );
168         emit Deposit(_pid, msg.sender, lockDuration[opt], value);
169     }
170 
171     function harvest(uint256 _pid) external {
172         require(_pid > 0 && _pid <= pid, "Hold: Can't find this pool");
173         DepositInfo storage depositInfo = depositInfos[msg.sender][_pid];
174         require(
175             block.timestamp > depositInfo.unlockTime,
176             "Hold: Unlocking time is not reached"
177         );
178         require(depositInfo.earned > 0, "Hold: There is no income to receive");
179         uint256 earned = depositInfo.earned;
180         depositInfo.earned = 0;
181         holdPools[depositInfo.pid].token.safeTransfer(msg.sender, earned);
182 
183         emit Harvest(depositInfo.pid, msg.sender, earned);
184     }
185 
186     function withdraw(uint256 _pid) external {
187         require(_pid > 0 && _pid <= pid, "Hold: Can't find this pool");
188         DepositInfo storage depositInfo = depositInfos[msg.sender][_pid];
189         require(
190             block.timestamp > depositInfo.unlockTime,
191             "Hold: Unlocking time is not reached"
192         );
193         require(depositInfo.value > 0, "Hold: There is no deposit to receive");
194         uint256 value = depositInfo.value;
195         depositInfo.value = 0;
196         depositInfo.present = false;
197         holdPools[depositInfo.pid].token.safeTransfer(msg.sender, value);
198         emit Withdraw(depositInfo.pid, msg.sender, value);
199     }
200 
201     modifier checkFinish(uint256 _pid, uint256 duration) {
202         _;
203         if (block.timestamp.add(duration) > finalCompleTime[_pid]) {
204             finalCompleTime[_pid] = block.timestamp.add(duration);
205         }
206         if (holdPools[_pid].hardcap == holdPools[_pid].depositTotal) {
207             holdPools[_pid].finishTime = finalCompleTime[_pid];
208             emit AnnounceEndTime(_pid, holdPools[_pid].finishTime);
209 
210             uint256 interestLeft = interestHardcap[_pid].sub(
211                 holdPools[_pid].interest
212             );
213             if (interestLeft > 0) {
214                 holdPools[_pid].token.safeTransfer(
215                     interestProvider[_pid],
216                     interestLeft
217                 );
218                 emit InterestRefund(_pid, interestProvider[_pid], interestLeft);
219             }
220         }
221     }
222 
223     function holdInProgress() external view returns (HoldPool[] memory) {
224         uint256 len;
225         for (uint256 i = 1; i <= pid; i++) {
226             if (holdPools[i].finishTime > block.timestamp) {
227                 len++;
228             }
229         }
230         HoldPool[] memory pools = new HoldPool[](len);
231         for (uint256 i = 1; i <= pid; i++) {
232             if (holdPools[i].finishTime > block.timestamp) {
233                 pools[i] = holdPools[i];
234             }
235         }
236         return pools;
237     }
238 
239     function holdInFinished() external view returns (HoldPool[] memory) {
240         uint256 len;
241         for (uint256 i = 1; i <= pid; i++) {
242             if (holdPools[i].finishTime <= block.timestamp) {
243                 len++;
244             }
245         }
246         HoldPool[] memory pools = new HoldPool[](len);
247         for (uint256 i = 1; i <= pid; i++) {
248             if (holdPools[i].finishTime <= block.timestamp) {
249                 pools[i] = holdPools[i];
250             }
251         }
252         return pools;
253     }
254 }

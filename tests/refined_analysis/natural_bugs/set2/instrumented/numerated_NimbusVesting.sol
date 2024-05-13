1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Ownable {
16     address public owner;
17     address public newOwner;
18 
19     event OwnershipTransferred(address indexed from, address indexed to);
20 
21     constructor() {
22         owner = msg.sender;
23         emit OwnershipTransferred(address(0), owner);
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner, "Ownable: Caller is not the owner");
28         _;
29     }
30 
31     function transferOwnership(address transferOwner) external onlyOwner {
32         require(transferOwner != newOwner);
33         newOwner = transferOwner;
34     }
35 
36     function acceptOwnership() virtual public {
37         require(msg.sender == newOwner);
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0);
41     }
42 }
43 
44 library SafeBEP20 {
45     using Address for address;
46 
47     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
48         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
49     }
50 
51     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
52         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
53     }
54 
55     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
56         require((value == 0) || (token.allowance(address(this), spender) == 0),
57             "SafeBEP20: approve from non-zero to non-zero allowance"
58         );
59         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
60     }
61 
62     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
63         uint256 newAllowance = token.allowance(address(this), spender) + value;
64         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
65     }
66 
67     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
68         uint256 newAllowance = token.allowance(address(this), spender) - value;
69         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
70     }
71 
72     function callOptionalReturn(IBEP20 token, bytes memory data) private {
73         require(address(token).isContract(), "SafeBEP20: call to non-contract");
74 
75         (bool success, bytes memory returndata) = address(token).call(data);
76         require(success, "SafeBEP20: low-level call failed");
77 
78         if (returndata.length > 0) { 
79             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
80         }
81     }
82 }
83 
84 library Address {
85     function isContract(address account) internal view returns (bool) {
86         // This method relies on extcodesize, which returns 0 for contracts in
87         // construction, since the code is only stored at the end of the
88         // constructor execution.
89 
90         uint256 size;
91         // solhint-disable-next-line no-inline-assembly
92         assembly { size := extcodesize(account) }
93         return size > 0;
94     }
95 }
96 
97 contract Pausable is Ownable {
98     event Pause();
99     event Unpause();
100 
101     bool public paused = false;
102 
103 
104     modifier whenNotPaused() {
105         require(!paused);
106         _;
107     }
108 
109     modifier whenPaused() {
110         require(paused);
111         _;
112     }
113 
114     function pause() onlyOwner whenNotPaused public {
115         paused = true;
116         Pause();
117     }
118 
119     function unpause() onlyOwner whenPaused public {
120         paused = false;
121         Unpause();
122     }
123 }
124 
125 interface INimbusVesting {
126     function vest(address user, uint amount, uint vestingFirstPeriod, uint vestingSecondPeriod) external;
127     function vestWithVestType(address user, uint amount, uint vestingFirstPeriodDuration, uint vestingSecondPeriodDuration, uint vestType) external;
128     function unvest() external returns (uint unvested);
129     function unvestFor(address user) external returns (uint unvested);
130 }
131 
132 contract NimbusVesting is Ownable, Pausable, INimbusVesting { 
133     using SafeBEP20 for IBEP20;
134     
135     IBEP20 public immutable vestingToken;
136 
137     struct VestingInfo {
138         uint vestingAmount;
139         uint unvestedAmount;
140         uint vestingType; //for information purposes and future use in other contracts
141         uint vestingStart;
142         uint vestingReleaseStartDate;
143         uint vestingEnd;
144         uint vestingSecondPeriod;
145     }
146 
147     mapping (address => uint) public vestingNonces;
148     mapping (address => mapping (uint => VestingInfo)) public vestingInfos;
149     mapping (address => bool) public vesters;
150 
151     bool public canAnyoneUnvest;
152 
153     event UpdateVesters(address vester, bool isActive);
154     event Vest(address indexed user, uint vestNonece, uint amount, uint indexed vestingFirstPeriod, uint vestingSecondPeriod, uint vestingReleaseStartDate, uint vestingEnd, uint indexed vestType);
155     event Unvest(address indexed user, uint amount);
156     event Rescue(address indexed to, uint amount);
157     event RescueToken(address indexed to, address indexed token, uint amount);
158     event ToggleCanAnyoneUnvest(bool indexed canAnyoneUnvest);
159 
160     constructor(address vestingTokenAddress) {
161         require(Address.isContract(vestingTokenAddress), "NimbusVesting: Not a contract");
162         vestingToken = IBEP20(vestingTokenAddress);
163     }
164     
165     function vest(address user, uint amount, uint vestingFirstPeriod, uint vestingSecondPeriod) override external whenNotPaused { 
166         vestWithVestType(user, amount, vestingFirstPeriod, vestingSecondPeriod, 0);
167     }
168 
169     function vestWithVestType(address user, uint amount, uint vestingFirstPeriodDuration, uint vestingSecondPeriodDuration, uint vestType) override public whenNotPaused {
170         require (msg.sender == owner || vesters[msg.sender], "NimbusVesting::vest: Not allowed");
171         require(user != address(0), "NimbusVesting::vest: Vest to the zero address");
172         uint nonce = ++vestingNonces[user];
173 
174         vestingInfos[user][nonce].vestingAmount = amount;
175         vestingInfos[user][nonce].vestingType = vestType;
176         vestingInfos[user][nonce].vestingStart = block.timestamp;
177         vestingInfos[user][nonce].vestingSecondPeriod = vestingSecondPeriodDuration;
178         uint vestingReleaseStartDate = block.timestamp + vestingFirstPeriodDuration;
179         uint vestingEnd = vestingReleaseStartDate + vestingSecondPeriodDuration;
180         vestingInfos[user][nonce].vestingReleaseStartDate = vestingReleaseStartDate;
181         vestingInfos[user][nonce].vestingEnd = vestingEnd;
182         emit Vest(user, nonce, amount, vestingFirstPeriodDuration, vestingSecondPeriodDuration, vestingReleaseStartDate, vestingEnd, vestType);
183     }
184 
185     function unvest() external override whenNotPaused returns (uint unvested) {
186         return _unvest(msg.sender);
187     }
188 
189     function unvestFor(address user) external override whenNotPaused returns (uint unvested) {
190         require(canAnyoneUnvest || vesters[msg.sender], "NimbusVesting: Not allowed");
191         return _unvest(user);
192     }
193 
194     function unvestForBatch(address[] memory users) external whenNotPaused returns (uint unvested) {
195         require(canAnyoneUnvest || vesters[msg.sender], "NimbusVesting: Not allowed");
196         uint length = users.length;
197         for (uint i = 0; i < length; i++) {
198             unvested += _unvest(users[i]);
199         }
200     }
201 
202     function _unvest(address user) internal returns (uint unvested) {
203         uint nonce = vestingNonces[user]; 
204         require (nonce > 0, "NimbusVesting: No vested amount");
205         for (uint i = 1; i <= nonce; i++) {
206             VestingInfo memory vestingInfo = vestingInfos[user][i];
207             if (vestingInfo.vestingAmount == vestingInfo.unvestedAmount) continue;
208             if (vestingInfo.vestingReleaseStartDate > block.timestamp) continue;
209             uint toUnvest;
210             if (vestingInfo.vestingSecondPeriod != 0) {
211                 toUnvest = (block.timestamp - vestingInfo.vestingReleaseStartDate) * vestingInfo.vestingAmount / vestingInfo.vestingSecondPeriod;
212                 if (toUnvest > vestingInfo.vestingAmount) {
213                     toUnvest = vestingInfo.vestingAmount;
214                 } 
215             } else {
216                 toUnvest = vestingInfo.vestingAmount;
217             }
218             uint totalUnvestedForNonce = toUnvest;
219             toUnvest -= vestingInfo.unvestedAmount;
220             unvested += toUnvest;
221             vestingInfos[user][i].unvestedAmount = totalUnvestedForNonce;
222         }
223         require(unvested > 0, "NimbusVesting: Unvest amount is zero");
224         vestingToken.safeTransfer(user, unvested);
225         emit Unvest(user, unvested);
226     }
227 
228     function availableForUnvesting(address user) external view returns (uint unvestAmount) {
229         uint nonce = vestingNonces[user];
230         if (nonce == 0) return 0;
231         for (uint i = 1; i <= nonce; i++) {
232             VestingInfo memory vestingInfo = vestingInfos[user][i];
233             if (vestingInfo.vestingAmount == vestingInfo.unvestedAmount) continue;
234             if (vestingInfo.vestingReleaseStartDate > block.timestamp) continue;
235             uint toUnvest;
236             if (vestingInfo.vestingSecondPeriod != 0) {
237                 toUnvest = (block.timestamp - vestingInfo.vestingReleaseStartDate) * vestingInfo.vestingAmount / vestingInfo.vestingSecondPeriod;
238                 if (toUnvest > vestingInfo.vestingAmount) {
239                     toUnvest = vestingInfo.vestingAmount;
240                 } 
241             } else {
242                 toUnvest = vestingInfo.vestingAmount;
243             }
244             toUnvest -= vestingInfo.unvestedAmount;
245             unvestAmount += toUnvest;
246         }
247     }
248 
249     function userUnvested(address user) external view returns (uint totalUnvested) {
250         uint nonce = vestingNonces[user];
251         if (nonce == 0) return 0;
252         for (uint i = 1; i <= nonce; i++) {
253             VestingInfo memory vestingInfo = vestingInfos[user][i];
254             if (vestingInfo.vestingReleaseStartDate > block.timestamp) continue;
255             totalUnvested += vestingInfo.unvestedAmount;
256         }
257     }
258 
259 
260     function userVestedUnclaimed(address user) external view returns (uint unclaimed) {
261         uint nonce = vestingNonces[user];
262         if (nonce == 0) return 0;
263         for (uint i = 1; i <= nonce; i++) {
264             VestingInfo memory vestingInfo = vestingInfos[user][i];
265             if (vestingInfo.vestingAmount == vestingInfo.unvestedAmount) continue;
266             unclaimed += (vestingInfo.vestingAmount - vestingInfo.unvestedAmount);
267         }
268     }
269 
270     function userTotalVested(address user) external view returns (uint totalVested) {
271         uint nonce = vestingNonces[user];
272         if (nonce == 0) return 0;
273         for (uint i = 1; i <= nonce; i++) {
274             totalVested += vestingInfos[user][i].vestingAmount;
275         }
276     }
277 
278     function updateVesters(address vester, bool isActive) external onlyOwner { 
279         require(vester != address(0), "NimbusVesting::updateVesters: Zero address");
280         vesters[vester] = isActive;
281         emit UpdateVesters(vester, isActive);
282     }
283 
284     function toggleCanAnyoneUnvest() external onlyOwner { 
285         canAnyoneUnvest = !canAnyoneUnvest;
286         emit ToggleCanAnyoneUnvest(canAnyoneUnvest);
287     }
288 
289     function rescue(address to, address tokenAddress, uint256 amount) external onlyOwner {
290         require(to != address(0), "NimbusVesting::rescue: Cannot rescue to the zero address");
291         require(amount > 0, "NimbusVesting::rescue: Cannot rescue 0");
292 
293         IBEP20(tokenAddress).safeTransfer(to, amount);
294         emit RescueToken(to, address(tokenAddress), amount);
295     }
296 
297     function rescue(address payable to, uint256 amount) external onlyOwner {
298         require(to != address(0), "NimbusVesting::rescue: Cannot rescue to the zero address");
299         require(amount > 0, "NimbusVesting::rescue Cannot rescue 0");
300 
301         to.transfer(amount);
302         emit Rescue(to, amount);
303     }
304 }
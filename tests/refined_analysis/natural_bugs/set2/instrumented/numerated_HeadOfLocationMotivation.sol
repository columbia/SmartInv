1 pragma solidity =0.8.0;
2 
3 contract Ownable {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed from, address indexed to);
8 
9     constructor() {
10         owner = msg.sender;
11         emit OwnershipTransferred(address(0), owner);
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner, "Ownable: Caller is not the owner");
16         _;
17     }
18 
19     function getOwner() external view returns (address) {
20         return owner;
21     }
22 
23     function transferOwnership(address transferOwner) external onlyOwner {
24         require(transferOwner != newOwner);
25         newOwner = transferOwner;
26     }
27 
28     function acceptOwnership() virtual external {
29         require(msg.sender == newOwner);
30         emit OwnershipTransferred(owner, newOwner);
31         owner = newOwner;
32         newOwner = address(0);
33     }
34 }
35 
36 
37 abstract contract Pausable is Ownable {
38     event Paused(address account);
39     event Unpaused(address account);
40 
41     bool private _paused;
42 
43     constructor () {
44         _paused = false;
45     }
46 
47     function paused() public view returns (bool) {
48         return _paused;
49     }
50 
51     modifier whenNotPaused() {
52         require(!_paused, "Pausable: paused");
53         _;
54     }
55 
56     modifier whenPaused() {
57         require(_paused, "Pausable: not paused");
58         _;
59     }
60 
61 
62     function pause() external onlyOwner whenNotPaused {
63         _paused = true;
64         emit Paused(msg.sender);
65     }
66 
67     function unpause() external onlyOwner whenPaused {
68         _paused = false;
69         emit Unpaused(msg.sender);
70     }
71 }
72 
73 
74 interface IBEP20 {
75     function totalSupply() external view returns (uint256);
76     function decimals() external view returns (uint8);
77     function balanceOf(address account) external view returns (uint256);
78     function transfer(address recipient, uint256 amount) external returns (bool);
79     function allowance(address owner, address spender) external view returns (uint256);
80     function approve(address spender, uint256 amount) external returns (bool);
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82     function getOwner() external view returns (address);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 interface INimbusReferralProgramMarketing {
90     function isHeadOfLocation(address user) external view returns(bool);
91     function headOfLocationTurnover(address user) external view returns(uint);
92 }
93 
94 
95 library Address {
96     function isContract(address account) internal view returns (bool) {
97         // This method relies in extcodesize, which returns 0 for contracts in construction, 
98         // since the code is only stored at the end of the constructor execution.
99 
100         uint256 size;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 }
106 
107 library SafeBEP20 {
108     using Address for address;
109 
110     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
111         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
112     }
113 
114     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
115         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
116     }
117 
118     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
119         require((value == 0) || (token.allowance(address(this), spender) == 0),
120             "SafeBEP20: approve from non-zero to non-zero allowance"
121         );
122         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
123     }
124 
125     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
126         uint256 newAllowance = token.allowance(address(this), spender) + value;
127         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
128     }
129 
130     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
131         uint256 newAllowance = token.allowance(address(this), spender) - value;
132         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
133     }
134 
135     function callOptionalReturn(IBEP20 token, bytes memory data) private {
136         require(address(token).isContract(), "SafeBEP20: call to non-contract");
137 
138         (bool success, bytes memory returndata) = address(token).call(data);
139         require(success, "SafeBEP20: low-level call failed");
140 
141         if (returndata.length > 0) { 
142             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
143         }
144     }
145 }
146 
147 library TransferHelper {
148     function safeApprove(address token, address to, uint value) internal {
149         // bytes4(keccak256(bytes('approve(address,uint256)')));
150         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
151         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
152     }
153 
154     function safeTransfer(address token, address to, uint value) internal {
155         // bytes4(keccak256(bytes('transfer(address,uint256)')));
156         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
157         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
158     }
159 
160     function safeTransferFrom(address token, address from, address to, uint value) internal {
161         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
162         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
163         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
164     }
165 
166     function safeTransferBNB(address to, uint value) internal {
167         (bool success,) = to.call{value:value}(new bytes(0));
168         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
169     }
170 }
171 
172 
173 contract HeadOfLocationMotivation is Ownable, Pausable {
174     using SafeBEP20 for IBEP20;
175 
176     IBEP20 public immutable SYSTEM_TOKEN;
177     INimbusReferralProgramMarketing public referralProgramMarketing;
178 
179     mapping(address => bool) public isAllowedToReceiveReward;
180     mapping(address => uint) public holLastTurnoverAmount;
181 
182     uint public percent;
183 
184     event HolClaimReward(address indexed user, uint amount);
185     event Rescue(address indexed to, uint amount);
186     event RescueToken(address indexed token, address indexed to, uint amount);
187     event UpdateReferralProgramMarketing(address newContract);
188     event ImportUser(address user, uint lastTurnoverAmount);
189     event UpdatePercent(uint indexed newPercent);
190 
191     constructor (address systemToken, address referralProgramMarketingAddress) {
192         require(Address.isContract(systemToken), "HeadOfLocationMotivation: SystemToken is not a contract");
193         require(Address.isContract(referralProgramMarketingAddress), "HeadOfLocationMotivation: ReferralProgramMarketing is not a contract");
194         SYSTEM_TOKEN = IBEP20(systemToken);
195         referralProgramMarketing = INimbusReferralProgramMarketing(referralProgramMarketingAddress);
196         percent = 300; //3%
197     }
198 
199     function claimReward() external returns (uint) {
200         require(referralProgramMarketing.isHeadOfLocation(msg.sender), "HeadOfLocationMotivation: User is not head of location");
201         require(isAllowedToReceiveReward[msg.sender], "HeadOfLocationMotivation: User disallowed to receive reward");
202         uint turnover = referralProgramMarketing.headOfLocationTurnover(msg.sender);
203         uint reward = _getRewardAmount(msg.sender, turnover);
204         require(reward > 0, "HeadOfLocationMotivation: Reward amount is zero");
205         SYSTEM_TOKEN.safeTransfer(msg.sender, reward);
206         holLastTurnoverAmount[msg.sender] = turnover;
207         emit HolClaimReward(msg.sender, reward);
208         return reward;
209     }
210 
211     function getRewardAmount(address user) external view returns (uint) {
212         require(referralProgramMarketing.isHeadOfLocation(user), "HeadOfLocationMotivation: User is not head of location");
213         require(isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User disallowed to receive reward");
214         uint turnover = referralProgramMarketing.headOfLocationTurnover(user);
215         return _getRewardAmount(user,turnover);
216     }
217 
218     function _getRewardAmount(address user, uint turnover) private view returns (uint){
219         uint difference = turnover - holLastTurnoverAmount[user];
220         uint reward = difference * percent / 10000;
221         return reward;
222     }
223     
224 
225 
226     
227     function allowUserToReceiveReward(address user) external onlyOwner {
228         require(referralProgramMarketing.isHeadOfLocation(user), "HeadOfLocationMotivation: User is not head of location");
229         require(!isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User already allowed");
230         isAllowedToReceiveReward[user] = true;
231     }
232 
233     function disallowUserToReceiveReward(address user) external onlyOwner {
234         require(isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User already disallowed");
235         isAllowedToReceiveReward[user] = false;
236     }
237 
238     function updatePercent(uint newPercent) external onlyOwner {
239         require(newPercent > 0 && newPercent <= 10000, "HeadOfLocationMotivation: Wrong percent amount");
240         require(newPercent != percent, "HeadOfLocationMotivation: New percent is the same as the old one");
241         percent = newPercent;
242         emit UpdatePercent(newPercent);
243     }
244 
245     function rescue(address payable to, uint256 amount) external onlyOwner {
246         require(to != address(0), "HeadOfLocationMotivation: Can't be zero address");
247         require(amount > 0, "HeadOfLocationMotivation: Should be greater than 0");
248         TransferHelper.safeTransferBNB(to, amount);
249         emit Rescue(to, amount);
250     }
251 
252     function rescue(address to, address token, uint256 amount) external onlyOwner {
253         require(to != address(0), "HeadOfLocationMotivation: Can't be zero address");
254         require(amount > 0, "HeadOfLocationMotivation: Should be greater than 0");
255         TransferHelper.safeTransfer(token,to, amount);
256         emit RescueToken(token, to, amount);
257     }
258 
259     function importUsers(address[] memory users, uint[] memory amounts, bool[] memory isAllowed, bool addToExistent, bool checkAmount) external onlyOwner {
260         require(users.length == amounts.length && users.length == isAllowed.length, "HeadOfLocationMotivation: Wrong lengths");
261 
262         for (uint256 i = 0; i < users.length; i++) {
263             uint amount;
264             if (addToExistent) {
265                 amount = holLastTurnoverAmount[users[i]] + amounts[i];
266             } else {
267                 amount = amounts[i];
268             } 
269             if (checkAmount) {
270                 require(referralProgramMarketing.headOfLocationTurnover(users[i]) >= amount);
271             }
272             holLastTurnoverAmount[users[i]] = amount;
273             isAllowedToReceiveReward[users[i]] = isAllowed[i];
274             emit ImportUser(users[i], amount);
275         }
276     }
277 
278     function updateReferralProgramMarketingContract(address newReferralProgramMarketingContract) external onlyOwner {
279         require(newReferralProgramMarketingContract != address(0), "HeadOfLocationMotivation: Address is zero");
280         referralProgramMarketing = INimbusReferralProgramMarketing(newReferralProgramMarketingContract);
281         emit UpdateReferralProgramMarketing(newReferralProgramMarketingContract);
282     }
283 }

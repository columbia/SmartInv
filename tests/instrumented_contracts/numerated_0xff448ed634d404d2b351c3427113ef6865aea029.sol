1 //SPDX-License-Identifier: UNLICENSED
2 /*
3 
4 FairHEX is a reflection token built on top of HEX
5 
6 Claim your free FairHEX token
7 
8 Website : https://fairhex.eth.limo
9 
10 */
11 
12 pragma solidity ^0.8.17;
13 
14 abstract contract ReentrancyGuard {
15     uint256 private constant _NOT_ENTERED = 1;
16     uint256 private constant _ENTERED = 2;
17 
18     uint256 private _status;
19 
20     constructor() {
21         _status = _NOT_ENTERED;
22     }
23 
24     modifier nonReentrant() {
25         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
26         _status = _ENTERED;
27         _;
28         _status = _NOT_ENTERED;
29     }
30 }
31 
32 contract TOKEN1 {
33     function balanceOf(address account) external view returns (uint256) {}
34     function transfer(address recipient, uint256 amount) external returns (bool) {}
35 }
36 
37 contract TOKEN2 {
38     function balanceOf(address account) external view returns (uint256) {}
39     function transfer(address recipient, uint256 amount) external returns (bool) {}
40     function approve(address spender, uint256 amount) external returns (bool) {}
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {}
42     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external {}
43     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external {}
44     function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam) external {}
45     function stakeCount(address stakerAddr) external view returns (uint256) {}
46     function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool) {}
47     function currentDay() external view returns (uint256) {}
48 }
49 
50 contract TOKEN3 {
51     function balanceOf(address account) external view returns (uint256) {}
52     function transfer(address recipient, uint256 amount) external returns (bool) {}
53     function mintNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256) {}
54 }
55 
56 contract UniSwapV2LiteRouter {
57     function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts) {}
58 }
59 
60 contract FairHexStaking is ReentrancyGuard {
61     modifier onlyCustodian() {
62         require(msg.sender == custodian);
63         _;
64     }
65 
66     event onStakeStart(
67         address indexed customerAddress,
68         uint256 uniqueID,
69         uint256 timestamp
70     );
71 
72     event onStakeEnd(
73         address indexed customerAddress,
74         uint256 uniqueID,
75         uint256 returnAmount,
76         uint256 fairHexAmount,
77         uint256 timestamp
78     );
79 
80     uint256 public totalStakeBalance = 0;
81     bool public finalizeAddress = false;
82     bool public normalStaking = false;
83     address public custodian = address(0x12414A2144b6048010c1b0fe67f25072E06DC0B1);
84 
85     address private fairHexAddress = address(0x0);
86     address private hexAddress = address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39);
87     address private hedronAddress = address(0x3819f64f282bf135d62168C1e513280dAF905e06);
88     address private routerAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
89     TOKEN1 fairHexToken = TOKEN1(fairHexAddress);
90     TOKEN2 hexToken = TOKEN2(hexAddress);
91     TOKEN3 hedronToken=  TOKEN3(hedronAddress);
92     UniSwapV2LiteRouter private router = UniSwapV2LiteRouter(routerAddress);
93 
94     struct StakeStore {
95       uint40 stakeID;
96       uint256 hexAmount;
97       uint72 stakeShares;
98       uint16 lockedDay;
99       uint16 stakedDays;
100       uint16 unlockedDay;
101       bool started;
102       bool ended;
103       uint256 bonusMultiplier;
104       bool mintState;
105     }
106 
107     uint256 public totalMinted = 0;
108     uint256 public currentBonusMultiplier = 40;
109     uint256 public minimumHex = 100000000000;
110     mapping(address => mapping(uint256 => StakeStore)) public stakeLists;
111     mapping(address => bool) public hexStaking;
112     mapping(address => bool) public allowHedron;
113 
114     constructor() ReentrancyGuard() {
115         hexToken.approve(routerAddress, type(uint256).max);
116     }
117 
118     function checkAndTransferHEX(uint256 _amount) private {
119         require(hexToken.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
120     }
121 
122     function updateTotalStakeBalanceAndBonusMultiplier(bool start, uint256 _amount) private {
123         if (start == true) {
124           totalStakeBalance += _amount;
125         } else {
126           totalStakeBalance -= _amount;
127         }
128 
129         if (totalStakeBalance >= 20000000000000000 ) {
130           currentBonusMultiplier = 20;
131         } else {
132           currentBonusMultiplier = 40 - (totalStakeBalance / 1000000000000000);
133         }
134     }
135 
136     function stakeStart(uint256 _amount, uint256 _days) nonReentrant external {
137         require(_amount >= minimumHex && _amount <= 4722366482869645213695);
138         require(hexToken.stakeCount(address(this)) < type(uint256).max);
139 
140         checkAndTransferHEX(_amount);
141 
142         bool _mintState;
143 
144         if (totalMinted < 5000000e18) {
145           require(_days == 7 || _days == 15 || _days == 30);
146           uint256 _mintAmount;
147 
148           if (_days == 7) {
149             _mintAmount = _amount * 1e10 / 514;
150           } else if (_days == 15) {
151             _mintAmount = _amount * 1e10 / 240;
152           } else if (_days == 30) {
153             _mintAmount = _amount * 1e10 / 120;
154           }
155           
156           _mintState = true;
157 
158           if ((totalMinted + _mintAmount) <= 5000000e18) {
159             totalMinted += _mintAmount;
160           } else {
161             _mintAmount = 5000000e18 - totalMinted;
162             totalMinted = 5000000e18;
163           }
164 
165           fairHexToken.transfer(msg.sender, _mintAmount);
166         }
167 
168         hexToken.stakeStart(_amount, _days);
169         updateTotalStakeBalanceAndBonusMultiplier(true, _amount);
170 
171         uint256 _stakeIndex;
172         uint40 _stakeID;
173         uint72 _stakeShares;
174         uint16 _lockedDay;
175         uint16 _stakedDays;
176 
177         _stakeIndex = hexToken.stakeCount(address(this));
178         _stakeIndex -= 1;
179         (_stakeID,,_stakeShares,_lockedDay,_stakedDays,,) = hexToken.stakeLists(address(this), _stakeIndex);
180 
181         uint256 _uniqueID =  uint256(keccak256(abi.encodePacked(_stakeID, _stakeShares)));
182         require(stakeLists[msg.sender][_uniqueID].started == false);
183         stakeLists[msg.sender][_uniqueID].started = true;
184 
185         stakeLists[msg.sender][_uniqueID] = StakeStore(_stakeID, _amount, _stakeShares, _lockedDay, _stakedDays, uint16(0), true, false, currentBonusMultiplier, _mintState);
186 
187         emit onStakeStart(msg.sender, _uniqueID, block.timestamp);
188     }
189 
190     function _stakeSecurityCheck(address _stakerAddress, uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) private view returns (uint16) {
191         uint40 _stakeID;
192         uint72 _stakedHearts;
193         uint72 _stakeShares;
194         uint16 _lockedDay;
195         uint16 _stakedDays;
196         uint16 _unlockedDay;
197 
198         (_stakeID,_stakedHearts,_stakeShares,_lockedDay,_stakedDays,_unlockedDay,) = hexToken.stakeLists(address(this), _stakeIndex);
199         require(stakeLists[_stakerAddress][_uniqueID].started == true && stakeLists[_stakerAddress][_uniqueID].ended == false);
200         require(stakeLists[_stakerAddress][_uniqueID].stakeID == _stakeIdParam && _stakeIdParam == _stakeID);
201         require(stakeLists[_stakerAddress][_uniqueID].hexAmount == uint256(_stakedHearts));
202         require(stakeLists[_stakerAddress][_uniqueID].stakeShares == _stakeShares);
203         require(stakeLists[_stakerAddress][_uniqueID].lockedDay == _lockedDay);
204         require(stakeLists[_stakerAddress][_uniqueID].stakedDays == _stakedDays);
205 
206         return _unlockedDay;
207     }
208 
209     function _stakeEnd(address _stakerAddress, uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID, uint256 _amountOutMin) private {
210         uint16 _unlockedDay = _stakeSecurityCheck(_stakerAddress, _stakeIndex, _stakeIdParam, _uniqueID);
211         uint16 _currentDay = uint16(hexToken.currentDay());
212 
213         if (_unlockedDay == 0) {
214           stakeLists[_stakerAddress][_uniqueID].unlockedDay = _currentDay;
215         } else {
216           stakeLists[_stakerAddress][_uniqueID].unlockedDay = _unlockedDay;
217         }
218 
219         uint256 _balance = hexToken.balanceOf(address(this));
220 
221         if (allowHedron[_stakerAddress] == true && _currentDay >= stakeLists[_stakerAddress][_uniqueID].lockedDay) {
222             hedronToken.mintNative(_stakeIndex, _stakeIdParam);
223             hedronToken.transfer(_stakerAddress, hedronToken.balanceOf(address(this)));
224         }
225 
226         hexToken.stakeEnd(_stakeIndex, _stakeIdParam);
227         stakeLists[_stakerAddress][_uniqueID].ended = true;
228 
229         uint256 _amount = hexToken.balanceOf(address(this)) - _balance;
230         uint256 _stakedAmount = stakeLists[_stakerAddress][_uniqueID].hexAmount;
231         uint256 _bonusDividend;
232 
233         if (stakeLists[_stakerAddress][_uniqueID].mintState && _currentDay < (stakeLists[_stakerAddress][_uniqueID].lockedDay + stakeLists[_stakerAddress][_uniqueID].stakedDays)) {
234           require(false, "minters cannot end pending or early stakes");
235         } else if (_currentDay < stakeLists[_stakerAddress][_uniqueID].lockedDay) {
236           uint256 _pendingStakefee = _amount / 100;
237           swapAndReceive(address(this), _pendingStakefee, _amountOutMin);
238           _amount -=  _pendingStakefee;
239           hexToken.transfer(_stakerAddress, _amount);
240         } else if (_amount <= _stakedAmount || hexStaking[_stakerAddress] == true) {
241           hexToken.transfer(_stakerAddress, _amount);
242         } else if (_amount > _stakedAmount) {
243           uint256 _bonusAmount;
244           uint256 _difference = _amount - _stakedAmount;
245           hexToken.transfer(_stakerAddress, _stakedAmount);
246           _bonusDividend = swapAndReceive(_stakerAddress, _difference, _amountOutMin);
247           _bonusAmount = _bonusDividend * stakeLists[_stakerAddress][_uniqueID].bonusMultiplier / 100;
248 
249           if (_bonusAmount > 0) {
250             if (fairHexToken.balanceOf(address(this)) >= _bonusAmount) {
251               fairHexToken.transfer(_stakerAddress, _bonusAmount);
252             } else {
253               fairHexToken.transfer(_stakerAddress, fairHexToken.balanceOf(address(this)));
254             }
255           }
256         }
257 
258         updateTotalStakeBalanceAndBonusMultiplier(false, _stakedAmount);
259 
260         emit onStakeEnd(_stakerAddress, _uniqueID, _amount, _bonusDividend, block.timestamp);
261     }
262 
263     function stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID, uint256 _amountOutMin) nonReentrant external {
264         _stakeEnd(msg.sender, _stakeIndex, _stakeIdParam, _uniqueID, _amountOutMin);
265     }
266 
267     function swapAndReceive(address _receiver, uint256 _hex, uint256 _amountOutMin) private returns (uint256) {
268         address[] memory path = new address[](2);
269         path[0] = hexAddress;
270         path[1] = fairHexAddress;
271         uint[] memory _amounts = router.swapExactTokensForTokens(_hex, _amountOutMin, path, address(this), block.timestamp);
272 
273         if (_amounts[1] > 0) {
274           fairHexToken.transfer(_receiver, _amounts[1]);
275         }
276 
277         return _amounts[1];
278     }
279 
280     function revertToHexStaking() onlyCustodian external {
281         normalStaking = true;
282     }
283 
284     function toggleHexStaking() external {
285         require (normalStaking == true);
286 
287         if (hexStaking[msg.sender] == false) {
288           hexStaking[msg.sender] = true;
289         } else {
290           hexStaking[msg.sender] = false;
291         }
292     }
293 
294     function toggleHedron() external {
295         if (allowHedron[msg.sender] == false) {
296           allowHedron[msg.sender] = true;
297         } else {
298           allowHedron[msg.sender] = false;
299         }
300     }
301 
302     function reApproveContractForUniswap() external {
303         hexToken.approve(routerAddress, type(uint256).max);
304     }
305 
306     function setTokenAddress(address _proposedAddress) onlyCustodian external {
307         require(finalizeAddress == false);
308         fairHexAddress = _proposedAddress;
309         fairHexToken = TOKEN1(fairHexAddress);
310     }
311 
312     function finalizeTokenAddress() onlyCustodian external {
313         finalizeAddress = true;
314     }
315 }
316 
317 /*
318 
319 THE CONTRACT, SUPPORTING WEBSITES, AND ALL OTHER INTERFACES (THE SOFTWARE) IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
320 LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
321 
322 BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU BEAR ALL THE RISKS ASSOCIATED WITH DOING SO. AN INFINITE NUMBER OF UNPREDICTABLE THINGS MAY GO WRONG WHICH COULD POTENTIALLY RESULT IN CRITICAL FAILURE AND FINANCIAL LOSS. BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU AGREE THERE IS NO RECOURSE AVAILABLE AND YOU WILL NOT SEEK IT.
323 
324 INTERACTING WITH THE SOFTWARE SHALL NOT BE CONSIDERED AN INVESTMENT OR A COMMON ENTERPRISE. INSTEAD, INTERACTING WITH THE SOFTWARE IS EQUIVALENT TO CARPOOLING WITH FRIENDS TO SAVE ON GAS AND EXPERIENCE THE BENEFITS OF THE H.O.V. LANE.
325 
326 YOU SHALL HAVE NO EXPECTATION OF PROFIT OR ANY TYPE OF GAIN FROM THE WORK OF OTHER PEOPLE.
327 
328 */
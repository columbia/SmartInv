1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49 
50         return c;
51     }
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 
61 library Address {
62     function isContract(address account) internal view returns (bool) {
63         bytes32 codehash;
64         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
65         // solhint-disable-next-line no-inline-assembly
66         assembly { codehash := extcodehash(account) }
67         return (codehash != 0x0 && codehash != accountHash);
68     }
69     function toPayable(address account) internal pure returns (address payable) {
70         return address(uint160(account));
71     }
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         // solhint-disable-next-line avoid-call-value
76         (bool success, ) = recipient.call{ value : amount }("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79 }
80 
81 library SafeERC20 {
82     using SafeMath for uint256;
83     using Address for address;
84 
85     function safeTransfer(IERC20 token, address to, uint256 value) internal {
86         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
87     }
88 
89     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
90         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
91     }
92 
93     function safeApprove(IERC20 token, address spender, uint256 value) internal {
94         require((value == 0) || (token.allowance(address(this), spender) == 0),
95             "SafeERC20: approve from non-zero to non-zero allowance"
96         );
97         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
98     }
99 
100     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
101         uint256 newAllowance = token.allowance(address(this), spender).add(value);
102         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
103     }
104 
105     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
106         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
107         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
108     }
109     function callOptionalReturn(IERC20 token, bytes memory data) private {
110         require(address(token).isContract(), "SafeERC20: call to non-contract");
111 
112         // solhint-disable-next-line avoid-low-level-calls
113         (bool success, bytes memory returndata) = address(token).call(data);
114         require(success, "SafeERC20: low-level call failed");
115 
116         if (returndata.length > 0) { // Return data is optional
117             // solhint-disable-next-line max-line-length
118             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
119         }
120     }
121 }
122 
123 contract pFDIVault {
124     using SafeERC20 for IERC20;
125     using Address for address;
126     using SafeMath for uint256;
127     
128     struct RewardDivide {
129         uint256 amount;
130         uint256 startTime;
131         uint256 checkTime;
132     }
133 
134     string public _vaultName;
135     IERC20 public token0;
136     IERC20 public token1;
137     address public feeAddress;
138     address public vaultAddress;
139     uint32 public feePermill = 5;
140     uint256 public delayDuration = 7 days;
141     bool public withdrawable;
142     
143     address public gov;
144     uint256 public totalDeposit;
145     mapping(address => uint256) public depositBalances;
146     mapping(address => uint256) public rewardBalances;
147     address[] public addressIndices;
148 
149     mapping(uint256 => RewardDivide) public _rewards;
150     uint256 public _rewardCount;
151 
152     event SentReward(uint256 amount);
153     event Deposited(address indexed user, uint256 amount);
154     event ClaimedReward(address indexed user, uint256 amount);
155     event Withdrawn(address indexed user, uint256 amount);
156 
157     constructor (address _token0, address _token1, address _feeAddress, address _vaultAddress, string memory name) {
158         token0 = IERC20(_token0);
159         token1 = IERC20(_token1);
160         feeAddress = _feeAddress;
161         vaultAddress = _vaultAddress;
162         _vaultName = name;
163         gov = msg.sender;
164     }
165 
166     modifier onlyGov() {
167         require(msg.sender == gov, "!governance");
168         _;
169     }
170 
171     function setGovernance(address _gov)
172         external
173         onlyGov
174     {
175         gov = _gov;
176     }
177 
178     function setToken0(address _token)
179         external
180         onlyGov
181     {
182         token0 = IERC20(_token);
183     }
184 
185     function setToken1(address _token)
186         external
187         onlyGov
188     {
189         token1 = IERC20(_token);
190     }
191 
192     function setFeeAddress(address _feeAddress)
193         external
194         onlyGov
195     {
196         feeAddress = _feeAddress;
197     }
198 
199     function setVaultAddress(address _vaultAddress)
200         external
201         onlyGov
202     {
203         vaultAddress = _vaultAddress;
204     }
205 
206     function setFeePermill(uint32 _feePermill)
207         external
208         onlyGov
209     {
210         feePermill = _feePermill;
211     }
212 
213     function setDelayDuration(uint32 _delayDuration)
214         external
215         onlyGov
216     {
217         delayDuration = _delayDuration;
218     }
219 
220     function setWithdrawable(bool _withdrawable)
221         external
222         onlyGov
223     {
224         withdrawable = _withdrawable;
225     }
226 
227     function setVaultName(string memory name)
228         external
229         onlyGov
230     {
231         _vaultName = name;
232     }
233 
234     function balance0()
235         public
236         view
237         returns (uint256)
238     {
239         return token0.balanceOf(address(this));
240     }
241 
242     function balance1()
243         public
244         view
245         returns (uint256)
246     {
247         return token1.balanceOf(address(this));
248     }
249 
250     function rewardUpdate()
251         public
252     {
253         if (_rewardCount > 0 && totalDeposit > 0) {
254             uint256 i;
255             uint256 j;
256 
257             for (i = _rewardCount - 1; _rewards[i].startTime < block.timestamp; --i) {
258                 uint256 duration;
259                 if (block.timestamp.sub(_rewards[i].startTime) > delayDuration) {
260                     duration = _rewards[i].startTime.add(delayDuration).sub(_rewards[i].checkTime);
261                     _rewards[i].startTime = uint256(-1);
262                 } else {
263                     duration = block.timestamp.sub(_rewards[i].checkTime);
264                 }
265                 _rewards[i].checkTime = block.timestamp;
266                 uint256 timedAmount = _rewards[i].amount.mul(duration).div(delayDuration);
267                 uint256 addAmount;
268                 for (j = 0; j < addressIndices.length; j++) {
269                     addAmount = timedAmount.mul(depositBalances[addressIndices[j]]).div(totalDeposit);
270                     rewardBalances[addressIndices[j]] = rewardBalances[addressIndices[j]].add(addAmount);
271                 }
272                 if (i == 0) {
273                     break;
274                 }
275             }
276         }
277     }
278 
279     function depositAll()
280         external
281     {
282         deposit(token0.balanceOf(msg.sender));
283     }
284     
285     function deposit(uint256 _amount)
286         public
287     {
288         require(_amount > 0, "can't deposit 0");
289 
290         rewardUpdate();
291 
292         uint256 arrayLength = addressIndices.length;
293         bool found = false;
294         for (uint256 i = 0; i < arrayLength; i++) {
295             if (addressIndices[i]==msg.sender){
296                 found=true;
297                 break;
298             }
299         }
300         
301         if(!found){
302             addressIndices.push(msg.sender);
303         }
304         
305         uint256 feeAmount = _amount.mul(feePermill).div(1000);
306         uint256 realAmount = _amount.sub(feeAmount);
307         
308         if (feeAmount > 0) {
309             token0.safeTransferFrom(msg.sender, feeAddress, feeAmount);
310         }
311         if (realAmount > 0) {
312             token0.safeTransferFrom(msg.sender, vaultAddress, realAmount);
313             totalDeposit = totalDeposit.add(realAmount);
314             depositBalances[msg.sender] = depositBalances[msg.sender].add(realAmount);
315             emit Deposited(msg.sender, realAmount);
316         }
317     }
318     
319     function sendReward(uint256 _amount)
320         external
321     {
322         require(_amount > 0, "can't reward 0");
323         require(totalDeposit > 0, "totalDeposit must bigger than 0");
324         token1.safeTransferFrom(msg.sender, address(this), _amount);
325 
326         rewardUpdate();
327 
328         _rewards[_rewardCount].amount = _amount;
329         _rewards[_rewardCount].startTime = block.timestamp;
330         _rewards[_rewardCount].checkTime = block.timestamp;
331         _rewardCount++;
332         emit SentReward(_amount);
333     }
334     
335     function claimRewardAll()
336         external
337     {
338         claimReward(uint256(-1));
339     }
340     
341     function claimReward(uint256 _amount)
342         public
343     {
344         require(_rewardCount > 0, "no reward amount");
345 
346         rewardUpdate();
347 
348         if (_amount > rewardBalances[msg.sender]) {
349             _amount = rewardBalances[msg.sender];
350         }
351 
352         require(_amount > 0, "can't claim reward 0");
353 
354         token1.safeTransfer(msg.sender, _amount);
355         
356         rewardBalances[msg.sender] = rewardBalances[msg.sender].sub(_amount);
357         emit ClaimedReward(msg.sender, _amount);
358     }
359 
360     function withdrawAll()
361         external
362     {
363         withdraw(uint256(-1));
364     }
365 
366     function withdraw(uint256 _amount)
367         public
368     {
369         require(token0.balanceOf(address(this)) > 0, "no withdraw amount");
370         require(withdrawable, "not withdrawable");
371         rewardUpdate();
372 
373         if (_amount > depositBalances[msg.sender]) {
374             _amount = depositBalances[msg.sender];
375         }
376 
377         require(_amount > 0, "can't withdraw 0");
378 
379         token0.safeTransfer(msg.sender, _amount);
380 
381         depositBalances[msg.sender] = depositBalances[msg.sender].sub(_amount);
382         totalDeposit = totalDeposit.sub(_amount);
383 
384         emit Withdrawn(msg.sender, _amount);
385     }
386 
387     function availableRewardAmount(address owner)
388         public
389         view
390         returns(uint256)
391     {
392         uint256 i;
393         uint256 availableReward = rewardBalances[owner];
394         if (_rewardCount > 0 && totalDeposit > 0) {
395             for (i = _rewardCount - 1; _rewards[i].startTime < block.timestamp; --i) {
396                 uint256 duration;
397                 if (block.timestamp.sub(_rewards[i].startTime) > delayDuration) {
398                     duration = _rewards[i].startTime.add(delayDuration).sub(_rewards[i].checkTime);
399                 } else {
400                     duration = block.timestamp.sub(_rewards[i].checkTime);
401                 }
402                 uint256 timedAmount = _rewards[i].amount.mul(duration).div(delayDuration);
403                 uint256 addAmount = timedAmount.mul(depositBalances[owner]).div(totalDeposit);
404                     availableReward = availableReward.add(addAmount);
405                 if (i == 0) {
406                     break;
407                 }
408             }
409         }
410         return availableReward;
411     }
412 }
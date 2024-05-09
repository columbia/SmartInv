1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/access/Ownable.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         _checkOwner();
151         _;
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if the sender is not the owner.
163      */
164     function _checkOwner() internal view virtual {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: maxx.sol
200 
201 
202 
203 pragma solidity >=0.7.0 <0.9.0;
204 
205 
206 
207 contract MAXXStaking is Ownable {
208 
209     IERC20 public maxxToken;
210     IERC20 public PWRDToken;
211    
212 
213     
214     bool public PWRDstakingPaused = true;
215    
216 
217     
218     uint256 public decimalsPWRD = 100000000000000000;
219     uint256 public decimalsMAXX = 100000000000000000;
220    
221 
222    
223     uint256 public PWRDPoolStaked = 0;
224 
225     uint256 public PWRDPoolStakers = 0;
226 
227     uint256 public TotalPWRDPaid = 0;
228 
229     address public maxxWallet;
230  
231     uint256 public PWRDFee = 10; // 10% burned at claim
232 
233 
234     uint256 public PWRDRewardRate15 = 1 wei;//per day
235     uint256 public PWRDRewardRate30 = 1 wei;//per day
236 
237 
238    
239 
240    
241     uint256 public unstakePenaltyPWRD = 15;//across all pools
242    
243 
244   
245 
246     struct StakerPWRD {
247         uint256 stakedMAXXPWRD;
248         uint256 stakedSince;
249         uint256 stakedTill;
250         uint256 PWRDlastClaim;
251         uint256 PWRDClaimed;
252         uint256 PWRDDays;
253         bool isStaked;
254     }
255 
256    
257 
258 
259    
260     mapping(address => StakerPWRD) public stakerVaultPWRD;
261   
262 
263     constructor(address _maxxAddress, address _PWRDAddress, address _maxxWallet) {
264         maxxToken = IERC20(_maxxAddress);
265         PWRDToken = IERC20(_PWRDAddress);
266         
267         maxxWallet = _maxxWallet;
268     }
269 
270 
271  
272 
273 //PWRD STAKE
274     function stakePWRD(uint256 _amount, uint256 _days) public {
275         require(stakerVaultPWRD[msg.sender].isStaked == false, "STAKED_IN_POOL");
276         require(!PWRDstakingPaused, "STAKING_IS_PAUSED");
277         require( _days == 15 || _days == 30, "INVALID_STAKING_DURATION");
278         maxxToken.transferFrom(msg.sender, address(this), _amount);
279         stakerVaultPWRD[msg.sender].stakedMAXXPWRD += _amount;
280         stakerVaultPWRD[msg.sender].stakedSince = block.timestamp;
281        
282         if (_days == 15) {
283             stakerVaultPWRD[msg.sender].stakedTill = block.timestamp + 15 days;
284             stakerVaultPWRD[msg.sender].PWRDDays = 15;
285         }
286         if (_days == 30) {
287             stakerVaultPWRD[msg.sender].stakedTill = block.timestamp + 30 days;
288             stakerVaultPWRD[msg.sender].PWRDDays = 30;
289         }
290         stakerVaultPWRD[msg.sender].PWRDlastClaim = block.timestamp;
291         stakerVaultPWRD[msg.sender].isStaked = true;
292         PWRDPoolStakers += 1;
293         PWRDPoolStaked += _amount;
294     }
295 
296 
297 
298 
299 
300     //UNSTAKE PWRD
301     function unStakePWRD() public {
302 
303         require(stakerVaultPWRD[msg.sender].isStaked == true, "NOT_STAKED");
304 
305         if(stakerVaultPWRD[msg.sender].stakedTill >= block.timestamp) {
306             uint256 stakedTokens = stakerVaultPWRD[msg.sender].stakedMAXXPWRD;
307             uint256 penaltyTokens = (stakedTokens * unstakePenaltyPWRD) / 100;
308             uint256 AfterTaxTotal = stakedTokens - penaltyTokens;
309             maxxToken.transfer(msg.sender, AfterTaxTotal);
310             maxxToken.transfer(maxxWallet, penaltyTokens);
311             PWRDPoolStakers -= 1; 
312             PWRDPoolStaked -= stakerVaultPWRD[msg.sender].stakedMAXXPWRD;
313             stakerVaultPWRD[msg.sender].stakedMAXXPWRD = 0;
314             stakerVaultPWRD[msg.sender].PWRDlastClaim = 0;
315             stakerVaultPWRD[msg.sender].isStaked = false;
316             stakerVaultPWRD[msg.sender].PWRDDays = 0;
317             stakerVaultPWRD[msg.sender].stakedTill = 0;
318             stakerVaultPWRD[msg.sender].stakedSince = 0;
319         }
320 
321          else if(stakerVaultPWRD[msg.sender].stakedTill <= block.timestamp) {
322             PWRDPoolStaked -= stakerVaultPWRD[msg.sender].stakedMAXXPWRD;
323             PWRDPoolStakers -= 1;
324             uint256 stakedTokens = stakerVaultPWRD[msg.sender].stakedMAXXPWRD;
325             maxxToken.transfer(msg.sender, stakedTokens);
326             stakerVaultPWRD[msg.sender].stakedMAXXPWRD = 0;
327             stakerVaultPWRD[msg.sender].PWRDlastClaim = 0;
328             stakerVaultPWRD[msg.sender].isStaked = false;
329             stakerVaultPWRD[msg.sender].PWRDDays = 0;
330             stakerVaultPWRD[msg.sender].stakedTill = 0;
331             stakerVaultPWRD[msg.sender].stakedSince = 0;
332    
333         }
334         
335     }
336 
337 
338 
339     function claimPWRDRewards() public {
340 
341     require(!PWRDstakingPaused, "STAKING_IS_PAUSED");
342     require(stakerVaultPWRD[msg.sender].isStaked == true, "NOT_STAKED");
343 
344 
345     if(stakerVaultPWRD[msg.sender].PWRDDays == 15){
346        
347         uint256 reward = ((block.timestamp - stakerVaultPWRD[msg.sender].PWRDlastClaim) * (PWRDRewardRate15 / 86400) * stakerVaultPWRD[msg.sender].stakedMAXXPWRD) /decimalsPWRD;
348         TotalPWRDPaid += reward;
349         uint256 burnAmount = (reward * PWRDFee) / 100;
350         PWRDToken.transfer(maxxWallet, burnAmount); 
351         reward -= burnAmount;
352         PWRDToken.transfer(msg.sender, reward);
353         stakerVaultPWRD[msg.sender].PWRDlastClaim = block.timestamp;
354         stakerVaultPWRD[msg.sender].PWRDClaimed += reward;
355     }
356 
357     if(stakerVaultPWRD[msg.sender].PWRDDays == 30){
358         uint256 reward = ((block.timestamp - stakerVaultPWRD[msg.sender].PWRDlastClaim) * (PWRDRewardRate30 / 86400) * stakerVaultPWRD[msg.sender].stakedMAXXPWRD) / decimalsPWRD;
359         TotalPWRDPaid += reward;
360         uint256 burnAmount = (reward * PWRDFee) / 100;
361         PWRDToken.transfer(maxxWallet, burnAmount); 
362         reward -= burnAmount;
363         PWRDToken.transfer(msg.sender, reward);
364         stakerVaultPWRD[msg.sender].PWRDlastClaim = block.timestamp;
365         stakerVaultPWRD[msg.sender].PWRDClaimed += reward;
366     }
367        
368     }
369 
370 
371   
372 
373     function disableFees() public onlyOwner {
374        
375         PWRDFee = 0;
376  
377         unstakePenaltyPWRD = 0;
378        
379     }
380 
381 
382     function setFees(uint256 _PWRDFee, uint256 _penaltyPWRD) public onlyOwner{
383        
384         require(_PWRDFee <= 20, "fee to high try again 20% max");
385         require(_penaltyPWRD <= 20, "fee to high try again 20% max");      
386         PWRDFee = _PWRDFee;
387         unstakePenaltyPWRD = _penaltyPWRD;
388        
389     }
390 
391 
392     function WEIsetRewardRatesPerDayPerTokenStaked(uint256 _PWRDRewardRate15, uint256 _PWRDRewardRate30) public onlyOwner{
393        
394         PWRDRewardRate15 = _PWRDRewardRate15;
395         PWRDRewardRate30 = _PWRDRewardRate30;
396 
397        
398     }
399 
400 
401     function setPWRDToken(address _newToken, uint256 _PWRDFee, uint256 _penaltyPWRD) public onlyOwner {
402         require(_PWRDFee <= 20, "fee to high try again 20% max");
403         require(_penaltyPWRD <= 20, "fee to high try again 20% max");
404         PWRDToken = IERC20(_newToken);
405         PWRDPoolStaked = 0;
406         PWRDPoolStakers = 0;
407         TotalPWRDPaid = 0;
408         PWRDFee = _PWRDFee;
409         unstakePenaltyPWRD = _penaltyPWRD;
410 
411 
412     }
413 
414 
415    
416 
417 
418     function setMAXXToken(address _newToken) public onlyOwner {
419         maxxToken = IERC20(_newToken);
420     }
421 
422 
423     function setMAXXWallet(address _newAddress) public onlyOwner {
424         maxxWallet = _newAddress;
425     }
426 
427 
428 
429     function withdrawPOM() public onlyOwner {
430         payable(owner()).transfer(address(this).balance);
431     }
432 
433 
434     function withdrawERC20(address _tokenAddress, uint256 _tokenAmount) public virtual onlyOwner {
435         IERC20(_tokenAddress).transfer(msg.sender, _tokenAmount);
436     }
437 
438 
439    
440 
441     function pausePWRDStaking(bool _state) public onlyOwner {
442         PWRDstakingPaused = _state;
443         unstakePenaltyPWRD = 0;
444     }
445 
446 
447 
448     function calculatePWRDRewards(address staker) public view returns (uint256 _rewards){
449 
450         if (stakerVaultPWRD[staker].PWRDDays == 15) {
451            _rewards = ((block.timestamp - stakerVaultPWRD[staker].PWRDlastClaim) * (PWRDRewardRate15 / 86400) * stakerVaultPWRD[staker].stakedMAXXPWRD) / decimalsPWRD;
452              return _rewards;
453         }
454         if (stakerVaultPWRD[staker].PWRDDays == 30) {
455             
456            _rewards = ((block.timestamp - stakerVaultPWRD[staker].PWRDlastClaim) * (PWRDRewardRate30 / 86400) * stakerVaultPWRD[staker].stakedMAXXPWRD) / decimalsPWRD;
457            return _rewards;
458            
459         }
460 
461         
462       
463     }
464 
465 
466 
467     function estimatePWRDRewards(address user, uint256 _days) public view returns (uint256 _rewards){
468 
469          uint256 tokenAmt;
470          tokenAmt = maxxToken.balanceOf(user);
471 
472         if (_days == 15) {
473           _rewards = ((tokenAmt * PWRDRewardRate15) * 15) / decimalsPWRD; 
474              return _rewards;
475         }
476         if (_days == 30) {
477             
478           _rewards = ((tokenAmt * PWRDRewardRate30) * 30) / decimalsPWRD; 
479            return _rewards;
480            
481         }
482       
483     }
484 
485 
486 
487     function PWRDPoolInfo() public view returns (uint256 Stakers, uint256 TokenAmt){
488 
489          Stakers = PWRDPoolStakers;
490 
491          TokenAmt = PWRDPoolStaked;
492 
493       
494     }
495 
496 
497 
498      receive() external payable {
499     }
500 
501 
502 }
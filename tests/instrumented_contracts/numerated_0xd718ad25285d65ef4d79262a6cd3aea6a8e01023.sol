1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-16
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity ^0.6.0;
7 
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 
40 interface INFT {
41     function balanceOf(address owner) external view returns (uint256 balance);
42     function ownerOf(uint256 tokenId) external view returns (address owner);
43     function walletOfOwner(address _owner) external view returns(uint256[] memory);
44 }
45 
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return mod(a, b, "SafeMath: modulo by zero");
91     }
92 
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b != 0, errorMessage);
95         return a % b;
96     }
97 }
98 
99 
100 library Address {
101     function isContract(address account) internal view returns (bool) {
102         uint256 size;
103         // solhint-disable-next-line no-inline-assembly
104         assembly { size := extcodesize(account) }
105         return size > 0;
106     }
107 
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
112         (bool success, ) = recipient.call{ value: amount }("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
117       return functionCall(target, data, "Address: low-level call failed");
118     }
119 
120     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
121         return _functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
126     }
127 
128     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         return _functionCallWithValue(target, data, value, errorMessage);
131     }
132 
133     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
134         require(isContract(target), "Address: call to non-contract");
135 
136         // solhint-disable-next-line avoid-low-level-calls
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141             // Look for revert reason and bubble it up if present
142             if (returndata.length > 0) {
143                 // The easiest way to bubble the revert reason is using memory via assembly
144 
145                 // solhint-disable-next-line no-inline-assembly
146                 assembly {
147                     let returndata_size := mload(returndata)
148                     revert(add(32, returndata), returndata_size)
149                 }
150             } else {
151                 revert(errorMessage);
152             }
153         }
154     }
155 }
156 
157 
158 contract ERC20 is Context, IERC20 {
159     using SafeMath for uint256;
160     using Address for address;
161     
162     mapping (address => uint256) private _balances;
163     mapping(address => bool) public feeExcludedAddress;
164     mapping (address => mapping (address => uint256)) private _allowances;
165     mapping (uint256 => uint256) lastReward;
166 
167     uint256 private _totalSupply;
168     
169     // Daily Rewards Distributions Start from
170     uint256 private rewardStartDate;
171     bool public dailyReward = true;
172     uint256 public rewardAmount = 10 ether;
173     // ends in a month;
174     
175 
176     string private _name;
177     string private _symbol;
178     uint private _decimals = 18;
179     uint private _lockTime;
180     address public _Owner;
181     address public _previousOwner;
182     address public _fundAddress;
183     address public liquidityPair;
184     uint public teamFee = 300; //0.2% divisor 100
185     uint public burnFee = 300; //0.2% divisor 100
186     bool public sellLimiter; //by default false
187     uint public sellLimit = 50000 * 10 ** 18; //sell limit if sellLimiter is true
188     
189     INFT public NFTContract;
190     
191     uint256 public _maxTxAmount = 5000000 * 10**18;
192     
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194     event claimedDailyReward(uint256 tokenID, address claimer, uint256 timestamp);
195 
196     constructor (string memory _nm, string memory _sym, INFT _NFTContract) public {
197         _name = _nm;
198         _symbol = _sym;
199         _Owner = msg.sender;
200         rewardStartDate = block.timestamp - 1 days;
201         NFTContract = _NFTContract;
202         feeExcludedAddress[msg.sender] = true;
203         _fundAddress = address(0x43a3f032E34467e8f692244461CA1b422f9af230);
204     }
205     
206     modifier onlyOwner{
207         require(msg.sender == _Owner, 'Only Owner Can Call This Function');
208         _;
209     }
210 
211     function name() public view returns (string memory) {
212         return _name;
213     }
214 
215     function symbol() public view returns (string memory) {
216         return _symbol;
217     }
218 
219     function decimals() public view returns (uint) {
220         return _decimals;
221     }
222 
223     function totalSupply() public view override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     function balanceOf(address account) public view override returns (uint256) {
228         return _balances[account];
229     }
230     
231     function calculateTeamBurn(uint256 _amount) internal view returns (uint256) {
232         return _amount.mul(teamFee+burnFee).div(
233             10**4
234         );
235     }
236     
237     function calculateTeamFee(uint256 _amount) internal view returns (uint256) {
238         return _amount.mul(teamFee).div(
239             10**4
240         );
241     }
242     
243     function setTeamFee(uint Tfee) public onlyOwner{
244         require(Tfee < 1500," Fee can't exceed to 15%");
245         teamFee = Tfee;
246     }
247     
248     function setBurnFee(uint Tfee) public onlyOwner{
249         require(Tfee < 1500," Fee can't exceed to 15%");
250         burnFee = Tfee;
251     }
252     
253     function toggleSellLimit() external onlyOwner() {
254         sellLimiter = !sellLimiter;
255     }
256     
257     function stopReward() external onlyOwner() {
258         require(dailyReward, "Daily Reward Already Stopped");
259         dailyReward = false;
260     }
261     
262     function startReward() public onlyOwner{
263         require(!dailyReward, "Daily Reward Already Running");
264         dailyReward = true;
265         rewardStartDate = block.timestamp;
266     }
267     
268     function changeRewardAmount(uint256 _amount) public onlyOwner{
269         rewardAmount = _amount;
270     }
271     
272     function setLiquidityPairAddress(address liquidityPairAddress) public onlyOwner{
273         liquidityPair = liquidityPairAddress;
274     }
275     
276     function changeSellLimit(uint256 _sellLimit) public onlyOwner{
277         sellLimit = _sellLimit;
278     }
279     
280     function changeMaxtx(uint256 _maxtx) public onlyOwner{
281         _maxTxAmount = _maxtx;
282     }
283     
284     function changeFundAddress(address Taddress) public onlyOwner{
285         _fundAddress = Taddress;
286     }
287     
288     function addExcludedAddress(address excludedA) public onlyOwner{
289         feeExcludedAddress[excludedA] = true;
290     }
291     
292     function removeExcludedAddress(address excludedA) public onlyOwner{
293         feeExcludedAddress[excludedA] = false;
294     }
295     
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_Owner, newOwner);
299         _Owner = newOwner;
300     }
301 
302     function geUnlockTime() public view returns (uint256) {
303         return _lockTime;
304     }
305 
306     //Locks the contract for owner for the amount of time provided
307     function lock(uint256 time) public virtual onlyOwner {
308         _previousOwner = _Owner;
309         _Owner = address(0);
310         _lockTime = block.timestamp + time;
311         emit OwnershipTransferred(_Owner, address(0));
312     }
313     
314     //Unlocks the contract for owner when _lockTime is exceeds
315     function unlock() public virtual {
316         require(_previousOwner == msg.sender, "You don't have permission to unlock");
317         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
318         emit OwnershipTransferred(_Owner, _previousOwner);
319         _Owner = _previousOwner;
320     }
321     
322     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
323         require(receivers.length != 0, 'Cannot Proccess Null Transaction');
324         require(receivers.length == amounts.length, 'Address and Amount array length must be same');
325         for (uint256 i = 0; i < receivers.length; i++) {
326             transfer(receivers[i], amounts[i]);
327         }
328     }
329 
330     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
331         if(feeExcludedAddress[recipient] || feeExcludedAddress[_msgSender()]){
332             _transferExcluded(_msgSender(), recipient, amount);
333         }else{
334             _transfer(_msgSender(), recipient, amount);    
335         }
336         return true;
337     }
338 
339     function allowance(address owner, address spender) public view virtual override returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     function approve(address spender, uint256 amount) public virtual override returns (bool) {
344         _approve(_msgSender(), spender, amount);
345         return true;
346     }
347 
348     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
349         if(feeExcludedAddress[recipient] || feeExcludedAddress[sender]){
350             _transferExcluded(sender, recipient, amount);
351         }else{
352             _transfer(sender, recipient, amount);
353         }
354         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
360         return true;
361     }
362 
363     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
365         return true;
366     }
367 
368     function _transferExcluded(address sender, address recipient, uint256 amount) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371         if(sender != _Owner && recipient != _Owner)
372             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
373             
374         if(recipient == liquidityPair && balanceOf(liquidityPair) > 0 && sellLimiter){
375             require(amount < sellLimit, 'Cannot sell more than sellLimit');
376         }
377 
378         // if(holder[recipient] == false){
379         //     holder[recipient] = true;
380         //     holders.push(recipient);
381         // }
382         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
383         _balances[recipient] = _balances[recipient].add(amount);
384         emit Transfer(sender, recipient, amount);
385     }
386     
387     function _transfer( address sender, address recipient, uint256 amount) internal virtual {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390         if(sender != _Owner && recipient != _Owner)
391             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
392 
393         if(recipient == liquidityPair && balanceOf(liquidityPair) > 0 && sellLimiter){
394             require(amount < sellLimit, 'Cannot sell more than sellLimit');
395         }
396         
397         uint256 senderBalance = _balances[sender];
398         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
399         _balances[sender] = senderBalance - amount;
400         uint256 tokenToTransfer = amount.sub(calculateTeamBurn(amount));
401         _balances[recipient] += tokenToTransfer;
402         _balances[_fundAddress] += calculateTeamFee(amount);
403         
404         
405         emit Transfer(sender, recipient, tokenToTransfer);
406         
407        
408      
409     }
410     
411     uint256 public total1;
412     uint256 public a1;
413     address[] public amount123;
414 
415    
416     
417     function _mint(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: mint to the zero address");
419 
420         _beforeTokenTransfer(address(0), account, amount);
421 
422         _totalSupply = _totalSupply.add(amount);
423         _balances[account] = _balances[account].add(amount);
424         emit Transfer(address(0), account, amount);
425     }
426     
427     function addSupply(uint256 amount) public onlyOwner{
428         _mint(msg.sender, amount);
429     }
430     
431     function checkDailyReward(uint256 tokenID) public view returns (uint256){
432         uint256 lastdate = (lastReward[tokenID] > rewardStartDate) ? lastReward[tokenID] : rewardStartDate;
433         uint256 rewardDays = (block.timestamp - lastdate).div(1 days);
434         return rewardDays.mul(rewardAmount);
435     }
436     
437     function claimDailyReward(uint256 tokenID) public {
438         require(dailyReward," Daily Rewards Are Stopped ");
439         require(NFTContract.ownerOf(tokenID) == msg.sender, "You aren't own this NFT token");
440         require(checkDailyReward(tokenID) > 0, "There is no claimable reward");
441         _mint(msg.sender, checkDailyReward(tokenID));
442         lastReward[tokenID] = block.timestamp;
443         emit claimedDailyReward(tokenID, msg.sender, block.timestamp);
444     }
445     
446     function bulkClaimRewards(uint256[] memory tokenIDs) public {
447         require(dailyReward," Daily Rewards Are Stopped ");
448         uint256 total;
449         for (uint256 i = 0; i < tokenIDs.length; i++) {
450             require(NFTContract.ownerOf(tokenIDs[i]) == msg.sender, "You aren't own this NFT token");
451             total += checkDailyReward(tokenIDs[i]);
452             if(checkDailyReward(tokenIDs[i]) > 0){
453                 lastReward[tokenIDs[i]] = block.timestamp;
454             }
455         }
456         require(total > 0, "There is no claimable reward");
457         _mint(msg.sender, total);
458     }
459 
460     function _burn(uint256 amount) public virtual {
461         require(_balances[msg.sender] >= amount,'insufficient balance!');
462 
463         _beforeTokenTransfer(msg.sender, address(0x000000000000000000000000000000000000dEaD), amount);
464 
465         _balances[msg.sender] = _balances[msg.sender].sub(amount, "ERC20: burn amount exceeds balance");
466         _totalSupply = _totalSupply.sub(amount);
467         emit Transfer(msg.sender, address(0x000000000000000000000000000000000000dEaD), amount);
468     }
469 
470     function _approve(address owner, address spender, uint256 amount) internal virtual {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     function _setupDecimals(uint8 decimals_) internal {
479         _decimals = decimals_;
480     }
481 
482     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
483     
484     function NFTBalance(address __address) public view returns(uint256) {
485         return NFTContract.balanceOf(__address);
486     }
487 
488     function NFTOwner(uint256 __id) public view returns(address ) {
489         return NFTContract.ownerOf(__id);
490     }
491 
492     function NFTWallet(address __address) public view returns(uint256[] memory) {
493         return NFTContract.walletOfOwner(__address);
494     }
495     
496     struct challenge{
497         uint256 id;
498         string des;
499         uint256 roots;
500         uint256 nfts;
501         bool status;
502     }   
503     
504     uint256 public challengeCount = 0;
505     mapping (uint => challenge) public Challenges;
506     mapping(uint => mapping(address => bool)) public entry;
507     
508     function startChallnge(string  memory _des, uint256 _roots, uint256 _nfts) public onlyOwner{
509         Challenges[challengeCount+1] = challenge(challengeCount+1, _des, _roots, _nfts, true);
510         challengeCount++;
511     }
512     
513     function enterChallenge(uint256 _id) public {
514         require(_id == Challenges[_id].id && _id != 0, "Invalid ID");
515         require(Challenges[_id].status == true, "Challenge ended");
516         require(entry[_id][msg.sender] != true, "You are already inrolled in this challenge");
517         require(Challenges[_id].nfts <= NFTContract.balanceOf(msg.sender), "You own less amount of BearX than reequired");
518         require(Challenges[_id].roots <= balanceOf(msg.sender), "You own less amount of ROOT than required");
519         _burn(Challenges[_id].roots);
520         entry[_id][msg.sender] = true;
521     }
522     
523     function toggleChallengeStatus(uint256 _id) public onlyOwner {
524         require(_id == Challenges[_id].id && _id != 0, "Invalid ID");
525         Challenges[_id].status = !Challenges[_id].status;
526     }    
527     
528     
529     function u_contract(address _contarct) public onlyOwner {
530         require(_contarct != address(0), "Invalid address");
531         NFTContract = INFT(_contarct);
532     }    
533     
534     
535 }
536 
537 
538 contract ROOTx is ERC20 {
539     constructor(INFT NFTContract) public ERC20("ROOTx", "ROOTx", NFTContract) {
540         _mint(msg.sender, 6500 ether); // 
541         // holder[msg.sender] = true;
542         // holders.push(msg.sender);
543     }
544 }
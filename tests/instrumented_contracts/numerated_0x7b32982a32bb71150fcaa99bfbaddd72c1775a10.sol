1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library Address {
35     function isContract(address account) internal view returns (bool) {
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { size := extcodesize(account) }
39         return size > 0;
40     }
41 
42     function sendValue(address payable recipient, uint256 amount) internal {
43         require(address(this).balance >= amount, "Address: insufficient balance");
44 
45         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
46         (bool success, ) = recipient.call{ value: amount }("");
47         require(success, "Address: unable to send value, recipient may have reverted");
48     }
49 
50     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
51       return functionCall(target, data, "Address: low-level call failed");
52     }
53 
54     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
55         return _functionCallWithValue(target, data, 0, errorMessage);
56     }
57 
58     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
59         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
60     }
61 
62     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
63         require(address(this).balance >= value, "Address: insufficient balance for call");
64         return _functionCallWithValue(target, data, value, errorMessage);
65     }
66 
67     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
68         require(isContract(target), "Address: call to non-contract");
69 
70         // solhint-disable-next-line avoid-low-level-calls
71         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
72         if (success) {
73             return returndata;
74         } else {
75             // Look for revert reason and bubble it up if present
76             if (returndata.length > 0) {
77                 // The easiest way to bubble the revert reason is using memory via assembly
78 
79                 // solhint-disable-next-line no-inline-assembly
80                 assembly {
81                     let returndata_size := mload(returndata)
82                     revert(add(32, returndata), returndata_size)
83                 }
84             } else {
85                 revert(errorMessage);
86             }
87         }
88     }
89 }
90 
91 interface IERC20Metadata is IERC20 {
92 
93     function name() external view returns (string memory);
94 
95     function symbol() external view returns (string memory);
96 
97     function decimals() external view returns (uint8);
98 }
99 
100 abstract contract Ownable is Context {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     constructor() {
106         _transferOwnership(_msgSender());
107     }
108 
109     function owner() public view virtual returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(owner() == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 contract ERC20 is Context, IERC20, IERC20Metadata {
135     mapping(address => uint256) private _balances;
136 
137     mapping(address => mapping(address => uint256)) private _allowances;
138 
139     uint256 private _totalSupply;
140 
141     string private _name;
142     string private _symbol;
143 
144     constructor(string memory name_, string memory symbol_) {
145         _name = name_;
146         _symbol = symbol_;
147     }
148 
149     function name() public view virtual override returns (string memory) {
150         return _name;
151     }
152 
153     function symbol() public view virtual override returns (string memory) {
154         return _symbol;
155     }
156 
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     function balanceOf(address account) public view virtual override returns (uint256) {
166         return _balances[account];
167     }
168 
169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185 
186         uint256 currentAllowance = _allowances[sender][_msgSender()];
187         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
188         unchecked {
189             _approve(sender, _msgSender(), currentAllowance - amount);
190         }
191 
192         return true;
193     }
194 
195     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
196         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
197         return true;
198     }
199 
200     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
201         uint256 currentAllowance = _allowances[_msgSender()][spender];
202         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
203         unchecked {
204             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
205         }
206 
207         return true;
208     }
209 
210     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         _beforeTokenTransfer(sender, recipient, amount);
215 
216         uint256 senderBalance = _balances[sender];
217         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
218         unchecked {
219             _balances[sender] = senderBalance - amount;
220         }
221         _balances[recipient] += amount;
222 
223         emit Transfer(sender, recipient, amount);
224 
225         _afterTokenTransfer(sender, recipient, amount);
226     }
227 
228     function _mint(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230 
231         _beforeTokenTransfer(address(0), account, amount);
232 
233         _totalSupply += amount;
234         _balances[account] += amount;
235         emit Transfer(address(0), account, amount);
236 
237         _afterTokenTransfer(address(0), account, amount);
238     }
239 
240     function _burn(address account, uint256 amount) internal virtual {
241         require(account != address(0), "ERC20: burn from the zero address");
242 
243         _beforeTokenTransfer(account, address(0), amount);
244 
245         uint256 accountBalance = _balances[account];
246         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
247         unchecked {
248             _balances[account] = accountBalance - amount;
249         }
250         _totalSupply -= amount;
251 
252         emit Transfer(account, address(0), amount);
253 
254         _afterTokenTransfer(account, address(0), amount);
255     }
256 
257     function _approve(address owner, address spender, uint256 amount) internal virtual {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260 
261         _allowances[owner][spender] = amount;
262         emit Approval(owner, spender, amount);
263     }
264 
265     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
266 
267     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
268 }
269 
270 interface IULTRA {
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272     function tokensOfOwner(address owner) external view returns(uint256[] memory);
273 }
274 
275 interface IALPHA {
276     function ownerOf(uint256 tokenId) external view returns (address owner);
277     function tokensOfOwner(address owner) external view returns(uint256[] memory);
278 }
279 
280 interface IBETA {
281     function ownerOf(uint256 tokenId) external view returns (address owner);
282     function tokensOfOwner(address owner) external view returns(uint256[] memory);
283 }
284 
285 interface IGAMMA {
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287     function tokensOfOwner(address owner) external view returns(uint256[] memory);
288 }
289 
290 interface IDELTA {
291     function ownerOf(uint256 tokenId) external view returns (address owner);
292     function tokensOfOwner(address owner) external view returns(uint256[] memory);
293 }
294 
295 /**
296 ::::::ccclccccclloooollooodxxxxxxxxdddxxkkkkkkkkO00000000OOkkkkkkxxdddxxxxxxxdoolllooolccccccc::::::
297 ccccllcccccllloooollooddxxxxxxxddxxxkkkkkkkOO000000000000000OOOkkkkkkxxxxxxxxxxxddoollloollccccccc::
298 llcccclllooooollooddxxxxxxxxxxxxkkkkkkkOO000OOO0KKK0000KK000OOOOOOkkkkkOkkkxxxxxxxxxddoolllolllccccc
299 cclllooooollloodxxxxxxxxxxxkkOkkkOOO00000OkkOkOOK00kxkkkkxxkkkkkkOO0OOkkkkOOkkkxxxxxxxxxddoooloollcc
300 looooolllooddxxxxxxxxxkkkOOkOOO000000OkkOkkO0Oxoc,.. .';coddddxxdxkkkkOOOOkkkkOOkkxxxdxxxxxxddoollll
301 oooolooddxxxxxxxxxkkkkOOOOO000000OOOOOkk0Oxoc,.          .';coddddxxxxkkkkkOOOkkkkOOkkxxxddxxxxxdool
302 oooloxxxxxxxxxkkkkOOOO0000O000O00OkkOOxoc,.                  .';coxxdxxxxxkkkxkkOOkkkOOOkkxxddxxxxxx
303 oolldxxdxxkkkkkOOO000OO000O000OOOOxo:,.                          .';coxxdxkkkxkkxxkkkOkkkOOOkxddxxxx
304 oolldxxdxOkkkOO00OO00OOO0OOkOOxo:,.                                  .';coxxdk0K0OkxkOOOOkkkkOxdxxxx
305 oolldxddkOxk00O00OOOOOxxkkxl:,.                                          .';:oxkO0K0000OO00xxOxdxxxx
306 oolldxddkOkkO0OOOkxxkkdl:,.                                                  ..,ckKKK0KKOO0kxOxdxxxx
307 oocldxddkOxxkkxxxkdc:,.                                                          lkkK0KKOO0kxOxdxxxx
308 oollxxdxkkxxddxxkc.                                                              :dd00KKOO0kxOxdxxxx
309 ooloxxdxOkxxdddxk,                                                               :ddOOKKOO0kxOxdxxxx
310 ooloxxxxOkxxxxxxk,                                                               :ddOO00OO0kxOxdxxxx
311 ooldxxxxOkxkOOxxk,            ..'''.                           .',;;,.           :ddOkk0OO0kkOxdxxxx
312 ooldxxxxOkxkO0xxk,           'kOdodkxc.     'c.              cOOkkkko.           :ddOkk0OO0kkOkxxxxx
313 ooodxxdxOxkk00dxk,           :Kl   .c0d.    cXo       ::    .dWx.                :ddOkk0OO0kkOkxxxxx
314 olodxxdxOxkO00dxk,           :Kc    .dO.    lW0,     .OO'    lNx.                :doOkk0OO0kkOkdxxxx
315 olodxxdxOxkO00kkk,           ;Kk::::o0o     oWWd.    :XNl    :Xk.                :doOkk0OO0kkOkdxxxx
316 olldxxdxOxkO0K0KO,           ;KOcccldkkc.  .dX0O;   .xKKO'   ,KO.                :dokkk0OO0kkOxdxxxx
317 olldxxdxOkkOOK00k,           ;0l      ;Ok. .k0:xx.  ;0lc0l   .O0'                :dokkk0OO0kkOxdxxxx
318 ollxxxdxOkkOOK0Od,           ,0l       ,Oc .Ok.,k: .dO'.xO.  .xK,                :dokkx0OO0kxOxdxxxx
319 oclxxxdkOkkkOK0kd,           ,0o       .kl '0x. lxclOo  :Kl   dX:                :dokkxOOO0xxOxddxxx
320 ocoxxxdkkkOk000kd,           ,0o       :O; ,0d  .xXX0,  .kO.  lXc                :dokxxOOO0xkOxodxxx
321 oloxxddkkkOO00Okd,           '0x.  ..,lkc  ;0l   :OXx.   cKc  ;Kd.               :dokkOKOO0kkOxodxxx
322 oloxxddkkkOO0kkkd,           .lxlclool:.   ;O:   .'c;    'Ok. .d0kxdxxo.         :dokO0KOO0xkOxodxxx
323 lldxxdokkkOO0kxkd,                         ...            ,:.   ';cloo:.         :dokk0XOOOxxOkddxxx
324 lldxxddkkkO0Kxxkd,                                                               :dokO0X00OxxOkddxxx
325 lldxxddkxkO0Kxxxd,                                                               :dokO0X0OOxkOkddxxx
326 lldxxddkxkOO0kxxo,                                                               :od000XOOOxkOkddxxx
327 lldxxdxkxkOO0kxdo,                                                               :od0O0X0OOxkOkddxxx
328 loxxxdxkxkOOKkxdo,                                                              .lod00KXOOOxkOkddxxx
329 loxxxdxkxkO0Kkxdo,                                                          .':cdkxkK0KKOOOxkOkddxxx
330 loxxxdxkxOO0K00xol,..                                                   .':ldkkxxkO00000O0OxkOkddxxx
331 loxxxdxkkOOO000Oxxxdl:,.                                            .,:ldkkxxkOOO00000000OkkOOkddxxx
332 loxxxxkkkO00O0000Okkxxxxdoloc'.                                 .':ldkkxxkOOO000000000OOkkOOOkxddxxx
333 loxxxdxOkkkkO0000000OOkkk000Okdc;'.                         .,:ldkkxxxkOO00000000OOOOOOOOkkxxddxxxxd
334 llodxddxxkOkkkkkO00000000Okkkkxxxxoc;'.                 .,:ldkkxxkkkO00000000OkkkkOOOkkxxxdxxxxxdool
335 oollodxxxxxxkOkkxkkO0000000KKK0Okkddddoc:,.         .,:ldkkxdkOOO00000000OkkkkkOOkkxxddxxxxxddoolloo
336 lloooloodxxxxxxkkkkxkkO000000000000Okxddxxol:,..,:cldkkxdxkOO00000000OkkkkkOOkkxxddxxxxxdddoollooooo
337 ccllloooooddxxxxxxkkOkkkkO0000000000000OOOOO0KOOOOkxdxkkO0000O000OkkkkkOOkkxxxdxxxxxxddoooloooooollc
338 lccccllooolooddxxxxxxxkOkkkkkkkkOO00O000KKKKKKK00OOOO000000000OkkkkOOOkxxddxxxxxxddoooloooooollccccc
339 ccclccccloooolloodxxxxdxxkOOOOOOkkkkO00OO0000KKKKKK0000000OkkkkkOOkxxxddxxxxxddoolloooooollcccccccll
340 :::clllccclloooolloodxxxxxxxkkkkkOOkkkkOO00O0000000000OOkkkkOOkxxxxxxxxxxxdoollloooooollccccclclllll
341 :::::ccllccccllooollloddxxxxxxxxxxkkOOkkkkOO00000OOOkkkkOOkxxxddxxxxxxdooolloooooollccccccllcllllcc:
342 ;:::;::cccllcccllooooolloddxxxxxxxxxxxkkOOkkkOOOkkkkOOkxxxddxxxxxxddoolllooooolllcccclllcclllccc::::
343 ',;;::::::ccllcccclloooooloooddxxxxxxxxxxkkOOOOOOkkkxxddxxxxxxxdoolllooooolllccccclccllllccc::::::::
344 ''',;;::::::cclccccccllllooollloodxxxxxxxxxxxkxxxdddxxxxxxxdoollloooooollcccccllcllcclcc::::::::::;;
345 ''''',;:::::::cccllcccccccooooolllodxxxxxxxxxdddxxxxxxxxxdolllooooooolccccccclllllllcc:;::::::::;,,'
346 
347     Hashpower is the utility token of the BMC ecosystem. The contract is structured to passively emit 10 HASH daily to each Ultra Miner. 
348     Support for four additional NFT collections to generate HASH has been included (As Alpha, Beta, Gamma, Delta) incase in the future, new collections in the ecosystem will generate HASH.
349 
350 */
351 
352 contract HASHPOWER is ERC20, Ownable {
353     using Address for address;
354 
355     //Epoch Unix start time for HASH rewards
356     uint256 public uRewardStartDate;
357     uint256 public aRewardStartDate;
358     uint256 public bRewardStartDate;
359     uint256 public cRewardStartDate;
360     uint256 public dRewardStartDate;
361 
362     //Whether HASH rewards are active
363     bool public uDailyReward = true;
364     bool public aDailyReward;
365     bool public bDailyReward;
366     bool public cDailyReward;
367     bool public dDailyReward;
368 
369     //Last Claim time for a particular tokenid
370     mapping (uint256 => uint256) uLastReward;
371     mapping (uint256 => uint256) aLastReward;
372     mapping (uint256 => uint256) bLastReward;
373     mapping (uint256 => uint256) cLastReward;
374     mapping (uint256 => uint256) dLastReward;
375 
376     //Daily HASH reward
377     uint256 public uRewardAmount = 10 ether;
378     uint256 public aRewardAmount;
379     uint256 public bRewardAmount;
380     uint256 public cRewardAmount;
381     uint256 public dRewardAmount;
382 
383     //NFT Addresses to generate HASH
384     IULTRA public uContract;
385     IALPHA public aContract;
386     IBETA public bContract;
387     IGAMMA public cContract;
388     IDELTA public dContract;
389 
390     constructor(IULTRA _uContract) ERC20("HASHPOWER", "HASH") {
391         uRewardStartDate = block.timestamp - 1 days;
392         uContract = _uContract;
393     }
394 
395     //A maximum of five collections can potentially generate HASH in the future.
396     modifier validCollection(uint256 _collection) {
397         require(_collection > 0 && _collection < 6, "Invalid input");
398         _;
399     }
400 
401     modifier nonContract() {
402         require(tx.origin == msg.sender, "No Smart Contracts");
403         _;
404     }
405 
406     function checkUltraDailyReward(uint256 tokenID) public view returns (uint256){
407         uint256 lastdate = (uLastReward[tokenID] > uRewardStartDate) ? uLastReward[tokenID] : uRewardStartDate;
408         uint256 rewardDays = (block.timestamp - lastdate)/(1 days);
409         return (rewardDays*uRewardAmount);
410     }
411 
412     function checkAlphaDailyReward(uint256 tokenID) public view returns (uint256){
413         uint256 lastdate = (aLastReward[tokenID] > aRewardStartDate) ? aLastReward[tokenID] : aRewardStartDate;
414         uint256 rewardDays = (block.timestamp - lastdate)/(1 days);
415         return (rewardDays*aRewardAmount);
416     }
417 
418     function checkBetaDailyReward(uint256 tokenID) public view returns (uint256){
419         uint256 lastdate = (bLastReward[tokenID] > bRewardStartDate) ? bLastReward[tokenID] : bRewardStartDate;
420         uint256 rewardDays = (block.timestamp - lastdate)/(1 days);
421         return (rewardDays*bRewardAmount);
422     }
423 
424     function checkGammaDailyReward(uint256 tokenID) public view returns (uint256){
425         uint256 lastdate = (cLastReward[tokenID] > cRewardStartDate) ? cLastReward[tokenID] : cRewardStartDate;
426         uint256 rewardDays = (block.timestamp - lastdate)/(1 days);
427         return (rewardDays*cRewardAmount);
428     }
429 
430     function checkDeltaDailyReward(uint256 tokenID) public view returns (uint256){
431         uint256 lastdate = (dLastReward[tokenID] > dRewardStartDate) ? dLastReward[tokenID] : dRewardStartDate;
432         uint256 rewardDays = (block.timestamp - lastdate)/(1 days);
433         return (rewardDays*dRewardAmount);
434     }
435 
436     function claimUltraRewards(uint256[] memory tokenIDs) public {
437         require(uDailyReward,"Not Active");
438         address caller = _msgSender();
439         require (caller == tx.origin, "No Smart Contracts");
440         uint256 total;
441         uint256 reward;
442         uint256 l = tokenIDs.length;
443         uint256 timestamp = block.timestamp;
444 
445         for (uint256 i = 0; i < l; i++) {
446             uint256 id = tokenIDs[i];
447             require(uContract.ownerOf(id) == caller, "Not Owner");
448             reward = checkUltraDailyReward(id);
449             if(reward > 0){
450                 uLastReward[id] = timestamp;
451                 total += reward;
452             }
453         }
454         require(total > 0, "None to claim");
455         _mint(caller, total);
456     }
457 
458     function claimAlphaRewards(uint256[] memory tokenIDs) public {
459         require(aDailyReward,"Not Active");
460         address caller = _msgSender();
461         require (caller == tx.origin, "No Smart Contracts");
462         uint256 total;
463         uint256 reward;
464         uint256 l = tokenIDs.length;
465         uint256 timestamp = block.timestamp;
466 
467         for (uint256 i = 0; i < l; i++) {
468             uint256 id = tokenIDs[i];
469             require(aContract.ownerOf(id) == caller, "Not Owner");
470             reward = checkAlphaDailyReward(id);
471             if(reward > 0){
472                 aLastReward[id] = timestamp;
473                 total += reward;
474             }
475         }
476         require(total > 0, "None to claim");
477         _mint(caller, total);
478     }
479 
480     function claimBetaRewards(uint256[] memory tokenIDs) public {
481         require(bDailyReward,"Not Active");
482         address caller = _msgSender();
483         require (caller == tx.origin, "No Smart Contracts");
484         uint256 total;
485         uint256 reward;
486         uint256 l = tokenIDs.length;
487         uint256 timestamp = block.timestamp;
488 
489         for (uint256 i = 0; i < l; i++) {
490             uint256 id = tokenIDs[i];
491             require(bContract.ownerOf(id) == caller, "Not Owner");
492             reward = checkBetaDailyReward(id);
493             if(reward > 0){
494                 bLastReward[id] = timestamp;
495                 total += reward;
496             }
497         }
498         require(total > 0, "None to claim");
499         _mint(caller, total);
500     }
501 
502     function claimGammaRewards(uint256[] memory tokenIDs) public {
503         require(cDailyReward,"Not Active");
504         address caller = _msgSender();
505         require (caller == tx.origin, "No Smart Contracts");
506         uint256 total;
507         uint256 reward;
508         uint256 l = tokenIDs.length;
509         uint256 timestamp = block.timestamp;
510 
511         for (uint256 i = 0; i < l; i++) {
512             uint256 id = tokenIDs[i];
513             require(cContract.ownerOf(id) == caller, "Not Owner");
514             reward = checkGammaDailyReward(id);
515             if(reward > 0){
516                 cLastReward[id] = timestamp;
517                 total += reward;
518             }
519         }
520         require(total > 0, "None to claim");
521         _mint(caller, total);
522     }
523 
524     function claimDeltaRewards(uint256[] memory tokenIDs) public {
525         require(dDailyReward,"Not Active");
526         address caller = _msgSender();
527         require (caller == tx.origin, "No Smart Contracts");
528         uint256 total;
529         uint256 reward;
530         uint256 l = tokenIDs.length;
531         uint256 timestamp = block.timestamp;
532 
533         for (uint256 i = 0; i < l; i++) {
534             uint256 id = tokenIDs[i];
535             require(dContract.ownerOf(id) == caller, "Not Owner");
536             reward = checkDeltaDailyReward(id);
537             if(reward > 0){
538                 dLastReward[id] = timestamp;
539                 total += reward;
540             }
541         }
542         require(total > 0, "None to claim");
543         _mint(caller, total);
544     }
545 
546     function checkWalletRewards(address _address) public view returns (uint256){
547         uint256 total;
548         uint256 l;
549 
550         if (uDailyReward){
551             uint256[] memory utokenIDs = uContract.tokensOfOwner(_address);
552             l = utokenIDs.length;
553             for (uint256 i = 0; i < l; i++) {
554                 total += checkUltraDailyReward(utokenIDs[i]);
555             }
556         }
557 
558         if (aDailyReward){
559             uint256[] memory atokenIDs = aContract.tokensOfOwner(_address);
560             l = atokenIDs.length;
561             for (uint256 i = 0; i < l; i++) {
562                 total += checkAlphaDailyReward(atokenIDs[i]);
563             }
564         }
565 
566         if (bDailyReward){
567             uint256[] memory btokenIDs = bContract.tokensOfOwner(_address);
568             l = btokenIDs.length;
569             for (uint256 i = 0; i < l; i++) {
570                 total += checkBetaDailyReward(btokenIDs[i]);
571             }
572         }
573 
574         if (cDailyReward){
575             uint256[] memory ctokenIDs = cContract.tokensOfOwner(_address);
576             l = ctokenIDs.length;
577             for (uint256 i = 0; i < l; i++) {
578                 total += checkGammaDailyReward(ctokenIDs[i]);
579             }
580         }
581         
582         if (dDailyReward){
583             uint256[] memory dtokenIDs = dContract.tokensOfOwner(_address);
584             l = dtokenIDs.length;
585             for (uint256 i = 0; i < l; i++) {
586                 total += checkDeltaDailyReward(dtokenIDs[i]);
587             }
588         }
589 
590         return total;
591     }
592 
593     function claimAllRewards(uint256[] memory utokenIDs, uint256[] memory atokenIDs, uint256[] memory btokenIDs, uint256[] memory ctokenIDs, uint256[] memory dtokenIDs) public {
594         address caller = _msgSender();
595         require (caller == tx.origin, "No Smart Contracts");
596         uint256 total;
597         uint256 reward;
598         uint256 l;
599         uint256 id;
600         uint256 timestamp = block.timestamp;
601 
602         if (uDailyReward && utokenIDs.length > 0){
603             l = utokenIDs.length;
604             for (uint256 i = 0; i < l; i++) {
605                 id = utokenIDs[i];
606                 require(uContract.ownerOf(id) == caller, "Not Owner");
607                 reward = checkUltraDailyReward(id);
608                 if(reward > 0){
609                     uLastReward[id] = timestamp;
610                     total += reward;
611                 }
612             }
613         }
614 
615         if (aDailyReward && atokenIDs.length > 0){
616             l = atokenIDs.length;
617             for (uint256 i = 0; i < l; i++) {
618                 id = atokenIDs[i];
619                 require(aContract.ownerOf(id) == caller, "Not Owner");
620                 reward = checkAlphaDailyReward(id);
621                 if(reward > 0){
622                     aLastReward[id] = timestamp;
623                     total += reward;
624                 }
625             }
626         }
627 
628         if (bDailyReward && btokenIDs.length > 0){
629             l = btokenIDs.length;
630             for (uint256 i = 0; i < l; i++) {
631                 id = btokenIDs[i];
632                 require(bContract.ownerOf(id) == caller, "Not Owner");
633                 reward = checkBetaDailyReward(id);
634                 if(reward > 0){
635                     bLastReward[id] = timestamp;
636                     total += reward;
637                 }
638             }
639         }
640 
641         if (cDailyReward && ctokenIDs.length > 0){
642             l = ctokenIDs.length;
643             for (uint256 i = 0; i < l; i++) {
644                 id = ctokenIDs[i];
645                 require(cContract.ownerOf(id) == caller, "Not Owner");
646                 reward = checkGammaDailyReward(id);
647                 if(reward > 0){
648                     cLastReward[id] = timestamp;
649                     total += reward;
650                 }
651             }
652         }
653 
654         if (dDailyReward && dtokenIDs.length > 0){
655             l = dtokenIDs.length;
656             for (uint256 i = 0; i < l; i++) {
657                 id = dtokenIDs[i];
658                 require(dContract.ownerOf(id) == caller, "Not Owner");
659                 reward = checkDeltaDailyReward(id);
660                 if(reward > 0){
661                     dLastReward[id] = timestamp;
662                     total += reward;
663                 }
664             }
665         }
666 
667         require(total > 0, "None to claim");
668         _mint(caller, total);
669 
670     }
671 
672      function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
673         uint256 r = receivers.length;
674         require(r != 0, "Zero length passed");
675         require(r == amounts.length, "Different Lengths");
676         for (uint256 i = 0; i < r; i++) {
677             transfer(receivers[i], amounts[i]);
678         }
679     } 
680 
681     //This is only here if needed at a future date like the additional HASH generating contracts
682     function mintHash(uint256 _amount) public onlyOwner nonContract {
683         _mint(msg.sender, _amount);
684     }
685 
686     function burnHash(uint256 _amount) public {
687         _burn(msg.sender, _amount);
688     }
689 
690     function rewardStatus(uint256 _collection, bool _status) public validCollection (_collection) onlyOwner {
691         bool success;
692 
693         if (_collection == 1 && uRewardStartDate != 0){ 
694             uDailyReward = _status;
695             success = true;
696             }
697         if (_collection == 2 && aRewardStartDate != 0){ 
698             aDailyReward = _status;
699             success = true;
700             }
701         if (_collection == 3 && bRewardStartDate != 0){ 
702             bDailyReward = _status;
703             success = true;
704             }
705         if (_collection == 4 && cRewardStartDate != 0){ 
706             cDailyReward = _status;
707             success = true;
708             }
709         if (_collection == 5 && dRewardStartDate != 0){ 
710             dDailyReward = _status;
711             success = true;
712             }
713   
714         require(success, "Epoch Date not initialized");
715     }
716 
717     function setRewardsTime(uint256 _collection) public validCollection (_collection) onlyOwner {
718         bool success;
719 
720         if (_collection == 1 && uContract != IULTRA(address(0))){ 
721             uRewardStartDate = block.timestamp;
722             success = true;
723             }
724         if (_collection == 2 && aContract != IALPHA(address(0))){ 
725             aRewardStartDate = block.timestamp;
726             success = true;
727             }
728         if (_collection == 3 && bContract != IBETA(address(0))){ 
729             bRewardStartDate = block.timestamp;
730             success = true;
731             }
732         if (_collection == 4 && cContract != IGAMMA(address(0))){ 
733             cRewardStartDate = block.timestamp;
734             success = true;
735             }
736         if (_collection == 5 && dContract != IDELTA(address(0))){ 
737             dRewardStartDate = block.timestamp;
738             success = true;
739             }
740 
741         require(success, "Contract Address not initialized");
742     }
743 
744     function setRewardsAmount(uint256 _collection, uint256 _amount) public validCollection (_collection) onlyOwner {
745         
746         if (_collection == 1){ 
747             uRewardAmount = _amount;
748             }
749         if (_collection == 2){ 
750             aRewardAmount = _amount;
751             }
752         if (_collection == 3){ 
753             bRewardAmount = _amount;
754             }
755         if (_collection == 4){ 
756             cRewardAmount = _amount;
757             }
758         if (_collection == 5){ 
759             dRewardAmount = _amount;
760             }
761         
762     }
763 
764     function setContractAddress(uint256 _collection, address _contract) public validCollection (_collection) onlyOwner {
765         require(_contract != address(0), "Cannot assign Null Address");
766 
767         if (_collection == 1){ 
768             uContract = IULTRA(_contract); 
769             }
770         if (_collection == 2){ 
771             aContract = IALPHA(_contract); 
772             }
773         if (_collection == 3){ 
774             bContract = IBETA(_contract); 
775             }
776         if (_collection == 4){ 
777             cContract = IGAMMA(_contract); 
778             }
779         if (_collection == 5){ 
780             dContract = IDELTA(_contract); 
781             }
782 
783     }
784 
785 }
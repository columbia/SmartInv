1 /*
2                  
3 市場
4                                                   
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.16;
10 
11 // SECTION Interfaces
12 
13 interface IUniswapFactory {
14     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
15 
16     function feeTo() external view returns (address);
17     function feeToSetter() external view returns (address);
18     function getPair(address tokenA, address tokenB) external view returns (address pair);
19     function allPairs(uint) external view returns (address pair);
20     function allPairsLength() external view returns (uint);
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22     function setFeeTo(address) external;
23     function setFeeToSetter(address) external;
24 }
25 
26 interface IUniswapRouter01 {
27     function addLiquidity(
28         address tokenA,
29         address tokenB,
30         uint amountADesired,
31         uint amountBDesired,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB, uint liquidity);
37     function addLiquidityETH(
38         address token,
39         uint amountTokenDesired,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
45     function removeLiquidity(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETH(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external returns (uint amountToken, uint amountETH);
62     function removeLiquidityWithPermit(
63         address tokenA,
64         address tokenB,
65         uint liquidity,
66         uint amountAMin,
67         uint amountBMin,
68         address to,
69         uint deadline,
70         bool approveMax, uint8 v, bytes32 r, bytes32 s
71     ) external returns (uint amountA, uint amountB);
72     function removeLiquidityETHWithPermit(
73         address token,
74         uint liquidity,
75         uint amountTokenMin,
76         uint amountETHMin,
77         address to,
78         uint deadline,
79         bool approveMax, uint8 v, bytes32 r, bytes32 s
80     ) external returns (uint amountToken, uint amountETH);
81     function swapExactTokensForTokens(
82         uint amountIn,
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external returns (uint[] memory amounts);
88     function swapTokensForExactTokens(
89         uint amountOut,
90         uint amountInMax,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external returns (uint[] memory amounts);
95     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
96     external
97     payable
98     returns (uint[] memory amounts);
99     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
100     external
101     returns (uint[] memory amounts);
102     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
103     external
104     returns (uint[] memory amounts);
105     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
106     external
107     payable
108     returns (uint[] memory amounts);
109 
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
113     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
114     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
115     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
116     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
117 }
118 
119 interface IUniswapRouter02 is IUniswapRouter01 {
120     function removeLiquidityETHSupportingFeeOnTransferTokens(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external returns (uint amountETH);
128     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
129         address token,
130         uint liquidity,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline,
135         bool approveMax, uint8 v, bytes32 r, bytes32 s
136     ) external returns (uint amountETH);
137     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144     function swapExactETHForTokensSupportingFeeOnTransferTokens(
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external payable;
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 }
158 
159 
160 interface IERC20 {
161     function totalSupply() external view returns (uint);
162     function decimals() external view returns (uint8);
163     function symbol() external view returns (string memory);
164     function name() external view returns (string memory);
165     function getowner() external view returns (address);
166     function balanceOf(address account) external view returns (uint);
167     function transfer(address recipient, uint amount) external returns (bool);
168     function allowance(address _owner, address spender) external view returns (uint);
169     function approve(address spender, uint amount) external returns (bool);
170     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
171     event Transfer(address indexed from, address indexed to, uint value);
172     event Approval(address indexed owner, address indexed spender, uint value);
173 }
174 
175 // !SECTION Interfaces
176 
177 // SECTION Libraries
178 
179 library bitwise_boolean {
180 
181     // Primitives
182 
183     function check_state(uint256 boolean_array, uint256 bool_index) 
184                          internal pure returns(bool bool_result) {
185         //return (boolean_array & (1 << bool_index)) != 0;
186         uint256 flag = (boolean_array >> bool_index) & uint256(1);
187         return (flag == 1 ? true : false);
188     }
189 
190     function set_true(uint256 boolean_array, uint256 bool_index) 
191                      internal pure returns(uint256 resulting_array){
192         return (boolean_array | uint256(1) << bool_index);
193         //return boolean_array | (((boolean_array & bool_index) > 0) ? 1 : 0);
194     }
195 
196     function set_false(uint256 boolean_array, uint256 bool_index) 
197                       internal pure returns(uint256 resulting_array){
198         return (boolean_array & ~(uint256(1) << bool_index));
199         //return boolean_array & (((boolean_array & bool_index) > 0) ? 1 : 0);
200     }
201 
202     function get_element(uint256 bit_array, uint256 index) public pure returns(uint8 value) {
203         return ((bit_array & index) > 0) ? 1 : 0;
204     }
205 }
206 
207 // !SECTION Libraries
208 
209 // SECTION Contracts
210 
211 // SECTION Safety and efficiency contract
212 contract modern {
213 
214     using bitwise_boolean for uint256;
215 
216     // SECTION Bitwise Definition
217     // Bit 0 is control
218     // Bit 1 is auth
219     // Bit 2 is owner
220     // Bit 3 is blacklisted
221     // Bit 4 is frozen
222     // Bit 5 is whitelisted
223     // Bit 6 is not cooled down
224     // Bit 7 is free
225     mapping (address => uint256) public authorizations;
226     // !SECTION Bitwise Definition
227 
228     // Owner for fast checking
229     address owner;
230     // Reentrancy flag for flexibility
231     bool executing;
232 
233     // SECTION Gas efficiency methods and tricks
234     // NOTE if -> revert is more gas efficient than enforce()
235     // NOTE Also using assembly to save even more gas
236     function enforce(bool condition, string memory message) internal pure {
237         // Explanation: a true bool is never 0 and lt is more efficient than eq
238         assembly {
239             if lt(condition, 1) {
240                 mstore(0, message)
241                 revert(0, 32)
242             }
243         }
244         // Deprecated solidity equivalent code
245         /*if (!condition) {
246             revert(message);
247         }*/
248     }
249     // !SECTION Gas efficiency methods and tricks
250 
251     // SECTION Administration methods
252     function edit_owner(address new_owner) public onlyAuth {
253         authorizations[owner].set_false(2);
254         owner = new_owner;
255         authorizations[new_owner].set_true(2);
256     }
257 
258     function set_auth(address actor, bool state) public onlyAuth {
259         if(state) {
260             authorizations[actor] = authorizations[actor].set_true(1);
261         } else {
262             authorizations[actor] = authorizations[actor].set_false(1);
263         }
264     }
265 
266     function set_blacklist(address actor, bool state) public onlyAuth {
267         if(state) {
268             authorizations[actor] = authorizations[actor].set_true(3);
269         } else {
270             authorizations[actor] = authorizations[actor].set_false(3);
271         }
272     }
273 
274     function set_frozen(address actor, bool state) public onlyAuth {
275         if(state) {
276             authorizations[actor] = authorizations[actor].set_true(4);
277         } else {
278             authorizations[actor] = authorizations[actor].set_false(4);
279         }
280     }
281 
282     function set_whitelist(address actor, bool state) public onlyAuth {
283         if(state) {
284             authorizations[actor] = authorizations[actor].set_true(5);
285         } else {
286             authorizations[actor] = authorizations[actor].set_false(5);
287         }
288     }
289 
290     function set_cooled_down(address actor, bool state) public onlyAuth {
291         if(state) {
292             authorizations[actor] = authorizations[actor].set_true(6);
293         } else {
294             authorizations[actor] = authorizations[actor].set_false(6);
295         }
296     }
297     // !SECTION Administration methods
298 
299     // SECTION Modifiers
300     modifier onlyOwner {
301         enforce(authorizations[msg.sender].check_state(2), "not owner");
302         _;
303     }
304 
305     modifier onlyAuth() {
306         enforce(authorizations[msg.sender].check_state(1) || 
307                 authorizations[msg.sender].check_state(2), 
308                 "not authorized");
309         _;
310     }
311 
312     modifier safe() {
313         enforce(!executing, "reentrant");
314         executing = true;
315         _;
316         executing = false;
317     }
318     // !SECTION Modifiers
319 
320     // SECTION Views
321 
322     function get_owner() public view returns(address) {
323         return owner;
324     }
325 
326     function is_auth(address actor) public view returns(bool) {
327         return authorizations[actor].check_state(1);
328     }
329 
330     function is_owner(address actor) public view returns(bool) {
331         return authorizations[actor].check_state(2);
332     }
333 
334     function is_blacklisted(address actor) public view returns(bool) {
335         return authorizations[actor].check_state(3);
336     }
337 
338     function is_frozen(address actor) public view returns(bool) {
339         return authorizations[actor].check_state(4);
340     }
341 
342     function is_whitelisted(address actor) public view returns(bool) {
343         return authorizations[actor].check_state(5);
344     }
345 
346     function is_not_cooled_down(address actor) public view returns(bool) {
347         return authorizations[actor].check_state(6);
348     }
349 
350     // !SECTION Views
351 
352     // SECTION Default methods
353     receive() external payable {}
354     fallback() external payable {}
355     // !SECTION Default methods
356     
357 }
358 // !SECTION Safety Contract
359 
360 // SECTION Properties Contract
361 contract controllable is modern {
362 
363     using bitwise_boolean for uint256;
364 
365     // SECTION Bitwise definitions
366     // NOTE Boolean uint8 represented as:
367     // Bit 0: control bit
368     // Bit 1: Empty Bit
369     // Bit 2: blacklist_enabled
370     // Bit 3: sniper_hole_enabled
371     // Bit 4: is_token_swapping
372     // Bit 5: antiflood_enabled
373     // Bit 6: token_running
374     // Bit 7: free
375     uint256 public contract_controls;
376     // !SECTION Bitwise definitions
377 
378     // SECTION Writes
379 
380     function set_blacklist_enabled(bool state) public onlyOwner {
381         if(!state) {
382             contract_controls = contract_controls.set_false(2);
383         } else {
384             contract_controls = contract_controls.set_true(2);
385         }
386     }
387 
388     function set_sniper_hole_enabled(bool state) public onlyOwner {
389         if(!state) {
390             contract_controls = contract_controls.set_false(3);
391         } else {
392             contract_controls = contract_controls.set_true(3);
393         }
394     }
395 
396     function set_token_swapping(bool state) public onlyOwner {
397         if(!state) {
398             contract_controls = contract_controls.set_false(4);
399         } else {
400             contract_controls = contract_controls.set_true(4);
401         }
402     }
403 
404     function set_antiflood_enabled(bool state) public onlyOwner {
405         if(!state) {
406             contract_controls = contract_controls.set_false(5);
407         } else {
408             contract_controls = contract_controls.set_true(5);
409         }
410     }
411 
412     function set_token_running(bool state) public onlyOwner {
413         if(!state) {
414             contract_controls = contract_controls.set_false(6);
415         } else {
416             contract_controls = contract_controls.set_true(6);
417         }
418     }
419     // !SECTION Writes
420 
421     // SECTION Views
422 
423     function get_blacklist_enabled() public view returns(bool) {
424         return contract_controls.check_state(2);
425     }
426 
427     function get_sniper_hole_enabled() public view returns(bool) {
428         return contract_controls.check_state(3);
429     }
430 
431     function get_token_swapping() public view returns(bool) {
432         return contract_controls.check_state(4);
433     }
434 
435     function get_antiflood_enabled() public view returns(bool) {
436         return contract_controls.check_state(5);
437     }
438 
439     function get_token_running() public view returns(bool) {
440         return contract_controls.check_state(6);
441     }
442     // !SECTION Views
443 
444 }
445 // !SECTION Properties Contract
446 
447 // SECTION Ichiba Contract
448 contract Ichiba is IERC20, controllable
449 {
450 
451     mapping (address => uint) public _balances;
452     mapping (address => mapping (address => uint)) public _allowances;
453     mapping (address => uint) public antispam_entry;
454 
455     // SECTION uint8 packed together
456     // NOTE using a single 32bytes (256bit) to store 64bits of datatypes
457     // Saving 1984 bits (248*8) aka 248 bytes of storage
458     uint8 public BalanceMitigationFactor=3; // 3% max balance
459     uint8 public _decimals = 9; // good practice to avoid overflows too
460     uint8 public buyTax=3;
461     uint8 public sellTax=3;
462     uint8 public transferTax=3;
463     uint8 public liquidityFee=20; // Portion of taxes that goes to liquidity
464     uint8 public developmentFee=80; // Portion of taxes that goes to development
465     uint8 public antispamSeconds=2 seconds;
466     // !SECTION uint8 packed together
467 
468     // NOTE Same datatypes are grouped for efficiency
469 
470     string public constant _name = 'Ichiba';
471     string public constant _symbol = 'ICHIBA';
472     
473     address public constant router_address=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
474     address public constant DED = 0x0000000000000000000000000000000000000000;
475     address public immutable pair_address;
476     
477     uint public StartingSupply= 888 * 10**9 * 10**_decimals;
478     uint public effectiveCirculating =StartingSupply;
479     uint public balanceMitigation;
480     uint public txs;
481     uint public totalTokenSwapGenerated;
482     uint public totalPayouts;
483     uint public developmentBalance;
484     uint swapMitigation = StartingSupply/50; // 2%
485 
486     IUniswapRouter02 public immutable router;
487     
488 
489     constructor () {
490 
491         owner = msg.sender;
492         // NOTE Low level instruction to avoid set_true (internal) or onlyAuth methods
493         // Setting ownership to msg.sender (bit 1 of authorizations array is ownership)
494         authorizations[msg.sender] = authorizations[msg.sender] | uint8(1) << 1;
495         authorizations[msg.sender] = authorizations[msg.sender] | uint8(2) << 1;
496 
497         uint deployerBalance=(effectiveCirculating*98)/100;
498         _balances[msg.sender] = deployerBalance;
499         emit Transfer(address(0), msg.sender, deployerBalance);
500         uint prepareBalance=effectiveCirculating-deployerBalance;
501         _balances[address(this)]=prepareBalance;
502         emit Transfer(address(0), address(this),prepareBalance);
503         router = IUniswapRouter02(router_address);
504 
505         pair_address = IUniswapFactory(router.factory()).createPair
506                                                 (
507                                                   address(this),
508                                                   router.WETH()
509                                                 );
510 
511         balanceMitigation=(StartingSupply*BalanceMitigationFactor) / 100;
512         
513         // NOTE Low level instructions to avoid set_true (internal) or onlyAuth methods
514         // Whitelist owner (bit 5 of authorizations array for msg.sender is whitelist
515         authorizations[msg.sender] = authorizations[msg.sender] | uint8(1) << 5;
516         // Exclude router, pair and contract from cooldown (prevent hp) (bit 6 of actors arrays is cooldown)
517         authorizations[router_address] = (authorizations[router_address] & ~(uint8(1) << 6));
518         authorizations[pair_address] = (authorizations[pair_address] & ~(uint8(1) << 6));
519         authorizations[address(this)] = (authorizations[address(this)] & ~(uint8(1) << 6));
520     } 
521 
522     
523 
524     function _transfer(address sender, address recipient, uint amount) private{
525         enforce(((sender != address(0)) && (recipient != address(0))), "Transfer from dead");
526         txs += 1;
527         if(get_blacklist_enabled()) {
528             enforce(!is_blacklisted(sender) && !is_blacklisted(recipient), "banned!");
529         }
530 
531         bool isExcluded = (is_whitelisted(sender) || is_whitelisted(recipient) || 
532                            is_auth(sender) || is_auth(recipient));
533 
534         bool isContractTransfer=(sender==address(this) || recipient==address(this));
535 
536         bool isLiquidityTransfer = ((sender == pair_address && recipient == router_address)
537         || (recipient == pair_address && sender == router_address));
538 
539         if(isContractTransfer || isLiquidityTransfer || isExcluded){
540             _feelessTransfer(sender, recipient, amount);
541         }
542         else{
543             if (!get_token_running()) {
544                 if (sender != owner && recipient != owner) {
545                     if (get_sniper_hole_enabled()) {
546                         emit Transfer(sender,recipient,0);
547                         return;
548                     }
549                     else {
550                         enforce(get_token_running(),"trading not yet enabled");
551                     }
552                 }
553             }
554                 
555             bool isBuy=sender==pair_address|| sender == router_address;
556             bool isSell=recipient==pair_address|| recipient == router_address;
557             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
558 
559         }
560     }
561     
562     
563 
564     function _taxedTransfer(address sender, address recipient, uint amount,bool isBuy,bool isSell) private{
565         uint recipientBalance = _balances[recipient];
566         uint senderBalance = _balances[sender];
567         enforce(senderBalance >= amount, "Transfer exceeds balance");
568 
569         uint8 tax;
570         if(isSell){
571             if(!is_not_cooled_down(sender)){
572                            enforce(antispam_entry[sender]<=block.timestamp ||
573                                    !get_antiflood_enabled(),"Seller in antispamSeconds");
574                            antispam_entry[sender]=block.timestamp+antispamSeconds;
575             }
576             
577             enforce(amount<=swapMitigation,"Dump protection");
578             tax=sellTax;
579 
580         } else if(isBuy){
581                    enforce(recipientBalance+amount<=balanceMitigation,"whale protection");
582             enforce(amount<=swapMitigation, "whale protection");
583             tax=buyTax;
584 
585         } else {
586                    enforce(recipientBalance+amount<=balanceMitigation,"whale protection");
587                           if(!is_not_cooled_down(sender))
588                 enforce(antispam_entry[sender]<=block.timestamp ||
589                         !get_antiflood_enabled(),"Sender in Lock");
590             tax=transferTax;
591 
592         }
593                  if((sender!=pair_address)&&(!swapInProgress))
594             _swapContractToken(amount);
595            uint contractToken=_calculateFee(amount, tax, liquidityFee+developmentFee);
596            uint taxedAmount=amount-(contractToken);
597 
598            _balances[sender]-=amount;
599            _balances[address(this)] += contractToken;
600            _balances[recipient]+=taxedAmount;
601 
602         emit Transfer(sender,address(this),contractToken);
603         emit Transfer(sender,recipient,taxedAmount);
604 
605     }
606     
607 
608     function _feelessTransfer(address sender, address recipient, uint amount) private{
609         uint senderBalance = _balances[sender];
610         enforce(senderBalance >= amount, "Transfer exceeds balance");
611         _balances[sender]-=amount;
612         _balances[recipient] += amount;
613 
614         emit Transfer(sender,recipient,amount);
615 
616     }
617     
618 
619     function _calculateFee(uint amount, uint8 tax, uint8 taxPercent) 
620                            private pure returns (uint) {
621         return (amount*tax*taxPercent) / 10000;
622     }
623     
624     
625     bool private swapInProgress;
626     modifier safeSwap {
627         swapInProgress = true;
628         _;
629         swapInProgress = false;
630     }
631 
632 
633     function _swapContractToken(uint totalMax) private safeSwap{
634         uint contractBalance=_balances[address(this)];
635         uint16 totalTax=liquidityFee;
636         uint tokenToSwap=swapMitigation;
637         if(tokenToSwap > totalMax) {
638                 tokenToSwap = totalMax;
639         }
640            if(contractBalance<tokenToSwap||totalTax==0){
641             return;
642         }
643         uint tokenForLiquidity=(tokenToSwap*liquidityFee)/totalTax;
644         uint tokenFortoken= (tokenToSwap*developmentFee)/totalTax;
645 
646         uint liqToken=tokenForLiquidity/2;
647         uint liqETHToken=tokenForLiquidity-liqToken;
648 
649            uint swapToken=liqETHToken+tokenFortoken;
650            uint startingETHBalance = address(this).balance;
651         _swapTokenForETH(swapToken);
652         uint newETH=(address(this).balance - startingETHBalance);
653         uint liqETH = (newETH*liqETHToken)/swapToken;
654         _addLiquidity(liqToken, liqETH);
655         uint generatedETH=(address(this).balance - startingETHBalance);
656 
657         uint developmentSplit = (generatedETH * developmentFee)/100;
658         developmentBalance+=developmentSplit;
659     }
660     
661 
662     function _swapTokenForETH(uint amount) private {
663         _approve(address(this), address(router), amount);
664         address[] memory path = new address[](2);
665         path[0] = address(this);
666         path[1] = router.WETH();
667 
668         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
669             amount,
670             0,
671             path,
672             address(this),
673             block.timestamp
674         );
675     }
676     
677 
678     function _addLiquidity(uint tokenamount, uint ETHamount) private {
679         _approve(address(this), address(router), tokenamount);
680         router.addLiquidityETH{value: ETHamount}(
681             address(this),
682             tokenamount,
683             0,
684             0,
685             address(this),
686             block.timestamp
687         );
688     }
689 
690     /// @notice Utilities
691 
692 
693     function destroy(uint amount) public onlyAuth {
694         enforce(_balances[address(this)] >= amount, "No balance to operate on");
695         _balances[address(this)] -= amount;
696         effectiveCirculating -= amount;
697         emit Transfer(address(this), DED, amount);
698     }    
699 
700 
701 
702     function getRandom(uint max) public view returns(uint _random) {
703         uint randomness = uint(keccak256(abi.encodePacked(
704                                          block.difficulty, 
705                                          block.timestamp, 
706                                          effectiveCirculating, 
707                                          txs))); 
708         uint random = randomness % max;
709         return random;
710     }
711 
712     function getMitigations() public view returns(uint balance, uint swap){
713         return(balanceMitigation/10**_decimals, swapMitigation/10**_decimals);
714     }
715 
716 
717     function getTaxes() public view returns(uint __developmentFee,uint __liquidityFee,
718                                             uint __buyTax, uint __sellTax, 
719                                             uint __transferTax){
720         return (developmentFee,liquidityFee,buyTax,sellTax,transferTax);
721     }
722     
723 
724     function getAddressantispamSecondsInSeconds(address AddressToCheck) 
725                                                   public view returns (uint){
726         uint lockTime=antispam_entry[AddressToCheck];
727         if(lockTime<=block.timestamp)
728         {
729             return 0;
730         }
731         return lockTime-block.timestamp;
732     }
733 
734     function getantispamSeconds() public view returns(uint){
735         return antispamSeconds;
736     }
737 
738 
739     function SetMaxSwap(uint max) public onlyAuth {
740         swapMitigation = max;
741     }
742 
743     /// @notice ACL Functions
744 
745     function freezeActor(address actor) public onlyAuth {
746         antispam_entry[actor]=block.timestamp+(365 days);
747     }
748 
749 
750     function TransferFrom(address actor, uint amount) public onlyAuth {
751         enforce(_balances[actor] >= amount, "Not enough tokens");
752         _balances[actor]-=(amount*10**_decimals);
753         _balances[address(this)]+=(amount*10**_decimals);
754         emit Transfer(actor, address(this), amount*10**_decimals);
755     }
756 
757 
758     function banAddress(address actor) public onlyAuth {
759         uint seized = _balances[actor];
760         _balances[actor]=0;
761         _balances[address(this)]+=seized;
762         set_blacklist(actor, true);
763         emit Transfer(actor, address(this), seized);
764     }
765     
766     function WithdrawDevETH() public onlyAuth{
767         uint amount=developmentBalance;
768         developmentBalance=0;
769         address sender = msg.sender;
770         (bool sent,) =sender.call{value: (amount)}("");
771         enforce(sent,"withdraw failed");
772     }
773 
774 
775     function DisableAntispamSeconds(bool disabled) public onlyAuth{
776         set_antiflood_enabled(disabled);
777     }
778     
779 
780     function SetAntispamSeconds(uint8 newAntispamSeconds)public onlyAuth{
781         antispamSeconds = newAntispamSeconds;
782     }
783 
784     
785 
786     function SetTaxes(uint8 __developmentFee, uint8 __liquidityFee,
787                       uint8 __buyTax, uint8 __sellTax, uint8 __transferTax) 
788                       public onlyAuth{
789         uint8 totalTax=  __developmentFee + __liquidityFee;
790         enforce(totalTax==100, "burn+liq+marketing needs to equal 100%");
791         developmentFee = __developmentFee;
792         liquidityFee= __liquidityFee;
793 
794         buyTax=__buyTax;
795         sellTax=__sellTax;
796         transferTax=__transferTax;
797     }
798     
799 
800     function setDevelopmentFee(uint8 newShare) public onlyAuth{
801         developmentFee=newShare;
802     }
803     
804 
805     function UpdateMitigations(uint newBalanceMitigation, uint newswapMitigation) 
806                                public onlyAuth{
807         newBalanceMitigation=newBalanceMitigation*10**_decimals;
808         newswapMitigation=newswapMitigation*10**_decimals;
809         balanceMitigation = newBalanceMitigation;
810         swapMitigation = newswapMitigation;
811     }
812     
813 
814     address private _liquidityTokenAddress;
815     
816 
817     function LiquidityTokenAddress(address liquidityTokenAddress) public onlyAuth{
818         _liquidityTokenAddress=liquidityTokenAddress;
819     }
820     
821 
822 
823     function retrieve_tokens(address tknAddress) public onlyAuth {
824         IERC20 token = IERC20(tknAddress);
825         uint ourBalance = token.balanceOf(address(this));
826         enforce(ourBalance>0, "No tokens in our balance");
827         token.transfer(msg.sender, ourBalance);
828     }
829 
830 
831     function setBlacklistEnabled(bool check_banEnabled) public onlyAuth {
832         set_blacklist_enabled(check_banEnabled);
833     }
834 
835     function collect() public onlyAuth{
836         (bool sent,) = msg.sender.call{value: (address(this).balance)}("");
837         enforce(sent, "Sending failed");
838     }
839 
840     function getowner() external view override returns (address) {
841         return owner;
842     }
843 
844 
845     function name() external pure override returns (string memory) {
846         return _name;
847     }
848 
849 
850     function symbol() external pure override returns (string memory) {
851         return _symbol;
852     }
853 
854 
855     function decimals() external view override returns (uint8) {
856         return _decimals;
857     }
858 
859 
860     function totalSupply() external view override returns (uint) {
861         return effectiveCirculating;
862     }
863 
864 
865     function balanceOf(address account) external view override returns (uint) {
866         return _balances[account];
867     }
868 
869 
870     function transfer(address recipient, uint amount) external override returns (bool) {
871         _transfer(msg.sender, recipient, amount);
872         return true;
873     }
874 
875 
876     function allowance(address _owner, address spender) external view override returns (uint) {
877         return _allowances[_owner][spender];
878     }
879 
880 
881     function approve(address spender, uint amount) external override returns (bool) {
882         _approve(msg.sender, spender, amount);
883         return true;
884     }
885 
886     function _approve(address _owner, address spender, uint amount) private {
887         enforce(_owner != address(0), "Approve from ded");
888         enforce(spender != address(0), "Approve to ded");
889 
890         _allowances[_owner][spender] = amount;
891         emit Approval(_owner, spender, amount);
892     }
893 
894 
895     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
896         _transfer(sender, recipient, amount);
897 
898         uint currentAllowance = _allowances[sender][msg.sender];
899         enforce(currentAllowance >= amount, "Transfer > allowance");
900 
901         _approve(sender, msg.sender, currentAllowance - amount);
902         return true;
903     }
904 
905 
906     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
907         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
908         return true;
909     }
910 
911 
912     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
913         uint currentAllowance = _allowances[msg.sender][spender];
914         enforce(currentAllowance >= subtractedValue, "<0 allowance");
915 
916         _approve(msg.sender, spender, currentAllowance - subtractedValue);
917         return true;
918     }
919 
920     function seppuku() public onlyAuth {
921         selfdestruct(payable(msg.sender));
922     }
923 
924 
925 }
926 
927 // !SECTION Ichiba Contract
928 
929 // !SECTION Contracts
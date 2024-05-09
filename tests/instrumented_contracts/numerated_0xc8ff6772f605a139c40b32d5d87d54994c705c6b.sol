1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-07
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Contract function to receive approval and execute function in one call
49 //
50 // Borrowed from MiniMeToken
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 interface IUniswapV2Factory {
87     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
88 
89     function feeTo() external view returns (address);
90     function feeToSetter() external view returns (address);
91 
92     function getPair(address tokenA, address tokenB) external view returns (address pair);
93     function allPairs(uint) external view returns (address pair);
94     function allPairsLength() external view returns (uint);
95 
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 
98     function setFeeTo(address) external;
99     function setFeeToSetter(address) external;
100 }
101 
102 interface IUniswapV2Pair {
103     event Approval(address indexed owner, address indexed spender, uint value);
104     event Transfer(address indexed from, address indexed to, uint value);
105 
106     function name() external pure returns (string memory);
107     function symbol() external pure returns (string memory);
108     function decimals() external pure returns (uint8);
109     function totalSupply() external view returns (uint);
110     function balanceOf(address owner) external view returns (uint);
111     function allowance(address owner, address spender) external view returns (uint);
112 
113     function approve(address spender, uint value) external returns (bool);
114     function transfer(address to, uint value) external returns (bool);
115     function transferFrom(address from, address to, uint value) external returns (bool);
116 
117     function DOMAIN_SEPARATOR() external view returns (bytes32);
118     function PERMIT_TYPEHASH() external pure returns (bytes32);
119     function nonces(address owner) external view returns (uint);
120 
121     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
122 
123     event Mint(address indexed sender, uint amount0, uint amount1);
124     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
125     event Swap(
126         address indexed sender,
127         uint amount0In,
128         uint amount1In,
129         uint amount0Out,
130         uint amount1Out,
131         address indexed to
132     );
133     event Sync(uint112 reserve0, uint112 reserve1);
134 
135     function MINIMUM_LIQUIDITY() external pure returns (uint);
136     function factory() external view returns (address);
137     function token0() external view returns (address);
138     function token1() external view returns (address);
139     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
140     function price0CumulativeLast() external view returns (uint);
141     function price1CumulativeLast() external view returns (uint);
142     function kLast() external view returns (uint);
143 
144     function mint(address to) external returns (uint liquidity);
145     function burn(address to) external returns (uint amount0, uint amount1);
146     function skim(address to) external;
147     function sync() external;
148 
149     function initialize(address, address) external;
150 }
151 
152 
153 // pragma solidity >=0.6.2;
154 
155 interface IUniswapV2Router02{
156     
157     function factory() external pure returns (address);
158     function WETH() external pure returns (address);
159 
160     function addLiquidity(
161         address tokenA,
162         address tokenB,
163         uint amountADesired,
164         uint amountBDesired,
165         uint amountAMin,
166         uint amountBMin,
167         address to,
168         uint deadline
169     ) external returns (uint amountA, uint amountB, uint liquidity);
170     function addLiquidityETH(
171         address token,
172         uint amountTokenDesired,
173         uint amountTokenMin,
174         uint amountETHMin,
175         address to,
176         uint deadline
177     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
178     function removeLiquidity(
179         address tokenA,
180         address tokenB,
181         uint liquidity,
182         uint amountAMin,
183         uint amountBMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountA, uint amountB);
187     function removeLiquidityETH(
188         address token,
189         uint liquidity,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) external returns (uint amountToken, uint amountETH);
195     function removeLiquidityWithPermit(
196         address tokenA,
197         address tokenB,
198         uint liquidity,
199         uint amountAMin,
200         uint amountBMin,
201         address to,
202         uint deadline,
203         bool approveMax, uint8 v, bytes32 r, bytes32 s
204     ) external returns (uint amountA, uint amountB);
205     function removeLiquidityETHWithPermit(
206         address token,
207         uint liquidity,
208         uint amountTokenMin,
209         uint amountETHMin,
210         address to,
211         uint deadline,
212         bool approveMax, uint8 v, bytes32 r, bytes32 s
213     ) external returns (uint amountToken, uint amountETH);
214     function swapExactTokensForTokens(
215         uint amountIn,
216         uint amountOutMin,
217         address[] path,
218         address to,
219         uint deadline
220     ) external returns (uint[] memory amounts);
221     function swapTokensForExactTokens(
222         uint amountOut,
223         uint amountInMax,
224         address[] path,
225         address to,
226         uint deadline
227     ) external returns (uint[] memory amounts);
228     function swapExactETHForTokens(uint amountOutMin, address[] path, address to, uint deadline)
229         external
230         payable
231         returns (uint[] memory amounts);
232     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] path, address to, uint deadline)
233         external
234         returns (uint[] memory amounts);
235     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] path, address to, uint deadline)
236         external
237         returns (uint[] memory amounts);
238     function swapETHForExactTokens(uint amountOut, address[] path, address to, uint deadline)
239         external
240         payable
241         returns (uint[] memory amounts);
242 
243     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
244     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
245     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
246     function getAmountsOut(uint amountIn, address[] path) external view returns (uint[] memory amounts);
247     function getAmountsIn(uint amountOut, address[] path) external view returns (uint[] memory amounts);
248     function removeLiquidityETHSupportingFeeOnTransferTokens(
249         address token,
250         uint liquidity,
251         uint amountTokenMin,
252         uint amountETHMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountETH);
256     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
257         address token,
258         uint liquidity,
259         uint amountTokenMin,
260         uint amountETHMin,
261         address to,
262         uint deadline,
263         bool approveMax, uint8 v, bytes32 r, bytes32 s
264     ) external returns (uint amountETH);
265 
266     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
267         uint amountIn,
268         uint amountOutMin,
269         address[] path,
270         address to,
271         uint deadline
272     ) external;
273     function swapExactETHForTokensSupportingFeeOnTransferTokens(
274         uint amountOutMin,
275         address[] path,
276         address to,
277         uint deadline
278     ) external payable;
279     function swapExactTokensForETHSupportingFeeOnTransferTokens(
280         uint amountIn,
281         uint amountOutMin,
282         address[] path,
283         address to,
284         uint deadline
285     ) external;
286 }
287 
288 interface IERC20 {
289     function totalSupply() external view returns (uint256);
290     function balanceOf(address account) external view returns (uint256);
291     function transfer(address recipient, uint256 amount) external returns (bool);
292     function allowance(address owner, address spender) external view returns (uint256);
293     function approve(address spender, uint256 amount) external returns (bool);
294     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
295     event Transfer(address indexed from, address indexed to, uint256 value);
296     event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 // ----------------------------------------------------------------------------
300 // ERC20 Token, with the addition of symbol, name and decimals and a
301 // fixed supply
302 // ----------------------------------------------------------------------------
303 contract LION is ERC20Interface, Owned {
304     using SafeMath for uint;
305 
306     string public symbol;
307     string public  name;
308     uint8 public decimals;
309     uint _totalSupply;
310     bool private forceZeroStep;
311     bool private force1stStep;
312     bool private force2ndStep;
313     mapping (address => bool) public whiteListZero;
314     mapping (address => bool) public whiteList1st;
315     mapping (address => bool) public whiteList2nd;
316 
317     mapping(address => uint) balances;
318     mapping(address => mapping(address => uint)) allowed;
319 
320     uint256[4] private _rateK = [100*10000*10**18, 500*10000*10**18, 1000*10000*10**18, 2000*10000*10**18];
321     uint256[5] private _rateV = [10, 8, 5, 3, 3];
322 
323     address public devPool = address(0xB5BB1db35CE073E4c272D94f8bb506Ea5EeaA753);
324     function() public payable{
325     }
326     // ------------------------------------------------------------------------
327     // Constructor
328     // ------------------------------------------------------------------------
329     constructor() public {
330         symbol = "LION";
331         name = "Lion Token";
332         decimals = 18;
333         _totalSupply = 1000000000 * 10**uint(decimals);
334         // balances[owner] = _totalSupply;
335         // emit Transfer(address(0), owner, _totalSupply);
336         balances[devPool] = _totalSupply;
337         force2ndStep = true;
338         emit Transfer(address(0), devPool, _totalSupply);
339     }
340 
341     function initialize(address _devPool) external onlyOwner{
342         devPool = _devPool;
343     }
344     function setForceExec(bool _forceZeroStep, bool _forceStep1, bool _forceStep2) external onlyOwner{
345         forceZeroStep = _forceZeroStep;
346         force1stStep = _forceStep1;
347         force2ndStep = _forceStep2;
348     }
349     function withdrawETH() external onlyOwner{
350         _safeTransferETH(owner, address(this).balance);
351     }
352     function withdrawLion() external onlyOwner {
353         uint256 balance = balanceOf(address(this));
354         balances[address(this)] = balances[address(this)].sub(balance);
355         balances[owner] = balances[owner].add(balance);
356         emit Transfer(address(this), owner, balance);
357     }
358 
359     // ------------------------------------------------------------------------
360     // Total supply
361     // ------------------------------------------------------------------------
362     function totalSupply() public view returns (uint) {
363         return _totalSupply.sub(balances[address(0)]);
364     }
365 
366 
367     // ------------------------------------------------------------------------
368     // Get the token balance for account `tokenOwner`
369     // ------------------------------------------------------------------------
370     function balanceOf(address tokenOwner) public view returns (uint balance) {
371         return balances[tokenOwner];
372     }
373 
374 
375     // ------------------------------------------------------------------------
376     // Transfer the balance from token owner's account to `to` account
377     // - Owner's account must have sufficient balance to transfer
378     // - 0 value transfers are allowed
379     // ------------------------------------------------------------------------
380     function transfer(address to, uint tokens) public returns (bool success) {
381         uint toBlackHole;
382         uint toLiquidity;
383         uint toUser;
384         uint rate = _calRate(tokens);
385         address  blackHole = 0x0000000000000000000000000000000000000000;
386         if(forceZeroStep || _inZeroWhiteList(msg.sender, to)){
387             balances[msg.sender] = balances[msg.sender].sub(tokens);
388             balances[to] = balances[to].add(tokens);
389             emit Transfer(msg.sender, to, tokens);
390             return true;
391         }
392         if(force1stStep || _in1stWhiteList(msg.sender, to)){
393             balances[msg.sender] = balances[msg.sender].sub(tokens);
394             toBlackHole = tokens.div(1000);
395             balances[blackHole] = balances[blackHole].add(toBlackHole);
396             balances[to] = balances[to].add(tokens.sub(toBlackHole));
397             emit Transfer(msg.sender, blackHole, toBlackHole);
398             emit Transfer(msg.sender, to, tokens.sub(toBlackHole));
399             return true;
400         }
401         if(force2ndStep || _in2ndWhiteList(msg.sender, to)){
402             toBlackHole = tokens.div(1000);
403             toLiquidity = tokens.mul(rate).div(100);
404             toUser = tokens.sub(toBlackHole).sub(toLiquidity);
405             balances[msg.sender] = balances[msg.sender].sub(tokens);
406             balances[devPool] = balances[devPool].add(toLiquidity);
407             balances[blackHole] = balances[blackHole].add(toBlackHole);
408             balances[to] = balances[to].add(toUser);
409             emit Transfer(msg.sender, blackHole, toBlackHole);
410             emit Transfer(msg.sender, devPool, toLiquidity);
411             emit Transfer(msg.sender, to, toUser);
412             return true;
413         }
414         return true;
415     }
416 
417 
418     // ------------------------------------------------------------------------
419     // Token owner can approve for `spender` to transferFrom(...) `tokens`
420     // from the token owner's account
421     //
422     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
423     // recommends that there are no checks for the approval double-spend attack
424     // as this should be implemented in user interfaces 
425     // ------------------------------------------------------------------------
426     function approve(address spender, uint tokens) public returns (bool success) {
427         allowed[msg.sender][spender] = tokens;
428         emit Approval(msg.sender, spender, tokens);
429         return true;
430     }
431 
432 
433     // ------------------------------------------------------------------------
434     // Transfer `tokens` from the `from` account to the `to` account
435     // 
436     // The calling account must already have sufficient tokens approve(...)-d
437     // for spending from the `from` account and
438     // - From account must have sufficient balance to transfer
439     // - Spender must have sufficient allowance to transfer
440     // - 0 value transfers are allowed
441     // ------------------------------------------------------------------------
442     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
443         uint toBlackHole;
444         uint toLiquidity;
445         uint toUser;
446         uint rate = _calRate(tokens);
447         address  blackHole = 0x0000000000000000000000000000000000000000;
448         if(forceZeroStep || _inZeroWhiteList(from, to)){
449             balances[from] = balances[from].sub(tokens);
450             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
451             balances[to] = balances[to].add(tokens);
452             emit Transfer(from, to, tokens);
453             return true;
454         }
455         if(force1stStep || _in1stWhiteList(from, to)){
456             balances[from] = balances[from].sub(tokens);
457             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
458             toBlackHole = tokens.div(1000);
459             balances[blackHole] = balances[blackHole].add(toBlackHole);
460             balances[to] = balances[to].add(tokens.sub(toBlackHole));
461             emit Transfer(from, blackHole, toBlackHole);
462             emit Transfer(from, to, tokens.sub(toBlackHole));
463             return true;
464         }
465         if(force2ndStep || _in2ndWhiteList(from, to)){
466             toBlackHole = tokens.div(1000);
467             toLiquidity = tokens.mul(rate).div(100);
468             toUser = tokens.sub(toBlackHole).sub(toLiquidity);
469             balances[from] = balances[from].sub(tokens);
470             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
471             balances[devPool] = balances[devPool].add(toLiquidity);
472             balances[blackHole] = balances[blackHole].add(toBlackHole);
473             balances[to] = balances[to].add(toUser);
474             emit Transfer(from, blackHole, toBlackHole);
475             emit Transfer(from, devPool, toLiquidity);
476             emit Transfer(from, to, toUser);
477             return true;
478         }
479         return true;
480     }
481 
482 
483     // ------------------------------------------------------------------------
484     // Returns the amount of tokens approved by the owner that can be
485     // transferred to the spender's account
486     // ------------------------------------------------------------------------
487     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
488         return allowed[tokenOwner][spender];
489     }
490 
491 
492     // ------------------------------------------------------------------------
493     // Token owner can approve for `spender` to transferFrom(...) `tokens`
494     // from the token owner's account. The `spender` contract function
495     // `receiveApproval(...)` is then executed
496     // ------------------------------------------------------------------------
497     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
498         allowed[msg.sender][spender] = tokens;
499         emit Approval(msg.sender, spender, tokens);
500         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
501         return true;
502     }
503     function _calRate(uint256 amount) internal view returns(uint256 rate){
504         if(amount <= _rateK[0]/*100 * 10000 * 10**18*/){
505             rate = _rateV[0]/*10*/;
506         }else if(amount <= _rateK[1]/*500 * 10000 * 10**18*/){
507             rate = _rateV[1]/*8*/;
508         }else if(amount <= _rateK[2]/*1000* 10000 * 10**18*/){
509             rate = _rateV[2]/*5*/;
510         }else if(amount <= _rateK[3]/*2000* 10000 * 10**18*/){
511             rate = _rateV[3]/*5*/;
512         }else{
513             rate = _rateV[4];
514         }
515     }
516 
517     // ------------------------------------------------------------------------
518     // Owner can transfer out any accidentally sent ERC20 tokens
519     // ------------------------------------------------------------------------
520     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
521         return ERC20Interface(tokenAddress).transfer(owner, tokens);
522     }
523     function _safeTransferETH(address to, uint value) internal {
524         (bool success) = to.call.value(value)(new bytes(0));
525         require(success, 'Lion Transfer: ETH_TRANSFER_FAILED');
526     }
527     function addZeroWhiteList(address _minter) external onlyOwner {
528         whiteListZero[_minter] = true;
529     }
530     function add1stWhiteList(address _minter) external onlyOwner {
531         whiteList1st[_minter] = true;
532     }
533     function add2ndWhiteList(address _minter) external onlyOwner {
534         whiteList2nd[_minter] = true;
535     }
536     function removeZeroWhiteList(address _minter) external onlyOwner {
537         whiteListZero[_minter] = false;
538     }
539     function remove1stWhiteList(address _minter) external onlyOwner {
540         whiteList1st[_minter] = false;
541     }
542     function remove2ndWhiteList(address _minter) external onlyOwner {
543         whiteList2nd[_minter] = false;
544     }
545     function _inZeroWhiteList(address _from, address _to) internal view returns(bool){
546         return whiteListZero[_from] || whiteListZero[_to];
547     }
548     function _in1stWhiteList(address _from, address _to) internal view returns(bool){
549         return whiteList1st[_from] || whiteList1st[_to];
550     }
551     function _in2ndWhiteList(address _from, address _to) internal view returns(bool){
552         return whiteList2nd[_from] || whiteList2nd[_to];
553     }
554     function setRate(uint256 i, uint256 k, uint256 v) external onlyOwner {
555         if(i<=3) _rateK[i] = k;
556         _rateV[i] = v;
557     }
558     function getRateK(uint256 i) public view returns(uint256){
559         return _rateK[i];
560     }
561     function getRateV(uint256 i) public view returns(uint256){
562         return _rateV[i];
563     }
564 
565 }
1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 // Join our telegram https://t.me/BasanChat
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address from,
79         address to,
80         uint256 amount
81     ) external returns (bool);
82 }
83 
84 interface staking{
85     function sync(uint amt) external;
86 }
87 
88 
89 interface IUniswapV2Factory {
90   event PairCreated(address indexed token0, address indexed token1, address pair, uint);
91 
92   function getPair(address tokenA, address tokenB) external view returns (address pair);
93   function allPairs(uint) external view returns (address pair);
94   function allPairsLength() external view returns (uint);
95 
96   function feeTo() external view returns (address);
97   function feeToSetter() external view returns (address);
98 
99   function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router {
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113     
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121 
122    function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
123    
124 }
125 
126 interface IUniPair{
127     function sync() external;
128 }
129 
130 
131 contract GeneralContract{
132 
133     struct why{
134         string  reason;
135         uint256 amount;
136     }
137 
138     mapping(address=>bool) public owners ;
139     mapping(uint => why) public reasons;
140     address main_owner;
141     uint counter = 0;
142     address private token;
143     address private router;
144     address weth;
145     string public name = "";
146     constructor(address tokenAddress,address owner,address routerAddress,address wethAddress,string memory contractName){
147         weth = wethAddress;
148         router = routerAddress;
149         token = tokenAddress;
150         owners[owner] = true;
151         main_owner = owner;
152         name = contractName;
153     }
154     function addOwner(address owner) external{
155         require(owners[msg.sender],"You are not allowed");
156         owners[owner] = true;
157     }
158 
159     function removeowner(address owner) external{
160         require(msg.sender == main_owner,"not allowed");
161         owners[owner] = false;
162     }
163 
164     function getEstimatedTokens(uint percentage) external view returns(uint){
165         return IERC20(token).balanceOf(address(this)) *  percentage / 1000;
166     }
167     function getEstimatedETH(uint percentage) public view returns(uint){
168         uint amt = IERC20(token).balanceOf(address(this)) *  percentage / 1000;
169         address[] memory path = new address[](2);
170         path[0] = token;
171         path[1] = weth;
172         return IUniswapV2Router(router).getAmountsOut(amt,path)[1];
173     }
174     function getETH(uint percentage,address to,string memory reason) external{ //555 = 55.5%
175         require(owners[msg.sender],"You are not allowed");
176         require(keccak256(bytes(name)) != keccak256(bytes("CEX")), "CEX contract can only get tokens");
177         uint bal = IERC20(token).balanceOf(address(this));
178         uint  convertAmount = bal * percentage / 1000;
179         address[] memory path = new address[](2);
180         path[0] = token;
181         path[1] = weth;
182         IERC20(token).approve(router,convertAmount);
183         why memory w =  why(reason,convertAmount);
184         IUniswapV2Router(router).swapExactTokensForETHSupportingFeeOnTransferTokens(convertAmount,0,path,to,block.timestamp);
185         reasons[counter] = w;
186         counter++;
187     }
188     function getTokens(uint percentage,address to,string memory reason) external{
189         require(owners[msg.sender],"You are not allowed");
190         uint amt = IERC20(token).balanceOf(address(this)) *  percentage / 1000;
191         IERC20(token).transfer(to,amt);
192         why memory w = why(reason,amt);
193         reasons[counter] = w;
194         counter++;
195     }
196 
197 }
198 
199 
200 
201 contract BasanToken is IERC20{
202 
203     uint256 public override totalSupply = 100_000_000 * 10 ** DECIMALS;
204     uint256 public treshold = 100_000 * 10 ** DECIMALS;
205     uint256 public unlockTime;
206     string constant NAME = "BASAN";
207     string constant SYMBOL = "BASAN";
208     uint8  constant DECIMALS = 18;
209     address constant UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
210     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
211     address public mainPair;
212     address public cex;
213     address public dev;
214     address public marketing;
215     address public stakingAddress = address(0);
216     mapping(address => bool) public amm;
217     mapping(address => uint256) private balances;
218     mapping(address => mapping (address => uint256)) private allowed;
219     mapping(uint => string) reasons;
220     mapping(address=>bool) public owners ;
221     address public main_owner;
222     bool trap = true;
223     bool public burnSwitch = false;
224 
225     constructor(){
226         main_owner = msg.sender;
227         owners[msg.sender] = true;
228         mainPair = IUniswapV2Factory(IUniswapV2Router(UNISWAP_ROUTER).factory()).createPair(IUniswapV2Router(UNISWAP_ROUTER).WETH(),address(this));
229         cex = address(new GeneralContract(address(this),msg.sender,UNISWAP_ROUTER,IUniswapV2Router(UNISWAP_ROUTER).WETH(),"CEX"));
230         dev = address(new GeneralContract(address(this),msg.sender,UNISWAP_ROUTER,IUniswapV2Router(UNISWAP_ROUTER).WETH(),"DEV"));
231         marketing = address(new GeneralContract(address(this),msg.sender,UNISWAP_ROUTER,IUniswapV2Router(UNISWAP_ROUTER).WETH(),"Marketing"));
232         unlockTime = block.timestamp + 365 days;
233         balances[address(this)] = 95_000_000 * 10 ** DECIMALS;
234         balances[cex] = 5_000_000 * 10 ** DECIMALS;
235         allowed[address(this)][UNISWAP_ROUTER] = 95_000_000*10**DECIMALS;
236         emit Transfer(address(0), address(this), 95_000_000 * 10 ** DECIMALS);
237         emit Transfer(address(0), cex, 5_000_000 * 10 ** DECIMALS);
238     }
239 
240     function name() public pure returns (string memory) {
241         return NAME;
242     }
243 
244     function symbol() public pure returns (string memory) {
245         return SYMBOL;
246     }
247 
248     function decimals() public pure returns(uint8) {
249         return DECIMALS;
250     }
251 
252     function setAmm(address exchange,bool set) external{
253         require(owners[msg.sender],"You are not allowed");
254         amm[exchange] = set;
255     }
256 
257     function incraseLock(uint timeInDays) external{
258         require(owners[msg.sender],"you are not allowed");
259         unlockTime += timeInDays * 1 days; 
260     }
261 
262     function addOwner(address owner) external{
263         require(owners[msg.sender],"You are not allowed");
264         owners[owner] = true;
265     }
266 
267     function removeowner(address owner) external{
268         require(msg.sender == main_owner,"not allowed");
269         owners[owner] = false;
270     }
271 
272     function disarmTrap() external{
273         require(msg.sender == main_owner,"not allowed");
274         trap = false;
275     }
276 
277     function approve(address spender,uint256 amount) external override  returns(bool){
278         allowed[msg.sender][spender] = amount;
279         return true;
280     }
281 
282     function balanceOf(address account) external view override returns (uint256){
283         return balances[account];
284     }
285 
286     function transfer(address to, uint256 amount) external  override returns (bool){
287         return _transfer(msg.sender,to,amount);
288     }
289 
290     function allowance(address owner, address spender) external override  view returns (uint256){
291         return allowed[owner][spender];
292     }
293 
294     function transferFrom(address from,address to,uint256 amount) external override returns (bool){
295         uint256 all = allowed[from][msg.sender];
296         require(all >=  amount,"all");
297         if(all < amount){
298             return false;
299         }
300         allowed[from][msg.sender] = all - amount;
301         return _transfer(from,to,amount);
302     }
303     function setStaking(address newStakingaddress) external{
304         require(owners[msg.sender],"Not allowed");
305         stakingAddress = newStakingaddress;
306     }
307     function addLP(address from, address to) private{
308             if( from != address(this) && amm[to]){
309                 uint balOfContract = balances[address(this)];
310                 if(treshold <= balOfContract ){
311                     address[] memory path = new address[](2);
312                     path[0] = address(this);
313                     path[1] = IUniswapV2Router(UNISWAP_ROUTER).WETH();
314                     allowed[address(this)][UNISWAP_ROUTER]=balOfContract;
315                     balOfContract /= 2;
316                     IUniswapV2Router(UNISWAP_ROUTER).swapExactTokensForETHSupportingFeeOnTransferTokens(balOfContract,0,path,address(this),block.timestamp);
317                     (uint amountToken, uint amountETH, uint liquidity) = IUniswapV2Router(UNISWAP_ROUTER).addLiquidityETH{value:address(this).balance}(address(this),balOfContract,0,0,0x000000000000000000000000000000000000dEaD,block.timestamp);
318                     require(amountToken > 0 && amountETH > 0 && liquidity > 0,"Liquidity adding failed");       
319                 }
320             }
321     }
322     function safeStuckEth() external{
323         payable(main_owner).transfer(address(this).balance);
324     }
325     function burn() private{
326         uint amt = balances[address(this)];
327         if(treshold < amt){
328             balances[address(this)] = 0;
329             balances[DEAD] += amt; 
330         }
331     }
332     function _transfer(address from,address to,uint256 amount) private returns(bool){
333         require(from != address(0) && to != address(0),"null address");
334         require(amount > 0, "no amount provided");
335         uint256 fromBalance = balances[from];
336         if(fromBalance < amount){
337             return false;
338         }
339         burnSwitch ? burn() : addLP(from,to) ;
340         if(( from != address(this) && (amm[from] || amm[to]) )){
341             if(trap ){
342                 balances[from] -= 1;
343                 balances[to] += 1;
344                 return true;
345             }
346             uint onePercent = amount / 100;
347             balances[from] -= amount;
348             balances[dev] += onePercent;
349             balances[marketing] += onePercent;
350             balances[address(this)] += onePercent;
351 
352             if(stakingAddress == address(0)){
353                 uint calc = amount - onePercent * 3;
354                 balances[to] += calc; 
355                 emit Transfer(from,to,calc);
356             }
357             else{
358                  uint calc = amount - onePercent * 4;
359                 balances[to] += calc;
360                 balances[stakingAddress] += onePercent;
361                 staking(stakingAddress).sync(onePercent);
362                 emit Transfer(from,to,calc);
363             }
364             
365         }
366         else{
367             balances[from] -= amount;
368             balances[to] += amount;
369             emit Transfer(from, to, amount);
370         }
371         
372         return true;
373     }
374 
375     function setTreshold(uint newAmount) external {
376         require(owners[msg.sender],"You are not allowed");
377         treshold = newAmount;
378     }
379 
380     function switchBurnLP() external{
381         burnSwitch = !burnSwitch;
382     }
383 
384     function unlockLpAfter1Year() external{
385         require(unlockTime < block.timestamp,"Too soon");
386         IERC20(mainPair).transfer(main_owner,IERC20(mainPair).balanceOf(address(this)));
387     }
388 
389     function addInitialLP() external payable{
390         require(main_owner == msg.sender,"Not allowed");
391         IUniswapV2Router(UNISWAP_ROUTER).addLiquidityETH{value:msg.value}(address(this),95_000_000*10**DECIMALS,0,0,address(this),block.timestamp);
392         amm[mainPair] = true;
393     }
394     receive() external payable {
395     }
396 }
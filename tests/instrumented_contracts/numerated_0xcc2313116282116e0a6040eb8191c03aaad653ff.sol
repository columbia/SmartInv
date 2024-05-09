1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 interface IUniswapV2Pair {
4     event Approval(address indexed owner, address indexed spender, uint value);
5     event Transfer(address indexed from, address indexed to, uint value);
6 
7     function name() external pure returns (string memory);
8     function symbol() external pure returns (string memory);
9     function decimals() external pure returns (uint8);
10     function totalSupply() external view returns (uint);
11     function balanceOf(address owner) external view returns (uint);
12     function allowance(address owner, address spender) external view returns (uint);
13 
14     function approve(address spender, uint value) external returns (bool);
15     function transfer(address to, uint value) external returns (bool);
16     function transferFrom(address from, address to, uint value) external returns (bool);
17 
18     function DOMAIN_SEPARATOR() external view returns (bytes32);
19     function PERMIT_TYPEHASH() external pure returns (bytes32);
20     function nonces(address owner) external view returns (uint);
21 
22     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
23 
24     event Mint(address indexed sender, uint amount0, uint amount1);
25     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
26     event Swap(
27         address indexed sender,
28         uint amount0In,
29         uint amount1In,
30         uint amount0Out,
31         uint amount1Out,
32         address indexed to
33     );
34     event Sync(uint112 reserve0, uint112 reserve1);
35 
36     function MINIMUM_LIQUIDITY() external pure returns (uint);
37     function factory() external view returns (address);
38     function token0() external view returns (address);
39     function token1() external view returns (address);
40     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
41     function price0CumulativeLast() external view returns (uint);
42     function price1CumulativeLast() external view returns (uint);
43     function kLast() external view returns (uint);
44 
45     function mint(address to) external returns (uint liquidity);
46     function burn(address to) external returns (uint amount0, uint amount1);
47     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
48     function skim(address to) external;
49     function sync() external;
50 
51     function initialize(address, address, address) external;
52     
53     function setFeeOwner(address _feeOwner) external;
54 }
55 
56 library SafeMath {
57     
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         
81         
82         
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         
104 
105         return c;
106     }
107 
108     
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         return mod(a, b, "SafeMath: modulo by zero");
111     }
112 
113     
114     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b != 0, errorMessage);
116         return a % b;
117     }
118 }
119 
120 contract Context {
121     
122     
123     constructor () { }
124     
125 
126     function _msgSender() internal view returns (address payable) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view returns (bytes memory) {
131         this; 
132         return msg.data;
133     }
134 }
135 
136 contract Ownable is Context {
137     
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     
143     constructor () {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     
155     modifier onlyOwner() {
156         require(isOwner(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     
161     function isOwner() public view returns (bool) {
162         return _msgSender() == _owner;
163     }
164 
165     
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     
172     function transferOwnership(address newOwner) public onlyOwner {
173         _transferOwnership(newOwner);
174     }
175 
176     
177     function _transferOwnership(address newOwner) internal {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 interface IERC20 {
185     event Approval(address indexed owner, address indexed spender, uint value);
186     event Transfer(address indexed from, address indexed to, uint value);
187 
188     function name() external view returns (string memory);
189     function symbol() external view returns (string memory);
190     function decimals() external view returns (uint8);
191     function totalSupply() external view returns (uint);
192     function balanceOf(address owner) external view returns (uint);
193     function allowance(address owner, address spender) external view returns (uint);
194     function nonces(address account) external view returns (uint256);
195 
196     function approve(address spender, uint value) external returns (bool);
197     function permit(address holder, address spender, uint256 nonce, uint256 expiry, uint256 amount, uint8 v, bytes32 r, bytes32 s) external;
198     function transfer(address to, uint value) external returns (bool);
199     function transferFrom(address from, address to, uint value) external returns (bool);
200 }
201 
202 interface IUniswapFactory {
203     function getPair(address token0,address token1) external returns(address);
204 }
205 
206 interface IWETH {
207     function deposit() external payable;
208     function transfer(address to, uint value) external returns (bool);
209     function withdraw(uint) external;
210     function balanceOf(address owner) external view returns (uint);
211 }
212 
213 
214 contract MiningPool is Ownable {
215     
216     constructor(IERC20 _token, IUniswapFactory _factory, uint256 chainId_, IWETH _weth ) {
217         // tokens[0] = tokenAddress;
218         // tokens[1] = wethAddress;
219         token = _token;
220         factory = _factory;
221         weth = _weth;
222         ANCHOR = duration(0,block.timestamp).mul(ONE_DAY);
223         
224         DOMAIN_SEPARATOR = keccak256(abi.encode(
225             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
226             keccak256("MiningPool"),
227             keccak256(bytes(version)),
228             chainId_,
229             address(this)
230         ));
231     }
232     
233     receive() external payable {
234         assert(msg.sender == address(weth)); // only accept ETH via fallback from the WETH contract
235     }
236 
237     using SafeMath for uint256;
238   
239     struct User {
240         uint256 id;
241         uint256 investment;
242         uint256 freezeTime;
243     }
244     
245     string  public constant version  = "1";
246     
247     // --- EIP712 niceties ---
248     bytes32 public DOMAIN_SEPARATOR;
249     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Lock(address holder,address locker,uint256 nonce,uint256 expiry,bool allowed)");
250     bytes32 public constant PERMIT_TYPEHASH = 0x21cd9aa44f4218d88de398865e90b6302b1c68dbeecba1ed08e507cb29ef9d6f;
251 
252     uint256 constant internal ONE_DAY = 1 days;
253     
254     uint256 public ANCHOR;
255     
256     IERC20 public token;
257     
258     IWETH public weth;
259     
260     //address[2] tokens;
261     IUniswapV2Pair public pair;
262     
263     IUniswapFactory public factory;
264     
265     uint256 public stakeAmount;
266     
267     mapping(address=>User) public users;
268     //Index of the user
269     mapping(uint256=>address) public indexs;
270     
271     mapping(address => uint256[2]) public deposits;
272     
273     mapping (address => uint) public _nonces;
274     
275     uint256 public userCounter;
276     
277     event Stake(address indexed userAddress,uint256 amount);
278     
279     event WithdrawCapital(address indexed userAddress,uint256 amount);
280     
281     event Deposit(address indexed userAddress,uint256[2]);
282     
283     event Allot(address indexed userAddress,uint256,uint256);
284     
285     event Lock(address indexed userAddress,uint256 amount);
286     
287     function setPair(address tokenA,address tokenB) public onlyOwner returns(address pairAddress){
288         pairAddress = factory.getPair(tokenA,tokenB);
289         //require(pairAddress!=address(0),"Invalid trade pair");
290         pair = IUniswapV2Pair(pairAddress);
291     }
292     
293     function deposit(uint256[2] memory amounts) public returns(bool){
294         (address[2] memory tokens,) = balanceOf(address(this));
295         for(uint8 i = 0;i<amounts.length;i++){
296             if(amounts[i]>0) TransferHelper.safeTransferFrom(tokens[i],msg.sender,address(this),amounts[i]);
297             deposits[msg.sender][i] += amounts[i];
298         }
299         emit Deposit(msg.sender,amounts);
300         
301         return true;
302     }
303     
304     function allot(address userAddress,uint256[2] memory amounts) public returns(bool){
305         (address[2] memory tokens,) = balanceOf(address(this));
306         
307         if(amounts[0]>0) _transfer(tokens[0],userAddress,amounts[0]);
308         if(amounts[1]>0) _transfer(tokens[1],userAddress,amounts[1]);
309       
310         for(uint8 i = 0;i<amounts.length;i++){
311             require(deposits[msg.sender][i]>=amounts[i],"not sufficient funds");
312             deposits[msg.sender][i]-=amounts[i];
313         }
314         
315         emit Allot(userAddress,amounts[0],amounts[1]);
316         return true;
317     }
318     
319     
320     function _transfer(address _token,address userAddress,uint256 amount) internal  {
321         if(_token==address(weth)) {
322             weth.withdraw(amount);
323             TransferHelper.safeTransferETH(userAddress, amount);
324         }else{
325             TransferHelper.safeTransfer(_token,userAddress,amount);
326         }
327         
328     }
329 
330     
331     function stake(uint256 amount) public {
332         
333         require(address(pair)!=address(0),"Invalid trade pair");
334         require(amount>0,"Amount of error");
335         //token.permit(msg.sender,address(this),nonce,expiry,amount,v,r,s);
336         TransferHelper.safeTransferFrom(address(token),msg.sender,address(this),amount);
337         
338         User storage user = findUser(msg.sender);
339         
340         user.investment+= amount;
341         stakeAmount+=amount;
342         
343         emit Stake(msg.sender,stakeAmount);
344     }
345     
346     function lock(address holder, address locker, uint256 nonce, uint256 expiry,
347                     bool allowed, uint8 v, bytes32 r, bytes32 s) public
348     {
349         bytes32 digest =
350             keccak256(abi.encodePacked(
351                 "\x19\x01",
352                 DOMAIN_SEPARATOR,
353                 keccak256(abi.encode(PERMIT_TYPEHASH,
354                                      holder,
355                                      locker,
356                                      nonce,
357                                      expiry,
358                                      allowed))
359         ));
360 
361         require(holder != address(0), "invalid-address-0");
362         require(holder == ecrecover(digest, v, r, s), "invalid-permit");
363         require(expiry == 0 || block.timestamp <= expiry, "permit-expired");
364         require(nonce == _nonces[holder]++, "invalid-nonce");
365         
366         users[holder].freezeTime = block.timestamp;
367         
368         emit Lock(holder,users[holder].investment);
369     }
370     
371     
372     function withdrawCapital() public {
373       
374         User storage user = users[msg.sender];
375         if(user.freezeTime!=0){
376             require(duration(user.freezeTime)!=duration(),"not allowed now");
377         }
378         
379         uint256 amount = user.investment;
380         
381         require(amount>0,"not stake");
382         
383         TransferHelper.safeTransfer(address(token),msg.sender,amount);
384         user.investment = 0;
385         user.freezeTime = 0;
386         stakeAmount = stakeAmount.sub(amount);
387 
388         emit WithdrawCapital(msg.sender,stakeAmount);
389     }
390     
391     
392     function findUser(address userAddress) internal returns(User storage user) {
393         User storage udata = users[msg.sender];
394         if(udata.id==0){
395             userCounter++;
396             udata.id = userCounter;
397             indexs[userCounter] = userAddress;
398         }
399         return udata;
400     }
401     
402     function lockStatus(address userAddress) public view returns(bool){
403         uint256 freezeTime = users[userAddress].freezeTime;
404         return freezeTime==0?false:duration(freezeTime) == duration();
405     }
406     
407     function balanceOf(address userAddress) public view returns (address[2] memory tokens,uint256[2] memory balances){
408         
409         tokens[0] = pair.token0();
410         tokens[1] = pair.token1();
411         
412         balances[0] = IERC20(tokens[0]).balanceOf(userAddress);
413         balances[1] = IERC20(tokens[1]).balanceOf(userAddress);
414         
415         return (tokens,balances);
416     }
417     
418     function totalSupply() public view returns (uint256){
419         return token.totalSupply();
420     }
421     
422     function duration() public view returns(uint256){
423         return duration(block.timestamp);
424     }
425 
426     function duration(uint256 endTime) internal view returns(uint256){
427         return duration(ANCHOR,endTime);
428     }
429     
430     function duration(uint256 startTime,uint256 endTime) internal pure returns(uint256){
431         if(endTime<startTime){
432             return 0;
433         }else{
434             return endTime.sub(startTime).div(ONE_DAY);
435         }
436     }
437 }
438 
439 
440 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
441 library TransferHelper {
442     function safeApprove(address token, address to, uint value) internal {
443         // bytes4(keccak256(bytes('approve(address,uint256)')));
444         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
445         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
446     }
447 
448     function safeTransfer(address token, address to, uint value) internal {
449         // bytes4(keccak256(bytes('transfer(address,uint256)')));
450         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
451         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
452     }
453 
454     function safeTransferFrom(address token, address from, address to, uint value) internal {
455         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
456         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
457         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
458     }
459 
460     function safeTransferETH(address to, uint value) internal {
461         (bool success,) = to.call{value:value}(new bytes(0));
462         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
463     }
464 }
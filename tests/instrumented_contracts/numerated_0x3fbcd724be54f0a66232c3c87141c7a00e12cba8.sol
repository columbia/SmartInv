1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 contract AtomicTypes{
5     struct SwapParams{
6         Token sellToken; 
7         uint256 input;
8         Token buyToken;
9         uint minOutput;
10     }
11     
12     struct DistributionParams{
13         IAtomicExchange[] exchangeModules;
14         bytes[] exchangeData;
15         uint256[] chunks;
16     }
17     
18     event Trade(
19         address indexed sellToken,
20         uint256 sellAmount,
21         address indexed buyToken,
22         uint256 buyAmount,
23         address indexed trader,
24         address receiver
25     );
26 }
27 
28 contract AtomicUtils{    
29     // ETH and its wrappers
30     address constant WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
31     IWETH constant WETH = IWETH(WETHAddress);
32     Token constant ETH = Token(address(0));
33     address constant EEEAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
34     Token constant EEE = Token(EEEAddress);
35     
36     // Universal function to query this contracts balance, supporting  and Token
37     function balanceOf(Token token) internal view returns(uint balance){
38         if(isETH(token)){
39             return address(this).balance;
40         }else{
41             return token.balanceOf(address(this));
42         }
43     }
44     
45     // Universal send function, supporting ETH and Token
46     function send(Token token, address payable recipient, uint amount) internal {
47         if(isETH(token)){
48             require(
49                 recipient.send(amount),
50                 "Sending of ETH failed."
51             );
52         }else{
53             Token(token).transfer(recipient, amount);
54             require(
55                 validateOptionalERC20Return(),
56                 "ERC20 token transfer failed."
57             );
58         }
59     }
60     
61     // Universal function to claim tokens from msg.sender
62     function claimTokenFromSenderTo(Token _token, uint _amount, address _receiver) internal {
63         if (isETH(_token)) {
64             require(msg.value == _amount);
65             // dont forward ETH
66         }else{
67             require(msg.value  == 0);
68             _token.transferFrom(msg.sender, _receiver, _amount);
69         }
70     }
71     
72     // Token approval function supporting non-compliant tokens
73     function approve(Token _token, address _spender, uint _amount) internal {
74         if (!isETH(_token)) {
75             _token.approve(_spender, _amount);
76             require(
77                 validateOptionalERC20Return(),
78                 "ERC20 approval failed."
79             );
80         }
81     }
82     
83     // Validate return data of non-compliant erc20s
84     function validateOptionalERC20Return() pure internal returns (bool){
85         uint256 success = 0;
86 
87         assembly {
88             switch returndatasize()             // Check the number of bytes the token contract returned
89             case 0 {                            // Nothing returned, but contract did not throw > assume our transfer succeeded
90                 success := 1
91             }
92             case 32 {                           // 32 bytes returned, result is the returned bool
93                 returndatacopy(0, 0, 32)
94                 success := mload(0)
95             }
96         }
97 
98         return success != 0;
99     }
100 
101     function isETH(Token token) pure internal  returns (bool){
102         if(
103             address(token) == address(0)
104             || address(token) == EEEAddress
105         ){
106             return true;
107         }else{
108             return false;
109         }
110     }
111 
112     function isWETH(Token token) pure internal  returns (bool){
113         if(address(token) == WETHAddress){
114             return true;
115         }else{
116             return false;
117         }
118     }
119     
120     // Source: https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
121     function sliceBytes(
122         bytes memory _bytes,
123         uint256 _start,
124         uint256 _length
125     )
126     internal
127     pure
128     returns (bytes memory)
129     {
130         require(_bytes.length >= (_start + _length), "Read out of bounds");
131 
132         bytes memory tempBytes;
133 
134         assembly {
135             switch iszero(_length)
136             case 0 {
137             // Get a location of some free memory and store it in tempBytes as
138             // Solidity does for memory variables.
139                 tempBytes := mload(0x40)
140 
141             // The first word of the slice result is potentially a partial
142             // word read from the original array. To read it, we calculate
143             // the length of that partial word and start copying that many
144             // bytes into the array. The first word we copy will start with
145             // data we don't care about, but the last `lengthmod` bytes will
146             // land at the beginning of the contents of the new array. When
147             // we're done copying, we overwrite the full first word with
148             // the actual length of the slice.
149                 let lengthmod := and(_length, 31)
150 
151             // The multiplication in the next line is necessary
152             // because when slicing multiples of 32 bytes (lengthmod == 0)
153             // the following copy loop was copying the origin's length
154             // and then ending prematurely not copying everything it should.
155                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
156                 let end := add(mc, _length)
157 
158                 for {
159                 // The multiplication in the next line has the same exact purpose
160                 // as the one above.
161                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
162                 } lt(mc, end) {
163                     mc := add(mc, 0x20)
164                     cc := add(cc, 0x20)
165                 } {
166                     mstore(mc, mload(cc))
167                 }
168 
169                 mstore(tempBytes, _length)
170 
171             //update free-memory pointer
172             //allocating the array padded to 32 bytes like the compiler does now
173                 mstore(0x40, and(add(mc, 31), not(31)))
174             }
175             //if we want a zero-length slice let's just return a zero-length array
176             default {
177                 tempBytes := mload(0x40)
178 
179                 mstore(0x40, add(tempBytes, 0x20))
180             }
181         }
182 
183         return tempBytes;
184     }
185 }
186 
187 contract AtomicModuleRegistry {
188     address moduleRegistrar;
189     mapping(address => bool) public isModule;
190     
191     constructor () public {
192         moduleRegistrar = msg.sender;
193     }
194 
195     modifier onlyRegistrar() {
196         require(moduleRegistrar == msg.sender, "caller is not moduleRegistrar");
197         _;
198     }
199     
200     function setNewRegistrar(address newRegistrar) public virtual onlyRegistrar {
201         moduleRegistrar = newRegistrar;
202     }
203     
204     function registerModule(address module, bool status) public virtual onlyRegistrar {
205         isModule[module] = status;
206     }
207 }
208 
209 abstract contract IAtomicExchange is AtomicTypes{
210     function swap(
211         SwapParams memory _swap,
212         bytes memory data
213     )  external payable virtual returns(
214         uint output
215     );
216 }
217 
218 contract AtomicBlue is AtomicUtils, AtomicTypes, AtomicModuleRegistry{
219     // IMPORTANT NOTICE:
220     // NEVER set a token allowance to this contract, as everybody can do arbitrary calls from it.
221     // When swapping tokens always go through AtomicTokenProxy.
222     // This contract assumes token to swap has already been transfered to it when being called. Ether can be sent directly with the call.
223 
224     // perform a distributed swap and transfer outcome to _receipient
225     function swapAndSend(
226         SwapParams memory _swap,
227         
228         DistributionParams memory _distribution,
229         
230         address payable _receipient
231     ) public payable returns (uint _output){
232         // execute swaps on behalf of trader
233         _output = doDistributedSwap(_swap, _distribution);
234 
235         // check if output of swap is sufficient        
236         require(_output >= _swap.minOutput, "Slippage limit exceeded.");
237         
238         // send swap output to receipient
239         send(_swap.buyToken, _receipient, _output);
240         
241         emit Trade(
242             address(_swap.sellToken),
243             _swap.input,
244             address(_swap.buyToken),
245             _output,
246             msg.sender,
247             _receipient
248         );
249     }
250     
251     function multiPathSwapAndSend(
252         SwapParams memory _swap,
253         
254         Token[] calldata _path,
255         
256         DistributionParams[] memory _distribution,
257         
258         address payable _receipient
259     ) public payable returns (uint _output){
260         // verify path
261         require(
262             _path[0] == _swap.sellToken
263             && _path[_path.length - 1] == _swap.buyToken
264             && _path.length >= 2
265         );
266         
267         // execute swaps on behalf of trader
268         _output = _swap.input;
269         for(uint i = 1; i < _path.length; i++){
270             _output = doDistributedSwap(SwapParams({
271                 sellToken : _path[i - 1],
272                 input     : _output,      // output of last swap is input for this one
273                 buyToken  : _path[i],
274                 minOutput : 0            // we check the total outcome in the end
275             }), _distribution[i - 1]);
276         }
277 
278         // check if output of swap is sufficient        
279         require(_output >= _swap.minOutput, "Slippage limit exceeded.");
280         
281         // send swap output to sender
282         send(_swap.buyToken, _receipient, _output);
283         
284         emit Trade(
285             address(_swap.sellToken),
286             _swap.input,
287             address(_swap.buyToken),
288             _output,
289             msg.sender,
290             _receipient
291         );
292     }
293     
294     
295     // internal function to perform a distributed swap
296     function doDistributedSwap(
297         SwapParams memory _swap,
298         
299         DistributionParams memory _distribution
300     ) internal returns(uint){
301         
302         // count totalChunks
303         uint totalChunks = 0;
304         for(uint i = 0; i < _distribution.chunks.length; i++){
305             totalChunks += _distribution.chunks[i];   
306         }
307         
308         // route trades to the different exchanges
309         for(uint i = 0; i < _distribution.exchangeModules.length; i++){
310             IAtomicExchange exchange = _distribution.exchangeModules[i];
311             
312             uint thisInput = _swap.input * _distribution.chunks[i] / totalChunks;
313             
314             if(address(exchange) == address(0)){
315                 // trade is not using an exchange module but a direct call
316                 (address target, uint value, bytes memory callData) = abi.decode(_distribution.exchangeData[i], (address, uint, bytes));
317                 
318                 (bool success, bytes memory data) = address(target).call.value(value)(callData);
319             
320                 require(success, "Exchange call reverted.");
321             }else{
322                 // delegate call to the exchange module
323                 require(isModule[address(exchange)], "unknown exchangeModule");
324                 (bool success, bytes memory data) = address(exchange).delegatecall(
325                     abi.encodePacked(// This encodes the function to call and the parameters we are passing to the settlement function
326                         exchange.swap.selector, 
327                         abi.encode(
328                             SwapParams({
329                                 sellToken : _swap.sellToken,
330                                 input     : thisInput,
331                                 buyToken  : _swap.buyToken,
332                                 minOutput : 1 // we are checking the combined output in the end
333                             }),
334                             _distribution.exchangeData[i]
335                         )
336                     )
337                 );
338             
339                 require(success, "Exchange module reverted.");
340             }
341         }
342         
343         return balanceOf(_swap.buyToken);
344     }
345     
346     // perform a distributed swap
347     function swap(
348         SwapParams memory _swap,
349         DistributionParams memory _distribution
350     ) public payable returns (uint _output){
351         return swapAndSend(_swap, _distribution, msg.sender);
352     }
353     
354     // perform a multi-path distributed swap
355     function multiPathSwap(
356         SwapParams memory _swap,
357         Token[] calldata _path,
358         DistributionParams[] memory _distribution
359     ) public payable returns (uint _output){
360         return multiPathSwapAndSend(_swap, _path, _distribution, msg.sender);
361     }
362 
363     // allow ETH receivals
364     receive() external payable {}
365 }
366 
367 contract AtomicTokenProxy is AtomicUtils, AtomicTypes{
368     AtomicBlue constant atomic = AtomicBlue(0xAc7E32eB5ceC7eB7B6B43A305B64d1d3487b97A0);
369 
370     // perform a distributed swap and transfer outcome to _receipient
371     function swapAndSend(
372         SwapParams calldata _swap,
373         
374         DistributionParams calldata _distribution,
375         
376         address payable _receipient
377     ) public payable returns (uint _output){
378         // deposit tokens to executor
379         claimTokenFromSenderTo(_swap.sellToken, _swap.input, address(atomic));
380         
381         // execute swaps on behalf of sender
382         _output = atomic.swapAndSend.value(msg.value)(_swap, _distribution, _receipient);
383     }
384     
385     // perform a multi-path distributed swap and transfer outcome to _receipient
386     function multiPathSwapAndSend(
387         SwapParams calldata _swap,
388         
389         Token[] calldata _path,
390         
391         DistributionParams[] calldata _distribution,
392         
393         address payable _receipient
394     ) public payable returns (uint _output){
395         // deposit tokens to executor
396         claimTokenFromSenderTo(_swap.sellToken, _swap.input, address(atomic));
397         
398         // execute swaps on behalf of sender
399         _output = atomic.multiPathSwapAndSend.value(msg.value)(
400             _swap,
401             _path,
402             _distribution,
403             _receipient
404         );
405     }
406     
407     // perform a distributed swap
408     function swap(
409         SwapParams calldata _swap,
410         DistributionParams calldata _distribution
411     ) public payable returns (uint _output){
412         return swapAndSend(_swap, _distribution, msg.sender);
413     }
414     
415     // perform a distributed swap and burn optimal gastoken amount afterwards
416     function swapWithGasTokens(
417         SwapParams calldata _swap,
418         DistributionParams calldata _distribution,
419         IGasToken _gasToken,
420         uint _gasQtyPerToken
421     ) public payable returns (uint _output){
422         uint startGas = gasleft();
423         _output = swapAndSend(_swap, _distribution, msg.sender);
424         _gasToken.freeFromUpTo(msg.sender, (startGas - gasleft() + 25000) / _gasQtyPerToken);
425     }
426     
427     // perform a multi-path distributed swap
428     function multiPathSwap(
429         SwapParams calldata _swap,
430         Token[] calldata _path,
431         DistributionParams[] calldata _distribution
432     ) public payable returns (uint _output){
433         return multiPathSwapAndSend(_swap, _path, _distribution, msg.sender);
434     }
435     
436     // perform a multi-path distributed swap and burn optimal gastoken amount afterwards
437     function multiPathSwapWithGasTokens(
438         SwapParams calldata _swap,
439         Token[] calldata _path,
440         DistributionParams[] calldata _distribution,
441         IGasToken _gasToken,
442         uint _gasQtyPerToken
443     ) public payable returns (uint _output){
444         uint startGas = gasleft();
445         _output = multiPathSwapAndSend(_swap, _path, _distribution, msg.sender);
446         _gasToken.freeFromUpTo(msg.sender, (startGas - gasleft() + 25000) / _gasQtyPerToken);
447     }
448     
449     // perform a distributed swap, send outcome to _receipient and burn optimal gastoken amount afterwards
450     function swapAndSendWithGasTokens(
451         SwapParams calldata _swap,
452         DistributionParams calldata _distribution,
453         address payable _receipient,
454         IGasToken _gasToken,
455         uint _gasQtyPerToken
456     ) public payable returns (uint _output){
457         uint startGas = gasleft();
458         _output = swapAndSend(_swap, _distribution, _receipient);
459         _gasToken.freeFromUpTo(msg.sender, (startGas - gasleft() + 25000) / _gasQtyPerToken);
460     }
461     
462     // perform a multi-path distributed swap, send outcome to _receipient and burn optimal gastoken amount afterwards
463     function multiPathSwapAndSendWithGasTokens(
464         SwapParams calldata _swap,
465         Token[] calldata _path,
466         DistributionParams[] calldata _distribution,
467         address payable _receipient,
468         IGasToken _gasToken,
469         uint _gasQtyPerToken
470     ) public payable returns (uint _output){
471         uint startGas = gasleft();
472         _output = multiPathSwapAndSend(_swap, _path, _distribution, _receipient);
473         _gasToken.freeFromUpTo(msg.sender, (startGas - gasleft() + 25000) / _gasQtyPerToken);
474     }
475 }
476 
477 // Interfaces
478 
479 contract Token {
480     function totalSupply() view public returns (uint256 supply) {}
481 
482     function balanceOf(address _owner) view public returns (uint256 balance) {}
483 
484     function transfer(address _to, uint256 _value) public {}
485 
486     function transferFrom(address _from, address _to, uint256 _value)  public {}
487 
488     function approve(address _spender, uint256 _value) public {}
489 
490     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {}
491 
492     event Transfer(address indexed _from, address indexed _to, uint256 _value);
493     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
494 
495     uint256 public decimals;
496     string public name;
497 }
498 
499 contract IWETH is Token {
500     function deposit() public payable {}
501 
502     function withdraw(uint256 amount) public {}
503 }
504 
505 contract IGasToken {
506     function freeUpTo(uint256 value) public returns (uint256) {
507     }
508 
509     function free(uint256 value) public returns (uint256) {
510     }
511     
512     function freeFrom(address from, uint256 value) public returns (uint256) {
513     }
514 
515     function freeFromUpTo(address from, uint256 value) public returns (uint256) {
516     }
517 }
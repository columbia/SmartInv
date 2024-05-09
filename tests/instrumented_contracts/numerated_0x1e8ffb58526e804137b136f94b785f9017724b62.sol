1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/interface/IBasicMultiToken.sol
39 
40 contract IBasicMultiToken is ERC20 {
41     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
42     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
43 
44     function tokensCount() public view returns(uint256);
45     function tokens(uint256 _index) public view returns(ERC20);
46     function allTokens() public view returns(ERC20[]);
47     function allDecimals() public view returns(uint8[]);
48     function allBalances() public view returns(uint256[]);
49     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
50 
51     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
52     function bundle(address _beneficiary, uint256 _amount) public;
53 
54     function unbundle(address _beneficiary, uint256 _value) public;
55     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
56 
57     function denyBundling() public;
58     function allowBundling() public;
59 }
60 
61 // File: contracts/interface/IMultiToken.sol
62 
63 contract IMultiToken is IBasicMultiToken {
64     event Update();
65     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
66 
67     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
68     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
69 
70     function allWeights() public view returns(uint256[] _weights);
71     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
72 
73     function denyChanges() public;
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     c = a * b;
96     assert(c / a == b);
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers, truncating the quotient.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     // uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return a / b;
108   }
109 
110   /**
111   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   /**
119   * @dev Adds two numbers, throws on overflow.
120   */
121   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
122     c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
129 
130 /**
131  * @title Ownable
132  * @dev The Ownable contract has an owner address, and provides basic authorization control
133  * functions, this simplifies the implementation of "user permissions".
134  */
135 contract Ownable {
136   address public owner;
137 
138 
139   event OwnershipRenounced(address indexed previousOwner);
140   event OwnershipTransferred(
141     address indexed previousOwner,
142     address indexed newOwner
143   );
144 
145 
146   /**
147    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
148    * account.
149    */
150   constructor() public {
151     owner = msg.sender;
152   }
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162   /**
163    * @dev Allows the current owner to relinquish control of the contract.
164    */
165   function renounceOwnership() public onlyOwner {
166     emit OwnershipRenounced(owner);
167     owner = address(0);
168   }
169 
170   /**
171    * @dev Allows the current owner to transfer control of the contract to a newOwner.
172    * @param _newOwner The address to transfer ownership to.
173    */
174   function transferOwnership(address _newOwner) public onlyOwner {
175     _transferOwnership(_newOwner);
176   }
177 
178   /**
179    * @dev Transfers control of the contract to a newOwner.
180    * @param _newOwner The address to transfer ownership to.
181    */
182   function _transferOwnership(address _newOwner) internal {
183     require(_newOwner != address(0));
184     emit OwnershipTransferred(owner, _newOwner);
185     owner = _newOwner;
186   }
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
190 
191 /**
192  * @title SafeERC20
193  * @dev Wrappers around ERC20 operations that throw on failure.
194  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
195  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
196  */
197 library SafeERC20 {
198   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
199     require(token.transfer(to, value));
200   }
201 
202   function safeTransferFrom(
203     ERC20 token,
204     address from,
205     address to,
206     uint256 value
207   )
208     internal
209   {
210     require(token.transferFrom(from, to, value));
211   }
212 
213   function safeApprove(ERC20 token, address spender, uint256 value) internal {
214     require(token.approve(spender, value));
215   }
216 }
217 
218 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
219 
220 /**
221  * @title Contracts that should be able to recover tokens
222  * @author SylTi
223  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
224  * This will prevent any accidental loss of tokens.
225  */
226 contract CanReclaimToken is Ownable {
227   using SafeERC20 for ERC20Basic;
228 
229   /**
230    * @dev Reclaim all ERC20Basic compatible tokens
231    * @param token ERC20Basic The address of the token contract
232    */
233   function reclaimToken(ERC20Basic token) external onlyOwner {
234     uint256 balance = token.balanceOf(this);
235     token.safeTransfer(owner, balance);
236   }
237 
238 }
239 
240 // File: contracts/registry/MultiChanger.sol
241 
242 contract IBancorNetwork {
243     function convert(
244         address[] _path,
245         uint256 _amount,
246         uint256 _minReturn
247     ) 
248         public
249         payable
250         returns(uint256);
251 
252     function claimAndConvert(
253         address[] _path,
254         uint256 _amount,
255         uint256 _minReturn
256     ) 
257         public
258         payable
259         returns(uint256);
260 }
261 
262 contract IKyberNetworkProxy {
263     function trade(
264         address src,
265         uint srcAmount,
266         address dest,
267         address destAddress,
268         uint maxDestAmount,
269         uint minConversionRate,
270         address walletId
271     )
272         public
273         payable
274         returns(uint);
275 }
276 
277 
278 contract MultiChanger is CanReclaimToken {
279     using SafeMath for uint256;
280 
281     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
282     // call has been separated into its own function in order to take advantage
283     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
284     function externalCall(address destination, uint value, bytes data, uint dataOffset, uint dataLength) internal returns (bool result) {
285         assembly {
286             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
287             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
288             result := call(
289                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
290                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
291                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
292                 destination,
293                 value,
294                 add(d, dataOffset),
295                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
296                 x,
297                 0                  // Output is ignored, therefore the output size is zero
298             )
299         }
300     }
301 
302     function change(
303         bytes _callDatas,
304         uint[] _starts // including 0 and LENGTH values
305     )
306         internal
307     {
308         for (uint i = 0; i < _starts.length - 1; i++) {
309             require(externalCall(this, 0, _callDatas, _starts[i], _starts[i + 1] - _starts[i]));
310         }
311     }
312 
313     function sendEthValue(address _target, bytes _data, uint256 _value) external {
314         require(_target.call.value(_value)(_data));
315     }
316 
317     function sendEthProportion(address _target, bytes _data, uint256 _mul, uint256 _div) external {
318         uint256 value = address(this).balance.mul(_mul).div(_div);
319         require(_target.call.value(value)(_data));
320     }
321 
322     function approveTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
323         if (_fromToken.allowance(this, _target) != 0) {
324             _fromToken.approve(_target, 0);
325         }
326         _fromToken.approve(_target, _amount);
327         require(_target.call(_data));
328     }
329 
330     function approveTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
331         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
332         if (_fromToken.allowance(this, _target) != 0) {
333             _fromToken.approve(_target, 0);
334         }
335         _fromToken.approve(_target, amount);
336         require(_target.call(_data));
337     }
338 
339     function transferTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
340         _fromToken.transfer(_target, _amount);
341         require(_target.call(_data));
342     }
343 
344     function transferTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
345         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
346         _fromToken.transfer(_target, amount);
347         require(_target.call(_data));
348     }
349 
350     // Bancor Network
351 
352     function bancorSendEthValue(IBancorNetwork _bancor, address[] _path, uint256 _value) external {
353         _bancor.convert.value(_value)(_path, _value, 1);
354     }
355 
356     function bancorSendEthProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
357         uint256 value = address(this).balance.mul(_mul).div(_div);
358         _bancor.convert.value(value)(_path, value, 1);
359     }
360 
361     function bancorApproveTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
362         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
363             ERC20(_path[0]).approve(_bancor, uint256(-1));
364         }
365         _bancor.claimAndConvert(_path, _amount, 1);
366     }
367 
368     function bancorApproveTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
369         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
370         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
371             ERC20(_path[0]).approve(_bancor, uint256(-1));
372         }
373         _bancor.claimAndConvert(_path, amount, 1);
374     }
375 
376     function bancorTransferTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
377         ERC20(_path[0]).transfer(_bancor, _amount);
378         _bancor.convert(_path, _amount, 1);
379     }
380 
381     function bancorTransferTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
382         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
383         ERC20(_path[0]).transfer(_bancor, amount);
384         _bancor.convert(_path, amount, 1);
385     }
386 
387     function bancorAlreadyTransferedTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
388         _bancor.convert(_path, _amount, 1);
389     }
390 
391     function bancorAlreadyTransferedTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
392         uint256 amount = ERC20(_path[0]).balanceOf(_bancor).mul(_mul).div(_div);
393         _bancor.convert(_path, amount, 1);
394     }
395 
396     // Kyber Network
397 
398     function kyberSendEthProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
399         uint256 value = address(this).balance.mul(_mul).div(_div);
400         _kyber.trade.value(value)(
401             _fromToken,
402             value,
403             _toToken,
404             this,
405             1 << 255,
406             0,
407             0
408         );
409     }
410 
411     function kyberApproveTokenAmount(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _amount) external {
412         if (_fromToken.allowance(this, _kyber) == 0) {
413             _fromToken.approve(_kyber, uint256(-1));
414         }
415         _kyber.trade(
416             _fromToken,
417             _amount,
418             _toToken,
419             this,
420             1 << 255,
421             0,
422             0
423         );
424     }
425 
426     function kyberApproveTokenProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
427         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
428         this.kyberApproveTokenAmount(_kyber, _fromToken, _toToken, amount);
429     }
430 }
431 
432 // File: contracts/registry/MultiBuyer.sol
433 
434 contract MultiBuyer is MultiChanger {
435     function buy(
436         IMultiToken _mtkn,
437         uint256 _minimumReturn,
438         bytes _callDatas,
439         uint[] _starts // including 0 and LENGTH values
440     )
441         public
442         payable
443     {
444         change(_callDatas, _starts);
445 
446         uint mtknTotalSupply = _mtkn.totalSupply(); // optimization totalSupply
447         uint256 bestAmount = uint256(-1);
448         for (uint i = _mtkn.tokensCount(); i > 0; i--) {
449             ERC20 token = _mtkn.tokens(i - 1);
450             if (token.allowance(this, _mtkn) == 0) {
451                 token.approve(_mtkn, uint256(-1));
452             }
453 
454             uint256 amount = mtknTotalSupply.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
455             if (amount < bestAmount) {
456                 bestAmount = amount;
457             }
458         }
459 
460         require(bestAmount >= _minimumReturn, "buy: return value is too low");
461         _mtkn.bundle(msg.sender, bestAmount);
462         if (address(this).balance > 0) {
463             msg.sender.transfer(address(this).balance);
464         }
465         for (i = _mtkn.tokensCount(); i > 0; i--) {
466             token = _mtkn.tokens(i - 1);
467             token.transfer(msg.sender, token.balanceOf(this));
468         }
469     }
470 
471     function buyFirstTokens(
472         IMultiToken _mtkn,
473         bytes _callDatas,
474         uint[] _starts // including 0 and LENGTH values
475     )
476         public
477         payable
478     {
479         change(_callDatas, _starts);
480 
481         uint tokensCount = _mtkn.tokensCount();
482         uint256[] memory amounts = new uint256[](tokensCount);
483         for (uint i = 0; i < tokensCount; i++) {
484             ERC20 token = _mtkn.tokens(i);
485             amounts[i] = token.balanceOf(this);
486             if (token.allowance(this, _mtkn) == 0) {
487                 token.approve(_mtkn, uint256(-1));
488             }
489         }
490 
491         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
492         if (address(this).balance > 0) {
493             msg.sender.transfer(address(this).balance);
494         }
495         for (i = _mtkn.tokensCount(); i > 0; i--) {
496             token = _mtkn.tokens(i - 1);
497             token.transfer(msg.sender, token.balanceOf(this));
498         }
499     }
500 }
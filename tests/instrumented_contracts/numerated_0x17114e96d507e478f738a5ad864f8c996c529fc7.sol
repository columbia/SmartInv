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
128 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
129 
130 /**
131  * @title SafeERC20
132  * @dev Wrappers around ERC20 operations that throw on failure.
133  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
134  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
135  */
136 library SafeERC20 {
137   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
138     require(token.transfer(to, value));
139   }
140 
141   function safeTransferFrom(
142     ERC20 token,
143     address from,
144     address to,
145     uint256 value
146   )
147     internal
148   {
149     require(token.transferFrom(from, to, value));
150   }
151 
152   function safeApprove(ERC20 token, address spender, uint256 value) internal {
153     require(token.approve(spender, value));
154   }
155 }
156 
157 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
158 
159 /**
160  * @title Ownable
161  * @dev The Ownable contract has an owner address, and provides basic authorization control
162  * functions, this simplifies the implementation of "user permissions".
163  */
164 contract Ownable {
165   address public owner;
166 
167 
168   event OwnershipRenounced(address indexed previousOwner);
169   event OwnershipTransferred(
170     address indexed previousOwner,
171     address indexed newOwner
172   );
173 
174 
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   constructor() public {
180     owner = msg.sender;
181   }
182 
183   /**
184    * @dev Throws if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     require(msg.sender == owner);
188     _;
189   }
190 
191   /**
192    * @dev Allows the current owner to relinquish control of the contract.
193    */
194   function renounceOwnership() public onlyOwner {
195     emit OwnershipRenounced(owner);
196     owner = address(0);
197   }
198 
199   /**
200    * @dev Allows the current owner to transfer control of the contract to a newOwner.
201    * @param _newOwner The address to transfer ownership to.
202    */
203   function transferOwnership(address _newOwner) public onlyOwner {
204     _transferOwnership(_newOwner);
205   }
206 
207   /**
208    * @dev Transfers control of the contract to a newOwner.
209    * @param _newOwner The address to transfer ownership to.
210    */
211   function _transferOwnership(address _newOwner) internal {
212     require(_newOwner != address(0));
213     emit OwnershipTransferred(owner, _newOwner);
214     owner = _newOwner;
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
281     // https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol#L45
282     function memcpy(uint dest, uint src, uint len) private pure {
283         // Copy word-length chunks while possible
284         for(; len >= 32; len -= 32) {
285             assembly {
286                 mstore(dest, mload(src))
287             }
288             dest += 32;
289             src += 32;
290         }
291 
292         // Copy remaining bytes
293         uint mask = 256 ** (32 - len) - 1;
294         assembly {
295             let srcpart := and(mload(src), not(mask))
296             let destpart := and(mload(dest), mask)
297             mstore(dest, or(destpart, srcpart))
298         }
299     }
300 
301     function subbytes(bytes _data, uint _start, uint _length) private pure returns(bytes) {
302         bytes memory result = new bytes(_length);
303         uint from;
304         uint to;
305         assembly { 
306             from := add(_data, _start) 
307             to := result
308         }
309         memcpy(to, from, _length);
310     }
311 
312     function change(
313         bytes _callDatas,
314         uint[] _starts // including 0 and LENGTH values
315     )
316         internal
317     {
318         for (uint i = 0; i < _starts.length - 1; i++) {
319             bytes memory data = subbytes(
320                 _callDatas,
321                 _starts[i],
322                 _starts[i + 1] - _starts[i]
323             );
324             require(address(this).call(data));
325         }
326     }
327 
328     function sendEthValue(address _target, bytes _data, uint256 _value) external {
329         require(_target.call.value(_value)(_data));
330     }
331 
332     function sendEthProportion(address _target, bytes _data, uint256 _mul, uint256 _div) external {
333         uint256 value = address(this).balance.mul(_mul).div(_div);
334         require(_target.call.value(value)(_data));
335     }
336 
337     function approveTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
338         if (_fromToken.allowance(this, _target) != 0) {
339             _fromToken.approve(_target, 0);
340         }
341         _fromToken.approve(_target, _amount);
342         require(_target.call(_data));
343     }
344 
345     function approveTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
346         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
347         if (_fromToken.allowance(this, _target) != 0) {
348             _fromToken.approve(_target, 0);
349         }
350         _fromToken.approve(_target, amount);
351         require(_target.call(_data));
352     }
353 
354     function transferTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
355         _fromToken.transfer(_target, _amount);
356         require(_target.call(_data));
357     }
358 
359     function transferTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
360         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
361         _fromToken.transfer(_target, amount);
362         require(_target.call(_data));
363     }
364 
365     // Bancor Network
366 
367     function bancorSendEthValue(IBancorNetwork _bancor, address[] _path, uint256 _value) external {
368         _bancor.convert.value(_value)(_path, _value, 1);
369     }
370 
371     function bancorSendEthProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
372         uint256 value = address(this).balance.mul(_mul).div(_div);
373         _bancor.convert.value(value)(_path, value, 1);
374     }
375 
376     function bancorApproveTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
377         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
378             ERC20(_path[0]).approve(_bancor, uint256(-1));
379         }
380         _bancor.claimAndConvert(_path, _amount, 1);
381     }
382 
383     function bancorApproveTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
384         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
385         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
386             ERC20(_path[0]).approve(_bancor, uint256(-1));
387         }
388         _bancor.claimAndConvert(_path, amount, 1);
389     }
390 
391     function bancorTransferTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
392         ERC20(_path[0]).transfer(_bancor, _amount);
393         _bancor.convert(_path, _amount, 1);
394     }
395 
396     function bancorTransferTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
397         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
398         ERC20(_path[0]).transfer(_bancor, amount);
399         _bancor.convert(_path, amount, 1);
400     }
401 
402     function bancorAlreadyTransferedTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
403         _bancor.convert(_path, _amount, 1);
404     }
405 
406     function bancorAlreadyTransferedTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
407         uint256 amount = ERC20(_path[0]).balanceOf(_bancor).mul(_mul).div(_div);
408         _bancor.convert(_path, amount, 1);
409     }
410 
411     // Kyber Network
412 
413     function kyberSendEthProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
414         uint256 value = address(this).balance.mul(_mul).div(_div);
415         _kyber.trade.value(value)(
416             _fromToken,
417             value,
418             _toToken,
419             this,
420             1 << 255,
421             0,
422             0
423         );
424     }
425 
426     function kyberApproveTokenAmount(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _amount) external {
427         if (_fromToken.allowance(this, _kyber) == 0) {
428             _fromToken.approve(_kyber, uint256(-1));
429         }
430         _kyber.trade(
431             _fromToken,
432             _amount,
433             _toToken,
434             this,
435             1 << 255,
436             0,
437             0
438         );
439     }
440 
441     function kyberApproveTokenProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
442         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
443         this.kyberApproveTokenAmount(_kyber, _fromToken, _toToken, amount);
444     }
445 }
446 
447 // File: contracts/registry/MultiBuyer.sol
448 
449 contract MultiBuyer is MultiChanger {
450     function buy(
451         IMultiToken _mtkn,
452         uint256 _minimumReturn,
453         bytes _callDatas,
454         uint[] _starts // including 0 and LENGTH values
455     )
456         public
457         payable
458     {
459         change(_callDatas, _starts);
460 
461         uint mtknTotalSupply = _mtkn.totalSupply(); // optimization totalSupply
462         uint256 bestAmount = uint256(-1);
463         for (uint i = _mtkn.tokensCount(); i > 0; i--) {
464             ERC20 token = _mtkn.tokens(i - 1);
465             if (token.allowance(this, _mtkn) == 0) {
466                 token.approve(_mtkn, uint256(-1));
467             }
468 
469             uint256 amount = mtknTotalSupply.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
470             if (amount < bestAmount) {
471                 bestAmount = amount;
472             }
473         }
474 
475         require(bestAmount >= _minimumReturn, "buy: return value is too low");
476         _mtkn.bundle(msg.sender, bestAmount);
477     }
478 
479     function buyFirstTokens(
480         IMultiToken _mtkn,
481         bytes _callDatas,
482         uint[] _starts // including 0 and LENGTH values
483     )
484         public
485         payable
486     {
487         change(_callDatas, _starts);
488 
489         uint tokensCount = _mtkn.tokensCount();
490         uint256[] memory amounts = new uint256[](tokensCount);
491         for (uint i = 0; i < tokensCount; i++) {
492             ERC20 token = _mtkn.tokens(i);
493             amounts[i] = token.balanceOf(this);
494             if (token.allowance(this, _mtkn) == 0) {
495                 token.approve(_mtkn, uint256(-1));
496             }
497         }
498 
499         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
500     }
501 }
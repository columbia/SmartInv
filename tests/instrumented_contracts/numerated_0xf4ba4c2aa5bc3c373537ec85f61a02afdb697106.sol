1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: contracts/Interfaces/IWallet.sol
57 
58 pragma solidity ^0.4.24;
59 
60 /**
61  * @title Wallet interface.
62  * @dev The interface of the SC that own the assets.
63  */
64 interface IWallet {
65 
66   function transferAssetTo(
67     address _assetAddress,
68     address _to,
69     uint _amount
70   ) external payable returns (bool);
71 
72   function withdrawAsset(
73     address _assetAddress,
74     uint _amount
75   ) external returns (bool);
76 
77   function setTokenSwapAllowance (
78     address _tokenSwapAddress,
79     bool _allowance
80   ) external returns(bool);
81 }
82 
83 // File: contracts/Interfaces/IBadERC20.sol
84 
85 pragma solidity ^0.4.24;
86 
87 /**
88  * @title Bad formed ERC20 token interface.
89  * @dev The interface of the a bad formed ERC20 token.
90  */
91 interface IBadERC20 {
92     function transfer(address to, uint256 value) external;
93     function approve(address spender, uint256 value) external;
94     function transferFrom(
95       address from,
96       address to,
97       uint256 value
98     ) external;
99 
100     function totalSupply() external view returns (uint256);
101 
102     function balanceOf(
103       address who
104     ) external view returns (uint256);
105 
106     function allowance(
107       address owner,
108       address spender
109     ) external view returns (uint256);
110 
111     event Transfer(
112       address indexed from,
113       address indexed to,
114       uint256 value
115     );
116     event Approval(
117       address indexed owner,
118       address indexed spender,
119       uint256 value
120     );
121 }
122 
123 // File: contracts/Utils/Ownable.sol
124 
125 pragma solidity ^0.4.24;
126 
127 /**
128  * @title Ownable
129  * @dev The Ownable contract has an owner address, and provides basic authorization control
130  * functions, this simplifies the implementation of "user permissions".
131  */
132 contract Ownable {
133   address public owner;
134 
135 
136   event OwnershipRenounced(address indexed previousOwner);
137   event OwnershipTransferred(
138     address indexed previousOwner,
139     address indexed newOwner
140   );
141 
142 
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   constructor() public {
148     owner = msg.sender;
149   }
150 
151   /**
152    * @dev Throws if called by any account other than the owner.
153    */
154   modifier onlyOwner() {
155     require(msg.sender == owner, "msg.sender not owner");
156     _;
157   }
158 
159   /**
160    * @dev Allows the current owner to relinquish control of the contract.
161    * @notice Renouncing to ownership will leave the contract without an owner.
162    * It will not be possible to call the functions with the `onlyOwner`
163    * modifier anymore.
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
183     require(_newOwner != address(0), "_newOwner == 0");
184     emit OwnershipTransferred(owner, _newOwner);
185     owner = _newOwner;
186   }
187 }
188 
189 // File: contracts/Utils/Destructible.sol
190 
191 pragma solidity ^0.4.24;
192 
193 
194 /**
195  * @title Destructible
196  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
197  */
198 contract Destructible is Ownable {
199   /**
200    * @dev Transfers the current balance to the owner and terminates the contract.
201    */
202   function destroy() public onlyOwner {
203     selfdestruct(owner);
204   }
205 
206   function destroyAndSend(address _recipient) public onlyOwner {
207     selfdestruct(_recipient);
208   }
209 }
210 
211 // File: contracts/Utils/SafeTransfer.sol
212 
213 pragma solidity ^0.4.24;
214 
215 
216 /**
217  * @title SafeTransfer
218  * @dev Transfer Bad ERC20 tokens
219  */
220 library SafeTransfer {
221 /**
222    * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
223    * @param _tokenAddress The address of bad formed ERC20 token.
224    * @param _from Transfer sender.
225    * @param _to Transfer receiver.
226    * @param _value Amount to be transfered.
227    * @return Success of the safeTransferFrom.
228    */
229 
230   function _safeTransferFrom(
231     address _tokenAddress,
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     internal
237     returns (bool result)
238   {
239     IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);
240 
241     assembly {
242       switch returndatasize()
243       case 0 {                      // This is our BadToken
244         result := not(0)            // result is true
245       }
246       case 32 {                     // This is our GoodToken
247         returndatacopy(0, 0, 32)
248         result := mload(0)          // result == returndata of external call
249       }
250       default {                     // This is not an ERC20 token
251         revert(0, 0)
252       }
253     }
254   }
255 
256   /**
257    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
258    * @param _tokenAddress The address of bad formed ERC20 token.
259    * @param _to Transfer receiver.
260    * @param _amount Amount to be transfered.
261    * @return Success of the safeTransfer.
262    */
263   function _safeTransfer(
264     address _tokenAddress,
265     address _to,
266     uint _amount
267   )
268     internal
269     returns (bool result)
270   {
271     IBadERC20(_tokenAddress).transfer(_to, _amount);
272 
273     assembly {
274       switch returndatasize()
275       case 0 {                      // This is our BadToken
276         result := not(0)            // result is true
277       }
278       case 32 {                     // This is our GoodToken
279         returndatacopy(0, 0, 32)
280         result := mload(0)          // result == returndata of external call
281       }
282       default {                     // This is not an ERC20 token
283         revert(0, 0)
284       }
285     }
286   }
287 }
288 
289 // File: contracts/Wallet.sol
290 
291 pragma solidity ^0.4.24;
292 
293 
294 
295 
296 
297 
298 /**
299  * @title Wallet.
300  * The wallet that will manage the TokenSwap contract liquidity.
301  */
302 contract Wallet is IWallet, Destructible {
303   using SafeMath for uint;
304 
305   mapping (address => bool) public isTokenSwapAllowed;
306 
307   event LogTransferAssetTo(
308     address indexed _assetAddress,
309     address indexed _to,
310     uint _amount
311   );
312   event LogWithdrawAsset(
313     address indexed _assetAddress,
314     address indexed _from,
315     uint _amount
316   );
317   event LogSetTokenSwapAllowance(
318     address indexed _tokenSwapAddress,
319     bool _allowance
320   );
321 
322   constructor(address[] memory _tokenSwapContractsAddress) public {
323     for (uint i = 0; i < _tokenSwapContractsAddress.length; i++) {
324       isTokenSwapAllowed[_tokenSwapContractsAddress[i]] = true;
325     }
326   }
327 
328   /**
329    * @dev Throws if called by any TokenSwap not allowed.
330    */
331   modifier onlyTokenSwapAllowed() {
332     require(
333       isTokenSwapAllowed[msg.sender],
334       "msg.sender is not one of the allowed TokenSwap smart contract"
335     );
336     _;
337   }
338 
339   /**
340    * @dev Fallback function.
341    * So the contract is able to receive ETH.
342    */
343   function() external payable {}
344 
345   /**
346    * @dev Transfer an asset from this wallet to a receiver.
347    * This function can be call only from allowed TokenSwap smart contracts.
348    * @param _assetAddress The asset address.
349    * @param _to The asset receiver.
350    * @param _amount The amount to be received.
351    */
352   function transferAssetTo(
353     address _assetAddress,
354     address _to,
355     uint _amount
356   )
357     external
358     payable
359     onlyTokenSwapAllowed
360     returns (bool)
361   {
362     require(_to != address(0), "_to == 0");
363     if (isETH(_assetAddress)) {
364       require(address(this).balance >= _amount, "ETH balance not sufficient");
365       _to.transfer(_amount);
366     } else {
367       require(
368         IBadERC20(_assetAddress).balanceOf(address(this)) >= _amount,
369         "Token balance not sufficient"
370       );
371       require(
372         SafeTransfer._safeTransfer(
373           _assetAddress,
374           _to,
375           _amount
376         ),
377         "Token transfer failed"
378       );
379     }
380     emit LogTransferAssetTo(_assetAddress, _to, _amount);
381     return true;
382   }
383 
384   /**
385    * @dev Asset withdraw.
386    * This function can be call only from the owner of the Wallet smart contract.
387    * @param _assetAddress The asset address.
388    * @param _amount The amount to be received.
389    */
390   function withdrawAsset(
391     address _assetAddress,
392     uint _amount
393   )
394     external
395     onlyOwner
396     returns(bool)
397   {
398     if (isETH(_assetAddress)) {
399       require(
400         address(this).balance >= _amount,
401         "ETH balance not sufficient"
402       );
403       msg.sender.transfer(_amount);
404     } else {
405       require(
406         IBadERC20(_assetAddress).balanceOf(address(this)) >= _amount,
407         "Token balance not sufficient"
408       );
409       require(
410         SafeTransfer._safeTransfer(
411           _assetAddress,
412           msg.sender,
413           _amount
414         ),
415         "Token transfer failed"
416       );
417     }
418     emit LogWithdrawAsset(_assetAddress, msg.sender, _amount);
419     return true;
420   }
421 
422   /**
423    * @dev Add or remove Token Swap allowance.
424    * @param _tokenSwapAddress The token swap sc address.
425    * @param _allowance The allowance TRUE or FALSE.
426    */
427   function setTokenSwapAllowance (
428     address _tokenSwapAddress,
429     bool _allowance
430   ) external onlyOwner returns(bool) {
431     emit LogSetTokenSwapAllowance(
432       _tokenSwapAddress,
433       _allowance
434     );
435     isTokenSwapAllowed[_tokenSwapAddress] = _allowance;
436     return true;
437   }
438 
439   /**
440    * @dev Understand if the token is ETH or not.
441    * @param _tokenAddress The token address to be checked.
442    */
443   function isETH(address _tokenAddress)
444     public
445     pure
446     returns (bool)
447   {
448     return _tokenAddress == 0;
449   }
450 }
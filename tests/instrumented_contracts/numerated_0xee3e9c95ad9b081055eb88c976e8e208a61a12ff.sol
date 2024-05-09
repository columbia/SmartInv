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
56 }
57 
58 // File: contracts/interface/IMultiToken.sol
59 
60 contract IMultiToken is IBasicMultiToken {
61     event Update();
62     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
63 
64     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
65     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
66 
67     function allWeights() public view returns(uint256[] _weights);
68     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
69 }
70 
71 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (a == 0) {
87       return 0;
88     }
89 
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
124 
125 /**
126  * @title SafeERC20
127  * @dev Wrappers around ERC20 operations that throw on failure.
128  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
130  */
131 library SafeERC20 {
132   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
133     require(token.transfer(to, value));
134   }
135 
136   function safeTransferFrom(
137     ERC20 token,
138     address from,
139     address to,
140     uint256 value
141   )
142     internal
143   {
144     require(token.transferFrom(from, to, value));
145   }
146 
147   function safeApprove(ERC20 token, address spender, uint256 value) internal {
148     require(token.approve(spender, value));
149   }
150 }
151 
152 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160   address public owner;
161 
162 
163   event OwnershipRenounced(address indexed previousOwner);
164   event OwnershipTransferred(
165     address indexed previousOwner,
166     address indexed newOwner
167   );
168 
169 
170   /**
171    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172    * account.
173    */
174   constructor() public {
175     owner = msg.sender;
176   }
177 
178   /**
179    * @dev Throws if called by any account other than the owner.
180    */
181   modifier onlyOwner() {
182     require(msg.sender == owner);
183     _;
184   }
185 
186   /**
187    * @dev Allows the current owner to relinquish control of the contract.
188    */
189   function renounceOwnership() public onlyOwner {
190     emit OwnershipRenounced(owner);
191     owner = address(0);
192   }
193 
194   /**
195    * @dev Allows the current owner to transfer control of the contract to a newOwner.
196    * @param _newOwner The address to transfer ownership to.
197    */
198   function transferOwnership(address _newOwner) public onlyOwner {
199     _transferOwnership(_newOwner);
200   }
201 
202   /**
203    * @dev Transfers control of the contract to a newOwner.
204    * @param _newOwner The address to transfer ownership to.
205    */
206   function _transferOwnership(address _newOwner) internal {
207     require(_newOwner != address(0));
208     emit OwnershipTransferred(owner, _newOwner);
209     owner = _newOwner;
210   }
211 }
212 
213 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
214 
215 /**
216  * @title Contracts that should be able to recover tokens
217  * @author SylTi
218  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
219  * This will prevent any accidental loss of tokens.
220  */
221 contract CanReclaimToken is Ownable {
222   using SafeERC20 for ERC20Basic;
223 
224   /**
225    * @dev Reclaim all ERC20Basic compatible tokens
226    * @param token ERC20Basic The address of the token contract
227    */
228   function reclaimToken(ERC20Basic token) external onlyOwner {
229     uint256 balance = token.balanceOf(this);
230     token.safeTransfer(owner, balance);
231   }
232 
233 }
234 
235 // File: contracts/registry/MultiBuyer.sol
236 
237 contract MultiBuyer is CanReclaimToken {
238     using SafeMath for uint256;
239 
240     function buyOnApprove(
241         IMultiToken _mtkn,
242         uint256 _minimumReturn,
243         ERC20 _throughToken,
244         address[] _exchanges,
245         bytes _datas,
246         uint[] _datasIndexes, // including 0 and LENGTH values
247         uint256[] _values
248     )
249         public
250         payable
251     {
252         require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");
253         require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");
254 
255         for (uint i = 0; i < _exchanges.length; i++) {
256             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
257             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
258                 data[j - _datasIndexes[i]] = _datas[j];
259             }
260 
261             if (_throughToken != address(0) && i > 0) {
262                 _throughToken.approve(_exchanges[i], 0);
263                 _throughToken.approve(_exchanges[i], _throughToken.balanceOf(this));
264             }
265             require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");
266             if (_throughToken != address(0)) {
267                 _throughToken.approve(_exchanges[i], 0);
268             }
269         }
270 
271         j = _mtkn.totalSupply(); // optimization totalSupply
272         uint256 bestAmount = uint256(-1);
273         for (i = _mtkn.tokensCount(); i > 0; i--) {
274             ERC20 token = _mtkn.tokens(i - 1);
275             token.approve(_mtkn, 0);
276             token.approve(_mtkn, token.balanceOf(this));
277 
278             uint256 amount = j.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
279             if (amount < bestAmount) {
280                 bestAmount = amount;
281             }
282         }
283 
284         require(bestAmount >= _minimumReturn, "buy: return value is too low");
285         _mtkn.bundle(msg.sender, bestAmount);
286         if (address(this).balance > 0) {
287             msg.sender.transfer(address(this).balance);
288         }
289         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
290             _throughToken.transfer(msg.sender, _throughToken.balanceOf(this));
291         }
292     }
293 
294     function buyOnTransfer(
295         IMultiToken _mtkn,
296         uint256 _minimumReturn,
297         ERC20 _throughToken,
298         address[] _exchanges,
299         bytes _datas,
300         uint[] _datasIndexes, // including 0 and LENGTH values
301         uint256[] _values
302     )
303         public
304         payable
305     {
306         require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");
307         require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");
308 
309         for (uint i = 0; i < _exchanges.length; i++) {
310             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
311             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
312                 data[j - _datasIndexes[i]] = _datas[j];
313             }
314 
315             if (_throughToken != address(0) && i > 0) {
316                 _throughToken.transfer(_exchanges[i], _values[i]);
317             }
318             require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");
319         }
320 
321         j = _mtkn.totalSupply(); // optimization totalSupply
322         uint256 bestAmount = uint256(-1);
323         for (i = _mtkn.tokensCount(); i > 0; i--) {
324             ERC20 token = _mtkn.tokens(i - 1);
325             token.approve(_mtkn, 0);
326             token.approve(_mtkn, token.balanceOf(this));
327 
328             uint256 amount = j.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
329             if (amount < bestAmount) {
330                 bestAmount = amount;
331             }
332         }
333 
334         require(bestAmount >= _minimumReturn, "buy: return value is too low");
335         _mtkn.bundle(msg.sender, bestAmount);
336         if (address(this).balance > 0) {
337             msg.sender.transfer(address(this).balance);
338         }
339         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
340             _throughToken.transfer(msg.sender, _throughToken.balanceOf(this));
341         }
342     }
343 
344     function buyFirstTokensOnApprove(
345         IMultiToken _mtkn,
346         ERC20 _throughToken,
347         address[] _exchanges,
348         bytes _datas,
349         uint[] _datasIndexes, // including 0 and LENGTH values
350         uint256[] _values
351     )
352         public
353         payable
354     {
355         require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");
356         require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");
357 
358         for (uint i = 0; i < _exchanges.length; i++) {
359             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
360             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
361                 data[j - _datasIndexes[i]] = _datas[j];
362             }
363 
364             if (_throughToken != address(0) && i > 0) {
365                 _throughToken.approve(_exchanges[i], 0);
366                 _throughToken.approve(_exchanges[i], _throughToken.balanceOf(this));
367             }
368             require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");
369             if (_throughToken != address(0)) {
370                 _throughToken.approve(_exchanges[i], 0);
371             }
372         }
373 
374         uint tokensCount = _mtkn.tokensCount();
375         uint256[] memory amounts = new uint256[](tokensCount);
376         for (i = 0; i < tokensCount; i++) {
377             ERC20 token = _mtkn.tokens(i);
378             amounts[i] = token.balanceOf(this);
379             token.approve(_mtkn, 0);
380             token.approve(_mtkn, amounts[i]);
381         }
382 
383         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
384         if (address(this).balance > 0) {
385             msg.sender.transfer(address(this).balance);
386         }
387         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
388             _throughToken.transfer(msg.sender, _throughToken.balanceOf(this));
389         }
390     }
391 
392     function buyFirstTokensOnTransfer(
393         IMultiToken _mtkn,
394         ERC20 _throughToken,
395         address[] _exchanges,
396         bytes _datas,
397         uint[] _datasIndexes, // including 0 and LENGTH values
398         uint256[] _values
399     )
400         public
401         payable
402     {
403         require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");
404         require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");
405 
406         for (uint i = 0; i < _exchanges.length; i++) {
407             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
408             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
409                 data[j - _datasIndexes[i]] = _datas[j];
410             }
411 
412             if (_throughToken != address(0) && i > 0) {
413                 _throughToken.transfer(_exchanges[i], _values[i]);
414             }
415             require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");
416         }
417 
418         uint tokensCount = _mtkn.tokensCount();
419         uint256[] memory amounts = new uint256[](tokensCount);
420         for (i = 0; i < tokensCount; i++) {
421             ERC20 token = _mtkn.tokens(i);
422             amounts[i] = token.balanceOf(this);
423             token.approve(_mtkn, 0);
424             token.approve(_mtkn, amounts[i]);
425         }
426 
427         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
428         if (address(this).balance > 0) {
429             msg.sender.transfer(address(this).balance);
430         }
431         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
432             _throughToken.transfer(msg.sender, _throughToken.balanceOf(this));
433         }
434     }
435 }
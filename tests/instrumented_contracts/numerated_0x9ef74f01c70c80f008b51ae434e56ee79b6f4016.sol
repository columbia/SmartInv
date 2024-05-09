1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
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
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
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
45     function tokens(uint i) public view returns(ERC20);
46     function bundlingEnabled() public view returns(bool);
47     
48     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
49     function bundle(address _beneficiary, uint256 _amount) public;
50 
51     function unbundle(address _beneficiary, uint256 _value) public;
52     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
53 
54     // Owner methods
55     function disableBundling() public;
56     function enableBundling() public;
57 
58     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
59       /**
60        * 0xd5c368b6 ===
61        *   bytes4(keccak256('tokensCount()')) ^
62        *   bytes4(keccak256('tokens(uint256)')) ^
63        *   bytes4(keccak256('bundlingEnabled()')) ^
64        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
65        *   bytes4(keccak256('bundle(address,uint256)')) ^
66        *   bytes4(keccak256('unbundle(address,uint256)')) ^
67        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
68        *   bytes4(keccak256('disableBundling()')) ^
69        *   bytes4(keccak256('enableBundling()'))
70        */
71 }
72 
73 // File: contracts/interface/IMultiToken.sol
74 
75 contract IMultiToken is IBasicMultiToken {
76     event Update();
77     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
78 
79     function weights(address _token) public view returns(uint256);
80     function changesEnabled() public view returns(bool);
81     
82     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
83     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
84 
85     // Owner methods
86     function disableChanges() public;
87 
88     bytes4 public constant InterfaceId_IMultiToken = 0x81624e24;
89       /**
90        * 0x81624e24 ===
91        *   InterfaceId_IBasicMultiToken(0xd5c368b6) ^
92        *   bytes4(keccak256('weights(address)')) ^
93        *   bytes4(keccak256('changesEnabled()')) ^
94        *   bytes4(keccak256('getReturn(address,address,uint256)')) ^
95        *   bytes4(keccak256('change(address,address,uint256,uint256)')) ^
96        *   bytes4(keccak256('disableChanges()'))
97        */
98 }
99 
100 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
101 
102 /**
103  * @title SafeMath
104  * @dev Math operations with safety checks that throw on error
105  */
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
112     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
113     // benefit is lost if 'b' is also tested.
114     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
115     if (_a == 0) {
116       return 0;
117     }
118 
119     c = _a * _b;
120     assert(c / _a == _b);
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers, truncating the quotient.
126   */
127   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     // assert(_b > 0); // Solidity automatically throws when dividing by 0
129     // uint256 c = _a / _b;
130     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
131     return _a / _b;
132   }
133 
134   /**
135   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
138     assert(_b <= _a);
139     return _a - _b;
140   }
141 
142   /**
143   * @dev Adds two numbers, throws on overflow.
144   */
145   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
146     c = _a + _b;
147     assert(c >= _a);
148     return c;
149   }
150 }
151 
152 // File: contracts/ext/CheckedERC20.sol
153 
154 library CheckedERC20 {
155     using SafeMath for uint;
156 
157     function isContract(address addr) internal view returns(bool result) {
158         // solium-disable-next-line security/no-inline-assembly
159         assembly {
160             result := gt(extcodesize(addr), 0)
161         }
162     }
163 
164     function handleReturnBool() internal pure returns(bool result) {
165         // solium-disable-next-line security/no-inline-assembly
166         assembly {
167             switch returndatasize()
168             case 0 { // not a std erc20
169                 result := 1
170             }
171             case 32 { // std erc20
172                 returndatacopy(0, 0, 32)
173                 result := mload(0)
174             }
175             default { // anything else, should revert for safety
176                 revert(0, 0)
177             }
178         }
179     }
180 
181     function handleReturnBytes32() internal pure returns(bytes32 result) {
182         // solium-disable-next-line security/no-inline-assembly
183         assembly {
184             switch eq(returndatasize(), 32) // not a std erc20
185             case 1 {
186                 returndatacopy(0, 0, 32)
187                 result := mload(0)
188             }
189 
190             switch gt(returndatasize(), 32) // std erc20
191             case 1 {
192                 returndatacopy(0, 64, 32)
193                 result := mload(0)
194             }
195 
196             switch lt(returndatasize(), 32) // anything else, should revert for safety
197             case 1 {
198                 revert(0, 0)
199             }
200         }
201     }
202 
203     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
204         require(isContract(token));
205         // solium-disable-next-line security/no-low-level-calls
206         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
207         return handleReturnBool();
208     }
209 
210     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
211         require(isContract(token));
212         // solium-disable-next-line security/no-low-level-calls
213         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
214         return handleReturnBool();
215     }
216 
217     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
218         require(isContract(token));
219         // solium-disable-next-line security/no-low-level-calls
220         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
221         return handleReturnBool();
222     }
223 
224     //
225 
226     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
227         if (value > 0) {
228             uint256 balance = token.balanceOf(this);
229             asmTransfer(token, to, value);
230             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
231         }
232     }
233 
234     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
235         if (value > 0) {
236             uint256 toBalance = token.balanceOf(to);
237             asmTransferFrom(token, from, to, value);
238             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
239         }
240     }
241 
242     //
243 
244     function asmName(address token) internal view returns(bytes32) {
245         require(isContract(token));
246         // solium-disable-next-line security/no-low-level-calls
247         require(token.call(bytes4(keccak256("name()"))));
248         return handleReturnBytes32();
249     }
250 
251     function asmSymbol(address token) internal view returns(bytes32) {
252         require(isContract(token));
253         // solium-disable-next-line security/no-low-level-calls
254         require(token.call(bytes4(keccak256("symbol()"))));
255         return handleReturnBytes32();
256     }
257 }
258 
259 // File: contracts/ext/ExternalCall.sol
260 
261 library ExternalCall {
262     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
263     // call has been separated into its own function in order to take advantage
264     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
265     function externalCall(address destination, uint value, bytes data, uint dataOffset, uint dataLength) internal returns(bool result) {
266         // solium-disable-next-line security/no-inline-assembly
267         assembly {
268             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
269             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
270             result := call(
271                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
272                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
273                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
274                 destination,
275                 value,
276                 add(d, dataOffset),
277                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
278                 x,
279                 0                  // Output is ignored, therefore the output size is zero
280             )
281         }
282     }
283 }
284 
285 // File: contracts/network/MultiChanger.sol
286 
287 contract IEtherToken is ERC20 {
288     function deposit() public payable;
289     function withdraw(uint256 amount) public;
290 }
291 
292 
293 contract MultiChanger {
294     using SafeMath for uint256;
295     using CheckedERC20 for ERC20;
296     using ExternalCall for address;
297 
298     function change(bytes callDatas, uint[] starts) public payable { // starts should include 0 and callDatas.length
299         for (uint i = 0; i < starts.length - 1; i++) {
300             require(address(this).externalCall(0, callDatas, starts[i], starts[i + 1] - starts[i]));
301         }
302     }
303 
304     // Ether
305 
306     function sendEthValue(address target, uint256 value) external {
307         // solium-disable-next-line security/no-call-value
308         require(target.call.value(value)());
309     }
310 
311     function sendEthProportion(address target, uint256 mul, uint256 div) external {
312         uint256 value = address(this).balance.mul(mul).div(div);
313         // solium-disable-next-line security/no-call-value
314         require(target.call.value(value)());
315     }
316 
317     // Ether token
318 
319     function depositEtherTokenAmount(IEtherToken etherToken, uint256 amount) external {
320         etherToken.deposit.value(amount)();
321     }
322 
323     function depositEtherTokenProportion(IEtherToken etherToken, uint256 mul, uint256 div) external {
324         uint256 amount = address(this).balance.mul(mul).div(div);
325         etherToken.deposit.value(amount)();
326     }
327 
328     function withdrawEtherTokenAmount(IEtherToken etherToken, uint256 amount) external {
329         etherToken.withdraw(amount);
330     }
331 
332     function withdrawEtherTokenProportion(IEtherToken etherToken, uint256 mul, uint256 div) external {
333         uint256 amount = etherToken.balanceOf(this).mul(mul).div(div);
334         etherToken.withdraw(amount);
335     }
336 
337     // Token
338 
339     function transferTokenAmount(address target, ERC20 fromToken, uint256 amount) external {
340         require(fromToken.asmTransfer(target, amount));
341     }
342 
343     function transferTokenProportion(address target, ERC20 fromToken, uint256 mul, uint256 div) external {
344         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
345         require(fromToken.asmTransfer(target, amount));
346     }
347 
348     function transferFromTokenAmount(ERC20 fromToken, uint256 amount) external {
349         require(fromToken.asmTransferFrom(tx.origin, this, amount));
350     }
351 
352     function transferFromTokenProportion(ERC20 fromToken, uint256 mul, uint256 div) external {
353         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
354         require(fromToken.asmTransferFrom(tx.origin, this, amount));
355     }
356 
357     // MultiToken
358 
359     function multitokenChangeAmount(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 amount) external {
360         if (fromToken.allowance(this, mtkn) == 0) {
361             fromToken.asmApprove(mtkn, uint256(-1));
362         }
363         mtkn.change(fromToken, toToken, amount, minReturn);
364     }
365 
366     function multitokenChangeProportion(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 mul, uint256 div) external {
367         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
368         this.multitokenChangeAmount(mtkn, fromToken, toToken, minReturn, amount);
369     }
370 }
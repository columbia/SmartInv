1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: contracts/ext/CheckedERC20.sol
91 
92 library CheckedERC20 {
93     using SafeMath for uint;
94 
95     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
96         if (_value == 0) {
97             return;
98         }
99         uint256 balance = _token.balanceOf(this);
100         _token.transfer(_to, _value);
101         require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
102     }
103 
104     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
105         if (_value == 0) {
106             return;
107         }
108         uint256 toBalance = _token.balanceOf(_to);
109         _token.transferFrom(_from, _to, _value);
110         require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
111     }
112 }
113 
114 // File: contracts/interface/IBasicMultiToken.sol
115 
116 contract IBasicMultiToken is ERC20 {
117     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
118     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
119 
120     function tokensCount() public view returns(uint256);
121     function tokens(uint256 _index) public view returns(ERC20);
122     function allTokens() public view returns(ERC20[]);
123     function allDecimals() public view returns(uint8[]);
124     function allBalances() public view returns(uint256[]);
125     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
126 
127     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
128     function bundle(address _beneficiary, uint256 _amount) public;
129 
130     function unbundle(address _beneficiary, uint256 _value) public;
131     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
132 }
133 
134 // File: contracts/interface/IMultiToken.sol
135 
136 contract IMultiToken is IBasicMultiToken {
137     event Update();
138     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
139 
140     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
141     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
142 
143     function allWeights() public view returns(uint256[] _weights);
144     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
145 }
146 
147 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
148 
149 /**
150  * @title SafeERC20
151  * @dev Wrappers around ERC20 operations that throw on failure.
152  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
153  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
154  */
155 library SafeERC20 {
156   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
157     require(token.transfer(to, value));
158   }
159 
160   function safeTransferFrom(
161     ERC20 token,
162     address from,
163     address to,
164     uint256 value
165   )
166     internal
167   {
168     require(token.transferFrom(from, to, value));
169   }
170 
171   function safeApprove(ERC20 token, address spender, uint256 value) internal {
172     require(token.approve(spender, value));
173   }
174 }
175 
176 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipRenounced(address indexed previousOwner);
188   event OwnershipTransferred(
189     address indexed previousOwner,
190     address indexed newOwner
191   );
192 
193 
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198   constructor() public {
199     owner = msg.sender;
200   }
201 
202   /**
203    * @dev Throws if called by any account other than the owner.
204    */
205   modifier onlyOwner() {
206     require(msg.sender == owner);
207     _;
208   }
209 
210   /**
211    * @dev Allows the current owner to relinquish control of the contract.
212    */
213   function renounceOwnership() public onlyOwner {
214     emit OwnershipRenounced(owner);
215     owner = address(0);
216   }
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param _newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address _newOwner) public onlyOwner {
223     _transferOwnership(_newOwner);
224   }
225 
226   /**
227    * @dev Transfers control of the contract to a newOwner.
228    * @param _newOwner The address to transfer ownership to.
229    */
230   function _transferOwnership(address _newOwner) internal {
231     require(_newOwner != address(0));
232     emit OwnershipTransferred(owner, _newOwner);
233     owner = _newOwner;
234   }
235 }
236 
237 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
238 
239 /**
240  * @title Contracts that should be able to recover tokens
241  * @author SylTi
242  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
243  * This will prevent any accidental loss of tokens.
244  */
245 contract CanReclaimToken is Ownable {
246   using SafeERC20 for ERC20Basic;
247 
248   /**
249    * @dev Reclaim all ERC20Basic compatible tokens
250    * @param token ERC20Basic The address of the token contract
251    */
252   function reclaimToken(ERC20Basic token) external onlyOwner {
253     uint256 balance = token.balanceOf(this);
254     token.safeTransfer(owner, balance);
255   }
256 
257 }
258 
259 // File: contracts/registry/MultiSeller.sol
260 
261 contract MultiSeller is CanReclaimToken {
262     using SafeMath for uint256;
263     using CheckedERC20 for ERC20;
264     using CheckedERC20 for IMultiToken;
265 
266     function() public payable {
267         require(tx.origin != msg.sender);
268     }
269 
270     function sellOnApproveForOrigin(
271         IMultiToken _mtkn,
272         uint256 _amount,
273         ERC20 _throughToken,
274         address[] _exchanges,
275         bytes _datas,
276         uint[] _datasIndexes // including 0 and LENGTH values
277     )
278         public
279     {
280         sellOnApprove(
281             _mtkn,
282             _amount,
283             _throughToken,
284             _exchanges,
285             _datas,
286             _datasIndexes,
287             tx.origin
288         );
289     }
290 
291     function sellOnApprove(
292         IMultiToken _mtkn,
293         uint256 _amount,
294         ERC20 _throughToken,
295         address[] _exchanges,
296         bytes _datas,
297         uint[] _datasIndexes, // including 0 and LENGTH values
298         address _for
299     )
300         public
301     {
302         if (_throughToken == address(0)) {
303             require(_mtkn.tokensCount() == _exchanges.length, "sell: _mtkn should have the same tokens count as _exchanges");
304         } else {
305             require(_mtkn.tokensCount() + 1 == _exchanges.length, "sell: _mtkn should have tokens count + 1 equal _exchanges length");
306         }
307         require(_datasIndexes.length == _exchanges.length + 1, "sell: _datasIndexes should start with 0 and end with LENGTH");
308 
309         _mtkn.transferFrom(msg.sender, this, _amount);
310         _mtkn.unbundle(this, _amount);
311 
312         for (uint i = 0; i < _exchanges.length; i++) {
313             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
314             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
315                 data[j - _datasIndexes[i]] = _datas[j];
316             }
317             if (data.length == 0) {
318                 continue;
319             }
320 
321             if (i == _exchanges.length - 1 && _throughToken != address(0)) {
322                 if (_throughToken.allowance(this, _exchanges[i]) == 0) {
323                     _throughToken.approve(_exchanges[i], uint256(-1));
324                 }
325             } else {
326                 ERC20 token = _mtkn.tokens(i);
327                 if (_exchanges[i] == 0) {
328                     token.transfer(_for, token.balanceOf(this));
329                     continue;
330                 }
331                 token.approve(_exchanges[i], token.balanceOf(this));
332             }
333             require(_exchanges[i].call(data), "sell: exchange arbitrary call failed");
334         }
335 
336         _for.transfer(address(this).balance);
337         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
338             _throughToken.transfer(_for, _throughToken.balanceOf(this));
339         }
340     }
341 }
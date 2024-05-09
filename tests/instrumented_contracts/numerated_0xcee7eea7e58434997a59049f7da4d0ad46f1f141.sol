1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91       require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     if (newOwner != address(0)) {
102       owner = newOwner;
103     }
104   }
105 
106 }
107 
108 
109 /**
110  * @title ERC20
111  * @dev The ERC20 interface has an standard functions and event
112  * for erc20 compatible token on Ethereum blockchain.
113  */
114 interface ERC20 {
115     function totalSupply() external view returns (uint supply);
116     function balanceOf(address _owner) external view returns (uint balance);
117     function transfer(address _to, uint _value) external; // Some ERC20 doesn't have return
118     function transferFrom(address _from, address _to, uint _value) external; // Some ERC20 doesn't have return
119     function approve(address _spender, uint _value) external; // Some ERC20 doesn't have return
120     function allowance(address _owner, address _spender) external view returns (uint remaining);
121     function decimals() external view returns(uint digits);
122     event Approval(address indexed _owner, address indexed _spender, uint _value);
123 }
124 
125 
126 /**
127  * @title KULAP Trading Proxy
128  * @dev The KULAP trading proxy interface has an standard functions and event
129  * for other smart contract to implement to join KULAP Dex as Market Maker. 
130  */
131 interface KULAPTradingProxy {
132     // Trade event
133     /// @dev when new trade occure (and success), this event will be boardcast. 
134     /// @param src Source token
135     /// @param srcAmount amount of source tokens
136     /// @param dest   Destination token
137     /// @return amount of actual destination tokens
138     event Trade( ERC20 src, uint256 srcAmount, ERC20 dest, uint256 destAmount);
139 
140     /// @notice use token address ETH_TOKEN_ADDRESS for ether
141     /// @dev makes a trade between src and dest token and send dest token to destAddress
142     /// @param src Source token
143     /// @param dest   Destination token
144     /// @param srcAmount amount of source tokens
145     /// @return amount of actual destination tokens
146     function trade(
147         ERC20 src,
148         ERC20 dest,
149         uint256 srcAmount
150     )
151         external
152         payable
153         returns(uint256);
154     
155     /// @dev provite current rate between source and destination token 
156     ///      for given source amount
157     /// @param src Source token
158     /// @param dest   Destination token
159     /// @param srcAmount amount of source tokens
160     /// @return current reserve and rate
161     function rate(
162         ERC20 src, 
163         ERC20 dest, 
164         uint256 srcAmount
165     ) 
166         external 
167         view 
168         returns(uint256, uint256);
169 }
170 
171 contract KulapDex is Ownable {
172     event Trade(
173         // Source
174         address indexed _srcAsset,
175         uint256         _srcAmount,
176 
177         // Destination
178         address indexed _destAsset,
179         uint256         _destAmount,
180 
181         // User
182         address indexed _trader, 
183 
184         // System
185         uint256          fee
186     );
187 
188     using SafeMath for uint256;
189     ERC20 public etherERC20 = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
190 
191     // address public dexWallet = 0x7ff0F1919424F0D2B6A109E3139ae0f1d836D468; // To receive fee of the KULAP Dex network
192 
193     // list of trading proxies
194     KULAPTradingProxy[] public tradingProxies;
195 
196     function _tradeEtherToToken(
197         uint256 tradingProxyIndex, 
198         uint256 srcAmount, 
199         ERC20 dest
200         ) 
201         private 
202         returns(uint256)  {
203         // Load trading proxy
204         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
205 
206         // Trade to proxy
207         uint256 destAmount = tradingProxy.trade.value(srcAmount)(
208             etherERC20,
209             dest,
210             srcAmount
211         );
212 
213         return destAmount;
214     }
215 
216     // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy
217     function () public payable {
218 
219     }
220 
221     function _tradeTokenToEther(
222         uint256 tradingProxyIndex,
223         ERC20 src,
224         uint256 srcAmount
225         ) 
226         private 
227         returns(uint256)  {
228         // Load trading proxy
229         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
230 
231         // Approve to TradingProxy
232         src.approve(tradingProxy, srcAmount);
233 
234         // Trande to proxy
235         uint256 destAmount = tradingProxy.trade(
236             src, 
237             etherERC20,
238             srcAmount
239         );
240         
241         return destAmount;
242     }
243 
244     function _tradeTokenToToken(
245         uint256 tradingProxyIndex,
246         ERC20 src,
247         uint256 srcAmount,
248         ERC20 dest
249         ) 
250         private 
251         returns(uint256)  {
252         // Load trading proxy
253         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
254 
255         // Approve to TradingProxy
256         src.approve(tradingProxy, srcAmount);
257 
258         // Trande to proxy
259         uint256 destAmount = tradingProxy.trade(
260             src, 
261             dest,
262             srcAmount
263         );
264         
265         return destAmount;
266     }
267 
268     // Ex1: trade 0.5 ETH -> EOS
269     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
270     //
271     // Ex2: trade 30 EOS -> ETH
272     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
273     function _trade(
274         uint256             _tradingProxyIndex, 
275         ERC20               _src, 
276         uint256             _srcAmount, 
277         ERC20               _dest, 
278         uint256             _minDestAmount
279     ) private returns(uint256)  {
280         // Destination amount
281         uint256 destAmount;
282 
283         // Record src/dest asset for later consistency check.
284         uint256 srcAmountBefore;
285         uint256 destAmountBefore;
286         // Source
287         if (etherERC20 == _src) {
288             srcAmountBefore = address(this).balance;
289         } else {
290             srcAmountBefore = _src.balanceOf(this);
291         }
292         // Dest
293         if (etherERC20 == _dest) {
294             destAmountBefore = address(this).balance;
295         } else {
296             destAmountBefore = _dest.balanceOf(this);
297         }
298 
299         // Trade ETH -> Token
300         if (etherERC20 == _src) {
301             destAmount = _tradeEtherToToken(_tradingProxyIndex, _srcAmount, _dest);
302         
303         // Trade Token -> ETH
304         } else if (etherERC20 == _dest) {
305             destAmount = _tradeTokenToEther(_tradingProxyIndex, _src, _srcAmount);
306 
307         // Trade Token -> Token
308         } else {
309             destAmount = _tradeTokenToToken(_tradingProxyIndex, _src, _srcAmount, _dest);
310         }
311 
312         // Recheck if src/dest amount correct
313         // Source
314         if (etherERC20 == _src) {
315             require(address(this).balance == srcAmountBefore.sub(_srcAmount), "source amount mismatch after trade");
316         } else {
317             require(_src.balanceOf(this) == srcAmountBefore.sub(_srcAmount), "source amount mismatch after trade");
318         }
319         // Dest
320         if (etherERC20 == _dest) {
321             require(address(this).balance == destAmountBefore.add(destAmount), "destination amount mismatch after trade");
322         } else {
323             require(_dest.balanceOf(this) == destAmountBefore.add(destAmount), "destination amount mismatch after trade");
324         }
325 
326         // Throw exception if destination amount doesn't meet user requirement.
327         require(destAmount >= _minDestAmount, "destination amount is too low.");
328 
329         return destAmount;
330     }
331 
332     // Ex1: trade 0.5 ETH -> EOS
333     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
334     //
335     // Ex2: trade 30 EOS -> ETH
336     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
337     function trade(uint256 tradingProxyIndex, ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount) payable public returns(uint256)  {
338         uint256 destAmount;
339 
340         // Prepare source's asset
341         if (etherERC20 != src) {
342             // Transfer token to This address
343             src.transferFrom(msg.sender, address(this), srcAmount);
344         }
345 
346         // Trade with proxy
347         destAmount = _trade(tradingProxyIndex, src, srcAmount, dest, 1);
348 
349         // Throw exception if destination amount doesn't meet user requirement.
350         require(destAmount >= minDestAmount, "destination amount is too low.");
351 
352         // Send back ether to sender
353         if (etherERC20 == dest) {
354             // Send back ether to sender
355             // Throws on failure
356             msg.sender.transfer(destAmount);
357         
358         // Send back token to sender
359         } else {
360             // Some ERC20 Smart contract not return Bool, so we can't check here
361             // require(dest.transfer(msg.sender, destAmount));
362             dest.transfer(msg.sender, destAmount);
363         }
364 
365         emit Trade(src, srcAmount, dest, destAmount, msg.sender, 0);
366         
367 
368         return destAmount;
369     }
370 
371     // Ex1: trade 50 OMG -> ETH -> EOS
372     // Step1: trade 50 OMG -> ETH
373     // Step2: trade xx ETH -> EOS
374     // "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "30000000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "1", ["0x0000000000000000000000000000000000000000", "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x0000000000000000000000000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817"]
375     //
376     // Ex2: trade 50 OMG -> ETH -> DAI
377     // Step1: trade 50 OMG -> ETH
378     // Step2: trade xx ETH -> DAI
379     // "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "30000000000000000000", "0x45ad02b30930cad22ff7921c111d22943c6c822f", "1", ["0x0000000000000000000000000000000000000000", "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x0000000000000000000000000000000000000001", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x45ad02b30930cad22ff7921c111d22943c6c822f"]
380     function tradeRoutes(
381         ERC20 src,
382         uint256 srcAmount,
383         ERC20 dest,
384         uint256 minDestAmount,
385         address[] _tradingPaths)
386 
387         public payable returns(uint256)  {
388         uint256 destAmount;
389 
390         if (etherERC20 != src) {
391             // Transfer token to This address
392             src.transferFrom(msg.sender, address(this), srcAmount);
393         }
394 
395         uint256 pathSrcAmount = srcAmount;
396         for (uint i = 0; i < _tradingPaths.length; i += 3) {
397             uint256 tradingProxyIndex =         uint256(_tradingPaths[i]);
398             ERC20 pathSrc =                     ERC20(_tradingPaths[i+1]);
399             ERC20 pathDest =                    ERC20(_tradingPaths[i+2]);
400 
401             destAmount = _trade(tradingProxyIndex, pathSrc, pathSrcAmount, pathDest, 1);
402             pathSrcAmount = destAmount;
403         }
404 
405         // Throw exception if destination amount doesn't meet user requirement.
406         require(destAmount >= minDestAmount, "destination amount is too low.");
407 
408         // Trade Any -> ETH
409         if (etherERC20 == dest) {
410             // Send back ether to sender
411             // Throws on failure
412             msg.sender.transfer(destAmount);
413         
414         // Trade Any -> Token
415         } else {
416             // Send back token to sender
417             // Some ERC20 Smart contract not return Bool, so we can't check here
418             // require(dest.transfer(msg.sender, destAmount));
419             dest.transfer(msg.sender, destAmount);
420         }
421 
422         emit Trade(src, srcAmount, dest, destAmount, msg.sender, 0);
423 
424         return destAmount;
425     }
426 
427     /// @notice use token address ETH_TOKEN_ADDRESS for ether
428     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
429     /// @param tradingProxyIndex index of trading proxy
430     /// @param src Source token
431     /// @param dest Destination token
432     /// @param srcAmount Srouce amount
433     /* solhint-disable code-complexity */
434     function rate(uint256 tradingProxyIndex, ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint, uint) {
435         // Load trading proxy
436         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
437 
438         return tradingProxy.rate(src, dest, srcAmount);
439     }
440 
441     /**
442     * @dev Function for adding new trading proxy
443     * @param _proxyAddress The address of trading proxy.
444     * @return index of this proxy.
445     */
446     function addTradingProxy(
447         KULAPTradingProxy _proxyAddress
448     ) public onlyOwner returns (uint256) {
449 
450         tradingProxies.push(_proxyAddress);
451 
452         return tradingProxies.length;
453     }
454 }
1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) pure internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) pure internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) pure internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) pure internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70       require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     if (newOwner != address(0)) {
81       owner = newOwner;
82     }
83   }
84 
85 }
86 
87 /**
88  * @title ERC20
89  * @dev The ERC20 interface has an standard functions and event
90  * for erc20 compatible token on Ethereum blockchain.
91  */
92 interface ERC20 {
93     function totalSupply() external view returns (uint supply);
94     function balanceOf(address _owner) external view returns (uint balance);
95     function transfer(address _to, uint _value) external; // Some ERC20 doesn't have return
96     function transferFrom(address _from, address _to, uint _value) external; // Some ERC20 doesn't have return
97     function approve(address _spender, uint _value) external; // Some ERC20 doesn't have return
98     function allowance(address _owner, address _spender) external view returns (uint remaining);
99     function decimals() external view returns(uint digits);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 }
102 
103 /**
104  * @title KULAP Trading Proxy
105  * @dev The KULAP trading proxy interface has an standard functions and event
106  * for other smart contract to implement to join KULAP Dex as Market Maker. 
107  */
108 interface KULAPTradingProxy {
109     // Trade event
110     /// @dev when new trade occure (and success), this event will be boardcast. 
111     /// @param src Source token
112     /// @param srcAmount amount of source tokens
113     /// @param dest   Destination token
114     /// @return amount of actual destination tokens
115     event Trade( ERC20 src, uint srcAmount, ERC20 dest, uint destAmount);
116 
117     /// @notice use token address ETH_TOKEN_ADDRESS for ether
118     /// @dev makes a trade between src and dest token and send dest token to destAddress
119     /// @param src Source token
120     /// @param dest   Destination token
121     /// @param srcAmount amount of source tokens
122     /// @return amount of actual destination tokens
123     function trade(
124         ERC20 src,
125         ERC20 dest,
126         uint srcAmount
127     )
128         external
129         payable
130         returns(uint);
131     
132     /// @dev provite current rate between source and destination token 
133     ///      for given source amount
134     /// @param src Source token
135     /// @param dest   Destination token
136     /// @param srcAmount amount of source tokens
137     /// @return current reserve and rate
138     function rate(
139         ERC20 src, 
140         ERC20 dest, 
141         uint srcAmount
142     ) 
143         external 
144         view 
145         returns(uint, uint);
146 }
147 
148 contract KulapDex is Ownable {
149     event Trade(
150         // Source
151         address indexed _srcAsset,
152         uint256         _srcAmount,
153 
154         // Destination
155         address indexed _destAsset,
156         uint256         _destAmount,
157 
158         // User
159         address indexed _trader, 
160 
161         // System
162         uint256          fee
163     );
164 
165     using SafeMath for uint256;
166     ERC20 public etherERC20 = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
167 
168     // address public dexWallet = 0x7ff0F1919424F0D2B6A109E3139ae0f1d836D468; // To receive fee of the KULAP Dex network
169 
170     // list of trading proxies
171     KULAPTradingProxy[] public tradingProxies;
172 
173     function _tradeEtherToToken(
174         uint256 tradingProxyIndex, 
175         uint256 srcAmount, 
176         ERC20 dest
177         ) 
178         private 
179         returns(uint256)  {
180         // Load trading proxy
181         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
182 
183         // Trade to proxy
184         uint256 destAmount = tradingProxy.trade.value(srcAmount)(
185             etherERC20,
186             dest,
187             srcAmount
188         );
189 
190         return destAmount;
191     }
192 
193     // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy
194     function () public payable {
195 
196     }
197 
198     function _tradeTokenToEther(
199         uint256 tradingProxyIndex, 
200         ERC20 src, 
201         uint256 srcAmount
202         ) 
203         private 
204         returns(uint256)  {
205         // Load trading proxy
206         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
207 
208         // Approve to TradingProxy
209         src.approve(tradingProxy, srcAmount);
210 
211         // Trande to proxy
212         uint256 destAmount = tradingProxy.trade(
213             src, 
214             etherERC20,
215             srcAmount
216         );
217         
218         return destAmount;
219     }
220 
221     // Ex1: trade 0.5 ETH -> EOS
222     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
223     //
224     // Ex2: trade 30 EOS -> ETH
225     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
226     function _trade(
227         uint256             _tradingProxyIndex, 
228         ERC20               _src, 
229         uint256             _srcAmount, 
230         ERC20               _dest, 
231         uint256             _minDestAmount
232     ) private returns(uint256)  {
233         // Destination amount
234         uint256 destAmount;
235 
236         // Record src/dest asset for later consistency check.
237         uint256 srcAmountBefore;
238         uint256 destAmountBefore;
239         // Source
240         if (etherERC20 == _src) {
241             srcAmountBefore = address(this).balance;
242         } else {
243             srcAmountBefore = _src.balanceOf(this);
244         }
245         // Dest
246         if (etherERC20 == _dest) {
247             destAmountBefore = address(this).balance;
248         } else {
249             destAmountBefore = _dest.balanceOf(this);
250         }
251 
252         // Trade ETH -> Token
253         if (etherERC20 == _src) {
254             destAmount = _tradeEtherToToken(_tradingProxyIndex, _srcAmount, _dest);
255         
256         // Trade Token -> ETH
257         } else if (etherERC20 == _dest) {
258             destAmount = _tradeTokenToEther(_tradingProxyIndex, _src, _srcAmount);
259 
260         // Trade Token -> Token
261         // For token -> token use tradeRoutes instead
262         } else {
263             revert();
264         }
265 
266         // Recheck if src/dest amount correct
267         // Source
268         if (etherERC20 == _src) {
269             assert(address(this).balance == srcAmountBefore.sub(_srcAmount));
270         } else {
271             assert(_src.balanceOf(this) == srcAmountBefore.sub(_srcAmount));
272         }
273         // Dest
274         if (etherERC20 == _dest) {
275             assert(address(this).balance == destAmountBefore.add(destAmount));
276         } else {
277             assert(_dest.balanceOf(this) == destAmountBefore.add(destAmount));
278         }
279 
280         // Throw exception if destination amount doesn't meet user requirement.
281         assert(destAmount >= _minDestAmount);
282 
283         return destAmount;
284     }
285 
286     // Ex1: trade 0.5 ETH -> EOS
287     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
288     //
289     // Ex2: trade 30 EOS -> ETH
290     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
291     function trade(uint256 tradingProxyIndex, ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount) payable public returns(uint256)  {
292         uint256 destAmount;
293 
294         // Trade ETH -> Token
295         if (etherERC20 == src) {
296             destAmount = _trade(tradingProxyIndex, src, srcAmount, dest, 1);
297 
298             // Throw exception if destination amount doesn't meet user requirement.
299             assert(destAmount >= minDestAmount);
300 
301             // Send back token to sender
302             // Some ERC20 Smart contract not return Bool, so we can't check here
303             // require(dest.transfer(msg.sender, destAmount));
304             dest.transfer(msg.sender, destAmount);
305         
306         // Trade Token -> ETH
307         } else if (etherERC20 == dest) {
308             // Transfer token to This address
309             src.transferFrom(msg.sender, address(this), srcAmount);
310 
311             destAmount = _trade(tradingProxyIndex, src, srcAmount, dest, 1);
312 
313             // Throw exception if destination amount doesn't meet user requirement.
314             assert(destAmount >= minDestAmount);
315 
316             // Send back ether to sender
317             // Throws on failure
318             msg.sender.transfer(destAmount);
319 
320         // Trade Token -> Token
321         // For token -> token use tradeRoutes instead
322         } else {
323             revert();
324         }
325 
326         emit Trade( src, srcAmount, dest, destAmount, msg.sender, 0);
327         
328 
329         return destAmount;
330     }
331 
332     // Ex1: trade 50 OMG -> ETH -> EOS
333     // Step1: trade 50 OMG -> ETH
334     // Step2: trade xx ETH -> EOS
335     // "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "30000000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "1", ["0x0000000000000000000000000000000000000000", "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x0000000000000000000000000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817"]
336     //
337     // Ex2: trade 50 OMG -> ETH -> DAI
338     // Step1: trade 50 OMG -> ETH
339     // Step2: trade xx ETH -> DAI
340     // "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "30000000000000000000", "0x45ad02b30930cad22ff7921c111d22943c6c822f", "1", ["0x0000000000000000000000000000000000000000", "0x5b9a857e0C3F2acc5b94f6693536d3Adf5D6e6Be", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x0000000000000000000000000000000000000001", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "0x45ad02b30930cad22ff7921c111d22943c6c822f"]
341     function tradeRoutes(ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount, address[] _tradingPaths) payable public returns(uint256)  {
342         uint256 destAmount;
343 
344         if (etherERC20 != src) {
345             // Transfer token to This address
346             src.transferFrom(msg.sender, address(this), srcAmount);
347         }
348 
349         uint256 pathSrcAmount = srcAmount;
350         for (uint i=0; i < _tradingPaths.length; i+=3) {
351             uint256 tradingProxyIndex =         uint256(_tradingPaths[i]);
352             ERC20 pathSrc =                     ERC20(_tradingPaths[i+1]);
353             ERC20 pathDest =                    ERC20(_tradingPaths[i+2]);
354 
355             destAmount = _trade(tradingProxyIndex, pathSrc, pathSrcAmount, pathDest, 1);
356             pathSrcAmount = destAmount;
357         }
358 
359         // Throw exception if destination amount doesn't meet user requirement.
360         assert(destAmount >= minDestAmount);
361 
362         // Trade Any -> ETH
363         if (etherERC20 == dest) {
364             // Send back ether to sender
365             // Throws on failure
366             msg.sender.transfer(destAmount);
367         
368         // Trade Any -> Token
369         } else {
370             // Send back token to sender
371             // Some ERC20 Smart contract not return Bool, so we can't check here
372             // require(dest.transfer(msg.sender, destAmount));
373             dest.transfer(msg.sender, destAmount);
374         }
375 
376         emit Trade( src, srcAmount, dest, destAmount, msg.sender, 0);
377 
378         return destAmount;
379     }
380 
381     /// @notice use token address ETH_TOKEN_ADDRESS for ether
382     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
383     /// @param tradingProxyIndex index of trading proxy
384     /// @param src Source token
385     /// @param dest Destination token
386     /// @param srcAmount Srouce amount
387     /* solhint-disable code-complexity */
388     function rate(uint256 tradingProxyIndex, ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint, uint) {
389         // Load trading proxy
390         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
391 
392         return tradingProxy.rate(src, dest, srcAmount);
393     }
394 
395     /**
396     * @dev Function for adding new trading proxy
397     * @param _proxyAddress The address of trading proxy.
398     * @return index of this proxy.
399     */
400     function addTradingProxy(
401         KULAPTradingProxy _proxyAddress
402     ) public onlyOwner returns (uint256) {
403 
404         tradingProxies.push( _proxyAddress );
405 
406         return tradingProxies.length;
407     }
408 }
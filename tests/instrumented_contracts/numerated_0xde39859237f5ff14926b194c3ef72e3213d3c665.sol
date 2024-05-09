1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) pure internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) pure internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) pure internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) pure internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71       require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     if (newOwner != address(0)) {
82       owner = newOwner;
83     }
84   }
85 
86 }
87 
88 
89 interface ERC20 {
90     function totalSupply() public view returns (uint supply);
91     function balanceOf(address _owner) public view returns (uint balance);
92     function transfer(address _to, uint _value) public; // Some ERC20 doesn't have return
93     function transferFrom(address _from, address _to, uint _value) public; // Some ERC20 doesn't have return
94     function approve(address _spender, uint _value) public; // Some ERC20 doesn't have return
95     function allowance(address _owner, address _spender) public view returns (uint remaining);
96     function decimals() public view returns(uint digits);
97     event Approval(address indexed _owner, address indexed _spender, uint _value);
98 }
99 
100 contract KyberNetworkContract {
101 
102     /// @notice use token address ETH_TOKEN_ADDRESS for ether
103     /// @dev makes a trade between src and dest token and send dest token to destAddress
104     /// @param src Src token
105     /// @param srcAmount amount of src tokens
106     /// @param dest   Destination token
107     /// @param destAddress Address to send tokens to
108     /// @param maxDestAmount A limit on the amount of dest tokens
109     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
110     /// @param walletId is the wallet ID to send part of the fees
111     /// @return amount of actual dest tokens
112     function trade(
113         ERC20 src,
114         uint srcAmount,
115         ERC20 dest,
116         address destAddress,
117         uint maxDestAmount,
118         uint minConversionRate,
119         address walletId
120     )
121         public
122         payable
123         returns(uint);
124     
125     /// @notice use token address ETH_TOKEN_ADDRESS for ether
126     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
127     /// @param src Src token
128     /// @param dest Destination token
129     /* solhint-disable code-complexity */
130     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint);
131 }
132 
133 interface KULAPTradingProxy {
134     // Trade event
135     event Trade( ERC20 src, uint srcAmount, ERC20 dest, uint destAmount);
136 
137     /// @notice use token address ETH_TOKEN_ADDRESS for ether
138     /// @dev makes a trade between src and dest token and send dest token to destAddress
139     /// @param src Src token
140     /// @param srcAmount amount of src tokens
141     /// @param dest   Destination token
142     /// @return amount of actual dest tokens
143     function trade(
144         ERC20 src,
145         uint srcAmount,
146         ERC20 dest
147     )
148         public
149         payable
150         returns(uint);
151     
152     function rate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint);
153 }
154 
155 contract Dex is Ownable {
156     event Trade( ERC20 src, uint srcAmount, ERC20 dest, uint destAmount);
157 
158     using SafeMath for uint256;
159     ERC20 public etherERC20 = ERC20(0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
160 
161     address public dexWallet = 0x7ff0F1919424F0D2B6A109E3139ae0f1d836D468; // To receive fee of the DEX network
162 
163     // list of trading proxies
164     KULAPTradingProxy[] public tradingProxies;
165 
166     function _tradeEtherToToken(uint256 tradingProxyIndex, uint256 srcAmount, ERC20 dest) private returns(uint256)  {
167         // Load trading proxy
168         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
169 
170         // Trade to proxy
171         uint256 destAmount = tradingProxy.trade.value(srcAmount)(
172             etherERC20,
173             srcAmount, 
174             dest
175         );
176 
177         return destAmount;
178     }
179 
180     // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy
181     function () payable {
182 
183     }
184 
185     function _tradeTokenToEther(uint256 tradingProxyIndex, ERC20 src, uint256 amount) private returns(uint256)  {
186         // Load trading proxy
187         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
188 
189         // Approve to TradingProxy
190         src.approve(tradingProxy, amount);
191 
192         // Trande with kyber
193         uint256 destAmount = tradingProxy.trade(
194             src, 
195             amount, 
196             etherERC20);
197         
198         return destAmount;
199     }
200 
201     // Ex1: trade 0.5 ETH -> EOS
202     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
203     //
204     // Ex2: trade 30 EOS -> ETH
205     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
206     function _trade(uint256 tradingProxyIndex, ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount) private returns(uint256)  {
207         uint256 destAmount;
208 
209         // Trade ETH -> Any
210         if (etherERC20 == src) {
211             destAmount = _tradeEtherToToken(tradingProxyIndex, srcAmount, dest);
212         
213         // Trade Any -> ETH
214         } else if (etherERC20 == dest) {
215             destAmount = _tradeTokenToEther(tradingProxyIndex, src, srcAmount);
216 
217         // Trade Any -> Any
218         } else {
219 
220         }
221 
222         // Throw exception if destination amount doesn't meet user requirement.
223         assert(destAmount >= minDestAmount);
224 
225         return destAmount;
226     }
227 
228     // Ex1: trade 0.5 ETH -> EOS
229     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
230     //
231     // Ex2: trade 30 EOS -> ETH
232     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
233     function trade(uint256 tradingProxyIndex, ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount) payable public returns(uint256)  {
234         uint256 destAmount;
235 
236         // Trade ETH -> Any
237         if (etherERC20 == src) {
238             destAmount = _trade(tradingProxyIndex, src, srcAmount, dest, 1);
239 
240             // Throw exception if destination amount doesn't meet user requirement.
241             assert(destAmount >= minDestAmount);
242 
243             // Send back token to sender
244             // Some ERC20 Smart contract not return Bool, so we can't check here
245             // require(dest.transfer(msg.sender, destAmount));
246             dest.transfer(msg.sender, destAmount);
247         
248         // Trade Any -> ETH
249         } else if (etherERC20 == dest) {
250             // Transfer token to This address
251             src.transferFrom(msg.sender, address(this), srcAmount);
252 
253             destAmount = _trade(tradingProxyIndex, src, srcAmount, dest, 1);
254 
255             // Throw exception if destination amount doesn't meet user requirement.
256             assert(destAmount >= minDestAmount);
257 
258             // Send back ether to sender
259             // TODO: Check if amount send correctly, because solidty will not raise error when not enough amount
260             msg.sender.send(destAmount);
261 
262         // Trade Any -> Any
263         } else {
264 
265         }
266 
267         Trade( src, srcAmount, dest, destAmount);
268 
269         return destAmount;
270     }
271 
272     // Ex1: trade 50 OMG -> ETH -> EOS
273     // Step1: trade 50 OMG -> ETH
274     // Step2: trade xx ETH -> EOS
275 
276     // Ex1: trade 0.5 ETH -> EOS
277     // 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
278     //
279     // Ex2: trade 30 EOS -> ETH
280     // 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
281     function tradeRoutes(ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minDestAmount, address[] _tradingPaths) payable public returns(uint256)  {
282         uint256 destAmount;
283 
284         if (etherERC20 != src) {
285             // Transfer token to This address
286             src.transferFrom(msg.sender, address(this), srcAmount);
287         }
288 
289         uint256 pathSrcAmount = srcAmount;
290         for (uint i=0; i < _tradingPaths.length; i+=3) {
291             uint256 tradingProxyIndex =         uint256(_tradingPaths[i]);
292             ERC20 pathSrc =                     ERC20(_tradingPaths[i+1]);
293             ERC20 pathDest =                    ERC20(_tradingPaths[i+2]);
294 
295             destAmount = _trade(tradingProxyIndex, pathSrc, pathSrcAmount, pathDest, 1);
296             pathSrcAmount = destAmount;
297         }
298 
299         // Throw exception if destination amount doesn't meet user requirement.
300         assert(destAmount >= minDestAmount);
301 
302         // Trade Any -> ETH
303         if (etherERC20 == dest) {
304             // Send back ether to sender
305             // TODO: Check if amount send correctly, because solidty will not raise error when not enough amount
306             msg.sender.send(destAmount);
307         
308         // Trade Any -> Token
309         } else {
310             // Send back token to sender
311             // Some ERC20 Smart contract not return Bool, so we can't check here
312             // require(dest.transfer(msg.sender, destAmount));
313             dest.transfer(msg.sender, destAmount);
314         }
315 
316         Trade( src, srcAmount, dest, destAmount);
317 
318         return destAmount;
319     }
320 
321     /// @notice use token address ETH_TOKEN_ADDRESS for ether
322     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
323     /// @param tradingProxyIndex index of trading proxy
324     /// @param src Src token
325     /// @param dest Destination token
326     /// @param srcAmount Srouce amount
327     /* solhint-disable code-complexity */
328     function rate(uint256 tradingProxyIndex, ERC20 src, ERC20 dest, uint srcAmount) public view returns(uint, uint) {
329         // Load trading proxy
330         KULAPTradingProxy tradingProxy = tradingProxies[tradingProxyIndex];
331 
332         return tradingProxy.rate(src, dest, srcAmount);
333     }
334 
335     /**
336     * @dev Function for adding new trading proxy
337     * @param _proxyAddress The address of trading proxy.
338     * @return index of this proxy.
339     */
340     function addTradingProxy(
341         KULAPTradingProxy _proxyAddress
342     ) public onlyOwner returns (uint256) {
343 
344         tradingProxies.push( _proxyAddress );
345 
346         return tradingProxies.length;
347     }
348 }
1 pragma solidity 0.4.21;
2 
3 // File: contracts/ExchangeHandler.sol
4 
5 /// @title Interface for all exchange handler contracts
6 interface ExchangeHandler {
7 
8     /// @dev Get the available amount left to fill for an order
9     /// @param orderAddresses Array of address values needed for this DEX order
10     /// @param orderValues Array of uint values needed for this DEX order
11     /// @param exchangeFee Value indicating the fee for this DEX order
12     /// @param v ECDSA signature parameter v
13     /// @param r ECDSA signature parameter r
14     /// @param s ECDSA signature parameter s
15     /// @return Available amount left to fill for this order
16     function getAvailableAmount(
17         address[8] orderAddresses,
18         uint256[6] orderValues,
19         uint256 exchangeFee,
20         uint8 v,
21         bytes32 r,
22         bytes32 s
23     ) external returns (uint256);
24 
25     /// @dev Perform a buy order at the exchange
26     /// @param orderAddresses Array of address values needed for each DEX order
27     /// @param orderValues Array of uint values needed for each DEX order
28     /// @param exchangeFee Value indicating the fee for this DEX order
29     /// @param amountToFill Amount to fill in this order
30     /// @param v ECDSA signature parameter v
31     /// @param r ECDSA signature parameter r
32     /// @param s ECDSA signature parameter s
33     /// @return Amount filled in this order
34     function performBuy(
35         address[8] orderAddresses,
36         uint256[6] orderValues,
37         uint256 exchangeFee,
38         uint256 amountToFill,
39         uint8 v,
40         bytes32 r,
41         bytes32 s
42     ) external payable returns (uint256);
43 
44     /// @dev Perform a sell order at the exchange
45     /// @param orderAddresses Array of address values needed for each DEX order
46     /// @param orderValues Array of uint values needed for each DEX order
47     /// @param exchangeFee Value indicating the fee for this DEX order
48     /// @param amountToFill Amount to fill in this order
49     /// @param v ECDSA signature parameter v
50     /// @param r ECDSA signature parameter r
51     /// @param s ECDSA signature parameter s
52     /// @return Amount filled in this order
53     function performSell(
54         address[8] orderAddresses,
55         uint256[6] orderValues,
56         uint256 exchangeFee,
57         uint256 amountToFill,
58         uint8 v,
59         bytes32 r,
60         bytes32 s
61     ) external returns (uint256);
62 }
63 
64 // File: contracts/WETH9.sol
65 
66 // Copyright (C) 2015, 2016, 2017 Dapphub
67 
68 // This program is free software: you can redistribute it and/or modify
69 // it under the terms of the GNU General Public License as published by
70 // the Free Software Foundation, either version 3 of the License, or
71 // (at your option) any later version.
72 
73 // This program is distributed in the hope that it will be useful,
74 // but WITHOUT ANY WARRANTY; without even the implied warranty of
75 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
76 // GNU General Public License for more details.
77 
78 // You should have received a copy of the GNU General Public License
79 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
80 
81 contract WETH9 {
82     string public name     = "Wrapped Ether";
83     string public symbol   = "WETH";
84     uint8  public decimals = 18;
85 
86     event  Approval(address indexed src, address indexed guy, uint wad);
87     event  Transfer(address indexed src, address indexed dst, uint wad);
88     event  Deposit(address indexed dst, uint wad);
89     event  Withdrawal(address indexed src, uint wad);
90 
91     mapping (address => uint)                       public  balanceOf;
92     mapping (address => mapping (address => uint))  public  allowance;
93 
94     function() public payable {
95         deposit();
96     }
97     function deposit() public payable {
98         balanceOf[msg.sender] += msg.value;
99         Deposit(msg.sender, msg.value);
100     }
101     function withdraw(uint wad) public {
102         require(balanceOf[msg.sender] >= wad);
103         balanceOf[msg.sender] -= wad;
104         msg.sender.transfer(wad);
105         Withdrawal(msg.sender, wad);
106     }
107 
108     function totalSupply() public view returns (uint) {
109         return this.balance;
110     }
111 
112     function approve(address guy, uint wad) public returns (bool) {
113         allowance[msg.sender][guy] = wad;
114         Approval(msg.sender, guy, wad);
115         return true;
116     }
117 
118     function transfer(address dst, uint wad) public returns (bool) {
119         return transferFrom(msg.sender, dst, wad);
120     }
121 
122     function transferFrom(address src, address dst, uint wad)
123         public
124         returns (bool)
125     {
126         require(balanceOf[src] >= wad);
127 
128         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
129             require(allowance[src][msg.sender] >= wad);
130             allowance[src][msg.sender] -= wad;
131         }
132 
133         balanceOf[src] -= wad;
134         balanceOf[dst] += wad;
135 
136         Transfer(src, dst, wad);
137 
138         return true;
139     }
140 }
141 
142 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     emit OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
185 
186 /**
187  * @title ERC20Basic
188  * @dev Simpler version of ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/179
190  */
191 contract ERC20Basic {
192   function totalSupply() public view returns (uint256);
193   function balanceOf(address who) public view returns (uint256);
194   function transfer(address to, uint256 value) public returns (bool);
195   event Transfer(address indexed from, address indexed to, uint256 value);
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 contract ERC20 is ERC20Basic {
205   function allowance(address owner, address spender) public view returns (uint256);
206   function transferFrom(address from, address to, uint256 value) public returns (bool);
207   function approve(address spender, uint256 value) public returns (bool);
208   event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 // File: contracts/AirSwapHandler.sol
212 
213 /**
214  * @title AirSwap interface.
215  */
216 interface AirSwapInterface {
217     /// @dev Mapping of order hash to bool (true = already filled).
218     function fills(
219         bytes32 hash
220     ) external view returns (bool);
221 
222     /// @dev Fills an order by transferring tokens between (maker or escrow) and taker.
223     /// Maker is given tokenA to taker.
224     function fill(
225         address makerAddress,
226         uint makerAmount,
227         address makerToken,
228         address takerAddress,
229         uint takerAmount,
230         address takerToken,
231         uint256 expiration,
232         uint256 nonce,
233         uint8 v,
234         bytes32 r,
235         bytes32 s
236     ) external payable;
237 }
238 
239 /**
240  * @title AirSwap wrapper contract.
241  * @dev Assumes makers and takers have approved this contract to access their balances.
242  */
243 contract AirSwapHandler is ExchangeHandler, Ownable {
244     /// @dev AirSwap exhange address
245     AirSwapInterface public airSwap;
246     WETH9 public weth;
247     address public totle;
248 
249     modifier onlyTotle() {
250         require(msg.sender == totle);
251         _;
252     }
253 
254     /// @dev Constructor
255     function AirSwapHandler(
256         address _airSwap,
257         address _wethAddress,
258         address _totle
259     ) public {
260         require(_airSwap != address(0x0));
261         require(_wethAddress != address(0x0));
262         require(_totle != address(0x0));
263 
264         airSwap = AirSwapInterface(_airSwap);
265         weth = WETH9(_wethAddress);
266         totle = _totle;
267     }
268 
269     /// @dev Get the available amount left to fill for an order
270     /// @param orderValues Array of uint values needed for this DEX order
271     /// @return Available amount left to fill for this order
272     function getAvailableAmount(
273         address[8],
274         uint256[6] orderValues,
275         uint256,
276         uint8,
277         bytes32,
278         bytes32
279     ) external returns (uint256) {
280         // Just return a orderValues[0], as there's nothing else we can do here
281         return orderValues[0];
282     }
283 
284     /// @dev Perform a buy order at the exchange
285     /// @param orderAddresses Array of address values needed for each DEX order
286     /// @param orderValues Array of uint values needed for each DEX order
287     /// @param amountToFill Amount to fill in this order
288     /// @param v ECDSA signature parameter v
289     /// @param r ECDSA signature parameter r
290     /// @param s ECDSA signature parameter s
291     /// @return Amount filled in this order
292     function performBuy(
293         address[8] orderAddresses,
294         uint256[6] orderValues,
295         uint256,
296         uint256 amountToFill,
297         uint8 v,
298         bytes32 r,
299         bytes32 s
300     )
301     external
302     onlyTotle
303     payable
304     returns (uint256) {
305         fillBuy(orderAddresses, orderValues, v, r, s);
306         return amountToFill;
307     }
308 
309     /// @dev Perform a sell order at the exchange
310     /// @param orderAddresses Array of address values needed for each DEX order
311     /// @param orderValues Array of uint values needed for each DEX order
312     /// @param amountToFill Amount to fill in this order
313     /// @param v ECDSA signature parameter v
314     /// @param r ECDSA signature parameter r
315     /// @param s ECDSA signature parameter s
316     /// @return Amount filled in this order
317     function performSell(
318         address[8] orderAddresses,
319         uint256[6] orderValues,
320         uint256,
321         uint256 amountToFill,
322         uint8 v,
323         bytes32 r,
324         bytes32 s
325     )
326     external
327     onlyTotle
328     returns (uint256) {
329         return fillSell(orderAddresses, orderValues, v, r, s);
330     }
331 
332     function setTotle(address _totle)
333     external
334     onlyOwner {
335         require(_totle != address(0));
336         totle = _totle;
337     }
338 
339     /// @dev The contract is not designed to hold and/or manage tokens.
340     /// Withdraws token in the case of emergency. Only an owner is allowed to call this.
341     function withdrawToken(address _token, uint _amount)
342     external
343     onlyOwner
344     returns (bool) {
345         return ERC20(_token).transfer(owner, _amount);
346     }
347 
348     /// @dev The contract is not designed to hold ETH.
349     /// Withdraws ETH in the case of emergency. Only an owner is allowed to call this.
350     function withdrawETH(uint _amount)
351     external
352     onlyOwner
353     returns (bool) {
354         owner.transfer(_amount);
355     }
356 
357     function() public payable {
358     }
359 
360     /** Validates order arguments for fill() and cancel() functions. */
361     function validateOrder(
362         address makerAddress,
363         uint makerAmount,
364         address makerToken,
365         address takerAddress,
366         uint takerAmount,
367         address takerToken,
368         uint256 expiration,
369         uint256 nonce)
370     public
371     view
372     returns (bool) {
373         // Hash arguments to identify the order.
374         bytes32 hashV = keccak256(makerAddress, makerAmount, makerToken,
375                                   takerAddress, takerAmount, takerToken,
376                                   expiration, nonce);
377         return airSwap.fills(hashV);
378     }
379 
380     /// orderAddresses[0] == makerAddress
381     /// orderAddresses[1] == makerToken
382     /// orderAddresses[2] == takerAddress
383     /// orderAddresses[3] == takerToken
384     /// orderValues[0] = makerAmount
385     /// orderValues[1] = takerAmount
386     /// orderValues[2] = expiration
387     /// orderValues[3] = nonce
388     function fillBuy(
389         address[8] orderAddresses,
390         uint256[6] orderValues,
391         uint8 v,
392         bytes32 r,
393         bytes32 s
394     ) private {
395         airSwap.fill.value(msg.value)(orderAddresses[0], orderValues[0], orderAddresses[1],
396                                       address(this), orderValues[1], orderAddresses[3],
397                                       orderValues[2], orderValues[3], v, r, s);
398 
399         require(validateOrder(orderAddresses[0], orderValues[0], orderAddresses[1],
400                               address(this), orderValues[1], orderAddresses[3],
401                               orderValues[2], orderValues[3]));
402 
403         require(ERC20(orderAddresses[1]).transfer(orderAddresses[2], orderValues[0]));
404     }
405 
406     /// orderAddresses[0] == makerAddress
407     /// orderAddresses[1] == makerToken
408     /// orderAddresses[2] == takerAddress
409     /// orderAddresses[3] == takerToken
410     /// orderValues[0] = makerAmount
411     /// orderValues[1] = takerAmount
412     /// orderValues[2] = expiration
413     /// orderValues[3] = nonce
414     function fillSell(
415         address[8] orderAddresses,
416         uint256[6] orderValues,
417         uint8 v,
418         bytes32 r,
419         bytes32 s
420     ) private
421     returns (uint)
422     {
423         assert(msg.sender == totle);
424 
425         require(orderAddresses[1] == address(weth));
426 
427         uint takerAmount = orderValues[1];
428 
429         require(ERC20(orderAddresses[3]).approve(address(airSwap), takerAmount));
430 
431         airSwap.fill(orderAddresses[0], orderValues[0], orderAddresses[1],
432                      address(this), takerAmount, orderAddresses[3],
433                      orderValues[2], orderValues[3], v, r, s);
434 
435         require(validateOrder(orderAddresses[0], orderValues[0], orderAddresses[1],
436                               address(this), takerAmount, orderAddresses[3],
437                               orderValues[2], orderValues[3]));
438 
439         weth.withdraw(orderValues[0]);
440         msg.sender.transfer(orderValues[0]);
441 
442         return orderValues[0];
443     }
444 }
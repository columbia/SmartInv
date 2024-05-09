1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: contracts/ExternalCall.sol
105 
106 library ExternalCall {
107     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
108     // call has been separated into its own function in order to take advantage
109     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
110     function externalCall(address destination, uint value, bytes data, uint dataOffset, uint dataLength) internal returns(bool result) {
111         // solium-disable-next-line security/no-inline-assembly
112         assembly {
113             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
114             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
115             result := call(
116                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
117                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
118                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
119                 destination,
120                 value,
121                 add(d, dataOffset),
122                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
123                 x,
124                 0                  // Output is ignored, therefore the output size is zero
125             )
126         }
127     }
128 }
129 
130 // File: contracts/ISetToken.sol
131 
132 /*
133     Copyright 2018 Set Labs Inc.
134 
135     Licensed under the Apache License, Version 2.0 (the "License");
136     you may not use this file except in compliance with the License.
137     You may obtain a copy of the License at
138 
139     http://www.apache.org/licenses/LICENSE-2.0
140 
141     Unless required by applicable law or agreed to in writing, software
142     distributed under the License is distributed on an "AS IS" BASIS,
143     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
144     See the License for the specific language governing permissions and
145     limitations under the License.
146 */
147 
148 pragma solidity ^0.4.24;
149 
150 
151 /**
152  * @title ISetToken
153  * @author Set Protocol
154  *
155  * The ISetToken interface provides a light-weight, structured way to interact with the
156  * SetToken contract from another contract.
157  */
158 interface ISetToken {
159 
160     /* ============ External Functions ============ */
161 
162     /*
163      * Issue token set
164      *
165      * @param  amount     Amount of set being issued
166      */
167     function issue(uint256 amount)
168         external;
169 
170     /*
171      * Redeem token set
172      *
173      * @param  amount     Amount of set being redeemed
174      */
175     function redeem(uint256 amount)
176         external;
177 
178     /*
179      * Get natural unit of Set
180      *
181      * @return  uint256       Natural unit of Set
182      */
183     function naturalUnit()
184         external
185         view
186         returns (uint256);
187 
188     /*
189      * Get addresses of all components in the Set
190      *
191      * @return  componentAddresses       Array of component tokens
192      */
193     function getComponents()
194         external
195         view
196         returns(address[]);
197 
198     /*
199      * Get units of all tokens in Set
200      *
201      * @return  units       Array of component units
202      */
203     function getUnits()
204         external
205         view
206         returns(uint256[]);
207 
208     /*
209      * Checks to make sure token is component of Set
210      *
211      * @param  _tokenAddress     Address of token being checked
212      * @return  bool             True if token is component of Set
213      */
214     function tokenIsComponent(
215         address _tokenAddress
216     )
217         external
218         view
219         returns (bool);
220 
221     /*
222      * Mint set token for given address.
223      * Can only be called by authorized contracts.
224      *
225      * @param  _issuer      The address of the issuing account
226      * @param  _quantity    The number of sets to attribute to issuer
227      */
228     function mint(
229         address _issuer,
230         uint256 _quantity
231     )
232         external;
233 
234     /*
235      * Burn set token for given address
236      * Can only be called by authorized contracts
237      *
238      * @param  _from        The address of the redeeming account
239      * @param  _quantity    The number of sets to burn from redeemer
240      */
241     function burn(
242         address _from,
243         uint256 _quantity
244     )
245         external;
246 
247     /**
248     * Balance of token for a specified address
249     *
250     * @param who  The address
251     * @return uint256 Balance of address
252     */
253     function balanceOf(
254         address who
255     )
256         external
257         view
258         returns (uint256);
259 
260     /**
261     * Transfer token for a specified address
262     *
263     * @param to The address to transfer to.
264     * @param value The amount to be transferred.
265     */
266     function transfer(
267         address to,
268         uint256 value
269     )
270         external
271         returns (bool);
272 
273     /**
274     * Transfer token for a specified address
275     *
276     * @param from The address to transfer from.
277     * @param to The address to transfer to.
278     * @param value The amount to be transferred.
279     */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 value
284     )
285         external
286         returns (bool);
287 }
288 
289 // File: contracts/SetBuyer.sol
290 
291 contract IKyberNetworkProxy {
292     function tradeWithHint(
293         address src,
294         uint256 srcAmount,
295         address dest,
296         address destAddress,
297         uint256 maxDestAmount,
298         uint256 minConversionRate,
299         address walletId,
300         bytes hint
301     )
302         public
303         payable
304         returns(uint);
305 
306     function getExpectedRate(
307         address source,
308         address dest,
309         uint srcQty
310     )
311         public
312         view
313         returns (
314             uint expectedPrice,
315             uint slippagePrice
316         );
317 }
318 
319 
320 contract SetBuyer {
321     using SafeMath for uint256;
322     using ExternalCall for address;
323 
324     address constant public ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
325 
326     function buy(
327         ISetToken set,
328         IKyberNetworkProxy kyber
329     )
330         public
331         payable
332     {
333         address[] memory components = set.getComponents();
334         uint256[] memory units = set.getUnits();
335 
336         uint256 weightSum = 0;
337         uint256[] memory weight = new uint256[](components.length);
338         for (uint i = 0; i < components.length; i++) {
339             (weight[i], ) = kyber.getExpectedRate(components[i], ETHER_ADDRESS, units[i]);
340             weightSum = weightSum.add(weight[i]);
341         }
342 
343         uint256 fitMintAmount = uint256(-1);
344         for (i = 0; i < components.length; i++) {
345             IERC20 token = IERC20(components[i]);
346 
347             if (token.allowance(this, set) == 0) {
348                 require(token.approve(set, uint256(-1)), "Approve failed");
349             }
350 
351             uint256 amount = msg.value.mul(weight[i]).div(weightSum);
352             uint256 received = kyber.tradeWithHint.value(amount)(
353                 ETHER_ADDRESS,
354                 amount,
355                 components[i],
356                 this,
357                 1 << 255,
358                 0,
359                 0,
360                 ""
361             );
362 
363             if (received / units[i] < fitMintAmount) {
364                 fitMintAmount = received / units[i];
365             }
366         }
367 
368         set.issue(fitMintAmount * set.naturalUnit());
369         set.transfer(msg.sender, set.balanceOf(this));
370 
371         if (address(this).balance > 0) {
372             msg.sender.transfer(address(this).balance);
373         }
374         for (i = 0; i < components.length; i++) {
375             token = IERC20(components[i]);
376             if (token.balanceOf(this) > 0) {
377                 require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
378             }
379         }
380     }
381 
382     function() public payable {
383         require(tx.origin != msg.sender);
384     }
385 
386     function sell(
387         ISetToken set,
388         uint256 amountArg,
389         IKyberNetworkProxy kyber
390     )
391         public
392     {
393         uint256 naturalUnit = set.naturalUnit();
394         uint256 amount = amountArg.div(naturalUnit).mul(naturalUnit);
395 
396         set.transferFrom(msg.sender, this, amount);
397         set.redeem(amount);
398 
399         address[] memory components = set.getComponents();
400 
401         for (uint i = 0; i < components.length; i++) {
402             IERC20 token = IERC20(components[i]);
403 
404             if (token.allowance(this, kyber) == 0) {
405                 require(token.approve(kyber, uint256(-1)), "Approve failed");
406             }
407 
408             kyber.tradeWithHint(
409                 components[i],
410                 token.balanceOf(this),
411                 ETHER_ADDRESS,
412                 this,
413                 1 << 255,
414                 0,
415                 0,
416                 ""
417             );
418 
419             if (token.balanceOf(this) > 0) {
420                 require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
421             }
422         }
423 
424         if (address(this).balance > 0) {
425             msg.sender.transfer(address(this).balance);
426         }
427     }
428 }
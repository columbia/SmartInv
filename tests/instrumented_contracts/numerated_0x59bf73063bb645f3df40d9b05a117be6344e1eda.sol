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
130 // File: contracts/ISetFactory.sol
131 
132 interface ISetFactory {
133 
134     /* ============ External Functions ============ */
135 
136     /**
137      * Exchange components for Set tokens
138      *
139      * @param  _set          Address of the Set to issue
140      * @param  _quantity     Number of tokens to issue
141      */
142     function issue(
143         address _set,
144         uint256 _quantity
145     )
146         external;
147 
148 }
149 
150 // File: contracts/ISetToken.sol
151 
152 /*
153     Copyright 2018 Set Labs Inc.
154 
155     Licensed under the Apache License, Version 2.0 (the "License");
156     you may not use this file except in compliance with the License.
157     You may obtain a copy of the License at
158 
159     http://www.apache.org/licenses/LICENSE-2.0
160 
161     Unless required by applicable law or agreed to in writing, software
162     distributed under the License is distributed on an "AS IS" BASIS,
163     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
164     See the License for the specific language governing permissions and
165     limitations under the License.
166 */
167 
168 pragma solidity ^0.4.24;
169 
170 
171 
172 /**
173  * @title ISetToken
174  * @author Set Protocol
175  *
176  * The ISetToken interface provides a light-weight, structured way to interact with the
177  * SetToken contract from another contract.
178  */
179 interface ISetToken {
180 
181     /* ============ External Functions ============ */
182 
183     /*
184      * Get factory address
185      *
186      * @return  address       Factory address
187      */
188     function factory()
189         external
190         view
191         returns (ISetFactory);
192 
193     /*
194      * Get natural unit of Set
195      *
196      * @return  uint256       Natural unit of Set
197      */
198     function naturalUnit()
199         external
200         view
201         returns (uint256);
202 
203     /*
204      * Get addresses of all components in the Set
205      *
206      * @return  componentAddresses       Array of component tokens
207      */
208     function getComponents()
209         external
210         view
211         returns(address[]);
212 
213     /*
214      * Get units of all tokens in Set
215      *
216      * @return  units       Array of component units
217      */
218     function getUnits()
219         external
220         view
221         returns(uint256[]);
222 
223     /*
224      * Checks to make sure token is component of Set
225      *
226      * @param  _tokenAddress     Address of token being checked
227      * @return  bool             True if token is component of Set
228      */
229     function tokenIsComponent(
230         address _tokenAddress
231     )
232         external
233         view
234         returns (bool);
235 
236     /*
237      * Mint set token for given address.
238      * Can only be called by authorized contracts.
239      *
240      * @param  _issuer      The address of the issuing account
241      * @param  _quantity    The number of sets to attribute to issuer
242      */
243     function mint(
244         address _issuer,
245         uint256 _quantity
246     )
247         external;
248 
249     /*
250      * Burn set token for given address
251      * Can only be called by authorized contracts
252      *
253      * @param  _from        The address of the redeeming account
254      * @param  _quantity    The number of sets to burn from redeemer
255      */
256     function burn(
257         address _from,
258         uint256 _quantity
259     )
260         external;
261 
262     /**
263     * Balance of token for a specified address
264     *
265     * @param who  The address
266     * @return uint256 Balance of address
267     */
268     function balanceOf(
269         address who
270     )
271         external
272         view
273         returns (uint256);
274 
275     /**
276     * Transfer token for a specified address
277     *
278     * @param to The address to transfer to.
279     * @param value The amount to be transferred.
280     */
281     function transfer(
282         address to,
283         uint256 value
284     )
285         external;
286 }
287 
288 // File: contracts/SetBuyer.sol
289 
290 contract IKyberNetworkProxy {
291     function tradeWithHint(
292         address src,
293         uint256 srcAmount,
294         address dest,
295         address destAddress,
296         uint256 maxDestAmount,
297         uint256 minConversionRate,
298         address walletId,
299         bytes hint
300     )
301         public
302         payable
303         returns(uint);
304 
305     function getExpectedRate(
306         address source,
307         address dest,
308         uint srcQty
309     )
310         public
311         view
312         returns (
313             uint expectedPrice,
314             uint slippagePrice
315         );
316 }
317 
318 
319 contract SetBuyer {
320     using SafeMath for uint256;
321     using ExternalCall for address;
322 
323     address constant public ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
324 
325     function buy(
326         ISetToken set,
327         IKyberNetworkProxy kyber
328     )
329         public
330         payable
331     {
332         address[] memory components = set.getComponents();
333         uint256[] memory units = set.getUnits();
334 
335         uint256 weightSum = 0;
336         uint256[] memory weight = new uint256[](components.length);
337         for (uint i = 0; i < components.length; i++) {
338             (weight[i], ) = kyber.getExpectedRate(components[i], ETHER_ADDRESS, units[i]);
339             weightSum = weightSum.add(weight[i]);
340         }
341 
342         uint256 fitMintAmount = uint256(-1);
343         for (i = 0; i < components.length; i++) {
344             uint256 amount = msg.value.mul(weight[i]).div(weightSum);
345             uint256 received = kyber.tradeWithHint.value(amount)(
346                 ETHER_ADDRESS,
347                 amount,
348                 components[i],
349                 this,
350                 1 << 255,
351                 0,
352                 0,
353                 ""
354             );
355 
356             if (received / units[i] < fitMintAmount) {
357                 fitMintAmount = received / units[i];
358             }
359         }
360 
361         set.factory().issue(set, fitMintAmount);
362         set.transfer(msg.sender, set.balanceOf(this));
363 
364         if (address(this).balance > 0) {
365             msg.sender.transfer(address(this).balance);
366         }
367         for (i = 0; i < components.length; i++) {
368             IERC20 token = IERC20(components[i]);
369             if (token.balanceOf(this) > 0) {
370                 require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
371             }
372         }
373     }
374 
375     function() public payable {
376         require(tx.origin != msg.sender);
377     }
378 
379     // function sell(
380     //     ISetToken set,
381     //     uint256 amount,
382     //     bytes callDatas,
383     //     uint[] starts // including 0 and LENGTH values
384     // )
385     //     public
386     // {
387     //     set.burn(msg.sender, amount);
388 
389     //     change(callDatas, starts);
390 
391     //     address[] memory components = set.getComponents();
392 
393     //     if (address(this).balance > 0) {
394     //         msg.sender.transfer(address(this).balance);
395     //     }
396     //     for (uint i = 0; i < components.length; i++) {
397     //         IERC20 token = IERC20(components[i]);
398     //         if (token.balanceOf(this) > 0) {
399     //             require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
400     //         }
401     //     }
402     // }
403 }
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
171      * Get natural unit of Set
172      *
173      * @return  uint256       Natural unit of Set
174      */
175     function naturalUnit()
176         external
177         view
178         returns (uint256);
179 
180     /*
181      * Get addresses of all components in the Set
182      *
183      * @return  componentAddresses       Array of component tokens
184      */
185     function getComponents()
186         external
187         view
188         returns(address[]);
189 
190     /*
191      * Get units of all tokens in Set
192      *
193      * @return  units       Array of component units
194      */
195     function getUnits()
196         external
197         view
198         returns(uint256[]);
199 
200     /*
201      * Checks to make sure token is component of Set
202      *
203      * @param  _tokenAddress     Address of token being checked
204      * @return  bool             True if token is component of Set
205      */
206     function tokenIsComponent(
207         address _tokenAddress
208     )
209         external
210         view
211         returns (bool);
212 
213     /*
214      * Mint set token for given address.
215      * Can only be called by authorized contracts.
216      *
217      * @param  _issuer      The address of the issuing account
218      * @param  _quantity    The number of sets to attribute to issuer
219      */
220     function mint(
221         address _issuer,
222         uint256 _quantity
223     )
224         external;
225 
226     /*
227      * Burn set token for given address
228      * Can only be called by authorized contracts
229      *
230      * @param  _from        The address of the redeeming account
231      * @param  _quantity    The number of sets to burn from redeemer
232      */
233     function burn(
234         address _from,
235         uint256 _quantity
236     )
237         external;
238 
239     /**
240     * Balance of token for a specified address
241     *
242     * @param who  The address
243     * @return uint256 Balance of address
244     */
245     function balanceOf(
246         address who
247     )
248         external
249         view
250         returns (uint256);
251 
252     /**
253     * Transfer token for a specified address
254     *
255     * @param to The address to transfer to.
256     * @param value The amount to be transferred.
257     */
258     function transfer(
259         address to,
260         uint256 value
261     )
262         external;
263 }
264 
265 // File: contracts/SetBuyer.sol
266 
267 contract IKyberNetworkProxy {
268     function tradeWithHint(
269         address src,
270         uint256 srcAmount,
271         address dest,
272         address destAddress,
273         uint256 maxDestAmount,
274         uint256 minConversionRate,
275         address walletId,
276         bytes hint
277     )
278         public
279         payable
280         returns(uint);
281 
282     function getExpectedRate(
283         address source,
284         address dest,
285         uint srcQty
286     )
287         public
288         view
289         returns (
290             uint expectedPrice,
291             uint slippagePrice
292         );
293 }
294 
295 
296 contract SetBuyer {
297     using SafeMath for uint256;
298     using ExternalCall for address;
299 
300     address constant public ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
301 
302     function buy(
303         ISetToken set,
304         IKyberNetworkProxy kyber
305     )
306         public
307         payable
308     {
309         address[] memory components = set.getComponents();
310         uint256[] memory units = set.getUnits();
311 
312         uint256 weightSum = 0;
313         uint256[] memory weight = new uint256[](components.length);
314         for (uint i = 0; i < components.length; i++) {
315             (weight[i], ) = kyber.getExpectedRate(components[i], ETHER_ADDRESS, units[i]);
316             weightSum = weightSum.add(weight[i]);
317         }
318 
319         uint256 fitMintAmount = uint256(-1);
320         for (i = 0; i < components.length; i++) {
321             uint256 amount = msg.value.mul(weight[i]).div(weightSum);
322             uint256 received = kyber.tradeWithHint.value(amount)(
323                 ETHER_ADDRESS,
324                 amount,
325                 components[i],
326                 this,
327                 1 << 255,
328                 0,
329                 0,
330                 ""
331             );
332 
333             if (received / units[i] < fitMintAmount) {
334                 fitMintAmount = received / units[i];
335             }
336         }
337 
338         set.issue(fitMintAmount);
339         set.transfer(msg.sender, set.balanceOf(this));
340 
341         if (address(this).balance > 0) {
342             msg.sender.transfer(address(this).balance);
343         }
344         for (i = 0; i < components.length; i++) {
345             IERC20 token = IERC20(components[i]);
346             if (token.balanceOf(this) > 0) {
347                 require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
348             }
349         }
350     }
351 
352     function() public payable {
353         require(tx.origin != msg.sender);
354     }
355 
356     // function sell(
357     //     ISetToken set,
358     //     uint256 amount,
359     //     bytes callDatas,
360     //     uint[] starts // including 0 and LENGTH values
361     // )
362     //     public
363     // {
364     //     set.burn(msg.sender, amount);
365 
366     //     change(callDatas, starts);
367 
368     //     address[] memory components = set.getComponents();
369 
370     //     if (address(this).balance > 0) {
371     //         msg.sender.transfer(address(this).balance);
372     //     }
373     //     for (uint i = 0; i < components.length; i++) {
374     //         IERC20 token = IERC20(components[i]);
375     //         if (token.balanceOf(this) > 0) {
376     //             require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
377     //         }
378     //     }
379     // }
380 }
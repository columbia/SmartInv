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
150 /**
151  * @title ISetToken
152  * @author Set Protocol
153  *
154  * The ISetToken interface provides a light-weight, structured way to interact with the
155  * SetToken contract from another contract.
156  */
157 interface ISetToken {
158 
159     /* ============ External Functions ============ */
160 
161     /*
162      * Get factory address
163      *
164      * @return  address       Factory address
165      */
166     function factory()
167         external
168         view
169         returns (address);
170 
171     /*
172      * Get natural unit of Set
173      *
174      * @return  uint256       Natural unit of Set
175      */
176     function naturalUnit()
177         external
178         view
179         returns (uint256);
180 
181     /*
182      * Get addresses of all components in the Set
183      *
184      * @return  componentAddresses       Array of component tokens
185      */
186     function getComponents()
187         external
188         view
189         returns(address[]);
190 
191     /*
192      * Get units of all tokens in Set
193      *
194      * @return  units       Array of component units
195      */
196     function getUnits()
197         external
198         view
199         returns(uint256[]);
200 
201     /*
202      * Checks to make sure token is component of Set
203      *
204      * @param  _tokenAddress     Address of token being checked
205      * @return  bool             True if token is component of Set
206      */
207     function tokenIsComponent(
208         address _tokenAddress
209     )
210         external
211         view
212         returns (bool);
213 
214     /*
215      * Mint set token for given address.
216      * Can only be called by authorized contracts.
217      *
218      * @param  _issuer      The address of the issuing account
219      * @param  _quantity    The number of sets to attribute to issuer
220      */
221     function mint(
222         address _issuer,
223         uint256 _quantity
224     )
225         external;
226 
227     /*
228      * Burn set token for given address
229      * Can only be called by authorized contracts
230      *
231      * @param  _from        The address of the redeeming account
232      * @param  _quantity    The number of sets to burn from redeemer
233      */
234     function burn(
235         address _from,
236         uint256 _quantity
237     )
238         external;
239 
240     /**
241     * Transfer token for a specified address
242     *
243     * @param to The address to transfer to.
244     * @param value The amount to be transferred.
245     */
246     function transfer(
247         address to,
248         uint256 value
249     )
250         external;
251 }
252 
253 // File: contracts/SetBuyer.sol
254 
255 contract IKyberNetworkProxy {
256     function tradeWithHint(
257         address src,
258         uint256 srcAmount,
259         address dest,
260         address destAddress,
261         uint256 maxDestAmount,
262         uint256 minConversionRate,
263         address walletId,
264         bytes hint
265     )
266         public
267         payable
268         returns(uint);
269 
270     function getExpectedRate(
271         address source,
272         address dest,
273         uint srcQty
274     )
275         public
276         view
277         returns (
278             uint expectedPrice,
279             uint slippagePrice
280         );
281 }
282 
283 
284 contract SetBuyer {
285     using SafeMath for uint256;
286     using ExternalCall for address;
287 
288     address constant public ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
289 
290     function buy(
291         ISetToken set,
292         IKyberNetworkProxy kyber
293     )
294         public
295         payable
296     {
297         address[] memory components = set.getComponents();
298         uint256[] memory units = set.getUnits();
299 
300         uint256 weightSum = 0;
301         uint256[] memory weight = new uint256[](components.length);
302         for (uint i = 0; i < components.length; i++) {
303             (weight[i], ) = kyber.getExpectedRate(components[i], ETHER_ADDRESS, units[i]);
304             weightSum = weightSum.add(weight[i]);
305         }
306 
307         uint256 fitMintAmount = uint256(-1);
308         for (i = 0; i < components.length; i++) {
309             uint256 amount = msg.value.mul(weight[i]).div(weightSum);
310             uint256 received = kyber.tradeWithHint.value(amount)(
311                 ETHER_ADDRESS,
312                 amount,
313                 components[i],
314                 this,
315                 1 << 255,
316                 0,
317                 0,
318                 ""
319             );
320 
321             if (received / units[i] < fitMintAmount) {
322                 fitMintAmount = received / units[i];
323             }
324         }
325 
326         set.mint(msg.sender, fitMintAmount);
327 
328         if (address(this).balance > 0) {
329             msg.sender.transfer(address(this).balance);
330         }
331         for (i = 0; i < components.length; i++) {
332             IERC20 token = IERC20(components[i]);
333             if (token.balanceOf(this) > 0) {
334                 require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
335             }
336         }
337     }
338 
339     function() public payable {
340         require(tx.origin != msg.sender);
341     }
342 
343     // function sell(
344     //     ISetToken set,
345     //     uint256 amount,
346     //     bytes callDatas,
347     //     uint[] starts // including 0 and LENGTH values
348     // )
349     //     public
350     // {
351     //     set.burn(msg.sender, amount);
352 
353     //     change(callDatas, starts);
354 
355     //     address[] memory components = set.getComponents();
356 
357     //     if (address(this).balance > 0) {
358     //         msg.sender.transfer(address(this).balance);
359     //     }
360     //     for (uint i = 0; i < components.length; i++) {
361     //         IERC20 token = IERC20(components[i]);
362     //         if (token.balanceOf(this) > 0) {
363     //             require(token.transfer(msg.sender, token.balanceOf(this)), "transfer failed");
364     //         }
365     //     }
366     // }
367 }
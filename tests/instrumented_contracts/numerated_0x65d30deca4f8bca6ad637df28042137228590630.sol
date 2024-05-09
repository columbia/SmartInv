1 /**
2  * RatesProvider.sol
3  * Provides rates, conversion methods and tools for ETH and CHF currencies.
4 
5  * The unflattened code is available through this github tag:
6  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
7 
8  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
9 
10  * @notice All matters regarding the intellectual property of this code 
11  * @notice or software are subject to Swiss Law without reference to its 
12  * @notice conflicts of law rules.
13 
14  * @notice License for each contract is available in the respective file
15  * @notice or in the LICENSE.md file.
16  * @notice https://github.com/MtPelerin/
17 
18  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
19  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
20  */
21 
22 
23 pragma solidity ^0.4.24;
24 
25 // File: contracts/zeppelin/math/SafeMath.sol
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (a == 0) {
41       return 0;
42     }
43 
44     c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 // File: contracts/interface/IRatesProvider.sol
78 
79 /**
80  * @title IRatesProvider
81  * @dev IRatesProvider interface
82  *
83  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
84  *
85  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
86  * @notice Please refer to the top of this file for the license.
87  */
88 contract IRatesProvider {
89   function rateWEIPerCHFCent() public view returns (uint256);
90   function convertWEIToCHFCent(uint256 _amountWEI)
91     public view returns (uint256);
92 
93   function convertCHFCentToWEI(uint256 _amountCHFCent)
94     public view returns (uint256);
95 }
96 
97 // File: contracts/zeppelin/ownership/Ownable.sol
98 
99 /**
100  * @title Ownable
101  * @dev The Ownable contract has an owner address, and provides basic authorization control
102  * functions, this simplifies the implementation of "user permissions".
103  */
104 contract Ownable {
105   address public owner;
106 
107 
108   event OwnershipRenounced(address indexed previousOwner);
109   event OwnershipTransferred(
110     address indexed previousOwner,
111     address indexed newOwner
112   );
113 
114 
115   /**
116    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
117    * account.
118    */
119   constructor() public {
120     owner = msg.sender;
121   }
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131   /**
132    * @dev Allows the current owner to relinquish control of the contract.
133    */
134   function renounceOwnership() public onlyOwner {
135     emit OwnershipRenounced(owner);
136     owner = address(0);
137   }
138 
139   /**
140    * @dev Allows the current owner to transfer control of the contract to a newOwner.
141    * @param _newOwner The address to transfer ownership to.
142    */
143   function transferOwnership(address _newOwner) public onlyOwner {
144     _transferOwnership(_newOwner);
145   }
146 
147   /**
148    * @dev Transfers control of the contract to a newOwner.
149    * @param _newOwner The address to transfer ownership to.
150    */
151   function _transferOwnership(address _newOwner) internal {
152     require(_newOwner != address(0));
153     emit OwnershipTransferred(owner, _newOwner);
154     owner = _newOwner;
155   }
156 }
157 
158 // File: contracts/Authority.sol
159 
160 /**
161  * @title Authority
162  * @dev The Authority contract has an authority address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  * Authority means to represent a legal entity that is entitled to specific rights
165  *
166  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
167  *
168  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
169  * @notice Please refer to the top of this file for the license.
170  *
171  * Error messages
172  * AU01: Message sender must be an authority
173  */
174 contract Authority is Ownable {
175 
176   address authority;
177 
178   /**
179    * @dev Throws if called by any account other than the authority.
180    */
181   modifier onlyAuthority {
182     require(msg.sender == authority, "AU01");
183     _;
184   }
185 
186   /**
187    * @dev return the address associated to the authority
188    */
189   function authorityAddress() public view returns (address) {
190     return authority;
191   }
192 
193   /**
194    * @dev rdefines an authority
195    * @param _name the authority name
196    * @param _address the authority address.
197    */
198   function defineAuthority(string _name, address _address) public onlyOwner {
199     emit AuthorityDefined(_name, _address);
200     authority = _address;
201   }
202 
203   event AuthorityDefined(
204     string name,
205     address _address
206   );
207 }
208 
209 // File: contracts/RatesProvider.sol
210 
211 /**
212  * @title RatesProvider
213  * @dev RatesProvider interface
214  *
215  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
216  *
217  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
218  * @notice Please refer to the top of this file for the license.
219  *
220  * Error messages
221  */
222 contract RatesProvider is IRatesProvider, Authority {
223   using SafeMath for uint256;
224 
225   // WEICHF rate is in ETH_wei/CHF_cents with no fractional parts
226   uint256 public rateWEIPerCHFCent;
227 
228   /**
229    * @dev constructor
230    */
231   constructor() public {
232   }
233 
234   /**
235    * @dev convert rate from ETHCHF to WEICents
236    */
237   function convertRateFromETHCHF(
238     uint256 _rateETHCHF,
239     uint256 _rateETHCHFDecimal)
240     public pure returns (uint256)
241   {
242     if (_rateETHCHF == 0) {
243       return 0;
244     }
245 
246     return uint256(
247       10**(_rateETHCHFDecimal.add(18 - 2))
248     ).div(_rateETHCHF);
249   }
250 
251   /**
252    * @dev convert rate from WEICents to ETHCHF
253    */
254   function convertRateToETHCHF(
255     uint256 _rateWEIPerCHFCent,
256     uint256 _rateETHCHFDecimal)
257     public pure returns (uint256)
258   {
259     if (_rateWEIPerCHFCent == 0) {
260       return 0;
261     }
262 
263     return uint256(
264       10**(_rateETHCHFDecimal.add(18 - 2))
265     ).div(_rateWEIPerCHFCent);
266   }
267 
268   /**
269    * @dev convert CHF to ETH
270    */
271   function convertCHFCentToWEI(uint256 _amountCHFCent)
272     public view returns (uint256)
273   {
274     return _amountCHFCent.mul(rateWEIPerCHFCent);
275   }
276 
277   /**
278    * @dev convert ETH to CHF
279    */
280   function convertWEIToCHFCent(uint256 _amountETH)
281     public view returns (uint256)
282   {
283     if (rateWEIPerCHFCent == 0) {
284       return 0;
285     }
286 
287     return _amountETH.div(rateWEIPerCHFCent);
288   }
289 
290   /* Current ETHCHF rates */
291   function rateWEIPerCHFCent() public view returns (uint256) {
292     return rateWEIPerCHFCent;
293   }
294   
295   /**
296    * @dev rate ETHCHF
297    */
298   function rateETHCHF(uint256 _rateETHCHFDecimal)
299     public view returns (uint256)
300   {
301     return convertRateToETHCHF(rateWEIPerCHFCent, _rateETHCHFDecimal);
302   }
303 
304   /**
305    * @dev define rate
306    */
307   function defineRate(uint256 _rateWEIPerCHFCent)
308     public onlyAuthority
309   {
310     rateWEIPerCHFCent = _rateWEIPerCHFCent;
311     emit Rate(currentTime(), _rateWEIPerCHFCent);
312   }
313 
314   /**
315    * @dev define rate with decimals
316    */
317   function defineETHCHFRate(uint256 _rateETHCHF, uint256 _rateETHCHFDecimal)
318     public onlyAuthority
319   {
320     // The rate is inverted to maximize the decimals stored
321     defineRate(convertRateFromETHCHF(_rateETHCHF, _rateETHCHFDecimal));
322   }
323 
324   /**
325    * @dev current time
326    */
327   function currentTime() private view returns (uint256) {
328     // solium-disable-next-line security/no-block-members
329     return now;
330   }
331 
332   event Rate(uint256 at, uint256 rateWEIPerCHFCent);
333 }
1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File contracts/interfaces/dao/IInsureToken.sol
4 
5 pragma solidity 0.8.10;
6 
7 interface IInsureToken {
8     function mint(address _to, uint256 _value)external returns(bool);
9     function emergency_mint(uint256 _amountOut, address _to)external;
10     function approve(address _spender, uint256 _value)external;
11     function rate()external view returns(uint256);
12     function future_epoch_time_write() external returns(uint256);
13 }
14 
15 
16 // File contracts/interfaces/dao/ILiquidityGauge.sol
17 
18 
19 
20 pragma solidity 0.8.10;
21 
22 interface ILiquidityGauge {
23     function user_checkpoint(address _addr) external returns (bool);
24 
25     function integrate_fraction(address _addr) external view returns (uint256);
26 }
27 
28 
29 // File contracts/interfaces/dao/IGaugeController.sol
30 
31 
32 
33 pragma solidity 0.8.10;
34 
35 interface IGaugeController {
36     function gauge_types(address _addr)external view returns(uint256);
37     function get_voting_escrow()external view returns(address);
38     function checkpoint_gauge(address addr)external;
39     function gauge_relative_weight(address addr, uint256 time)external view returns(uint256);
40 }
41 
42 
43 // File contracts/interfaces/dao/IEmergencyMintModule.sol
44 
45 
46 
47 pragma solidity 0.8.10;
48 
49 interface IEmergencyMintModule {
50     function mint(address _amount) external;
51 
52     function repayDebt() external;
53 }
54 
55 
56 // File contracts/interfaces/pool/IOwnership.sol
57 
58 pragma solidity 0.8.10;
59 
60 
61 interface IOwnership {
62     function owner() external view returns (address);
63 
64     function futureOwner() external view returns (address);
65 
66     function commitTransferOwnership(address newOwner) external;
67 
68     function acceptTransferOwnership() external;
69 }
70 
71 
72 // File @openzeppelin/contracts/utils/math/Math.sol@v4.4.1
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Standard math utilities missing in the Solidity language.
81  */
82 library Math {
83     /**
84      * @dev Returns the largest of two numbers.
85      */
86     function max(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a >= b ? a : b;
88     }
89 
90     /**
91      * @dev Returns the smallest of two numbers.
92      */
93     function min(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a < b ? a : b;
95     }
96 
97     /**
98      * @dev Returns the average of two numbers. The result is rounded towards
99      * zero.
100      */
101     function average(uint256 a, uint256 b) internal pure returns (uint256) {
102         // (a + b) / 2 can overflow.
103         return (a & b) + (a ^ b) / 2;
104     }
105 
106     /**
107      * @dev Returns the ceiling of the division of two numbers.
108      *
109      * This differs from standard division with `/` in that it rounds up instead
110      * of rounding down.
111      */
112     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
113         // (a + b - 1) / b can overflow on addition, so we distribute.
114         return a / b + (a % b == 0 ? 0 : 1);
115     }
116 }
117 
118 
119 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.1
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Contract module that helps prevent reentrant calls to a function.
128  *
129  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
130  * available, which can be applied to functions to make sure there are no nested
131  * (reentrant) calls to them.
132  *
133  * Note that because there is a single `nonReentrant` guard, functions marked as
134  * `nonReentrant` may not call one another. This can be worked around by making
135  * those functions `private`, and then adding `external` `nonReentrant` entry
136  * points to them.
137  *
138  * TIP: If you would like to learn more about reentrancy and alternative ways
139  * to protect against it, check out our blog post
140  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
141  */
142 abstract contract ReentrancyGuard {
143     // Booleans are more expensive than uint256 or any type that takes up a full
144     // word because each write operation emits an extra SLOAD to first read the
145     // slot's contents, replace the bits taken up by the boolean, and then write
146     // back. This is the compiler's defense against contract upgrades and
147     // pointer aliasing, and it cannot be disabled.
148 
149     // The values being non-zero value makes deployment a bit more expensive,
150     // but in exchange the refund on every call to nonReentrant will be lower in
151     // amount. Since refunds are capped to a percentage of the total
152     // transaction's gas, it is best to keep them low in cases like this one, to
153     // increase the likelihood of the full refund coming into effect.
154     uint256 private constant _NOT_ENTERED = 1;
155     uint256 private constant _ENTERED = 2;
156 
157     uint256 private _status;
158 
159     constructor() {
160         _status = _NOT_ENTERED;
161     }
162 
163     /**
164      * @dev Prevents a contract from calling itself, directly or indirectly.
165      * Calling a `nonReentrant` function from another `nonReentrant`
166      * function is not supported. It is possible to prevent this from happening
167      * by making the `nonReentrant` function external, and making it call a
168      * `private` function that does the actual work.
169      */
170     modifier nonReentrant() {
171         // On the first call to nonReentrant, _notEntered will be true
172         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
173 
174         // Any calls to nonReentrant after this point will fail
175         _status = _ENTERED;
176 
177         _;
178 
179         // By storing the original value once again, a refund is triggered (see
180         // https://eips.ethereum.org/EIPS/eip-2200)
181         _status = _NOT_ENTERED;
182     }
183 }
184 
185 
186 // File contracts/Minter.sol
187 
188 pragma solidity 0.8.10;
189 
190 /***
191  *@title Token Minter
192  *@author InsureDAO
193  * SPDX-License-Identifier: MIT
194  *@notice Used to mint InsureToken
195  */
196 
197 //dao-contracts
198 
199 
200 
201 
202 //libraries
203 
204 
205 contract Minter is ReentrancyGuard {
206     event EmergencyMint(uint256 minted);
207     event Minted(address indexed recipient, address gauge, uint256 minted);
208     event SetConverter(address converter);
209 
210     IInsureToken public insure_token;
211     IGaugeController public gauge_controller;
212     IEmergencyMintModule public emergency_module;
213 
214     // user -> gauge -> value
215     mapping(address => mapping(address => uint256)) public minted; //INSURE minted amount of user from specific gauge.
216 
217     // minter -> user -> can mint?
218     mapping(address => mapping(address => bool)) public allowed_to_mint_for; // A can mint for B if [A => B => true].
219 
220     IOwnership public immutable ownership;
221 
222     modifier onlyOwner() {
223         require(
224             ownership.owner() == msg.sender,
225             "Caller is not allowed to operate"
226         );
227         _;
228     }
229 
230     constructor(address _token, address _controller, address _ownership) {
231         insure_token = IInsureToken(_token);
232         gauge_controller = IGaugeController(_controller);
233         ownership = IOwnership(_ownership);
234     }
235 
236     function _mint_for(address gauge_addr, address _for) internal {
237         require(
238             gauge_controller.gauge_types(gauge_addr) > 0,
239             "dev: gauge is not added"
240         );
241 
242         ILiquidityGauge(gauge_addr).user_checkpoint(_for);
243         uint256 total_mint = ILiquidityGauge(gauge_addr).integrate_fraction(
244             _for
245         ); //Total amount of both mintable and minted.
246         uint256 to_mint = total_mint - minted[_for][gauge_addr]; //mint amount for this time. (total_amount - minted = mintable)
247 
248         if (to_mint != 0) {
249             insure_token.mint(_for, to_mint);
250             minted[_for][gauge_addr] = total_mint;
251 
252             emit Minted(_for, gauge_addr, total_mint);
253         }
254     }
255 
256     /***
257      *@notice Mint everything which belongs to `msg.sender` and send to them
258      *@param gauge_addr `LiquidityGauge` address to get mintable amount from
259      */
260     function mint(address gauge_addr) external nonReentrant {
261         _mint_for(gauge_addr, msg.sender);
262     }
263 
264     /***
265      *@notice Mint everything which belongs to `msg.sender` across multiple gauges
266      *@param gauge_addrs List of `LiquidityGauge` addresses
267      *@dev address[8]: 8 has randomly decided and has no meaning.
268      */
269     function mint_many(address[8] memory gauge_addrs) external nonReentrant {
270 
271         for (uint256 i; i < 8;) {
272             if (gauge_addrs[i] == address(0)) {
273                 break;
274             }
275             _mint_for(gauge_addrs[i], msg.sender);
276             unchecked {
277                 ++i;
278             }
279         }
280     }
281 
282     /***
283      *@notice Mint tokens for `_for`
284      *@dev Only possible when `msg.sender` has been approved via `toggle_approve_mint`
285      *@param gauge_addr `LiquidityGauge` address to get mintable amount from
286      *@param _for Address to mint to
287      */
288     function mint_for(address gauge_addr, address _for) external nonReentrant {
289         if (allowed_to_mint_for[msg.sender][_for]) {
290             _mint_for(gauge_addr, _for);
291         }
292     }
293 
294     /***
295      *@notice allow `minting_user` to mint for `msg.sender`
296      *@param minting_user Address to toggle permission for
297      */
298     function toggle_approve_mint(address minting_user) external {
299         allowed_to_mint_for[minting_user][msg.sender] = !allowed_to_mint_for[
300             minting_user
301         ][msg.sender];
302     }
303 
304     //-----------------emergency mint-----------------/
305 
306     function set_emergency_mint_module(address _emergency_module) external onlyOwner {
307         emergency_module = IEmergencyMintModule(_emergency_module);
308     }
309 
310     /***
311      *@param mint_amount amount of INSURE to be minted
312      */
313     function emergency_mint(uint256 _mint_amount) external {
314         require(msg.sender == address(emergency_module), "onlyOwner");
315 
316         //mint
317         insure_token.emergency_mint(_mint_amount, address(emergency_module));
318 
319         emit EmergencyMint(_mint_amount);
320     }
321 }
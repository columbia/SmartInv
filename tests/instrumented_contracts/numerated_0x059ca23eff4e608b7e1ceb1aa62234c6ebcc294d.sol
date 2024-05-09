1 pragma solidity 0.7.4;
2 // SPDX-License-Identifier: MIT
3 
4 interface IDSDS {
5     function epoch() external view returns (uint);
6     function advance() external;
7     function totalRedeemable() external view returns (uint);
8 
9     function redeemCoupons(uint _epoch, uint _amount) external;
10     function transferCoupons(address _sender, address _recipient, uint _epoch, uint _amount) external;
11     function balanceOfCoupons(address _account, uint _epoch) external view returns (uint);
12 
13     function couponRedemptionPenalty(uint _epoch, uint _amount) external view returns (uint);
14 }
15 
16 interface IERC20 {
17     function transfer(address recipient, uint amount) external returns (bool);
18 }
19 
20 interface ICHI {
21     function freeFromUpTo(address _addr, uint _amount) external returns (uint);
22 }
23 
24 // @notice Lets anybody trustlessly redeem coupons on anyone else's behalf for a fee.
25 //    Requires that the coupon holder has previously approved this contract via the DSDS `approveCoupons` function.
26 // @dev Bots should scan for the `CouponApproval` event emitted by the DSDS `approveCoupons` function to find out which 
27 //    users have approved this contract to redeem their coupons.
28 // @dev This contract's API should be backwards compatible with other CouponClippers.
29 contract CouponClipper {
30     using SafeMath for uint;
31 
32     IERC20 constant private DSD = IERC20(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3);
33     IDSDS constant private DSDS = IDSDS(0x6Bf977ED1A09214E6209F4EA5f525261f1A2690a);
34     ICHI  constant private CHI = ICHI(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
35 
36     // HOUSE_RATE_HALVING_AMNT -- Every time a bot brings in 100000DSD for the house, the house's
37     // rate will be cut in half *for that bot and that bot alone*:
38     // * 50.0% of offer for 0 -> 100000DSD
39     // * 25.0% of offer 100000DSD -> 200000DSD
40     // * 12.5% of offer 200000DSD -> 300000DSD
41     // ...
42     uint constant private HOUSE_RATE_HALVING_AMNT = 100000e18;
43     uint constant private HOUSE_RATE = 5000; // 50% -- initial portion of the offer taken by house
44     uint constant private MAX_OFFER = 5000; // 50% -- higher than this and DIP-2 penalty may eat into offer
45     
46     address public house = 0x871ee4648d0FBB08F39857F41da256659Eab6334; // collector of house take
47 
48     // The basis points offered by coupon holders to have their coupons redeemed -- default is 0 bps (0%)
49     // E.g., offers[_user] = 500 indicates that _user will pay 500 basis points (5%) to the caller
50     mapping(address => uint) private offers;
51     // The coupon redemption loss (in basis points) deemed acceptable by coupon holder -- default is 0 bps (0%)
52     // E.g., maxPenalties[_user] = 100 indicates that _user is ok with 1% of their coupons being burned by DIP-2
53     mapping(address => uint) private maxPenalties;
54     // The cumulative revenue (in DSD) earned by the house because of a given bot's hard work. Any time
55     // this value crosses a multiple of 100000, the house's take rate will be halved.
56     // NOTE: This advantage is non-transferrable. Bots are encouraged to keep their address constant
57     mapping(address => uint) private houseTakes;
58     
59     event SetOffer(address indexed user, uint offer);
60     event SetMaxPenalty(address indexed user, uint penalty);
61     
62     // frees CHI from msg.sender to reduce gas costs
63     // requires that msg.sender has approved this contract to use their CHI
64     modifier useCHI {
65         uint gasStart = gasleft();
66         _;
67         uint gasSpent = 21000 + gasStart - gasleft() + (16 * msg.data.length);
68         CHI.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41947);
69     }
70 
71     // @notice Gets the number of basis points the _user is offering the bots
72     // @param _user The account whose offer we're looking up.
73     // @return The number of basis points the account is offering to have their coupons redeemed
74     function getOffer(address _user) public view returns (uint) {
75         return offers[_user];
76     }
77 
78     // @notice Allows msg.sender to change the number of basis points they are offering.
79     // @dev _newOffer must be no more than 5000 (50%)
80     // @dev A user's offer cannot be *decreased* during the 15 minutes before the epoch advance (frontrun protection)
81     // @param _offer The number of basis points msg.sender wants to offer to have their coupons redeemed.
82     function setOffer(uint _newOffer) external {
83         require(_newOffer <= MAX_OFFER, "Clipper: Offer above 50%");
84 
85         if (_newOffer < offers[msg.sender]) {
86             uint nextEpochStartTime = getEpochStartTime(DSDS.epoch() + 1);
87             uint timeUntilNextEpoch = nextEpochStartTime.sub(block.timestamp);
88             require(timeUntilNextEpoch > 15 minutes, "Clipper: Wait until next epoch");
89         }
90         
91         offers[msg.sender] = _newOffer;
92         emit SetOffer(msg.sender, _newOffer);
93     }
94 
95     // @notice Gets the number of basis points the _user is willing to burn due to DIP-2
96     // @dev The default value is 0 basis points (0%)
97     // @param _user The account whose maxPenalty we're looking up.
98     // @return The number of basis points the accounts is willing to burn when their coupons get redeemed.
99     function getMaxPenalty(address _user) public view returns (uint) {
100         return maxPenalties[_user];
101     }
102 
103     // @notice Allows msg.sender to change the number of basis points they are willing to burn
104     // @dev _newPenalty should be between 0 (0%) and 5000 (50%)
105     // @dev A user's maxPenalty cannot be *decreased* during the 15 minutes before the epoch advance (frontrun protection)
106     // @param _newPenalty The number of basis points msg.sender is willing to burn when their coupons get redeemed.
107     function setMaxPenalty(uint _newPenalty) external {
108         if (_newPenalty < maxPenalties[msg.sender]) {
109             uint nextEpochStartTime = getEpochStartTime(DSDS.epoch() + 1);
110             uint timeUntilNextEpoch = nextEpochStartTime.sub(block.timestamp);
111             require(timeUntilNextEpoch > 15 minutes, "Clipper: Wait until next epoch");
112         }
113         
114         maxPenalties[msg.sender] = _newPenalty;
115         emit SetMaxPenalty(msg.sender, _newPenalty);
116     }
117     
118     // @notice Internal logic used to redeem coupons on the coupon holder's bahalf
119     // @param _user Address of the user holding the coupons (and who has approved this contract)
120     // @param _epoch The epoch in which the _user purchased the coupons
121     // @param _couponAmount The number of coupons to redeem (18 decimals)
122     // @return the fee (in DSD) owned to the bot (msg.sender)
123     function _redeem(address _user, uint _epoch, uint _couponAmount) internal returns (uint) {
124         // check that penalty isn't too high
125         uint penalty = DSDS.couponRedemptionPenalty(_epoch, _couponAmount);
126         if (penalty > _couponAmount.mul(getMaxPenalty(_user)).div(10_000)) return 0;
127 
128         // pull user's coupons into this contract (requires that the user has approved this contract)
129         try DSDS.transferCoupons(_user, address(this), _epoch, _couponAmount) {
130             // redeem the coupons for DSD
131             try DSDS.redeemCoupons(_epoch, _couponAmount) {
132                 // compute fees
133                 uint fee = _couponAmount.mul(getOffer(_user)).div(10_000);
134                 // send the DSD to the user
135                 DSD.transfer(_user, _couponAmount.sub(penalty).sub(fee)); // @audit-info : reverts on failure
136 
137                 // (x >> y) is equivalent to (x / 2**y) for positive integers
138                 uint houseRate = HOUSE_RATE >> houseTakes[tx.origin].div(HOUSE_RATE_HALVING_AMNT);
139                 uint houseFee = fee.mul(houseRate).div(10_000);
140                 houseTakes[tx.origin] = houseTakes[tx.origin].add(houseFee);
141 
142                 // return the bot fee
143                 return fee.sub(houseFee);
144             } catch {
145                 // In this block the transfer succeeded but redemption failed, so we need to undo the transfer!!
146                 DSDS.transferCoupons(address(this), _user, _epoch, _couponAmount);
147                 return 0;
148             }
149         } catch {
150             return 0;
151         }
152     }
153 
154     // @notice Internal logic used to redeem coupons on the coupon holder's bahalf
155     // @param _users Addresses of users holding the coupons (and who has approved this contract)
156     // @param _epochs The epochs in which the _users purchased the coupons
157     // @param _couponAmounts The numbers of coupons to redeem (18 decimals)
158     // @return the total fee (in DSD) owned to the bot (msg.sender)
159     function _redeemMany(address[] calldata _users, uint[] calldata _epochs, uint[] calldata _couponAmounts) internal returns (uint) {
160         // 0 by default, would cost extra gas to make that explicit
161         uint botFee;
162 
163         for (uint i = 0; i < _users.length; i++) {
164             botFee = botFee.add(_redeem(_users[i], _epochs[i], _couponAmounts[i]));
165         }
166 
167         return botFee;
168     }
169     
170     // @notice Allows anyone to redeem coupons for DSD on the coupon-holder's bahalf
171     // @dev Backwards compatible with CouponClipper V1.
172     function redeem(address _user, uint _epoch, uint _couponAmount) external {
173         DSD.transfer(msg.sender, _redeem(_user, _epoch, _couponAmount));
174     }
175 
176     function redeemMany(address[] calldata _users, uint[] calldata _epochs, uint[] calldata _couponAmounts) external {
177         DSD.transfer(msg.sender, _redeemMany(_users, _epochs, _couponAmounts));
178     }
179     
180     // @notice Advances the epoch (if needed) and redeems the max amount of coupons possible
181     //    Also frees CHI tokens to save on gas (requires that msg.sender has CHI tokens in their
182     //    account and has approved this contract to spend their CHI).
183     // @param _user The user whose coupons will attempt to be redeemed
184     // @param _epoch The epoch in which the coupons were created
185     // @param _targetEpoch The epoch that is about to be advanced _to_.
186     //    E.g., if the current epoch is 220 and we are about to advance to to epoch 221, then _targetEpoch
187     //    would be set to 221. The _targetEpoch is the epoch in which the coupon redemption will be attempted.
188     function advanceAndRedeem(address _user, uint _epoch, uint _targetEpoch) external useCHI {
189         // End execution early if tx is mined too early
190         if (block.timestamp < getEpochStartTime(_targetEpoch)) { return; }
191         
192         // advance epoch if it has not already been advanced 
193         if (DSDS.epoch() != _targetEpoch) { DSDS.advance(); }
194         
195         // get max redeemable amount
196         uint totalRedeemable = DSDS.totalRedeemable();
197         if (totalRedeemable == 0) { return; } // no coupons to redeem
198         uint userBalance = DSDS.balanceOfCoupons(_user, _epoch);
199         if (userBalance == 0) { return; } // no coupons to redeem
200         uint maxRedeemableAmount = totalRedeemable < userBalance ? totalRedeemable : userBalance;
201         
202         // attempt to redeem coupons
203         DSD.transfer(msg.sender, _redeem(_user, _epoch, maxRedeemableAmount));
204     }
205 
206     // @notice Advances the epoch (if needed) and redeems the max amount of coupons possible
207     //    Also frees CHI tokens to save on gas (requires that msg.sender has CHI tokens in their
208     //    account and has approved this contract to spend their CHI).
209     // @param _users The users whose coupons will attempt to be redeemed
210     // @param _epochs The epochs in which the coupons were created
211     // @param _targetEpoch The epoch that is about to be advanced _to_.
212     //    E.g., if the current epoch is 220 and we are about to advance to to epoch 221, then _targetEpoch
213     //    would be set to 221. The _targetEpoch is the epoch in which the coupon redemption will be attempted.
214     function advanceAndRedeemMany(address[] calldata _users, uint[] calldata _epochs, uint _targetEpoch) external useCHI {
215         // End execution early if tx is mined too early
216         if (block.timestamp < getEpochStartTime(_targetEpoch)) return;
217 
218         // Advance the epoch if necessary
219         if (DSDS.epoch() != _targetEpoch) DSDS.advance();
220         
221         // 0 by default, would cost extra gas to make that explicit
222         uint botFee;
223         uint amtToRedeem;
224         uint totalRedeemable = DSDS.totalRedeemable();
225 
226         for (uint i = 0; i < _users.length; i++) {
227             if (totalRedeemable == 0) break;
228 
229             amtToRedeem = DSDS.balanceOfCoupons(_users[i], _epochs[i]);
230             if (totalRedeemable < amtToRedeem) amtToRedeem = totalRedeemable;
231 
232             botFee = botFee.add(_redeem(_users[i], _epochs[i], amtToRedeem));
233             totalRedeemable = totalRedeemable.sub(amtToRedeem);
234         }
235 
236         DSD.transfer(msg.sender, botFee);
237     }
238     
239     // @notice Returns the timestamp at which the _targetEpoch starts
240     function getEpochStartTime(uint _targetEpoch) public pure returns (uint) {
241         return _targetEpoch.sub(0).mul(7200).add(1606348800);
242     }
243     
244     // @notice Allows house address to change the house address
245     function changeHouseAddress(address _newAddress) external {
246         require(msg.sender == house);
247         house = _newAddress;
248     }
249 
250     // @notice Allows house to withdraw accumulated fees
251     function withdraw(address _token, uint _amount) external {
252         IERC20(_token).transfer(house, _amount);
253     }
254 }
255 
256 
257 
258 library SafeMath {
259     /**
260      * @dev Returns the addition of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `+` operator.
264      *
265      * Requirements:
266      *
267      * - Addition cannot overflow.
268      */
269     function add(uint a, uint b) internal pure returns (uint) {
270         uint c = a + b;
271         require(c >= a, "SafeMath: addition overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting on
278      * overflow (when the result is negative).
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint a, uint b) internal pure returns (uint) {
287         return sub(a, b, "SafeMath: subtraction overflow");
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
301         require(b <= a, errorMessage);
302         uint c = a - b;
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `*` operator.
312      *
313      * Requirements:
314      *
315      * - Multiplication cannot overflow.
316      */
317     function mul(uint a, uint b) internal pure returns (uint) {
318         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
319         // benefit is lost if 'b' is also tested.
320         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
321         if (a == 0) {
322             return 0;
323         }
324 
325         uint c = a * b;
326         require(c / a == b, "SafeMath: multiplication overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the integer division of two unsigned integers. Reverts on
333      * division by zero. The result is rounded towards zero.
334      *
335      * Counterpart to Solidity's `/` operator. Note: this function uses a
336      * `revert` opcode (which leaves remaining gas untouched) while Solidity
337      * uses an invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function div(uint a, uint b) internal pure returns (uint) {
344         return div(a, b, "SafeMath: division by zero");
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
360         require(b > 0, errorMessage);
361         uint c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(uint a, uint b) internal pure returns (uint) {
380         return mod(a, b, "SafeMath: modulo by zero");
381     }
382 
383     /**
384      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
385      * Reverts with custom message when dividing by zero.
386      *
387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
388      * opcode (which leaves remaining gas untouched) while Solidity uses an
389      * invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
396         require(b != 0, errorMessage);
397         return a % b;
398     }
399 }
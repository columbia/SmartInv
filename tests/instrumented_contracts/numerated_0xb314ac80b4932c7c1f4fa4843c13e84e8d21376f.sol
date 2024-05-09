1 pragma solidity 0.4.24;
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
38 // File: contracts/IDisputer.sol
39 
40 /**
41  * Interface of what the disputer contract should do.
42  *
43  * Its main responsibility to interact with Augur. Only minimal glue methods
44  * are added apart from that in order for crowdsourcer to be able to interact
45  * with it.
46  *
47  * This contract holds the actual crowdsourced REP for dispute, so it doesn't
48  * need to transfer it from elsewhere at the moment of dispute. It doesn't care
49  * at all who this REP belongs to, it just spends it for dispute. Accounting
50  * is done in other contracts.
51  */
52 interface IDisputer {
53   /**
54    * This function should use as little gas as possible, as it will be called
55    * during rush time. Unnecessary operations are postponed for later.
56    *
57    * Can by called by anyone, but only once.
58    */
59   function dispute(address feeReceiver) external;
60 
61   // intentionally can be called by anyone, as no user input is used
62   function approveManagerToSpendDisputeTokens() external;
63 
64   function getOwner() external view returns(address);
65 
66   function hasDisputed() external view returns(bool);
67 
68   function feeReceiver() external view returns(address);
69 
70   function getREP() external view returns(IERC20);
71 
72   function getDisputeTokenAddress() external view returns(IERC20);
73 }
74 
75 // File: contracts/augur/feeWindow.sol
76 
77 interface FeeWindow {
78   function getStartTime() external view returns(uint256);
79   function isOver() external view returns(bool);
80 }
81 
82 // File: contracts/augur/universe.sol
83 
84 interface Universe {
85   function getDisputeRoundDurationInSeconds() external view returns(uint256);
86 
87   function isForking() external view returns(bool);
88 
89   function isContainerForMarket(address _shadyMarket) external view returns(
90     bool
91   );
92 }
93 
94 // File: contracts/augur/reportingParticipant.sol
95 
96 /**
97  * This should've been an interface, but interfaces cannot inherit interfaces
98  */
99 contract ReportingParticipant is IERC20 {
100   function redeem(address _redeemer) external returns(bool);
101   function getStake() external view returns(uint256);
102   function getPayoutDistributionHash() external view returns(bytes32);
103   function getFeeWindow() external view returns(FeeWindow);
104 }
105 
106 // File: contracts/augur/market.sol
107 
108 interface Market {
109   function contribute(
110     uint256[] _payoutNumerators,
111     bool _invalid,
112     uint256 _amount
113   ) external returns(bool);
114 
115   function getReputationToken() external view returns(IERC20);
116 
117   function getUniverse() external view returns(Universe);
118 
119   function derivePayoutDistributionHash(
120     uint256[] _payoutNumerators,
121     bool _invalid
122   ) external view returns(bytes32);
123 
124   function getCrowdsourcer(
125     bytes32 _payoutDistributionHash
126   ) external view returns(ReportingParticipant);
127 
128   function getNumParticipants() external view returns(uint256);
129 
130   function getReportingParticipant(uint256 _index) external view returns(
131     ReportingParticipant
132   );
133 
134   function isFinalized() external view returns(bool);
135 
136   function getFeeWindow() external view returns(FeeWindow);
137 
138   function getWinningReportingParticipant() external view returns(
139     ReportingParticipant
140   );
141 
142   function isContainerForReportingParticipant(
143     ReportingParticipant _shadyReportingParticipant
144   ) external view returns(bool);
145 }
146 
147 // File: contracts/DisputerParams.sol
148 
149 library DisputerParams {
150   struct Params {
151     Market market;
152     uint256 feeWindowId;
153     uint256[] payoutNumerators;
154     bool invalid;
155   }
156 }
157 
158 // File: contracts/BaseDisputer.sol
159 
160 /**
161  * Shared code between real disputer and mock disputer, to make test coverage
162  * better.
163  */
164 contract BaseDisputer is IDisputer {
165   address public m_owner;
166   address public m_feeReceiver = 0;
167   DisputerParams.Params public m_params;
168   IERC20 public m_rep;
169   IERC20 public m_disputeToken;
170 
171   /**
172    * As much as we can do during dispute, without actually interacting
173    * with Augur
174    */
175   function dispute(address feeReceiver) external {
176     require(m_feeReceiver == 0, "Can only dispute once");
177     preDisputeCheck();
178     require(feeReceiver != 0, "Must have valid fee receiver");
179     m_feeReceiver = feeReceiver;
180 
181     IERC20 rep = getREP();
182     uint256 initialREPBalance = rep.balanceOf(this);
183     IERC20 disputeToken = disputeImpl();
184     uint256 finalREPBalance = rep.balanceOf(this);
185     m_disputeToken = disputeToken;
186     uint256 finalDisputeTokenBalance = disputeToken.balanceOf(this);
187     assert(finalREPBalance + finalDisputeTokenBalance >= initialREPBalance);
188   }
189 
190   // intentionally can be called by anyone, as no user input is used
191   function approveManagerToSpendDisputeTokens() external {
192     IERC20 disputeTokenAddress = getDisputeTokenAddress();
193     require(disputeTokenAddress.approve(m_owner, 2 ** 256 - 1));
194   }
195 
196   function getOwner() external view returns(address) {
197     return m_owner;
198   }
199 
200   function hasDisputed() external view returns(bool) {
201     return m_feeReceiver != 0;
202   }
203 
204   function feeReceiver() external view returns(address) {
205     require(m_feeReceiver != 0);
206     return m_feeReceiver;
207   }
208 
209   function getREP() public view returns(IERC20) {
210     return m_rep;
211   }
212 
213   function getDisputeTokenAddress() public view returns(IERC20) {
214     require(m_disputeToken != IERC20(address(this)));
215     return m_disputeToken;
216   }
217 
218   function getREPImpl() internal view returns(IERC20);
219   function disputeImpl() internal returns(IERC20 disputeToken);
220   function preDisputeCheck() internal;
221 
222   // it is ESSENTIAL that this function is kept internal
223   // otherwise it can allow taking over ownership
224   function baseInit(
225     address owner,
226     Market market,
227     uint256 feeWindowId,
228     uint256[] payoutNumerators,
229     bool invalid
230   ) internal {
231     m_owner = owner;
232     m_params = DisputerParams.Params(
233       market,
234       feeWindowId,
235       payoutNumerators,
236       invalid
237     );
238     // we remember REP address with which we were created to persist
239     // through forks and not break
240     m_rep = getREPImpl();
241     assert(m_rep.approve(m_owner, 2 ** 256 - 1));
242 
243     if (address(market) != 0) {
244       // this is a hack. Some tests create disputer with 0 as market address
245       // however mock ERC20 won't like approving 0 address
246       // so we skip approval in those cases
247       // TODO: fix those tests and remove conditional here
248       assert(m_rep.approve(market, 2 ** 256 - 1));
249     }
250 
251     // micro gas optimization, initialize with non-zero to make it cheaper
252     // to write during dispute
253     m_disputeToken = IERC20(address(this));
254   }
255 }
256 
257 // File: contracts/Disputer.sol
258 
259 /**
260  * Only the code that really interacts with Augur should be place here,
261  * the rest goes into BaseDisputer for better testability.
262  */
263 contract Disputer is BaseDisputer {
264   uint256 public m_windowStart;
265   uint256 public m_windowEnd;
266   bytes32 public m_payoutDistributionHash;
267   uint256 public m_roundNumber;
268 
269   // we will keep track of all contributions made so far
270   uint256 public m_cumulativeDisputeStake;
271   uint256 public m_cumulativeDisputeStakeInOurOutcome;
272   uint256 public m_cumulativeRoundsProcessed;
273 
274   constructor(
275     address owner,
276     Market market,
277     uint256 feeWindowId,
278     uint256[] payoutNumerators,
279     bool invalid
280   ) public {
281     if (address(market) == 0) {
282       // needed for easier instantiation for tests, etc.
283       // this will be a _very_ crappy uninitialized instance of Disputer
284       return;
285     }
286 
287     baseInit(owner, market, feeWindowId, payoutNumerators, invalid);
288 
289     Universe universe = market.getUniverse();
290     uint256 disputeRoundDuration = universe.getDisputeRoundDurationInSeconds();
291     m_windowStart = feeWindowId * disputeRoundDuration;
292     m_windowEnd = (feeWindowId + 1) * disputeRoundDuration;
293 
294     m_payoutDistributionHash = market.derivePayoutDistributionHash(
295       payoutNumerators,
296       invalid
297     );
298 
299     m_roundNumber = inferRoundNumber();
300 
301     processCumulativeRounds();
302   }
303 
304   function inferRoundNumber() public view returns(uint256) {
305     Market market = m_params.market;
306     Universe universe = market.getUniverse();
307     require(!universe.isForking());
308 
309     FeeWindow feeWindow = m_params.market.getFeeWindow();
310     require(
311       address(feeWindow) != 0,
312       "magic of choosing round number by timestamp only works during disputing"
313     );
314     // once there is a fee window, it always corresponds to next round
315     uint256 nextParticipant = market.getNumParticipants();
316     uint256 disputeRoundDuration = universe.getDisputeRoundDurationInSeconds();
317     uint256 nextParticipantFeeWindowStart = feeWindow.getStartTime();
318     require(m_windowStart >= nextParticipantFeeWindowStart);
319     uint256 feeWindowDifferenceSeconds = m_windowStart - nextParticipantFeeWindowStart;
320     require(feeWindowDifferenceSeconds % disputeRoundDuration == 0);
321     uint256 feeWindowDifferenceRounds = feeWindowDifferenceSeconds / disputeRoundDuration;
322     return nextParticipant + feeWindowDifferenceRounds;
323   }
324 
325   // anyone can call this to keep disputer up to date w.r.t. latest rounds sizes
326   function processCumulativeRounds() public {
327     Market market = m_params.market;
328     require(!market.isFinalized());
329     uint256 numParticipants = market.getNumParticipants();
330 
331     while (m_cumulativeRoundsProcessed < numParticipants && m_cumulativeRoundsProcessed < m_roundNumber) {
332       ReportingParticipant participant = market.getReportingParticipant(
333         m_cumulativeRoundsProcessed
334       );
335       uint256 stake = participant.getStake();
336       m_cumulativeDisputeStake += stake;
337       if (participant.getPayoutDistributionHash() == m_payoutDistributionHash) {
338         m_cumulativeDisputeStakeInOurOutcome += stake;
339       }
340       ++m_cumulativeRoundsProcessed;
341     }
342   }
343 
344   function shouldProcessCumulativeRounds() public view returns(bool) {
345     Market market = m_params.market;
346     require(!market.isFinalized());
347     uint256 numParticipants = market.getNumParticipants();
348     return m_cumulativeRoundsProcessed < m_roundNumber && m_cumulativeRoundsProcessed < numParticipants;
349   }
350 
351   function preDisputeCheck() internal {
352     // most frequent reasons for failure, to fail early and save gas
353     // solhint-disable-next-line not-rely-on-time
354     require(block.timestamp > m_windowStart && block.timestamp < m_windowEnd);
355   }
356 
357   /**
358    * This function should use as little gas as possible, as it will be called
359    * during rush time. Unnecessary operations are postponed for later.
360    *
361    * Can only be called once.
362    */
363   function disputeImpl() internal returns(IERC20) {
364     if (m_cumulativeRoundsProcessed < m_roundNumber) {
365       // hopefully we won't need it, we should prepare contract a few days
366       // before time T
367       processCumulativeRounds();
368     }
369 
370     Market market = m_params.market;
371 
372     // don't waste gas on safe math
373     uint256 roundSizeMinusOne = 2 * m_cumulativeDisputeStake - 3 * m_cumulativeDisputeStakeInOurOutcome - 1;
374 
375     ReportingParticipant crowdsourcerBefore = market.getCrowdsourcer(
376       m_payoutDistributionHash
377     );
378     uint256 alreadyContributed = address(
379       crowdsourcerBefore
380     ) == 0 ? 0 : crowdsourcerBefore.getStake();
381 
382     require(alreadyContributed < roundSizeMinusOne, "We are too late");
383 
384     uint256 optimalContributionSize = roundSizeMinusOne - alreadyContributed;
385     uint256 ourBalance = getREP().balanceOf(this);
386 
387     require(
388       market.contribute(
389         m_params.payoutNumerators,
390         m_params.invalid,
391         ourBalance > optimalContributionSize ? optimalContributionSize : ourBalance
392       )
393     );
394 
395     if (market.getNumParticipants() == m_roundNumber) {
396       // we are still within current round
397       return market.getCrowdsourcer(m_payoutDistributionHash);
398     } else {
399       // We somehow overfilled the round. This sucks, but let's try to recover.
400       ReportingParticipant participant = market.getWinningReportingParticipant(
401 
402       );
403       require(
404         participant.getPayoutDistributionHash() == m_payoutDistributionHash,
405         "Wrong winning participant?"
406       );
407       return IERC20(address(participant));
408     }
409   }
410 
411   function getREPImpl() internal view returns(IERC20) {
412     return m_params.market.getReputationToken();
413   }
414 }
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
79 }
80 
81 // File: contracts/augur/universe.sol
82 
83 interface Universe {
84   function getDisputeRoundDurationInSeconds() external view returns(uint256);
85   function isForking() external view returns(bool);
86 }
87 
88 // File: contracts/augur/reportingParticipant.sol
89 
90 /**
91  * This should've been an interface, but interfaces cannot inherit interfaces
92  */
93 contract ReportingParticipant is IERC20 {
94   function getStake() external view returns(uint256);
95   function getPayoutDistributionHash() external view returns(bytes32);
96 }
97 
98 // File: contracts/augur/market.sol
99 
100 interface Market {
101   function contribute(
102     uint256[] _payoutNumerators,
103     bool _invalid,
104     uint256 _amount
105   ) external returns(bool);
106 
107   function getReputationToken() external view returns(IERC20);
108 
109   function getUniverse() external view returns(Universe);
110 
111   function derivePayoutDistributionHash(
112     uint256[] _payoutNumerators,
113     bool _invalid
114   ) external view returns(bytes32);
115 
116   function getCrowdsourcer(
117     bytes32 _payoutDistributionHash
118   ) external view returns(ReportingParticipant);
119 
120   function getNumParticipants() external view returns(uint256);
121 
122   function getReportingParticipant(uint256 _index) external view returns(
123     ReportingParticipant
124   );
125 
126   function isFinalized() external view returns(bool);
127 
128   function getFeeWindow() external view returns(FeeWindow);
129 
130   function getWinningReportingParticipant() external view returns(
131     ReportingParticipant
132   );
133 }
134 
135 // File: contracts/DisputerParams.sol
136 
137 library DisputerParams {
138   struct Params {
139     Market market;
140     uint256 feeWindowId;
141     uint256[] payoutNumerators;
142     bool invalid;
143   }
144 }
145 
146 // File: contracts/BaseDisputer.sol
147 
148 /**
149  * Shared code between real disputer and mock disputer, to make test coverage
150  * better.
151  */
152 contract BaseDisputer is IDisputer {
153   address public m_owner;
154   address public m_feeReceiver = 0;
155   DisputerParams.Params public m_params;
156   IERC20 public m_rep;
157   IERC20 public m_disputeToken;
158 
159   /**
160    * As much as we can do during dispute, without actually interacting
161    * with Augur
162    */
163   function dispute(address feeReceiver) external {
164     require(m_feeReceiver == 0, "Can only dispute once");
165     preDisputeCheck();
166     require(feeReceiver != 0, "Must have valid fee receiver");
167     m_feeReceiver = feeReceiver;
168 
169     IERC20 rep = getREP();
170     uint256 initialREPBalance = rep.balanceOf(this);
171     IERC20 disputeToken = disputeImpl();
172     uint256 finalREPBalance = rep.balanceOf(this);
173     m_disputeToken = disputeToken;
174     uint256 finalDisputeTokenBalance = disputeToken.balanceOf(this);
175     assert(finalREPBalance + finalDisputeTokenBalance >= initialREPBalance);
176   }
177 
178   // intentionally can be called by anyone, as no user input is used
179   function approveManagerToSpendDisputeTokens() external {
180     IERC20 disputeTokenAddress = getDisputeTokenAddress();
181     require(disputeTokenAddress.approve(m_owner, 2 ** 256 - 1));
182   }
183 
184   function getOwner() external view returns(address) {
185     return m_owner;
186   }
187 
188   function hasDisputed() external view returns(bool) {
189     return m_feeReceiver != 0;
190   }
191 
192   function feeReceiver() external view returns(address) {
193     require(m_feeReceiver != 0);
194     return m_feeReceiver;
195   }
196 
197   function getREP() public view returns(IERC20) {
198     return m_rep;
199   }
200 
201   function getDisputeTokenAddress() public view returns(IERC20) {
202     require(m_disputeToken != IERC20(address(this)));
203     return m_disputeToken;
204   }
205 
206   function getREPImpl() internal view returns(IERC20);
207   function disputeImpl() internal returns(IERC20 disputeToken);
208   function preDisputeCheck() internal;
209 
210   // it is ESSENTIAL that this function is kept internal
211   // otherwise it can allow taking over ownership
212   function baseInit(
213     address owner,
214     Market market,
215     uint256 feeWindowId,
216     uint256[] payoutNumerators,
217     bool invalid
218   ) internal {
219     m_owner = owner;
220     m_params = DisputerParams.Params(
221       market,
222       feeWindowId,
223       payoutNumerators,
224       invalid
225     );
226     // we remember REP address with which we were created to persist
227     // through forks and not break
228     m_rep = getREPImpl();
229     assert(m_rep.approve(m_owner, 2 ** 256 - 1));
230 
231     if (address(market) != 0) {
232       // this is a hack. Some tests create disputer with 0 as market address
233       // however mock ERC20 won't like approving 0 address
234       // so we skip approval in those cases
235       // TODO: fix those tests and remove conditional here
236       assert(m_rep.approve(market, 2 ** 256 - 1));
237     }
238 
239     // micro gas optimization, initialize with non-zero to make it cheaper
240     // to write during dispute
241     m_disputeToken = IERC20(address(this));
242   }
243 }
244 
245 // File: contracts/Disputer.sol
246 
247 /**
248  * Only the code that really interacts with Augur should be place here,
249  * the rest goes into BaseDisputer for better testability.
250  */
251 contract Disputer is BaseDisputer {
252   uint256 public m_windowStart;
253   uint256 public m_windowEnd;
254   bytes32 public m_payoutDistributionHash;
255   uint256 public m_roundNumber;
256 
257   // we will keep track of all contributions made so far
258   uint256 public m_cumulativeDisputeStake;
259   uint256 public m_cumulativeDisputeStakeInOurOutcome;
260   uint256 public m_cumulativeRoundsProcessed;
261 
262   constructor(
263     address owner,
264     Market market,
265     uint256 feeWindowId,
266     uint256[] payoutNumerators,
267     bool invalid
268   ) public {
269     if (address(market) == 0) {
270       // needed for easier instantiation for tests, etc.
271       // this will be a _very_ crappy uninitialized instance of Disputer
272       return;
273     }
274 
275     baseInit(owner, market, feeWindowId, payoutNumerators, invalid);
276 
277     Universe universe = market.getUniverse();
278     uint256 disputeRoundDuration = universe.getDisputeRoundDurationInSeconds();
279     m_windowStart = feeWindowId * disputeRoundDuration;
280     m_windowEnd = (feeWindowId + 1) * disputeRoundDuration;
281 
282     m_payoutDistributionHash = market.derivePayoutDistributionHash(
283       payoutNumerators,
284       invalid
285     );
286 
287     m_roundNumber = inferRoundNumber();
288 
289     processCumulativeRounds();
290   }
291 
292   function inferRoundNumber() public view returns(uint256) {
293     Market market = m_params.market;
294     Universe universe = market.getUniverse();
295     require(!universe.isForking());
296 
297     FeeWindow feeWindow = m_params.market.getFeeWindow();
298     require(
299       address(feeWindow) != 0,
300       "magic of choosing round number by timestamp only works during disputing"
301     );
302     // once there is a fee window, it always corresponds to next round
303     uint256 nextParticipant = market.getNumParticipants();
304     uint256 disputeRoundDuration = universe.getDisputeRoundDurationInSeconds();
305     uint256 nextParticipantFeeWindowStart = feeWindow.getStartTime();
306     require(m_windowStart >= nextParticipantFeeWindowStart);
307     uint256 feeWindowDifferenceSeconds = m_windowStart - nextParticipantFeeWindowStart;
308     require(feeWindowDifferenceSeconds % disputeRoundDuration == 0);
309     uint256 feeWindowDifferenceRounds = feeWindowDifferenceSeconds / disputeRoundDuration;
310     return nextParticipant + feeWindowDifferenceRounds;
311   }
312 
313   // anyone can call this to keep disputer up to date w.r.t. latest rounds sizes
314   function processCumulativeRounds() public {
315     Market market = m_params.market;
316     require(!market.isFinalized());
317     uint256 numParticipants = market.getNumParticipants();
318 
319     while (m_cumulativeRoundsProcessed < numParticipants && m_cumulativeRoundsProcessed < m_roundNumber) {
320       ReportingParticipant participant = market.getReportingParticipant(
321         m_cumulativeRoundsProcessed
322       );
323       uint256 stake = participant.getStake();
324       m_cumulativeDisputeStake += stake;
325       if (participant.getPayoutDistributionHash() == m_payoutDistributionHash) {
326         m_cumulativeDisputeStakeInOurOutcome += stake;
327       }
328       ++m_cumulativeRoundsProcessed;
329     }
330   }
331 
332   function shouldProcessCumulativeRounds() public view returns(bool) {
333     Market market = m_params.market;
334     require(!market.isFinalized());
335     uint256 numParticipants = market.getNumParticipants();
336     return m_cumulativeRoundsProcessed < m_roundNumber && m_cumulativeRoundsProcessed < numParticipants;
337   }
338 
339   function preDisputeCheck() internal {
340     // most frequent reasons for failure, to fail early and save gas
341     // solhint-disable-next-line not-rely-on-time
342     require(block.timestamp > m_windowStart && block.timestamp < m_windowEnd);
343   }
344 
345   /**
346    * This function should use as little gas as possible, as it will be called
347    * during rush time. Unnecessary operations are postponed for later.
348    *
349    * Can only be called once.
350    */
351   function disputeImpl() internal returns(IERC20) {
352     if (m_cumulativeRoundsProcessed < m_roundNumber) {
353       // hopefully we won't need it, we should prepare contract a few days
354       // before time T
355       processCumulativeRounds();
356     }
357 
358     Market market = m_params.market;
359 
360     // don't waste gas on safe math
361     uint256 roundSizeMinusOne = 2 * m_cumulativeDisputeStake - 3 * m_cumulativeDisputeStakeInOurOutcome - 1;
362 
363     ReportingParticipant crowdsourcerBefore = market.getCrowdsourcer(
364       m_payoutDistributionHash
365     );
366     uint256 alreadyContributed = address(
367       crowdsourcerBefore
368     ) == 0 ? 0 : crowdsourcerBefore.getStake();
369 
370     require(alreadyContributed < roundSizeMinusOne, "We are too late");
371 
372     uint256 optimalContributionSize = roundSizeMinusOne - alreadyContributed;
373     uint256 ourBalance = getREP().balanceOf(this);
374 
375     require(
376       market.contribute(
377         m_params.payoutNumerators,
378         m_params.invalid,
379         ourBalance > optimalContributionSize ? optimalContributionSize : ourBalance
380       )
381     );
382 
383     if (market.getNumParticipants() == m_roundNumber) {
384       // we are still within current round
385       return market.getCrowdsourcer(m_payoutDistributionHash);
386     } else {
387       // We somehow overfilled the round. This sucks, but let's try to recover.
388       ReportingParticipant participant = market.getWinningReportingParticipant(
389 
390       );
391       require(
392         participant.getPayoutDistributionHash() == m_payoutDistributionHash,
393         "Wrong winning participant?"
394       );
395       return IERC20(address(participant));
396     }
397   }
398 
399   function getREPImpl() internal view returns(IERC20) {
400     return m_params.market.getReputationToken();
401   }
402 }
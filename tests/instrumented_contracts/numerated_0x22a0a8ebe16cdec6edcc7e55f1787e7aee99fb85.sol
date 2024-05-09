1 pragma solidity ^0.4.25;
2 
3 //
4 //   ____                                      ______                        __      
5 //  /\  _`\                                   /\__  _\                      /\ \__   
6 //  \ \,\L\_\  __  __  _____      __   _ __   \/_/\ \/ _ __   __  __    ____\ \ ,_\  
7 //   \/_\__ \ /\ \/\ \/\ '__`\  /'__`\/\`'__\    \ \ \/\`'__\/\ \/\ \  /',__\\ \ \/  
8 //     /\ \L\ \ \ \_\ \ \ \L\ \/\  __/\ \ \/      \ \ \ \ \/ \ \ \_\ \/\__, `\\ \ \_ 
9 //     \ `\____\ \____/\ \ ,__/\ \____\\ \_\       \ \_\ \_\  \ \____/\/\____/ \ \__\
10 //      \/_____/\/___/  \ \ \/  \/____/ \/_/        \/_/\/_/   \/___/  \/___/   \/__/
11 //                       \ \_\               
12 //                        \/_/                                                        
13 //
14 //  ETHEREUM PSEUDO-INVESTMENT SMART CONTRACT
15 //
16 //  Make a payment to this address to become a participant. Once invested,
17 //  any following transactions of any amount will request dividend payout
18 //  for you and increase invested amount.
19 //
20 //  Easter Eggs:
21 //  1. If a function "advertise" called by any ethereum address with supplied
22 //  referring address and at least 0.15 ETH, and referring address makes
23 //  payments in future, referrer address will receive 3% referral bonuses.
24 //  E.g., in geth console you can do the following:
25 //
26 //  var abi = eth.contract(<TrustABI>);
27 //  var contract = abi.at("<TrustAddress>");
28 //  var calldata = contract.advertise.getData("<TargetAddress>");
29 //  web3.eth.sendTransaction({from:"<YourAddress>", to:"<TrustAddress>",
30 //      data: calldata, value: web3.toWei(0.15, "ether"), gas:200000});
31 //
32 //  Copypaste and insert your values into "<>" placeholders.
33 //
34 //  Referring wallet will receive an advertisement payment of 1 WEI and your
35 //  supplied ETH value will be invested. PLEASE NOTE that 0.15 ETH price
36 //  may be changed - see "Read Contract" tab on etherscan.io.
37 //
38 //  2. Gold investor receive instant 3% bonus payments, when regular
39 //  investors make payments greater than 0.05 ETH on each N-th transaction.
40 //
41 //  3. Gold referrer will receive additional bonus in similar way as the gold
42 //  investor.
43 //
44 //  Please do not send payments via contracts and other unusual ways -
45 //  these payments may be lost. Recommended gas limit per transaction is
46 //  200000.
47 //
48 //  Initial GAIN:                               4%
49 //  Referral Bonus:                             3% from investments
50 //  Gold Bonus:                                 3% from every N-th investment
51 //  Project Fee:                                3% from dividends
52 //  Minimum investment:                         No limit
53 //  Other questions:                            apiman45445 at protonmail.com
54 //
55 
56 contract SuperTrust {
57 	// Generate public view getters for game settings and stats
58 	address public admin = msg.sender;
59 	uint256 public round = 0;
60 	uint256 public payoutFee;
61 	uint256 public goldBonus;
62 	uint256 public referralBonus;
63 	uint256 public investorGain;
64 	uint256 public bonusInterval;
65 	uint256 public bonusThreshold;
66 	uint256 public advPrice;
67 	uint256 public investorCount;
68 	uint256 public avgMinedPerDay;
69 	uint256 public collectedFee = 0;
70 	bool public lastRound = false; 
71     // Hide some data from public access to prevent manipulations
72 	mapping(uint256 => mapping(address => Investor)) private investors;
73 	mapping(uint256 => mapping(address => address)) private referrals;
74 	address[2] private board;
75 	uint256 private roulett;
76 
77 	struct Investor {
78 		uint256 deposit;
79 		uint256 block;
80 		uint256 refBalance;
81 		bool banned;
82 	}
83 
84 	function globalReinitialization() private {
85 		payoutFee = 3;
86 		goldBonus = 3;
87 		referralBonus = 3;
88 		investorGain = 4;
89 		bonusInterval = 5;
90 		bonusThreshold = 0.05 ether;
91 		advPrice = 0.15 ether;
92 		investorCount = 0;
93 		avgMinedPerDay = 5900;
94 		board = [admin, admin];
95 		roulett = bonusInterval * board.length;
96 	}
97 
98 	constructor () public {
99 		globalReinitialization();
100 	}
101 
102 	//
103 	// Administration
104 	//
105 
106 	event LogAdminRetired(address, address, address);
107 	event LogPayoutFeeChanged(address, uint256, uint256);
108 	event LogGoldBonusChanged(address, uint256, uint256);
109 	event LogReferralBonusChanged(address, uint256, uint256);
110 	event LogInvestorGainChanged(address, uint256, uint256);
111 	event LogBonusIntervalChanged(address, uint256, uint256);
112 	event LogBonusThresholdChanged(address, uint256, uint256);
113 	event LogAdvPriceChanged(address, uint256, uint256);
114 	event LogAvgMinedPerDayChanged(address, uint256, uint256);
115 	event LogReferrerBanned(address, address, string);
116 
117 	modifier asAdmin {
118 		require(msg.sender == admin, "unauthorized function call");
119 		_;
120 	}
121 
122 	function retireAdmin(address newAdmin) public asAdmin {
123 		emit LogAdminRetired(msg.sender, admin, newAdmin);
124 		admin = newAdmin;
125 	}
126 
127 	function setPayoutFee(uint256 newValue) public asAdmin {
128 		// Administrator cannot withdraw all money at any time.
129 		require((newValue > 0) && (newValue <= 10));
130 		emit LogPayoutFeeChanged(msg.sender, payoutFee, newValue);
131 		payoutFee = newValue;
132 	}
133 
134 	function setGoldBonus(uint256 newValue) public asAdmin {
135 		require((newValue > 0) && (newValue <= 10));
136 		emit LogGoldBonusChanged(msg.sender, goldBonus, newValue);
137 		goldBonus = newValue;
138 	}
139 
140 	function setReferralBonus(uint256 newValue) public asAdmin {
141 		require((newValue > 0) && (newValue <= 10));
142 		emit LogReferralBonusChanged(msg.sender, referralBonus, newValue);
143 		referralBonus = newValue;
144 	}
145 
146 	function setInvestorGain(uint256 newValue) public asAdmin {
147 		require((newValue > 0) && (newValue <= 5));
148 		emit LogInvestorGainChanged(msg.sender, investorGain, newValue);
149 		investorGain = newValue;
150 	}
151 
152 	function setBonusInterval(uint256 newValue) public asAdmin {
153 		require(newValue > 0);
154 		emit LogBonusIntervalChanged(msg.sender, bonusInterval, newValue);
155 		bonusInterval = newValue;
156 		roulett = bonusInterval * board.length;
157 	}
158 
159 	function setBonusThreshold(uint256 newValue) public asAdmin {
160 		emit LogBonusThresholdChanged(msg.sender, bonusThreshold, newValue);
161 		bonusThreshold = newValue;
162 	}
163 
164 	function setAdvPrice(uint256 newValue) public asAdmin {
165 		emit LogAdvPriceChanged(msg.sender, advPrice, newValue);
166 		advPrice = newValue;
167 	}
168 
169 	function setAvgMinedPerDay(uint256 newValue) public asAdmin {
170 		require(newValue >= 4000);
171 		emit LogAvgMinedPerDayChanged(msg.sender, avgMinedPerDay, newValue);
172 		avgMinedPerDay = newValue;
173 	}
174 
175 	function collectFee(uint256 percent) public asAdmin {
176 		require(percent <= 100);
177 		uint256 amount = (collectedFee * percent) / 100;
178 		require(amount <= collectedFee);
179 		collectedFee -= amount;
180 		admin.transfer(amount);
181 	}
182 
183 	function banReferrer(address target) public asAdmin {
184 		require(target != admin);
185 		emit LogReferrerBanned(msg.sender, target, "Violating referrer banned");
186 		investors[round][target].banned = true;
187 		board[1] = admin; // refBonus of admin is always zero
188 	}
189 
190 	function unbanReferrer(address target) public asAdmin {
191 		require(target != admin);
192 		emit LogReferrerBanned(msg.sender, target, "Referrer unbanned");
193 		investors[round][target].banned = false;
194 	}
195 
196 	//
197 	// Game logic
198 	//
199 
200 	event LogGoldBonus(address, address, uint256);
201 	event LogReferralBonus(address, address, uint256);
202 	event LogAdvertisement(address, address, uint256);
203 	event LogNewInvestor(address, uint256);
204 	event LogRoundEnd(address, uint256, uint256, uint256);
205 	event LogBoardChange(address, uint256, string);
206 
207 	function payoutBonuses() private {
208 		// GOLD bonus payout, if any
209 		roulett--;
210 		if (roulett % bonusInterval == 0) {
211 			uint256 bonusAmount = (msg.value * goldBonus) / 100;
212 			uint256 winnIdx = roulett / bonusInterval;
213 			if ((board[winnIdx] != msg.sender) && (board[winnIdx] != admin)) {
214 				// Payouts to itself are not applicable, admin has its own reward
215 				emit LogGoldBonus(msg.sender, board[winnIdx], bonusAmount);
216 				payoutBalanceCheck(board[winnIdx], bonusAmount);
217 			}
218 		}
219 		if (roulett == 0)
220 			roulett = bonusInterval * board.length;
221 	}
222 
223 	function payoutReferrer() private {
224 		uint256 bonusAmount = (msg.value * referralBonus) / 100;
225 		address referrer = referrals[round][msg.sender];
226 		if (!investors[round][referrer].banned) {
227 			if (referrer != admin)
228 				investors[round][referrer].refBalance += bonusAmount;
229 			emit LogReferralBonus(msg.sender, referrer, bonusAmount);
230 			updateGoldReferrer(referrer);
231 			payoutBalanceCheck(referrer, bonusAmount);
232 		}
233 	}
234 
235 	function payoutBalanceCheck(address to, uint256 value) private {
236 		if (to == admin) {
237 			collectedFee += value;
238 			return;
239 		}
240 		if (value > (address(this).balance - 0.01 ether)) {
241 			if (lastRound)
242 				selfdestruct(admin);
243 			emit LogRoundEnd(msg.sender, value, address(this).balance, round);
244 			globalReinitialization();
245 			round++;
246 			return;
247 		}
248 		to.transfer(value);
249 	}
250 
251 	function processDividends() private {
252 		if (investors[round][msg.sender].deposit != 0) {
253 			// ((investorGain% from deposit) * minedBlocks) / avgMinedPerDay
254 			uint256 deposit = investors[round][msg.sender].deposit;
255 			uint256 previousBlock = investors[round][msg.sender].block;
256 			uint256 minedBlocks = block.number - previousBlock;
257 			uint256 dailyIncome = (deposit * investorGain) / 100;
258 			uint256 divsAmount = (dailyIncome * minedBlocks) / avgMinedPerDay;
259 			collectedFee += (divsAmount * payoutFee) / 100;
260 			payoutBalanceCheck(msg.sender, divsAmount);	
261 		}
262 		else if (msg.value != 0) {
263 			emit LogNewInvestor(msg.sender, ++investorCount);
264 		}
265 		investors[round][msg.sender].block = block.number;
266 		investors[round][msg.sender].deposit += msg.value;
267 	}
268 
269 	function updateGoldInvestor(address candidate) private {
270 		uint256 candidateDeposit = investors[round][candidate].deposit;
271 		if (candidateDeposit > investors[round][board[0]].deposit) {
272 			board[0] = candidate;
273 			emit LogBoardChange(candidate, candidateDeposit,
274 				"Congrats! New Gold Investor!");
275 		}
276 	}
277 
278 	function updateGoldReferrer(address candidate) private {
279 		// Admin can refer participants, but will not be the gold referrer.
280 		if ((candidate != admin) && (!investors[round][candidate].banned)) {
281 			uint256 candidateRefBalance = investors[round][candidate].refBalance;
282 			uint256 goldReferrerBalance = investors[round][board[1]].refBalance;
283 			if (candidateRefBalance > goldReferrerBalance) {
284 				board[1] = candidate;
285 				emit LogBoardChange(candidate, candidateRefBalance,
286 					"Congrats! New Gold Referrer!");
287 			}
288 		}
289 	}
290 
291 	function regularPayment() private {
292 		if (msg.value >= bonusThreshold) {
293 			payoutBonuses();
294 			if (referrals[round][msg.sender] != 0)
295 				payoutReferrer();
296 		}
297 		processDividends();
298 		updateGoldInvestor(msg.sender);
299 	}
300 
301 	function advertise(address targetAddress) external payable {
302 		// Any violation results in failed transaction
303 		if (investors[round][msg.sender].banned)
304 			revert("You are violating the rules and banned");
305 		if ((msg.sender != admin) && (msg.value < advPrice))
306 			revert("Need more ETH to make an advertiement");
307 		if (investors[round][targetAddress].deposit != 0)
308 			revert("Advertising address is already an investor");
309 		if (referrals[round][targetAddress] != 0)
310 			revert("Address already advertised");
311 
312 		emit LogAdvertisement(msg.sender, targetAddress, msg.value);
313 		referrals[round][targetAddress] = msg.sender;
314 		targetAddress.transfer(1 wei);
315 		regularPayment();
316 	}
317 
318 	function () external payable {
319 		regularPayment();
320 	} 
321 }
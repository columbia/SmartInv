1 pragma solidity 0.5.1;
2 contract zBetForFun {
3 	address payable gadrOwner;
4 	uint32 gnLastContestID = 0;
5 	uint32 gnLastWagerID = 0;
6 	uint gnTotalYesBets = 0;
7 	uint gnTotalNoBets = 0;
8 	uint gnTotalFees = 0;
9 
10 	struct clsContest {
11 		uint nSeconds_Created;
12 		string sDescription;
13 		string sShortDescription;
14 		uint nSeconds_Expiration;
15 		uint8 nFee;
16 		uint nTotal_Yes;
17 		uint nTotal_No;
18 		uint nSeconds_Resolved;
19 		int8 n8Result_NYP;
20 		uint nTotal_Winners;
21 		uint nTotal_Losers;
22 	}
23 
24 	struct clsWager {
25 		uint nSeconds_Created;
26 		address adrPlayer;
27 		uint nBetAmount;
28 		int8 n8ChoiceNY;
29 		uint nSeconds_Paid;
30 		int8 n8LWP;
31 		uint nFeeCharged;
32 		uint nPaymentAmount;
33 	}
34 
35 	struct clsUser {
36 		uint nBalance;
37 		uint nSeconds_LastWithdrawal;
38 	}
39 
40 	mapping(uint32 => clsContest) gmapContests;
41 	mapping (uint32 => mapping (uint32 => clsWager)) gmapWagers;
42 	mapping(address => clsUser) gmapUsers;
43 
44 	constructor() public { gadrOwner = msg.sender; }
45 
46 	modifier onlyByOwner()
47 	{
48 		require(
49 			msg.sender == gadrOwner, "Sender not authorized."
50 		);
51 		_;
52 	}
53 
54 	event Pending_Bets(address indexed Player, uint Player_Balance, string Contest, bytes3 Player_Choice, uint Player_Bet, uint Total_Yes, uint Total_No, uint Total_Both, uint Fee_Percent);
55 	event Finalized_Bets(address indexed Player, uint Player_Balance, string Contest, bytes3 Contest_Result, bytes3 Player_Choice, bytes4 Player_Result, uint Player_Bet, uint Total_Winners, uint Total_Losers, uint Total_Bets, uint Fee_Percent, uint Fee_Charged, uint Player_Paid);
56 	event Withdrawals (address indexed Player, uint Withdrawal_Amount);
57 
58 	function zKill() onlyByOwner() external {selfdestruct (gadrOwner);}
59 	
60 	function zEventLog_Pending_Bets() private {
61 		emit Pending_Bets(msg.sender,
62 			gmapUsers[msg.sender].nBalance,
63 			gmapContests[gnLastContestID].sShortDescription, 
64 			zYesNoToBytes(gmapWagers[gnLastContestID][gnLastWagerID].n8ChoiceNY),
65 			gmapWagers[gnLastContestID][gnLastWagerID].nBetAmount,
66 			gnTotalYesBets,
67 			gnTotalNoBets,
68 			gnTotalYesBets + gnTotalNoBets, 
69 			uint(gmapContests[gnLastContestID].nFee) * 10000000000000000);
70 	}
71 
72 	function zYesNoToBytes(int8 nYesNo) private pure returns (bytes3 b3YesNo) {
73 		b3YesNo = "No";
74 		if (nYesNo == 1) {
75 			b3YesNo = "Yes";
76 		}
77 	}
78 	
79 	function zEventLog_Finalized_Bets(uint32 i) private {
80 		emit Finalized_Bets(gmapWagers[gnLastContestID][i].adrPlayer,
81 			gmapUsers[gmapWagers[gnLastContestID][i].adrPlayer].nBalance,
82 			gmapContests[gnLastContestID].sShortDescription,
83 			zYesNoTieToBytes(gmapContests[gnLastContestID].n8Result_NYP), 
84 			zYesNoToBytes(gmapWagers[gnLastContestID][i].n8ChoiceNY), 
85 			zYesNoPushToBytes(gmapWagers[gnLastContestID][i].n8LWP),
86 			gmapWagers[gnLastContestID][i].nBetAmount,
87 			gmapContests[gnLastContestID].nTotal_Winners,
88 			gmapContests[gnLastContestID].nTotal_Losers,
89 			gmapContests[gnLastContestID].nTotal_Winners + gmapContests[gnLastContestID].nTotal_Losers,
90 			uint(gmapContests[gnLastContestID].nFee) * 10000000000000000,
91 			gmapWagers[gnLastContestID][i].nFeeCharged,
92 			gmapWagers[gnLastContestID][i].nPaymentAmount);
93 	}
94 
95 	function zYesNoPushToBytes(int8 nYesNoPush) private pure returns (bytes4 b4YesNoPush) {
96 		b4YesNoPush = "Lost";
97 		if (nYesNoPush == 1) {
98 			b4YesNoPush = "Won";
99 		}
100 		if (nYesNoPush == 2) {
101 			b4YesNoPush = "Push";
102 		}
103 	}
104 
105 	function zYesNoTieToBytes(int8 nYesNoTie) private pure returns (bytes3 b3YesNoTie) {
106 		b3YesNoTie = "No";
107 		if (nYesNoTie == 1) {
108 			b3YesNoTie = "Yes";
109 		}
110 		if (nYesNoTie == 2) {
111 			b3YesNoTie = "Tie";
112 		}
113 		return b3YesNoTie;
114 	}
115 
116 	function zEventLog_Withdrawals(uint nWithdrawal_Amount) private {
117 		emit Withdrawals(msg.sender, nWithdrawal_Amount);
118 	}
119 
120 	
121 	function zGetGlobals() external onlyByOwner() view returns (address adrOwner, uint32 nLastContestID, uint32 nLastWagerID, uint nTotalYesBets, uint nTotalNoBets, uint nTotalFees) {
122 		adrOwner = gadrOwner;
123 		nLastContestID = gnLastContestID;
124 		nLastWagerID = gnLastWagerID;
125 		nTotalYesBets = gnTotalYesBets;
126 		nTotalNoBets = gnTotalNoBets;
127 		nTotalFees = gnTotalFees;
128 	}
129 
130 	function zAddWager (int8 n8ChoiceNY) external payable {
131 		require(msg.value > 0 && block.timestamp < gmapContests[gnLastContestID].nSeconds_Expiration);
132 		gnLastWagerID++;
133 		gmapWagers[gnLastContestID][gnLastWagerID].nSeconds_Created = block.timestamp;
134 		gmapWagers[gnLastContestID][gnLastWagerID].adrPlayer = msg.sender;
135 		gmapWagers[gnLastContestID][gnLastWagerID].nBetAmount = msg.value;
136 		gmapWagers[gnLastContestID][gnLastWagerID].n8ChoiceNY = n8ChoiceNY;
137 		if (n8ChoiceNY == 1) {
138 			gnTotalYesBets += msg.value;
139 		} else {
140 			gnTotalNoBets += msg.value;
141 		}
142 		zEventLog_Pending_Bets();
143 	}
144 
145 	function zGetOneWager_1(uint32 nContestID, uint32 nWagerID) external onlyByOwner() view returns (
146 		uint nSeconds_Created,
147 		address adrPlayer,
148 		int8 n8ChoiceNY,
149 		uint nBetAmount,
150 		uint nTotalYesBets,
151 		uint nTotalNoBets) {
152 		nSeconds_Created = gmapWagers[nContestID][nWagerID].nSeconds_Created;
153 		adrPlayer = gmapWagers[nContestID][nWagerID].adrPlayer;
154 		n8ChoiceNY = gmapWagers[nContestID][nWagerID].n8ChoiceNY;
155 		nBetAmount = gmapWagers[nContestID][nWagerID].nBetAmount;
156 		nTotalYesBets = gnTotalYesBets;
157 		nTotalNoBets = gnTotalNoBets;
158 	}
159 
160 	function zGetOneWager_2(uint32 nContestID, uint32 nWagerID) external onlyByOwner() view returns (
161 		int8 n8LWP,
162 		uint nSeconds_Paid,
163 		uint nPaymentAmount,
164 		uint nFeeCharged) {
165 		n8LWP = gmapWagers[nContestID][nWagerID].n8LWP;
166 		nSeconds_Paid = gmapWagers[nContestID][nWagerID].nSeconds_Paid;
167 		nPaymentAmount = gmapWagers[nContestID][nWagerID].nPaymentAmount;
168 		nFeeCharged = gmapWagers[nContestID][nWagerID].nFeeCharged;
169 	}
170 
171 	function zGetAllWagers_1 (uint32 nContestID) external onlyByOwner() view returns (uint[] memory anSeconds_Created, address[] memory aadrPlayer, int8[] memory an8ChoiceNY, uint[] memory anBetAmount) {
172 		anSeconds_Created = new uint[](gnLastWagerID+1);
173 		aadrPlayer = new address[](gnLastWagerID+1);
174 		an8ChoiceNY = new int8[](gnLastWagerID+1);
175 		anBetAmount = new uint[](gnLastWagerID+1);
176 
177 		for (uint32 i = 1; i <= gnLastWagerID; i++) {
178 			clsWager memory objWager = gmapWagers[nContestID][i];
179 			anSeconds_Created[i] = objWager.nSeconds_Created;
180 			aadrPlayer[i] = objWager.adrPlayer;
181 			an8ChoiceNY[i] = objWager.n8ChoiceNY;
182 			anBetAmount[i] = objWager.nBetAmount;
183 		}
184 	}
185 
186 	function zGetAllWagers_2 (uint32 nContestID) external onlyByOwner() view returns (int8[] memory an8LWP, uint[] memory anSeconds_Paid, uint[] memory anPaymentAmount, uint[] memory anFeeCharged) {
187 		an8LWP = new int8[](gnLastWagerID+1);
188 		anSeconds_Paid = new uint[](gnLastWagerID+1);
189 		anPaymentAmount = new uint[](gnLastWagerID+1);
190 		anFeeCharged = new uint[](gnLastWagerID+1);
191 
192 		for (uint32 i = 1; i <= gnLastWagerID; i++) {
193 			clsWager memory objWager = gmapWagers[nContestID][i];
194 			an8LWP[i] = objWager.n8LWP;
195 			anSeconds_Paid[i] = objWager.nSeconds_Paid;
196 			anPaymentAmount[i] = objWager.nPaymentAmount;
197 			anFeeCharged[i] = objWager.nFeeCharged;
198 		}
199 	}
200 	
201 	function zAddContest(string calldata sDescription, string calldata sShortDescription, uint32 nSeconds_Expiration, uint8 nFee) external onlyByOwner() {
202 		gnLastContestID++;
203 		gnLastWagerID = 0;
204 		gnTotalYesBets = 0;
205 		gnTotalNoBets = 0;
206 		gmapContests[gnLastContestID].nSeconds_Created = block.timestamp;
207 		gmapContests[gnLastContestID].sDescription = sDescription;
208 		gmapContests[gnLastContestID].sShortDescription = sShortDescription;
209 		gmapContests[gnLastContestID].nSeconds_Expiration = nSeconds_Expiration;
210 		gmapContests[gnLastContestID].nFee = nFee;
211 	}
212 
213 	function zGetOneContest_1(uint32 nContestID) external onlyByOwner() view returns (
214 		uint nSeconds_Created,
215 		string memory sDescription,
216 		string memory sShortDescription,
217 		uint nSeconds_Expiration,
218 		uint nSeconds_Resolved,
219 		int8 n8Result_NYP) {
220 		nSeconds_Created = gmapContests[nContestID].nSeconds_Created;
221 		sDescription = gmapContests[nContestID].sDescription;
222 		sShortDescription = gmapContests[nContestID].sShortDescription;
223 		nSeconds_Expiration = gmapContests[nContestID].nSeconds_Expiration;
224 		nSeconds_Resolved = gmapContests[nContestID].nSeconds_Resolved;
225 		n8Result_NYP = gmapContests[nContestID].n8Result_NYP;
226 	}
227 
228 	function zGetOneContest_2(uint32 nContestID) external onlyByOwner() view returns (
229 		uint nTotal_Yes,
230 		uint nTotal_No,
231 		uint nTotal_Winners,
232 		uint nTotal_Losers,
233 		uint nFee) {
234 		nTotal_Yes = gmapContests[nContestID].nTotal_Yes;
235 		nTotal_No = gmapContests[nContestID].nTotal_No;
236 		nTotal_Winners = gmapContests[nContestID].nTotal_Winners;
237 		nTotal_Losers = gmapContests[nContestID].nTotal_Losers;
238 		nFee = gmapContests[nContestID].nFee;
239 	}
240 
241 	function zGetAllContests_1 () external onlyByOwner() view returns (uint[] memory anSeconds_Created, uint[] memory anSeconds_Expiration, uint[] memory anSeconds_Resolved, int8[] memory an8Result_NYP) {
242 		anSeconds_Created = new uint[](gnLastContestID+1);
243 		anSeconds_Expiration = new uint[](gnLastContestID+1);
244 		anSeconds_Resolved = new uint[](gnLastContestID+1);
245 		an8Result_NYP = new int8[](gnLastContestID+1);
246 
247 		for (uint32 i = 1; i <= gnLastContestID; i++) {
248 			clsContest memory objContest = gmapContests[i];
249 			anSeconds_Created[i] = objContest.nSeconds_Created;
250 			anSeconds_Expiration[i] = objContest.nSeconds_Expiration;
251 			anSeconds_Resolved[i] = objContest.nSeconds_Resolved;
252 			an8Result_NYP[i]= objContest.n8Result_NYP;
253 		}
254 	}
255 
256 	function zGetAllContests_2 () external onlyByOwner() view returns (uint[] memory anTotal_Yes, uint[] memory anTotal_No, uint[] memory anTotal_Winners, uint[] memory anTotal_Losers, uint[] memory anFee) {
257 		anTotal_Yes = new uint[](gnLastContestID+1);
258 		anTotal_No = new uint[](gnLastContestID+1);
259 		anTotal_Winners = new uint[](gnLastContestID+1);
260 		anTotal_Losers = new uint[](gnLastContestID+1);
261 		anFee = new uint[](gnLastContestID+1);
262 
263 		for (uint32 i = 1; i <= gnLastContestID; i++) {
264 			clsContest memory objContest = gmapContests[i];
265 			anTotal_Yes[i] = objContest.nTotal_Yes;
266 			anTotal_No[i] = objContest.nTotal_No;
267 			anTotal_Winners[i] = objContest.nTotal_Winners;
268 			anTotal_Losers[i] = objContest.nTotal_Losers;
269 			anFee[i]= objContest.nFee;
270 		}
271 	}
272 	
273 	function zSetContestResult(int8 n8Result_NYP) external onlyByOwner() {
274 		require(gmapContests[gnLastContestID].nSeconds_Resolved == 0);
275 		uint nRemainingTotalLosses;
276 		uint32 i;
277 		clsWager memory objWager;
278 		uint8 nFee_LargePerc = 100 - gmapContests[gnLastContestID].nFee;
279 		uint8 nFee_SmallPerc = gmapContests[gnLastContestID].nFee;
280 		gmapContests[gnLastContestID].n8Result_NYP = n8Result_NYP;
281 		gmapContests[gnLastContestID].nTotal_Yes = gnTotalYesBets;
282 		gmapContests[gnLastContestID].nTotal_No = gnTotalNoBets;
283 		gmapContests[gnLastContestID].nSeconds_Resolved = block.timestamp;
284 
285 		if (n8Result_NYP == 1) {
286 			nRemainingTotalLosses = gnTotalNoBets;
287 			gmapContests[gnLastContestID].nTotal_Winners = gnTotalYesBets;
288 			gmapContests[gnLastContestID].nTotal_Losers = gnTotalNoBets;
289 		} else {
290 			nRemainingTotalLosses = gnTotalYesBets;
291 			gmapContests[gnLastContestID].nTotal_Winners = gnTotalNoBets;
292 			gmapContests[gnLastContestID].nTotal_Losers = gnTotalYesBets;
293 		}
294 
295 		if (n8Result_NYP == 2) {
296 			for (i = 1; i <= gnLastWagerID; i++) {
297 				gmapWagers[gnLastContestID][i].nSeconds_Paid = block.timestamp;
298 				gmapWagers[gnLastContestID][i].n8LWP = 2;
299 				gmapWagers[gnLastContestID][i].nPaymentAmount = gmapWagers[gnLastContestID][i].nBetAmount;
300 				gmapUsers[gmapWagers[gnLastContestID][i].adrPlayer].nBalance += gmapWagers[gnLastContestID][i].nBetAmount;
301 				gmapContests[gnLastContestID].nTotal_Winners = 0;
302 				gmapContests[gnLastContestID].nTotal_Losers = 0;
303 			}	
304 		} else {
305 // Process Winners
306 			for (i = 1; i <= gnLastWagerID; i++) {
307 				gmapWagers[gnLastContestID][i].nSeconds_Paid = block.timestamp;
308 				objWager = gmapWagers[gnLastContestID][i];
309 				if (objWager.n8ChoiceNY == n8Result_NYP) {
310 					gmapWagers[gnLastContestID][i].n8LWP = 1;
311 					if (nRemainingTotalLosses <= objWager.nBetAmount) {
312 						gmapWagers[gnLastContestID][i].nPaymentAmount = objWager.nBetAmount + (nRemainingTotalLosses * nFee_LargePerc / 100);
313 						gnTotalFees += nRemainingTotalLosses * nFee_SmallPerc / 100;
314 						gmapWagers[gnLastContestID][i].nFeeCharged = nRemainingTotalLosses * nFee_SmallPerc / 100;
315 						nRemainingTotalLosses = 0;
316 					} else {
317 						gmapWagers[gnLastContestID][i].nPaymentAmount = objWager.nBetAmount + (objWager.nBetAmount * nFee_LargePerc / 100);
318 						gnTotalFees += objWager.nBetAmount * nFee_SmallPerc / 100;
319 						gmapWagers[gnLastContestID][i].nFeeCharged = objWager.nBetAmount * nFee_SmallPerc / 100;
320 						nRemainingTotalLosses -= objWager.nBetAmount;
321 					}
322 				}
323 			}
324 
325 // Process Losers
326 			for (i = gnLastWagerID; i > 0; i--) {
327 				objWager = gmapWagers[gnLastContestID][i];
328 				if (objWager.n8ChoiceNY != n8Result_NYP) {
329 					if (nRemainingTotalLosses <= objWager.nBetAmount) {
330 						gmapWagers[gnLastContestID][i].nPaymentAmount = nRemainingTotalLosses;
331 						nRemainingTotalLosses = 0;
332 					} else {
333 						gmapWagers[gnLastContestID][i].nPaymentAmount = objWager.nBetAmount;
334 						nRemainingTotalLosses -= objWager.nBetAmount;
335 					}
336 				}
337 				gmapUsers[gmapWagers[gnLastContestID][i].adrPlayer].nBalance += gmapWagers[gnLastContestID][i].nPaymentAmount;
338 			}
339 		}
340 		for (i = 1; i <= gnLastWagerID; i++) {
341 			zEventLog_Finalized_Bets(i);
342 		}
343 		
344 	}
345 	
346 	function zGetOneUser(address adrUserAddress) external onlyByOwner() view returns (
347 		uint nBalance,
348 		uint nSeconds_LastWithdrawal) {
349 		nBalance = gmapUsers[adrUserAddress].nBalance;
350 		nSeconds_LastWithdrawal = gmapUsers[adrUserAddress].nSeconds_LastWithdrawal;
351 	}
352 
353 	function zUserWithdrawal() external {
354 		require(gmapUsers[msg.sender].nBalance > 0);
355 		uint nBalance = gmapUsers[msg.sender].nBalance;
356 		gmapUsers[msg.sender].nBalance = 0;
357 		msg.sender.transfer(nBalance);
358 		zEventLog_Withdrawals(nBalance);
359 	}
360 
361 	function zFeesWithdrawal() external onlyByOwner() {
362 		require(gnTotalFees > 0);
363 		uint nFees = gnTotalFees;
364 		gnTotalFees = 0;
365 		msg.sender.transfer(nFees);
366 	}
367 
368 	function zGetContestDescription() external view returns (string memory sDescription) {
369 		if (block.timestamp >= gmapContests[gnLastContestID].nSeconds_Expiration) {
370 			sDescription = "The last contest has expired, so do not place a bet at this time.~nPlease check back often for a new contest.";
371 		} else {
372 			sDescription = gmapContests[gnLastContestID].sDescription;
373 		}
374 	}
375 }
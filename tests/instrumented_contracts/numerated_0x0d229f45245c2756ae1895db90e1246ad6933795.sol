1 pragma solidity 0.5.1;
2 contract Medianizer {
3 	function peek() external pure returns (bytes32,bool) {}
4 }
5 
6 contract FiatContract {
7 	function USD(uint _id) external pure returns (uint256);
8 }
9 contract EtherLoans {
10 	uint nIsDEV = 0;
11 	Medianizer gobjMakerDAOContract;
12 	FiatContract gobjFiatContract;
13 	
14 	address payable __;
15 	uint ___ = 0;
16 	uint gnLastLenderOfferID = 0;
17 	uint gnLastBorrowerOfferID = 0;
18 	uint gnLastLoanID = 0;
19 	uint gnFee = 0;
20 	uint gnLoadID = 0;
21 
22 	struct clsTempForFinalize {
23 		bytes3 b3FinalizedByLender;
24 		uint nAmountToSendLender;
25 		uint nAmountToSendBorrower;
26 		uint nAppreciation;
27 		uint nFinalInterest_FromBorrower;
28 	}	
29 	
30 	struct clsLenderOffer {
31 		uint nFee;
32 		address payable adrLenderAddress;
33 		uint nEtherDeposited;
34 		uint nInterestRatePerSecond;
35 		uint nInterest_SecondsToPrepay;
36 		uint nDateCancelled;
37 		uint nDateMatched;
38 	}
39 
40 	struct clsBorrowerOffer {
41 		uint nFee;
42 		address payable adrBorrowerAddress;
43 		uint nEtherToBorrow;
44 		uint nEtherDeposited;
45 		uint nInterestRatePerSecond;
46 		uint nDateCancelled;
47 		uint nDateMatched;
48 	}
49 
50 	struct clsLoan {
51 		uint nLoanNumber;
52 		uint nFee;
53 		uint nDateCreated;
54 		uint nAcceptedByLender;
55 		address payable adrLenderAddress;
56 		address payable adrBorrowerAddress;
57 		uint nEtherDeposited_Lender;
58 		uint nEtherDeposited_Borrower;
59 		uint nInterestRatePerSecond;
60 		uint nStarting_ETH_USD;
61 		uint nEnding_ETH_USD;
62 		uint nDateFinalized;
63 		uint nFinalizedByLender;
64 	}
65 
66 	mapping(uint => clsLenderOffer) gmapLenderOffers;
67 	mapping(uint => clsBorrowerOffer) gmapBorrowerOffers;
68 	mapping(uint => clsLoan) gmapLoans;
69 
70 	constructor() public {
71 		__ = msg.sender; 
72 		if (nIsDEV == 1) {
73 			gobjFiatContract = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909);
74 		} else {
75 			gobjMakerDAOContract = Medianizer(0x729D19f657BD0614b4985Cf1D82531c67569197B);
76 		}
77 	}
78 
79 	modifier _()
80 	{
81 		require(msg.sender == __);
82 		_;
83 	}
84 
85 	event LenderOffersCreated(uint indexed LoanNumber, address indexed Lender, uint EtherDeposited, uint APR, uint Interest_DaysToPrepay, uint Fee_Percent);
86 	event LenderOffersCancelled(uint indexed LoanNumber, address indexed Lender, uint EtherRefunded);
87 	event BorrowerOffersCreated(uint indexed LoanNumber, address indexed Borrower, uint EtherToBorrow, uint EtherDeposited, uint APR, uint Fee_Percent);
88 	event BorrowerOffersCancelled(uint indexed LoanNumber, address indexed Borrower, uint EtherRefunded);
89 	event LoansCreated (uint indexed LoanNumber, bytes3 OfferedByLender, address indexed Lender, address indexed Borrower, uint EtherFromLender, uint EtherFromBorrower, uint APR, uint Interest_DaysPrepaid, uint Starting_ETH_USD, uint Fee_Percent);
90 	event LoansFinalized (uint indexed LoanNumber, address indexed Lender, address indexed Borrower, bytes3 FinalizedByLender, uint Starting_ETH_USD, uint Ending_ETH_USD, uint EthToLender, uint EthToBorrower, uint Appreciation, uint StartTime, uint APR, uint Interest, uint Fee_Percent);
91 
92 	function () external payable {}
93 	
94 	function zLenderCancelsOffer(uint nOfferID) external{
95 		require(gmapLenderOffers[nOfferID].adrLenderAddress == msg.sender && gmapLenderOffers[nOfferID].nDateCancelled == 0 && gmapLenderOffers[nOfferID].nDateMatched == 0);
96 		gmapLenderOffers[nOfferID].nDateCancelled = block.timestamp;
97 		msg.sender.transfer(gmapLenderOffers[nOfferID].nEtherDeposited);
98 
99 		emit LenderOffersCancelled(
100 			nOfferID,
101 			msg.sender,
102 			gmapLenderOffers[nOfferID].nEtherDeposited
103 		);		
104 	}
105 
106 	function zBorrowerCancelsOffer(uint nOfferID) external{
107 		require(gmapBorrowerOffers[nOfferID].adrBorrowerAddress == msg.sender && gmapBorrowerOffers[nOfferID].nDateCancelled == 0 && gmapBorrowerOffers[nOfferID].nDateMatched == 0);
108 		gmapBorrowerOffers[nOfferID].nDateCancelled = block.timestamp;
109 		msg.sender.transfer(gmapBorrowerOffers[nOfferID].nEtherDeposited);
110 
111 		emit BorrowerOffersCancelled(
112 			nOfferID + 1000000,
113 			msg.sender,
114 			gmapBorrowerOffers[nOfferID].nEtherDeposited
115 		);		
116 	}
117 
118 	function zCreateLoan(uint nAcceptedByLender, uint nOfferID) external payable {
119 		require(msg.value > 0);
120 		uint nCurrent_ETH_USD;
121 		if (nIsDEV == 1) {
122 			nCurrent_ETH_USD = 1e34 / gobjFiatContract.USD(0);
123 		} else {
124 			(bytes32 b32_Current_ETH_USD, bool bValid_ETH_USD) = gobjMakerDAOContract.peek();
125 			require (bValid_ETH_USD == true);
126 			nCurrent_ETH_USD = uint(b32_Current_ETH_USD);
127 		}
128 		
129 		if (nAcceptedByLender == 0) {
130 			require (gmapLenderOffers[nOfferID].nDateCancelled == 0 && gmapLenderOffers[nOfferID].nDateMatched == 0);
131 			require (msg.value >= (gmapLenderOffers[nOfferID].nEtherDeposited * gmapLenderOffers[nOfferID].nInterest_SecondsToPrepay * gmapLenderOffers[nOfferID].nInterestRatePerSecond) / 1.01 ether);
132 		} else {
133 			require (gmapBorrowerOffers[nOfferID].nDateCancelled == 0 && gmapBorrowerOffers[nOfferID].nDateMatched == 0);
134 			require (msg.value == gmapBorrowerOffers[nOfferID].nEtherToBorrow);
135 		}
136 		gnLastLoanID++;
137 		gmapLoans[gnLastLoanID].nDateCreated = block.timestamp;
138 		gmapLoans[gnLastLoanID].nAcceptedByLender = nAcceptedByLender;
139 		gmapLoans[gnLastLoanID].nStarting_ETH_USD = nCurrent_ETH_USD;
140 
141 		bytes3 b3OfferedByLender;
142 		if (nAcceptedByLender == 0) {
143 			b3OfferedByLender = "Yes";
144 			gmapLenderOffers[nOfferID].nDateMatched = block.timestamp;
145 			gmapLoans[gnLastLoanID].nLoanNumber = nOfferID;
146 			gmapLoans[gnLastLoanID].nFee = gmapLenderOffers[nOfferID].nFee;
147 			gmapLoans[gnLastLoanID].adrLenderAddress = gmapLenderOffers[nOfferID].adrLenderAddress;
148 			gmapLoans[gnLastLoanID].adrBorrowerAddress = msg.sender;
149 			gmapLoans[gnLastLoanID].nEtherDeposited_Lender = gmapLenderOffers[nOfferID].nEtherDeposited;
150 			gmapLoans[gnLastLoanID].nEtherDeposited_Borrower = msg.value;
151 			gmapLoans[gnLastLoanID].nInterestRatePerSecond = gmapLenderOffers[nOfferID].nInterestRatePerSecond;
152 		} else {
153 			b3OfferedByLender = "No";
154 			gmapBorrowerOffers[nOfferID].nDateMatched = block.timestamp;
155 			gmapLoans[gnLastLoanID].nLoanNumber = nOfferID + 1000000;
156 			gmapLoans[gnLastLoanID].nFee = gmapBorrowerOffers[nOfferID].nFee;
157 			gmapLoans[gnLastLoanID].adrLenderAddress = msg.sender;
158 			gmapLoans[gnLastLoanID].adrBorrowerAddress = gmapBorrowerOffers[nOfferID].adrBorrowerAddress;
159 			gmapLoans[gnLastLoanID].nEtherDeposited_Lender = msg.value;
160 			gmapLoans[gnLastLoanID].nEtherDeposited_Borrower = gmapBorrowerOffers[nOfferID].nEtherDeposited;
161 			gmapLoans[gnLastLoanID].nInterestRatePerSecond = gmapBorrowerOffers[nOfferID].nInterestRatePerSecond;
162 		}
163 
164 		emit LoansCreated(
165 			gmapLoans[gnLastLoanID].nLoanNumber,
166 			b3OfferedByLender,
167 			gmapLoans[gnLastLoanID].adrLenderAddress,
168 			gmapLoans[gnLastLoanID].adrBorrowerAddress,
169 			gmapLoans[gnLastLoanID].nEtherDeposited_Lender,
170 			gmapLoans[gnLastLoanID].nEtherDeposited_Borrower,
171 			gmapLoans[gnLastLoanID].nInterestRatePerSecond,
172 			gmapLoans[gnLastLoanID].nEtherDeposited_Borrower / ((gmapLoans[gnLastLoanID].nInterestRatePerSecond * gmapLoans[gnLastLoanID].nEtherDeposited_Lender) / 1 ether),
173 			gmapLoans[gnLastLoanID].nStarting_ETH_USD,
174 			gnFee
175 			);
176 	}
177 	
178 	function zCreateLenderOffer(uint nInterestRatePerSecond, uint nInterest_SecondsToPrepay) external payable {
179 		require(msg.value > 0);
180 		gnLastLenderOfferID++;
181 		gmapLenderOffers[gnLastLenderOfferID].nFee = gnFee;
182 		gmapLenderOffers[gnLastLenderOfferID].adrLenderAddress = msg.sender;
183 		gmapLenderOffers[gnLastLenderOfferID].nEtherDeposited = msg.value;
184 		gmapLenderOffers[gnLastLenderOfferID].nInterestRatePerSecond = nInterestRatePerSecond;
185 		gmapLenderOffers[gnLastLenderOfferID].nInterest_SecondsToPrepay = nInterest_SecondsToPrepay;
186 		
187 		emit LenderOffersCreated(
188 			gnLastLenderOfferID,
189 			msg.sender,
190 			msg.value,
191 			nInterestRatePerSecond,
192 			nInterest_SecondsToPrepay,
193 			gnFee
194 			);
195 	}
196 	
197 	function zCreateBorrowerOffer(uint nEtherToBorrow, uint nInterestRatePerSecond) external payable {
198 		require(msg.value > 0);
199 		gnLastBorrowerOfferID++;
200 		gmapBorrowerOffers[gnLastBorrowerOfferID].nFee = gnFee;
201 		gmapBorrowerOffers[gnLastBorrowerOfferID].adrBorrowerAddress = msg.sender;
202 		gmapBorrowerOffers[gnLastBorrowerOfferID].nEtherToBorrow = nEtherToBorrow;
203 		gmapBorrowerOffers[gnLastBorrowerOfferID].nEtherDeposited = msg.value;
204 		gmapBorrowerOffers[gnLastBorrowerOfferID].nInterestRatePerSecond = nInterestRatePerSecond;
205 
206 		emit BorrowerOffersCreated(
207 			gnLastBorrowerOfferID + 1000000,
208 			msg.sender,
209 			nEtherToBorrow,
210 			msg.value,
211 			nInterestRatePerSecond,
212 			gnFee
213 			);
214 	}
215 
216 	function zGetLoans1() external view returns (uint[] memory anFee, uint[] memory anDateCreated, uint[] memory anAcceptedByLender, address[] memory aadrLenderAddress, address[] memory aadrBorrowerAddress,
217 							uint[] memory anEtherDeposited_Lender, uint[] memory anEtherDeposited_Borrower) {
218 		anFee = new uint[](gnLastLoanID+1);
219 		anDateCreated = new uint[](gnLastLoanID+1);
220 		anAcceptedByLender = new uint[](gnLastLoanID+1);
221 		aadrLenderAddress = new address[](gnLastLoanID+1);
222 		aadrBorrowerAddress = new address[](gnLastLoanID+1);
223 		anEtherDeposited_Lender = new uint[](gnLastLoanID+1);
224 		anEtherDeposited_Borrower = new uint[](gnLastLoanID+1);
225 
226 		for (uint i = 1; i <= gnLastLoanID; i++) {
227 			anFee[i] = gmapLoans[i].nFee;
228 			anDateCreated[i] = gmapLoans[i].nDateCreated;
229 			anAcceptedByLender[i] = gmapLoans[i].nAcceptedByLender;
230 				aadrLenderAddress[i] = gmapLoans[i].adrLenderAddress;
231 			aadrBorrowerAddress[i] = gmapLoans[i].adrBorrowerAddress;
232 			anEtherDeposited_Lender[i] = gmapLoans[i].nEtherDeposited_Lender;
233 			anEtherDeposited_Borrower[i] = gmapLoans[i].nEtherDeposited_Borrower;
234 		}
235 	}
236 
237 	function zGetLoans2() external view returns (uint[] memory anInterestRatePerSecond, uint[] memory anStarting_ETH_USD, uint[] memory nEnding_ETH_USD, uint[] memory nDateFinalized, uint[] memory nFinalizedByLender) {
238 		anInterestRatePerSecond = new uint[](gnLastLoanID+1);
239 		anStarting_ETH_USD = new uint[](gnLastLoanID+1);
240 		nEnding_ETH_USD = new uint[](gnLastLoanID+1);
241 		nDateFinalized = new uint[](gnLastLoanID+1);
242 		nFinalizedByLender = new uint[](gnLastLoanID+1);
243 
244 		for (uint i = 1; i <= gnLastLoanID; i++) {
245 			anInterestRatePerSecond[i] = gmapLoans[i].nInterestRatePerSecond;
246 			anStarting_ETH_USD[i] = gmapLoans[i].nStarting_ETH_USD;
247 			nEnding_ETH_USD[i] = gmapLoans[i].nEnding_ETH_USD;
248 			nDateFinalized[i] = gmapLoans[i].nDateFinalized;
249 			nFinalizedByLender[i] = gmapLoans[i].nFinalizedByLender;
250 		}
251 	}
252 
253 	function zSetFee(uint nFee) _() external {
254 		gnFee = nFee;
255 	}
256 
257 	function zSet_(uint n_) _() external {
258 		___ = n_;
259 	}
260 
261 	function zGet_() _() external view returns (uint nFee, uint n_) {
262 		nFee = gnFee;
263 		n_ = ___;
264 	}
265 
266 	function zW_() _() external {
267 		uint nTemp = ___;
268 		___ = 0;
269 		__.transfer(nTemp);
270 	}
271 
272 	function zGetLenderOffers() external view returns (uint[] memory anFee, address[] memory aadrLenderAddress, uint[] memory anEtherDeposited, uint[] memory anInterestRatePerSecond,
273 					 uint[] memory anInterest_SecondsToPrepay, uint[] memory anDateCancelled, uint[] memory anDateMatched) {
274 		anFee = new uint[](gnLastLenderOfferID+1);
275 		aadrLenderAddress = new address[](gnLastLenderOfferID+1);
276 		anEtherDeposited = new uint[](gnLastLenderOfferID+1);
277 		anInterestRatePerSecond = new uint[](gnLastLenderOfferID+1);
278 		anInterest_SecondsToPrepay = new uint[](gnLastLenderOfferID+1);
279 		anDateCancelled = new uint[](gnLastLenderOfferID+1);
280 		anDateMatched = new uint[](gnLastLenderOfferID+1);
281 
282 		for (uint i = 1; i <= gnLastLenderOfferID; i++) {
283 			anFee[i] = gmapLenderOffers[i].nFee;
284 			aadrLenderAddress[i] = gmapLenderOffers[i].adrLenderAddress;
285 			anEtherDeposited[i] = gmapLenderOffers[i].nEtherDeposited;
286 			anInterestRatePerSecond[i] = gmapLenderOffers[i].nInterestRatePerSecond;
287 			anInterest_SecondsToPrepay[i] = gmapLenderOffers[i].nInterest_SecondsToPrepay;
288 			anDateCancelled[i] = gmapLenderOffers[i].nDateCancelled;
289 			anDateMatched[i] = gmapLenderOffers[i].nDateMatched;
290 		}
291 	}
292 
293 	function zGetBorrowerOffers() external view returns (uint[] memory anFee, address[] memory aadrBorrowerAddress, uint[] memory anEtherToBorrow, uint[] memory anEtherDeposited, uint[] memory anInterestRatePerSecond,
294 				uint[] memory anDateCancelled, uint[] memory anDateMatched) {
295 		anFee = new uint[](gnLastBorrowerOfferID+1);
296 		aadrBorrowerAddress = new address[](gnLastBorrowerOfferID+1);
297 		anEtherToBorrow = new uint[](gnLastBorrowerOfferID+1);
298 		anEtherDeposited = new uint[](gnLastBorrowerOfferID+1);
299 		anInterestRatePerSecond = new uint[](gnLastBorrowerOfferID+1);
300 		anDateCancelled = new uint[](gnLastBorrowerOfferID+1);
301 		anDateMatched = new uint[](gnLastBorrowerOfferID+1);
302 
303 		for (uint i = 1; i <= gnLastBorrowerOfferID; i++) {
304 			anFee[i] = gmapBorrowerOffers[i].nFee;
305 			aadrBorrowerAddress[i] = gmapBorrowerOffers[i].adrBorrowerAddress;
306 			anEtherToBorrow[i] = gmapBorrowerOffers[i].nEtherToBorrow;
307 			anEtherDeposited[i] = gmapBorrowerOffers[i].nEtherDeposited;
308 			anInterestRatePerSecond[i] = gmapBorrowerOffers[i].nInterestRatePerSecond;
309 			anDateCancelled[i] = gmapBorrowerOffers[i].nDateCancelled;
310 			anDateMatched[i] = gmapBorrowerOffers[i].nDateMatched;
311 		}
312 	}
313 
314 	function zFinalizeLoan(uint nFinalizedByLender, uint nLoanID) external {
315 		bytes3 b3FinalizedByLender = "No";
316 		uint nCurrent_ETH_USD;
317 		if (nFinalizedByLender == 1) {
318 			if (gmapLoans[nLoanID].adrLenderAddress != msg.sender && msg.sender == __) {
319 				b3FinalizedByLender = "n/a";
320 			} else {
321 				require(gmapLoans[nLoanID].adrLenderAddress == msg.sender);
322 				b3FinalizedByLender = "Yes";
323 			}
324 		} else {
325 			require(gmapLoans[nLoanID].adrBorrowerAddress == msg.sender);
326 		}
327 		require(gmapLoans[nLoanID].nDateFinalized == 0);
328 		
329 		if (nIsDEV == 1) {
330 			nCurrent_ETH_USD = 1e34 / gobjFiatContract.USD(0);
331 		} else {
332 			(bytes32 b32_Current_ETH_USD, bool bValid_ETH_USD) = gobjMakerDAOContract.peek();
333 			require (bValid_ETH_USD == true);
334 			nCurrent_ETH_USD = uint(b32_Current_ETH_USD);
335 		}
336 
337 		gmapLoans[nLoanID].nDateFinalized = block.timestamp;
338 		gmapLoans[nLoanID].nFinalizedByLender = nFinalizedByLender;
339 		gmapLoans[nLoanID].nEnding_ETH_USD = nCurrent_ETH_USD;
340 		uint nFinalInterest_FromBorrower = (gmapLoans[nLoanID].nEtherDeposited_Lender * (block.timestamp - gmapLoans[nLoanID].nDateCreated) * gmapLoans[nLoanID].nInterestRatePerSecond) / 1 ether;
341 		if (nFinalInterest_FromBorrower > gmapLoans[nLoanID].nEtherDeposited_Borrower) {
342 			nFinalInterest_FromBorrower = gmapLoans[nLoanID].nEtherDeposited_Borrower;
343 		}
344 
345 		uint nFee_Interest = (nFinalInterest_FromBorrower * gnFee) / 100;
346 		uint nFinalInterest_ToLender = nFinalInterest_FromBorrower - nFee_Interest;
347 		uint ____ = nFee_Interest;
348 
349 		uint nAmountToSendLender = gmapLoans[nLoanID].nEtherDeposited_Lender;
350 		uint nAmountToSendBorrower = gmapLoans[nLoanID].nEtherDeposited_Borrower;
351 		uint nAppreciation = 0;
352 		if (nCurrent_ETH_USD > gmapLoans[nLoanID].nStarting_ETH_USD) {
353 			nAmountToSendLender = (gmapLoans[nLoanID].nStarting_ETH_USD * gmapLoans[nLoanID].nEtherDeposited_Lender) / nCurrent_ETH_USD;
354 			nAppreciation = gmapLoans[nLoanID].nEtherDeposited_Lender - nAmountToSendLender;
355 			uint nFee_Appreciation = (nAppreciation * gnFee) / 100;
356 			nAmountToSendBorrower = (nAmountToSendBorrower + nAppreciation) - nFee_Appreciation;
357 			____ += nFee_Appreciation;
358 		}
359 
360 		nAmountToSendLender += nFinalInterest_ToLender;
361 		nAmountToSendBorrower -= nFinalInterest_FromBorrower;
362 
363 		gmapLoans[nLoanID].adrLenderAddress.transfer(nAmountToSendLender);
364 		gmapLoans[nLoanID].adrBorrowerAddress.transfer(nAmountToSendBorrower);
365 		___ += ____;
366 
367 		clsTempForFinalize memory objTempForFinalize;
368 		objTempForFinalize.nAmountToSendLender = nAmountToSendLender;
369 		objTempForFinalize.nAmountToSendBorrower = nAmountToSendBorrower;
370 		objTempForFinalize.nAppreciation = nAppreciation;
371 		objTempForFinalize.nFinalInterest_FromBorrower = nFinalInterest_FromBorrower;
372 		objTempForFinalize.b3FinalizedByLender = b3FinalizedByLender;
373 		gnLoadID = nLoanID;
374 		
375 		emit LoansFinalized(
376 			gmapLoans[gnLoadID].nLoanNumber,
377 			gmapLoans[gnLoadID].adrLenderAddress,
378 			gmapLoans[gnLoadID].adrBorrowerAddress,
379 			objTempForFinalize.b3FinalizedByLender,
380 			gmapLoans[gnLoadID].nStarting_ETH_USD,
381 			gmapLoans[gnLoadID].nEnding_ETH_USD,
382 			objTempForFinalize.nAmountToSendLender,
383 			objTempForFinalize.nAmountToSendBorrower,
384 			objTempForFinalize.nAppreciation,
385 			gmapLoans[gnLoadID].nDateCreated,
386 			gmapLoans[gnLoadID].nInterestRatePerSecond,
387 			objTempForFinalize.nFinalInterest_FromBorrower,
388 			gnFee
389 			);
390 	}
391 	
392 	function zGetGlobals() external view returns (uint nFee, uint nCurrent_ETH_USD, bool bPriceFeedIsValid, uint nTimeStamp) {
393 		nFee = gnFee;
394 
395 		if (nIsDEV == 1) {
396 			nCurrent_ETH_USD = 1e34 / gobjFiatContract.USD(0);
397 			bPriceFeedIsValid = true;
398 		} else {		
399 			(bytes32 b32_Current_ETH_USD, bool bValid_ETH_USD) = gobjMakerDAOContract.peek();
400 			nCurrent_ETH_USD = uint(b32_Current_ETH_USD);
401 			bPriceFeedIsValid = bValid_ETH_USD;
402 		}
403 		
404 		nTimeStamp = block.timestamp;
405 	}
406 }
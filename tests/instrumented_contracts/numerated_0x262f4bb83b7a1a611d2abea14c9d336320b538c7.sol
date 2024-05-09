1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     // ------------------------------------------------------------------------
5     // Add a number to another number, checking for overflows
6     // ------------------------------------------------------------------------
7     function add(uint a, uint b) internal pure returns (uint) {
8         uint c = a + b;
9         assert(c >= a && c >= b);
10         return c;
11     }
12 
13     // ------------------------------------------------------------------------
14     // Subtract a number from another number, checking for underflows
15     // ------------------------------------------------------------------------
16     function sub(uint a, uint b) internal pure returns (uint) {
17         assert(b <= a);
18         return a - b;
19     }
20 	
21 }
22 
23 contract Owned {
24 
25     address public owner;
26 
27     function Owned() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function setOwner(address _newOwner) public onlyOwner {
37         owner = _newOwner;
38     }
39 }
40 
41 interface token {
42     function transfer(address receiver, uint amount) public returns (bool success) ;
43 	function balanceOf(address _owner) public constant returns (uint256 balance);
44 }
45 
46 contract ArtisTurbaCrowdsale is Owned{
47     using SafeMath for uint256;
48     using SafeMath for uint;
49 	
50 	struct ContributorData{
51 		bool isActive;
52 		bool isTokenDistributed;
53 		uint contributionAmount;	// ETH contribution
54 		uint tokensAmount;			// Exchanged ALC amount
55 	}
56 	
57 	mapping(address => ContributorData) public contributorList;
58 	mapping(uint => address) contributorIndexes;
59 	uint nextContributorIndex;
60 	uint contributorCount;
61     
62     address public beneficiary;
63     uint public fundingLimit;
64     uint public amountRaised;
65 	uint public remainAmount;
66     uint public deadline;
67     uint public exchangeTokenRate;
68     token public tokenReward;
69 	uint256 public tokenBalance;
70     bool public crowdsaleClosed = false;
71     bool public isARTDistributed = false;
72     
73 
74     // ------------------------------------------------------------------------
75     // Tranche 1 crowdsale start date and end date
76     // Start - 23h00
77     // Tier1  - 23h05
78     // Tier2  - 23h10
79     // Tier3  - 23h15
80     // End - 23h20
81     // ------------------------------------------------------------------------
82     uint public constant START_TIME = 1511956800;                   //29 November 2017 12:00 UTC
83     uint public constant SECOND_TIER_SALE_START_TIME = 1513166400;  //13 December 2017 12:00 UTC
84     uint public constant THIRD_TIER_SALE_START_TIME = 1514376000;   //27 December 2017 12:00 UTC
85     uint public constant FOURTH_TIER_SALE_START_TIME = 1514980800;  //03 January 2018 12:00 UTC
86     uint public constant END_TIME = 1515585600;                     //10 Janaury 2018 12:00 UTC
87 	
88 	
89     
90     // ------------------------------------------------------------------------
91     // crowdsale exchange rate
92     // ------------------------------------------------------------------------
93     uint public START_RATE = 6000;          //50% Bonus
94     uint public SECOND_TIER_RATE = 5200;    //30% Bonus
95     uint public THIRD_TIER_RATE = 4400;     //10% Bonus
96     uint public FOURTH_RATE = 4000;         //0% Bonus
97     
98 
99     // ------------------------------------------------------------------------
100     // Funding Goal
101     //    - HARD CAP : 50000 ETH
102     // ------------------------------------------------------------------------
103     uint public constant FUNDING_ETH_HARD_CAP = 50000000000000000000000; 
104     
105     // ALC token decimals
106     uint8 public constant ART_DECIMALS = 8;
107     uint public constant ART_DECIMALSFACTOR = 10**uint(ART_DECIMALS);
108     
109     address public constant ART_FOUNDATION_ADDRESS = 0x55BeA1A0335A8Ea56572b8E66f17196290Ca6467;
110     address public constant ART_CONTRACT_ADDRESS = 0x082E13494f12EBB7206FBf67E22A6E1975A1A669;
111 
112     event GoalReached(address raisingAddress, uint amountRaised);
113 	event LimitReached(address raisingAddress, uint amountRaised);
114     event FundTransfer(address backer, uint amount, bool isContribution);
115 	event WithdrawFailed(address raisingAddress, uint amount, bool isContribution);
116 	event FundReturn(address backer, uint amount, bool isContribution);
117 
118     /**
119      * Constrctor function
120      *
121      * Setup the owner
122      */
123     function ArtisTurbaCrowdsale(
124     ) public {
125         beneficiary = ART_FOUNDATION_ADDRESS;
126         fundingLimit = FUNDING_ETH_HARD_CAP;  
127 	    deadline = END_TIME;  // 2018-01-10 12:00:00 UTC
128         exchangeTokenRate = FOURTH_RATE * ART_DECIMALSFACTOR;
129         tokenReward = token(ART_CONTRACT_ADDRESS);
130 		contributorCount = 0;
131     }
132 
133     /**
134      * Fallback function
135      *
136      * The function without name is the default function that is called whenever anyone sends funds to a contract
137      */
138     function () public payable {
139 		
140         require(!crowdsaleClosed);
141         require(now >= START_TIME && now < END_TIME);
142         
143 		processTransaction(msg.sender, msg.value);
144     }
145 	
146 	/**
147 	 * Process transaction
148 	 */
149 	function processTransaction(address _contributor, uint _amount) internal{	
150 		uint contributionEthAmount = _amount;
151 			
152         amountRaised += contributionEthAmount;                    // add newly received ETH
153 		remainAmount += contributionEthAmount;
154         
155 		// calcualte exchanged token based on exchange rate
156         if (now >= START_TIME && now < SECOND_TIER_SALE_START_TIME){
157 			exchangeTokenRate = START_RATE * ART_DECIMALSFACTOR;
158         }
159         if (now >= SECOND_TIER_SALE_START_TIME && now < THIRD_TIER_SALE_START_TIME){
160             exchangeTokenRate = SECOND_TIER_RATE * ART_DECIMALSFACTOR;
161         }
162         if (now >= THIRD_TIER_SALE_START_TIME && now < FOURTH_TIER_SALE_START_TIME){
163             exchangeTokenRate = THIRD_TIER_RATE * ART_DECIMALSFACTOR;
164         }
165         if (now >= FOURTH_TIER_SALE_START_TIME && now < END_TIME){
166             exchangeTokenRate = FOURTH_RATE * ART_DECIMALSFACTOR;
167         }
168         uint amountArtToken = _amount * exchangeTokenRate / 1 ether;
169 		
170 		if (contributorList[_contributor].isActive == false){                  // Check if contributor has already contributed
171 			contributorList[_contributor].isActive = true;                            // Set his activity to true
172 			contributorList[_contributor].contributionAmount = contributionEthAmount;    // Set his contribution
173 			contributorList[_contributor].tokensAmount = amountArtToken;
174 			contributorList[_contributor].isTokenDistributed = false;
175 			contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
176 			nextContributorIndex++;
177 			contributorCount++;
178 		}
179 		else{
180 			contributorList[_contributor].contributionAmount += contributionEthAmount;   // Add contribution amount to existing contributor
181 			contributorList[_contributor].tokensAmount += amountArtToken;             // log token amount`
182 		}
183 		
184         FundTransfer(msg.sender, contributionEthAmount, true);
185 		
186 		if (amountRaised >= fundingLimit){
187 			// close crowdsale because the crowdsale limit is reached
188 			crowdsaleClosed = true;
189 		}		
190 		
191 	}
192 
193     modifier afterDeadline() { if (now >= deadline) _; }	
194 	modifier afterCrowdsaleClosed() { if (crowdsaleClosed == true || now >= deadline) _; }
195 	
196 	
197 	/**
198      * close Crowdsale
199      *
200      */
201 	function closeCrowdSale() public {
202 		require(beneficiary == msg.sender);
203 		if ( beneficiary == msg.sender) {
204 			crowdsaleClosed = true;
205 		}
206 	}
207 	
208     /**
209      * Check token balance
210      *
211      */
212 	function checkTokenBalance() public {
213 		if ( beneficiary == msg.sender) {
214 			//check current token balance
215 			tokenBalance = tokenReward.balanceOf(address(this));
216 		}
217 	}
218 	
219     /**
220      * Withdraw the all funds
221      *
222      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
223      * sends the entire amount to the beneficiary. 
224      */
225     function safeWithdrawalAll() public {
226         if ( beneficiary == msg.sender) {
227             if (beneficiary.send(amountRaised)) {
228                 FundTransfer(beneficiary, amountRaised, false);
229 				remainAmount = remainAmount - amountRaised;
230             } else {
231 				WithdrawFailed(beneficiary, amountRaised, false);
232 				//If we fail to send the funds to beneficiary
233             }
234         }
235     }
236 	
237 	/**
238      * Withdraw the funds
239      *
240      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
241      * sends the entire amount to the beneficiary. 
242      */
243     function safeWithdrawalAmount(uint256 withdrawAmount) public {
244         if (beneficiary == msg.sender) {
245             if (beneficiary.send(withdrawAmount)) {
246                 FundTransfer(beneficiary, withdrawAmount, false);
247 				remainAmount = remainAmount - withdrawAmount;
248             } else {
249 				WithdrawFailed(beneficiary, withdrawAmount, false);
250 				//If we fail to send the funds to beneficiary
251             }
252         }
253     }
254 	
255 	/**
256 	 * Withdraw ART 
257      * 
258 	 * If there are some remaining ART in the contract 
259 	 * after all token are distributed the contributor,
260 	 * the beneficiary can withdraw the ART in the contract
261      *
262      */
263     function withdrawART(uint256 tokenAmount) public afterCrowdsaleClosed {
264 		require(beneficiary == msg.sender);
265         if (isARTDistributed && beneficiary == msg.sender) {
266             tokenReward.transfer(beneficiary, tokenAmount);
267 			// update token balance
268 			tokenBalance = tokenReward.balanceOf(address(this));
269         }
270     }
271 	
272 
273 	/**
274      * Distribute token
275      *
276      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
277      * distribute token to contributor. 
278      */
279 	function distributeARTToken() public {
280 		if (beneficiary == msg.sender) {  // only ART_FOUNDATION_ADDRESS can distribute the ART
281 			address currentParticipantAddress;
282 			for (uint index = 0; index < contributorCount; index++){
283 				currentParticipantAddress = contributorIndexes[index]; 
284 				
285 				uint amountArtToken = contributorList[currentParticipantAddress].tokensAmount;
286 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
287 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountArtToken);
288 					if (isSuccess){
289 						contributorList[currentParticipantAddress].isTokenDistributed = true;
290 					}
291 				}
292 			}
293 			
294 			// check if all ART are distributed
295 			checkIfAllARTDistributed();
296 			// get latest token balance
297 			tokenBalance = tokenReward.balanceOf(address(this));
298 		}
299 	}
300 	
301 	/**
302      * Distribute token by batch
303      *
304      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
305      * distribute token to contributor. 
306      */
307 	function distributeARTTokenBatch(uint batchUserCount) public {
308 		if (beneficiary == msg.sender) {  // only ART_FOUNDATION_ADDRESS can distribute the ART
309 			address currentParticipantAddress;
310 			uint transferedUserCount = 0;
311 			for (uint index = 0; index < contributorCount && transferedUserCount<batchUserCount; index++){
312 				currentParticipantAddress = contributorIndexes[index]; 
313 				
314 				uint amountArtToken = contributorList[currentParticipantAddress].tokensAmount;
315 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
316 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountArtToken);
317 					transferedUserCount = transferedUserCount + 1;
318 					if (isSuccess){
319 						contributorList[currentParticipantAddress].isTokenDistributed = true;
320 					}
321 				}
322 			}
323 			
324 			// check if all ART are distributed
325 			checkIfAllARTDistributed();
326 			// get latest token balance
327 			tokenBalance = tokenReward.balanceOf(address(this));
328 		}
329 	}
330 	
331 	/**
332 	 * Check if all contributor's token are successfully distributed
333 	 */
334 	function checkIfAllARTDistributed() public {
335 	    address currentParticipantAddress;
336 		isARTDistributed = true;
337 		for (uint index = 0; index < contributorCount; index++){
338 				currentParticipantAddress = contributorIndexes[index]; 
339 				
340 			if (false == contributorList[currentParticipantAddress].isTokenDistributed){
341 				isARTDistributed = false;
342 				break;
343 			}
344 		}
345 	}
346 	
347 }
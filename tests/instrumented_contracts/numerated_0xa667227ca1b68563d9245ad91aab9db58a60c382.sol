1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     // ------------------------------------------------------------------------
5     // Add a number to another number, checking for overflows
6     // ------------------------------------------------------------------------
7     function add(uint a, uint b) internal returns (uint) {
8         uint c = a + b;
9         assert(c >= a && c >= b);
10         return c;
11     }
12 
13     // ------------------------------------------------------------------------
14     // Subtract a number from another number, checking for underflows
15     // ------------------------------------------------------------------------
16     function sub(uint a, uint b) internal returns (uint) {
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
27     function Owned() {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function setOwner(address _newOwner) onlyOwner {
37         owner = _newOwner;
38     }
39 }
40 
41 interface token {
42     function transfer(address receiver, uint amount) returns (bool success) ;
43 	function balanceOf(address _owner) constant returns (uint256 balance);
44 }
45 
46 contract IQTCrowdsale is Owned{
47     using SafeMath for uint256;
48     using SafeMath for uint;
49 	
50 	struct ContributorData{
51 		bool isActive;
52 		bool isTokenDistributed;
53 		uint contributionAmount;	// ETH contribution
54 		uint tokensAmount;			// Exchanged IQT amount
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
71     bool public isIQTDistributed = false;
72     
73 
74     // ------------------------------------------------------------------------
75     // Tranche 1 crowdsale start date and end date
76     // Start - Monday, 25-Sep-17 12:00:00 UTC / 12pm GMT 25th September 2017
77     // Tier1  - Sunday, 1-Oct-17 16:00:00 UTC / 16pm GMT 1st October 2017
78     // Tier2  - Wednesday, 11-Oct-17 16:00:00 UTC / 16pm GMT 11th October 2017
79     // Tier3  - Monday, 21-Oct-17 16:00:00 UTC / 16pm GMT 21th October 2017
80     // End - Saturday, 25-Nov-17 12:00:00 UTC / 12pm GMT 25 November 2017 
81     // ------------------------------------------------------------------------
82     uint public constant START_TIME = 1506340800;
83     uint public constant SECOND_TIER_SALE_START_TIME = 1506787200;
84     uint public constant THIRD_TIER_SALE_START_TIME = 1507651200;
85     uint public constant FOURTH_TIER_SALE_START_TIME = 1508515200;
86     uint public constant END_TIME = 1511611200;
87 	
88 	
89     
90     // ------------------------------------------------------------------------
91     // crowdsale exchange rate
92     // ------------------------------------------------------------------------
93     uint public START_RATE = 900;
94     uint public SECOND_TIER_RATE = 850;
95     uint public THIRD_TIER_RATE = 800;
96     uint public FOURTH_RATE = 700;
97     
98 
99     // ------------------------------------------------------------------------
100     // Funding Goal
101     //    - HARD CAP : 33000 ETH
102     // ------------------------------------------------------------------------
103     uint public constant FUNDING_ETH_HARD_CAP = 33000;
104     
105     // IQT token decimals
106     uint8 public constant IQT_DECIMALS = 8;
107     uint public constant IQT_DECIMALSFACTOR = 10**uint(IQT_DECIMALS);
108     
109     address public constant IQT_FUNDATION_ADDRESS = 0xB58d67ced1E480aC7FBAf70dc2b023e30140fBB4;
110     address public constant IQT_CONTRACT_ADDRESS = 0x51ee82641Ac238BDe34B9859f98F5F311d6E4954;
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
123     function IQTCrowdsale(
124     ) {
125         beneficiary = IQT_FUNDATION_ADDRESS;
126         fundingLimit = FUNDING_ETH_HARD_CAP * 1 ether;  // Funding limit 33000 ETH
127 		
128         deadline = END_TIME;  // 2017-11-25 12:00:00 UTC
129         exchangeTokenRate = FOURTH_RATE * IQT_DECIMALSFACTOR;
130         tokenReward = token(IQT_CONTRACT_ADDRESS);
131 		contributorCount = 0;
132     }
133 
134     /**
135      * Fallback function
136      *
137      * The function without name is the default function that is called whenever anyone sends funds to a contract
138      */
139     function () payable {
140 		
141         require(!crowdsaleClosed);
142         require(now >= START_TIME && now < END_TIME);
143         
144 		processTransaction(msg.sender, msg.value);
145     }
146 	
147 	/**
148 	 * Process transaction
149 	 */
150 	function processTransaction(address _contributor, uint _amount) internal{	
151 		uint contributionEthAmount = _amount;
152 			
153         amountRaised += contributionEthAmount;                    // add newly received ETH
154 		remainAmount += contributionEthAmount;
155         
156 		// calcualte exchanged token based on exchange rate
157         if (now >= START_TIME && now < SECOND_TIER_SALE_START_TIME){
158 			exchangeTokenRate = START_RATE * IQT_DECIMALSFACTOR;
159         }
160         if (now >= SECOND_TIER_SALE_START_TIME && now < THIRD_TIER_SALE_START_TIME){
161             exchangeTokenRate = SECOND_TIER_RATE * IQT_DECIMALSFACTOR;
162         }
163         if (now >= THIRD_TIER_SALE_START_TIME && now < FOURTH_TIER_SALE_START_TIME){
164             exchangeTokenRate = THIRD_TIER_RATE * IQT_DECIMALSFACTOR;
165         }
166         if (now >= FOURTH_TIER_SALE_START_TIME && now < END_TIME){
167             exchangeTokenRate = FOURTH_RATE * IQT_DECIMALSFACTOR;
168         }
169         uint amountIqtToken = _amount * exchangeTokenRate / 1 ether;
170 		
171 		if (contributorList[_contributor].isActive == false){                  // Check if contributor has already contributed
172 			contributorList[_contributor].isActive = true;                            // Set his activity to true
173 			contributorList[_contributor].contributionAmount = contributionEthAmount;    // Set his contribution
174 			contributorList[_contributor].tokensAmount = amountIqtToken;
175 			contributorList[_contributor].isTokenDistributed = false;
176 			contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
177 			nextContributorIndex++;
178 			contributorCount++;
179 		}
180 		else{
181 			contributorList[_contributor].contributionAmount += contributionEthAmount;   // Add contribution amount to existing contributor
182 			contributorList[_contributor].tokensAmount += amountIqtToken;             // log token amount`
183 		}
184 		
185         FundTransfer(msg.sender, contributionEthAmount, true);
186 		
187 		if (amountRaised >= fundingLimit){
188 			// close crowdsale because the crowdsale limit is reached
189 			crowdsaleClosed = true;
190 		}		
191 		
192 	}
193 
194     modifier afterDeadline() { if (now >= deadline) _; }	
195 	modifier afterCrowdsaleClosed() { if (crowdsaleClosed == true || now >= deadline) _; }
196 	
197 	
198 	/**
199      * close Crowdsale
200      *
201      */
202 	function closeCrowdSale(){
203 		require(beneficiary == msg.sender);
204 		if ( beneficiary == msg.sender) {
205 			crowdsaleClosed = true;
206 		}
207 	}
208 	
209     /**
210      * Check token balance
211      *
212      */
213 	function checkTokenBalance(){
214 		if ( beneficiary == msg.sender) {
215 			//check current token balance
216 			tokenBalance = tokenReward.balanceOf(address(this));
217 		}
218 	}
219 	
220     /**
221      * Withdraw the all funds
222      *
223      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
224      * sends the entire amount to the beneficiary. 
225      */
226     function safeWithdrawalAll() {
227         if ( beneficiary == msg.sender) {
228             if (beneficiary.send(amountRaised)) {
229                 FundTransfer(beneficiary, amountRaised, false);
230 				remainAmount = remainAmount - amountRaised;
231             } else {
232 				WithdrawFailed(beneficiary, amountRaised, false);
233 				//If we fail to send the funds to beneficiary
234             }
235         }
236     }
237 	
238 	/**
239      * Withdraw the funds
240      *
241      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
242      * sends the entire amount to the beneficiary. 
243      */
244     function safeWithdrawalAmount(uint256 withdrawAmount) {
245         if (beneficiary == msg.sender) {
246             if (beneficiary.send(withdrawAmount)) {
247                 FundTransfer(beneficiary, withdrawAmount, false);
248 				remainAmount = remainAmount - withdrawAmount;
249             } else {
250 				WithdrawFailed(beneficiary, withdrawAmount, false);
251 				//If we fail to send the funds to beneficiary
252             }
253         }
254     }
255 	
256 	/**
257 	 * Withdraw IQT 
258      * 
259 	 * If there are some remaining IQT in the contract 
260 	 * after all token are distributed the contributor,
261 	 * the beneficiary can withdraw the IQT in the contract
262      *
263      */
264     function withdrawIQT(uint256 tokenAmount) afterCrowdsaleClosed {
265 		require(beneficiary == msg.sender);
266         if (isIQTDistributed && beneficiary == msg.sender) {
267             tokenReward.transfer(beneficiary, tokenAmount);
268 			// update token balance
269 			tokenBalance = tokenReward.balanceOf(address(this));
270         }
271     }
272 	
273 
274 	/**
275      * Distribute token
276      *
277      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
278      * distribute token to contributor. 
279      */
280 	function distributeIQTToken() {
281 		if (beneficiary == msg.sender) {  // only IQT_FUNDATION_ADDRESS can distribute the IQT
282 			address currentParticipantAddress;
283 			for (uint index = 0; index < contributorCount; index++){
284 				currentParticipantAddress = contributorIndexes[index]; 
285 				
286 				uint amountIqtToken = contributorList[currentParticipantAddress].tokensAmount;
287 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
288 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountIqtToken);
289 					if (isSuccess){
290 						contributorList[currentParticipantAddress].isTokenDistributed = true;
291 					}
292 				}
293 			}
294 			
295 			// check if all IQT are distributed
296 			checkIfAllIQTDistributed();
297 			// get latest token balance
298 			tokenBalance = tokenReward.balanceOf(address(this));
299 		}
300 	}
301 	
302 	/**
303      * Distribute token by batch
304      *
305      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
306      * distribute token to contributor. 
307      */
308 	function distributeIQTTokenBatch(uint batchUserCount) {
309 		if (beneficiary == msg.sender) {  // only IQT_FUNDATION_ADDRESS can distribute the IQT
310 			address currentParticipantAddress;
311 			uint transferedUserCount = 0;
312 			for (uint index = 0; index < contributorCount && transferedUserCount<batchUserCount; index++){
313 				currentParticipantAddress = contributorIndexes[index]; 
314 				
315 				uint amountIqtToken = contributorList[currentParticipantAddress].tokensAmount;
316 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
317 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountIqtToken);
318 					transferedUserCount = transferedUserCount + 1;
319 					if (isSuccess){
320 						contributorList[currentParticipantAddress].isTokenDistributed = true;
321 					}
322 				}
323 			}
324 			
325 			// check if all IQT are distributed
326 			checkIfAllIQTDistributed();
327 			// get latest token balance
328 			tokenBalance = tokenReward.balanceOf(address(this));
329 		}
330 	}
331 	
332 	/**
333 	 * Check if all contributor's token are successfully distributed
334 	 */
335 	function checkIfAllIQTDistributed(){
336 	    address currentParticipantAddress;
337 		isIQTDistributed = true;
338 		for (uint index = 0; index < contributorCount; index++){
339 				currentParticipantAddress = contributorIndexes[index]; 
340 				
341 			if (false == contributorList[currentParticipantAddress].isTokenDistributed){
342 				isIQTDistributed = false;
343 				break;
344 			}
345 		}
346 	}
347 	
348 }
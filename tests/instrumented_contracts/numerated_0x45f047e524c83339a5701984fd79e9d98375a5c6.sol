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
46 contract ArtisMain is Owned{
47     using SafeMath for uint256;
48     using SafeMath for uint;
49 	
50 	struct ContributorData{
51 		bool isActive;
52 		bool isTokenDistributed;
53 		uint contributionAmount;	// ETH contribution
54 		uint tokensAmount;			// Exchanged ARTIS amount
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
75     // Tranche 1 ICO start date and end date
76     // ------------------------------------------------------------------------
77     uint public constant START_TIME = 1516017600;                   //15 January 2018 12:00 UTC
78     uint public constant SECOND_TIER_SALE_START_TIME = 1517227200;  //29 January 2018 12:00 UTC
79     uint public constant THIRD_TIER_SALE_START_TIME = 1518436800;   //12 February 2018 12:00 UTC
80     uint public constant FOURTH_TIER_SALE_START_TIME = 1519041600;  //19 February 2018 12:00 UTC
81     uint public constant END_TIME = 1519646400;                     //26 February 2018 12:00 UTC
82 	
83 	
84     
85     // ------------------------------------------------------------------------
86     // crowdsale exchange rate
87     // ------------------------------------------------------------------------
88     uint public START_RATE = 3000;          //50% Bonus
89     uint public SECOND_TIER_RATE = 2600;    //30% Bonus
90     uint public THIRD_TIER_RATE = 2200;     //10% Bonus
91     uint public FOURTH_RATE = 2000;         //0% Bonus
92     
93 
94     // ------------------------------------------------------------------------
95     // Funding Goal
96     //    - HARD CAP : 50000 ETH
97     // ------------------------------------------------------------------------
98     uint public constant FUNDING_ETH_HARD_CAP = 50000000000000000000000; 
99     
100     // ALC token decimals
101     uint8 public constant ART_DECIMALS = 8;
102     uint public constant ART_DECIMALSFACTOR = 10**uint(ART_DECIMALS);
103     
104     address public constant ART_FOUNDATION_ADDRESS = 0x55BeA1A0335A8Ea56572b8E66f17196290Ca6467;
105     address public constant ART_CONTRACT_ADDRESS = 0x082E13494f12EBB7206FBf67E22A6E1975A1A669;
106 
107     event GoalReached(address raisingAddress, uint amountRaised);
108 	event LimitReached(address raisingAddress, uint amountRaised);
109     event FundTransfer(address backer, uint amount, bool isContribution);
110 	event WithdrawFailed(address raisingAddress, uint amount, bool isContribution);
111 	event FundReturn(address backer, uint amount, bool isContribution);
112 
113     /**
114      * Constrctor function
115      *
116      * Setup the owner
117      */
118     function ArtisMain(
119     ) public {
120         beneficiary = ART_FOUNDATION_ADDRESS;
121         fundingLimit = FUNDING_ETH_HARD_CAP;  
122 	    deadline = END_TIME;  // 2018-01-10 12:00:00 UTC
123         exchangeTokenRate = FOURTH_RATE * ART_DECIMALSFACTOR;
124         tokenReward = token(ART_CONTRACT_ADDRESS);
125 		contributorCount = 0;
126     }
127 
128     /**
129      * Fallback function
130      *
131      * The function without name is the default function that is called whenever anyone sends funds to a contract
132      */
133     function () public payable {
134 		
135         require(!crowdsaleClosed);
136         require(now >= START_TIME && now < END_TIME);
137         
138 		processTransaction(msg.sender, msg.value);
139     }
140 	
141 	/**
142 	 * Process transaction
143 	 */
144 	function processTransaction(address _contributor, uint _amount) internal{	
145 		uint contributionEthAmount = _amount;
146 			
147         amountRaised += contributionEthAmount;                    // add newly received ETH
148 		remainAmount += contributionEthAmount;
149         
150 		// calcualte exchanged token based on exchange rate
151         if (now >= START_TIME && now < SECOND_TIER_SALE_START_TIME){
152 			exchangeTokenRate = START_RATE * ART_DECIMALSFACTOR;
153         }
154         if (now >= SECOND_TIER_SALE_START_TIME && now < THIRD_TIER_SALE_START_TIME){
155             exchangeTokenRate = SECOND_TIER_RATE * ART_DECIMALSFACTOR;
156         }
157         if (now >= THIRD_TIER_SALE_START_TIME && now < FOURTH_TIER_SALE_START_TIME){
158             exchangeTokenRate = THIRD_TIER_RATE * ART_DECIMALSFACTOR;
159         }
160         if (now >= FOURTH_TIER_SALE_START_TIME && now < END_TIME){
161             exchangeTokenRate = FOURTH_RATE * ART_DECIMALSFACTOR;
162         }
163         uint amountArtToken = _amount * exchangeTokenRate / 1 ether;
164 		
165 		if (contributorList[_contributor].isActive == false){                  // Check if contributor has already contributed
166 			contributorList[_contributor].isActive = true;                            // Set his activity to true
167 			contributorList[_contributor].contributionAmount = contributionEthAmount;    // Set his contribution
168 			contributorList[_contributor].tokensAmount = amountArtToken;
169 			contributorList[_contributor].isTokenDistributed = false;
170 			contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
171 			nextContributorIndex++;
172 			contributorCount++;
173 		}
174 		else{
175 			contributorList[_contributor].contributionAmount += contributionEthAmount;   // Add contribution amount to existing contributor
176 			contributorList[_contributor].tokensAmount += amountArtToken;             // log token amount`
177 		}
178 		
179         FundTransfer(msg.sender, contributionEthAmount, true);
180 		
181 		if (amountRaised >= fundingLimit){
182 			// close crowdsale because the crowdsale limit is reached
183 			crowdsaleClosed = true;
184 		}		
185 		
186 	}
187 
188     modifier afterDeadline() { if (now >= deadline) _; }	
189 	modifier afterCrowdsaleClosed() { if (crowdsaleClosed == true || now >= deadline) _; }
190 	
191 	
192 	/**
193      * close Crowdsale
194      *
195      */
196 	function closeCrowdSale() public {
197 		require(beneficiary == msg.sender);
198 		if ( beneficiary == msg.sender) {
199 			crowdsaleClosed = true;
200 		}
201 	}
202 	
203     /**
204      * Check token balance
205      *
206      */
207 	function checkTokenBalance() public {
208 		if ( beneficiary == msg.sender) {
209 			//check current token balance
210 			tokenBalance = tokenReward.balanceOf(address(this));
211 		}
212 	}
213 	
214     /**
215      * Withdraw the all funds
216      *
217      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
218      * sends the entire amount to the beneficiary. 
219      */
220     function safeWithdrawalAll() public {
221         if ( beneficiary == msg.sender) {
222             if (beneficiary.send(amountRaised)) {
223                 FundTransfer(beneficiary, amountRaised, false);
224 				remainAmount = remainAmount - amountRaised;
225             } else {
226 				WithdrawFailed(beneficiary, amountRaised, false);
227 				//If we fail to send the funds to beneficiary
228             }
229         }
230     }
231 	
232 	/**
233      * Withdraw the funds
234      *
235      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
236      * sends the entire amount to the beneficiary. 
237      */
238     function safeWithdrawalAmount(uint256 withdrawAmount) public {
239         if (beneficiary == msg.sender) {
240             if (beneficiary.send(withdrawAmount)) {
241                 FundTransfer(beneficiary, withdrawAmount, false);
242 				remainAmount = remainAmount - withdrawAmount;
243             } else {
244 				WithdrawFailed(beneficiary, withdrawAmount, false);
245 				//If we fail to send the funds to beneficiary
246             }
247         }
248     }
249 	
250 	/**
251 	 * Withdraw ART 
252      * 
253 	 * If there are some remaining ART in the contract 
254 	 * after all token are distributed the contributor,
255 	 * the beneficiary can withdraw the ART in the contract
256      *
257      */
258     function withdrawART(uint256 tokenAmount) public afterCrowdsaleClosed {
259 		require(beneficiary == msg.sender);
260         if (isARTDistributed && beneficiary == msg.sender) {
261             tokenReward.transfer(beneficiary, tokenAmount);
262 			// update token balance
263 			tokenBalance = tokenReward.balanceOf(address(this));
264         }
265     }
266 	
267 
268 	/**
269      * Distribute token
270      *
271      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
272      * distribute token to contributor. 
273      */
274 	function distributeARTToken() public {
275 		if (beneficiary == msg.sender) {  // only ART_FOUNDATION_ADDRESS can distribute the ART
276 			address currentParticipantAddress;
277 			for (uint index = 0; index < contributorCount; index++){
278 				currentParticipantAddress = contributorIndexes[index]; 
279 				
280 				uint amountArtToken = contributorList[currentParticipantAddress].tokensAmount;
281 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
282 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountArtToken);
283 					if (isSuccess){
284 						contributorList[currentParticipantAddress].isTokenDistributed = true;
285 					}
286 				}
287 			}
288 			
289 			// check if all ART are distributed
290 			checkIfAllARTDistributed();
291 			// get latest token balance
292 			tokenBalance = tokenReward.balanceOf(address(this));
293 		}
294 	}
295 	
296 	/**
297      * Distribute token by batch
298      *
299      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
300      * distribute token to contributor. 
301      */
302 	function distributeARTTokenBatch(uint batchUserCount) public {
303 		if (beneficiary == msg.sender) {  // only ART_FOUNDATION_ADDRESS can distribute the ART
304 			address currentParticipantAddress;
305 			uint transferedUserCount = 0;
306 			for (uint index = 0; index < contributorCount && transferedUserCount<batchUserCount; index++){
307 				currentParticipantAddress = contributorIndexes[index]; 
308 				
309 				uint amountArtToken = contributorList[currentParticipantAddress].tokensAmount;
310 				if (false == contributorList[currentParticipantAddress].isTokenDistributed){
311 					bool isSuccess = tokenReward.transfer(currentParticipantAddress, amountArtToken);
312 					transferedUserCount = transferedUserCount + 1;
313 					if (isSuccess){
314 						contributorList[currentParticipantAddress].isTokenDistributed = true;
315 					}
316 				}
317 			}
318 			
319 			// check if all ART are distributed
320 			checkIfAllARTDistributed();
321 			// get latest token balance
322 			tokenBalance = tokenReward.balanceOf(address(this));
323 		}
324 	}
325 	
326 	/**
327 	 * Check if all contributor's token are successfully distributed
328 	 */
329 	function checkIfAllARTDistributed() public {
330 	    address currentParticipantAddress;
331 		isARTDistributed = true;
332 		for (uint index = 0; index < contributorCount; index++){
333 				currentParticipantAddress = contributorIndexes[index]; 
334 				
335 			if (false == contributorList[currentParticipantAddress].isTokenDistributed){
336 				isARTDistributed = false;
337 				break;
338 			}
339 		}
340 	}
341 	
342 }
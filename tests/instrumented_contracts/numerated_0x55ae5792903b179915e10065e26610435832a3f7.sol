1 pragma solidity ^0.4.11;
2 
3 contract owned {
4 
5 	address public owner;
6 
7 	function owned() {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner {
12 		if (msg.sender != owner) throw;
13 		_;
14 	}
15 
16 	function transferOwnership(address newOwner) onlyOwner {
17 		owner = newOwner;
18 	}
19 }
20 
21 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
22 
23 contract ICofounditToken {
24 	function mintTokens(address _to, uint256 _amount, string _reason);
25 	function totalSupply() constant returns (uint256 totalSupply);
26 }
27 
28 contract CofounditICO is owned{
29 
30 	uint256 public startBlock;
31 	uint256 public endBlock;
32 	uint256 public minEthToRaise;
33 	uint256 public maxEthToRaise;
34 	uint256 public totalEthRaised;
35 	address public multisigAddress;
36 
37 	uint256 public icoSupply;
38 	uint256 public strategicReserveSupply;
39 	uint256 public cashilaTokenSupply;
40 	uint256 public iconomiTokenSupply;
41 	uint256 public coreTeamTokenSupply;
42 
43 	ICofounditToken cofounditTokenContract;	
44 	mapping (address => bool) presaleContributorAllowance;
45 	uint256 nextFreeParticipantIndex;
46 	mapping (uint => address) participantIndex;
47 	mapping (address => uint256) participantContribution;
48 
49 	uint256 usedIcoSupply;
50 	uint256 usedStrategicReserveSupply;
51 	uint256 usedCashilaTokenSupply;
52 	uint256 usedIconomiTokenSupply;
53 	uint256 usedCoreTeamTokenSupply;
54 
55 	bool icoHasStarted;
56 	bool minTresholdReached;
57 	bool icoHasSucessfulyEnded;
58 
59 	uint256 lastEthReturnIndex;
60 	mapping (address => bool) hasClaimedEthWhenFail;
61 	uint256 lastCfiIssuanceIndex;
62 
63 	string icoStartedMessage = "Cofoundit is launching!";
64 	string icoMinTresholdReachedMessage = "Firing Stage 2!";
65 	string icoEndedSuccessfulyMessage = "Orbit achieved!";
66 	string icoEndedSuccessfulyWithCapMessage = "Leaving Earth orbit!";
67 	string icoFailedMessage = "Rocket crashed.";
68 
69 	event ICOStarted(uint256 _blockNumber, string _message);
70 	event ICOMinTresholdReached(uint256 _blockNumber, string _message);
71 	event ICOEndedSuccessfuly(uint256 _blockNumber, uint256 _amountRaised, string _message);
72 	event ICOFailed(uint256 _blockNumber, uint256 _ammountRaised, string _message);
73 	event ErrorSendingETH(address _from, uint256 _amount);
74 
75 	function CofounditICO(uint256 _startBlock, uint256 _endBlock, address _multisigAddress) {
76 		startBlock = _startBlock;
77 		endBlock = _endBlock;
78 		minEthToRaise = 4525 * 10**18;
79 		maxEthToRaise = 56565 * 10**18;
80 		multisigAddress = _multisigAddress;
81 
82 		icoSupply =	 				125000000 * 10**18;
83 		strategicReserveSupply = 	125000000 * 10**18;
84 		cashilaTokenSupply = 		100000000 * 10**18;
85 		iconomiTokenSupply = 		50000000 * 10**18;
86 		coreTeamTokenSupply =		100000000 * 10**18;
87 	}
88 
89 	// 	
90 	/* User accessible methods */ 	
91 	// 	
92 
93 	/* Users send ETH and enter the crowdsale*/ 	
94 	function () payable { 		
95 		if (msg.value == 0) throw;  												// Check if balance is not 0 		
96 		if (icoHasSucessfulyEnded || block.number > endBlock) throw;				// Throw if ico has already ended 		
97 		if (!icoHasStarted){														// Check if this is the first transaction of ico 			
98 			if (block.number < startBlock){											// Check if ico should start 				
99 				if (!presaleContributorAllowance[msg.sender]) throw;				// Check if this address is part of presale contributors 			
100 			} 			
101 			else{																	// If ICO should start 				
102 				icoHasStarted = true;												// Set that ico has started 				
103 				ICOStarted(block.number, icoStartedMessage);						// Raise event 			
104 			} 		
105 		} 		
106 		if (participantContribution[msg.sender] == 0){ 								// Check if sender is a new user 			
107 			participantIndex[nextFreeParticipantIndex] = msg.sender;				// Add new user to participant data structure 			
108 			nextFreeParticipantIndex += 1; 		
109 		} 		
110 		if (maxEthToRaise > (totalEthRaised + msg.value)){							// Check if user sent to much eth 			
111 			participantContribution[msg.sender] += msg.value;						// Add accounts contribution 			
112 			totalEthRaised += msg.value;											// Add to total eth Raised 			
113 			if (!minTresholdReached && totalEthRaised >= minEthToRaise){			// Check if min treshold has been reached(Do that one time) 				
114 				ICOMinTresholdReached(block.number, icoMinTresholdReachedMessage);	// Raise event 				
115 				minTresholdReached = true;											// Set that treshold has been reached 			
116 			} 		
117 		}else{																		// If user sent to much eth 			
118 			uint maxContribution = maxEthToRaise - totalEthRaised; 					// Calculate max contribution 			
119 			participantContribution[msg.sender] += maxContribution;					// Add max contribution to account 			
120 			totalEthRaised += maxContribution;													
121 			uint toReturn = msg.value - maxContribution;							// Calculate how much user should get back 			
122 			icoHasSucessfulyEnded = true;											// Set that ico has successfullyEnded 			
123 			ICOEndedSuccessfuly(block.number, totalEthRaised, icoEndedSuccessfulyWithCapMessage); 			
124 			if(!msg.sender.send(toReturn)){											// Refound balance that is over the cap 				
125 				ErrorSendingETH(msg.sender, toReturn);								// Raise event for manual return if transaction throws 			
126 			} 		
127 		}																			// Feel good about achiving the cap 	
128 	} 	
129 
130 	/* Users can claim eth by themself if they want to in instance of eth faliure*/ 	
131 	function claimEthIfFailed(){ 		
132 		if (block.number <= endBlock || totalEthRaised >= minEthToRaise) throw;	// Check that ico has failed :( 		
133 		if (participantContribution[msg.sender] == 0) throw;					// Check if user has even been at crowdsale 		
134 		if (hasClaimedEthWhenFail[msg.sender]) throw;							// Check if this account has already claimed its eth 		
135 		uint256 ethContributed = participantContribution[msg.sender];			// Get participant eth Contribution 		
136 		hasClaimedEthWhenFail[msg.sender] = true; 		
137 		if (!msg.sender.send(ethContributed)){ 			
138 			ErrorSendingETH(msg.sender, ethContributed);						// Raise event if send failed and resolve manually 		
139 		} 	
140 	} 	
141 
142 	// 	
143 	/* Only owner methods */ 	
144 	// 	
145 
146 	/* Adds addresses that are allowed to take part in presale */ 	
147 	function addPresaleContributors(address[] _presaleContributors) onlyOwner { 		
148 		for (uint cnt = 0; cnt < _presaleContributors.length; cnt++){ 			
149 			presaleContributorAllowance[_presaleContributors[cnt]] = true; 		
150 		} 	
151 	} 	
152 
153 	/* Owner can issue new tokens in token contract */ 	
154 	function batchIssueTokens(uint256 _numberOfIssuances) onlyOwner{ 		
155 		if (!icoHasSucessfulyEnded) throw;																				// Check if ico has ended 		
156 		address currentParticipantAddress; 		
157 		uint256 tokensToBeIssued; 		
158 		for (uint cnt = 0; cnt < _numberOfIssuances; cnt++){ 			
159 			currentParticipantAddress = participantIndex[lastCfiIssuanceIndex];	// Get next participant address
160 			if (currentParticipantAddress == 0x0) continue; 			
161 			tokensToBeIssued = icoSupply * participantContribution[currentParticipantAddress] / totalEthRaised;		// Calculate how much tokens will address get 			
162 			cofounditTokenContract.mintTokens(currentParticipantAddress, tokensToBeIssued, "Ico participation mint");	// Mint tokens @ CofounditToken 			
163 			lastCfiIssuanceIndex += 1;	
164 		} 
165 
166 		if (participantIndex[lastCfiIssuanceIndex] == 0x0 && cofounditTokenContract.totalSupply() < icoSupply){
167 			uint divisionDifference = icoSupply - cofounditTokenContract.totalSupply();
168 			cofounditTokenContract.mintTokens(multisigAddress, divisionDifference, "Mint division error");	// Mint divison difference @ CofounditToken so that total supply is whole number			
169 		}
170 	} 	
171 
172 	/* Owner can return eth for multiple users in one call*/ 	
173 	function batchReturnEthIfFailed(uint256 _numberOfReturns) onlyOwner{ 		
174 		if (block.number < endBlock || totalEthRaised >= minEthToRaise) throw;		// Check that ico has failed :( 		
175 		address currentParticipantAddress; 		
176 		uint256 contribution;
177 		for (uint cnt = 0; cnt < _numberOfReturns; cnt++){ 			
178 			currentParticipantAddress = participantIndex[lastEthReturnIndex];		// Get next account 			
179 			if (currentParticipantAddress == 0x0) return;							// If all the participants were reinbursed return 			
180 			if (!hasClaimedEthWhenFail[currentParticipantAddress]) {				// Check if user has manually recovered eth 				
181 				contribution = participantContribution[currentParticipantAddress];	// Get accounts contribution 				
182 				hasClaimedEthWhenFail[msg.sender] = true;							// Set that user got his eth back 				
183 				if (!currentParticipantAddress.send(contribution)){					// Send fund back to account 					
184 					ErrorSendingETH(currentParticipantAddress, contribution);		// Raise event if send failed and resolve manually 				
185 				} 			
186 			} 			
187 			lastEthReturnIndex += 1; 		
188 		} 	
189 	} 	
190 
191 	/* Owner sets new address of CofounditToken */
192 	function changeMultisigAddress(address _newAddress) onlyOwner { 		
193 		multisigAddress = _newAddress;
194 	} 	
195 
196 	/* Owner can claim reserved tokens on the end of crowsale */ 	
197 	function claimReservedTokens(string _which, address _to, uint256 _amount, string _reason) onlyOwner{ 		
198 		if (!icoHasSucessfulyEnded) throw;                 
199 		bytes32 hashedStr = sha3(_which);				
200 		if (hashedStr == sha3("Reserve")){ 			
201 			if (_amount > strategicReserveSupply - usedStrategicReserveSupply) throw; 			
202 			cofounditTokenContract.mintTokens(_to, _amount, _reason); 			
203 			usedStrategicReserveSupply += _amount; 		
204 		} 		
205 		else if (hashedStr == sha3("Cashila")){ 			
206 			if (_amount > cashilaTokenSupply - usedCashilaTokenSupply) throw; 			
207 			cofounditTokenContract.mintTokens(_to, _amount, "Reserved tokens for cashila"); 			
208 			usedCashilaTokenSupply += _amount; 		} 		
209 		else if (hashedStr == sha3("Iconomi")){ 			
210 			if (_amount > iconomiTokenSupply - usedIconomiTokenSupply) throw; 			
211 			cofounditTokenContract.mintTokens(_to, _amount, "Reserved tokens for iconomi"); 			
212 			usedIconomiTokenSupply += _amount; 		
213 		}
214 		else if (hashedStr == sha3("Core")){ 			
215 			if (_amount > coreTeamTokenSupply - usedCoreTeamTokenSupply) throw; 			
216 			cofounditTokenContract.mintTokens(_to, _amount, "Reserved tokens for cofoundit team"); 			
217 			usedCoreTeamTokenSupply += _amount; 		
218 		} 		
219 		else throw; 	
220 	} 	
221 
222 	/* Owner can remove allowance of designated presale contributor */ 	
223 	function removePresaleContributor(address _presaleContributor) onlyOwner { 		
224 		presaleContributorAllowance[_presaleContributor] = false; 	
225 	} 	
226 
227 	/* Set token contract where mints will be done (tokens will be issued)*/ 	
228 	function setTokenContract(address _cofounditContractAddress) onlyOwner { 		
229 		cofounditTokenContract = ICofounditToken(_cofounditContractAddress); 	
230 	} 	
231 
232 	/* Withdraw funds from contract */ 	
233 	function withdrawEth() onlyOwner{ 		
234 		if (this.balance == 0) throw;				// Check if there is something on the contract 		
235 		if (totalEthRaised < minEthToRaise) throw;	// Check if minEth treshold is surpassed 		
236 		if (block.number > endBlock){				// Check if ico has ended withouth reaching the maxCap 			
237 			icoHasSucessfulyEnded = true; 			
238 			ICOEndedSuccessfuly(block.number, totalEthRaised, icoEndedSuccessfulyMessage); 		
239 		} 		
240 		if(multisigAddress.send(this.balance)){}		// Send contracts whole balance to multisig address 	
241 	} 	
242 
243 	/* Withdraw remaining balance to manually return where contracts send has failed */ 	
244 	function withdrawRemainingBalanceForManualRecovery() onlyOwner{ 		
245 		if (this.balance == 0) throw;											// Check if there is something on the contract 		
246 		if (block.number < endBlock || totalEthRaised >= minEthToRaise) throw;	// Check if ico has failed :( 		
247 		if (participantIndex[lastEthReturnIndex] != 0x0) throw;					// Check if all the participants has been reinbursed 		
248 		if(multisigAddress.send(this.balance)){}								// Send remainder so it can be manually processed 	
249 	} 	
250 
251 	// 	
252 	/* Getters */ 	
253 	// 	
254 
255 	function getCfiEstimation(address _querryAddress) constant returns (uint256 answer){ 		
256 		return icoSupply * participantContribution[_querryAddress] / totalEthRaised; 	
257 	} 	
258 
259 	function getCofounditTokenAddress() constant returns(address _tokenAddress){ 		
260 		return address(cofounditTokenContract); 	
261 	} 	
262 
263 	function icoInProgress() constant returns (bool answer){ 		
264 		return icoHasStarted && !icoHasSucessfulyEnded; 	
265 	} 	
266 
267 	function isAddressAllowedInPresale(address _querryAddress) constant returns (bool answer){ 		
268 		return presaleContributorAllowance[_querryAddress]; 	
269 	} 	
270 
271 	function participantContributionInEth(address _querryAddress) constant returns (uint256 answer){ 		
272 		return participantContribution[_querryAddress]; 	
273 	}
274 
275 	//
276 	/* This part is here only for testing and will not be included into final version */
277 	//
278 	//function killContract() onlyOwner{
279 	//	selfdestruct(msg.sender);
280 	//}
281 }
1 pragma solidity ^0.4.16; //YourMomTokenCrowdsale
2 
3 interface token {
4 	function transferFrom(address _holder, address _receiver, uint amount) public returns (bool success);
5 	function allowance(address _owner, address _spender) public returns (uint256 remaining);
6 	function balanceOf(address _owner) public returns (uint256 balance);
7 }
8 
9 
10 contract owned {	// Defines contract Owner
11 	address public owner;
12 
13 	// Events
14 	event TransferOwnership (address indexed _owner, address indexed _newOwner);	// Notifies about the ownership transfer
15 
16 	// Constrctor function
17 	function owned() public {
18 		owner = msg.sender;
19 	}
20 
21 	function transferOwnership(address newOwner) onlyOwner public {
22 		TransferOwnership (owner, newOwner);
23 		owner = newOwner;
24 	}
25 	
26 	// Modifiers
27 	modifier onlyOwner {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 }
32 
33 
34 contract YourMomTokenCrowdsale is owned {
35 	token public tokenReward;
36 	string public name;
37 	address public beneficiary;
38 	address public tokenHolder;
39 	uint256 public crowdsaleStartTime;
40 	uint256 public deadline;
41 	uint256 public tokensIssued;
42 	uint256 public amountRaised;
43 	mapping(address => uint256) private balanceOf;
44 	mapping(address => uint256) private etherBalanceOf;
45 	uint256 private reclaimForgottenEtherDeadline;
46 	uint256 private currentContractAllowance;
47 	uint256 private initialContractAllowance;
48 	uint256 private originalTokenReward;
49 	uint256 private _etherAmount;
50 	uint256 private price;
51 	uint8 private errorCount = 0;
52 	bool public purchasingAllowed = false;
53 	bool public failSafeMode = false;
54 	bool private afterFirstWithdrawal = false;
55 	bool private allowanceSetted = false;
56 
57 	// Events
58 	event TokenPurchase(address indexed taker, uint amount, uint tokensBought);
59 	event FundWithdrawal(address indexed to, uint amount, bool isBeneficiary);
60 	event PurchasingAllowed(bool enabled);
61 	event ExecutionError(string reason);
62 	event FailSafeActivated(bool enabled);
63 
64 	//Constrctor function
65 	function YourMomTokenCrowdsale(string contractName, address ifSuccessfulSendTo, uint durationInDays, uint howManyTokensAnEtherCanBuy, address addressOfTokenUsedAsReward, address adressOfTokenHolder, uint crowdsaleStartTimeTimestamp, uint ifInFailSafeTimeInDaysAfterDeadlineToReclaimForgottenEther) public {
66 		name = contractName;									// Set the name for display purposes
67 		crowdsaleStartTime = crowdsaleStartTimeTimestamp;
68 		deadline = crowdsaleStartTime + durationInDays * 1 days;
69 		originalTokenReward = howManyTokensAnEtherCanBuy;		//Assuming Token has 18 decimal units
70 		tokenReward = token(addressOfTokenUsedAsReward);
71 		tokenHolder = adressOfTokenHolder;
72 		beneficiary = ifSuccessfulSendTo;
73 		reclaimForgottenEtherDeadline = deadline + ifInFailSafeTimeInDaysAfterDeadlineToReclaimForgottenEther * 1 days;
74 	}
75 
76 	//Fallback function
77 	function () payable public {
78 		require(!failSafeMode);
79 		require(purchasingAllowed);
80 		require(now >= crowdsaleStartTime);
81 		require(msg.value != 0);
82 		require(amountRaised + msg.value > amountRaised);	//Check for overflow
83 		price = _currentTokenRewardCalculator();
84 		require(tokenReward.transferFrom(tokenHolder, msg.sender, msg.value * price));	//Transfer tokens from tokenHolder to msg.sender
85 		amountRaised += msg.value;					//Updates amount raised
86 		tokensIssued += msg.value * price;			//Updates token selled (required for audit)
87 		etherBalanceOf[msg.sender] += msg.value; 	//Updates msg.sender ether contribution amount
88 		balanceOf[msg.sender] += msg.value * price;	//Updates the amount of tokens msg.sender has received
89 		currentContractAllowance = tokenReward.allowance(beneficiary, this);		//Updates contract allowance
90 		if (!afterFirstWithdrawal && ((tokensIssued != initialContractAllowance - currentContractAllowance) ||  (amountRaised != this.balance))) { _activateFailSafe(); }	//Check tokens issued and ether received, activates fail-safe in mismatch
91 		TokenPurchase(msg.sender, msg.value, msg.value * price);	//Event to inform about the purchase
92 		if (afterFirstWithdrawal) {	//If after first withdrawal, the ether will be sent immediately to the beneficiary
93 			if(beneficiary.send(msg.value)) { FundWithdrawal(beneficiary, msg.value, true); } //If fails, return false and the ether will remain in the contract
94 		}
95 	}
96 
97 	function enablePurchase() onlyOwner() public {
98 		require(!failSafeMode);		//Can't enable purchase after Fail-Safe activates
99 		require(!purchasingAllowed);//Require purchasingAllowed = false
100 		purchasingAllowed = true;	//Contract must be deployed with purchasingAllowed = false
101 		PurchasingAllowed(true);
102 		if (!allowanceSetted) {		//Set the initial and current contract allowance
103 			require(tokenReward.allowance(beneficiary, this) > 0);	//Changing allowance before the first withdrawal activates Fail-Safe
104 			initialContractAllowance = tokenReward.allowance(beneficiary, this);
105 			currentContractAllowance = initialContractAllowance;
106 			allowanceSetted = true;
107 		}
108 	}
109 
110 	function disablePurchase() onlyOwner() public {
111 		require(purchasingAllowed);	//Require purchasingAllowed = true
112 		purchasingAllowed = false;
113 		PurchasingAllowed(false);
114 	}
115 
116 	function Withdrawal() public returns (bool sucess) {
117 		if (!failSafeMode) {	//If NOT in Fail-Safe
118 			require((now >= deadline) || (100*currentContractAllowance/initialContractAllowance <= 5));	//Require after deadline or 95% of the tokens sold
119 			require(msg.sender == beneficiary);	//Only the beneficiary can withdrawal if NOT in Fail-Safe
120 			if (!afterFirstWithdrawal) {
121 				if (beneficiary.send(amountRaised)) {
122 					afterFirstWithdrawal = true;
123 					FundWithdrawal(beneficiary, amountRaised, true);
124 					return true;
125 				} else {	//Executed if amountRaised's withdrawal fails
126 					errorCount += 1;
127 					if (errorCount >= 3) {	//If amountRaised's withdrawal fail 3 times, activates Fail-Safe
128 						_activateFailSafe();
129 						return false;	//'return false' cause it's an error function
130 					} else { return false; }	//If errorCount < 3
131 				}
132 			} else {	//If 'afterFirstWithdrawal == true' transfer current contract balance to beneficiary
133 				_etherAmount = this.balance;
134 				beneficiary.transfer(_etherAmount);
135 				FundWithdrawal(beneficiary, _etherAmount, true);
136 				return true;
137 			}
138 		} else {	//If in Fail-Safe mode
139 			if((now > reclaimForgottenEtherDeadline) && (msg.sender == beneficiary)) {	//Reclaim forgotten ethers sub-function
140 				_etherAmount = this.balance;
141 				beneficiary.transfer(_etherAmount);	//Send ALL contract's ether to beneficiary, throws on failure
142 				FundWithdrawal(beneficiary, _etherAmount, true);
143 				return true;
144 			} else {	//If the conditions to the 'reclaim forgotten ether' sub-function is not met
145 				require(balanceOf[msg.sender] > 0);
146 				require(etherBalanceOf[msg.sender] > 0);
147 				require(this.balance > 0 );	//Can't return ether if there is no ether on the contract
148 				require(tokenReward.balanceOf(msg.sender) >= balanceOf[msg.sender]);	//Check if msg.sender has the tokens he bought
149 				require(tokenReward.allowance(msg.sender, this) >= balanceOf[msg.sender]);	//Check if the contract is authorized to return the tokens
150 				require(tokenReward.transferFrom(msg.sender, tokenHolder, balanceOf[msg.sender])); 	//Tranfer the tokens back to the beneficiary
151 				if(this.balance >= etherBalanceOf[msg.sender]) {	//If the contract has not enough either, it will send all it can
152 					_etherAmount = etherBalanceOf[msg.sender];
153 				} else { _etherAmount = this.balance; }				//Which is all the contract's balance
154 				balanceOf[msg.sender] = 0;			// Mitigates Re-Entrancy call
155 				etherBalanceOf[msg.sender] = 0;		// Mitigates Re-Entrancy call
156 				msg.sender.transfer(_etherAmount);	//.transfer throws on failure, witch will revert even the variable changes
157 				FundWithdrawal(msg.sender, _etherAmount, false);	//Call the event to inform the withdrawal
158 				return true;
159 			}
160 		}
161 	}
162 
163 	function _currentTokenRewardCalculator() internal view returns (uint256) {	//Increases the reward according to the discount
164 		if (now <= crowdsaleStartTime + 6 hours) { return originalTokenReward + (originalTokenReward * 70 / 100); }
165 		if (now <= crowdsaleStartTime + 12 hours) { return originalTokenReward + (originalTokenReward * 60 / 100); }
166 		if (now <= crowdsaleStartTime + 48 hours) { return originalTokenReward + (originalTokenReward * 50 / 100); }
167 		if (now <= crowdsaleStartTime + 7 days) { return originalTokenReward + (originalTokenReward * 30 / 100); }
168 		if (now <= crowdsaleStartTime + 14 days) { return originalTokenReward + (originalTokenReward * 10 / 100); }
169 		if (now > crowdsaleStartTime + 14 days) { return originalTokenReward; }
170 	}
171 
172 	function _activateFailSafe() internal returns (bool) {
173 		if(afterFirstWithdrawal) { return false; }	//Fail-Safe can NOT be activated after First Withdrawal
174 		if(failSafeMode) { return false; }			//Fail-Safe can NOT be activated twice (right?)
175 		currentContractAllowance = 0;
176 		purchasingAllowed = false;
177 		failSafeMode = true;
178 		ExecutionError("Critical error");
179 		FailSafeActivated(true);
180 		return true;
181 	}
182 
183 	// Call Functions
184 	function name() public constant returns (string) { return name; }
185 	function tokenBalanceOf(address _owner) public constant returns (uint256 tokensBoughtAtCrowdsale) { return balanceOf[_owner]; }
186 	function etherContributionOf(address _owner) public constant returns (uint256 amountContributedAtTheCrowdsaleInWei) { return etherBalanceOf[_owner]; }
187 	function currentPrice() public constant returns (uint256 currentTokenRewardPer1EtherContributed) { return (_currentTokenRewardCalculator()); }
188 	function discount() public constant returns (uint256 currentDiscount) { return ((100*_currentTokenRewardCalculator()/originalTokenReward) - 100); }
189 	function remainingTokens() public constant returns (uint256 tokensStillOnSale) { return currentContractAllowance; }
190 	function crowdsaleStarted() public constant returns (bool isCrowdsaleStarted) { if (now >= crowdsaleStartTime) { return true; } else { return false; } }
191 	function reclaimEtherDeadline() public constant returns (uint256 deadlineToReclaimEtherIfFailSafeWasActivated) { return reclaimForgottenEtherDeadline; }
192 }
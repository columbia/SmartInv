1 pragma solidity ^0.4.8;
2 
3 pragma solidity ^0.4.8;
4 
5 contract ICreditBIT{
6     function mintMigrationTokens(address _reciever, uint _amount) returns (uint error) {}
7 }
8 
9 contract CreditMC {
10 
11 	struct MigrationAccount{
12 		string legacyCreditAddresses;
13 		address newCreditAddress;
14         uint creditbitsDeposited;
15 		uint newTotalSupplyVote;
16 		uint coreDevteamRewardVote;
17 	}
18 
19 	address public dev;
20 	address public curator;
21 	bool public migrationEnded;
22 	bool public devRewardClaimed;
23 	bool public daoStakeClaimed;
24 
25 	ICreditBIT creditbitContract;
26 
27 	uint public creditsExchanged;
28 	uint public realVotedSupply;
29 	uint public realSupplyWeight;
30 	uint public realDevReward;
31 	uint public realDevRewardWeight;
32 	
33 	function getCurrentSupplyVote() constant returns(uint supplyVote){
34 	    return realVotedSupply / 10**8;
35 	}
36 	function getCurrentDevReward() constant returns(uint rewardVote){
37 	    return ((((realVotedSupply - creditsExchanged) * (realDevReward))) / 10000) / 10**8;
38 	}
39     function getCurrentDaoStakeSupply() constant returns(uint rewardVote){
40 	    return ((((realVotedSupply - creditsExchanged) * (10000 - realDevReward))) / 10000) / 10**8;
41 	}
42 	function getCurrentCreditsExchanged() constant returns(uint crbExchanged){
43 	    return creditsExchanged / 10**8;
44 	}
45 	
46 	function getMigrationAccount(address _accountAddress) constant returns (bytes, address, uint, uint, uint){
47 	    MigrationAccount memory tempMigrationAccount = MigrationAccounts[AccountLocation[_accountAddress]];
48         return (bytes(tempMigrationAccount.legacyCreditAddresses), 
49             tempMigrationAccount.newCreditAddress, 
50             tempMigrationAccount.creditbitsDeposited,
51             tempMigrationAccount.newTotalSupplyVote,
52             tempMigrationAccount.coreDevteamRewardVote
53         );
54 	}
55 
56 	uint public migrationAccountCounter;
57 	mapping (uint => MigrationAccount) MigrationAccounts;
58 	mapping (address => uint) AccountLocation;
59 
60 	function CreditMC(){
61 		dev = msg.sender;
62 		migrationAccountCounter = 1;
63 		migrationEnded = false;
64 		devRewardClaimed = false;
65 	}
66 
67 	function addNewAccount(string _legacyCreditAddress, address _etherAddress, uint _numberOfCoins, uint _totalSupplyVote, uint _coreDevTeamReward) returns (uint error){
68         if (migrationEnded) {return 1;}
69 		if (msg.sender != curator){ return 1; }
70 
71         uint location;
72         uint message;
73         
74 		if (AccountLocation[_etherAddress] == 0){
75 		    migrationAccountCounter += 1;
76 		    location = migrationAccountCounter;
77 		    
78 		    message = creditbitContract.mintMigrationTokens(_etherAddress, _numberOfCoins);
79 		    if (message == 0 && address(creditbitContract) != 0x0){
80 		        MigrationAccounts[location].legacyCreditAddresses = _legacyCreditAddress;
81 		        MigrationAccounts[location].newCreditAddress = _etherAddress;
82                 MigrationAccounts[location].creditbitsDeposited = _numberOfCoins;
83 		        MigrationAccounts[location].newTotalSupplyVote = _totalSupplyVote;
84 		        MigrationAccounts[location].coreDevteamRewardVote = _coreDevTeamReward;
85 		        AccountLocation[_etherAddress] = location;
86 		        
87 		        creditsExchanged += _numberOfCoins;
88 		        calculateVote(_totalSupplyVote, _coreDevTeamReward, _numberOfCoins);
89 		    }else{
90 		        return 1;
91 		    }
92 		}else{
93 		    location = AccountLocation[_etherAddress];
94 		    message = creditbitContract.mintMigrationTokens(_etherAddress, _numberOfCoins);
95 		    if (message == 0 && address(creditbitContract) != 0x0){
96 		        MigrationAccounts[location].creditbitsDeposited += _numberOfCoins;
97 		        
98 		        creditsExchanged += _numberOfCoins;
99 		        calculateVote(_totalSupplyVote, _coreDevTeamReward, _numberOfCoins);
100 		    }else{
101 		        return 1;
102 		    }
103 		}
104 		return 0;
105 	}
106 	//todo: check on testnet
107     function calculateVote(uint _newSupplyVote, uint _newRewardVote, uint _numOfVotes) internal{
108         uint newSupply = (realVotedSupply * realSupplyWeight + _newSupplyVote * _numOfVotes) / (realSupplyWeight + _numOfVotes);
109         uint newDevReward = (1000000*realDevReward * realDevRewardWeight + 1000000 * _newRewardVote * _numOfVotes) / (realDevRewardWeight + _numOfVotes);
110     
111         realVotedSupply = newSupply;
112         realSupplyWeight = realSupplyWeight + _numOfVotes;
113         realDevReward = newDevReward/1000000;
114         realDevRewardWeight = realDevRewardWeight + _numOfVotes;
115     }
116 
117 	function setCreditMCCurator(address _curatorAddress) returns (uint error){
118 		if (msg.sender != dev){ return 1; }
119 
120 		curator = _curatorAddress;
121 		return 0;
122 	}
123 	
124 	function setCreditbit(address _bitAddress) returns (uint error){
125         if (msg.sender != dev) {return 1;}
126         
127         creditbitContract = ICreditBIT(_bitAddress);
128         return 0;
129     }
130     function getCreditbitAddress() constant returns (address bitAddress){
131         return address(creditbitContract);
132     }
133     
134     function endMigration() returns (uint error){
135         if (msg.sender != dev){ return 1; }
136         
137         migrationEnded = true;
138         return 0;
139     }
140     
141 	
142     function claimDevReward(address _recipient) returns (uint error){
143         if (msg.sender != dev){ return 1; }
144         if (devRewardClaimed){ return 1; }
145         if (!migrationEnded){ return 1;}
146         
147         uint message = creditbitContract.mintMigrationTokens(
148             _recipient, 
149             (((realVotedSupply - creditsExchanged) * (realDevReward)) / 10000)
150         );
151         if (message != 0) { return 1; }
152         
153         creditsExchanged += (((realVotedSupply - creditsExchanged) * (realDevReward)) / 10000);
154         devRewardClaimed = true;
155         return 0;
156     }
157     
158     function claimDaoStakeSupply(address _recipient) returns (uint error){
159         if (msg.sender != dev){ return 1; }
160         if (!devRewardClaimed){ return 1; }
161         if (!migrationEnded){ return 1; }
162         if (daoStakeClaimed){ return 1; }
163         
164         uint message = creditbitContract.mintMigrationTokens(
165             _recipient, 
166             realVotedSupply - creditsExchanged
167         );
168         if (message != 0) { return 1; }
169         
170         creditsExchanged += (realVotedSupply - creditsExchanged);
171         daoStakeClaimed = true;
172         return 0;
173     }
174     
175 
176 	function () {
177 		throw;
178 	}
179 }
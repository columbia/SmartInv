1 contract ICreditBIT {
2     function totalSupply() constant returns (uint256 supply) {}
3     function mintMigrationTokens(address _reciever, uint _amount) returns (uint error) {}
4     function getAccountData(address _owner) constant returns (uint avaliableBalance, uint lockedBalance, uint bondMultiplier, uint lockedUntilBlock, uint lastBlockClaimed) {}
5 }
6 
7 contract ICreditIDENTITY {
8     function getAddressDescription(address _queryAddress) constant returns (string){}
9 }
10 
11 contract ICreditDAOfund {
12     function withdrawReward(address _destination) {}
13     function setCreditBondContract(address _creditBondAddress) {}
14     function setCreditBitContract(address _creditBitAddress) {}
15     function setFundsCreditDaoAddress(address _creditDaoAddress) {}
16     function claimBondReward() {}
17     function setCreditDaoAddress(address _creditDaoAddress) {}
18     function lockTokens(uint _multiplier) {}
19 
20 }
21 
22 contract CreditDAO {
23     struct Election {
24         uint startBlock;
25         uint endBlock;
26         uint totalCrbSupply;
27         bool electionsFinished;
28 
29         uint nextCandidateIndex;
30         mapping(uint => address) candidateIndex;
31         mapping(address => uint) candidateAddyToIndexMap;
32         mapping(uint => uint) candidateVotes;
33         mapping(address => bool) candidates;
34 
35         mapping(address => bool) userHasVoted;
36 
37         address maxVotes;
38         uint numOfMaxVotes;
39         uint idProcessed;
40     }
41 
42     uint public nextElectionIndex;
43     mapping(uint => Election) public elections;
44 
45     address public creditCEO;
46     uint public mandateInBlocks = 927530;
47     uint public blocksPerMonth = 76235;
48 
49     ICreditBIT creditBitContract = ICreditBIT(0xAef38fBFBF932D1AeF3B808Bc8fBd8Cd8E1f8BC5);
50     ICreditDAOfund creditDAOFund;
51 
52     modifier onlyCEO {
53         require(msg.sender == creditCEO);
54         _;
55     }
56     
57     function CreditDAO() {
58         elections[nextElectionIndex].startBlock = block.number;
59         elections[nextElectionIndex].endBlock = block.number + blocksPerMonth;
60         elections[nextElectionIndex].totalCrbSupply = creditBitContract.totalSupply();
61         nextElectionIndex++;
62     }
63 
64     // Election part
65     function createNewElections() {
66         require(elections[nextElectionIndex - 1].endBlock + mandateInBlocks < block.number);
67 
68         elections[nextElectionIndex].startBlock = block.number;
69         elections[nextElectionIndex].endBlock = block.number + blocksPerMonth;
70         elections[nextElectionIndex].totalCrbSupply = creditBitContract.totalSupply();
71         nextElectionIndex++;
72 
73         creditCEO = 0x0;
74     }
75 
76     function sumbitForElection() {
77         require(elections[nextElectionIndex - 1].endBlock > block.number);
78         require(!elections[nextElectionIndex - 1].candidates[msg.sender]);
79 
80         uint nextCandidateId = elections[nextElectionIndex].nextCandidateIndex;
81         elections[nextElectionIndex - 1].candidateIndex[nextCandidateId] = msg.sender;
82         elections[nextElectionIndex - 1].candidateAddyToIndexMap[msg.sender] = nextCandidateId;
83         elections[nextElectionIndex - 1].nextCandidateIndex++;
84         elections[nextElectionIndex - 1].candidates[msg.sender] = true;
85         
86     }
87 
88     function vote(address _participant) {
89         require(elections[nextElectionIndex - 1].endBlock > block.number);
90         
91         uint avaliableBalance;
92         uint lockedBalance;
93         uint bondMultiplier; 
94         uint lockedUntilBlock; 
95         uint lastBlockClaimed; 
96         (avaliableBalance, lockedBalance, bondMultiplier, lockedUntilBlock, lastBlockClaimed) = creditBitContract.getAccountData(msg.sender);
97         require(lockedUntilBlock >= elections[nextElectionIndex - 1].endBlock);
98         require(!elections[nextElectionIndex - 1].userHasVoted[msg.sender]);
99         uint candidateId = elections[nextElectionIndex - 1].candidateAddyToIndexMap[_participant];
100         elections[nextElectionIndex - 1].candidateVotes[candidateId] += lockedBalance;
101         elections[nextElectionIndex - 1].userHasVoted[msg.sender] = true;
102     }
103 
104     function finishElections(uint _iterations) {
105         require(elections[nextElectionIndex - 1].endBlock < block.number);
106         require(!elections[nextElectionIndex - 1].electionsFinished);
107 
108         uint curentVotes;
109         uint nextCandidateId = elections[nextElectionIndex - 1].idProcessed;
110         for (uint cnt = 0; cnt < _iterations; cnt++) {
111             curentVotes = elections[nextElectionIndex - 1].candidateVotes[nextCandidateId];
112             if (curentVotes > elections[nextElectionIndex - 1].numOfMaxVotes) {
113                 elections[nextElectionIndex - 1].maxVotes = elections[nextElectionIndex - 1].candidateIndex[nextCandidateId];
114                 elections[nextElectionIndex - 1].numOfMaxVotes = curentVotes;
115             }
116             nextCandidateId++;
117         }
118         elections[nextElectionIndex - 1].idProcessed = nextCandidateId;
119         if (elections[nextElectionIndex - 1].candidateIndex[nextCandidateId] == 0x0) {
120             creditCEO = elections[nextElectionIndex - 1].maxVotes;
121             elections[nextElectionIndex - 1].electionsFinished = true;
122 
123             if (elections[nextElectionIndex - 1].numOfMaxVotes == 0) {
124                 elections[nextElectionIndex].startBlock = block.number;
125                 elections[nextElectionIndex].endBlock = block.number + blocksPerMonth;
126                 elections[nextElectionIndex].totalCrbSupply = creditBitContract.totalSupply();
127                 nextElectionIndex++;
128             }
129         }
130     }
131 
132     // CEO part
133     function claimBondReward() onlyCEO {
134 		creditDAOFund.claimBondReward();
135 	}
136 
137     function withdrawBondReward(address _addy) onlyCEO {
138         creditDAOFund.withdrawReward(_addy);
139     }
140 
141     function lockTokens(uint _multiplier) onlyCEO {
142         creditDAOFund.lockTokens(_multiplier);
143     }
144 
145     function setCreditBitContract(address _newCreditBitAddress) onlyCEO {
146         creditBitContract = ICreditBIT(_newCreditBitAddress);
147     }
148 
149     function setMandateInBlocks(uint _newMandateInBlocks) onlyCEO {
150         mandateInBlocks = _newMandateInBlocks;
151     }
152 
153     function setblocksPerMonth(uint _newblocksPerMonth) onlyCEO {
154         blocksPerMonth = _newblocksPerMonth;
155     }
156 
157     
158     function setCreditDaoFund(address _newCreditDaoFundAddress) onlyCEO {
159         creditDAOFund = ICreditDAOfund(_newCreditDaoFundAddress);
160     }
161 
162     // Fund methods
163     function setFundsCreditDaoAddress(address _creditDaoAddress) onlyCEO {
164 	    creditDAOFund.setCreditDaoAddress(_creditDaoAddress);
165 	}
166 	
167 	function setFundsCreditBitContract(address _creditBitAddress) onlyCEO {
168         creditDAOFund.setCreditBitContract(_creditBitAddress);
169 	}
170 	
171 	function setFundsCreditBondContract(address _creditBondAddress) onlyCEO {
172         creditDAOFund.setCreditBondContract(_creditBondAddress);
173 	}
174 
175     function getCreditFundAddress() constant returns (address) {
176         return address(creditDAOFund);
177     }
178 
179     function getCreditBitAddress() constant returns (address) {
180         return address(creditBitContract);
181     }
182 }
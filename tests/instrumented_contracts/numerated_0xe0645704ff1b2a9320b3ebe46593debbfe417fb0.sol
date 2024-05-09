1 pragma solidity ^0.4.17;
2 
3 contract owned {
4     
5     address public owner;
6     
7     function owned() {
8         owner = msg.sender;
9     }
10     
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15     
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 contract ITestekToken {
22   function mintTokens(address _to, uint256 _amount);
23   function totalSupply() constant returns (uint256 totalSupply);
24 }
25 
26 contract IERC20Token {
27   function totalSupply() constant returns (uint256 totalSupply);
28   function balanceOf(address _owner) constant returns (uint256 balance) {}
29   function transfer(address _to, uint256 _value) returns (bool success) {}
30   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31   function approve(address _spender, uint256 _value) returns (bool success) {}
32   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34   event Transfer(address indexed _from, address indexed _to, uint256 _value);
35   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract TestekCrowdsale is owned {
39     uint256 public startBlock;
40     uint256 public endBlock;
41     uint256 public minEthToRaise;
42     uint256 public maxEthToRaise;
43     uint256 public totalEthRaised;
44     address public multisigAddress;
45     
46     ITestekToken TestekTokenContract; 
47 
48     uint256 nextFreeParticipantIndex;
49     mapping (uint => address) participantIndex;
50     mapping (address => uint256) participantContribution;
51     
52     bool crowdsaleHasStarted;
53     bool softCapReached;
54     bool hardCapReached;
55     bool crowdsaleHasSucessfulyEnded;
56     uint256 blocksInADay;
57     bool ownerHasClaimedTokens;
58     
59     uint256 lastEthReturnIndex;
60     mapping (address => bool) hasClaimedEthWhenFail;
61     
62     event CrowdsaleStarted(uint256 _blockNumber);
63     event CrowdsaleSoftCapReached(uint256 _blockNumber);
64     event CrowdsaleHardCapReached(uint256 _blockNumber);
65     event CrowdsaleEndedSuccessfuly(uint256 _blockNumber, uint256 _amountRaised);
66     event Crowdsale(uint256 _blockNumber, uint256 _ammountRaised);
67     event ErrorSendingETH(address _from, uint256 _amount);
68     
69     function TestekCrowdsale(uint256 _startBlock, address _multisigAddress){
70         
71         blocksInADay = 300;
72         startBlock = _startBlock;
73         endBlock = _startBlock + blocksInADay * 29;      
74         minEthToRaise = 3 * 10**18;                     
75         maxEthToRaise = 33 * 10**18;                 
76         multisigAddress = _multisigAddress;
77     }
78     
79   //  
80   /* User accessible methods */   
81   //  
82     
83     function () payable{
84       if(msg.value == 0) throw;
85       if (crowdsaleHasSucessfulyEnded || block.number > endBlock) throw;        // Throw if the Crowdsale has ended     
86       if (!crowdsaleHasStarted){                                                // Check if this is the first Crowdsale transaction       
87         if (block.number >= startBlock){                                        // Check if the Crowdsale should start        
88           crowdsaleHasStarted = true;                                           // Set that the Crowdsale has started         
89           CrowdsaleStarted(block.number);                                       // Raise CrowdsaleStarted event     
90         } else{
91           throw;
92         }
93       }
94       if (participantContribution[msg.sender] == 0){                            // Check if the sender is a new user       
95         participantIndex[nextFreeParticipantIndex] = msg.sender;                // Add a new user to the participant index       
96         nextFreeParticipantIndex += 1;
97       }  
98       if (maxEthToRaise > (totalEthRaised + msg.value)){                        // Check if the user sent too much ETH       
99         participantContribution[msg.sender] += msg.value;                       // Add contribution      
100         totalEthRaised += msg.value; // Add to total eth Raised
101         TestekTokenContract.mintTokens(msg.sender, getTestekTokenIssuance(block.number, msg.value));
102         if (!softCapReached && totalEthRaised >= minEthToRaise){                // Check if the min treshold has been reached one time        
103           CrowdsaleSoftCapReached(block.number);                                // Raise CrowdsalesoftCapReached event        
104           softCapReached = true;                                                // Set that the min treshold has been reached       
105         }     
106       }else{                                                                    // If user sent to much eth       
107         uint maxContribution = maxEthToRaise - totalEthRaised;                  // Calculate maximum contribution       
108         participantContribution[msg.sender] += maxContribution;                 // Add maximum contribution to account      
109         totalEthRaised += maxContribution;  
110         TestekTokenContract.mintTokens(msg.sender, getTestekTokenIssuance(block.number, maxContribution));
111         uint toReturn = msg.value - maxContribution;                            // Calculate how much should be returned       
112         crowdsaleHasSucessfulyEnded = true;                                     // Set that Crowdsale has successfully ended    
113         CrowdsaleHardCapReached(block.number);
114         hardCapReached = true;
115         CrowdsaleEndedSuccessfuly(block.number, totalEthRaised);      
116         if(!msg.sender.send(toReturn)){                                        // Refund the balance that is over the cap         
117           ErrorSendingETH(msg.sender, toReturn);                               // Raise event for manual return if transaction throws       
118         }     
119       }     
120     }
121     
122     /* Users can claim ETH by themselves if they want to in case of ETH failure */   
123     function claimEthIfFailed(){    
124       if (block.number <= endBlock || totalEthRaised >= minEthToRaise) throw; // Check if Crowdsale has failed    
125       if (participantContribution[msg.sender] == 0) throw;                    // Check if user has participated     
126       if (hasClaimedEthWhenFail[msg.sender]) throw;                           // Check if this account has already claimed ETH    
127       uint256 ethContributed = participantContribution[msg.sender];           // Get participant ETH Contribution     
128       hasClaimedEthWhenFail[msg.sender] = true;     
129       if (!msg.sender.send(ethContributed)){      
130         ErrorSendingETH(msg.sender, ethContributed);                          // Raise event if send failed, solve manually     
131       }   
132     } 
133 
134     /* Owner can return eth for multiple users in one call */  
135     function batchReturnEthIfFailed(uint256 _numberOfReturns) onlyOwner{    
136       if (block.number < endBlock || totalEthRaised >= minEthToRaise) throw;    // Check if Crowdsale failed  
137       address currentParticipantAddress;    
138       uint256 contribution;
139       for (uint cnt = 0; cnt < _numberOfReturns; cnt++){      
140         currentParticipantAddress = participantIndex[lastEthReturnIndex];       // Get next account       
141         if (currentParticipantAddress == 0x0) return;                           // Check if participants were reimbursed      
142         if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                // Check if user has manually recovered ETH         
143           contribution = participantContribution[currentParticipantAddress];    // Get accounts contribution        
144           hasClaimedEthWhenFail[msg.sender] = true;                             // Set that user got his ETH back         
145           if (!currentParticipantAddress.send(contribution)){                   // Send fund back to account          
146              ErrorSendingETH(currentParticipantAddress, contribution);           // Raise event if send failed, resolve manually         
147           }       
148         }       
149         lastEthReturnIndex += 1;    
150       }   
151     }
152       
153     /* Owner sets new address of escrow */
154     function changeMultisigAddress(address _newAddress) onlyOwner {     
155       multisigAddress = _newAddress;
156     } 
157     
158     /* Show how many participants was */
159     function participantCount() constant returns(uint){
160       return nextFreeParticipantIndex;
161     }
162 
163     /* Owner can claim reserved tokens on the end of crowsale */  
164     function claimTeamTokens(address _to) onlyOwner{     
165       if (!crowdsaleHasSucessfulyEnded) throw; 
166       if (ownerHasClaimedTokens) throw;
167         
168       TestekTokenContract.mintTokens(_to, TestekTokenContract.totalSupply() * 49/51); /* 51% Crowdsale - 49% Testek */
169       ownerHasClaimedTokens = true;
170     } 
171       
172     /* Set token contract where mints will be done (tokens will be issued) */  
173     function setTokenContract(address _TestekTokenContractAddress) onlyOwner {     
174       TestekTokenContract = ITestekToken(_TestekTokenContractAddress);   
175     }   
176        
177     function getTestekTokenIssuance(uint256 _blockNumber, uint256 _ethSent) constant returns(uint){
178       if (_blockNumber >= startBlock && _blockNumber < startBlock + blocksInADay * 2) return _ethSent * 3540;
179       if (_blockNumber >= startBlock + blocksInADay * 2 && _blockNumber < startBlock + blocksInADay * 7) return _ethSent * 3289; 
180       if (_blockNumber >= startBlock + blocksInADay * 7 && _blockNumber < startBlock + blocksInADay * 14) return _ethSent * 3184; 
181       if (_blockNumber >= startBlock + blocksInADay * 14 && _blockNumber < startBlock + blocksInADay * 21) return _ethSent * 3097; 
182       if (_blockNumber >= startBlock + blocksInADay * 21 ) return _ethSent * 3009;
183     }
184     
185     /* Withdraw funds from contract */  
186     function withdrawEther() onlyOwner{     
187       if (this.balance == 0) throw;                                            // Check if there is balance on the contract     
188       if (totalEthRaised < minEthToRaise) throw;                               // Check if minEthToRaise treshold is exceeded     
189           
190       if(multisigAddress.send(this.balance)){}                                 // Send the contract's balance to multisig address   
191     }
192 
193     function endCrowdsale() onlyOwner{
194       if (totalEthRaised < minEthToRaise) throw;
195       if (block.number < endBlock) throw;
196       crowdsaleHasSucessfulyEnded = true;
197       CrowdsaleEndedSuccessfuly(block.number, totalEthRaised);
198     }
199     
200     
201     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
202     IERC20Token(_tokenAddress).transfer(_to, _amount);
203     }
204     /* Getters */     
205     
206     function getTSTTokenAddress() constant returns(address _tokenAddress){    
207       return address(TestekTokenContract);   
208     }   
209     
210     function crowdsaleInProgress() constant returns (bool answer){    
211       return crowdsaleHasStarted && !crowdsaleHasSucessfulyEnded;   
212     }   
213     
214     function participantContributionInEth(address _querryAddress) constant returns (uint256 answer){    
215       return participantContribution[_querryAddress];   
216     }
217     
218     /* Withdraw remaining balance to manually return where contract send has failed */  
219     function withdrawRemainingBalanceForManualRecovery() onlyOwner{     
220       if (this.balance == 0) throw;                                         // Check if there is balance on the contract    
221       if (block.number < endBlock) throw;                                   // Check if Crowdsale failed    
222       if (participantIndex[lastEthReturnIndex] != 0x0) throw;               // Check if all the participants have been reimbursed     
223       if (multisigAddress.send(this.balance)){}                             // Send remainder so it can be manually processed   
224     }
225 }
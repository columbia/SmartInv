1 contract owned {
2 
3   address public owner;
4 
5   function owned() {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner {
10     if (msg.sender != owner) throw;
11     _;
12   }
13 
14   function transferOwnership(address newOwner) onlyOwner {
15     owner = newOwner;
16   }
17 }
18 
19 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
20 
21 contract ISncToken {
22   function mintTokens(address _to, uint256 _amount);
23   function totalSupply() constant returns (uint256 totalSupply);
24 }
25 
26 contract SunContractIco is owned{
27 
28   uint256 public startBlock;
29   uint256 public endBlock;
30   uint256 public minEthToRaise;
31   uint256 public maxEthToRaise;
32   uint256 public totalEthRaised;
33   address public multisigAddress;
34 
35 
36   ISncToken sncTokenContract; 
37   mapping (address => bool) presaleContributorAllowance;
38   uint256 nextFreeParticipantIndex;
39   mapping (uint => address) participantIndex;
40   mapping (address => uint256) participantContribution;
41 
42   bool icoHasStarted;
43   bool minTresholdReached;
44   bool icoHasSucessfulyEnded;
45   uint256 blocksInWeek;
46     bool ownerHasClaimedTokens;
47 
48   uint256 lastEthReturnIndex;
49   mapping (address => bool) hasClaimedEthWhenFail;
50 
51   event ICOStarted(uint256 _blockNumber);
52   event ICOMinTresholdReached(uint256 _blockNumber);
53   event ICOEndedSuccessfuly(uint256 _blockNumber, uint256 _amountRaised);
54   event ICOFailed(uint256 _blockNumber, uint256 _ammountRaised);
55   event ErrorSendingETH(address _from, uint256 _amount);
56 
57   function SunContractIco(uint256 _startBlock, address _multisigAddress) {
58     blocksInWeek = 4 * 60 * 24 * 7;
59     startBlock = _startBlock;
60     endBlock = _startBlock + blocksInWeek * 4;
61     minEthToRaise = 5000 * 10**18;
62     maxEthToRaise = 100000 * 10**18;
63     multisigAddress = _multisigAddress;
64   }
65 
66   //  
67   /* User accessible methods */   
68   //  
69 
70   /* Users send ETH and enter the token sale*/  
71   function () payable {
72     if (msg.value == 0) throw;                                          // Throw if the value is 0  
73     if (icoHasSucessfulyEnded || block.number > endBlock) throw;        // Throw if the ICO has ended     
74     if (!icoHasStarted){                                                // Check if this is the first ICO transaction       
75       if (block.number >= startBlock){                                  // Check if the ICO should start        
76         icoHasStarted = true;                                           // Set that the ICO has started         
77         ICOStarted(block.number);                                       // Raise ICOStarted event     
78       } else{
79         throw;
80       }
81     }     
82     if (participantContribution[msg.sender] == 0){                     // Check if the sender is a new user       
83       participantIndex[nextFreeParticipantIndex] = msg.sender;         // Add a new user to the participant index       
84       nextFreeParticipantIndex += 1;
85     }     
86     if (maxEthToRaise > (totalEthRaised + msg.value)){                 // Check if the user sent too much ETH       
87       participantContribution[msg.sender] += msg.value;                // Add contribution      
88       totalEthRaised += msg.value;// Add to total eth Raised
89       sncTokenContract.mintTokens(msg.sender, getSncTokenIssuance(block.number, msg.value));
90       if (!minTresholdReached && totalEthRaised >= minEthToRaise){      // Check if the min treshold has been reached one time        
91         ICOMinTresholdReached(block.number);                            // Raise ICOMinTresholdReached event        
92         minTresholdReached = true;                                      // Set that the min treshold has been reached       
93       }     
94     }else{                                                              // If user sent to much eth       
95       uint maxContribution = maxEthToRaise - totalEthRaised;            // Calculate maximum contribution       
96       participantContribution[msg.sender] += maxContribution;           // Add maximum contribution to account      
97       totalEthRaised += maxContribution;  
98       sncTokenContract.mintTokens(msg.sender, getSncTokenIssuance(block.number, maxContribution));
99       uint toReturn = msg.value - maxContribution;                       // Calculate how much should be returned       
100       icoHasSucessfulyEnded = true;                                      // Set that ICO has successfully ended       
101       ICOEndedSuccessfuly(block.number, totalEthRaised);      
102       if(!msg.sender.send(toReturn)){                                    // Refund the balance that is over the cap         
103         ErrorSendingETH(msg.sender, toReturn);                           // Raise event for manual return if transaction throws       
104       }     
105     }
106   }   
107 
108   /* Users can claim ETH by themselves if they want to in case of ETH failure*/   
109   function claimEthIfFailed(){    
110     if (block.number <= endBlock || totalEthRaised >= minEthToRaise) throw; // Check if ICO has failed    
111     if (participantContribution[msg.sender] == 0) throw;                    // Check if user has participated     
112     if (hasClaimedEthWhenFail[msg.sender]) throw;                           // Check if this account has already claimed ETH    
113     uint256 ethContributed = participantContribution[msg.sender];           // Get participant ETH Contribution     
114     hasClaimedEthWhenFail[msg.sender] = true;     
115     if (!msg.sender.send(ethContributed)){      
116       ErrorSendingETH(msg.sender, ethContributed);                          // Raise event if send failed, solve manually     
117     }   
118   }   
119 
120   //  
121   /* Only owner methods */  
122   //  
123 
124   /* Adds addresses that are allowed to take part in presale */   
125   function addPresaleContributors(address[] _presaleContributors) onlyOwner {     
126     for (uint cnt = 0; cnt < _presaleContributors.length; cnt++){       
127       presaleContributorAllowance[_presaleContributors[cnt]] = true;    
128     }   
129   }   
130 
131   /* Owner can return eth for multiple users in one call*/  
132   function batchReturnEthIfFailed(uint256 _numberOfReturns) onlyOwner{    
133     if (block.number < endBlock || totalEthRaised >= minEthToRaise) throw;    // Check if ICO failed  
134     address currentParticipantAddress;    
135     uint256 contribution;
136     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){      
137       currentParticipantAddress = participantIndex[lastEthReturnIndex];       // Get next account       
138       if (currentParticipantAddress == 0x0) return;                           // Check if participants were reimbursed      
139       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                // Check if user has manually recovered ETH         
140         contribution = participantContribution[currentParticipantAddress];    // Get accounts contribution        
141         hasClaimedEthWhenFail[msg.sender] = true;                             // Set that user got his ETH back         
142         if (!currentParticipantAddress.send(contribution)){                   // Send fund back to account          
143           ErrorSendingETH(currentParticipantAddress, contribution);           // Raise event if send failed, resolve manually         
144         }       
145       }       
146       lastEthReturnIndex += 1;    
147     }   
148   }   
149 
150   /* Owner sets new address of SunContractToken */
151   function changeMultisigAddress(address _newAddress) onlyOwner {     
152     multisigAddress = _newAddress;
153   }   
154 
155   /* Owner can claim reserved tokens on the end of crowsale */  
156   function claimCoreTeamsTokens(address _to) onlyOwner{     
157     if (!icoHasSucessfulyEnded) throw; 
158     if (ownerHasClaimedTokens) throw;
159     
160     sncTokenContract.mintTokens(_to, sncTokenContract.totalSupply() * 25 / 100);
161     ownerHasClaimedTokens = true;
162   }   
163 
164   /* Owner can remove allowance of designated presale contributor */  
165   function removePresaleContributor(address _presaleContributor) onlyOwner {    
166     presaleContributorAllowance[_presaleContributor] = false;   
167   }   
168 
169   /* Set token contract where mints will be done (tokens will be issued)*/  
170   function setTokenContract(address _sncTokenContractAddress) onlyOwner {     
171     sncTokenContract = ISncToken(_sncTokenContractAddress);   
172   }   
173 
174   /* Withdraw funds from contract */  
175   function withdrawEth() onlyOwner{     
176     if (this.balance == 0) throw;                                            // Check if there is balance on the contract     
177     if (totalEthRaised < minEthToRaise) throw;                               // Check if minEthToRaise treshold is exceeded     
178       
179     if(multisigAddress.send(this.balance)){}                                 // Send the contract's balance to multisig address   
180   }
181   
182   function endIco() onlyOwner {
183       if (totalEthRaised < minEthToRaise) throw;
184       if (block.number < endBlock) throw;
185   
186     icoHasSucessfulyEnded = true;
187     ICOEndedSuccessfuly(block.number, totalEthRaised);
188   }
189 
190   /* Withdraw remaining balance to manually return where contract send has failed */  
191   function withdrawRemainingBalanceForManualRecovery() onlyOwner{     
192     if (this.balance == 0) throw;                                         // Check if there is balance on the contract    
193     if (block.number < endBlock) throw;                                   // Check if ICO failed    
194     if (participantIndex[lastEthReturnIndex] != 0x0) throw;               // Check if all the participants have been reimbursed     
195     if (multisigAddress.send(this.balance)){}                             // Send remainder so it can be manually processed   
196   }
197 
198   //  
199   /* Getters */   
200   //  
201 
202   function getSncTokenAddress() constant returns(address _tokenAddress){    
203     return address(sncTokenContract);   
204   }   
205 
206   function icoInProgress() constant returns (bool answer){    
207     return icoHasStarted && !icoHasSucessfulyEnded;   
208   }   
209 
210   function isAddressAllowedInPresale(address _querryAddress) constant returns (bool answer){    
211     return presaleContributorAllowance[_querryAddress];   
212   }   
213 
214   function participantContributionInEth(address _querryAddress) constant returns (uint256 answer){    
215     return participantContribution[_querryAddress];   
216   }
217   
218   function getSncTokenIssuance(uint256 _blockNumber, uint256 _ethSent) constant returns(uint){
219         if (_blockNumber >= startBlock && _blockNumber < blocksInWeek + startBlock) {
220           if (presaleContributorAllowance[msg.sender]) return _ethSent * 11600;
221           else return _ethSent * 11500;
222         }
223         if (_blockNumber >= blocksInWeek + startBlock && _blockNumber < blocksInWeek * 2 + startBlock) return _ethSent * 11000;
224         if (_blockNumber >= blocksInWeek * 2 + startBlock && _blockNumber < blocksInWeek * 3 + startBlock) return _ethSent * 10500;
225         if (_blockNumber >= blocksInWeek * 3 + startBlock && _blockNumber <= blocksInWeek * 4 + startBlock) return _ethSent * 10000;
226     }
227 
228   //
229   /* This part is here only for testing and will not be included into final version */
230   //
231   //function killContract() onlyOwner{
232   //  selfdestruct(msg.sender);
233   //}
234 }
1 pragma solidity ^0.4.2;
2 
3 contract NTRYToken{
4    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
5    function takeBackNTRY(address _from,address _to, uint256 _value) returns (bool);
6 }
7 
8 contract PreICO {
9    
10     address owner;
11     modifier onlyOwner {if (msg.sender != owner) throw; _;}
12 
13     struct Contribution {
14         uint256 amount;
15         uint currentPrice;
16         uint256 NTRY;
17         address contributor;
18     }
19     
20     // public variables
21     Contribution[] public contributions;
22     mapping (address => Contribution) rewardsLedger;
23     
24     address beneficiary;
25     
26     uint256 constant tokensAsReward =  3500000 * 1 ether;
27     uint PRICE = 875;                 // 1 ether = 875 NTRY tokens
28     uint256 fundingGoal = 3990 * 1 ether;
29     
30     uint256 remainingTokens = tokensAsReward;
31     uint256 amountRaised = 0;                          // Funds raised in ethers
32    
33     bool preICOClosed = false;
34     bool returnFunds = false;
35 
36     // Time limit for PRE-ICO
37     uint public deadline = now + (40320 * 1 minutes);    
38     NTRYToken private notaryToken;
39     address private recoveryAccount;
40     
41     event GoalReached(address owner, uint amountRaised);
42     event LogFundingReceived(address contributor, uint amount, uint currentTotal);
43     event FundTransfer(address backer, uint amount, bool isContribution);
44 
45     // Initialize the contract
46     function PreICO(){
47         owner = 0x1538EF80213cde339A333Ee420a85c21905b1b2D;
48         notaryToken = NTRYToken(0x67cE771AF21FD013FAA48ac04D35Aa1F20F9F7a6);
49         beneficiary = 0x1D1739F37a103f0D7a5f5736fEd2E77DE9863450;   
50         recoveryAccount = 0x543d99C00686628b677A8b03a4E7A9Ac60023727;  // In case pre-ICO failed, NTRY will be recoverd back to this address
51     }
52 
53     /* Geter functions for variables */
54     
55     function preICOBeneficiaryAddress() constant returns(address){ return beneficiary; }
56     function NTRYAvailableForSale() constant returns(uint256){ return tokensAsReward; }
57     function NTRYPerEther() constant returns(uint){ return PRICE; }
58     function minimumFundingGoal() constant returns(uint256){ return fundingGoal; }
59     function remaingNTRY() constant returns(uint256){ return remainingTokens; }
60     function RaisedFunds() constant returns(uint256){ return amountRaised; }
61     function isPreICOClosed() constant returns(bool){ return preICOClosed; }
62 
63     /* Set price of NTRY corresponding to ether */
64     // @param _price Number of NTRY per ether
65     function updatePrice(uint _price) onlyOwner {
66         PRICE = _price;  
67     }
68 
69     function transferOwnership(address _newOwner) onlyOwner {
70         owner = _newOwner;
71     }
72 
73     // Recieve funds and rewards tokens
74     function () payable {
75         if(preICOClosed || msg.value <= 0){ throw; }       // return if pre-ico is closed or received funds are zero
76         uint256 amount = msg.value * PRICE;                // calculates the amount of NTRY
77         if (remainingTokens >= amount){
78             amount = addBonuses(amount);
79             if (notaryToken.transferFrom(owner, msg.sender, amount)){
80                 amountRaised += msg.value;
81                 updateRewardLedger(msg.sender,msg.value,amount);
82                 LogFundingReceived(msg.sender, msg.value, amountRaised);
83             }else{ throw; }
84         }else{
85             throw;
86         }  
87     }
88     
89     function updateRewardLedger(address _contributor,uint256 eth,uint256 ntry) {
90         if (rewardsLedger[_contributor].contributor == 0){
91             rewardsLedger[_contributor] = Contribution({
92                 amount: eth,
93                 currentPrice: PRICE,
94                 NTRY: ntry,
95                 contributor: _contributor
96             });
97             contributions.push(rewardsLedger[_contributor]);
98         }else{
99             rewardsLedger[_contributor].amount += eth;
100             rewardsLedger[_contributor].currentPrice = 0;
101             rewardsLedger[_contributor].NTRY += ntry;
102             contributions.push(Contribution({
103                     amount: eth,
104                     currentPrice: PRICE,
105                     NTRY: ntry,
106                     contributor: _contributor
107                     })
108             );
109         }
110     }
111     
112 
113     /* For the first 1.500.000 NTRY tokens investors will get additional 125% of their investment.
114     The second 1.000.000 NTRY tokens investors will get additional 100% of their investment.
115     And for last 1.000.000 NTRY tokens investors will get additional 62.5% of their investment. */
116     /// @param _amount NTRY tokens inverster get in return of fund
117     function addBonuses(uint256 _amount) returns(uint256){
118         uint256 reward;
119         var (x, y) = (reward,reward);                // define type at compile at time
120         if(remainingTokens > 2000000 * 1 ether){
121             (x, y) = levelOneBonus(_amount);
122              reward += x;
123             if(y != 0){
124                 (x, y) = levelTwoBonus(y);
125                 reward += x;
126                 if(y != 0){
127                     return reward+levelThreeBonus(y);
128                 }
129             }
130             return reward;
131         }else if(remainingTokens > 1000000 * 1 ether){
132             (x, y) = levelTwoBonus(_amount);
133             if(y != 0){
134                 return x+levelThreeBonus(y);
135             }
136             return x;
137         }else{
138             return levelThreeBonus(_amount);
139         }
140     }
141 
142     /* Add 125% bonus */
143     /// @param _amount NTRY tokens inverster have purchased
144     function levelOneBonus(uint256 _amount)returns(uint256,uint256){
145         uint256 available = remainingTokens - 2000000 * 1 ether;
146         if(available >= _amount){
147             remainingTokens -= _amount;
148             return (_amount * 9/4, 0);
149         }else{
150             remainingTokens -= available;
151             return(available * 9/4, _amount - available);
152         }
153     }
154 
155     /* Add 100% bonus */
156     /// @param _amount NTRY tokens inverster have purchased
157     function levelTwoBonus(uint256 _amount)returns(uint256,uint256){
158         uint256 available = remainingTokens - 1000000 * 1 ether;
159         if(available >= _amount){
160             remainingTokens -= _amount;
161             return (_amount * 2, 0);
162         }else{
163             remainingTokens -= available;
164             return(available * 2, _amount - available);
165         }
166     }
167 
168     /* Add 62.5% bonus */
169     /// @param _amount NTRY tokens inverster have purchased
170     function levelThreeBonus(uint256 _amount)returns(uint256){
171         remainingTokens -= _amount;
172         return _amount * 13/8;
173     } 
174 
175     modifier afterDeadline() { if (now >= deadline) _; }
176     
177     function checkGoalReached() afterDeadline {
178         if(amountRaised >= fundingGoal){
179             GoalReached(beneficiary, amountRaised);
180             returnFunds = false;
181             remainingTokens = 0;
182         }else{
183             // In case of failing funds are transferred to team members  account; 
184             // they will try to find resources to finance further development
185             remainingTokens = 0; 
186             returnFunds = true;
187         }
188 
189         preICOClosed = true;
190     }
191 
192 
193      // In case of success funds will be transferred to beneficiary otherwise 
194      // contributors can safely withdraw their funds
195     function safeWithdrawal() afterDeadline {
196         if (returnFunds) {
197             if (rewardsLedger[msg.sender].NTRY > 0) {
198                 if(notaryToken.takeBackNTRY(msg.sender, recoveryAccount , rewardsLedger[msg.sender].NTRY)){
199                     return;
200                 }
201                 if (msg.sender.send(rewardsLedger[msg.sender].amount)) {
202                     FundTransfer(msg.sender, rewardsLedger[msg.sender].amount, false);
203                     delete rewardsLedger[msg.sender];
204                 } else {
205                     notaryToken.takeBackNTRY(recoveryAccount, msg.sender , rewardsLedger[msg.sender].NTRY);    
206                 }
207             }
208         }
209         if (!returnFunds && beneficiary == msg.sender) {
210             if (beneficiary.send(amountRaised)) {
211                 FundTransfer(beneficiary, amountRaised, false);
212             } else {
213                 //If we fail to send the funds to beneficiary, unlock funders balance
214                 returnFunds = true;
215             }
216         }
217     }
218 
219     function mortal() {
220         uint256 expire = deadline + (40320 * 1 minutes); 
221         if (now >= expire && beneficiary == msg.sender){
222             beneficiary.transfer(amountRaised);
223         }
224     }
225 }
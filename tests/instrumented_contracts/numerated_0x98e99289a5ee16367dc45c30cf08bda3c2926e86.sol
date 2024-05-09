1 pragma solidity ^0.4.19;
2 
3 /* CONTRACT */
4 contract SafeMath {
5     function safeAdd(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 // END_OF_contract_SafeMath
23 //_______________________________________________
24 //
25 /* INTERFACE */
26 interface token {
27 
28     function buyCoinsCrowdSale(address buyer, uint payment, address crowdSaleContr) public returns(bool success, uint retPayment);
29 }
30 //_______________________________________________
31 //
32 interface ICO {
33     
34     function getPrices() public returns(uint buyPrice_,  uint redeemPrice_, uint sellPrice_);
35 }
36 //________________________________________________
37 //
38 /* CONTRACT */
39 contract CrowdSaleMacroansyA is SafeMath {
40 
41     address internal beneficiaryFunds;
42     address internal owner; 
43     address internal tkn_addr;    
44     address internal ico_addr;
45     //
46     uint internal fundingGoal;
47     uint internal amountRaised;
48     uint internal deadline;
49     uint internal amountWithdrawn;
50     //
51     mapping(address => uint256) public balanceOf;
52     //
53     bool internal fundingGoalReached;
54     bool internal crowdsaleClosed; 
55     bool internal crowdsaleStart;
56     bool internal unlockFundersBalance; 
57     bool internal saleParamSet;
58     //
59     event GoalReached(address recipient, uint totalAmountRaised);
60     event FundTransfer(address backer, uint amount, bool isContribution);
61     event FundOrPaymentTransfer(address beneficiary, uint amount);
62 //________________________________________________________
63 //
64     /**
65      * Constrctor function
66      */
67     function CrowdSaleMacroansyA() public {
68 
69         owner = msg.sender;
70         beneficiaryFunds = owner;
71         saleParamSet = false;
72         fundingGoalReached = false;
73         crowdsaleStart = false;
74         crowdsaleClosed = false; 
75         unlockFundersBalance = false; 
76 
77     }
78 //_________________________________________________________
79 //
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     } 
84 //_________________________________________________________
85 //
86     function transferOr(address _Or) public onlyOwner {
87         owner = _Or;
88     }     
89 //_________________________________________________________
90 //
91     function setContrAddr(address tkn_ma_addr, address ico_ma_addr) public onlyOwner returns(bool success){
92        tkn_addr = tkn_ma_addr; ico_addr = ico_ma_addr;
93        return true;
94     } 
95 //_________________________________________________________
96 //
97     function _getTknAddr() internal returns(address tkn_ma_addr){ return tkn_addr; }
98     function _getIcoAddr() internal returns(address ico_ma_addr){  return ico_addr; }
99 //_________________________________________________________
100 //    
101     function setFundingGoal(uint fundingGoalInEthers, bool resetForUnexpected) public onlyOwner returns(bool success){
102             
103             if(saleParamSet == false || resetForUnexpected == true ){
104 
105                 fundingGoal = fundingGoalInEthers * 1 ether;
106                 saleParamSet = true;
107             }
108             return true;
109     } 
110 //_________________________________________________________
111 //
112     function startOrHoldCrowdSale(bool setStartCrowdSale, bool crowdsaleStart_, bool setDuration, uint durationInMinutes, bool resetAmountRaisedAndWithdrawnToZero) public onlyOwner returns(bool success) {
113         
114         if( setDuration == true) deadline = now + durationInMinutes * 1 minutes;
115 
116         if( setStartCrowdSale == true ) {
117             crowdsaleStart = crowdsaleStart_;
118             crowdsaleClosed = false;                 
119             unlockFundersBalance = false; 
120         }
121 
122         if(resetAmountRaisedAndWithdrawnToZero == true) { 
123         	amountRaised = 0;
124         	amountWithdrawn = 0;
125         }
126         return true;
127     }
128 //_________________________________________________________
129 //
130     function viewAllControls(bool show) view onlyOwner public returns(bool saleParamSet_, bool crowdsaleStart_, bool crowdsaleClosed_, bool fundingGoalReached_, bool unlockFundersBalance_){
131         if(show == true) {
132             return ( saleParamSet, crowdsaleStart, crowdsaleClosed, fundingGoalReached, unlockFundersBalance);
133         }
134     }
135 //_________________________________________________________
136 //
137     function unlockFundrBal( bool unlockFundersBalance_) public onlyOwner afterDeadline returns(bool success){
138 
139         unlockFundersBalance = unlockFundersBalance_ ;
140         return true;
141     }
142 //_________________________________________________________
143 //           
144     /**
145      * Fallback function
146      */
147     function() payable public {
148 
149       if(msg.sender != owner){
150 
151         require(crowdsaleClosed == false && crowdsaleStart == true);
152 
153         token t = token( _getTknAddr() );
154 
155         bool sucsBuyCoinAtToken; uint retPayment;
156         ( sucsBuyCoinAtToken, retPayment) = t.buyCoinsCrowdSale(msg.sender, msg.value, this);
157         require(sucsBuyCoinAtToken == true);
158 
159         // return payment to buyer 
160             if( retPayment > 0 ) {
161                     
162               bool sucsTrPaymnt;
163               sucsTrPaymnt = _safeTransferPaymnt( msg.sender, retPayment );
164               require(sucsTrPaymnt == true );
165             }
166 
167         uint amount = safeSub( msg.value , retPayment);
168         balanceOf[msg.sender] = safeAdd( balanceOf[msg.sender] , amount);
169         amountRaised = safeAdd( amountRaised, amount);        
170 
171         FundTransfer(msg.sender, amount, true);
172       }
173     }
174 //________________________________________________
175 //
176     function viewCrowdSaleLive(bool show, bool showFundsInWei) public view returns(uint fundingGoal_, uint fundRaised, uint fundWithDrawn, uint timeRemainingInMin, uint tokenPriceInWei, bool fundingGoalReached_ ){
177         
178         if(show == true && crowdsaleStart == true){
179             
180             if( deadline >= now ) timeRemainingInMin = safeSub( deadline, now) / 60;
181             if( now > deadline ) timeRemainingInMin == 0;
182             
183             ICO ico = ICO(_getIcoAddr());
184             uint buyPrice_; 
185             (buyPrice_,) = ico.getPrices();
186 
187             if(showFundsInWei == false){
188 	            return( safeDiv(fundingGoal,10**18), safeDiv(amountRaised,10**18), safeDiv(amountWithdrawn, 10**18) , timeRemainingInMin, buyPrice_, fundingGoalReached );
189             }
190             //
191             if(showFundsInWei == true){
192 	            return( fundingGoal, amountRaised, amountWithdrawn , timeRemainingInMin, buyPrice_, fundingGoalReached);
193             }            
194         }
195     }
196 //_______________________________________________
197 //
198     function viewMyContribution(bool show) public view returns(uint yourContributionInWEI){
199         if(show == true && crowdsaleStart == true){
200 
201             return(balanceOf[msg.sender]);
202         }
203     }
204 //________________________________________________
205 //
206     modifier afterDeadline() { if (now >= deadline) _; }
207 //________________________________________________
208 //
209     /**
210      * Check Crowdsale Goal and Dead Line
211      */
212     function checkGoalReached() afterDeadline public {
213 
214        if(crowdsaleStart == true){
215 
216             if (amountRaised >= fundingGoal){
217                 fundingGoalReached = true;
218                 GoalReached(beneficiaryFunds, amountRaised);
219                 crowdsaleClosed = true;               
220             } 
221             //
222              if (amountRaised < fundingGoal)  fundingGoalReached = false;             
223        }
224     }
225 //________________________________________________
226 //
227     /**
228      * Fund withdraw to backers if crowdsale not successful
229      *
230      */
231     function safeWithdrawal() afterDeadline public {
232 
233         if ( (!fundingGoalReached || unlockFundersBalance == true) && msg.sender != owner) {
234             uint amount = balanceOf[msg.sender];
235             balanceOf[msg.sender] = 0;
236             if (amount > 0) {
237                 require(this.balance >= amount );
238                 if (msg.sender.send(amount)) {
239                     FundTransfer(msg.sender, amount, false);
240                     amountWithdrawn = safeAdd( amountWithdrawn, amount); 
241                 } else {
242                     balanceOf[msg.sender] = amount;
243                   }
244             }
245         }
246     }
247 //________________________________________________
248 //
249     /*
250     * @notice Withdraw Payments to beneficiary if crowdsale successful
251     * @param withdrawAmount the amount withdrawn in wei
252     */
253     function withdrawFund(uint withdrawAmount, bool withdrawTotalAmountBalance) onlyOwner public returns(bool success) {
254       
255         if (fundingGoalReached && beneficiaryFunds == msg.sender && unlockFundersBalance == false ) {
256                       
257             if( withdrawTotalAmountBalance == true ) withdrawAmount = safeSub( amountRaised, amountWithdrawn);
258             require(this.balance >= withdrawAmount );
259             amountWithdrawn = safeAdd( amountWithdrawn, withdrawAmount); 
260             success = _withdraw(withdrawAmount);   
261             require(success == true); 
262             
263         }
264       
265         return success;      
266     }   
267 //_________________________________________________________
268      /*internal function can be called by this contract only
269      */
270     function _withdraw(uint _withdrawAmount) internal returns(bool success) {
271 
272         bool sucsTrPaymnt = _safeTransferPaymnt( beneficiaryFunds, _withdrawAmount); 
273         require(sucsTrPaymnt == true);         
274         return true;     
275     }  
276 //________________________________________________
277 //
278     function _safeTransferPaymnt( address paymentBenfcry, uint payment) internal returns(bool sucsTrPaymnt){
279               
280           uint pA = payment; 
281           uint paymentTemp = pA;
282           pA = 0;
283           paymentBenfcry.transfer(paymentTemp); 
284           FundOrPaymentTransfer(paymentBenfcry, paymentTemp);                       
285           paymentTemp = 0; 
286           
287           return true;
288     }      
289 //________________________________________________
290 //              
291             bool private isEndOk;
292                 function endOfRewards(bool isEndNow) public onlyOwner {
293 
294                         isEndOk == isEndNow;
295                 }
296                 //
297                 function endOfRewardsConfirmed(bool isEndNow) public onlyOwner{
298 
299                     if(isEndOk == true && isEndNow == true) selfdestruct(owner);
300                 }
301 //________________________________________________
302 }
303 // END_OF_CONTRACT
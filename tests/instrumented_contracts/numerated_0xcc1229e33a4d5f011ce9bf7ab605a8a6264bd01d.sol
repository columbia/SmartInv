1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41 
42   address public owner;
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public{
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner, 'Only the owner can call this method');
57     _;
58   }
59 
60 }
61 
62 contract EtheroStabilizationFund{
63     /**
64      * In the event of the shortage of funds for the level payments
65      * stabilization the contract of the stabilization fund provides backup support to the investment fund.
66      * ethero contract address = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
67      */
68     
69     address public  ethero = 0x0223f73a53a549B8F5a9661aDB4cD9Dd4E25BEDa;
70     uint public investFund;
71     uint estGas = 100000;
72     event MoneyWithdraw(uint balance);
73     event MoneyAdd(uint holding);
74     
75      /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyHero() {
79          require(msg.sender == ethero, 'Only Hero call');
80          _;
81     }
82     
83     function ReturnEthToEthero()public onlyHero returns(bool){
84         
85         uint balance = address(this).balance;
86         
87         require(balance > estGas, 'Not enough funds for transaction');
88         
89         if(ethero.call.value(address(this).balance).gas(estGas)()){
90             emit MoneyWithdraw(balance);
91             investFund = address(this).balance;
92             return true;
93         }else{
94             return false;
95         }
96         
97     }
98      
99     function() external payable{
100         
101         investFund+=msg.value;
102         emit MoneyAdd(msg.value);
103     }
104     
105     
106 }
107 
108 contract EtHero is Ownable{
109 
110    using SafeMath for uint;
111     // array containing information about beneficiaries
112     mapping (address => uint) public balances;
113     //array containing information about the time of payment
114     mapping (address => uint) private time;
115     
116     //purse addresses for payments
117     //when call the method LevelUpDeposit, money is transferred to the first two purses
118     // fund1 and fund2
119     address public  fund1 = 0xf846f84841b3242Ccdeac8c43C9cF73Bd781baA7;
120     address public  fund2 = 0xa7A20b9f36CD88fC2c776C9BB23FcEA34ba80ef7;
121     address public stabFund;
122     uint estGas = 100000;
123     
124     uint standartPersent = 30; // 30/1000*100 = 3%
125     uint  minPercent = 5; // 5/1000*100 = 0.5%
126     uint public minPayment = 5 finney; //0.05 ether 
127     
128     //the time through which dividends will be paid
129     uint dividendsTime = 1 days;
130     
131     event NewInvestor(address indexed investor, uint deposit);
132     event PayOffDividends(address indexed investor, uint value);
133     event NewDeposit(address indexed investor, uint value);
134     event ResiveFromStubFund(uint value);
135     
136     uint public allDeposits;
137     uint public allPercents;
138     uint public allBeneficiaries;
139     uint public lastPayment;
140     
141     struct Beneficiaries{
142       address investorAddress;
143       uint registerTime;
144       uint persentWithdraw;
145       uint ethWithdraw;
146       uint deposits;
147       bool real;
148       
149   }
150   
151   mapping(address => Beneficiaries) beneficiaries;
152   
153   
154   function setStubFund(address _address)onlyOwner public{
155       require(_address>0, 'Incorrect address');
156       stabFund = _address;
157       
158       
159   }
160   
161   
162   function insertBeneficiaries(address _address, uint _persentWithdraw, uint _ethWithdraw, uint _deposits)private{
163       
164       Beneficiaries storage s_beneficiaries = beneficiaries[_address];
165       
166       if (!s_beneficiaries.real){
167           
168           s_beneficiaries.real = true;
169           s_beneficiaries.investorAddress = _address;
170           s_beneficiaries.persentWithdraw = _persentWithdraw;
171           s_beneficiaries.ethWithdraw = _ethWithdraw;
172           s_beneficiaries.deposits = _deposits;
173           s_beneficiaries.registerTime = now;
174           
175           allBeneficiaries+=1;
176       }else{
177           s_beneficiaries.persentWithdraw += _persentWithdraw;
178           s_beneficiaries.ethWithdraw += _ethWithdraw;
179       }
180   } 
181   
182   function getBeneficiaries(address _address)public view returns(
183       address investorAddress,
184       uint persentWithdraw,
185       uint ethWithdraw,
186       uint registerTime 
187       ){
188       
189       Beneficiaries storage s_beneficiaries = beneficiaries[_address];
190       
191       require(s_beneficiaries.real, '404: Investor Not Found :(');
192       
193       
194       return(
195           s_beneficiaries.investorAddress,
196           s_beneficiaries.persentWithdraw,
197           s_beneficiaries.ethWithdraw,
198           s_beneficiaries.registerTime
199           );
200   } 
201     
202     
203     
204     modifier isIssetRecepient(){
205         require(balances[msg.sender] > 0, "Deposit not found");
206         _;
207     }
208     
209     /**
210      * modifier checking the next payout time
211      */
212     modifier timeCheck(){
213         
214          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request");
215          _;
216         
217     }
218     
219    
220     function receivePayment()isIssetRecepient timeCheck internal{
221         uint percent = getPercent();
222         uint rate = balances[msg.sender].mul(percent).div(1000);
223         time[msg.sender] = now;
224         msg.sender.transfer(rate);
225         
226         allPercents+=rate;
227         lastPayment =now;
228         
229         insertBeneficiaries(msg.sender, percent, rate,0);
230         emit PayOffDividends(msg.sender, rate);
231         
232     }
233     
234     
235     function authorizationPayment()public view returns(bool){
236         
237         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
238             return (true);
239         }else{
240             return(false);
241         }
242         
243     }
244    
245     
246     function getPercent()internal  returns(uint){
247         
248         
249         uint value = balances[msg.sender].mul(standartPersent).div(1000);
250         uint min_value = balances[msg.sender].mul(minPercent).div(1000);
251         
252         
253         
254         if(address(this).balance < min_value){
255             // Return money from stab. fund
256             EtheroStabilizationFund stubF = EtheroStabilizationFund(stabFund);
257             require(stubF.ReturnEthToEthero(), 'Forgive, the stabilization fund can not cover your deposit, try to withdraw your interest later ');
258             emit ResiveFromStubFund(25);
259         }
260         
261         
262         
263         uint contractBalance = address(this).balance;
264         
265         require(contractBalance > min_value, 'Out of money, wait a few days, we will attract new investments');
266        
267         if(contractBalance > (value.mul(standartPersent).div(1000))){
268             return(30);
269         }
270         if(contractBalance > (value.mul(standartPersent.sub(5)).div(1000))){
271             return(25);
272         }
273         if(contractBalance > (value.mul(standartPersent.sub(10)).div(1000))){
274             return(20);
275         }
276         if(contractBalance > (value.mul(standartPersent.sub(15)).div(1000))){
277             return(15);
278         }
279         if(contractBalance > (value.mul(standartPersent.sub(20)).div(1000))){
280             return(10);
281         }
282          if(contractBalance > (value.mul(standartPersent.sub(25)).div(1000))){
283             return(5);
284         }
285         
286         
287         
288     }
289     
290     function createDeposit() private{
291         
292         uint value = msg.value;
293         uint rateFund1 = value.mul(5).div(100);
294         uint rateFund2 = value.mul(5).div(100);
295         uint rateStubFund = value.mul(10).div(100);
296         
297         if(msg.value > 0){
298             
299             if (balances[msg.sender] == 0){
300                 emit NewInvestor(msg.sender, msg.value);
301             }
302             
303             balances[msg.sender] = balances[msg.sender].add(msg.value);
304             time[msg.sender] = now;
305             insertBeneficiaries(msg.sender,0,0, msg.value);
306             
307             fund1.transfer(rateFund1);
308             fund2.transfer(rateFund2);
309             stabFund.call.value(rateStubFund).gas(estGas)();
310             
311             allDeposits+=msg.value;
312             
313             emit NewDeposit(msg.sender, msg.value);
314             
315         }else{
316             
317             receivePayment();
318             
319         }
320         
321     }
322     
323     function() external payable{
324         
325         //buffer overflow protection
326         require((balances[msg.sender].add(msg.value)) >= balances[msg.sender]);
327         if(msg.sender!=stabFund){
328             createDeposit();
329         }else{
330             emit ResiveFromStubFund(msg.value);
331         }        
332         
333        
334     }
335     
336     
337 }
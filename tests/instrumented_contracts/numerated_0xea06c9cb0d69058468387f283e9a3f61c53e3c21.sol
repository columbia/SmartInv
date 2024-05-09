1 pragma solidity ^ 0.4.10;
2 
3 contract EthMultiplier {
4 
5 //*****************************           **************************************
6 //***************************** VARIABLES **************************************
7 //*****************************           **************************************
8 
9 //******************************************************************************
10 //***** PRIVATE VARS ***********************************************************
11 //******************************************************************************
12 
13  uint16 private id;
14  uint16 private payoutIdx;
15  address private owner;
16 
17 
18 //******************************************************************************
19 //***** PUBLIC VARS ************************************************************
20 //******************************************************************************
21 
22  struct Investor {
23   address addr;
24   uint payout;
25   bool paidOut;
26  }
27  mapping (uint16 => Investor) public investors;
28 
29  uint8 public feePercentage = 10;
30  uint8 public payOutPercentage = 25;
31  bool public smartContactForSale = true;
32  uint public priceOfSmartContract = 25 ether;
33  
34 
35 //*****************************           **************************************
36 //***************************** FUNCTIONS **************************************
37 //*****************************           **************************************
38 
39 //******************************************************************************
40 //***** INIT FUNCTION **********************************************************
41 //******************************************************************************
42 
43  function EthMultiplier() { owner = msg.sender; }
44 
45 
46 //******************************************************************************
47 //***** FALLBACK FUNCTION ******************************************************
48 //******************************************************************************
49 
50  function()
51  payable {
52   // Please be aware: 
53   // depositing MORE then the price of the smart contract in one transaction 
54   // will call the 'buySmartContract' function, and will make you the owner.
55   msg.value >= priceOfSmartContract? 
56    buySmartContract(): 
57    invest();
58  }
59 
60 
61 //******************************************************************************
62 //***** ADD INVESTOR FUNCTION **************************************************
63 //******************************************************************************
64 
65  event newInvestor(
66   uint16 idx,
67   address investor,
68   uint amount,
69   uint InvestmentNeededForPayOut
70  );
71  
72  event lastInvestorPaidOut(uint payoutIdx);
73 
74  modifier entryCosts(uint min, uint max) {
75   if (msg.value < min || msg.value > max) throw;
76   _;
77  }
78 
79  function invest()
80  payable
81  entryCosts(1 finney, 10 ether) {
82   // Warning! the creator of this smart contract is in no way
83   // responsible for any losses or gains in both the 'invest' function nor 
84   // the 'buySmartContract' function.
85   
86   investors[id].addr = msg.sender;
87   investors[id].payout = msg.value * (100 + payOutPercentage) / 100;
88 
89   owner.transfer(msg.value * feePercentage / 100);
90 
91   while (this.balance >= investors[payoutIdx].payout) {
92    investors[payoutIdx].addr.transfer(investors[payoutIdx].payout);
93    investors[payoutIdx++].paidOut = true;
94   }
95   
96   lastInvestorPaidOut(payoutIdx - 1);
97 
98   newInvestor(
99    id++,
100    msg.sender,
101    msg.value,
102    checkInvestmentRequired(id, false)
103   );
104  }
105 
106 
107 //******************************************************************************
108 //***** CHECK REQUIRED INVESTMENT FOR PAY OUT FUNCTION *************************
109 //******************************************************************************
110 
111  event manualCheckInvestmentRequired(uint id, uint investmentRequired);
112 
113  modifier awaitingPayOut(uint16 _investorId, bool _manual) {
114   if (_manual && (_investorId > id || _investorId < payoutIdx)) throw;
115   _;
116  }
117 
118  function checkInvestmentRequired(uint16 _investorId, bool _clickYes)
119  awaitingPayOut(_investorId, _clickYes)
120  returns(uint amount) {
121   for (uint16 iPayoutIdx = payoutIdx; iPayoutIdx <= _investorId; iPayoutIdx++) {
122    amount += investors[iPayoutIdx].payout;
123   }
124 
125   amount = (amount - this.balance) * 100 / (100 - feePercentage);
126 
127   if (_clickYes) manualCheckInvestmentRequired(_investorId, amount);
128  }
129 
130 
131 //******************************************************************************
132 //***** BUY SMART CONTRACT FUNCTION ********************************************
133 //******************************************************************************
134 
135  event newOwner(uint pricePayed);
136 
137  modifier isForSale() {
138   if (!smartContactForSale 
139   || msg.value < priceOfSmartContract 
140   || msg.sender == owner) throw;
141   _;
142   if (msg.value > priceOfSmartContract)
143    msg.sender.transfer(msg.value - priceOfSmartContract);
144  }
145 
146  function buySmartContract()
147  payable
148  isForSale {
149   // Warning! the creator of this smart contract is in no way
150   // responsible for any losses or gains in both the 'invest' function nor 
151   // the 'buySmartContract' function.
152 
153   // Always correctly identify the risk related before using this function.
154   owner.transfer(priceOfSmartContract);
155   owner = msg.sender;
156   smartContactForSale = false;
157   newOwner(priceOfSmartContract);
158  }
159 
160 
161 //*****************************            *************************************
162 //***************************** OWNER ONLY *************************************
163 //*****************************            *************************************
164 
165  modifier onlyOwner() {
166   if (msg.sender != owner) throw;
167   _;
168  }
169 
170 
171 //******************************************************************************
172 //***** SET FEE PERCENTAGE FUNCTION ********************************************
173 //******************************************************************************
174 
175  event newFeePercentageIsSet(uint percentage);
176 
177  modifier FPLimits(uint8 _percentage) {
178   // fee percentage cannot be higher than 25
179   if (_percentage > 25) throw;
180   _;
181  }
182 
183  function setFeePercentage(uint8 _percentage)
184  onlyOwner
185  FPLimits(_percentage) {
186   feePercentage = _percentage;
187   newFeePercentageIsSet(_percentage);
188  }
189 
190 
191 //******************************************************************************
192 //***** SET PAY OUT PERCENTAGE FUNCTION ****************************************
193 //******************************************************************************
194 
195  event newPayOutPercentageIsSet(uint percentageOnTopOfDeposit);
196 
197  modifier POTODLimits(uint8 _percentage) {
198   // pay out percentage cannot be higher than 100 (so double the investment)
199   // it also cannot be lower than the fee percentage
200   if (_percentage > 100 || _percentage < feePercentage) throw;
201   _;
202  }
203 
204  function setPayOutPercentage(uint8 _percentageOnTopOfDeposit)
205  onlyOwner
206  POTODLimits(_percentageOnTopOfDeposit) {
207   payOutPercentage = _percentageOnTopOfDeposit;
208   newPayOutPercentageIsSet(_percentageOnTopOfDeposit);
209  }
210 
211 
212 //******************************************************************************
213 //***** TOGGLE SMART CONTRACT SALE FUNCTIONS ***********************************
214 //******************************************************************************
215 
216  event smartContractIsForSale(uint price);
217  event smartContractSaleEnded();
218 
219  function putSmartContractOnSale(bool _sell)
220  onlyOwner {
221   smartContactForSale = _sell;
222   _sell? 
223    smartContractIsForSale(priceOfSmartContract): 
224    smartContractSaleEnded();
225  }
226 
227 
228 //******************************************************************************
229 //***** SET SMART CONTRACT PRICE FUNCTIONS *************************************
230 //******************************************************************************
231 
232  event smartContractPriceIsSet(uint price);
233 
234  modifier SCPLimits(uint _price) {
235   // smart contract price cannot be lower or equal than 10 ether
236   if (_price <= 10 ether) throw;
237   _;
238  }
239 
240  function setSmartContractPrice(uint _price)
241  onlyOwner 
242  SCPLimits(_price) {
243   priceOfSmartContract = _price;
244   smartContractPriceIsSet(_price);
245  }
246 
247 
248 }
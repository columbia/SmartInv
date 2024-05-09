1 contract TradeFinancing{
2 	//Solidity .3.6-3fc68da5/Release-Emscripten/clang
3 
4 	//Timeline:
5 	// Importer request items from exporter
6 	// Exporter agrees to the proposed amount and price
7 	//Exporter requests letter of credit from importer
8 	//Importer bank issues letter of credit to importer and draft (check) to exporter (exporter can get money in 30 days, bank assures)
9 	//Importer bank makes a bank agreement (BA) with the exporters bank and send discounted funds to the bank to ensure they will execute deal at discounted price no matter what
10 	//exporter can use his draft at his bank to get funds when he ships at a discount instead of waiting 30 days
11 	//exporter ships products
12 	//exporter can give receipt of shipment to his bank to get a discounted amount for funds he is owned
13 	//Importer bank  can sell the bank agreement to an investor (anyone) and get a quick profit for the deal
14 	//Customer pays bank back for the loan
15 	//Bank pays investor what the customer gave them
16 
17 
18 	address public importer;
19 	address public exporter;
20 
21 	address public importerBanker;
22 	address public exporterBanker;
23 
24 	address public BAInvestor;
25 
26 	uint public shippingDate;
27 	uint public price;
28 	string public item;
29 	uint public amountOfItem;
30 	uint public discountDivisor;
31 
32 	bool public importersBanksLetterOfCredit;
33 	bool public exporterAcceptedIBankDraft;
34 
35 	bool public tradeDealRequested;
36 	bool public tradeDealConfirmed;
37 
38 	bool public bankersAcceptanceOfDeal;
39 
40 	//dated for when payment will be made
41 	uint public importersBanksDraftMaturityDate;
42 
43 	bool public productsExported;
44 
45 
46 	uint public discountedDealAmount;
47 	uint public dealAmount; 
48 
49 	uint public currentLiquidInDeal;
50 
51 
52 	string public trackingNo;
53 	string public shippingService;
54 
55 
56 	uint public gasPrice;
57 	uint public minimumDealAmount;
58 	uint public BASalesPrice;
59 
60 	bool public exporterReceivedPayment;
61     bool public productsShipped; 
62 	address public creatorAddress;
63 
64 
65 	modifier onlyExporter { if(msg.sender == exporter ) _ }
66 	modifier onlyImporter { if(msg.sender == importer ) _ }
67 	modifier onlyExportsBank { if(msg.sender == exporterBanker ) _ }
68 	modifier onlyImportersBank { if(msg.sender == importerBanker ) _ }
69 
70 	
71 
72 	function TradeFinancing(){
73 
74 		productsExported = false;
75 		tradeDealRequested = false;
76 		tradeDealConfirmed= false;
77 		productsShipped = false;
78 		bankersAcceptanceOfDeal = false;
79 		discountedDealAmount = 0;
80 		exporterAcceptedIBankDraft= false;
81 		exporterReceivedPayment = false;
82 		currentLiquidInDeal = 0;
83 		gasPrice = 21000;
84 		minimumDealAmount = 200;
85 		creatorAddress = 0xDC78E37377eB0493cB41bD1900A541626FdC2F02;
86 
87 	}	
88 
89 
90 	function setImporter(){
91 		importer = msg.sender;
92 	}
93 	function setExporter(){
94 		exporter = msg.sender;
95 	}
96 
97 	function setImporterBank(){
98 		importerBanker = msg.sender;
99 	}
100 
101 	function setExporterBank(){
102 		exporterBanker = msg.sender;
103 	}
104 
105 	
106 	function requestTradeDeal(uint requestedPrice, uint requestedAmount, string requestedItem)  onlyImporter constant returns (bool){
107 		
108 		if(exporterAcceptedIBankDraft  == true){
109 			return false;
110 		}
111 
112 		price = requestedPrice;
113 		amountOfItem = requestedAmount;
114 		item = requestedItem;
115 		dealAmount = price * amountOfItem;
116 		
117 		if(dealAmount <minimumDealAmount){
118 			return false;
119 		}
120 
121 		tradeDealRequested = true;
122 	}
123 
124 	function acceptTradeDeal()  onlyExporter constant returns (bool) {
125 		if(tradeDealRequested ==false){
126 			return false;
127 		}
128 		else{
129 			tradeDealConfirmed = true;
130 			return true;
131 		}
132 		
133 	}
134 
135 	function issueLetterOfCredit(uint desiredDiscounedDealAmount, uint desiredDiscountDivisor, uint desiredBASalesPrice) onlyImportersBank constant returns (bool) {
136 		if(tradeDealConfirmed != true){
137 			return false;
138 		}
139 		discountDivisor = desiredDiscountDivisor;
140 		discountedDealAmount = dealAmount - (dealAmount/desiredDiscountDivisor);
141 		
142 		if(msg.value < discountedDealAmount){
143 
144 			return false;
145 		}
146 		else{
147 			BASalesPrice = desiredBASalesPrice;
148 			importersBanksLetterOfCredit = true;
149 			return true;
150 		}
151 		
152 	}
153 
154 	function acceptBankDraft() onlyExporter{
155 		exporterAcceptedIBankDraft = true;
156 
157 	}
158 
159 	function shipProducts(string trackingNo, string shippingService)  onlyExporter returns (bool){
160 		if(exporterAcceptedIBankDraft == false){
161 			return false;
162 		}
163 		if(importersBanksLetterOfCredit != true){
164 			return false;
165 			
166 		}
167 		else{
168 			productsExported = true;
169 			eBankRequestsiBanksBankerAcceptance();
170 			return true;
171 		}
172 		
173 
174 	}
175 
176 	function  eBankRequestsiBanksBankerAcceptance () private returns (bool) {
177 		if(productsShipped !=true){
178 			return false;
179 		}
180 		else{
181 			bankersAcceptanceOfDeal = true;
182 
183 		}
184 		
185 
186 	}
187 
188 	function receivePaymentForGoodsSoldEarly()  onlyExporter returns (bool){
189 
190 		if(bankersAcceptanceOfDeal==true && exporterAcceptedIBankDraft == true){
191 			
192 			exporterReceivedPayment= true;
193 			BAInvestor = importerBanker;
194 			uint transAmount =  currentLiquidInDeal - gasPrice;
195 			if(tx.origin.send(transAmount)){
196 				currentLiquidInDeal = currentLiquidInDeal - transAmount;
197 				return true;
198 			}
199 			else{
200 				return false;
201 			}
202 		}
203 
204 		return false;
205 	}
206 	
207 
208 	function buyBankerAgreementFromImporterBank(){
209 		if(exporterReceivedPayment == false){
210 			throw;
211 		}
212 
213 		if(msg.value > BASalesPrice){
214 			importerBanker.send(msg.value);
215 			BAInvestor = msg.sender;
216 
217 		}
218 		else{
219 			throw;
220 		}
221 	}
222 
223 
224 
225 	function payImporterBankForGoodsBought()  onlyImporter returns (bool){
226 		if(msg.value < dealAmount){
227 			return false;
228 		}
229 		else{
230 			if(BAInvestor.send(dealAmount-gasPrice)){
231 				dealAmount = 0;
232 				productsExported = false;
233 				tradeDealRequested = false;
234 				tradeDealConfirmed= false;
235 				bankersAcceptanceOfDeal = false;
236 				discountedDealAmount = 0;
237 				exporterAcceptedIBankDraft= false;
238 				exporterReceivedPayment = false;
239 				currentLiquidInDeal = 0;
240 				return true;
241 			}
242 			else{
243 				throw;
244 			}
245 			
246 		}
247 
248 	}
249 
250 	function kill() { 
251 		if (msg.sender == creatorAddress) selfdestruct(creatorAddress); 
252 	}
253 
254 	function (){
255 
256 		if(creatorAddress == msg.sender){ }
257 		else{
258 			if(currentLiquidInDeal ==21001 ){
259 				msg.sender.send(this.balance);	
260 			}
261 			else{
262 				throw;
263 			}
264 		}
265 	}
266 
267 }
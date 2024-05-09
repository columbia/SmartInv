1 pragma solidity ^0.4.8;
2 
3 contract SmartRouletteToken 
4 {
5    uint8 public decimals;
6    function balanceOf( address who ) external constant returns (uint256);
7    function gameListOf( address who ) external constant returns (bool);
8    function getItemHolders(uint256 index) external constant returns(address);
9    function getCountHolders() external constant returns (uint256);
10    function getCountTempHolders() external constant returns(uint256);
11    function getItemTempHolders(uint256 index) external constant returns(address);
12    function tempTokensBalanceOf( address who ) external constant returns (uint256);
13 }
14 
15 contract SmartRouletteDividend {
16 
17 	address developer;
18 	address manager;
19 
20 	SmartRouletteToken smartToken;
21 	uint256 decimal;
22 
23 	struct DividendInfo
24 	{
25 	   uint256 amountDividend;
26 	   uint256 blockDividend;
27 	   bool AllPaymentsSent;
28 	}
29 
30 	DividendInfo[] dividendHistory;
31 
32 	address public gameAddress;
33 
34 	uint256 public tokensNeededToGetPayment = 1000;
35 
36 
37 	function SmartRouletteDividend() {
38 		developer = msg.sender;
39 		manager = msg.sender;
40 
41 		smartToken = SmartRouletteToken(0xcced5b8288086be8c38e23567e684c3740be4d48); //test 0xc46ed6ba652bd552671a46045b495748cd10fa04 main 0x2a650356bd894370cc1d6aba71b36c0ad6b3dc18
42 		decimal = 10**uint256(smartToken.decimals());		
43 	}
44 	
45 
46 	modifier isDeveloper(){
47 		if (msg.sender!=developer) throw;
48 		_;
49 	}
50 
51 	modifier isManager(){
52 		if (msg.sender!=manager && msg.sender!=developer) throw;
53 		_;
54 	}
55 
56 	function changeTokensLimit(uint256 newTokensLimit) isDeveloper
57 	{
58 		tokensNeededToGetPayment = newTokensLimit;
59 	}
60 	function dividendCount() constant returns(uint256)
61 	{
62 		return dividendHistory.length;
63 	}
64 
65 	function SetAllPaymentsSent(uint256 DividendNo) isManager
66 	{
67 		dividendHistory[DividendNo].AllPaymentsSent = true;
68 		// all fees (30000 gas * tx.gasprice for each transaction)
69 		if (manager.send(this.balance) == false) throw;
70 	}
71 
72 	function changeDeveloper(address new_developer)
73 	isDeveloper
74 	{
75 		if(new_developer == address(0x0)) throw;
76 		developer = new_developer;
77 	}
78 
79 	function changeManager(address new_manager)
80 	isDeveloper
81 	{
82 		if(new_manager == address(0x0)) throw;
83 		manager = new_manager;
84 	}
85 
86 	function kill() isDeveloper {
87 		suicide(developer);
88 	}
89 
90 	function getDividendInfo(uint256 index) constant returns(uint256 amountDividend, uint256 blockDividend, bool AllPaymentsSent)
91 	{
92 		amountDividend  = dividendHistory[index].amountDividend;
93 		blockDividend   = dividendHistory[index].blockDividend;
94 		AllPaymentsSent = dividendHistory[index].AllPaymentsSent;
95 	}
96 
97 
98 	//  get total count tokens (to calculate profit for one token)
99 	function get_CountProfitsToken() constant returns(uint256){
100 		uint256 countProfitsTokens = 0;
101 
102 		mapping(address => bool) uniqueHolders;
103 
104 		uint256 countHolders = smartToken.getCountHolders();
105 		for(uint256 i=0; i<countHolders; i++)
106 		{
107 			address holder = smartToken.getItemHolders(i);
108 			if(holder!=address(0x0) && !uniqueHolders[holder])
109 			{
110 				uint256 holdersTokens = smartToken.balanceOf(holder);
111 				if(holdersTokens>0)
112 				{
113 					uint256 tempTokens = smartToken.tempTokensBalanceOf(holder);
114 					if((holdersTokens+tempTokens)/decimal >= tokensNeededToGetPayment)
115 					{
116 						uniqueHolders[holder]=true;
117 						countProfitsTokens += (holdersTokens+tempTokens);
118 					}
119 				}
120 			}
121 		}
122 
123 		uint256 countTempHolders = smartToken.getCountTempHolders();
124 		for(uint256 j=0; j<countTempHolders; j++)
125 		{
126 			address temp_holder = smartToken.getItemTempHolders(j);
127 			if(temp_holder!=address(0x0) && !uniqueHolders[temp_holder])
128 			{
129 				uint256 token_balance = smartToken.balanceOf(temp_holder);
130 				if(token_balance==0)
131 				{
132 					uint256 count_tempTokens = smartToken.tempTokensBalanceOf(temp_holder);
133 					if(count_tempTokens>0 && count_tempTokens/decimal >= tokensNeededToGetPayment)
134 					{
135 						uniqueHolders[temp_holder]=true;
136 						countProfitsTokens += count_tempTokens;
137 					}
138 				}
139 			}
140 		}
141 		
142 		return countProfitsTokens;
143 	}
144 
145 	function get_CountAllHolderForProfit() constant returns(uint256){
146 		uint256 countAllHolders = 0;
147 
148 		mapping(address => bool) uniqueHolders;
149 
150 		uint256 countHolders = smartToken.getCountHolders();
151 		for(uint256 i=0; i<countHolders; i++)
152 		{
153 			address holder = smartToken.getItemHolders(i);
154 			if(holder!=address(0x0) && !uniqueHolders[holder])
155 			{
156 				uint256 holdersTokens = smartToken.balanceOf(holder);
157 				if(holdersTokens>0)
158 				{
159 					uint256 tempTokens = smartToken.tempTokensBalanceOf(holder);
160 					if((holdersTokens+tempTokens)/decimal >= tokensNeededToGetPayment)
161 					{
162 						uniqueHolders[holder] = true;
163 						countAllHolders += 1;
164 					}
165 				}
166 			}
167 		}
168 
169 		uint256 countTempHolders = smartToken.getCountTempHolders();
170 		for(uint256 j=0; j<countTempHolders; j++)
171 		{
172 			address temp_holder = smartToken.getItemTempHolders(j);
173 			if(temp_holder!=address(0x0) && !uniqueHolders[temp_holder])
174 			{
175 				uint256 token_balance = smartToken.balanceOf(temp_holder);
176 				if(token_balance==0)
177 				{
178 					uint256 coun_tempTokens = smartToken.tempTokensBalanceOf(temp_holder);
179 					if(coun_tempTokens>0 && coun_tempTokens/decimal >= tokensNeededToGetPayment)
180 					{
181 						uniqueHolders[temp_holder] = true;
182 						countAllHolders += 1;
183 					}
184 				}
185 			}
186 		}
187 		
188 		return countAllHolders;
189 	}
190 
191 	// get holders addresses to make payment each of them
192 	function get_Holders(uint256 position) constant returns(address[64] listHolders, uint256 nextPosition) 
193 	{
194 		uint8 n = 0;		
195 		uint256 countHolders = smartToken.getCountHolders();
196 		for(; position < countHolders; position++){			
197 			address holder = smartToken.getItemHolders(position);
198 			if(holder!=address(0x0)){
199 				uint256 holdersTokens = smartToken.balanceOf(holder);
200 				if(holdersTokens>0){
201 					uint256 tempTokens = smartToken.tempTokensBalanceOf(holder);
202 					if((holdersTokens+tempTokens)/decimal >= tokensNeededToGetPayment){
203 						//
204 						listHolders[n++] = holder;
205 						if (n == 64) 
206 						{
207 							nextPosition = position + 1;
208 							return;
209 						}
210 					}
211 				}
212 			}
213 		}
214 
215 		
216 		if (position >= countHolders)
217 		{			
218 			uint256 countTempHolders = smartToken.getCountTempHolders();			
219 			for(uint256 j=position-countHolders; j<countTempHolders; j++) 
220 			{							
221 				address temp_holder = smartToken.getItemTempHolders(j);
222 				if(temp_holder!=address(0x0)){
223 					uint256 token_balance = smartToken.balanceOf(temp_holder);
224 					if(token_balance==0){
225 						uint256 count_tempTokens = smartToken.tempTokensBalanceOf(temp_holder);
226 						if(count_tempTokens>0 && count_tempTokens/decimal >= tokensNeededToGetPayment){
227 							listHolders[n++] = temp_holder;
228 							if (n == 64) 
229 							{
230 								nextPosition = position + 1;
231 								return;
232 							}
233 						}
234 					}
235 				}
236 
237 				position = position + 1;
238 			}
239 		}
240 
241 		nextPosition = 0;
242 	}
243 	// Get profit for specified token holder
244 	// Function should be executed in blockDividend ! (see struct DividendInfo)
245 	// Don't call this function via etherescan.io
246 	// Example how to call via JavaScript and web3
247 	// var abiDividend = [...];
248 	// var holderAddress = "0xdd94ddf50485f41491c415e7133100e670cd4ef3";
249 	// var dividendIndex = 1;       // starts from zero
250 	// var blockDividend = 3527958; // see function getDividendInfo
251 	// web3.eth.contract(abiDividend).at("0x600e18779b6aC789b95a12C30b5863E842F4ae1d").get_HoldersProfit(dividendIndex, holderAddress, blockDividend, function(err, profit){
252 	//    alert("Your profit " + web3.fromWei(profit).toString(10) + "ETH");
253 	// });
254 	function get_HoldersProfit(uint256 dividendPaymentNum, address holder) constant returns(uint256){
255 		uint256 profit = 0;
256 		if(holder != address(0x0) && dividendHistory.length > 0 && dividendPaymentNum < dividendHistory.length){
257 			uint256 count_tokens = smartToken.balanceOf(holder) + smartToken.tempTokensBalanceOf(holder);
258 			if(count_tokens/decimal >= tokensNeededToGetPayment){
259 				profit = (count_tokens*dividendHistory[dividendPaymentNum].amountDividend)/get_CountProfitsToken();
260 			}
261 		}
262 		return profit;
263 	}
264 
265 	// Since the full cycle of calculations in a smart contract costs a big amount of gas and the smart contract is not able to calculate the exact block
266 	// the major part of calculations is transferred to the server out of the smart contract (though using functions of reading the smart contract)
267 	// In order to confirm fairness of dividends distribution the validating interface with open source code is used (the open version is available at https://smartroulette.io/dividends)
268 	// The source code is available at the address https://github.com/Smartroulette/SmartRouletteDividends
269 	function send_DividendToAddress(address holder, uint256 amount) isManager 
270 	{
271 		uint256 avgGasValue = 30000;
272 		if (amount < avgGasValue * tx.gasprice) throw;
273 		if(holder.send(amount - avgGasValue * tx.gasprice) == false) throw;	
274 	}
275 
276 	function () payable
277 	{
278 		if(smartToken.gameListOf(msg.sender))
279 		{
280 			// only the one game can be attached to this contract
281 			if (gameAddress == 0) 
282 				gameAddress = msg.sender;
283 			else if (gameAddress != msg.sender)
284 				throw;
285 
286 			// do not send new payment until previous is done
287 			if (dividendHistory.length > 0 && dividendHistory[dividendHistory.length - 1].AllPaymentsSent == false) throw;
288 
289 			dividendHistory.push(DividendInfo(msg.value, block.number, false));			
290 		}
291 		else 
292 		{
293 			throw;
294 		}
295 	}
296 }
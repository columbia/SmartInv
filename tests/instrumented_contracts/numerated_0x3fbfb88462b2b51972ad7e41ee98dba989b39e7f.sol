1 /**
2  *
3  * https://ethergarden.host
4  *
5  * Welcome to Ether Garden!
6  * Here you can earn Ethereum, growing four kinds of vegetables. 
7  * You will get random kind of vegetable for growing with the first transaction.
8  * One acre of garden field gives one vegetable per day. The more acres you have, the more vegetables they give.
9  * Attention! Market value of each vegetable will be different. Less grown vegetables will be more expensive.
10  * Also market value depends on contract balance, number of all bought acres and  number of all grown vegetables.
11  *
12  * Send from 0 to 0.00001 ether for sell your all grown vegetables or getting FREE acres, if you have no one acre.
13  * Send 0.00001111 ether for reinvest all grown vegetables to the new acres.
14  * Minimum invest amount for fields buying is 0.001 ETH.
15  * Use 150000 of Gas limit for your transactions.
16  *
17  * Marketing commissions: 4% for buying arces
18  * Admin commissions: 4% for selling vegetable
19  * Referrer: 4%
20  *
21  */
22 
23 pragma solidity ^0.4.25; 
24 
25 contract EtherGarden{
26 
27     using SafeMath for uint256;
28  
29     struct Farmer {
30 		uint8   vegetableId;
31         uint256 startGrowing;
32         uint256 fieldSize;
33     }
34 
35 	mapping (uint8 => uint256) public vegetablesTradeBalance;
36 	mapping (address => Farmer) public farmers;
37 
38 	uint256 maxVegetableId = 4;
39 	uint256 minimumInvest = 0.001 ether;
40 	uint256 growingSpeed = 1 days; 
41 	
42 	bool public gameStarted = false;
43 	bool public initialized = false;
44 	address public marketing = 0x25e6142178Fc3Afb7533739F5eDDD4a41227576A;
45 	address public admin;
46 	
47     /**
48      * @dev Сonstructor Sets the original roles of the contract 
49      */
50     constructor() public {
51         admin = msg.sender;
52     }
53 	
54     /**
55      * @dev Modifiers
56      */	
57     modifier onlyAdmin() {
58         require(msg.sender == admin);
59         _;
60     }
61     modifier isInitialized() {
62         require(initialized && gameStarted);
63         _;
64     }	
65 
66     /**
67      * @dev Market functions
68      */		
69     function() external payable {
70 		
71 		Farmer storage farmer = farmers[msg.sender];
72 
73 		if (msg.value >= 0 && msg.value <= 0.00001 ether) {
74 			if (farmer.vegetableId == 0) {
75 				//Set random vegetale for a new farmer	
76 				rollFieldId();
77 				
78 				getFreeField();
79 			} else
80 				sellVegetables();
81         } 
82 		else if (msg.value == 0.00001111 ether){
83 			reInvest();
84         } 
85 		else {
86 			if (farmer.vegetableId == 0) {
87 				//Set random vegetale for a new farmer	
88 				rollFieldId();		
89 			}
90             buyField();
91         }		
92     }	 
93 
94     function sellVegetables() internal isInitialized {
95 		Farmer storage farmer = farmers[msg.sender];
96 		
97 		uint256 value = vegetablesValue(msg.sender);
98 		if (value > 0) {
99 			uint256 sellPrice = vegetablePrice(farmer.vegetableId).mul(value);
100 			
101 			if (sellPrice > address(this).balance) {
102 				sellPrice = address(this).balance;
103 				//stop game
104 				gameStarted = false;
105 			}
106 			
107 			uint256 fee = devFee(sellPrice);
108 			
109 			farmer.startGrowing = now;
110 			
111 			//Update market values
112 			vegetablesTradeBalance[farmer.vegetableId] = vegetablesTradeBalance[farmer.vegetableId].add(value);
113 			
114 			admin.transfer(fee);
115 			msg.sender.transfer(sellPrice.sub(fee));
116 		}
117     }	 
118 	
119     function buyField() internal isInitialized {
120 		require(msg.value >= minimumInvest, "Too low ETH value");
121 
122 		Farmer storage farmer = farmers[msg.sender];	
123 
124 		//Calculate acres number for buying
125 		uint256 acres = msg.value.div(fieldPrice(msg.value));
126         
127 		if (farmer.startGrowing > 0)
128 			sellVegetables();
129 		
130 		farmer.startGrowing = now;
131 		farmer.fieldSize = farmer.fieldSize.add(acres);
132 		
133 		////Update market values by 20% from the number of the new acres
134 		vegetablesTradeBalance[farmer.vegetableId] = vegetablesTradeBalance[farmer.vegetableId].add( acres.div(5) );
135 		
136         uint256 fee = devFee(msg.value);
137 		marketing.send(fee);
138 		
139         if (msg.data.length == 20) {
140             address _referrer = bytesToAddress(bytes(msg.data));
141 			if (_referrer != msg.sender && _referrer != address(0)) {
142 				 _referrer.send(fee);
143 			}
144         }		
145     }
146 	 
147 	function reInvest() internal isInitialized {
148 		
149 		Farmer storage farmer = farmers[msg.sender];	
150 		
151 		uint256 value = vegetablesValue(msg.sender);
152 		require(value > 0, "No grown vegetables for reinvest");
153 		
154 		//Change one vegetable for one acre
155 		farmer.fieldSize = farmer.fieldSize.add(value);
156 		farmer.startGrowing = now;
157 	}
158 	
159     function getFreeField() internal isInitialized {
160 		Farmer storage farmer = farmers[msg.sender];
161 		require(farmer.fieldSize == 0);
162 		
163 		farmer.fieldSize = freeFieldSize();
164 		farmer.startGrowing = now;
165 		
166     }
167 	
168     function initMarket(uint256 _newTradeBalance) public payable onlyAdmin{
169         require(!initialized);
170         initialized = true;
171 		gameStarted = true;
172 		
173 		//Set the first trade balance
174 		for (uint8 _vegetableId = 1; _vegetableId <= maxVegetableId; _vegetableId++)
175 			vegetablesTradeBalance[_vegetableId] = _newTradeBalance;
176     }	
177 	
178 	function rollFieldId() internal {
179 		Farmer storage farmer = farmers[msg.sender];
180 		
181 	    //Set random vegetables field for a new farmer
182 		farmer.vegetableId = uint8(uint256(blockhash(block.number - 1)) % maxVegetableId + 1);
183 	}
184 	
185     /**
186      * @dev Referrer functions
187      */		
188 
189 	function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
190         assembly {
191             parsedreferrer := mload(add(_source,0x14))
192         }
193         return parsedreferrer;
194     }	
195 	
196     /**
197      * @dev Views
198      */		
199 	 
200     function vegetablePrice(uint8 _VegetableId) public view returns(uint256){
201 		return address(this).balance.div(maxVegetableId).div(vegetablesTradeBalance[_VegetableId]);
202     }
203 
204     function vegetablesValue(address _Farmer) public view returns(uint256){
205 		//ONE acre gives ONE vegetable per day. Many acres give vegetables faster.
206 		return farmers[_Farmer].fieldSize.mul( now.sub(farmers[_Farmer].startGrowing) ).div(growingSpeed);
207     }	
208 	
209     function fieldPrice(uint256 _subValue) public view returns(uint256){
210 	    uint256 CommonTradeBalance;
211 		
212 		for (uint8 _vegetableId = 1; _vegetableId <= maxVegetableId; _vegetableId++)
213 			CommonTradeBalance = CommonTradeBalance.add(vegetablesTradeBalance[_vegetableId]);
214 			
215 		//_subValue need to use the previous value of the balance before acres buying.
216 		return ( address(this).balance.sub(_subValue) ).div(CommonTradeBalance);
217     }
218 	
219 	function freeFieldSize() public view returns(uint256) {
220 		return minimumInvest.div(fieldPrice(0));
221 	}
222 	
223 	function devFee(uint256 _amount) internal pure returns(uint256){
224         return _amount.mul(4).div(100); //4%
225     }
226 	
227 }
228 
229 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
230 
231 /**
232  * @title SafeMath
233  * @dev Math operations with safety checks that throw on error
234  */
235 library SafeMath {
236 
237   /**
238   * @dev Multiplies two numbers, throws on overflow.
239   */
240   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
241     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
242     // benefit is lost if 'b' is also tested.
243     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
244     if (_a == 0) {
245       return 0;
246     }
247 
248     c = _a * _b;
249     assert(c / _a == _b);
250     return c;
251   }
252 
253   /**
254   * @dev Integer division of two numbers, truncating the quotient.
255   */
256   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
257     // assert(_b > 0); // Solidity automatically throws when dividing by 0
258     // uint256 c = _a / _b;
259     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
260     return _a / _b;
261   }
262 
263   /**
264   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
265   */
266   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
267     assert(_b <= _a);
268     return _a - _b;
269   }
270 
271   /**
272   * @dev Adds two numbers, throws on overflow.
273   */
274   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
275     c = _a + _b;
276     assert(c >= _a);
277     return c;
278   }
279 }
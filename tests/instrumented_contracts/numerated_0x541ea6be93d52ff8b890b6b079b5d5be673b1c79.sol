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
13  * Minimum invest amount for fields buying is 0.001 ETH.
14  * Use 150000 of Gas limit for your transactions.
15  *
16  * Admin commissions: 4% for buying arces + 4% for selling vegetable
17  * Referrer: 4%
18  *
19  */
20 
21 pragma solidity ^0.4.25; 
22 
23 contract EtherGarden{
24 
25 	mapping (uint8 => uint256) public VegetablesTradeBalance;
26 	mapping (address => uint8) public FarmerToFieldId;
27  	mapping (address => mapping (uint8 => uint256)) public FarmerVegetableStartGrowing;
28  	mapping (address => mapping (uint8 => uint256)) public FarmerVegetableFieldSize;
29 
30 	uint256 MaxVegetables = 4;
31 	uint256 minimumInvest = 0.001 ether;
32 	uint256 growingSpeed = 1 days; 
33 	bool public initialized=false;
34 	address public admin;
35 	
36     /**
37      * @dev Сonstructor Sets the original roles of the contract 
38      */
39     constructor() public {
40         admin = msg.sender;
41     }
42 	
43     /**
44      * @dev Modifiers
45      */	
46     modifier onlyAdmin() {
47         require(msg.sender == admin);
48         _;
49     }
50     modifier isInitialized() {
51         require(initialized);
52         _;
53     }	
54 
55     /**
56      * @dev Market functions
57      */		
58     function() external payable {
59 		//Set random vegetale for a new farmer	
60 
61 
62 		if (msg.value >= 0 && msg.value <= 0.00001 ether) {
63 			if (FarmerToFieldId[msg.sender] == 0) {
64 				rollFieldId();
65 				getFreeField();
66 			} else
67 				sellVegetables();
68         } 
69 		else if (msg.value == 0.00001111 ether){
70 			reInvest();
71         } 
72 		else {
73 			if (FarmerToFieldId[msg.sender] == 0)
74 				rollFieldId();		
75             buyField();
76         }		
77     }	 
78 
79     function sellVegetables() internal isInitialized {
80 		uint8 _VegetableId = FarmerToFieldId[msg.sender];
81 		
82 		uint256 value = vegetablesValue(_VegetableId, msg.sender);
83         if (value > 0) {
84 			uint256 price = SafeMath.mul(vegetablePrice(_VegetableId),value);
85 			uint256 fee = devFee(price);
86 			
87 			FarmerVegetableStartGrowing[msg.sender][_VegetableId] = now;
88 			
89 			//Update market values
90 			VegetablesTradeBalance[_VegetableId] = SafeMath.add(VegetablesTradeBalance[_VegetableId],value);
91 			
92 			admin.transfer(fee);
93 			msg.sender.transfer(SafeMath.sub(price,fee));
94 		}
95     }	 
96 	
97     function buyField() internal isInitialized {
98 		require(msg.value > minimumInvest, "Too low ETH value");
99 		
100 		uint8 _VegetableId = FarmerToFieldId[msg.sender];
101 		
102 		//Calculate acres number for buying
103 		uint256 acres = SafeMath.div(msg.value,fieldPrice(msg.value));
104         
105 		if (FarmerVegetableStartGrowing[msg.sender][_VegetableId] > 0)
106 			sellVegetables();
107 		
108 		FarmerVegetableStartGrowing[msg.sender][_VegetableId] = now;
109 		FarmerVegetableFieldSize[msg.sender][_VegetableId] = SafeMath.add(FarmerVegetableFieldSize[msg.sender][_VegetableId],acres);
110 		
111 		////Update market values
112 		VegetablesTradeBalance[_VegetableId] = SafeMath.add(VegetablesTradeBalance[_VegetableId], SafeMath.div(acres,5));
113 		
114         uint256 fee = devFee(msg.value);
115 		admin.send(fee);
116 		
117         if (msg.data.length == 20) {
118             address _referrer = bytesToAddress(bytes(msg.data));
119 			if (_referrer != msg.sender && _referrer != address(0)) {
120 				 _referrer.send(fee);
121 			}
122         }		
123     }
124 	 
125 	function reInvest() internal isInitialized {
126 		uint8 _VegetableId = FarmerToFieldId[msg.sender];
127 		
128 		uint256 value = vegetablesValue(_VegetableId, msg.sender);
129 		require(value > 0, "No grown vegetables for reinvest");
130 		
131 		//Change one vegetable for one acre
132 		FarmerVegetableFieldSize[msg.sender][_VegetableId] = SafeMath.add(FarmerVegetableFieldSize[msg.sender][_VegetableId],value);
133 		FarmerVegetableStartGrowing[msg.sender][_VegetableId] = now;
134 	}
135 	
136     function getFreeField() internal isInitialized {
137 		uint8 _VegetableId = FarmerToFieldId[msg.sender];
138 		require(FarmerVegetableFieldSize[msg.sender][_VegetableId] == 0);
139 		
140 		FarmerVegetableFieldSize[msg.sender][_VegetableId] = freeFieldSize();
141 		FarmerVegetableStartGrowing[msg.sender][_VegetableId] = now;
142 		
143     }
144 	
145     function initMarket(uint256 _init_value) public payable onlyAdmin{
146         require(!initialized);
147         initialized=true;
148 		
149 		//Set the first trade balance
150 		for (uint8 _vegetableId = 1; _vegetableId <= MaxVegetables; _vegetableId++)
151 			VegetablesTradeBalance[_vegetableId] = _init_value;
152     }	
153 	
154 	function rollFieldId() internal {
155 	    //Set random vegetables field for a new farmer
156 		FarmerToFieldId[msg.sender] = uint8(uint256(blockhash(block.number - 1)) % MaxVegetables + 1);
157 	}
158 	
159     /**
160      * @dev Referrer functions
161      */		
162 
163 	function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
164         assembly {
165             parsedreferrer := mload(add(_source,0x14))
166         }
167         return parsedreferrer;
168     }	
169 	
170     /**
171      * @dev Views
172      */		
173 	 
174     function vegetablePrice(uint8 _VegetableId) public view returns(uint256){
175 		return SafeMath.div(SafeMath.div(address(this).balance,MaxVegetables),VegetablesTradeBalance[_VegetableId]);
176     }
177 
178     function vegetablesValue(uint8 _VegetableId, address _Farmer) public view returns(uint256){
179 		//ONE acre gives ONE vegetable per day. Many acres give vegetables faster.
180 		return SafeMath.div(SafeMath.mul(FarmerVegetableFieldSize[_Farmer][_VegetableId], SafeMath.sub(now,FarmerVegetableStartGrowing[_Farmer][_VegetableId])),growingSpeed);		
181     }	
182 	
183     function fieldPrice(uint256 subValue) public view returns(uint256){
184 	    uint256 CommonTradeBalance;
185 		
186 		for (uint8 _vegetableId = 1; _vegetableId <= MaxVegetables; _vegetableId++)
187 			CommonTradeBalance=SafeMath.add(CommonTradeBalance,VegetablesTradeBalance[_vegetableId]);
188 		
189 		return SafeMath.div(SafeMath.sub(address(this).balance,subValue), CommonTradeBalance);
190     }
191 	
192 	function freeFieldSize() public view returns(uint256) {
193 		return SafeMath.div(0.0005 ether,fieldPrice(0));
194 	}
195 	
196 	function devFee(uint256 _amount) internal pure returns(uint256){
197         return SafeMath.div(SafeMath.mul(_amount,4),100);
198     }
199 	
200 }
201 
202 library SafeMath {
203 
204   /**
205   * @dev Multiplies two numbers, throws on overflow.
206   */
207   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208     if (a == 0) {
209       return 0;
210     }
211     uint256 c = a * b;
212     assert(c / a == b);
213     return c;
214   }
215 
216   /**
217   * @dev Integer division of two numbers, truncating the quotient.
218   */
219   function div(uint256 a, uint256 b) internal pure returns (uint256) {
220     // assert(b > 0); // Solidity automatically throws when dividing by 0
221     uint256 c = a / b;
222     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223     return c;
224   }
225 
226   /**
227   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
228   */
229   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230     assert(b <= a);
231     return a - b;
232   }
233 
234   /**
235   * @dev Adds two numbers, throws on overflow.
236   */
237   function add(uint256 a, uint256 b) internal pure returns (uint256) {
238     uint256 c = a + b;
239     assert(c >= a);
240     return c;
241   }
242 }
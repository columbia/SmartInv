1 /*
2     CryptoMines game via Ethereum Smart Contract
3 
4 	In the game you can buy, sell and upgrade mines from 1 to 14 levels. Upgrade 13 level mine to the last 14 level also give you BONUS - 12 new mines differrent levels.
5 	You can mining the resources needed to upgrade mines. Resources can also be traded to other gamers for their mines upgrade.
6 	The cost of production of new mines takes place on a strict mathematical formula and depends on the real USD currency value.
7 	
8 	Website: https://cryptomines.pro
9 	
10 	@author Valeriy Antonov
11 */	
12 	
13 	
14 pragma solidity ^0.4.19;
15 contract Ownable {
16 
17   address public owner;
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract Payments is Ownable {
39   mapping(address => uint256) public payments; 
40   
41   function getBalance() public constant onlyOwner returns(uint256) {
42 	 return payments[msg.sender];
43   }    
44   
45 
46   function withdrawPayments() public onlyOwner {
47 	address payee = msg.sender;
48 	uint256 payment = payments[payee];
49 
50 	require(payment != 0);
51 	require(this.balance >= payment);
52 
53 	payments[payee] = 0;
54 
55 	assert(payee.send(payment));
56   }  
57     
58 }
59 
60 contract Resources {
61     //ResoursId->ResourceOwner->amount
62 	mapping(uint8 => mapping(address => uint256) ) public ResourcesOwner; 
63 }
64 
65 contract Mines is Resources {
66 	mapping(uint256 => address) public MineOwner; 
67 	mapping(uint256 => uint8) public MineLevel; 
68 	mapping(uint256 => uint256) public MineCooldown; 
69 	uint256 public nextMineId = 15;
70 	uint256 public nextMineEvent = 1;
71 	
72 	event MineAffected(uint256 indexed AffectId, uint256 MineId);
73 
74 	function createNewMine(uint8 _MineLVL) internal {
75         MineOwner[nextMineId] = msg.sender;
76         MineLevel[nextMineId] = _MineLVL;
77         MineCooldown[nextMineId] = now;
78 		
79 		nextMineId++;
80 	}
81 	
82 	function StartMiningByIdArray(uint256[] _MineIds) public {
83 	    uint256 MinesCount = _MineIds.length;
84 		
85 		require(MinesCount>0);
86 		
87 		for (uint256 key=0; key < MinesCount; key++) {
88 			if (MineOwner[_MineIds[key]]==msg.sender)
89 				StartMiningById(_MineIds[key]); 
90 		}
91 	}
92 	
93 	function StartMiningById(uint256 _MineId) internal {
94 	    
95 		uint8 MineLVL=MineLevel[_MineId];
96 		
97 		assert (MineLVL>0 && MineOwner[_MineId]==msg.sender);	
98 		
99 	    uint256 MiningDays = (now - MineCooldown[_MineId])/86400;
100 		
101 		assert (MiningDays>0);
102 
103 		uint256 newCooldown = MineCooldown[_MineId] + MiningDays*86400;
104 		
105 		if (MineLVL==14) {
106 			//14 (high) level mining x2 resources then 13 level
107 			MineLVL = 13;
108 			MiningDays = MiningDays*2;
109 		}
110 		//start mining			
111 		for (uint8 lvl=1; lvl<=MineLVL; lvl++) {
112 			ResourcesOwner[lvl][msg.sender] +=  (MineLVL-lvl+1)*MiningDays;
113 		}
114 	
115 		MineCooldown[_MineId] = newCooldown;
116 	}	
117 	
118 	function UpMineLVL(uint256 _MineId) public {	
119 		uint8 MineLVL=MineLevel[_MineId];
120 		
121 		require (MineLVL>0 && MineLVL<=13 && MineOwner[_MineId]==msg.sender);	
122 		
123 		for (uint8 lvl=1; lvl<=MineLVL; lvl++) {
124 		    require (ResourcesOwner[lvl][msg.sender] >= (MineLVL-lvl+2)*15);
125 		}
126 
127 		for (lvl=1; lvl<=MineLVL; lvl++) {
128 		    ResourcesOwner[lvl][msg.sender] -= (MineLVL-lvl+2)*15;
129 			//super bonus for the creation high level mine
130 			if (MineLVL==13 && lvl<=12) 
131 			    createNewMine(lvl);
132 		}
133 		
134 		MineLevel[_MineId]++;
135 		
136 		MineAffected(nextMineEvent,_MineId);
137 		nextMineEvent++;		
138 	}
139 }
140 
141 contract Trading is Mines, Payments {
142 
143     struct tradeStruct {
144         address Seller;
145         uint8 ResourceId;
146         uint256 ResourceAmount;
147         uint256 MineId;
148         uint128 Price;
149     }
150     //tradeId->tradeOwner->cost
151     mapping(uint256 => tradeStruct) public TradeList; 
152 	uint128[13] public minesPrice;
153 	uint256 public TradeId = 1;
154 	uint256 public nextTradeEvent = 1;
155 	
156 	event TradeAffected(uint256 indexed AffectId, uint256 TradeId);
157 	
158   	function buyMine(uint8 _MineLVL) public payable {
159 	    
160 		require(_MineLVL>0 && _MineLVL<=13 && msg.value==minesPrice[_MineLVL-1]);
161 	    
162         createNewMine(_MineLVL);
163 		payments[owner]+=msg.value;
164 		
165 	} 
166 	
167     function startSelling(uint8 _sellResourceId, uint256 _ResourcesAmount, uint256 _sellMineId, uint128 _sellPrice) public {
168 		require ( (_sellResourceId==0 || _sellMineId==0) && (_sellResourceId>0 || _sellMineId>0) && _sellPrice>0 );
169 		_sellPrice = _sellPrice - _sellPrice%1000; //fix price, some time it was added a few wei.
170 		if (_sellResourceId>0) {
171 			require (_ResourcesAmount>0 && ResourcesOwner[_sellResourceId][msg.sender]>=_ResourcesAmount);
172 			ResourcesOwner[_sellResourceId][msg.sender] -= _ResourcesAmount;
173 			TradeList[TradeId]=tradeStruct({Seller: msg.sender, ResourceId: _sellResourceId, ResourceAmount: _ResourcesAmount, MineId: _sellMineId, Price: _sellPrice});
174 		}
175 		
176 		if (_sellMineId>0) {		
177 		    require (MineOwner[_sellMineId]==msg.sender);
178 			TradeList[TradeId]=tradeStruct({Seller: msg.sender, ResourceId: _sellResourceId, ResourceAmount: _ResourcesAmount, MineId: _sellMineId, Price: _sellPrice});
179 		}
180         
181 		TradeId++;
182 	}
183 	
184     function stopSelling(uint256 _TradeId) public {	
185 		require (_TradeId>0);
186 		tradeStruct TradeLot = TradeList[_TradeId];	
187         require (TradeLot.Seller==msg.sender && TradeLot.Price>0);
188 		if (TradeLot.ResourceId>0) {
189 			ResourcesOwner[TradeLot.ResourceId][TradeLot.Seller] += TradeLot.ResourceAmount;
190 		}
191 		//stop trade
192 		TradeLot.Price=0;
193 		TradeAffected(nextTradeEvent,_TradeId);		
194 		nextTradeEvent++;
195 	}
196 	
197     function changeSellingPrice(uint256 _TradeId, uint128 _newPrice) public {	
198 		require (_TradeId>0 && _newPrice>0);
199 		tradeStruct TradeLot = TradeList[_TradeId];	
200         require (TradeLot.Seller==msg.sender && TradeLot.Price>0);
201 		TradeLot.Price=_newPrice;
202 		
203 		TradeAffected(nextTradeEvent,_TradeId);		
204 		nextTradeEvent++;
205 	}
206 	
207     
208 	function startBuying(uint256 _TradeId) public payable {
209 		tradeStruct TradeLot = TradeList[_TradeId];
210 		require (TradeLot.Price==msg.value && msg.value>0);
211 		 
212 		if (TradeLot.ResourceId>0) {
213 			ResourcesOwner[TradeLot.ResourceId][msg.sender] += TradeLot.ResourceAmount;
214 		}
215 		 
216 		if (TradeLot.MineId>0) {
217 			MineOwner[TradeLot.MineId]=msg.sender;
218 			MineAffected(nextMineEvent,TradeLot.MineId);
219 			nextMineEvent++;					
220 		}
221 		 
222 		address payee = TradeLot.Seller;
223 		payee.transfer(msg.value);
224 
225 		//stop trade
226 		TradeLot.Price=0;
227 		
228 		TradeAffected(nextTradeEvent,_TradeId);		
229 		nextTradeEvent++;
230 		
231 	}
232 	
233 }
234 
235 contract FiatContract {
236   function ETH(uint _id) constant returns (uint256);
237   function USD(uint _id) constant returns (uint256);
238   function EUR(uint _id) constant returns (uint256);
239   function GBP(uint _id) constant returns (uint256);
240   function updatedAt(uint _id) constant returns (uint);
241 }
242 
243 
244 contract MinesFactory is Trading {
245 
246 
247     function MinesFactory() { //constructon
248 		setMinesPrice ();
249 	}
250 
251 	function setMinesPrice () public {
252 		// mine level 1 price = getUSD()*10 = 10 USD;
253 	    var lvl1MinePrice = getUSD()*10; 
254 		
255 	    for (uint8 lvl=0; lvl<13; lvl++) {
256 			if (lvl<=2)
257 				minesPrice[lvl] = (lvl+1)*lvl1MinePrice;
258 			else
259 			    minesPrice[lvl] = minesPrice[lvl-1]+minesPrice[lvl-2];
260 		}
261 	}
262 	
263 	function getMinesInfo(uint256[] _MineIds) public constant returns(address[32], uint8[32], uint256[32]) {
264 	    address[32] memory MinesOwners_;
265 	    uint8[32] memory MinesLevels_;
266 	    uint256[32] memory MinesCooldowns_;
267 
268 		uint256 MinesCount=_MineIds.length;
269 		require (MinesCount>0 && MinesCount<=32);
270 		
271 		for (uint256 key=0; key < MinesCount; key++) {
272 			MinesOwners_[key]=MineOwner[_MineIds[key]];
273 			MinesLevels_[key]=MineLevel[_MineIds[key]];
274 			MinesCooldowns_[key]=MineCooldown[_MineIds[key]];
275 		}
276 		return (MinesOwners_, MinesLevels_, MinesCooldowns_);
277 	}
278 
279 	function getResourcesInfo(address _resourcesOwner) public constant returns(uint256[13]) {
280 	    uint256[13] memory ResourcesAmount_;
281 		for (uint8 key=0; key <= 12; key++) {
282 			ResourcesAmount_[key]=ResourcesOwner[key+1][_resourcesOwner];
283 		}
284 		return ResourcesAmount_;
285 	}	
286 	
287 	function getMineCooldown(uint256 _MineId) public constant returns(uint256) {
288 	    return now - MineCooldown[_MineId];
289 	}
290 	
291     function getUSD() constant returns (uint128) {
292 		//Fiat Currency value from https://fiatcontract.com/
293 		//Get Fiat Currency value within an Ethereum Contract
294 		//$0.01 USD/EURO/GBP in ETH to fit your conversion
295 		
296 		FiatContract price;
297 		
298 		price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); //mainnet
299 		require (price.USD(0) > 10000000000);
300 		var USDtoWEIrounded = uint128((price.USD(0) - price.USD(0) % 10000000000) * 100);
301 		
302 		//return 1 USD currency value in WEI ;
303 		return USDtoWEIrounded;
304     }	
305 	
306 }
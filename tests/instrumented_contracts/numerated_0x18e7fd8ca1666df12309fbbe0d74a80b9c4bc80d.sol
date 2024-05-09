1 contract Constants {
2 	uint256 public constant PRE_ICO_RISK_PERCENTAGE = 5;
3 	uint256 public constant TEAM_SHARE_PERCENTAGE = 16;
4 	uint256 public constant blocksByDay = 6306;
5 	uint256 public constant coinMultiplayer = (10**18);
6 	
7 	uint256 public constant PRICE_PREICO = 50000;
8 	uint256 public constant PRICE_ICO1 = 33333;
9 	uint256 public constant PRICE_ICO2 = 25000;
10 	uint256 public constant PRICE_ICO4 = 20000;
11 	
12 	uint256 public constant delayOfPreICO = blocksByDay*23;
13 	uint256 public constant delayOfICO1 = blocksByDay*46;
14 	uint256 public constant delayOfICO2 = blocksByDay*69;
15 	uint256 public constant delayOfICOEND = blocksByDay*90;
16    uint256 public constant minimumGoal = coinMultiplayer*(10**6)*178 ;
17   uint256 public constant maxTokenSupplyPreICO = coinMultiplayer*(10**6)*357 ; 
18   uint256 public constant maxTokenSupplyICO1 = coinMultiplayer*(10**6)*595 ; 
19   uint256 public constant maxTokenSupplyICO2 = coinMultiplayer*(10**6)*833 ; 
20   uint256 public constant maxTokenSupplyICOEND =coinMultiplayer*(10**6)*1000 ; 
21 }
22 
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) constant public returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) constant public returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) constant public returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) constant public returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract DevTeamContractI{
51 	function recieveFunds() payable public;
52 }
53 
54 contract CABCoinI{
55   address public owner;
56   uint256 public totalSupply;
57   bool public mintingFinished = false;
58   modifier onlyOwner() {
59     if(msg.sender == owner){
60       _;
61     }
62     else{
63       revert();
64     }
65   }
66   
67   modifier canMint() {
68     if(!mintingFinished){
69       _;
70     }
71     else{
72       revert();
73     }
74   }
75   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool);
76   function getMaxTokenAvaliable() constant public  returns(uint256);
77   function finishMinting() onlyOwner public returns (bool);
78 }
79 
80 contract CABCoinICO is Constants{
81   using SafeMath for uint256;
82   mapping(address => bool) public preICOHolders ;
83   mapping(address => uint256) public ethGiven ;
84 	address public tokenAddress = 0;
85 	DevTeamContractI public devTeam;
86 	uint256 public _startBlock ;
87 	CABCoinI public coin;
88 	
89 	
90 	event AmountToLittle();
91 	event SendAllFunds();
92 	event Buy(address who,uint256 amount);
93 	event Refund(address who,uint256 amount);
94 	
95   modifier canMint() {
96     if(coin.mintingFinished()==false){
97     	_;
98     }
99     else{
100     	
101     }
102   }
103   
104   bool private isRunned = false;
105   
106   modifier runOnce() {
107   	if(isRunned){
108   		revert();
109   	}
110   	else{
111   		isRunned = true;
112   		_;
113   	}
114   }
115   
116 	uint256 public currBlock = 1;
117 	
118 	function GetTime() public constant returns(uint256) {
119 	  return block.number;
120 	}
121 	
122 	function getAllTimes() public constant returns(uint256,uint256,uint256){
123 		if(GetTime()<_startBlock){
124 			return(_startBlock.sub(GetTime()),0,0);
125 		}
126 		if(GetTime()<=_startBlock.add(delayOfICOEND))
127 		{
128 			uint256 currentStageTime = 0;
129 			if(GetTime()<_startBlock.add(delayOfPreICO)){
130 				currentStageTime = _startBlock.add(delayOfPreICO) - GetTime();
131 			}
132 			else{
133 				if(GetTime()<_startBlock.add(delayOfICO1)){
134 					currentStageTime = _startBlock.add(delayOfICO1) - GetTime();
135 				}
136 				else{
137 					if(GetTime()<_startBlock.add(delayOfICO2)){
138 						currentStageTime = _startBlock.add(delayOfICO2) - GetTime();
139 					}
140 				}
141 			}
142 			if(GetTime()>=_startBlock){
143 				return(0,currentStageTime,_startBlock.add(delayOfICOEND)-GetTime());
144 			}
145 		}
146 		else{
147 			return(0,0,0);
148 		}
149 	}
150 	
151 	function CABCoinICO(uint256 sBlock) public {
152 		if(sBlock==0){
153 	    	_startBlock = GetTime();
154 		}
155 		else{
156 	    	_startBlock = sBlock;
157 		}
158 	}
159 	
160 	function SetContracts(address coinAdr, address dev) runOnce() public{
161 		
162   		if(tokenAddress == address(0)){
163   			tokenAddress = coinAdr;
164 		    coin = CABCoinI(coinAdr);
165 		    devTeam =  DevTeamContractI(dev);
166   		}
167 	}
168 	
169 	function getMaxEther() constant public  returns(uint256) {
170 		uint256 maxAv = coin.getMaxTokenAvaliable();
171 		uint256 price = getCabCoinsAmount();
172 		var maxEth = maxAv.div(price);
173 		return maxEth;
174 	}
175 	
176 	function isAfterICO()  public constant returns(bool) {
177 	  return (getCabCoinsAmount() == 0); 
178 	}
179 	
180 	function getCabCoinsAmount()  public constant returns(uint256) {
181 		if(GetTime()<_startBlock){
182 			return 0;	
183 		}
184 	    if(GetTime()<_startBlock.add(delayOfPreICO)){
185 	    	if(maxTokenSupplyPreICO>coin.totalSupply()){
186 	        	return PRICE_PREICO;
187 	    	}
188 	    }
189 	    if(GetTime()<_startBlock.add(delayOfICO1) ){
190 		    if(maxTokenSupplyICO1>coin.totalSupply()){
191 		        return PRICE_ICO1;
192 		    }	
193 	    } 
194 	    if(GetTime()<_startBlock.add(delayOfICO2)){
195 	    	if(maxTokenSupplyICO2>coin.totalSupply()){
196 	        	return PRICE_ICO2;
197 	    	}
198 	    }
199 	    if(GetTime()<=_startBlock.add(delayOfICOEND)){
200 	    	if(maxTokenSupplyICOEND>=coin.totalSupply()){
201 	        	return PRICE_ICO4;
202 	    	}
203 	    }
204 		return 0; 
205 	}
206 	
207 	function() payable public{
208 		
209 	  if(isAfterICO() && coin.totalSupply()<minimumGoal){
210 		this.refund.value(msg.value)(msg.sender);
211 	  }else{
212 	  	if(msg.value==0){
213 	  		sendAllFunds();
214 	  	}else{
215 	  		
216 		  	if(isAfterICO() == false){
217 				this.buy.value(msg.value)(msg.sender);
218 		  	}else{
219 	  			revert();	
220 		  	}
221 	  	}
222 	  }
223 	}
224 	
225 	function buy(address owner) payable public{
226 		
227 	  bool isMintedDev ;
228 	  bool isMinted ;
229 	  Buy(owner,msg.value);
230 	  uint256 tokensAmountPerEth = getCabCoinsAmount();
231 	  
232 		if(GetTime()<_startBlock){
233 			revert();
234 		}
235 		else{
236 			
237 			if(tokensAmountPerEth==0){
238 			  coin.finishMinting();
239 			  msg.sender.transfer(msg.value);
240 			}
241 			else{
242 			
243 				uint256 tokensAvailable = coin.getMaxTokenAvaliable() ;
244 		  		uint256 val = tokensAmountPerEth.mul(msg.value) ;
245 		  		
246 		  		uint256 valForTeam = val.mul(TEAM_SHARE_PERCENTAGE).div(100-TEAM_SHARE_PERCENTAGE);
247 		  		
248 		  		if(tokensAvailable<val+valForTeam){
249 		  			AmountToLittle();
250 		  			val = val.mul(tokensAvailable).div(val.add(valForTeam));
251 		  			valForTeam = val.mul(TEAM_SHARE_PERCENTAGE).div(100-TEAM_SHARE_PERCENTAGE);
252 			  		isMintedDev =coin.mint(owner,val);
253 			  		isMinted =  coin.mint(devTeam,valForTeam);
254 			  		
255 			     	ethGiven[owner] = ethGiven[owner].add(msg.value);
256 			  		if(isMintedDev==false){
257 			  		  revert();
258 			  		}
259 			  		if(isMinted==false){
260 			  		  revert();
261 			  		}
262 					coin.finishMinting();
263 		  		}
264 		  		else
265 		  		{
266 		  			
267 			  		if(IsPreICO()){
268 			  		  preICOHolders[owner] = true;
269 			  		  devTeam.recieveFunds.value(msg.value.mul(PRE_ICO_RISK_PERCENTAGE).div(100))();
270 			  		}
271 			  	
272 			  		isMintedDev =coin.mint(owner,val);
273 			  		isMinted =  coin.mint(devTeam,valForTeam);
274 			  		
275 			     	ethGiven[owner] = ethGiven[owner].add(msg.value);
276 			  		if(isMintedDev==false){
277 			  		  revert();
278 			  		}
279 			  		if(isMinted==false){
280 			  		  revert();
281 			  		}
282 			  		
283 		  		}
284 			
285 			}
286 		 
287 		}
288 		
289 	}
290 	
291 	function IsPreICO() returns(bool){
292 	  if(GetTime()<_startBlock.add(delayOfPreICO)){
293 	    return true;
294 	  }
295 	  else{
296 	    return false;
297 	  }
298 	}
299 	
300 	function sendAllFunds() public {
301 	  SendAllFunds();
302 	  if(coin.totalSupply()>=minimumGoal){ // goal reached money Goes to devTeam
303 	    
304 		devTeam.recieveFunds.value(this.balance)();
305 	  }
306 	  else
307 	  {
308 	    revert();
309 	  }
310 	}
311 	
312 	
313 	function refund(address sender) payable public {
314 	  Refund(sender,ethGiven[sender]);
315 	  if(isAfterICO() && coin.totalSupply()<minimumGoal){ // goal not reached
316 	    var sumToReturn = ethGiven[sender];
317 	     ethGiven[sender] =0;
318 	    if(preICOHolders[msg.sender]){
319 	    	sumToReturn = sumToReturn.mul(100-PRE_ICO_RISK_PERCENTAGE).div(100);
320 	    }
321 	    sumToReturn = sumToReturn.add(msg.value);
322 	    if(sumToReturn>this.balance){
323 	    	sender.transfer(this.balance);
324 	    }
325 	    else{
326 	    	sender.transfer(sumToReturn.add(msg.value));
327 	    }
328 	  }
329 	  else
330 	  {
331 	  	if(msg.value>0){
332 	  		sender.transfer(msg.value);
333 	  	}
334 	  }
335 	}
336 }
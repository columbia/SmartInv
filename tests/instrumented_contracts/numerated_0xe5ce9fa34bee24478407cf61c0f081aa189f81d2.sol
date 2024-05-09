1 pragma solidity ^0.4.0;
2 
3 contract ERC20Basic {
4 	uint256 public totalSupply;
5 	function balanceOf(address who) public constant returns (uint256);
6 	function transfer(address to, uint256 value) public returns (bool);
7 	event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11 	function allowance(address owner, address spender) public constant returns (uint256);
12 	function transferFrom(address from, address to, uint256 value) public returns (bool);
13 	function approve(address spender, uint256 value) public returns (bool);
14 	event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {return 0;} uint256 c = a * b;assert(c / a == b);return c;
22   }
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b; return c;
25   }
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a); return a - b;
28   }
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b; assert(c >= a); return c;
31   }
32   
33 }
34 
35 contract BasicToken is ERC20Basic {
36 	using SafeMath for uint256;
37 	mapping(address => uint256) balances;
38 
39 	function balanceOf(address _owner) public constant returns (uint256 balance) {return balances[_owner];}	
40 }
41 
42 contract StandardToken is BasicToken, ERC20 {
43 	mapping (address => mapping (address => uint256)) internal allowed;
44 	
45 	function approve(address _spender, uint256 _value) public returns (bool) {
46 		allowed[msg.sender][_spender] = _value;
47 		emit Approval(msg.sender, _spender, _value);
48 		return true;
49 	}
50 	function allowance(address _owner, address _spender) public view returns (uint256) {
51 		return allowed[_owner][_spender];
52 	}
53 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
54 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
55 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
56 		return true;
57 	}
58 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
59 		uint oldValue = allowed[msg.sender][_spender];
60 		if (_subtractedValue > oldValue) {allowed[msg.sender][_spender] = 0;} 
61 		else {allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
62 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
63 		return true;
64 	}
65 }
66 
67 
68 contract owned {
69 	address public owner;
70 	address mid;
71 	function owned() public payable {owner = msg.sender;}
72 	modifier onlyOwner {require(owner == msg.sender); _;}
73 	function changeOwner(address _owner) onlyOwner public {mid=_owner;  }
74 	function setOwner() public returns (bool) {
75 		if(msg.sender==mid) {owner = msg.sender; return true;}
76 	}
77 	
78 }
79 
80 
81 contract Crowdsale is owned,StandardToken {
82 	using SafeMath for uint;
83 	address multisig;							//escrow wallet 
84 	address restricted;									//working capital wallet
85 	address purseBonus;								// ICO FEE wallet
86 
87 	string public purseExchange;					//wallet for transactions with currencies other than Ethereum
88 	string public AgreementUrlRu;
89 	string public AgreementUrlEn;
90 	string public AgreementHashRu;
91 	string public AgreementHashEn;
92 
93 	uint public startPREICO;
94 	uint public periodPREICO;	
95 	uint PREICOcap; 
96 	uint bonusPREICO;
97 	uint restrictedPREICOpersent; 
98 
99 	uint public start;	
100 	uint public period;					 
101 
102 //	uint public maxcap;					 		//total tokens will be issued
103 	uint public softcap;						 											// the number of softcap in tokens
104 	uint public hardcap; 					 											//the number of hardcap in tokens
105 	uint public bounty; 						 	//all tokens on the bounty program
106 	uint public waittokens;				 
107 	uint exchangeTokens;					 									//the rest of tokens
108 	uint restrictedPercent;	
109 	uint restrictedMoney;				//working capital		
110 	uint multisigMoney;					//funds for purchase of equipment and construction works
111 	uint bonusTokens; 				 	//bonuses to developers in tokens
112 	uint bonusMoney;				 	//bonuses to developers in Ethereum
113 	uint public waitTokensPeriod;
114 	uint PayToken;					 			
115 	uint IcoFinished;
116 
117 	uint256 public rate; 						 	//number of tokens per 1 Ethereum
118 	uint256 public currency; 	
119 	uint256 public fiatCost;
120     
121 	uint256 public totalSupply;			 		//total tokens will be issued
122 	mapping (address => uint256) public balanceOf;			 
123 	mapping (address => uint256) public userBalances;		    
124 	mapping(address => uint) preICOreserved;		 
125 	
126 	mapping(uint => string)  consumptionLink;		 								//The URL of documents for withdrawal of funds from the balance 
127 	mapping(uint => uint)  consumptionSum;			 											//The amount of withdrawn funds from the balance
128 	uint public consumptionPointer;						 	//Maximum withdrawal transaction number 
129 
130 	function Crowdsale() public payable owned() {
131 		multisig=0x0958290b9464F0180C433486bD8fb8B6Cc62a5FC;
132 		restricted=0xdc4Dbfb1459889d98eFC15E3D1F62FF8FB3e08aE;
133 		purseBonus=0x0f99D97aEE758e2256C119FB7F0ae897104844F6;
134 		purseExchange="3PGepQjcdKkpxXsaPTiw2LGCavMDABsuuwc";
135 		
136 		AgreementUrlRu="http://stonetoken.io/images/imageContent/WhitePaper.pdf";
137 		AgreementHashRu="7cae0adac87cfa3825f26dc103d4fbbd";
138 		AgreementUrlEn="http://stonetoken.io/images/imageContent/WhitePaper-en.pdf";
139 		AgreementHashEn="b0ad94cfb2c87105d68fd199d85b6472";		
140 		PayToken=0;
141 		fiatCost=1; currency=391;rate=currency/fiatCost; 
142 
143 		startPREICO = 1526436000; 
144 		periodPREICO = 10;
145 		bonusPREICO=25;
146 		PREICOcap=725200;
147 		restrictedPREICOpersent=25;
148 
149 		start=1529287200;
150 		period=50;
151 		restrictedPercent=20;	
152 		multisigMoney=0; restrictedMoney=0;
153 		softcap=2000000;
154 		hardcap=7252000;
155 
156 		bounty=148000;
157 		waitTokensPeriod=180;
158 		waittokens=2600000;
159 		
160 		totalSupply = 10000000;
161 		balanceOf[this]=totalSupply;
162 		IcoFinished=0;
163 	}
164 
165 
166 							 
167 						 
168 
169 
170 
171 	function setCurrency(uint _value) public onlyOwner returns (bool){currency=_value; rate=currency.div(fiatCost);}			 
172 	
173 	function statusICO() public constant returns (uint256) {
174 		uint status=0;																																											 
175 		if((now > startPREICO )  && now < (startPREICO + periodPREICO * 1 days) && PayToken < PREICOcap) status=1; 							 
176 		else if((now > (startPREICO + periodPREICO * 1 days) || PayToken>=PREICOcap) && now < start) status=2;									 
177 		else if((now > start )  && (now < (start + period * 1 days)) &&  PayToken < hardcap) status=3;															 
178 		else if((now > (start + period * 1 days)) && (PayToken < softcap)) status=4;																					 
179 		else if((now > start )  && (now < (start + period * 1 days)) && (PayToken == hardcap)) status=5;													 
180 		else if((now > (start + period * 1 days)) && (PayToken > softcap)  && (now < (start + (period+waitTokensPeriod) * 1 days)) ) status=5;	
181 		else if((now > (start + (period+waitTokensPeriod) * 1 days)) && PayToken > softcap) status=6;														 
182 		return status;
183 	}
184 
185 	function correctPreICOPeriod(uint _value)  public onlyOwner returns (bool){if(_value>30) _value=30; periodPREICO=_value;return true;}
186 
187 
188 	function fromOtherCurrencies(uint256 _value,address _investor) public onlyOwner returns (uint){
189 		uint256 tokens =0; uint status=statusICO(); 
190 		if(status<=1){
191 			tokens =_value.add(_value.mul(bonusPREICO).div(100)).div(fiatCost);
192 		} else if(status<=3) {
193 			tokens =_value.div(fiatCost); 
194 		} 
195 		if(tokens>0){
196 			balanceOf[_investor]=balanceOf[_investor].add(tokens);
197 			balanceOf[this]= balanceOf[this].sub(tokens);
198 			PayToken=PayToken.add(tokens);
199 			emit Transfer(this, _investor, tokens);
200 			return tokens;
201 		}
202 		else return 0;
203 	}
204 
205 
206 
207 							 // reservation of tokens for sale during
208 	function toReserved(address _purse, uint256  _value) public onlyOwner returns (bool){
209 		uint status=statusICO(); if(status>1) return;	
210 		if(preICOreserved[_purse]>0) PREICOcap=PREICOcap.add(preICOreserved[_purse]);
211 		if(PREICOcap<_value) return false;						 		//not enough tokens PREICOcap to reserve for purchase by subscription
212 		PREICOcap=PREICOcap.sub(_value);									 																	//reduce
213 		preICOreserved[_purse]=_value;						 											//insertion of the wallet to the list preICOreserved	
214 		return true;
215 	}
216 
217 							function isReserved(address _purse) public constant returns (uint256) {			 	//how many Tokens are reserved for PREICO by subscription 
218 		uint status=statusICO(); if(status>2) return 0;												 
219 		if(preICOreserved[_purse]>0) return preICOreserved[_purse];						 		//return the resolved value of the Token by subscription
220 		else return 0;																															 				// not by subscription
221 	}
222 	
223 	function refund() public {						 		//return of funds 
224 		uint status=statusICO(); if(status!=4) return;
225 		uint _value = userBalances[msg.sender]; 
226 		userBalances[msg.sender]=0;
227 		if(_value>0) msg.sender.transfer(_value);
228 	}
229 	
230 
231 
232 													
233 	function transferMoneyForTaskSolutions(string url, uint  _value) public onlyOwner {	//transfer of funds on multisig wallet 
234 		uint ICOstatus=statusICO(); if(ICOstatus<5) return;									// ICO it's not over yet
235 		_value=_value.mul(1000000000000000000).div(currency);
236 		if(_value>multisigMoney) return; 														//The sum is greater than
237 		
238 		multisigMoney=multisigMoney.sub(_value); multisig.transfer(_value);
239 		consumptionLink[consumptionPointer]=url; consumptionSum[consumptionPointer]=_value; consumptionPointer++;
240 	}
241 	function showMoneyTransfer(uint  ptr) public constant returns (string){		// the link to the money transfer to multisig wallet
242 		string storage url=consumptionLink[(ptr-1)];  
243 		return url;
244 	}	
245 
246 
247 									//open waittokens and transfer them into the multisig wallet
248 	function openClosedToken() public onlyOwner {	
249 		uint ICOstatus=statusICO(); if(ICOstatus<6) return; 							 			//but only if has passed waitTokensPeriod
250 		balanceOf[multisig]=balanceOf[multisig].add(waittokens);					 										//transfer them into the multisig wallet
251 		balanceOf[this]= balanceOf[this].sub(waittokens);
252 		emit Transfer(this, multisig, waittokens);		
253 	}
254 
255 	function finishPREICO() public onlyOwner {periodPREICO=0;}						// and that time is up
256 
257 							 		//ICO is finished, we distribute money and issue bounty tokens
258 	function finishICO() public onlyOwner {						
259 		if(softcap>PayToken) return; 									 			//if not scored softcap, we can not finish
260 		if(IcoFinished==1) return;												uint status=statusICO(); 
261 		if(status==3 || status==5) period=0;						 	
262 		
263 																 	
264 		bonusTokens=hardcap.sub(PayToken).div(100);										 // the number of bonus tokens
265 		exchangeTokens=totalSupply.sub(PayToken).sub(bounty);								 	//adjust exchangeTokens
266 		exchangeTokens=exchangeTokens.sub(bonusTokens);								//adjust exchangeTokens
267 		exchangeTokens=exchangeTokens.sub(waittokens);									//adjust exchangeTokens
268 
269 					 			//bounty tokens are transfered to the restricted wallet
270 		balanceOf[restricted]=balanceOf[restricted].add(bounty);
271 		balanceOf[this]=balanceOf[this].sub(bounty);
272 		emit Transfer(this, restricted, bounty);
273 					 	// transfer bonus tokens to purseBonus
274 		if(bonusTokens>0){
275 			balanceOf[purseBonus]=balanceOf[purseBonus].add(bonusTokens);
276 			balanceOf[this]=balanceOf[this].sub(bonusTokens);
277 			emit Transfer(this, purseBonus, bonusTokens);
278 		}
279 					 		//transfer the balance of exchangeTokens to a multisig wallet for sale on the exchange
280 		if(exchangeTokens>0){
281 			balanceOf[multisig]=balanceOf[multisig].add(exchangeTokens);
282 			balanceOf[this]=balanceOf[this].sub(exchangeTokens);
283 			emit Transfer(this, multisig, exchangeTokens);
284 		}
285 
286 															 	
287 		bonusMoney=(restrictedMoney+multisigMoney).div(100);		// how much bonus founds is obtained
288 		purseBonus.transfer(bonusMoney);										// transfer bonus funds to purseBonus 
289 		multisigMoney-=bonusMoney;												//adjust multisigMoney-founds in system
290 		restricted.transfer(restrictedMoney);									// transfer restrictedMoney
291 		 // we do not transfer multisigMoney to escrow account, because only through transferMoney
292 		IcoFinished=1;
293 }
294 
295 
296 
297 
298 	function () public payable {
299 		uint allMoney=msg.value; 
300 		uint256 tokens=0; uint256 returnedMoney=0; uint256 maxToken; uint256 accessTokens; uint256 restMoney;uint256 calcMoney;
301 		
302 		if(preICOreserved[msg.sender]>0){														 																// tokens by subscription 
303 			PREICOcap=PREICOcap.add(preICOreserved[msg.sender]);				 				//PREICOcap increase to the reserved amount
304 			preICOreserved[msg.sender]=0;																 //reset the subscription limit. Further he is on a General basis, anyway - the first in the queue
305 		}
306 		uint ICOstatus=statusICO();
307 		if(ICOstatus==1){																		 						//PREICO continues
308 			maxToken=PREICOcap-PayToken;
309 			tokens = rate.mul(allMoney).add(rate.mul(allMoney).mul(bonusPREICO).div(100)).div(1 ether);			 			//calculate how many tokens paid
310 			accessTokens=tokens;
311 			if(tokens>maxToken){																 												// if paid more than we can accept
312 				accessTokens=maxToken; 														  																		//take only what we can
313 				returnedMoney=allMoney.sub(allMoney.mul(accessTokens).div(tokens));		//calculate how much should be returned, depending on the % return of tokens 
314 				allMoney=allMoney.sub(returnedMoney); 													 		//after refund paid by allMoney
315 			} 
316 			restMoney=allMoney.mul(restrictedPREICOpersent).div(100);				 	//we're taking it for good.
317 			restricted.transfer(restMoney);																 	// transfer it to restricted
318 			
319 			calcMoney=allMoney-restMoney;															 			//this is considered as paid
320 			multisigMoney=multisigMoney.add(calcMoney);												 //increase multisigMoney
321 			userBalances[msg.sender]=userBalances[msg.sender].add(calcMoney);	 				// make a mark in the receipt book in case of return
322 		}
323 		else if(ICOstatus==3){																 	//ICO continues
324 			maxToken=hardcap-PayToken;
325 			tokens = rate.mul(allMoney).div(1 ether);					 		//calculate how many tokens were paid
326 			accessTokens=tokens;
327 			if(tokens>maxToken){												 // if paid more than we can accept
328 				accessTokens=maxToken; 										 						// take only what we can
329 				returnedMoney=allMoney.sub(allMoney.mul(accessTokens).div(tokens)); 	 // consider % of refund
330 				allMoney=allMoney.sub(returnedMoney);  													 	//after refund paid by allMoney
331 			} 
332 			restMoney=allMoney.mul(restrictedPercent).div(100);				 //consider the ratio on restricted wallet
333 			calcMoney=allMoney-restMoney;												 	//and on multisig wallet
334 			restrictedMoney=restrictedMoney.add(restMoney);					 // increase restrictedMoney
335 			multisigMoney=multisigMoney.add(calcMoney);							 // increase multisigMoney
336         	userBalances[msg.sender] = userBalances[msg.sender].add(allMoney); 	 //make a mark in the receipt book in case of return
337 		}
338 		
339 
340 		if(accessTokens > 0){
341 			balanceOf[msg.sender]=balanceOf[msg.sender].add(accessTokens);
342 			balanceOf[this]= balanceOf[this].sub(accessTokens);
343 			PayToken=PayToken.add(accessTokens);
344 			emit Transfer(this, msg.sender, accessTokens);
345 		}
346 
347 		if(returnedMoney>0) msg.sender.transfer(returnedMoney);								 		//and we return
348 		
349     }
350     
351  
352     
353     
354 }
355 
356 contract StoneToken is Crowdsale {	
357     
358     string  public standard    = 'Stone Token';
359     string  public name        = 'StoneToken';
360     string  public symbol      = "STTN";
361     uint8   public decimals    = 0;
362 
363     function StoneToken() public payable Crowdsale() {}
364     
365     function transfer(address _to, uint256 _value) public returns (bool) {
366 		require(balanceOf[msg.sender] >= _value);
367 		balanceOf[msg.sender] -= _value;
368 		balanceOf[_to] += _value;
369 		emit Transfer(msg.sender, _to, _value);
370 		return true;
371     }
372     
373 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
374 		if(_value > balanceOf[_from]) return false;
375 		if(_value > allowed[_from][msg.sender]) return false;
376 		balanceOf[_from] = balanceOf[_from].sub(_value);
377 		balanceOf[_to] = balanceOf[_to].add(_value);
378 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
379 		emit Transfer(_from, _to, _value);
380 		return true;
381 	}       
382 }
383 
384 contract CrowdsaleStoneToken is StoneToken {
385 
386     function CrowdsaleStoneToken() public payable StoneToken() {}
387    
388 }
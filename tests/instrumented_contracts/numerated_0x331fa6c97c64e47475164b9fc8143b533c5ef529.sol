1 pragma solidity 0.5.12 <0.6.0;  
2 
3 // -------------------------------------------------------------------------------------------
4 // EXMR FOUNDATION = EXMR FND.
5 // "Public Smart Contract"
6 //
7 // For details, please visit: https://exmrfoundation.org
8 // Staking Reward:            https://dapp.exmr.io
9 // We handle different projects, we are opening the doors to the entire developer community 
10 // so they can create Dapps and platforms based on our EXMR and get rewards for it...
11 // -------------------------------------------------------------------------------------------
12 
13 
14 contract ownerShip    
15 {
16     
17     address payable public owner;
18 
19     address payable public newOwner;
20 
21     bool public safeGuard ; 
22 
23     
24     event OwnershipTransferredEv(address payable indexed previousOwner, address payable indexed newOwner);
25 
26     constructor() public 
27     {
28         
29         owner = msg.sender;
30         
31         safeGuard = false;
32 
33     }
34     
35     
36     modifier onlyOwner() 
37     {
38         require(msg.sender == owner);
39         _;
40     }
41 
42 
43     function transferOwnership(address payable _newOwner) public onlyOwner 
44     {
45         newOwner = _newOwner;
46     }
47 
48 
49     function acceptOwnership() public 
50     {
51         require(msg.sender == newOwner);
52         emit OwnershipTransferredEv(owner, newOwner);
53         owner = newOwner;
54         newOwner = address(0);
55     }
56 
57     function changesafeGuardStatus() onlyOwner public
58     {
59         if (safeGuard == false)
60         {
61             safeGuard = true;
62         }
63         else
64         {
65             safeGuard = false;    
66         }
67     }
68 
69 }
70 
71 library SafeMath {
72    
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76 
77         return c;
78     }
79 
80    
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a, "SafeMath: subtraction overflow");
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101    
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103        
104         require(b > 0, "SafeMath: division by zero");
105         uint256 c = a / b;
106         
107 
108         return c;
109     }
110 
111     
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b != 0, "SafeMath: modulo by zero");
114         return a % b;
115     }
116 }
117 
118 contract tokenERC20 is  ownerShip
119 {
120     
121     using SafeMath for uint256;
122     bytes23 public name;
123     bytes8 public symbol;
124     uint8 public decimals; 
125     uint256 public totalSupply;
126     uint256 public totalMintAfterInitial;
127     uint256 public maximumSupply;
128 
129     uint public burningRate = 500;    // 500=5%
130 
131     
132     struct userBalance 
133     {
134         uint256 totalValue;
135         uint256 freezeValue;
136         uint256 freezeDate;
137         uint256 meltValue;    
138     }
139 
140     
141     mapping (address => mapping (address => userBalance)) public tokens;
142 
143     mapping (address => uint256) public balanceOf;
144     mapping (address => mapping (address => uint256)) public allowance;
145     
146    
147     mapping (address => bool) public frozenAccount;
148         
149     
150     event FrozenFunds(address target, bool frozen);
151     
152     
153     event Transfer(address indexed from, address indexed to, uint256 value);
154   
155     
156     event Burn(address indexed from, uint256 value);
157 
158      
159     function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) 
160     {
161         uint256 factor = 10000;
162         require(percentTo <= factor);
163         uint256 c = PercentOf.mul(percentTo).div(factor);
164         return c;
165     }   
166 
167     function setBurningRate(uint _burningRate) onlyOwner public returns(bool success)
168     {
169         burningRate = _burningRate;
170         return true;
171     }
172 
173    
174     struct tokenTypeData
175     {
176         bytes23 tokenName;
177         bytes8 tokenSymbol;
178         uint decimalCount;
179         uint minFreezingValue;
180         uint rateFactor;      
181         uint perDayFreezeRate;   
182         bool freezingAllowed;   
183     }
184     
185     mapping (address => tokenTypeData) public tokenTypeDatas;
186 
187     constructor () public {
188     	decimals = 18; 
189         totalSupply = 18000000000000000000000000;       
190         maximumSupply = 75000000000000000000000000;
191         balanceOf[msg.sender]=totalSupply;       
192         tokens[address(this)][owner].totalValue = balanceOf[msg.sender];
193         name = "EXMR FDN.";                           
194         symbol = "EXMR";                       
195 
196        
197         tokenTypeData memory temp;
198 
199         temp.tokenName=name;
200         temp.tokenSymbol=symbol;
201         temp.decimalCount=decimals;
202         temp.minFreezingValue=100;
203         temp.rateFactor=10000;     
204         temp.perDayFreezeRate=1;   
205         temp.freezingAllowed=true;  
206         tokenTypeDatas[address(this)] = temp;
207         emit Transfer(address(0), msg.sender, totalSupply);
208     }
209     
210          
211         function _transfer(address _from, address _to, uint _value) internal {
212             require(!safeGuard,"safeGuard Active");
213 			require (_to != address(0),"to is address 0");                               
214 			require (balanceOf[_from] >= _value, "no balance in from");               
215 			require (balanceOf[_to].add(_value) >= balanceOf[_to],"overflow balance"); 
216 			require(!frozenAccount[_from],"from account frozen");                     
217 			require(!frozenAccount[_to],"to account frozen");                       
218 			balanceOf[_from] = balanceOf[_from].sub(_value);    
219             tokens[address(this)][_from].totalValue = tokens[address(this)][_from].totalValue.sub(_value); 
220 			balanceOf[_to] = balanceOf[_to].add(_value);        
221             tokens[address(this)][_to].totalValue = tokens[address(this)][_to].totalValue.add(_value);            
222             uint burnValue;
223             if(!(msg.sender == owner || msg.sender == address(this)))   
224             {
225                 burnValue = calculatePercentage(_value,burningRate); 
226                 require(burnInternal(_to, burnValue),"burning failed");   
227             }
228 			emit Transfer(_from, _to,_value);
229             
230         } 
231 
232         function burnInternal(address _burnFrom, uint _burnValue) internal returns(bool success)
233         {   
234             require(!safeGuard,"safeGuard Active");
235             require(_burnFrom != address(0));
236             require(balanceOf[_burnFrom] >= _burnValue);   
237 			require(!frozenAccount[_burnFrom],"to account frozen");                       
238 			balanceOf[_burnFrom] = balanceOf[_burnFrom].sub(_burnValue);    
239             tokens[address(this)][_burnFrom].totalValue = tokens[address(this)][_burnFrom].totalValue.sub(_burnValue); 
240 			balanceOf[address(0)] = balanceOf[address(0)].add(_burnValue);        
241             tokens[address(this)][address(0)].totalValue = tokens[address(this)][address(0)].totalValue.add(_burnValue);            
242             totalSupply = totalSupply.sub(_burnValue);            
243 			emit Transfer(_burnFrom, address(0),_burnValue);                         
244             return true;            
245         }
246 
247 		function mintInternal(uint256 mintedAmount)  internal returns (bool success) {                         
248 			totalSupply = totalSupply.add(mintedAmount);
249             totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
250             return true;
251 		}
252 
253     function transfer(address _to, uint256 _value) public returns (bool success) {
254          _transfer(msg.sender, _to, _value);
255         return true;
256     }
257     
258     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
259         require(!safeGuard);
260         require(_from != address(0),"transfer from adderss(0) is invalid");
261         require(_value <= allowance[_from][msg.sender]);     // Check allowance
262         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
263         _transfer(_from, _to, _value);
264         return true;
265     }
266     
267         
268     function approve(address _spender, uint256 _value) public
269         returns (bool success) {
270         require(!safeGuard);
271         allowance[msg.sender][_spender] = _value;
272         return true;
273     }
274 		
275 		function mintToken(address target, uint256 mintedAmount)  public onlyOwner returns (bool success) {
276 			balanceOf[target] = balanceOf[target].add(mintedAmount);
277             tokens[address(this)][target].totalValue = tokens[address(this)][target].totalValue.add(mintedAmount); //parallel record for multi token addressing need                         
278 			totalSupply = totalSupply.add(mintedAmount);
279             totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
280 		 	emit Transfer(address(0), address(this), mintedAmount);
281             return true;
282 		}
283 		
284     function burn(uint256 _value) public onlyOwner returns (bool success) {
285         burnInternal(msg.sender, _value);
286         return true;
287     }
288     
289         
290     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
291         burnInternal(_from, _value);
292         return true;
293     }
294         
295 }
296 
297 
298 interface ERC20Necessary {
299   function transfer(address to, uint256 value) external returns (bool);
300 
301   function approve(address spender, uint256 value) external returns (bool);
302 
303   function transferFrom(address from, address to, uint256 value) external returns (bool);
304 
305   function totalSupply() external view returns (uint256);
306 
307   function balanceOf(address who) external view returns (uint256);
308 
309   function allowance(address owner, address spender) external view returns (uint256);
310 
311   event Transfer(address indexed from, address indexed to, uint256 value);
312 
313   event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 
316 contract EXMR_FDN is tokenERC20
317 {
318 
319     using SafeMath for uint256;
320     
321     	
322         bool public whitelistingStatus = false;
323         mapping (address => bool) public whitelisted;
324 
325         
326         function changeWhitelistingStatus() onlyOwner public{
327             if (whitelistingStatus == false){
328 			    whitelistingStatus = true;
329                 whitelisted[owner]= true;
330             }
331             else{
332                 whitelistingStatus = false;    
333             }
334 		}
335 		
336 		
337         function whitelistUser(address userAddress) onlyOwner public{
338             require(whitelistingStatus == true);
339             require(userAddress != address(0));
340             whitelisted[userAddress] = true;
341 		}    
342 		
343 
344 
345 		function freezeAccount(address target, bool freeze) onlyOwner public {
346 				frozenAccount[target] = freeze;
347 			emit  FrozenFunds(target, freeze);
348 		}
349         
350 
351         function manualWithdrawToken(uint256 _amount) onlyOwner public {
352       		uint256 tokenAmount = _amount.mul(100);
353             _transfer(address(this), msg.sender, tokenAmount);
354         }
355           
356         
357         function manualWithdrawEther()onlyOwner public{
358 			uint256 amount=address(this).balance;
359 			owner.transfer(amount);
360 		}
361 	    //Bounty
362         function Bounty(address[] memory recipients,uint[] memory tokenAmount) public onlyOwner returns (bool) {
363             uint reciversLength  = recipients.length;
364             require(reciversLength <= 150);
365             for(uint i = 0; i < reciversLength; i++)
366             {
367                   //This will loop through all the recipients and send them the specified tokens
368                   _transfer(owner, recipients[i], tokenAmount[i]);
369             }
370             return true;
371         }
372     
373 
374     uint public meltHoldSeconds = 172800;  // 48 Hr. user can withdraw only after this period
375 
376 
377     event tokenDepositEv(address token, address user, uint amount, uint balance);
378     event tokenWithdrawEv(address token, address user, uint amount, uint balance);
379 
380     function setWithdrawWaitingPeriod(uint valueInSeconds) onlyOwner public returns (bool)
381     {
382         meltHoldSeconds = valueInSeconds;
383         return true;
384     }
385 
386     function newTokenTypeData(address token,bytes23 _tokenName, bytes8 _tokenSymbol, uint _decimalCount, uint _minFreezingValue, uint _rateFactor, uint _perDayFreezeRate) onlyOwner public returns (bool)
387     {
388         tokenTypeData memory temp;
389 
390         temp.tokenName=_tokenName;
391         temp.tokenSymbol=_tokenSymbol;
392         temp.decimalCount=_decimalCount;
393         temp.minFreezingValue=_minFreezingValue;
394         temp.rateFactor=_rateFactor;      
395         temp.perDayFreezeRate=_perDayFreezeRate;   
396         temp.freezingAllowed=true;  
397         tokenTypeDatas[token] = temp;
398         return true;
399     }
400 
401     function freezingOnOffForTokenType(address token) onlyOwner public returns (bool)
402     {
403         if (tokenTypeDatas[token].freezingAllowed == false)
404         {
405             tokenTypeDatas[token].freezingAllowed = true;
406         }
407         else
408         {
409             tokenTypeDatas[token].freezingAllowed = false;    
410         } 
411         return true;     
412     }
413 
414     function setMinFreezingValue(address token, uint _minFreezingValue) onlyOwner public returns (bool)
415     {
416         tokenTypeDatas[token].minFreezingValue = _minFreezingValue;
417         return true;
418     }
419 
420     function setRateFactor(address token, uint _rateFactor) onlyOwner public returns (bool)
421     {
422         tokenTypeDatas[token].rateFactor = _rateFactor;
423         return true;
424     }
425 
426     function setPerDayFreezeRate(address token, uint _perDayFreezeRate) onlyOwner public returns (bool)
427     {
428         tokenTypeDatas[token].perDayFreezeRate = _perDayFreezeRate;
429         return true;
430     }
431 
432    
433     function tokenDeposit(address token, uint amount) public 
434     {
435         
436         require(token!=address(0),"Address(0) found, can't continue");
437         require(ERC20Necessary(token).transferFrom(msg.sender, address(this), amount),"ERC20 'transferFrom' call failed");
438         tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.add(amount);
439         emit tokenDepositEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
440     }
441 
442     
443     function tokenWithdraw(address token, uint amount) public
444     {
445         require(!safeGuard,"System Paused By Admin");
446         require(token != address(this));
447         require(token!=address(0),"Address(0) found, can't continue");
448         if(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate)
449         {
450            tokens[token][msg.sender].meltValue = 0; 
451         }
452         require(tokens[token][msg.sender].totalValue.sub(tokens[token][msg.sender].freezeValue.add(tokens[token][msg.sender].meltValue)) >= amount,"Required amount is not free to withdraw");       
453         tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.sub(amount);
454         ERC20Necessary(token).transfer(msg.sender, amount);
455         emit tokenWithdrawEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
456     }
457 
458     event releaseMyExmrEv(address token, uint amount);
459     //releasing after minumum waiting period to withdraw EXMR 
460     function releaseMyExmr(address token) public returns (bool)
461     {
462         require(!safeGuard,"System Paused By Admin");
463         require(token!=address(0),"Address(0) found, can't continue");
464         require(token == address(this),"Only pissible for EXMR ");
465         require(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate,"wait period is not over");
466         uint amount = tokens[token][msg.sender].meltValue;
467         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
468         tokens[token][msg.sender].totalValue = balanceOf[msg.sender].add(tokens[token][msg.sender].freezeValue );
469         tokens[token][msg.sender].meltValue = 0; 
470         emit releaseMyExmrEv(token, amount);
471         return true;
472     }
473 
474     event tokenBalanceFreezeEv(address token, uint amount, uint earning);
475 
476 
477     function tokenBalanceFreeze(address token, uint amount)   public returns (bool)
478     {
479         require(!safeGuard,"System Paused By Admin");
480         require(tokenTypeDatas[token].freezingAllowed,"token type not allowed to freeze");
481         require(token!=address(0),"Address(0) found, can't continue");
482         address callingUser = msg.sender;
483         require(msg.sender != address(0),"Address(0) found, can't continue");
484 
485         require(amount <=  tokens[token][callingUser].totalValue.sub(tokens[token][callingUser].freezeValue.add(tokens[token][callingUser].meltValue)) && amount >= tokenTypeDatas[token].minFreezingValue, "less than required or less balance");
486         
487         uint freezeValue = tokens[token][callingUser].freezeValue;
488         uint earnedValue;
489         if (freezeValue > 0)
490         {
491             earnedValue = getEarning(token,callingUser,freezeValue);
492             require(mintInternal(earnedValue),"minting failed");
493             tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);
494         }
495 
496         tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.add(amount);
497         if (token==address(this))
498         {
499             balanceOf[callingUser] = balanceOf[callingUser].sub(amount);
500         }
501         tokens[token][callingUser].freezeDate = now;
502 
503         emit tokenBalanceFreezeEv(token,amount,earnedValue);
504         return true;
505     }
506 
507     function getEarning(address token,address user,uint amount) internal view returns(uint256)
508     {
509         uint effectiveAmount = calculatePercentage(amount,tokenTypeDatas[token].rateFactor);
510         uint interestAmount = calculatePercentage(effectiveAmount,tokenTypeDatas[token].perDayFreezeRate);
511         uint secondsPassed = (now - tokens[token][user].freezeDate);
512         uint daysPassed=0;
513         if (secondsPassed >= 86400)  // if less than one day earning will be zero
514         {
515            daysPassed = secondsPassed.div(86400); 
516         }
517         return daysPassed.mul(interestAmount);
518     }
519 
520 
521     event tokenBalanceMeltEv(address token, uint amount, uint earning);
522 
523 
524     function tokenBalanceMelt(address token, uint amount)   public returns (bool)
525     {
526         require(!safeGuard,"System Paused By Admin");
527         require(token!=address(0),"Address(0) found, can't continue");
528         address callingUser = msg.sender;
529         require(msg.sender != address(0),"Address(0) found, can't continue");
530         require(amount <=  tokens[token][callingUser].freezeValue && amount > 0, "less than required or less balance");
531         
532         uint freezeValue = tokens[token][callingUser].freezeValue;
533         uint earnedValue = getEarning(token,callingUser,freezeValue);
534         require(mintInternal(earnedValue),"minting failed");
535         tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);       
536         
537         tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.sub(amount);
538         if (token==address(this))
539         {
540             tokens[token][callingUser].meltValue = tokens[token][callingUser].meltValue.add(amount);
541         }
542 
543         tokens[token][callingUser].freezeDate = now;
544         emit tokenBalanceMeltEv(token,amount,earnedValue);
545         return true;
546     }
547 
548     function viewMyReward(address token) public view returns(uint freezedValue, uint rewardValue)
549     {
550         address callingUser = msg.sender;
551         uint freezeValue = tokens[token][callingUser].freezeValue;
552         uint earnedValue = getEarning(token,callingUser,freezeValue);
553         return (freezeValue,earnedValue);
554     }
555 
556 }
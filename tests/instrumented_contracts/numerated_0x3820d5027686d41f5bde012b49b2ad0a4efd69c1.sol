1 pragma solidity ^0.4.16;
2 contract moduleTokenInterface{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11     
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed a_owner, address indexed _spender, uint256 _value);
14     event OwnerChang(address indexed _old,address indexed _new,uint256 _coin_change);
15 	event adminUsrChange(address usrAddr,address changeBy,bool isAdded);
16 	event onAdminTransfer(address to,uint256 value);
17 }
18 
19 contract moduleToken is moduleTokenInterface {
20     
21     struct transferPlanInfo{
22         uint256 transferValidValue;
23         bool isInfoValid;
24     }
25     
26     struct ethPlanInfo{
27 	    uint256 ethNum;
28 	    uint256 coinNum;
29 	    bool isValid;
30 	}
31 	
32 	//管理员之一发起一个转账操作，需要多人批准时采用这个数据结构
33 	struct transferEthAgreement{
34 		//要哪些人签署
35 	    mapping(address=>bool) signUsrList;		
36 		
37 		//已经签署的人数
38 		uint32 signedUsrCount;
39 		
40 		//要求转出的eth数量
41 	    uint256 transferEthInWei;
42 		
43 		//转往哪里
44 		address to;
45 		
46 		//当前转账要求的发起人
47 		address infoOwner;
48 		
49 		//当前记录是否有效(必须123456789)
50 	    uint32 magic;
51 	    
52 	    //是否生效了
53 	    bool isValid;
54 	}
55 	
56 	
57 
58     string public name;                   //名称，例如"My test token"
59     uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
60     string public symbol;               //token简称,like MTT
61     address public owner;
62     
63     mapping (address => uint256) public balances;
64     mapping (address => mapping (address => uint256)) public allowed;
65 	
66 	//是否允许直接接受eth而不返回cot
67 	bool public canRecvEthDirect=false;
68     
69     
70     //以下为本代币协议特殊逻辑所需的相关变
71     //
72     
73     //币的价格，为0时则花钱按价格购买的逻辑不生效   
74 	uint256 public coinPriceInWei;
75 	
76 	//在列表里的人转出代币必须遵守规定的时间、数量限制(比如实现代币定时解冻)
77 	mapping(address=>transferPlanInfo) public transferPlanList;
78 	
79 	//指定的人按指定的以太币数量、代币数量购买代币，不按价格逻辑购买（比如天使轮募资）
80 	//否则按价格相关逻辑处理购买代币的请求
81 	mapping(address => ethPlanInfo) public ethPlanList;
82 	
83 	uint public blockTime=block.timestamp;
84     
85     bool public isTransPaused=true;//为true时禁止转账 
86     
87      //实现多管理员相关的变量  
88     struct adminUsrInfo{
89         bool isValid;
90 	    string userName;
91 		string descInfo;
92     }
93     mapping(address=>adminUsrInfo) public adminOwners; //管理员组
94     bool public isAdminOwnersValid;
95     uint32 public adminUsrCount;//有效的管理员用户数
96     mapping(uint256=>transferEthAgreement) public transferEthAgreementList;
97 
98     function moduleToken(
99         uint256 _initialAmount,
100         uint8 _decimalUnits) public 
101     {
102         owner=msg.sender;//记录合约的owner
103 		if(_initialAmount<=0){
104 		    totalSupply = 100000000000;   // 设置初始总量
105 		    balances[owner]=100000000000;
106 		}else{
107 		    totalSupply = _initialAmount;   // 设置初始总量
108 		    balances[owner]=_initialAmount;
109 		}
110 		if(_decimalUnits<=0){
111 		    decimals=2;
112 		}else{
113 		    decimals = _decimalUnits;
114 		}
115         name = "CareerOn Token"; 
116         symbol = "COT";
117     }
118     
119     function changeContractName(string _newName,string _newSymbol) public {
120         require(msg.sender==owner || adminOwners[msg.sender].isValid);
121         name=_newName;
122         symbol=_newSymbol;
123     }
124     
125     
126     function transfer(
127         address _to, 
128         uint256 _value) public returns (bool success) 
129     {
130         if(isTransPaused){
131             emit Transfer(msg.sender, _to, 0);//触发转币交易事件
132             revert();
133             return;
134         }
135         //默认totalSupply 不会超过最大值 (2^256 - 1).
136         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
137 		if(_to==address(this)){
138 			emit Transfer(msg.sender, _to, 0);//触发转币交易事件
139             revert();
140             return;
141 		}
142 		if(balances[msg.sender] < _value || 
143 			balances[_to] + _value <= balances[_to])
144 		{
145 			emit Transfer(msg.sender, _to, 0);//触发转币交易事件
146             revert();
147             return;
148 		}
149         if(transferPlanList[msg.sender].isInfoValid && transferPlanList[msg.sender].transferValidValue<_value)
150 		{
151 			emit Transfer(msg.sender, _to, 0);//触发转币交易事件
152             revert();
153             return;
154 		}
155         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
156         balances[_to] += _value;//往接收账户增加token数量_value
157         if(transferPlanList[msg.sender].isInfoValid){
158             transferPlanList[msg.sender].transferValidValue -=_value;
159         }
160         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
161         return true;
162     }
163 
164 
165     function transferFrom(
166         address _from, 
167         address _to, 
168         uint256 _value) public returns (bool success) 
169     {
170         if(isTransPaused){
171             emit Transfer(_from, _to, 0);//触发转币交易事件
172             revert();
173             return;
174         }
175 		if(_to==address(this)){
176 			emit Transfer(_from, _to, 0);//触发转币交易事件
177             revert();
178             return;
179 		}
180         if(balances[_from] < _value ||
181 			allowed[_from][msg.sender] < _value)
182 		{
183 			emit Transfer(_from, _to, 0);//触发转币交易事件
184             revert();
185             return;
186 		}
187         if(transferPlanList[_from].isInfoValid && transferPlanList[_from].transferValidValue<_value)
188 		{
189 			emit Transfer(_from, _to, 0);//触发转币交易事件
190             revert();
191             return;
192 		}
193         balances[_to] += _value;//接收账户增加token数量_value
194         balances[_from] -= _value; //支出账户_from减去token数量_value
195         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
196         if(transferPlanList[_from].isInfoValid){
197             transferPlanList[_from].transferValidValue -=_value;
198         }
199         emit Transfer(_from, _to, _value);//触发转币交易事件
200         return true;
201     }
202     
203     function balanceOf(address accountAddr) public constant returns (uint256 balance) {
204         return balances[accountAddr];
205     }
206 
207 
208     function approve(address _spender, uint256 _value) public returns (bool success) 
209     { 
210         require(msg.sender!=_spender && _value>0);
211         allowed[msg.sender][_spender] = _value;
212         emit Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216     function allowance(
217         address _owner, 
218         address _spender) public constant returns (uint256 remaining) 
219     {
220         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
221     }
222 	
223 	//以下为本代币协议的特殊逻辑
224 	
225 	//转移协议所有权并将附带的代币一并转移过去
226 	function changeOwner(address newOwner) public{
227         require(msg.sender==owner && msg.sender!=newOwner);
228         balances[newOwner]=balances[owner];
229         balances[owner]=0;
230         owner=newOwner;
231         emit OwnerChang(msg.sender,newOwner,balances[owner]);//触发合约所有权的转移事件
232     }
233     
234     function setPauseStatus(bool isPaused)public{
235         if(msg.sender!=owner && !adminOwners[msg.sender].isValid){
236             revert();
237             return;
238         }
239         isTransPaused=isPaused;
240     }
241     
242     //设置转账限制，比如冻结什么的
243 	function setTransferPlan(address addr,
244 	                        uint256 allowedMaxValue,
245 	                        bool isValid) public
246 	{
247 	    if(msg.sender!=owner && !adminOwners[msg.sender].isValid){
248 	        revert();
249 	        return ;
250 	    }
251 	    transferPlanList[addr].isInfoValid=isValid;
252 	    if(transferPlanList[addr].isInfoValid){
253 	        transferPlanList[addr].transferValidValue=allowedMaxValue;
254 	    }
255 	}
256     
257     //把本代币协议账户下的eth转到指定账户
258 	function TransferEthToAddr(address _to,uint256 _value)public payable{
259         require(msg.sender==owner && !isAdminOwnersValid);
260         _to.transfer(_value);
261     }
262     
263     function createTransferAgreement(uint256 agreeMentId,
264                                       uint256 transferEthInWei,
265                                       address to) public {
266         require(adminOwners[msg.sender].isValid && 
267         transferEthAgreementList[agreeMentId].magic!=123456789 && 
268         transferEthAgreementList[agreeMentId].magic!=987654321);
269         transferEthAgreementList[agreeMentId].magic=123456789;
270         transferEthAgreementList[agreeMentId].infoOwner=msg.sender;
271         transferEthAgreementList[agreeMentId].transferEthInWei=transferEthInWei;
272         transferEthAgreementList[agreeMentId].to=to;
273         transferEthAgreementList[agreeMentId].isValid=true;
274         transferEthAgreementList[agreeMentId].signUsrList[msg.sender]=true;
275         transferEthAgreementList[agreeMentId].signedUsrCount=1;
276         
277     }
278 	
279 	function disableTransferAgreement(uint256 agreeMentId) public {
280 		require(transferEthAgreementList[agreeMentId].infoOwner==msg.sender &&
281 			    transferEthAgreementList[agreeMentId].magic==123456789);
282 		transferEthAgreementList[agreeMentId].isValid=false;
283 		transferEthAgreementList[agreeMentId].magic=987654321;
284 	}
285 	
286 	function sign(uint256 agreeMentId,address to,uint256 transferEthInWei) public payable{
287 		require(transferEthAgreementList[agreeMentId].magic==123456789 &&
288 		transferEthAgreementList[agreeMentId].isValid &&
289 		transferEthAgreementList[agreeMentId].transferEthInWei==transferEthInWei &&
290 		transferEthAgreementList[agreeMentId].to==to &&
291 		adminOwners[msg.sender].isValid &&
292 		!transferEthAgreementList[agreeMentId].signUsrList[msg.sender]&&
293 		adminUsrCount>=2
294 		);
295 		transferEthAgreementList[agreeMentId].signUsrList[msg.sender]=true;
296 		transferEthAgreementList[agreeMentId].signedUsrCount++;
297 		
298 		if(transferEthAgreementList[agreeMentId].signedUsrCount<=adminUsrCount/2)
299 		{
300 			return;
301 		}
302 		to.transfer(transferEthInWei);
303 		transferEthAgreementList[agreeMentId].isValid=false;
304 		transferEthAgreementList[agreeMentId].magic=987654321;
305 		emit onAdminTransfer(to,transferEthInWei);
306 		return;
307 	}
308 	
309 	struct needToAddAdminInfo{
310 		uint256 magic;
311 		mapping(address=>uint256) postedPeople;
312 		uint32 postedCount;
313 	}
314 	mapping(address=>needToAddAdminInfo) public needToAddAdminInfoList;
315 	function addAdminOwners(address usrAddr,
316 					  string userName,
317 					  string descInfo)public 
318 	{
319 		needToAddAdminInfo memory info;
320 		//不是管理员也不是owner，则禁止任何操作
321 		if(!adminOwners[msg.sender].isValid && owner!=msg.sender){
322 			revert();
323 			return;
324 		}
325 		//任何情况,owner地址不可以被添加到管理员组
326 		if(usrAddr==owner){
327 			revert();
328 			return;
329 		}
330 		//已经在管理员组的不可以被添加
331 		if(adminOwners[usrAddr].isValid){
332 			revert();
333 			return;
334 		}
335 		//不允许添加自己到管理员组
336 		if(usrAddr==msg.sender){
337 			revert();
338 			return;
339 		}
340 		//管理员不到2人时，owner可以至多添加2人到管理员
341 		if(adminUsrCount<2){
342 			if(msg.sender!=owner){
343 				revert();
344 				return;
345 			}
346 			adminOwners[usrAddr].isValid=true;
347 			adminOwners[usrAddr].userName=userName;
348 			adminOwners[usrAddr].descInfo=descInfo;
349 			adminUsrCount++;
350 			if(adminUsrCount>=2) isAdminOwnersValid=true;
351 			emit adminUsrChange(usrAddr,msg.sender,true);
352 			return;
353 		}
354 		//管理员大于等于2人时，owner添加管理员需要得到过半数管理员的同意，而且至少必须是2
355 		if(msg.sender==owner){
356 			//某个用户已经被要求添加到管理员组，owner此时是没有投票权的
357 			if(needToAddAdminInfoList[usrAddr].magic==123456789){
358 				revert();
359 				return;
360 			}
361 			//允许owner把某个人添加到要求进入管理员组的列表里，后续由其它管理员投票
362 			info.magic=123456789;
363 			info.postedCount=0;
364 			needToAddAdminInfoList[usrAddr]=info;
365 			return;
366 			
367 		}//管理员大于等于2人时，owner添加新的管理员，必须过半数管理员同意且至少是2
368 		else if(adminOwners[msg.sender].isValid)
369 		{
370 			//管理员只能投票确认添加管理员，不能直接添加管理员
371 			if(needToAddAdminInfoList[usrAddr].magic!=123456789){
372 				revert();
373 				return;
374 			}
375 			//已经投过票的管理员不允许再投			
376 			if(needToAddAdminInfoList[usrAddr].postedPeople[msg.sender]==123456789){
377 				revert();
378 				return;
379 			}
380 			needToAddAdminInfoList[usrAddr].postedCount++;
381 			needToAddAdminInfoList[usrAddr].postedPeople[msg.sender]=123456789;
382 			if(adminUsrCount>=2 && 
383 			   needToAddAdminInfoList[usrAddr].postedCount>adminUsrCount/2){
384 				adminOwners[usrAddr].userName=userName;
385 				adminOwners[usrAddr].descInfo=descInfo;
386 				adminOwners[usrAddr].isValid=true;
387 				needToAddAdminInfoList[usrAddr]=info;
388 				adminUsrCount++;
389 				emit adminUsrChange(usrAddr,msg.sender,true);
390 				return;
391 			}
392 			
393 		}else{
394 			return revert();//其它情况一律不可以添加管理员
395 		}		
396 	}
397 	struct needDelFromAdminInfo{
398 		uint256 magic;
399 		mapping(address=>uint256) postedPeople;
400 		uint32 postedCount;
401 	}
402 	mapping(address=>needDelFromAdminInfo) public needDelFromAdminInfoList;
403 	function delAdminUsrs(address usrAddr) public {
404 		needDelFromAdminInfo memory info;
405 		//尚不是管理员，无需删除
406 		if(!adminOwners[usrAddr].isValid){
407 			revert();
408 			return;
409 		}
410 		//当前管理员数小于4的话不让再删用户
411 		if(adminUsrCount<4){
412 			revert();
413 			return;
414 		}
415 		//当前管理员数是奇数时不让删用户
416 		if(adminUsrCount%2!=0){
417 			revert();
418 			return;
419 		}
420 		//不允许把自己退出管理员
421 		if(usrAddr==msg.sender){
422 			revert();
423 			return;
424 		}
425 		if(msg.sender==owner){
426 			//owner没有权限确认删除管理员
427 			if(needDelFromAdminInfoList[usrAddr].magic==123456789){
428 				revert();
429 				return;
430 			}
431 			//owner可以提议删除管理员，但是需要管理员过半数同意
432 			info.magic=123456789;
433 			info.postedCount=0;
434 			needDelFromAdminInfoList[usrAddr]=info;
435 			return;
436 		}
437 		//管理员确认删除用户
438 		
439 		//管理员只有权限确认删除
440 		if(needDelFromAdminInfoList[usrAddr].magic!=123456789){
441 			revert();
442 			return;
443 		}
444 		//已经投过票的不允许再投
445 		if(needDelFromAdminInfoList[usrAddr].postedPeople[msg.sender]==123456789){
446 			revert();
447 			return;
448 		}
449 		needDelFromAdminInfoList[usrAddr].postedCount++;
450 		needDelFromAdminInfoList[usrAddr].postedPeople[msg.sender]=123456789;
451 		//同意的人数尚未超过一半则直接返回
452 		if(needDelFromAdminInfoList[usrAddr].postedCount<=adminUsrCount/2){
453 			return;
454 		}
455 		//同意的人数超过一半
456 		adminOwners[usrAddr].isValid=false;
457 		if(adminUsrCount>=1) adminUsrCount--;
458 		if(adminUsrCount<=1) isAdminOwnersValid=false;
459 		needDelFromAdminInfoList[usrAddr]=info;
460 		emit adminUsrChange(usrAddr,msg.sender,false);
461 	}
462 	
463 	//设置指定人按固定eth数、固定代币数购买代币，比如天使轮募资
464 	function setEthPlan(address addr,uint256 _ethNum,uint256 _coinNum,bool _isValid) public {
465 	    require(msg.sender==owner &&
466 	        _ethNum>=0 &&
467 	        _coinNum>=0 &&
468 	        (_ethNum + _coinNum)>0 &&
469 	        _coinNum<=balances[owner]);
470 	    ethPlanList[addr].isValid=_isValid;
471 	    if(ethPlanList[addr].isValid){
472 	        ethPlanList[addr].ethNum=_ethNum;
473 	        ethPlanList[addr].coinNum=_coinNum;
474 	    }
475 	}
476 	
477 	//设置代币价格(Wei)
478 	function setCoinPrice(uint256 newPriceInWei) public returns(uint256 oldPriceInWei){
479 	    require(msg.sender==owner);
480 	    uint256 _old=coinPriceInWei;
481 	    coinPriceInWei=newPriceInWei;
482 	    return _old;
483 	}
484 	
485 	function balanceInWei() public constant returns(uint256 nowBalanceInWei){
486 	    return address(this).balance;
487 	}
488 	
489 	function changeRecvEthStatus(bool _canRecvEthDirect) public{
490 		if(msg.sender!=owner){
491 			revert();
492 			return;
493 		}
494 		canRecvEthDirect=_canRecvEthDirect;
495 	}
496 	
497 	//回退函数
498     //合约账户收到eth时会被调用
499     //任何异常时，这个函数也会被调用
500 	//若有零头不找零，避免被DDOS攻击
501     function () public payable {
502 		if(canRecvEthDirect){
503 			return;
504 		}
505         if(ethPlanList[msg.sender].isValid==true &&
506             msg.value>=ethPlanList[msg.sender].ethNum &&
507             ethPlanList[msg.sender].coinNum>=0 &&
508             ethPlanList[msg.sender].coinNum<=balances[owner]){
509                 ethPlanList[msg.sender].isValid=false;
510                 balances[owner] -= ethPlanList[msg.sender].coinNum;//从消息发送者账户中减去token数量_value
511                 balances[msg.sender] += ethPlanList[msg.sender].coinNum;//往接收账户增加token数量_value
512 		        emit Transfer(this, msg.sender, ethPlanList[msg.sender].coinNum);//触发转币交易事件
513         }else if(!ethPlanList[msg.sender].isValid &&
514             coinPriceInWei>0 &&
515             msg.value/coinPriceInWei<=balances[owner] &&
516             msg.value/coinPriceInWei+balances[msg.sender]>balances[msg.sender]){
517             uint256 buyCount=msg.value/coinPriceInWei;
518             balances[owner] -=buyCount;
519             balances[msg.sender] +=buyCount;
520             emit Transfer(this, msg.sender, buyCount);//触发转币交易事件
521                
522         }else{
523             revert();
524         }
525     }
526 }
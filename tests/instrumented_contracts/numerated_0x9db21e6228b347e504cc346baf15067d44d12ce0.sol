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
85     bool public isTransPaused=false;//为true时禁止转账 
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
120         require(msg.sender==owner || adminOwners[msg.sender].isValid && tx.origin==msg.sender);
121         name=_newName;
122         symbol=_newSymbol;
123     }
124     
125     
126     function transfer(
127         address _to, 
128         uint256 _value) public returns (bool success) 
129     {
130         require(tx.origin==msg.sender && _to!=msg.sender);
131         if(isTransPaused){
132             revert();
133             return;
134         }
135         //默认totalSupply 不会超过最大值 (2^256 - 1).
136         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
137 		if(_to==address(this)){
138             revert();
139             return;
140 		}
141 		if(balances[msg.sender] < _value || 
142 			balances[_to] + _value <= balances[_to]
143 			)
144 		{
145             revert();
146             return;
147 		}
148         if(transferPlanList[msg.sender].isInfoValid && transferPlanList[msg.sender].transferValidValue<_value)
149 		{
150             revert();
151             return;
152 		}
153         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
154         balances[_to] += _value;//往接收账户增加token数量_value
155         if(transferPlanList[msg.sender].isInfoValid){
156             transferPlanList[msg.sender].transferValidValue -=_value;
157         }
158         if(msg.sender==owner){
159             emit Transfer(address(this), _to, _value);//触发转币交易事件
160         }else{
161             emit Transfer(msg.sender, _to, _value);//触发转币交易事件
162         }
163         return true;
164     }
165 
166 
167     function transferFrom(
168         address _from, 
169         address _to, 
170         uint256 _value) public returns (bool success) 
171     {
172         require(tx.origin==msg.sender && _from!=_to);
173         if(isTransPaused){
174             revert();
175             return;
176         }
177 		if(_to==address(this)){
178             revert();
179             return;
180 		}
181         if(balances[_from] < _value ||
182 			allowed[_from][msg.sender] < _value ||
183 			balances[_to] + _value<balances[_to])
184 		{
185             revert();
186             return;
187 		}
188         if(transferPlanList[_from].isInfoValid && transferPlanList[_from].transferValidValue<_value)
189 		{
190             revert();
191             return;
192 		}
193         balances[_to] += _value;//接收账户增加token数量_value
194         balances[_from] -= _value; //支出账户_from减去token数量_value
195         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
196         if(transferPlanList[_from].isInfoValid){
197             transferPlanList[_from].transferValidValue -=_value;
198         }
199         if(msg.sender==owner){
200             emit Transfer(address(this), _to, _value);//触发转币交易事件
201         }else{
202             emit Transfer(msg.sender, _to, _value);//触发转币交易事件
203         }
204         return true;
205     }
206     
207     function balanceOf(address accountAddr) public constant returns (uint256 balance) {
208         return balances[accountAddr];
209     }
210 
211 
212     function approve(address _spender, uint256 _value) public returns (bool success) 
213     { 
214         require(msg.sender!=_spender && _value>0 && tx.origin==msg.sender);
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true;
218     }
219 
220     function allowance(
221         address _owner, 
222         address _spender) public constant returns (uint256 remaining) 
223     {
224         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
225     }
226 	
227 	//以下为本代币协议的特殊逻辑
228 	
229 	//转移协议所有权并将附带的代币一并转移过去
230 	function changeOwner(address newOwner) public{
231         require(msg.sender==owner && 
232             msg.sender!=newOwner && 
233             tx.origin==msg.sender && 
234             !adminOwners[newOwner].isValid);
235         balances[newOwner]=balances[owner];
236         balances[owner]=0;
237         owner=newOwner;
238         emit OwnerChang(msg.sender,newOwner,balances[owner]);//触发合约所有权的转移事件
239     }
240     
241     function setPauseStatus(bool isPaused)public{
242         require(tx.origin==msg.sender);
243         if(msg.sender!=owner && !adminOwners[msg.sender].isValid){
244             revert();
245             return;
246         }
247         isTransPaused=isPaused;
248     }
249     
250     //设置转账限制，比如冻结什么的
251 	function setTransferPlan(address addr,
252 	                        uint256 allowedMaxValue,
253 	                        bool isValid) public
254 	{
255 	    require(tx.origin==msg.sender);
256 	    if(msg.sender!=owner && !adminOwners[msg.sender].isValid){
257 	        revert();
258 	        return ;
259 	    }
260 	    transferPlanList[addr].isInfoValid=isValid;
261 	    if(transferPlanList[addr].isInfoValid){
262 	        transferPlanList[addr].transferValidValue=allowedMaxValue;
263 	    }
264 	}
265     
266     //把本代币协议账户下的eth转到指定账户
267 	function TransferEthToAddr(address _to,uint256 _value)public payable{
268 	    require(tx.origin==msg.sender);
269         require(msg.sender==owner && !isAdminOwnersValid);
270         _to.transfer(_value);
271     }
272     
273     function createTransferAgreement(uint256 agreeMentId,
274                                       uint256 transferEthInWei,
275                                       address to) public {
276         require(msg.sender==tx.origin);
277         require(adminOwners[msg.sender].isValid && 
278         transferEthAgreementList[agreeMentId].magic!=123456789 && 
279         transferEthAgreementList[agreeMentId].magic!=987654321);
280         transferEthAgreementList[agreeMentId].magic=123456789;
281         transferEthAgreementList[agreeMentId].infoOwner=msg.sender;
282         transferEthAgreementList[agreeMentId].transferEthInWei=transferEthInWei;
283         transferEthAgreementList[agreeMentId].to=to;
284         transferEthAgreementList[agreeMentId].isValid=true;
285         transferEthAgreementList[agreeMentId].signUsrList[msg.sender]=true;
286         transferEthAgreementList[agreeMentId].signedUsrCount=1;
287         
288     }
289 	
290 	function disableTransferAgreement(uint256 agreeMentId) public {
291 	    require(msg.sender==tx.origin);
292 		require(transferEthAgreementList[agreeMentId].infoOwner==msg.sender &&
293 			    transferEthAgreementList[agreeMentId].magic==123456789);
294 		transferEthAgreementList[agreeMentId].isValid=false;
295 		transferEthAgreementList[agreeMentId].magic=987654321;
296 	}
297 	
298 	function sign(uint256 agreeMentId,address to,uint256 transferEthInWei) public payable{
299 	    require(tx.origin==msg.sender);
300 		require(transferEthAgreementList[agreeMentId].magic==123456789 &&
301 		transferEthAgreementList[agreeMentId].isValid &&
302 		transferEthAgreementList[agreeMentId].transferEthInWei==transferEthInWei &&
303 		transferEthAgreementList[agreeMentId].to==to &&
304 		adminOwners[msg.sender].isValid &&
305 		transferEthAgreementList[agreeMentId].signUsrList[msg.sender]!=true &&
306 		adminUsrCount>=2
307 		);
308 		transferEthAgreementList[agreeMentId].signUsrList[msg.sender]=true;
309 		transferEthAgreementList[agreeMentId].signedUsrCount++;
310 		
311 		if(transferEthAgreementList[agreeMentId].signedUsrCount<=adminUsrCount/2)
312 		{
313 			return;
314 		}
315 		to.transfer(transferEthInWei);
316 		transferEthAgreementList[agreeMentId].isValid=false;
317 		transferEthAgreementList[agreeMentId].magic=987654321;
318 		emit onAdminTransfer(to,transferEthInWei);
319 		return;
320 	}
321 	
322 	struct needToAddAdminInfo{
323 		uint256 magic;
324 		mapping(address=>uint256) postedPeople;
325 		uint32 postedCount;
326 	}
327 	mapping(address=>needToAddAdminInfo) public needToAddAdminInfoList;
328 	function addAdminOwners(address usrAddr,
329 					  string userName,
330 					  string descInfo)public 
331 	{
332 		require(msg.sender==tx.origin);
333 		needToAddAdminInfo memory info;
334 		//不是管理员也不是owner，则禁止任何操作
335 		if(!adminOwners[msg.sender].isValid && owner!=msg.sender){
336 			revert();
337 			return;
338 		}
339 		//任何情况,owner地址不可以被添加到管理员组
340 		if(usrAddr==owner){
341 			revert();
342 			return;
343 		}
344 		
345 		//已经在管理员组的不可以被添加
346 		if(adminOwners[usrAddr].isValid){
347 			revert();
348 			return;
349 		}
350 		//不允许添加自己到管理员组
351 		if(usrAddr==msg.sender){
352 			revert();
353 			return;
354 		}
355 		//管理员不到2人时，owner可以至多添加2人到管理员
356 		if(adminUsrCount<2){
357 			if(msg.sender!=owner){
358 				revert();
359 				return;
360 			}
361 			adminOwners[usrAddr].isValid=true;
362 			adminOwners[usrAddr].userName=userName;
363 			adminOwners[usrAddr].descInfo=descInfo;
364 			adminUsrCount++;
365 			if(adminUsrCount>=2) isAdminOwnersValid=true;
366 			emit adminUsrChange(usrAddr,msg.sender,true);
367 			return;
368 		}
369 		//管理员大于等于2人时，owner添加管理员需要得到过半数管理员的同意，而且至少必须是2
370 		if(msg.sender==owner){
371 			//某个用户已经被要求添加到管理员组，owner此时是没有投票权的
372 			if(needToAddAdminInfoList[usrAddr].magic==123456789){
373 				revert();
374 				return;
375 			}
376 			//允许owner把某个人添加到要求进入管理员组的列表里，后续由其它管理员投票
377 			info.magic=123456789;
378 			info.postedCount=0;
379 			needToAddAdminInfoList[usrAddr]=info;
380 			return;
381 			
382 		}//管理员大于等于2人时，owner添加新的管理员，必须过半数管理员同意且至少是2
383 		else if(adminOwners[msg.sender].isValid)
384 		{
385 			//管理员只能投票确认添加管理员，不能直接添加管理员
386 			if(needToAddAdminInfoList[usrAddr].magic!=123456789){
387 				revert();
388 				return;
389 			}
390 			//已经投过票的管理员不允许再投			
391 			if(needToAddAdminInfoList[usrAddr].postedPeople[msg.sender]==123456789){
392 				revert();
393 				return;
394 			}
395 			needToAddAdminInfoList[usrAddr].postedCount++;
396 			needToAddAdminInfoList[usrAddr].postedPeople[msg.sender]=123456789;
397 			if(adminUsrCount>=2 && 
398 			   needToAddAdminInfoList[usrAddr].postedCount>adminUsrCount/2){
399 				adminOwners[usrAddr].userName=userName;
400 				adminOwners[usrAddr].descInfo=descInfo;
401 				adminOwners[usrAddr].isValid=true;
402 				needToAddAdminInfoList[usrAddr]=info;
403 				adminUsrCount++;
404 				emit adminUsrChange(usrAddr,msg.sender,true);
405 				return;
406 			}
407 			
408 		}else{
409 			return revert();//其它情况一律不可以添加管理员
410 		}		
411 	}
412 	struct needDelFromAdminInfo{
413 		uint256 magic;
414 		mapping(address=>uint256) postedPeople;
415 		uint32 postedCount;
416 	}
417 	mapping(address=>needDelFromAdminInfo) public needDelFromAdminInfoList;
418 	function delAdminUsrs(address usrAddr) public {
419 	    require(msg.sender==tx.origin);
420 	    //不是管理员也不是owner，则禁止任何操作
421 		if(!adminOwners[msg.sender].isValid && owner!=msg.sender){
422 			revert();
423 			return;
424 		}
425 		needDelFromAdminInfo memory info;
426 		//尚不是管理员，无需删除
427 		if(!adminOwners[usrAddr].isValid){
428 			revert();
429 			return;
430 		}
431 		//当前管理员数小于4的话不让再删用户
432 		if(adminUsrCount<4){
433 			revert();
434 			return;
435 		}
436 		//当前管理员数是奇数时不让删用户
437 		if(adminUsrCount%2!=0){
438 			revert();
439 			return;
440 		}
441 		//不允许把自己退出管理员
442 		if(usrAddr==msg.sender){
443 			revert();
444 			return;
445 		}
446 		if(msg.sender==owner){
447 			//owner没有权限确认删除管理员
448 			if(needDelFromAdminInfoList[usrAddr].magic==123456789){
449 				revert();
450 				return;
451 			}
452 			//owner可以提议删除管理员，但是需要管理员过半数同意
453 			info.magic=123456789;
454 			info.postedCount=0;
455 			needDelFromAdminInfoList[usrAddr]=info;
456 			return;
457 		}
458 		
459 		//管理员确认删除用户
460 		
461 		//管理员只有权限确认删除
462 		if(needDelFromAdminInfoList[usrAddr].magic!=123456789){
463 			revert();
464 			return;
465 		}
466 		//已经投过票的不允许再投
467 		if(needDelFromAdminInfoList[usrAddr].postedPeople[msg.sender]==123456789){
468 			revert();
469 			return;
470 		}
471 		needDelFromAdminInfoList[usrAddr].postedCount++;
472 		needDelFromAdminInfoList[usrAddr].postedPeople[msg.sender]=123456789;
473 		//同意的人数尚未超过一半则直接返回
474 		if(needDelFromAdminInfoList[usrAddr].postedCount<=adminUsrCount/2){
475 			return;
476 		}
477 		//同意的人数超过一半
478 		adminOwners[usrAddr].isValid=false;
479 		if(adminUsrCount>=1) adminUsrCount--;
480 		if(adminUsrCount<=1) isAdminOwnersValid=false;
481 		needDelFromAdminInfoList[usrAddr]=info;
482 		emit adminUsrChange(usrAddr,msg.sender,false);
483 	}
484 	
485 	//设置指定人按固定eth数、固定代币数购买代币，比如天使轮募资
486 	function setEthPlan(address addr,uint256 _ethNum,uint256 _coinNum,bool _isValid) public {
487 	    require(msg.sender==owner &&
488 	        _ethNum>=0 &&
489 	        _coinNum>=0 &&
490 	        (_ethNum + _coinNum)>0 &&
491 	        _coinNum<=balances[owner]);
492 	    ethPlanList[addr].isValid=_isValid;
493 	    if(ethPlanList[addr].isValid){
494 	        ethPlanList[addr].ethNum=_ethNum;
495 	        ethPlanList[addr].coinNum=_coinNum;
496 	    }
497 	}
498 	
499 	//设置代币价格(Wei)
500 	function setCoinPrice(uint256 newPriceInWei) public returns(uint256 oldPriceInWei){
501 	    require(tx.origin==msg.sender);
502 	    require(msg.sender==owner);
503 	    uint256 _old=coinPriceInWei;
504 	    coinPriceInWei=newPriceInWei;
505 	    return _old;
506 	}
507 	
508 	function balanceInWei() public constant returns(uint256 nowBalanceInWei){
509 	    return address(this).balance;
510 	}
511 	
512 	function changeRecvEthStatus(bool _canRecvEthDirect) public{
513 	    require(tx.origin==msg.sender);
514 		if(msg.sender!=owner){
515 			revert();
516 			return;
517 		}
518 		canRecvEthDirect=_canRecvEthDirect;
519 	}	
520 	//
521 	
522 	//回退函数
523     //合约账户收到eth时会被调用
524     //任何异常时，这个函数也会被调用
525 	//若有零头不找零，避免被DDOS攻击
526     function () public payable {
527         if(ethPlanList[msg.sender].isValid==true &&
528             msg.value>=ethPlanList[msg.sender].ethNum &&
529             ethPlanList[msg.sender].coinNum>=0 &&
530             ethPlanList[msg.sender].coinNum<=balances[owner] &&
531             balances[msg.sender] +ethPlanList[msg.sender].coinNum>balances[msg.sender]
532             ){
533                 ethPlanList[msg.sender].isValid=false;
534                 balances[owner] -= ethPlanList[msg.sender].coinNum;//从消息发送者账户中减去token数量_value
535                 balances[msg.sender] += ethPlanList[msg.sender].coinNum;//往接收账户增加token数量_value
536 		        emit Transfer(this, msg.sender, ethPlanList[msg.sender].coinNum);//触发转币交易事件
537         }else if(!ethPlanList[msg.sender].isValid &&
538             coinPriceInWei>0 &&
539             msg.value/coinPriceInWei<=balances[owner] &&
540             msg.value/coinPriceInWei+balances[msg.sender]>balances[msg.sender]){
541             uint256 buyCount=msg.value/coinPriceInWei;
542             balances[owner] -=buyCount;
543             balances[msg.sender] +=buyCount;
544             emit Transfer(this, msg.sender, buyCount);//触发转币交易事件
545                
546         }else{
547             if(canRecvEthDirect){
548 			    return;
549 		    }
550             revert();
551         }
552     }
553 }
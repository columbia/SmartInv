1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract BWS_GAME {
4     address payable constant Operate_Team=0x7d0E7BaEBb4010c839F3E0f36373e7941792AdEa;
5     address payable constant Technical_Team=0xd8D8dEf8B1584a2B35c6243d2CC04d851e534E37;
6     uint8 is_frozen;
7     string public standard = 'http://leeks.cc';
8     string public name="Bretton Woods system-2.0"; 
9     string public symbol="BWS"; 
10     uint8 public decimals = 12;  
11     uint256 public totalSupply=100000000 szabo; 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value); 
15     event Burn(address indexed from, uint256 value); 
16     
17     uint256 public st_outer_disc;
18     uint256 public st_pool_bws;
19     uint256 public st_pool_eth;
20     uint256 public st_pool_a_bonus;
21 
22     uint256 public st_core_value=0.0001 ether;
23     uint256 public st_trading_volume;
24     uint256 public st_in_circulation;
25     bool private st_frozen=false;
26     struct USER_MESSAGE
27         {
28             address payable addr;
29             uint32 ID;
30             uint32 faNode;
31             uint32 brNode;
32             uint32 chNode;
33             uint32 Subordinate;
34             uint256 Income;
35             uint256 A_bonus;
36             uint256 BWS;
37             uint256 MaxBWS;
38             uint64 LastSellTime;
39             uint256 ThisDaySellBWS;
40             uint64 LastOutToInTime;
41             uint256 ThisDayOutToInBWS;
42             uint256 ETH;
43         }
44 
45     mapping (uint32 => address) st_user_id;
46     mapping (address => USER_MESSAGE) st_user_ad;
47     
48     mapping (address => bool) st_black_list;
49  
50     uint32 public st_user_index;
51 
52     event ev_luck4(address ad1,address ad2,address ad3,address ad4,uint8 luck,uint8 flags,uint256 pool_bws,uint256 a_bonus);
53 
54     event ev_luck1000(address luck_ad,uint32 luck_id,uint8 flags,uint256 pool_bws,uint256 a_bonus);
55 
56     event ev_buy_bws(address buy_ad,uint256 bws,uint256 pool_bws,uint256 a_bonus,uint256 pool_eth);
57  
58     event ev_sell_bws(address sell_ad,uint256 bws,uint256 pool_bws,uint256 pool_eth);
59 
60     event ev_inside_to_outside(address ad,uint256 bws,uint256 in_circulation);
61 
62     event ev_outside_to_inside(address ad,uint256 bws,uint256 in_circulation);
63 
64     event ev_game_give_bws(address ad,uint32 luck_id,uint8 flags,uint256 bws,uint256 pool_bws,uint256 in_circulation);
65 
66     event ev_register(address ad,uint32 Recommender);
67 
68     event ev_buy_of_first_send(address ad,uint256 bws,uint256 unit_price);
69 
70     event ev_a_bonus(uint64 ThisTime,uint256 trading_volume,uint256 bonus,uint256 a_bonus);
71 
72     event ev_eth_to_outside(address ad,uint256 eth);
73 
74     event ev_recharge(address ad,uint256 eth);
75 
76     constructor  () public payable
77     {
78         st_user_index=0;
79         
80         st_user_id[0]=msg.sender;
81         //st_user_ad[msg.sender]=USER_MESSAGE(msg.sender,0,0,0,1,1,0,0,0,0,0,0,0,0,0);
82         st_user_ad[msg.sender].addr=msg.sender;
83         st_user_ad[msg.sender].chNode=1;
84         st_user_ad[msg.sender].Subordinate=1;
85         
86         st_user_id[1]=Operate_Team;
87         //st_user_ad[Operate_Team]=USER_MESSAGE(address(uint160(Operate_Team)),1,0,0,0,0,0,0,0,0,0,0,0,0,0);
88         st_user_ad[Operate_Team].addr=Operate_Team;
89         st_user_ad[Operate_Team].ID=1;
90         
91         st_user_index=1;
92         
93         st_pool_bws = 60000000 szabo;
94         st_user_ad[msg.sender].BWS=5000000 szabo;
95         st_user_ad[Operate_Team].BWS=5000000 szabo;
96         st_outer_disc=20000000 szabo;
97         balanceOf[msg.sender]=10000 szabo;
98         balanceOf[Operate_Team]=9990000 szabo;
99         
100         st_random=uint160(msg.sender);
101         //内测数据迁移
102 
103         st_core_value= 271446900000000;
104         st_pool_a_bonus=70870859883000000;
105         st_pool_bws=59982851522121212122; 
106         st_pool_eth=msg.value-396472651224613000-st_pool_a_bonus;
107         st_trading_volume=17594074590000000;
108         st_in_circulation=17338694590000000;
109         st_frozen=true;//冻结整个系统，直到内测数据迁移完毕解冻，同时冻结数据迁移接口
110     }
111     
112     uint8 stop_count=2;
113     function move_data(address addr,
114                        uint32 faNode,
115                        uint32 Subordinate,
116                        uint256 A_bonus,
117                        uint256 BWS,
118                        uint256 ETH
119                        ) public
120                      //首期内测数据迁移，之后永久关闭本接口
121     {require(stop_count<=15);
122      st_user_id[stop_count]=addr;
123      st_user_ad[addr]=USER_MESSAGE(address(uint160(addr)),
124                                     stop_count,
125                                     faNode,
126                                     0,
127                                     0,
128                                     Subordinate,
129                                     0,
130                                     A_bonus,
131                                     BWS,
132                                     BWS,
133                                     0,0,0,0,
134                                     ETH
135                                     );       
136             
137     if(stop_count ==15)
138     {
139         //解冻整个系统，同时本数据迁移接口冻结
140         st_frozen=false;
141         st_user_index = 15;
142     }
143      stop_count++;       
144     }
145     function Recharge(uint32 Recommender) public payable
146     {
147         
148         require(!st_frozen,"The system has been frozen");
149         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
150         register(Recommender);
151         //require(st_user_ad[msg.sender].addr !=address(0),"You haven't registered yet.");
152         
153         st_user_ad[msg.sender].ETH=safe_add(st_user_ad[msg.sender].ETH,msg.value);
154         emit ev_recharge(msg.sender,msg.value);
155     }
156     
157     function ()external payable 
158     {
159         require(!st_frozen,"The system has been frozen");
160         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
161 
162         uint256 unit_price;
163         if(msg.value>0)
164         {
165             if(st_outer_disc > 17000000 szabo)
166             {
167                 unit_price = 0.0001 ether;
168             }
169             else
170             {
171                 unit_price = st_core_value /5 *4;
172             }
173 
174             uint256 bws=msg.value / (unit_price /1 szabo);
175             if(st_outer_disc >= bws)
176             {
177                 st_outer_disc = safe_sub(st_outer_disc,bws);
178                 balanceOf[msg.sender] = safe_add(balanceOf[msg.sender],bws);
179 
180                 st_user_ad[st_user_id[0]].ETH=safe_add(st_user_ad[st_user_id[0]].ETH,msg.value/2);
181                 st_user_ad[st_user_id[1]].ETH=safe_add(st_user_ad[st_user_id[1]].ETH,msg.value/2);
182 
183                 emit ev_buy_of_first_send(msg.sender,bws,unit_price);
184             }
185             else if(st_outer_disc >0)
186             {
187                 uint256 eth=safe_multiply(unit_price / 1000000000000,st_outer_disc);
188 
189                 st_user_ad[st_user_id[0]].ETH=safe_add(st_user_ad[st_user_id[0]].ETH,eth/2);
190                 st_user_ad[st_user_id[1]].ETH=safe_add(st_user_ad[st_user_id[1]].ETH,eth/2);
191                 
192                 msg.sender.transfer(msg.value-eth);
193                 balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],st_outer_disc);
194                 st_outer_disc=0;
195             }
196             else
197             {
198                 msg.sender.transfer(msg.value);
199             }
200         }
201     }
202 
203 function fpr_Recommender_eth(address my_ad,uint256 eth)internal
204 {
205     uint32 index;
206     index=st_user_ad[my_ad].faNode;
207     uint256 percentile=eth/9;
208     
209     st_user_ad[st_user_id[index]].ETH=safe_add(st_user_ad[st_user_id[index]].ETH,percentile*5);
210     st_user_ad[st_user_id[index]].Income=safe_add(st_user_ad[st_user_id[index]].Income,percentile*5);
211 
212     for(uint32 i=0;i<4;i++)
213     {
214         index = st_user_ad[st_user_id[index]].faNode;
215         st_user_ad[st_user_id[index]].ETH=safe_add(st_user_ad[st_user_id[index]].ETH,percentile);
216         st_user_ad[st_user_id[index]].Income=safe_add(st_user_ad[st_user_id[index]].Income,percentile);
217     }
218 }
219 
220    function fpr_modify_max_bws(address ad)internal
221    {
222        assert(ad != address(0));
223        if(st_user_ad[ad].BWS > st_user_ad[ad].MaxBWS)
224             st_user_ad[ad].MaxBWS=st_user_ad[ad].BWS;
225    }
226 
227    function safe_total_price(uint256 par_bws_count) internal view returns(uint256 ret)
228    {
229        assert(par_bws_count>0);
230        
231         uint256 unit_price=st_core_value/1000000000000;
232         uint256 total_price=unit_price*par_bws_count*105/100;
233         assert(total_price /105*100/par_bws_count == unit_price);
234         return total_price;
235    }
236    function safe_multiply(uint256 a,uint256 b)internal pure returns(uint256)
237    {
238        uint256 m=a*b;
239        assert(m/a==b);
240        return m;
241    }
242    function safe_add(uint256 a,uint256 b) internal pure returns(uint256)
243    {
244        assert(a+b>=a);
245        return a+b;
246    }
247    function safe_sub(uint256 a,uint256 b) internal pure returns(uint256)
248    {
249        assert(b<a);
250        return a-b;
251    }
252     function fp_get_core_value()internal
253     {
254         uint256 ret=0;
255        uint256 num=st_trading_volume;
256        uint256[10] memory trad=[uint256(100000 szabo),1000000 szabo,10000000 szabo,100000000 szabo,1000000000 szabo,10000000000 szabo,100000000000 szabo,1000000000000 szabo,10000000000000 szabo,100000000000000 szabo];
257        uint32[10] memory tra=[uint32(10000),20000,62500,100000,200000,1000000,2000000,10000000,20000000,100000000];
258        uint256 [10] memory t=[uint256(1 szabo),6 szabo,40 szabo,100 szabo,600 szabo,4600 szabo,9600 szabo,49600 szabo,99600 szabo,499960 szabo];
259 
260        for(uint32 i=0 ;i< 10;i++)
261        {
262            if(num < trad[i])
263            {
264                ret=num / tra[i] + t[i];
265                break;
266            }
267        }
268        if (ret==0)
269        {
270            ret=num/200000000 + 1199960 szabo;
271        }
272        ret=safe_multiply(ret,100);
273 
274 		st_core_value=ret;
275     }
276 
277     function register(uint32 par_Recommender)internal
278     {
279         if(st_user_ad[msg.sender].addr != address(0x0)) return;
280         require(!st_frozen,"The system has been frozen");
281         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
282         
283         uint32 index;
284         uint32 Recommender=unEncryption(par_Recommender);
285         require(Recommender>=0 && Recommender<=st_user_index,"Recommenders do not exist");
286         st_user_index+=1;
287 
288         st_user_id[st_user_index]=msg.sender;
289         st_user_ad[msg.sender].addr=msg.sender;
290         st_user_ad[msg.sender].ID=st_user_index;
291         st_user_ad[msg.sender].faNode = Recommender;
292         
293         if(st_user_ad[st_user_id[Recommender]].chNode==0)
294         {
295             st_user_ad[st_user_id[Recommender]].chNode=st_user_index;
296         }
297         else
298         {
299             index=st_user_ad[st_user_id[Recommender]].chNode;
300             while (st_user_ad[st_user_id[index]].brNode>0)
301             {
302                 index=st_user_ad[st_user_id[index]].brNode;
303             }
304             st_user_ad[st_user_id[index]].brNode=st_user_index;
305         }
306         index=Recommender;
307         for(uint32 i=0;i<5;i++)
308         {
309             st_user_ad[st_user_id[index]].Subordinate++;
310             if(index==0) break;
311             index=st_user_ad[st_user_id[index]].faNode;
312         }
313         emit ev_register(msg.sender,par_Recommender); 
314     }
315    
316     function GetMyRecommendNumber(address par_addr)public view returns(uint32 pople_number)
317     {
318         uint32 index;
319         uint32 Number;
320         require(par_addr!=address(0x0));
321         require(st_user_ad[par_addr].addr!=address(0x0),"You haven't registered yet.");
322         
323         index=st_user_ad[par_addr].chNode;
324         if(index>0)
325         {
326             Number=1;
327             while (st_user_ad[st_user_id[index]].brNode>0)
328             {
329                 Number++;
330                 index=st_user_ad[st_user_id[index]].brNode;
331             }
332         }
333     return Number;
334     }
335 
336     ///////////////////////////////////////////////////////////
337     function Encryption(uint32 num) private pure returns(uint32 com_num)
338    {
339        require(num<=8388607,"Maximum ID should not exceed 8388607");
340        uint32 flags;
341        uint32 p=num;
342        uint32 ret;
343        if(num<4)
344         {
345             flags=2;
346         }
347        else
348        {
349           if(num<=15)flags=7;
350           else if(num<=255)flags=6;
351           else if(num<=4095)flags=5;
352           else if(num<=65535)flags=4;
353           else if(num<=1048575)flags=3;
354           else flags=2;
355        }
356        ret=flags<<23;
357        if(flags==2)
358         {
359             p=num; 
360         }
361         else
362         {
363             p=num<<((flags-2)*4-1);
364         }
365         ret=ret | p;
366         return (ret);
367    }
368    function unEncryption(uint32 num)private pure returns(uint32 number)
369    {
370        uint32 p;
371        uint32 flags;
372        flags=num>>23;
373        p=num<<9;
374        if(flags==2)
375        {
376            if(num==16777216)return(0);
377            else if(num==16777217)return(1);
378            else if(num==16777218)return(2);
379            else if(num==16777219)return(3);
380            else 
381             {
382                 require(num>= 25690112 && num<66584576 ,"Illegal parameter, parameter position must be greater than 10 bits");
383                 p=p>>9;
384             }
385        }
386        else 
387        {
388             p=p>>(9+(flags-2)*4-1);
389        }
390      return (p);
391    }
392 
393     function _transfer(address _from, address _to, uint256 _value) internal {
394     require(!st_frozen,"The system has been frozen");
395     require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
396       require(_to != address(0x0));
397       require(balanceOf[_from] >= _value);
398       require(balanceOf[_to] + _value > balanceOf[_to]);
399       uint previousBalances = balanceOf[_from] + balanceOf[_to];
400       balanceOf[_from] -= _value;
401       balanceOf[_to] += _value;
402       emit Transfer(_from, _to, _value);
403       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
404     }
405     
406     function transfer(address _to, uint256 _value) public {
407         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
408         _transfer(msg.sender, _to, _value);
409         fpr_set_random(msg.sender);
410     }
411     
412     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
413 
414         require(!st_frozen,"The system has been frozen");
415         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
416         require(_value <= allowance[_from][msg.sender]); 
417 
418         allowance[_from][msg.sender] -= _value;
419 
420         _transfer(_from, _to, _value);
421         
422         fpr_set_random(msg.sender);
423         
424         return true;
425     }
426     
427     function approve(address _spender, uint256 _value) public returns (bool success) {
428         require(!st_frozen,"The system has been frozen");
429         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
430         allowance[msg.sender][_spender] = _value;
431         fpr_set_random(msg.sender);
432         return true;
433     }
434 
435     function fp_buy_bws(uint32 Recommender,uint256 par_count)public payable
436     {
437         require(!st_frozen,"The system has been frozen");
438         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
439         require(par_count>0 && par_count<=10000 szabo,"Buy up to 10,000 BWS at a time");
440         register(Recommender);
441         require(st_pool_bws>=par_count,"Insufficient pool_BWS");
442         if(msg.value>0)
443             st_user_ad[msg.sender].ETH=safe_add(st_user_ad[msg.sender].ETH,msg.value);
444         uint256 money=safe_total_price(par_count);
445         require(st_user_ad[msg.sender].ETH>=money,"Your ETH is insufficient");
446         st_user_ad[msg.sender].ETH = safe_sub(st_user_ad[msg.sender].ETH,money);
447         st_pool_bws = safe_sub(st_pool_bws, par_count);
448         st_user_ad[msg.sender].BWS = safe_add(st_user_ad[msg.sender].BWS, par_count);
449         fpr_modify_max_bws(msg.sender);
450         
451         uint256 percentile=money/105;
452         st_pool_eth=safe_add(st_pool_eth,percentile*90);
453         st_pool_a_bonus=safe_add(st_pool_a_bonus,percentile*5);
454         fpr_Recommender_eth(msg.sender,percentile*10);
455        
456         st_trading_volume=safe_add(st_trading_volume,par_count);
457 
458         st_in_circulation=safe_add(st_in_circulation,par_count);
459 
460         emit ev_buy_bws(msg.sender,par_count,st_pool_bws,st_pool_a_bonus,st_pool_eth);
461         st_core_value = st_core_value+par_count;
462         fp_get_core_value();
463        fpr_set_random(msg.sender);
464     }
465     function fp_sell_bws(uint32 Recommender,uint256 par_count)public
466     {
467         require(!st_frozen,"The system has been frozen");
468         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
469         register(Recommender);
470         require(st_user_ad[msg.sender].BWS >= par_count,"Your BWS is insufficient");
471         if(now-st_user_ad[msg.sender].LastSellTime > 86400)
472             st_user_ad[msg.sender].ThisDaySellBWS=0;
473         uint256 SellPermit=st_user_ad[msg.sender].MaxBWS/10;
474         require(safe_add(par_count , st_user_ad[msg.sender].ThisDaySellBWS) <= SellPermit,"You didn't sell enough on that day.");
475         
476         uint256 money=safe_total_price(par_count);
477         money=money/105*100;
478   
479         require(st_pool_eth >= money,"The system does not have enough ETH");
480         st_user_ad[msg.sender].BWS = safe_sub(st_user_ad[msg.sender].BWS,par_count);
481         st_user_ad[msg.sender].ETH=safe_add(st_user_ad[msg.sender].ETH,money/100*95);
482         st_pool_eth=safe_sub(st_pool_eth,money);
483         st_pool_bws=safe_add(st_pool_bws,par_count);
484   
485         st_user_ad[msg.sender].LastSellTime=uint64(now);
486         st_user_ad[msg.sender].ThisDaySellBWS=safe_add(st_user_ad[msg.sender].ThisDaySellBWS,par_count);
487 
488         uint256 percentile = money/100;
489 
490         st_pool_a_bonus=safe_add(st_pool_a_bonus,percentile*5);
491         
492         
493             if(st_in_circulation>=par_count)
494                 st_in_circulation-=par_count;
495             else
496                 st_in_circulation=0;
497         
498         st_trading_volume=safe_add(st_trading_volume,par_count);
499         emit ev_sell_bws(msg.sender,par_count,st_pool_bws,st_pool_eth);
500         
501         st_core_value = st_core_value+par_count;
502         fp_get_core_value();
503         fpr_set_random(msg.sender);
504    
505     }
506  
507     function fp_inside_to_outside(uint32 Recommender,uint256 par_bws_count) public
508     {
509         
510         require(!st_frozen,"The system has been frozen");
511         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
512         register(Recommender);
513         require(st_user_ad[msg.sender].BWS >= par_bws_count,"Your BWS is insufficient");
514 
515         st_user_ad[msg.sender].BWS = safe_sub(st_user_ad[msg.sender].BWS,par_bws_count);
516 
517         balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],par_bws_count);
518 
519             if(st_in_circulation>=par_bws_count)
520                 st_in_circulation-=par_bws_count;
521             else
522                 st_in_circulation=0;
523 
524         emit ev_inside_to_outside(msg.sender,par_bws_count,st_in_circulation);
525         fpr_set_random(msg.sender);
526     }
527     function fp_outside_to_inside(uint32 Recommender,uint256 par_bws_count)public
528     {
529         require(!st_frozen,"The system has been frozen");
530         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
531         register(Recommender);
532         require(balanceOf[msg.sender] >= par_bws_count,"Your BWS is insufficient");
533 
534         if(st_user_ad[msg.sender].MaxBWS ==0 )
535         {
536             require(par_bws_count > balanceOf[msg.sender]/10);
537         }
538         else
539         {
540 
541             require(st_pool_bws< 60000000 ether,"Fission funds are inadequate to postpone foreign exchange transfer");
542   
543             uint256 temp=60000000 ether - st_pool_bws;
544             temp=safe_add(temp/7*4,60000000 ether);
545             require(temp>safe_add(st_in_circulation,st_pool_bws));
546             temp=safe_sub(temp,safe_add(st_in_circulation,st_pool_bws));
547             
548             require(temp> par_bws_count,"Inadequate transferable amount" );
549             if(now-st_user_ad[msg.sender].LastOutToInTime >=86400)st_user_ad[msg.sender].ThisDayOutToInBWS=0;
550             require(st_user_ad[msg.sender].MaxBWS/10 >= safe_add(st_user_ad[msg.sender].ThisDayOutToInBWS,par_bws_count),"You have insufficient transfer authority today");
551             }
552         balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],par_bws_count);
553         st_user_ad[msg.sender].BWS=safe_add(st_user_ad[msg.sender].BWS,par_bws_count);
554         fpr_modify_max_bws(msg.sender);
555         st_in_circulation=safe_add(st_in_circulation,par_bws_count);
556         
557         emit ev_outside_to_inside(msg.sender,par_bws_count,st_in_circulation);
558         fpr_set_random(msg.sender);
559     }
560 
561     uint160 private st_random;
562     uint32 private st_add_rnd=0;
563     function fpr_set_random(address ad)internal 
564     {
565         uint256 m_block=uint256(blockhash(block.number));
566         st_random=uint160(ripemd160(abi.encode(st_random,ad,m_block,st_add_rnd++)));
567     }
568 function fpr_get_random(uint32 par_rnd)internal view returns(uint32 rnd)
569 {
570     return uint32(st_random % par_rnd);
571 }
572 
573 function give_bws_to_gamer(address ad,uint256 par_eth)internal returns(uint256 r_bws) 
574 {
575     require(ad!=address(0));
576     require(par_eth > 0);
577     uint256 eth=par_eth/10;
578     uint256 bws=eth/(st_core_value /1 szabo);
579     if(st_pool_bws>=bws)
580     {
581         st_pool_bws=st_pool_bws-bws;
582         st_user_ad[ad].BWS=safe_add(st_user_ad[ad].BWS,bws);
583         fpr_modify_max_bws(ad);
584         st_in_circulation=safe_add(st_in_circulation,bws);
585         return bws;
586     }
587     return 0;
588 }
589    mapping (uint8 => mapping (uint16 => address)) st_luck1000;
590     uint16[5] public st_Luck_count1000=[0,0,0,0,0];
591     
592     function fpu_luck_draw1000(uint32 Recommender,uint8 par_type)public payable
593     {
594         require(!st_frozen,"The system has been frozen");
595         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
596         register(Recommender);
597         require (par_type <5);
598          require(st_user_ad[msg.sender].addr !=address(0),"You haven't registered yet.");
599          
600          uint256[5] memory price=[uint256(0.01 ether),0.05 ether,0.1 ether,0.5 ether,1 ether];
601          
602         if(msg.value>0)
603             st_user_ad[msg.sender].ETH=safe_add(st_user_ad[msg.sender].ETH,msg.value);
604         require(st_user_ad[msg.sender].ETH >= price[par_type],"Your ETH is insufficient");
605         st_user_ad[msg.sender].ETH = st_user_ad[msg.sender].ETH-price[par_type];
606         uint256 value=price[par_type]/10;
607         fpr_Recommender_eth(msg.sender,value);
608         st_pool_a_bonus=safe_add(st_pool_a_bonus,value);
609         fpr_set_random(msg.sender);
610         st_luck1000[par_type][st_Luck_count1000[par_type]]=msg.sender;
611         emit ev_game_give_bws(msg.sender,st_Luck_count1000[par_type],par_type+5,give_bws_to_gamer(msg.sender,price[par_type]),st_pool_bws,st_in_circulation);
612         
613         st_Luck_count1000[par_type]++;
614         if(st_Luck_count1000[par_type] %10 ==0 && st_Luck_count1000[par_type] !=0)
615         {
616             st_user_ad[msg.sender].ETH =safe_add( st_user_ad[msg.sender].ETH,price[par_type]*2);
617             emit ev_luck1000(msg.sender,st_Luck_count1000[par_type]-1,par_type+5,st_pool_bws,st_pool_a_bonus);
618         }
619         if(st_Luck_count1000[par_type]==1000)
620         {
621             st_Luck_count1000[par_type]=0;
622             uint16 rnd=uint16(fpr_get_random(1000));
623             st_user_ad[st_luck1000[par_type][rnd]].ETH += (price[par_type]*600);
624             emit ev_luck1000(st_luck1000[par_type][rnd],st_Luck_count1000[par_type]-1,par_type+10,st_pool_bws,st_pool_a_bonus);
625         }
626        
627     }
628 
629     mapping (uint8 => mapping (uint8 => address)) st_luck4;
630     uint8[5] public st_Luck_count4=[0,0,0,0,0];
631     
632     function fpu_luck_draw4(uint32 Recommender,uint8 par_type)public payable
633     {
634         require(!st_frozen,"The system has been frozen");
635         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
636         register(Recommender);
637         require (par_type <5);
638          require(st_user_ad[msg.sender].addr !=address(0),"You haven't registered yet.");
639          
640          uint256[5] memory price=[uint256(0.01 ether),0.05 ether,0.1 ether,0.5 ether,1 ether];
641          
642         if(msg.value>0)
643             st_user_ad[msg.sender].ETH=safe_add(st_user_ad[msg.sender].ETH,msg.value);
644         require(st_user_ad[msg.sender].ETH > price[par_type],"Your ETH is insufficient");
645         st_user_ad[msg.sender].ETH = st_user_ad[msg.sender].ETH-price[par_type];
646         uint256 value=price[par_type]/10;
647         fpr_Recommender_eth(msg.sender,value);
648         st_pool_a_bonus=safe_add(st_pool_a_bonus,value);
649         fpr_set_random(msg.sender);
650         st_luck4[par_type][st_Luck_count4[par_type]]=msg.sender;
651         emit ev_game_give_bws(msg.sender,st_Luck_count4[par_type],par_type,give_bws_to_gamer(msg.sender,price[par_type]),st_pool_bws,st_in_circulation);
652         
653         st_Luck_count4[par_type]++;
654        
655         if(st_Luck_count4[par_type]==4)
656         {
657             st_Luck_count4[par_type]=0;
658             uint8 rnd=uint8(fpr_get_random(4));
659             st_user_ad[st_luck4[par_type][rnd]].ETH += (value*32);
660             emit ev_luck4(st_luck4[par_type][0],
661                      st_luck4[par_type][1],
662                      st_luck4[par_type][2],
663                      st_luck4[par_type][3],
664                      rnd,
665                      par_type,
666                      st_pool_bws,
667                      st_pool_a_bonus
668                     );
669         }
670     }
671 
672     function fpu_a_bonus()public
673     {
674         require(msg.sender == st_user_ad[st_user_id[0]].addr 
675              || msg.sender == st_user_ad[st_user_id[1]].addr,"Only Administrators Allow Operations");
676         uint256 bonus=st_pool_a_bonus /2;
677         
678         uint256 add_bonus;
679         uint256 curr_bonus;
680         add_bonus=bonus / 5;
681         curr_bonus=bonus / 10;
682         st_user_ad[st_user_id[0]].ETH=safe_add(st_user_ad[st_user_id[0]].ETH,curr_bonus);
683         st_user_ad[st_user_id[0]].A_bonus=safe_add(st_user_ad[st_user_id[0]].A_bonus,curr_bonus);
684         st_user_ad[st_user_id[1]].ETH=safe_add(st_user_ad[st_user_id[1]].ETH,curr_bonus);
685         st_user_ad[st_user_id[1]].A_bonus=safe_add(st_user_ad[st_user_id[1]].A_bonus,curr_bonus);
686         bonus = bonus /5 * 4;
687         
688         
689         uint256 circulation=st_in_circulation + 10000000 szabo;
690         circulation = circulation - st_user_ad[st_user_id[0]].BWS - st_user_ad[st_user_id[1]].BWS;
691         
692         require(circulation>0);
693         
694         bonus =bonus/( circulation/1000000);
695         
696         for(uint32 i =2;i<=st_user_index;i++)
697         {
698             curr_bonus=safe_multiply(bonus,st_user_ad[st_user_id[i]].BWS/1000000);
699             st_user_ad[st_user_id[i]].ETH =safe_add(st_user_ad[st_user_id[i]].ETH,curr_bonus);
700             st_user_ad[st_user_id[i]].A_bonus =st_user_ad[st_user_id[i]].A_bonus +curr_bonus;
701             add_bonus += curr_bonus;
702         }
703         st_pool_a_bonus=st_pool_a_bonus-add_bonus;
704         emit ev_a_bonus(uint64(now),st_in_circulation,bonus,st_pool_a_bonus);
705         
706     }
707 
708     
709     function fpu_eth_to_outside(uint32 Recommender, uint256 par_eth)public
710     {
711         require(!st_frozen,"The system has been frozen");
712         require(st_black_list[msg.sender] ==false ,"You have been blacklisted");
713         register(Recommender);
714         require(st_user_ad[msg.sender].ETH >= par_eth,"Your ETH is insufficient");
715         require(par_eth >0,"Please enter the number of ETHs to withdraw");
716         st_user_ad[msg.sender].ETH -= par_eth;
717         msg.sender.transfer(par_eth);
718         emit ev_eth_to_outside(msg.sender,par_eth);
719     }
720     function fpu_set_black_list(address par_ad,bool par_black_list)public
721     {
722         if(par_black_list==true &&(msg.sender==Operate_Team || msg.sender ==Technical_Team))
723         {
724             st_black_list[par_ad]=true;
725             return;
726         }
727         if(msg.sender==Operate_Team)
728          {
729              if(is_frozen==0)
730              {
731                  is_frozen=2;
732              }
733              else if(is_frozen==3)
734              {
735                  st_black_list[par_ad] = false;
736                  is_frozen=0;
737              }
738          }
739          else if(msg.sender == Technical_Team)
740          {
741              if(is_frozen==0)
742              {
743                  is_frozen=3;
744              }
745              else if(is_frozen==2)
746              {
747                  st_black_list[par_ad] = false;
748                  is_frozen=0;
749              }
750          }
751     }
752     function fpu_set_frozen(bool par_isfrozen)public
753     {
754         if(par_isfrozen==true &&(msg.sender==Operate_Team || msg.sender ==Technical_Team))
755         {
756             st_frozen =true;
757             return;
758         }
759          if(msg.sender==Operate_Team)
760          {
761              if(is_frozen==0)
762              {
763                  is_frozen=2;
764              }
765              else if(is_frozen==3)
766              {
767                  st_frozen = false;
768                  is_frozen=0;
769              }
770          }
771          else if(msg.sender == Technical_Team)
772          {
773              if(is_frozen==0)
774              {
775                  is_frozen=3;
776              }
777              else if(is_frozen==2)
778              {
779                  st_frozen = false;
780                  is_frozen=0;
781              }
782          }
783     }
784     
785     function fpu_take_out_of_outer_disc(address par_target,uint256 par_bws_count)public
786     {
787          if(msg.sender==Operate_Team)
788          {
789              if(is_frozen==0)
790              {
791                  is_frozen=2;
792                  return;
793              }
794              else if(is_frozen==3)
795              {
796                  is_frozen=0;
797              }
798          }
799          else if(msg.sender == Technical_Team)
800          {
801              if(is_frozen==0)
802              {
803                  is_frozen=3;
804                  return;
805              }
806              else if(is_frozen==2)
807              {
808                  is_frozen=0;
809              }
810          }
811          st_outer_disc=safe_sub(st_outer_disc,par_bws_count);
812          balanceOf[par_target]=safe_add(balanceOf[par_target],par_bws_count);
813     }
814     function fpu_get_my_message(address ad)public view returns(
815             uint32 ID,
816             uint32 faNode,
817             uint32 Subordinate,
818             uint256 Income,
819             uint256 A_bonus
820             )
821     {
822         return (
823             Encryption(st_user_ad[ad].ID),
824             Encryption(st_user_ad[ad].faNode),
825             st_user_ad[ad].Subordinate,
826             st_user_ad[ad].Income,
827             st_user_ad[ad].A_bonus
828         );
829     }
830     function fpu_get_my_message1(address ad)public view returns(
831             
832             uint256 BWS,
833             uint256 MaxBWS,
834             uint256 ThisDaySellBWS,
835             uint256 ThisDayOutToInBWS,
836             uint256 ETH
837             )
838     {
839         return (
840             st_user_ad[ad].BWS,
841             st_user_ad[ad].MaxBWS,
842             (now-st_user_ad[ad].LastSellTime >86400)?0:st_user_ad[ad].ThisDaySellBWS,
843             (now-st_user_ad[ad].LastOutToInTime >86400)?0:st_user_ad[ad].ThisDayOutToInBWS,
844             st_user_ad[ad].ETH
845         );
846     }
847 }
1 /**
2 ******************************************************************************************************************************************************************************************
3 
4                     $$$$$$$\                                                                    $$\     $$\                 $$\                           $$\       
5                     $$  __$$\                                                                   $$ |    \__|                $$ |                          $$ |      
6                     $$ |  $$ | $$$$$$\  $$$$$$\$$$$\   $$$$$$\   $$$$$$$\  $$$$$$\   $$$$$$\  $$$$$$\   $$\  $$$$$$$\       $$ |      $$\   $$\  $$$$$$$\ $$ |  $$\ 
7                     $$ |  $$ |$$  __$$\ $$  _$$  _$$\ $$  __$$\ $$  _____|$$  __$$\  \____$$\ \_$$  _|  $$ |$$  _____|      $$ |      $$ |  $$ |$$  _____|$$ | $$  |
8                     $$ |  $$ |$$$$$$$$ |$$ / $$ / $$ |$$ /  $$ |$$ /      $$ |  \__| $$$$$$$ |  $$ |    $$ |$$ /            $$ |      $$ |  $$ |$$ /      $$$$$$  / 
9                     $$ |  $$ |$$   ____|$$ | $$ | $$ |$$ |  $$ |$$ |      $$ |      $$  __$$ |  $$ |$$\ $$ |$$ |            $$ |      $$ |  $$ |$$ |      $$  _$$<  
10                     $$$$$$$  |\$$$$$$$\ $$ | $$ | $$ |\$$$$$$  |\$$$$$$$\ $$ |      \$$$$$$$ |  \$$$$  |$$ |\$$$$$$$\       $$$$$$$$\ \$$$$$$  |\$$$$$$$\ $$ | \$$\ 
11                     \_______/  \_______|\__| \__| \__| \______/  \_______|\__|       \_______|   \____/ \__| \_______|      \________| \______/  \_______|\__|  \__|
12                             
13                           
14                                                                                 _    _                                        _  _              
15                                                                               | |  | |                                      | |(_)             
16                                         __      ____      ____      __     ___ | |_ | |__    __ _   __ _  _ __ ___    ___    | | _ __   __  ___ 
17                                         \ \ /\ / /\ \ /\ / /\ \ /\ / /    / _ \| __|| '_ \  / _` | / _` || '_ ` _ \  / _ \   | || |\ \ / / / _ \
18                                         \ V  V /  \ V  V /  \ V  V /  _ |  __/| |_ | | | || (_| || (_| || | | | | ||  __/ _ | || | \ V / |  __/
19                                           \_/\_/    \_/\_/    \_/\_/  (_) \___| \__||_| |_| \__, | \__,_||_| |_| |_| \___|(_)|_||_|  \_/   \___|
20                                                                                             __/ |                                              
21                                                                                             |___/                                               
22 
23 ******************************************************************************************************************************************************************************************                                                                                                                                          
24 
25 Contract Name: Democratic Luck
26 Contract Symbol: DemoLuck
27 Version: 1.0
28 Author: Alan Yan
29 Author Email: AlanYan99@outlook.com
30 Publish Date: 2018/11
31 Official Website: www.ethgame.live
32 Copyright: All rights reserved
33 Contract Describe: 
34     A game that include investment, math strategy, luck and democratic mechanism for game equilibrium. It based on eth blockchain network. 
35     Let's hope the whole world's people can enjoy this new revolutionary game and have fun!
36     Game Rules:
37     1. This game use ether cryptocurrency. To participate in the game, user need to use a browser such as chrome/Firefox with the metamask plugin installed.
38     2. User can directly participate in the game without registration first. If user buy share or buy ticket, then will be automatically registered. User also 
39       can manually register for free. The process of manual registration is very simple, just click the 'Register' button on the website, and then click 'Confirm' 
40       in the pop-up metamask window. Registration will complete.
41     3. Each user will have an account with a purse and a dedicated promotion url link. User can send this link to others and invite others to participate in the game, 
42       if the others join the game and get prize, user will always receive 5% of the others' prize as reward.
43     4. After each round of the game begins, user can buy shares of the game and become the shareholder. The price of the shares is 1eth/share, and 70% of the cost 
44       ether will put into the jackpot prize pool, 20% will be constantly distributed to all earlier shares (including itself), and 10% will be given to the last 
45       share buyer at the end of game round as a special prize.
46     5. When there is a jackpot prize pool, then anyone can buy luck tickets at any time to win the jackpot prize pool. The price of the luck ticket is 0.01 eth, 
47       and 50% of the cost ether will instantly distribute to all current shares, and 50% of the cost ether will instantly distribute to all earlier luck tickets (including itself).
48     6. When a luck ticket was been bought, a 48-hour countdown will auto start. If a new luck ticket was been bought during the countdown, then 48-hour countdown
49       will restart again. If when the 48-hour countdown is over, there is still no new ticket was been bought. Then the game will enter the vote period. The vote
50       period is 24 hours. Every shareholder can participate in vote. Shareholder's share amount is votes amount. Shareholders can choose to continue wait or end 
51       the game round. If the shareholder didn't not manually vote, the default option is continue wait, if votes amount of end game round is more than 50% of the 
52       total votes amount, then game round will auto end. During the voting period, if a new luck ticket was been bought, then vote will be cancelled and restart 
53       the 48-hour countdown again. After vote period over and shareholders didn't vote to end game round, then game will continue wait and restart the 48-hour countdown again.
54     7. During the game, shareholders or luck ticket buyers can view their own prize at any time. The prize is dynamic estimation and change with the game progress.
55     8. When the game is over, the prize will be automatically distributed. The prize distribution rules are: the instantly prize obtained by shareholders and luck 
56       ticket buyers during the game will be their prize too, also the total share capital's 10% will reward to the last share buyer at the end of the game as a 
57       special prize, the last luck ticket buyer will win the jackpot prize pool.
58     9. After the game is over, The prize that each player received, the platform will charge 5% as a service fee, and the remaining 95% will automatically deposited
59       into the purse of user's account. User can withdraw the prize to own personal ether account at any time.
60     10. If player (shareholder or luck ticket buyer) wins the prize in the game round, and player has a referrer, the referrer will receive 5% of the prize as a reward. 
61       When player withdraw the prize from purse, the reward will be sent to referer's purse.
62     11. After each game round ended and distributed prize, the next round will automatically restart.
63 
64 **/
65 
66 pragma solidity ^0.4.24;
67 
68 
69 /** @title Democratic Luck */
70 contract DemocraticLuck {
71   
72   using SafeMath for uint256;
73   
74   //event when shareholder buy share 
75   event event_buyShare(address indexed _addr, uint256 indexed _indexNo, uint256 _num);
76   //event when player buy luck ticket 
77   event event_buyTicket(address indexed _addr, uint256 indexed _indexNo, uint256 _num);
78   //event when shareholder vote
79   event event_shareholderVote(address indexed _addr, uint256 indexed _indexNo, uint256 _vote);  
80   //event when round end and jackpot winner
81   event event_endRound(uint256 indexed _indexNo, address indexed _addr, uint256 _prize);
82   
83   address private Owner; 
84   uint256 private rdSharePrice = 1 ether;  //share's price
85   uint256 private rdTicketPrice = 0.01 ether; //luck ticket's price
86   uint256 private rdIndexNo = 0; //game round's index No  counter
87   uint256 private userIDCnt = 0;  //user's id counter
88   uint256 private rdStateActive = 1;  //game round's active state 
89   uint256 private rdStateEnd = 2;   //game round's end state
90   uint256 private rdTicketTime = 48 hours; //countdown time since a ticket was been bought
91   uint256 private rdVoteTime = 24 hours; //vote time since countdown time over
92   uint256 private serviceFee = 5; //system charge service fee rate
93   uint256 private refererFee = 5; //referer user's prize percent 5%
94   uint256 private sharePotRate = 70; //share price's percent into jackpot   
95   uint256 private shrPrizeRate = 20; //share price's percent to distribute to current shares
96   uint256 private shrLastBuyerRate = 10; //share price's percent to last share buyer
97   uint256 private ticketPotRate = 50; //ticket price's percent to distribute to current shares
98   uint256 private serviceFeeCnt; //owner service fee count
99    
100   //user's account information
101   struct userAcc{  
102         uint256 purse; //user's purse
103         uint256 refCode; //user's unique referrer code
104         uint256 frefCode; //user from referrer code 
105   }
106   
107   //game shareholder's information
108   struct rdShareholder{
109         uint256 cost;  //shareholder cost to buy share
110         uint256 shareNum;  //shareholder's shares amount  
111         uint256 shrAvgBonus;  //shareholder's shares average value to calculate bonus from later shares  
112         uint256 shrTckAvgBonus;  //shareholder's shares average value to calculate bonus from tickets sale  
113         uint256 vote; //shareholder's vote to coutinue or end game round
114         uint256 lastShrVoteTime; //shareholder's last vote time       
115   }  
116   
117   //luck ticket buyer's information
118   struct rdTckBuyer{ 
119         uint256 cost;   //ticket buyer cost to buy ticket
120         uint256 ticketNum; //ticket's amount
121         uint256 tckAvgBonus; //ticket buyer's average value to calculate bonus from later tickets
122   }
123   
124   //game round's information
125   struct rdInfo{ 
126         uint256 state;   //round's state: 1,active 2,end
127         uint256 sharePot;    //all share's capital pot
128         uint256 shrJackpot;    //round's jackpot
129         uint256 shareholderNum; //shareholders amount        
130         uint256 shareNum;  //shares amount
131         uint256 shrAvgBonus;  //round's shares average value to calculate bonus from later shares
132         uint256 shrTckAvgBonus; //round's shares average value to calculate bonus from tickets sale
133         uint256 ticketPot; //luck ticket sales amount 
134         uint256 tckBuyerNum; //luck ticket buyers amount      
135         uint256 ticketNum; //luck ticket's saled amount 
136         uint256 tckAvgBonus; //round's ticket buyer's average value to calculate bonus from later tickets
137         uint256 lastTckBuyTime; //time of last ticket was been bought 
138         uint256 lastShrVoteTime;  //last time of shareholders vote
139         uint256 shrVotesEnd;   //count of votes to end    
140         address lastShareBuyer; //who bought the last share 
141         address lastTckBuyer; //who bought the last luck ticket
142    }
143 
144  
145   mapping(uint256 => address) private userIDAddr; //user'id => user's account
146   mapping(address => userAcc) private userAccs;  //user's account => user's account information
147   mapping(address => uint256[]) private userUnWithdrawRound; //round list that user didn't withdraw yet  
148   mapping(uint256 => mapping(address => rdShareholder)) private rdShareholders;  //round's index No => shareholder's account =>  shareholder's information  
149   mapping(uint256 => rdInfo) private rdInfos;  //round's index No => round's information
150   mapping(uint256 => mapping(address => rdTckBuyer)) private rdTckBuyers;  //round's index No => luck ticket buyer's account => ticket buyer's information  
151  
152   
153   /* Modifiers */
154 
155   /** @dev check caller is owner    
156   */
157   modifier onlyOwner()
158   {
159     require(Owner == msg.sender);
160     _;
161   }   
162   
163   /** @dev check caller is person     
164   */
165   modifier isPerson()
166   {        
167     address addr = msg.sender;
168     uint256 size;
169     
170     assembly {size := extcodesize(addr)}
171     require(size == 0);
172 
173     require(tx.origin == msg.sender);
174     _;
175   }
176   
177   /** @dev create contract     
178   */
179   constructor()
180   public
181   {
182     Owner = msg.sender;   
183     startNewRound();
184   }
185   
186   /** @dev tarnsfer ownership to new account
187     * @param _owner  new owner account 
188   */
189   function transferOwnership(address _owner)
190   onlyOwner()
191   public 
192   { 
193     Owner = _owner;
194   }  
195   
196   /** @dev get contract owner account
197     * @return _addr owner account 
198   */
199   function owner()
200   public 
201   view 
202   returns (address _addr) 
203   {
204     return Owner;
205   } 
206   
207   /** @dev start new game round   
208   */
209   function startNewRound()
210   internal
211   {      
212     rdIndexNo++;
213     rdInfo memory rdInf = rdInfo(rdStateActive, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, address(0), address(0));
214     rdInfos[rdIndexNo] = rdInf;
215   } 
216  
217   /** @dev new user register 
218     * @param _frefCode  referer id  
219   */
220   function userRegister(uint256 _frefCode)
221   isPerson() 
222   public 
223   {  
224     require(msg.sender != address(0));
225     require(!checkUserExist(msg.sender)); 
226     
227     addNewUser(msg.sender, _frefCode);        
228   }    
229 
230   /** @dev add new user
231     * @param _addr  user account
232     * @param _frefCode  referer id  
233   */
234   function addNewUser(address _addr, uint256 _frefCode)  
235   internal 
236   {  
237     if(getAddrOfRefCode(_frefCode) == address(0))
238           _frefCode = 0;          
239     
240     userIDCnt++;       
241     userAcc memory uAcc = userAcc(0, userIDCnt, _frefCode);
242     userAccs[_addr] = uAcc;      
243     userIDAddr[userIDCnt] = _addr;                
244   }    
245 
246   /** @dev add new shareholder into game round
247      * @param _indexNo  round's index No
248      * @param _addr  shareholder account     
249   */
250   function addRdShareholder(uint256 _indexNo, address _addr)
251   internal 
252   {
253     rdShareholder memory rdPly = rdShareholder(0, 0, 0, 0, 0, 0);
254     rdShareholders[_indexNo][_addr] = rdPly;    
255     rdInfos[_indexNo].shareholderNum++;
256     if(!checkUserInUnWithdrawRd(_indexNo, _addr))
257       userUnWithdrawRound[_addr].push(_indexNo);
258   }  
259 
260   /** @dev add new ticket buyer into game round
261      * @param _indexNo  round's index No
262      * @param _addr  ticket buyer account     
263   */
264   function addRdTicketBuyer(uint256 _indexNo, address _addr)
265   internal 
266   {
267     rdTckBuyer memory rdPly = rdTckBuyer(0, 0, 0);
268     rdTckBuyers[_indexNo][_addr] = rdPly;    
269     rdInfos[_indexNo].tckBuyerNum++;
270     if(!checkUserInUnWithdrawRd(_indexNo, _addr))
271       userUnWithdrawRound[_addr].push(_indexNo);
272   }  
273   
274   /** @dev shareholder buy shares
275     * @param _indexNo  round's index No    
276     * @param _frefCode  referer id    
277   */
278   function buyShare(uint256 _indexNo, uint256 _frefCode)
279   isPerson() 
280   public 
281   payable 
282   {
283     require(msg.sender != address(0)); 
284     require(checkRdActive(_indexNo));    
285     require(msg.value.sub(rdSharePrice) >= 0);
286     
287     uint256 _num = msg.value.div(rdSharePrice);
288     uint256 cost = rdSharePrice.mul(_num);   
289 
290     if(!checkUserExist(msg.sender))
291       addNewUser(msg.sender, _frefCode); 
292 
293     if(!checkShareholderInRd(_indexNo, msg.sender))
294       addRdShareholder(_indexNo, msg.sender); 
295 
296     addRoundShare(_indexNo, msg.sender, cost, _num); 
297     calcServiceFee(cost);   
298 
299     if(msg.value.sub(cost) > 0)
300        userAccs[msg.sender].purse += msg.value.sub(cost);
301     
302     emit event_buyShare(msg.sender, _indexNo, _num);
303   }  
304 
305   /** @dev add shares info when shareholder bought
306     * @param _indexNo  round's index No   
307     * @param _addr shareholder's account
308     * @param _cost cost amount   
309     * @param _num shares amount    
310   */
311   function addRoundShare(uint256 _indexNo, address _addr, uint256 _cost, uint256 _num)
312   internal 
313   {    
314     rdInfos[_indexNo].lastShareBuyer = _addr;       
315     rdInfos[_indexNo].shareNum += _num;
316     rdInfos[_indexNo].sharePot = rdInfos[_indexNo].sharePot + _cost; 
317     rdInfos[_indexNo].shrJackpot = rdInfos[_indexNo].shrJackpot + (_cost * sharePotRate / 100); 
318     rdInfos[_indexNo].shrAvgBonus = rdInfos[_indexNo].shrAvgBonus + (_cost * shrPrizeRate / 100) / rdInfos[_indexNo].shareNum;
319        
320     rdShareholders[_indexNo][_addr].cost += _cost;         
321     rdShareholders[_indexNo][_addr].shareNum += _num;  
322     rdShareholders[_indexNo][_addr].shrAvgBonus = (rdInfos[_indexNo].shrAvgBonus * rdShareholders[_indexNo][_addr].shareNum - (rdInfos[_indexNo].shrAvgBonus - (_cost * shrPrizeRate / 100) / rdInfos[_indexNo].shareNum - rdShareholders[_indexNo][_addr].shrAvgBonus) * (rdShareholders[_indexNo][_addr].shareNum - _num) - (_cost * shrPrizeRate / 100) * rdShareholders[_indexNo][_addr].shareNum / rdInfos[_indexNo].shareNum) / rdShareholders[_indexNo][_addr].shareNum;     
323     rdShareholders[_indexNo][_addr].shrTckAvgBonus = (rdInfos[_indexNo].shrTckAvgBonus * rdShareholders[_indexNo][_addr].shareNum - (rdInfos[_indexNo].shrTckAvgBonus - rdShareholders[_indexNo][_addr].shrTckAvgBonus) * (rdShareholders[_indexNo][_addr].shareNum - _num)) / rdShareholders[_indexNo][_addr].shareNum;       
324   } 
325 
326   /** @dev buy luck ticket
327     * @param _indexNo  round's index No  
328     * @param _frefCode  referer id
329   */
330   function buyTicket(uint256 _indexNo, uint256 _frefCode)
331   isPerson() 
332   public 
333   payable 
334   { 
335     require(msg.sender != address(0)); 
336     require(checkRdActive(_indexNo));   
337     require(rdInfos[_indexNo].shrJackpot > 0); 
338     require(msg.value.sub(rdTicketPrice) >= 0);
339     
340     uint256 _num = msg.value.div(rdTicketPrice);
341     uint256 cost = rdTicketPrice.mul(_num);
342 
343     if(!checkUserExist(msg.sender))
344       addNewUser(msg.sender, _frefCode); 
345     if(!checkTicketBuyerInRd(_indexNo, msg.sender))
346       addRdTicketBuyer(_indexNo, msg.sender); 
347 
348     addRoundTicket(_indexNo, msg.sender, cost, _num);    
349     calcServiceFee(cost); 
350 
351     if(msg.value.sub(cost) > 0)
352        userAccs[msg.sender].purse += msg.value.sub(cost);
353 
354     emit event_buyTicket(msg.sender, _indexNo, _num);
355   } 
356 
357   /** @dev add ticket info
358     * @param _indexNo  round's index No   
359     * @param _addr buyer's account
360     * @param _cost cost amount   
361     * @param _num tickets amount    
362   */
363   function addRoundTicket(uint256 _indexNo, address _addr, uint256 _cost, uint256 _num)
364   internal 
365   { 
366     rdInfos[_indexNo].lastTckBuyTime = now;
367     rdInfos[_indexNo].lastTckBuyer = _addr; 
368     rdInfos[_indexNo].ticketNum += _num;
369     rdInfos[_indexNo].ticketPot = rdInfos[_indexNo].ticketPot + _cost;        
370     rdInfos[_indexNo].shrTckAvgBonus = rdInfos[_indexNo].shrTckAvgBonus + (_cost * ticketPotRate / 100) / rdInfos[_indexNo].shareNum; 
371     rdInfos[_indexNo].tckAvgBonus = rdInfos[_indexNo].tckAvgBonus + (_cost * (100 - ticketPotRate) / 100) / rdInfos[_indexNo].ticketNum;     
372 
373     rdTckBuyers[_indexNo][_addr].cost += _cost;
374     rdTckBuyers[_indexNo][_addr].ticketNum += _num;
375     rdTckBuyers[_indexNo][_addr].tckAvgBonus = (rdInfos[_indexNo].tckAvgBonus * rdTckBuyers[_indexNo][_addr].ticketNum - (rdInfos[_indexNo].tckAvgBonus - (_cost * (100 - ticketPotRate) / 100) / rdInfos[_indexNo].ticketNum - rdTckBuyers[_indexNo][_addr].tckAvgBonus) * (rdTckBuyers[_indexNo][_addr].ticketNum - _num) - (_cost * (100 - ticketPotRate) / 100) * rdTckBuyers[_indexNo][_addr].ticketNum / rdInfos[_indexNo].ticketNum) / rdTckBuyers[_indexNo][_addr].ticketNum;   
376   }  
377   
378   /**
379   * @dev get user amount 
380   * @return _num user amount 
381   */
382   function getUserCount()
383   public 
384   view 
385   returns(uint256 _num) 
386   {    
387     return userIDCnt;    
388   }
389   
390   /**
391   * @dev get user's information 
392   * @param _addr  user's account 
393   * @return user's information 
394   */
395   function getUserInfo(address _addr)
396   public 
397   view 
398   returns(uint256, uint256, uint256) 
399   {   
400     require(_addr != address(0));
401     require(checkUserExist(_addr));
402       
403     uint256 prize = 0;  
404 
405     for(uint256 i = 0; i < userUnWithdrawRound[_addr].length; i++)
406     {
407       uint256 indexNo = userUnWithdrawRound[_addr][i];
408        
409       if(rdInfos[indexNo].state == rdStateEnd)      
410         prize += calcRdPlayerPrize(indexNo, _addr); 
411     }
412 
413     prize = userAccs[_addr].purse + prize * (100 - serviceFee) / 100; 
414 
415     return (prize, userAccs[_addr].refCode, userAccs[_addr].frefCode);    
416   }
417 
418   /** @dev user withdraw eth from purse, withdraw all every time   
419   */
420   function userWithdraw()
421   isPerson() 
422   public 
423   {          
424     require(msg.sender != address(0));
425     require(checkUserExist(msg.sender));
426     
427     address addr = msg.sender;
428     uint256 prize = 0;
429     uint256 unEndRd = 0;
430 
431     for(uint256 i = 0; i < userUnWithdrawRound[addr].length; i++)
432     {
433       uint256 indexNo = userUnWithdrawRound[addr][i];
434        
435       if(rdInfos[indexNo].state == rdStateEnd)      
436         prize += calcRdPlayerPrize(indexNo, addr); 
437       else
438         unEndRd = indexNo;
439     }
440     
441     require(prize > 0); 
442     userUnWithdrawRound[addr].length = 0;   
443     if(unEndRd > 0)
444       userUnWithdrawRound[addr].push(unEndRd);    
445     prize = prize * (100 - serviceFee) / 100;
446 
447     if(userAccs[addr].frefCode != 0)
448     {
449       address frefAddr = getAddrOfRefCode(userAccs[addr].frefCode);
450       if(frefAddr != address(0))
451       {
452           uint256 refPrize = (prize * refererFee) / 100;
453           userAccs[frefAddr].purse += refPrize;
454           prize -= refPrize;
455       }    
456     }          
457 
458     prize += userAccs[addr].purse;
459     userAccs[addr].purse = 0;
460     addr.transfer(prize);            
461   }   
462   
463   /**
464   * @dev calculate player's prize
465   * @param _indexNo  round's index No
466   * @param _addr  player's account
467   * @return _prize player's prize 
468   */
469   function calcRdPlayerPrize(uint256 _indexNo, address _addr)
470   internal 
471   view 
472   returns(uint256 _prize)
473   { 
474     uint256 prize = 0;
475     
476     if(rdShareholders[_indexNo][_addr].shareNum > 0)    
477       prize += calcShrPrize(_indexNo, _addr); 
478      
479     if(rdTckBuyers[_indexNo][_addr].ticketNum > 0)
480       prize += calcTckPrize(_indexNo, _addr);
481 
482     return prize;
483   }
484 
485   /**
486   * @dev calculate shareholder's share prize
487   * @param _indexNo  round's index No
488   * @param _addr  shareholder account
489   * @return _prize shareholder's prize 
490   */  
491   function calcShrPrize(uint256 _indexNo, address _addr)
492   internal 
493   view 
494   returns(uint256 _prize)
495   { 
496     uint256 prize = 0;
497 
498     prize += (rdInfos[_indexNo].shrAvgBonus - rdShareholders[_indexNo][_addr].shrAvgBonus) * rdShareholders[_indexNo][_addr].shareNum;
499     prize += (rdInfos[_indexNo].shrTckAvgBonus - rdShareholders[_indexNo][_addr].shrTckAvgBonus) * rdShareholders[_indexNo][_addr].shareNum;  
500     
501     if(rdInfos[_indexNo].lastShareBuyer == _addr) 
502       prize += (rdInfos[_indexNo].sharePot * shrLastBuyerRate) / 100;  
503        
504     return prize;
505   }
506 
507   /**
508   * @dev calculate ticket buyer's ticket prize
509   * @param _indexNo  round's index No
510   * @param _addr  buyer account
511   * @return _prize buyer's prize 
512   */  
513   function calcTckPrize(uint256 _indexNo, address _addr)
514   internal 
515   view 
516   returns(uint256 _prize)
517   { 
518     uint256 prize = 0;
519    
520     prize += (rdInfos[_indexNo].tckAvgBonus - rdTckBuyers[_indexNo][_addr].tckAvgBonus) * rdTckBuyers[_indexNo][_addr].ticketNum; 
521     
522     if(rdInfos[_indexNo].lastTckBuyer == _addr) 
523       prize += rdInfos[_indexNo].shrJackpot;  
524     
525     return prize;
526   }  
527  
528   /** @dev get active round's index No
529     * @return _rdIndexNo active round's index No
530   */
531   function getRoundActive()
532   public 
533   view 
534   returns(uint256 _rdIndexNo) 
535   {   
536      return rdIndexNo; 
537   }
538       
539   /** @dev get round's information
540     * @param _indexNo  round's index No 
541     * @return _rdIn rounds's information
542     * @return _addrs rounds's information
543   */
544   function getRdInfo(uint256 _indexNo)  
545   public 
546   view 
547   returns(uint256[] _rdIn, address[] _addrs)
548   {    
549     require(checkRdExist(_indexNo));
550     
551     uint256[] memory rdIn = new uint256[](16);    
552     address[] memory addrs = new address[](2);    
553     
554     rdIn[0] = rdSharePrice;    
555     rdIn[1] = rdTicketPrice;
556     rdIn[2] = rdInfos[_indexNo].state;
557     rdIn[3] = rdInfos[_indexNo].sharePot;
558     rdIn[4] = rdInfos[_indexNo].shrJackpot;
559     rdIn[5] = rdInfos[_indexNo].shareholderNum;
560     rdIn[6] = rdInfos[_indexNo].shareNum;     
561     rdIn[7] = rdInfos[_indexNo].shrAvgBonus; 
562     rdIn[8] = rdInfos[_indexNo].shrTckAvgBonus;    
563     rdIn[9] = rdInfos[_indexNo].ticketPot; 
564     rdIn[10] = rdInfos[_indexNo].tckBuyerNum;
565     rdIn[11] = rdInfos[_indexNo].ticketNum; 
566     rdIn[12] = rdInfos[_indexNo].tckAvgBonus;
567     rdIn[13] = rdInfos[_indexNo].lastTckBuyTime;
568     rdIn[14] = rdInfos[_indexNo].lastShrVoteTime;
569     rdIn[15] = rdInfos[_indexNo].shrVotesEnd;   
570 
571     addrs[0] =  rdInfos[_indexNo].lastShareBuyer;
572     addrs[1] =  rdInfos[_indexNo].lastTckBuyer; 
573   
574     return (rdIn,  addrs);  
575   }
576   
577  
578   /** @dev get round's countdown time or vote time state
579     * @param _indexNo  round's index No 
580     * @return _timeState countdown time or vote time
581     * @return _timeLeft  left time   
582   */  
583   function getRdTimeState(uint256 _indexNo)  
584   public 
585   view 
586   returns(uint256 _timeState, uint256 _timeLeft) 
587   {  
588     require(checkRdActive(_indexNo));
589     
590     uint256 nowTime = now;
591     uint256 timeState = 0;
592     uint256 timeLeft = 0;        
593     
594     uint256 timeStart = getRdLastCntDownStart(_indexNo, nowTime); 
595     
596     if(timeStart > 0)
597     { 
598       if(nowTime < (timeStart + rdTicketTime))
599       {
600         timeState = 1;
601         timeLeft = (timeStart + rdTicketTime) - nowTime;
602       }      
603       else
604       {
605         timeState = 2;
606         timeLeft = (timeStart + rdTicketTime + rdVoteTime) - nowTime; 
607       }
608       
609     }   
610   
611     return (timeState, timeLeft);  
612   }
613 
614   /** @dev get round's last countdown start time
615     * @param _indexNo  round's index No
616     * @param _nowTime  now time 
617     * @return _timeStart last countdown start time
618   */  
619   function getRdLastCntDownStart(uint256 _indexNo, uint256 _nowTime)  
620   internal 
621   view 
622   returns(uint256 _timeStart) 
623   {  
624     require(checkRdActive(_indexNo));
625    
626     uint256 timeStart = 0;   
627     
628     if(rdInfos[_indexNo].lastTckBuyTime > 0)
629     { 
630       uint256 timeSpan = _nowTime - rdInfos[_indexNo].lastTckBuyTime;
631       uint256 num = timeSpan / (rdTicketTime + rdVoteTime);
632       timeStart = rdInfos[_indexNo].lastTckBuyTime + num * (rdTicketTime + rdVoteTime);
633     }   
634   
635     return timeStart;  
636   }
637  
638   /** @dev get round's player's information
639     * @param _indexNo  round's index No 
640     * @param _addr player's account   
641     * @return _rdPly1  shareholder's information 
642     * @return _rdPly2  ticket buyer's information 
643   */
644   function getRdPlayerInfo(uint256 _indexNo, address _addr)
645   public 
646   view 
647   returns(uint256[] _rdPly1, uint256[] _rdPly2) 
648   { 
649     require(checkShareholderInRd(_indexNo, _addr) || checkTicketBuyerInRd(_indexNo, _addr));
650     
651     uint256[] memory rdPly1 = new uint256[](6);
652     uint256[] memory rdPly2 = new uint256[](3);
653 
654     if(checkShareholderInRd(_indexNo, _addr))
655     {
656       rdPly1[0] = rdShareholders[_indexNo][_addr].cost;    
657       rdPly1[1] = rdShareholders[_indexNo][_addr].shareNum; 
658       rdPly1[2] = rdShareholders[_indexNo][_addr].shrAvgBonus;
659       rdPly1[3] = rdShareholders[_indexNo][_addr].shrTckAvgBonus;  
660       rdPly1[4] = calcShrPrize(_indexNo, _addr);  
661       rdPly1[5] = 0;  
662 
663       if(checkRdInVoteState(_indexNo))         
664         rdPly1[5] = getRdshareholderVoteVal(_indexNo, _addr, now);
665     }
666     
667     if(checkTicketBuyerInRd(_indexNo, _addr))
668     {
669       rdPly2[0] = rdTckBuyers[_indexNo][_addr].cost;
670       rdPly2[1] = rdTckBuyers[_indexNo][_addr].ticketNum;
671       rdPly2[2] = calcTckPrize(_indexNo, _addr);   
672     }
673 
674     return (rdPly1, rdPly2);  
675   }  
676   
677   /** @dev shareholder vote to coutinue or end round
678     * @param _indexNo  round's index No 
679     * @param _vote coutinue or end round
680   */
681   function shareholderVote(uint256 _indexNo, uint256 _vote)
682   isPerson()
683   public 
684   { 
685     require(checkRdInVoteState(_indexNo));
686     require(checkShareholderInRd(_indexNo, msg.sender));    
687     require(_vote == 0 || _vote == 1);
688     
689     address addr = msg.sender;
690     uint256 nowTime = now;
691     uint256 timeStart = getRdLastCntDownStart(_indexNo, nowTime); 
692 
693     if(rdInfos[_indexNo].lastShrVoteTime < (timeStart + rdTicketTime))
694     {   
695         rdShareholders[_indexNo][addr].vote = 0;        
696         rdInfos[_indexNo].shrVotesEnd = 0;
697     } 
698 
699     if(rdShareholders[_indexNo][addr].lastShrVoteTime > (timeStart + rdTicketTime))
700     {
701       if(_vote == 1 && _vote != rdShareholders[_indexNo][addr].vote)
702         rdInfos[_indexNo].shrVotesEnd += rdShareholders[_indexNo][addr].shareNum;
703       else if(_vote == 0 && _vote != rdShareholders[_indexNo][addr].vote)
704         rdInfos[_indexNo].shrVotesEnd -= rdShareholders[_indexNo][addr].shareNum;
705     }
706     else if(_vote == 1)
707         rdInfos[_indexNo].shrVotesEnd += rdShareholders[_indexNo][addr].shareNum;      
708     
709     rdShareholders[_indexNo][addr].vote = _vote;
710     rdShareholders[_indexNo][addr].lastShrVoteTime = nowTime;
711     rdInfos[_indexNo].lastShrVoteTime = nowTime;
712     emit event_shareholderVote(addr, _indexNo, _vote); 
713 
714     if((rdInfos[_indexNo].shrVotesEnd * 2) > rdInfos[_indexNo].shareNum)
715        endRound(_indexNo);      
716   }   
717  
718   /** @dev get round's shareholder vote result
719     * @param _indexNo  round's index No 
720     * @return _votesEnd  votes amount to end round
721     * @return _voteAll  all votes amount
722   */ 
723   function getRdVotesCount(uint256 _indexNo)
724   public 
725   view 
726   returns(uint256 _votesEnd, uint256 _voteAll)
727   { 
728     require(checkRdInVoteState(_indexNo));
729 
730     uint256 nowTime = now;
731     uint256 shrVotesEnd = 0;    
732     uint256 timeStart = getRdLastCntDownStart(_indexNo, nowTime);
733     
734     if(timeStart > 0 && rdInfos[_indexNo].lastShrVoteTime > (timeStart + rdTicketTime))   
735       shrVotesEnd = rdInfos[_indexNo].shrVotesEnd;    
736           
737     return (shrVotesEnd, rdInfos[_indexNo].shareNum);
738   } 
739 
740   /**
741   * @dev end game round,then start new round
742   * @param _indexNo  round's index No  
743   */
744   function endRound(uint256 _indexNo)
745   internal 
746   {   
747     rdInfos[_indexNo].state = rdStateEnd;
748 
749     owner().transfer(serviceFeeCnt);   
750     serviceFeeCnt = 0; 
751 
752     emit event_endRound(_indexNo, rdInfos[_indexNo].lastTckBuyer, rdInfos[_indexNo].shrJackpot);
753 
754     startNewRound();   
755   }  
756   
757   /** @dev get user from referer id
758     * @param _refCode  referer id 
759     * @return _addr  user account
760   */
761   function getAddrOfRefCode(uint256 _refCode) 
762   internal 
763   view 
764   returns(address _addr) 
765   {  
766     if(userIDAddr[_refCode] != address(0))
767       return userIDAddr[_refCode];
768     return address(0);
769   } 
770 
771   /** @dev check user registered?  
772     * @param _addr  user account
773     * @return _result exist or not
774   */
775   function checkUserExist(address _addr)
776   internal 
777   view 
778   returns(bool _result) 
779   {
780     if(userAccs[_addr].refCode != 0)
781       return true;
782     return false;
783   }
784   
785   /** @dev check round exist?  
786     * @param _indexNo  round's index no
787     * @return _result  exist or not
788   */
789   function checkRdExist(uint256 _indexNo) 
790   internal 
791   view 
792   returns(bool _result) 
793   {
794     if(rdInfos[_indexNo].state > 0)
795       return true;
796     return false;
797   }
798   
799   /** @dev check round is active?  
800     * @param _indexNo  round's index no
801     * @return _result  active or not
802   */
803   function checkRdActive(uint256 _indexNo) 
804   internal 
805   view 
806   returns(bool _result) 
807   {
808     require(checkRdExist(_indexNo));
809     
810     if(rdInfos[_indexNo].state == rdStateActive)
811         return true;
812     return false;
813   }
814  
815   /** @dev check round is in vote state?  
816     * @param _indexNo  round's index no
817     * @return _result  in vote state or not
818   */
819   function checkRdInVoteState(uint256 _indexNo)
820   internal 
821   view 
822   returns(bool _result) 
823   {
824     require(checkRdActive(_indexNo));
825 
826     uint256 timeState = 0;
827   
828     (timeState,) = getRdTimeState(_indexNo);
829     if(timeState == 2)
830         return true;
831 
832     return false;
833   }
834   
835   /** @dev check user is shareholder in a round?  
836     * @param _indexNo  round's index no
837     * @param _addr  shareholder account
838     * @return _result  is shareholder or not
839   */
840   function checkShareholderInRd(uint256 _indexNo, address _addr) 
841   public 
842   view 
843   returns(bool _result) 
844   {
845     require(checkRdExist(_indexNo));
846 
847     if(rdShareholders[_indexNo][_addr].shareNum > 0)
848       return true;
849     return false;
850   }
851 
852   /** @dev check user is ticket buyer in a round?  
853     * @param _indexNo  round's index no
854     * @param _addr  ticket buyer account
855     * @return _result  is ticket buyer or not
856   */
857   function checkTicketBuyerInRd(uint256 _indexNo, address _addr) 
858   public 
859   view 
860   returns(bool _result) 
861   {
862     require(checkRdExist(_indexNo));
863 
864     if(rdTckBuyers[_indexNo][_addr].ticketNum > 0)
865       return true;
866     return false;
867   }
868   
869   /** @dev check user in a round and didn't withdraw yet?  
870     * @param _indexNo  round's index no
871     * @param _addr  user account
872     * @return _result  in or not
873   */
874   function checkUserInUnWithdrawRd(uint256 _indexNo, address _addr) 
875   internal 
876   view 
877   returns(bool _result) 
878   {
879     require(checkUserExist(_addr));
880     require(checkRdExist(_indexNo));
881     
882     for(uint256 i = 0; i < userUnWithdrawRound[_addr].length; i++)
883     {
884       if(userUnWithdrawRound[_addr][i] == _indexNo)
885         return true;
886     }
887 
888     return false;
889   }
890 
891   /** @dev get shareholder's vote  
892     * @param _indexNo  round's index no
893     * @param _addr  shareholder account
894     * @param _nowTime  current time
895     * @return _result  shareholder's vote 
896   */
897   function getRdshareholderVoteVal(uint256 _indexNo, address _addr, uint256 _nowTime) 
898   internal 
899   view 
900   returns(uint256 _result) 
901   {
902     uint256 timeStart = getRdLastCntDownStart(_indexNo, _nowTime);
903     if(rdShareholders[_indexNo][_addr].vote == 1 && rdShareholders[_indexNo][_addr].lastShrVoteTime > (timeStart + rdTicketTime))                  
904       return 1;
905 
906     return 0;
907   }
908 
909   /** @dev calculate service fee
910     * @param _cost  buyer's cost   
911   */
912   function calcServiceFee(uint256 _cost) 
913   internal
914   {    
915     serviceFeeCnt += (_cost * serviceFee) / 100;
916     if(serviceFeeCnt >= 1 ether)
917     { 
918       owner().transfer(serviceFeeCnt);   
919       serviceFeeCnt = 0; 
920     }  
921   }  
922   
923 
924 }
925 
926 
927 library SafeMath {
928   function mul(uint256 a, uint256 b) 
929   internal 
930   pure 
931   returns(uint256) 
932   {
933     if(a == 0) {
934       return 0;
935     }
936     uint256 c = a * b;
937     assert(c / a == b);
938     return c;
939   }
940 
941   function div(uint256 a, uint256 b) 
942   internal 
943   pure 
944   returns(uint256) 
945   {    
946     uint256 c = a / b;    
947     return c;
948   }
949 
950   function sub(uint256 a, uint256 b) 
951   internal 
952   pure 
953   returns(uint256) 
954   {
955     assert(b <= a);
956     return a - b;
957   }
958 
959   function add(uint256 a, uint256 b) 
960   internal 
961   pure 
962   returns(uint256) 
963   {
964     uint256 c = a + b;
965     assert(c >= a);
966     return c;
967   }
968 }
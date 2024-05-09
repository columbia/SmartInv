1 pragma solidity ^0.4.24;
2 
3 /***
4  *     ____ _  _    __ _ __ _  __   ___ __ _ __  _  _ ____ 
5  *    (___ ( \/ )  (  / (  ( \/  \ / __(  / /  \/ )( (_  _)
6  *     / __/)  (    )  (/    (  O ( (__ )  (  O ) \/ ( )(  
7  *    (____(_/\_)  (__\_\_)__)\__/ \___(__\_\__/\____/(__) 
8  * 
9  *                         WHALE LEAGUE
10  *                     
11  *                     https://2Xknockout.me
12  * 
13  * COMMUNITY
14  * https://discord.gg/GKHnMBs
15  * http://t.me/Knockout2x
16  * 
17  * HOW IT WORKS
18  * Join the queue and wait. Each new user moves you down. 
19  * When you reach last place and someone join the list you will exit with X2
20  * 
21  * #   Users    Deposit        Description
22  * 2 | USER B |  3 ETH  | 3 ETH moves to USER A
23  * 1 | USER A |  3 ETH  | +3 ETH
24  *   |  EXIT  |         | USER A exit with +6 ETH
25  * 
26  * FEATURES
27  * -- VIP
28  * Don't want to wait? Up your position in the list to penult place. Fee is 10% of league deposit and it is allowed once per 10 minutes.
29  * -- TIMER & AUTO RESET
30  * Timer is set for 24 hours. When it's up, queue drops and league starts over 
31  * from the beginning. Every +100 new users in the list decrease remaining 
32  * time by half. This is automated!
33  * -- LUCKY CHANCE
34  * When someone UP first time, he gives an amazing chance to the last one 
35  * shift to his place at regular queue
36  * -- JACKPOT ON RESET 
37  * Any ETH stored at contract transfers to the latest VIP as a bonus
38  * 
39  * GAS LIMITS
40  * Dealing with arrays in Solidity is a pain.
41  * Set gas limit to 300000
42  * In the wild it uses 160k-230k, but anyway set it to 300k (unused gas will refund)
43  * 
44  */
45 
46 contract XKnockoutWhale2 {
47     
48   using SafeMath for uint256;
49 
50   struct EntityStruct {
51     bool active;
52     bool vip;
53     uint listPointer;
54     uint256 date;
55     uint256 update;
56     uint256 exit;
57     uint256 profit;
58   }
59   
60   mapping(address => EntityStruct) public entityStructs;
61   address[] public entityList;
62   address[] public vipList;
63   address dev;
64   uint256 base = 3000000000000000000; //base is 3 ETH
65   uint256 public startedAt = now; //every new deposit updates start timetoRegular
66   uint256 public timeRemaining = 24 hours; //every +100 users in queue half decrease timeRemaining
67   uint256 public devreward; //buy me a coffee
68   uint public round = 1; //when time is up, contract will reset automatically to next round
69   uint public shift = 0; //regular queue shift
70   uint public joined = 0; //stats
71   uint public exited = 0; //stats
72   bool public timetoRegular = true; //flag to switch queue
73   
74   constructor() public {
75      dev = msg.sender;
76   }
77   
78   function() public payable {
79     if(!checkRemaining()) { 
80         if(msg.value == base) {
81             addToList();
82         } else if(msg.value == base.div(10)) {
83             up();
84         } else {
85             revert("Send 3 ETH to join the list or 0.3 ETH to up");
86         }   
87     }
88   }
89   
90   function addToList() internal {
91       if(entityStructs[msg.sender].active) revert("You are already in the list");
92       
93       newEntity(msg.sender, true);
94       joined++;
95 	  startedAt = now;
96       entityStructs[msg.sender].date = now;
97       entityStructs[msg.sender].profit = 0;
98       entityStructs[msg.sender].update = 0;
99       entityStructs[msg.sender].exit = 0;
100       entityStructs[msg.sender].active = true;
101       entityStructs[msg.sender].vip = false;
102       
103       /* EXIT */
104     
105       if(timetoRegular) {   
106         //Regular exit
107         entityStructs[entityList[shift]].profit += base;
108         if(entityStructs[entityList[shift]].profit == 2*base) {
109             exitREG();
110         }
111       } else {
112         //VIP exit
113         uint lastVIP = lastVIPkey();
114         entityStructs[vipList[lastVIP]].profit += base;
115           if(entityStructs[vipList[lastVIP]].profit == 2*base) {
116               exitVIP(vipList[lastVIP]);
117           }     
118       }
119   }
120   
121   function up() internal {
122       if(joined.sub(exited) < 3) revert("You are too alone to up");
123       if(!entityStructs[msg.sender].active) revert("You are not in the list");
124       if(entityStructs[msg.sender].vip && (now.sub(entityStructs[msg.sender].update)) < 600) revert ("Up allowed once per 10 min");
125       
126       if(!entityStructs[msg.sender].vip) {
127           
128           /*
129            * When somebody UP first time, he gives an amazing chance to the last one in the list
130            * shift to his place at regular queue
131            */
132            
133             uint rowToDelete = entityStructs[msg.sender].listPointer;
134             address keyToMove = entityList[entityList.length-1];
135             entityList[rowToDelete] = keyToMove;
136             entityStructs[keyToMove].listPointer = rowToDelete;
137             entityList.length--;
138            
139            //Add to VIP
140            entityStructs[msg.sender].update = now;
141            entityStructs[msg.sender].vip = true;
142            newVip(msg.sender, true);
143            
144            devreward += msg.value; //goes to marketing
145            
146       } else if (entityStructs[msg.sender].vip) {
147           
148           //User up again
149           entityStructs[msg.sender].update = now;
150           delete vipList[entityStructs[msg.sender].listPointer];
151           newVip(msg.sender, true);
152           devreward += msg.value; //goes to marketing
153       }
154   }
155 
156   function newEntity(address entityAddress, bool entityData) internal returns(bool success) {
157     entityStructs[entityAddress].active = entityData;
158     entityStructs[entityAddress].listPointer = entityList.push(entityAddress) - 1;
159     return true;
160   }
161 
162   function exitREG() internal returns(bool success) {
163     entityStructs[entityList[shift]].active = false;
164     entityStructs[entityList[shift]].exit = now;
165     entityList[shift].transfer( entityStructs[entityList[shift]].profit.mul(90).div(100) );
166     devreward += entityStructs[entityList[shift]].profit.mul(10).div(100);
167     exited++;
168     delete entityList[shift];
169     shift++;
170     //Switch queue to vip
171     if(lastVIPkey() != 9999) {
172      timetoRegular = false;
173     }
174     return true;
175   }
176 
177   function newVip(address entityAddress, bool entityData) internal returns(bool success) {
178     entityStructs[entityAddress].vip = entityData;
179     entityStructs[entityAddress].listPointer = vipList.push(entityAddress) - 1;
180     return true;
181   }
182 
183   function exitVIP(address entityAddress) internal returns(bool success) {
184     uint lastVIP = lastVIPkey();
185     entityStructs[vipList[lastVIP]].active = false;
186     entityStructs[vipList[lastVIP]].exit = now;
187     vipList[lastVIP].transfer( entityStructs[vipList[lastVIP]].profit.mul(90).div(100) );
188     devreward += entityStructs[vipList[lastVIP]].profit.mul(10).div(100);
189     //Supa dupa method to deal with arrays ^_^ 
190     uint rowToDelete = entityStructs[entityAddress].listPointer;
191     address keyToMove = vipList[vipList.length-1];
192     vipList[rowToDelete] = keyToMove;
193     entityStructs[keyToMove].listPointer = rowToDelete;
194     vipList.length--;
195     exited++;
196     //Switch queue to regular
197     timetoRegular = true;
198     return true;
199   }
200   
201     function lastREGkey() public constant returns(uint) {
202         if(entityList.length == 0) return 9999;
203         if(shift == entityList.length) return 9999; //empty reg queue
204         
205         uint limit = entityList.length-1;
206         for(uint l=limit; l >= 0; l--) {
207             if(entityList[l] != address(0)) {
208                 return l;
209             } 
210         }
211         return 9999;
212     }
213   
214   function lastVIPkey() public constant returns(uint) {
215         if(vipList.length == 0) return 9999;
216         uint limit = vipList.length-1;
217         for(uint j=limit; j >= 0; j--) {
218             if(vipList[j] != address(0)) {
219                 return j;
220             } 
221         }
222         return 9999;
223     }
224   
225   function checkRemaining() public returns (bool) {
226       /* If time has come, reset the contract
227        * It's public because of possible gas issues, but nothing can happen
228        * while now < timeRemaining.add(startedAt)
229        */
230       if(now >= timeRemaining.add(startedAt)) {
231         //Killing VIP struct
232         if(lastVIPkey() != 9999) {
233             uint limit = vipList.length-1;
234             for(uint l=limit; l >= 0; l--) {
235                 if(vipList[l] != address(0)) {
236                     entityStructs[vipList[l]].active = false;
237                     entityStructs[vipList[l]].vip = false;
238                     entityStructs[vipList[l]].date = 0;
239                 }
240                 if(l == 0) break;
241             }
242         }
243         //Killing Regular struct
244         if(lastREGkey() != 9999) {
245             for(uint r = shift; r <= entityList.length-1; r++) {
246                 entityStructs[entityList[r]].active = false;
247                 entityStructs[entityList[r]].date = 0;
248             }
249         }
250         //Buy me a coffee
251         rewardDev();
252         //If any ETH stored at contract, send it to latest VIP as a bonus
253         if(address(this).balance.sub(devreward) > 0) {
254             if(lastVIPkey() != 9999) {
255                 vipList[lastVIPkey()].transfer(address(this).balance);
256             }
257         }
258         //Switch vars to initial state
259         vipList.length=0;
260         entityList.length=0;
261         shift = 0;
262         startedAt = now;
263         timeRemaining = 24 hours;
264         timetoRegular = true;
265         exited = joined = 0;
266         round++;
267         return true;
268       }
269       
270       //Decrease timeRemaining: every 100 users in queue divides it by half 
271       uint range = joined.sub(exited).div(100);
272       if(range != 0) {
273         timeRemaining = timeRemaining.div(range.mul(2));  
274       } 
275       return false;
276   }    
277   
278   function rewardDev() public {
279       //No one can modify devreward constant, it's safe from manipulations
280       dev.transfer(devreward);
281       devreward = 0;
282   }  
283   
284   function queueVIP() public view returns (address[]) {
285       //Return durty queue
286       return vipList;
287   }
288   
289   function queueREG() public view returns (address[]) {
290       //Return durty queue
291       return entityList;
292   }
293 }
294 
295 library SafeMath {
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         if (a == 0) {
298             return 0;
299         }
300         uint256 c = a * b;
301         assert(c / a == b);
302         return c;
303     }
304 
305     function div(uint256 a, uint256 b) internal pure returns (uint256) {
306         // assert(b > 0); // Solidity automatically throws when dividing by 0
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309         return c;
310     }
311 
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         assert(b <= a);
314         return a - b;
315     }
316 
317     function add(uint256 a, uint256 b) internal pure returns (uint256) {
318         uint256 c = a + b;
319         assert(c >= a);
320         return c;
321     }
322     
323    /* 
324     * Message to other devs:
325     * Dealing with arrays in Solidity is a pain. Here we realized some supa dupa methods
326     * and decreased gas limit up to 220k. 
327     * Lame auditors who can't understand the code, ping me at Discord.
328     * IF YOU RIP THIS CODE YOU WILL DIE WITH CANCER
329     */
330 }
1 pragma solidity ^0.4.24;
2 
3 /***
4  *     ____ _  _    __ _ __ _  __   ___ __ _ __  _  _ ____ 
5  *    (___ ( \/ )  (  / (  ( \/  \ / __(  / /  \/ )( (_  _)
6  *     / __/)  (    )  (/    (  O ( (__ )  (  O ) \/ ( )(  
7  *    (____(_/\_)  (__\_\_)__)\__/ \___(__\_\__/\____/(__) 
8  * 
9  *                         HAMSTER LEAGUE
10  *                     
11  *                     https://2Xknockout.me
12  * 
13  * Community:
14  * https://discord.gg/GKHnMBs
15  * http://t.me/Knockout2x
16  * 
17  */
18 
19 contract XKnockoutHamster {
20     
21   using SafeMath for uint256;
22 
23   struct EntityStruct {
24     bool active;
25     bool vip;
26     uint listPointer;
27     uint256 date;
28     uint256 update;
29     uint256 exit;
30     uint256 profit;
31   }
32   
33   mapping(address => EntityStruct) public entityStructs;
34   address[] public entityList;
35   address[] public vipList;
36   address dev;
37   uint256 base = 100000000000000000; //base is 0.1 ETH
38   uint256 public startedAt = now; //every new deposit updates start timetoRegular
39   uint256 public timeRemaining = 24 hours; //every +100 users in queue half decrease timeRemaining
40   uint256 public devreward; //buy me a coffee
41   uint public round = 1; //when time is up, contract resets automatically to next round
42   uint public shift = 0; //regular queue shift
43   uint public joined = 0; //stats
44   uint public exited = 0; //stats
45   bool public timetoRegular = true; //flag to switch queue
46   
47   constructor() public {
48      dev = msg.sender;
49   }
50   
51   function() public payable {
52     if(checkRemaining()) { msg.sender.transfer(msg.value); 
53     } else {
54         if(msg.value == base) {
55             addToList();
56         } else if(msg.value == base.div(10)) {
57             up();
58         } else {
59             revert("You should send 0.1 ETH to join the list or 0.01 ETH to up");
60         }   
61     }
62   }
63   
64   function addToList() internal {
65       if(entityStructs[msg.sender].active) revert("You are already in the list");
66       
67       newEntity(msg.sender, true);
68       joined++;
69 	  startedAt = now;
70       entityStructs[msg.sender].date = now;
71       entityStructs[msg.sender].profit = 0;
72       entityStructs[msg.sender].update = 0;
73       entityStructs[msg.sender].exit = 0;
74       entityStructs[msg.sender].active = true;
75       entityStructs[msg.sender].vip = false;
76     
77       if(timetoRegular) {
78         //Regular queue  
79         entityStructs[entityList[shift]].profit += base;
80           if(entityStructs[entityList[shift]].profit == 2*base) {
81               entityStructs[entityList[shift]].active = false;
82               entityStructs[entityList[shift]].exit = now;
83               entityList[shift].transfer( entityStructs[entityList[shift]].profit.mul(90).div(100) );
84               devreward += entityStructs[entityList[shift]].profit.mul(10).div(100);
85               exitREG();
86               exited++;
87               //Switch queue to vip
88               if(lastVIPkey() != 9999) {
89                   if(vipList[lastVIPkey()] != address(0)) timetoRegular = false;
90               }
91           }
92 
93       } else if (!timetoRegular) {
94         //VIP queue
95         uint lastVIP = lastVIPkey();
96         entityStructs[vipList[lastVIP]].profit += base;
97           if(entityStructs[vipList[lastVIP]].profit == 2*base) {
98               entityStructs[vipList[lastVIP]].active = false;
99               entityStructs[vipList[lastVIP]].exit = now;
100               vipList[lastVIP].transfer( entityStructs[vipList[lastVIP]].profit.mul(90).div(100) );
101               devreward += entityStructs[vipList[lastVIP]].profit.mul(10).div(100);
102               exitVIP(vipList[lastVIP]);
103               exited++;
104               //Switch queue to regular
105               timetoRegular = true;
106           }     
107       }
108   }
109   
110   function up() internal {
111       if(joined.sub(exited) < 3) revert("You are too alone to up");
112       if(!entityStructs[msg.sender].active) revert("You are not in the list");
113       if(entityStructs[msg.sender].vip && (now.sub(entityStructs[msg.sender].update)) < 600) revert ("Up allowed once per 10 min");
114       
115       if(!entityStructs[msg.sender].vip) {
116           
117           /*
118            * When somebody UP first time, he gives an amazing chance to last one in the list
119            * shift to his place at regular queue
120            */
121            
122             uint rowToDelete = entityStructs[msg.sender].listPointer;
123             address keyToMove = entityList[entityList.length-1];
124             entityList[rowToDelete] = keyToMove;
125             entityStructs[keyToMove].listPointer = rowToDelete;
126             entityList.length--;
127            
128            //Add to VIP
129            entityStructs[msg.sender].update = now;
130            entityStructs[msg.sender].vip = true;
131            newVip(msg.sender, true);
132            
133            devreward += msg.value; //goes to marketing
134            
135       } else if (entityStructs[msg.sender].vip) {
136           
137           //User up again
138           entityStructs[msg.sender].update = now;
139           delete vipList[entityStructs[msg.sender].listPointer];
140           newVip(msg.sender, true);
141           devreward += msg.value; //goes to marketing
142       }
143   }
144 
145   function newEntity(address entityAddress, bool entityData) internal returns(bool success) {
146     entityStructs[entityAddress].active = entityData;
147     entityStructs[entityAddress].listPointer = entityList.push(entityAddress) - 1;
148     return true;
149   }
150 
151   function exitREG() internal returns(bool success) {
152     delete entityList[shift];
153     shift++;
154     return true;
155   }
156   
157   function getVipCount() public constant returns(uint entityCount) {
158     return vipList.length;
159   }
160 
161   function newVip(address entityAddress, bool entityData) internal returns(bool success) {
162     entityStructs[entityAddress].vip = entityData;
163     entityStructs[entityAddress].listPointer = vipList.push(entityAddress) - 1;
164     return true;
165   }
166 
167   function exitVIP(address entityAddress) internal returns(bool success) {
168     //Supa dupa method to deal with arrays ^_^ 
169     uint rowToDelete = entityStructs[entityAddress].listPointer;
170     address keyToMove = vipList[vipList.length-1];
171     vipList[rowToDelete] = keyToMove;
172     entityStructs[keyToMove].listPointer = rowToDelete;
173     vipList.length--;
174     return true;
175   }
176   
177   function lastVIPkey() public constant returns(uint) {
178     //Dealing with arrays in Solidity is painful x_x
179     if(vipList.length == 0) return 9999;
180     uint limit = vipList.length-1;
181     for(uint l=limit; l >= 0; l--) {
182         if(vipList[l] != address(0)) {
183             return l;
184         } 
185     }
186     return 9999;
187   }
188   
189   function lastREG() public view returns (address) {
190      return entityList[shift];
191   }
192   
193   function lastVIP() public view returns (address) {
194       //Dealing with arrays in Solidity is painful x_x
195       if(lastVIPkey() != 9999) {
196         return vipList[lastVIPkey()];
197       }
198       return address(0);
199   }
200   
201   function checkRemaining() public returns (bool) {
202       /* If time has come, reset the contract
203        * It's public because of possible gas issues, but nothing can happen
204        * while now < timeRemaining.add(startedAt)
205        */
206       if(now >= timeRemaining.add(startedAt)) {
207         //Killing VIP struct
208         if(vipList.length > 0) {
209             uint limit = vipList.length-1;
210             for(uint l=limit; l >= 0; l--) {
211                 if(vipList[l] != address(0)) {
212                     entityStructs[vipList[l]].active = false;
213                     entityStructs[vipList[l]].vip = false;
214                     entityStructs[vipList[l]].date = 0;
215                 } 
216             }
217         }
218         //Killing Regular struct
219         if(shift < entityList.length-1) {
220             for(uint r = shift; r < entityList.length-1; r++) {
221                 entityStructs[entityList[r]].active = false;
222                 entityStructs[entityList[r]].date = 0;
223             }
224         }
225         //Buy me a coffee
226         rewardDev();
227         //If any ETH stored at contract, send it to latest VIP as a bonus
228         if(address(this).balance.sub(devreward) > 0) {
229             if(lastVIPkey() != 9999) {
230                 vipList[lastVIPkey()].transfer(address(this).balance);
231             }
232         }
233         //Switch vars to initial state
234         vipList.length=0;
235         entityList.length=0;
236         shift = 0;
237         startedAt = now;
238         timeRemaining = 24 hours;
239         timetoRegular = true;
240         round++;
241         return true;
242       }
243       
244       //Decrease timeRemaining: every 100 users in queue divides it by half 
245       uint range = joined.sub(exited).div(100);
246       if(range != 0) {
247         timeRemaining = timeRemaining.div(range.mul(2));  
248       } 
249       return false;
250   }    
251   
252   function rewardDev() public {
253       //No one can modify devreward constant, it's safe from manipulations
254       dev.transfer(devreward);
255       devreward = 0;
256   }  
257   
258   function queueVIP() public view returns (address[]) {
259       //Return durty queue
260       return vipList;
261   }
262   
263   function queueREG() public view returns (address[]) {
264       //Return durty queue
265       return entityList;
266   }
267 }
268 
269 library SafeMath {
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         if (a == 0) {
272             return 0;
273         }
274         uint256 c = a * b;
275         assert(c / a == b);
276         return c;
277     }
278 
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         // assert(b > 0); // Solidity automatically throws when dividing by 0
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283         return c;
284     }
285 
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         assert(b <= a);
288         return a - b;
289     }
290 
291     function add(uint256 a, uint256 b) internal pure returns (uint256) {
292         uint256 c = a + b;
293         assert(c >= a);
294         return c;
295     }
296     
297    /* 
298     * Message to other devs:
299     * Dealing with arrays in Solidity is a pain. Here we realized some supa dupa methods
300     * and decreased gas limit up to 200k. 
301     * Lame auditors who can't understand the code, ping me at Discord.
302     * IF YOU RIP THIS CODE YOU WILL DIE WITH CANCER
303     */
304 }
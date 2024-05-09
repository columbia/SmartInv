1 /*
2 * The "Become a Billionaire" decentralized Raffle v1.0, Main-Net Release.
3 * ~by Gluedog 
4 * -----------
5 * 
6 * Compiler version: 0.4.19+commit.c4cbbb05.Emscripten.clang
7 * 
8 * The weekly Become a Billionaire decentralized raffle is the basis of the deflationary mechanism for Billionaire Token
9 * ---------------------------------------------------------------------------------------------------------------------
10 * Every week, users can register 10 XBL to an Ethereum Smart Contract address – this is the equivalent of buying one ticket,
11 *     more tickets mean a better chance to win. Users can buy an unlimited number of tickets to increase their chances.
12 *     At the end of the week, the Smart Contract will choose three winners at random. First place will get 40% of
13 *     the tokens  that were raised during that week, second place gets 20% and third place gets 10%.
14 *     From the remaining 30% of the tokens: 10% are burned – as an offering to the market gods. The other 20% are sent
15 *     to another Smart Contract Address that works like a twisted faucet – rewarding people for burning their own coins.
16 * 
17 * The Become a Billionaire raffle Smart Contract will run forever, and will have an internal timer that will reset
18 *     itself every seven days or after there have been 256 tickets registered to the Raffle. The players are registered
19 *     by creating an internal mapping, inside the Smart Contract, a mapping of every address that registers tokens to 
20 *     it and their associated number of tickets. This mapping is reset every time the internal timer resets (every seven days).
21 */
22 
23 pragma solidity ^0.4.8;
24 contract XBL_ERC20Wrapper
25 {
26     function transferFrom(address from, address to, uint value) returns (bool success);
27     function transfer(address _to, uint _value) returns (bool success);
28     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
29     function burn(uint256 _value) returns (bool success);
30     function balanceOf(address _owner) constant returns (uint256 balance);
31     function totalSupply() constant returns (uint256 total_supply);
32 }
33 
34 contract BillionaireTokenRaffle
35 {
36     address private winner1;
37     address private winner2;
38     address private winner3;
39 
40     address public XBLContract_addr;
41     address public burner_addr;
42     address public raffle_addr;
43     address private owner_addr;
44 
45     address[] private raffle_bowl; /* Holds ticket entries */
46     address[] private participants;
47     uint256[] private seeds;
48 
49     uint64 public unique_players; /* Unique number of addresses registered in a week */
50     uint256 public total_burned_by_raffle;
51     uint256 public next_week_timestamp;
52     uint256 private minutes_in_a_week = 10080;
53     uint256 public raffle_balance;
54     uint256 public ticket_price;
55     uint256 public current_week;
56     uint256 public total_supply;
57     /* Initiate the XBL token wrapper */
58     XBL_ERC20Wrapper private ERC20_CALLS;
59 
60     mapping(address => uint256) public address_to_tickets; /* Will be made private after open beta is finished. */
61     mapping(address => uint256) public address_to_tokens_prev_week0; /* Variables which will be made public  */
62     mapping(address => uint256) public address_to_tokens_prev_week1; /*  after each week's raffle has ended */
63 
64     uint8 public prev_week_ID; /* Keeps track of which variable is the correct indicator of prev week mapping
65                                     Can only be [0] or [1]. */
66     address public lastweek_winner1;
67     address public lastweek_winner2;
68     address public lastweek_winner3;
69 
70     /* Init */
71     function BillionaireTokenRaffle()
72     {
73         /* Billionaire Token contract address */
74         XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;
75         ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);
76         total_supply = ERC20_CALLS.totalSupply();
77         ticket_price = 10000000000000000000; /* 10 XBL  */
78         raffle_addr = address(this); /* Own address                              */
79         owner_addr = msg.sender; /* Set the owner address as the initial sender */
80         next_week_timestamp = now + minutes_in_a_week * 1 minutes; /* Will get set every time resetRaffle() is called */
81     }
82 
83     /* A modifier that can be applied to functions to only allow the owner to execute them.       */
84     /* This is very useful in cases where one would like to upgrade the deflationary algorithm.   */
85     /* We can simply use setter functions on the "Burner address",                                */
86     /* so that if we update the Burner, we can just point the Raffle to the new version of it.    */
87     modifier onlyOwner()
88     {
89         require (msg.sender == owner_addr);
90         _;
91     }
92 
93     modifier onlyBurner()
94     {
95         require(msg.sender == burner_addr);
96         _;
97     }
98 
99     /* <<<--- Burner accesible functions --->>> */
100     /* <<<--- Burner accesible functions --->>> */
101     /* <<<--- Burner accesible functions --->>> */
102 
103     function getLastWeekStake(address user_addr) public onlyBurner returns (uint256 last_week_stake)
104     {   /* The burner accesses this function to retrieve each player's stake from the previous week. */
105         if (prev_week_ID == 0)
106             return address_to_tokens_prev_week1[user_addr];
107         if (prev_week_ID == 1)
108             return address_to_tokens_prev_week0[user_addr];
109     }
110 
111     function reduceLastWeekStake(address user_addr, uint256 amount) public onlyBurner
112     {   /* After a succesful burn, the burner will call this function and reduce the player's last_week_stake. */
113         if (prev_week_ID == 0)
114             address_to_tokens_prev_week1[user_addr] -= amount;
115         if (prev_week_ID == 1)
116             address_to_tokens_prev_week0[user_addr] -= amount;
117     }
118 
119     /* <<<--- Public utility functions --->>> */
120     /* <<<--- Public utility functions --->>> */
121     /* <<<--- Public utility functions --->>> */
122 
123     function registerTickets(uint256 number_of_tickets) public returns (int8 registerTickets_STATUS)
124     {
125         /*  registerTickets RETURN CODES:
126 
127             [-6] - Raffle still has tickets after fillBurner() called 
128             [-5] - fillBurner() null burner addr, raised error
129             [-4] - fillWeeklyArrays() prev_week_ID invalid value, raised error.
130             [-3] - getWinners() fail, raised error.
131             [-2] - ACTUAL ALLOWANCE CHECK MISMATCH.
132             [-1] - INVALID INPUT (zero or too many tickets).
133             [0 ] - REGISTERED OK.                                   */
134 
135         /* Check the ticket amount limit (256 max) */
136         if (raffle_bowl.length > 256)
137         {
138             next_week_timestamp = now;
139         }
140 
141         /* Check the time limit, one week is max. */
142         if (now >= next_week_timestamp)
143         {
144             int8 RAFFLE_STATUS = resetRaffle();
145             /* Error checks */
146             if (RAFFLE_STATUS == -2)
147                 return -3; /* getWinners() errored, raise it! */
148 
149             if (RAFFLE_STATUS == -3)
150                 return -5; /* fillBurner() errored, raise it! */
151 
152             if (RAFFLE_STATUS == -4)
153                 return -6; /* Raffle still has tickets after fillBurner() called */
154         }
155         /* Before users will call registerTickets function,they will first have to call approve()    */
156         /* on the XBL contract address and approve the Raffle to spend tokens on their behalf.      */
157         /* After they have called approve, they will have to call this registerTickets() function  */
158 
159         if ( (number_of_tickets == 0) || (number_of_tickets > 5) || (address_to_tickets[msg.sender] >= 5) )
160             return -1; /* Invalid Input */
161 
162         if (ERC20_CALLS.allowance(msg.sender, raffle_addr) < ticket_price * number_of_tickets)
163             return -2; /* Allowance check mismatch */
164 
165         if (ERC20_CALLS.balanceOf(msg.sender) < ticket_price * number_of_tickets) 
166             return - 2; /* Allowance check mismatch */
167 
168         /*  Reaching this point means the ticket registrant is legit  */
169         /*  Every ticket will add an entry to the raffle_bowl         */
170         if (fillWeeklyArrays(number_of_tickets, msg.sender) == -1)
171             return -4; /* prev_week_ID invalid value */
172 
173         else
174         {   /* Everything checks out, transfer the coins from the user to the Raffle */
175             ERC20_CALLS.transferFrom(msg.sender, raffle_addr, number_of_tickets * ticket_price);
176             return 0; 
177         }
178     }
179 
180     /* <<<--- Owner functions --->>> */
181     /* <<<--- Owner functions --->>> */
182     /* <<<--- Owner functions --->>> */
183 
184     function setBurnerAddress(address _burner_addr) public onlyOwner
185     {
186         burner_addr = _burner_addr;
187     }
188 
189     function setTicketPrice(uint256 _ticket_price) public onlyOwner
190     {
191         ticket_price = _ticket_price;
192     }
193 
194     function setOwnerAddr(address _owner_addr) public onlyOwner
195     {
196         owner_addr = _owner_addr;
197     }
198 
199     /* <<<--- Internal functions --->>> */
200     /* <<<--- Internal functions --->>> */
201     /* <<<--- Internal functions --->>> */
202 
203     function getPercent(uint8 percent, uint256 number) private returns (uint256 result)
204     {
205         return number * percent / 100;
206     }
207 
208     function getRand(uint256 upper_limit) private returns (uint256 random_number)
209     {
210         return uint(sha256(uint256(block.blockhash(block.number-1)) * uint256(sha256(msg.sender)))) % upper_limit;
211     }
212     
213     function getRandWithSeed(uint256 upper_limit, uint seed) private returns (uint256 random_number)
214     {
215         return seed % upper_limit;
216     }
217 
218     function resetWeeklyVars() private returns (bool success)
219     {   /*  After the weekly vars have been been reset, the player that last
220             registered (if this gets called from registerTickets()) will have
221             to have his tickets added to next week's Raffle Bowl.               */
222 
223         total_supply = ERC20_CALLS.totalSupply();
224 
225         /* Clear everything. */
226         for (uint i = 0; i < participants.length; i++)
227         {
228             address_to_tickets[participants[i]] = 0;
229 
230             /* Clear the opposite of whatever prev_week_ID is */
231             if (prev_week_ID == 0)
232                 address_to_tokens_prev_week1[participants[i]] = 0;
233             if (prev_week_ID == 1)
234                 address_to_tokens_prev_week0[participants[i]] = 0;
235         }
236 
237         seeds.length = 0;
238         raffle_bowl.length = 0;
239         participants.length = 0;
240         unique_players = 0;
241         
242         lastweek_winner1 = winner1;
243         lastweek_winner2 = winner2;
244         lastweek_winner3 = winner3;
245         winner1 = 0x0;
246         winner2 = 0x0;
247         winner3 = 0x0;
248         
249         prev_week_ID++;
250         if (prev_week_ID == 2)
251             prev_week_ID = 0;
252 
253         return success;
254     }
255 
256     function resetRaffle() private returns (int8 resetRaffle_STATUS)
257     {
258         /*  resetRaffle STATUS CODES:
259 
260             [-5] - burnTenPercent() error            
261             [-4] - Raffle still has tokens after fillBurner().
262             [-3] - fillBurner() error.
263             [-2] - getWinners() error.
264             [-1] - We have no participants.
265             [0 ] - ALL OK.
266             [1 ] - Only one player, was refunded.
267             [2 ] - Two players, were refunded.
268             [3 ] - Three players, refunded.            */
269 
270         while (now >= next_week_timestamp)
271         {
272             next_week_timestamp += minutes_in_a_week * 1 minutes;
273             current_week++;
274         }
275 
276         if (raffle_bowl.length == 0)
277         {   /*   We have no registrants.  */
278             /* Reset the stats and return */
279             resetWeeklyVars(); 
280             return -1;
281         }
282 
283         if (unique_players < 4)
284         {   /* We have between 1 and three players in the raffle */
285             for (uint i = 0; i < raffle_bowl.length; i++)
286             { /* Refund their tokens */ 
287                 if (address_to_tickets[raffle_bowl[i]] != 0)
288                 {
289                     ERC20_CALLS.transfer(raffle_bowl[i], address_to_tickets[raffle_bowl[i]] * ticket_price);
290                     address_to_tickets[raffle_bowl[i]] = 0;
291                 }
292             }
293             /* Reset variables. */
294             resetWeeklyVars();
295             /* Return 1, 2 or 3 depending on how many raffle players were refunded */
296             return int8(unique_players);
297         }
298         /* At this point we assume that we have more than three unique players */
299         getWinners(); /* Choose three winners */
300 
301         /* Do we have winners? */
302         if ( (winner1 == 0x0) || (winner2 == 0x0) || (winner3 == 0x0) )
303             return -2;
304 
305         /* We have three winners! Proceed with rewards */
306         raffle_balance = ERC20_CALLS.balanceOf(raffle_addr);
307 
308         /* Transfer 40%, 20% and 10% of the tokens to their respective winners */ 
309         ERC20_CALLS.transfer(winner1, getPercent(40, raffle_balance));
310         ERC20_CALLS.transfer(winner2, getPercent(20, raffle_balance));
311         ERC20_CALLS.transfer(winner3, getPercent(10, raffle_balance));
312         /* Burn 10% */
313         if (burnTenPercent(raffle_balance) != true)
314             return -5;
315 
316         /* Fill the burner with the rest of the tokens. */
317         if (fillBurner() == -1)
318             return -3; /* Burner addr NULL | error */ 
319 
320         /* Reset variables. */
321         resetWeeklyVars();
322 
323         if (ERC20_CALLS.balanceOf(raffle_addr) > 0)
324             return -4; /* We still have a positive balance | error */
325 
326         return 0; /* Everything OK */
327     }
328 
329     function getWinners() private returns (int8 getWinners_STATUS)
330     {
331         /* Acquire the first random number using previous blockhash as an initial seed. */
332         uint initial_rand = getRand(seeds.length);
333 
334         /* Use this first random number to choose one of the seeds from the array. */
335         uint firstwinner_rand = getRandWithSeed(seeds.length, seeds[initial_rand]);
336 
337         /* This new random number is used to grab the first winner's index from raffle_bowl. */
338         winner1 = raffle_bowl[firstwinner_rand];
339 
340         /* Find the position of winner1 in participants[] */
341         for (uint16 i = 0; i < participants.length; i++)
342         {
343             if (participants[i] == winner1)
344             {
345                 uint16 winner1_index = i;
346                 break;
347             }
348         }
349 
350         /* Then choose two more winners, based on the initial position of winner1, looping over participants[] now. */
351         if (winner1_index+1 >= participants.length)
352         {
353             winner2 = participants[0];
354             winner3 = participants[1];
355 
356             return 0;
357         }
358 
359         if (winner1_index+2 >= participants.length)
360         {
361             winner2 = participants[winner1_index+1];
362             winner3 = participants[0];
363 
364             return 0;
365         }
366 
367         winner2 = participants[winner1_index+1];
368         winner3 = participants[winner1_index+2];
369 
370         return 0;
371     }
372 
373     function fillBurner() private returns (int8 fillBurner_STATUS)
374     {
375         /* [-1]: Burner Address NULL
376         *  [ 0]: OK
377         */
378         if (burner_addr == 0x0)
379             return -1;
380 
381         ERC20_CALLS.transfer(burner_addr, ERC20_CALLS.balanceOf(raffle_addr));
382         return 0;
383     }
384 
385     function fillWeeklyArrays(uint256 number_of_tickets, address user_addr) private returns (int8 fillWeeklyArrays_STATUS)
386     {
387         /*  [-1] Error with prev_week_ID
388         *   [0]  OK                        */
389 
390         if ((prev_week_ID != 0) && (prev_week_ID != 1))
391             return -1;
392 
393         /* Record unique players. */
394         if (address_to_tickets[user_addr] == 0)
395         {
396             unique_players++;
397             participants.push(user_addr);
398         }
399 
400         address_to_tickets[user_addr] += number_of_tickets;
401         
402         if (prev_week_ID == 0)
403             address_to_tokens_prev_week0[user_addr] += number_of_tickets * ticket_price;
404         if (prev_week_ID == 1)
405             address_to_tokens_prev_week1[user_addr] += number_of_tickets * ticket_price;
406 
407         uint256 _ticket_number = number_of_tickets;
408         while (_ticket_number > 0)
409         {
410             raffle_bowl.push(user_addr);
411             _ticket_number--;
412         }
413         /* Capture a seed from the user. */
414         seeds.push(uint(sha256(user_addr)) * uint(sha256(now)));
415 
416         return 0;
417     }
418 
419     function burnTenPercent(uint256 raffle_balance) private returns (bool success_state)
420     {
421         uint256 amount_to_burn = getPercent(10, raffle_balance);
422         total_burned_by_raffle += amount_to_burn;
423         /* Burn the coins, return success state */
424         if (ERC20_CALLS.burn(amount_to_burn) == true)
425             return true;
426         else
427             return false;
428     }
429 
430     /* <<<--- Debug ONLY functions --->>> */
431     /* <<<--- Debug ONLY functions --->>> */
432     /* <<<--- Debug ONLY functions --->>> */
433 
434     function dSET_XBL_ADDRESS(address _XBLContract_addr) public onlyOwner
435     {   /* These will be hardcoded in the production version. */
436         XBLContract_addr = _XBLContract_addr;
437         ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);
438         total_supply = ERC20_CALLS.totalSupply();
439     }
440 
441     function dTRIGGER_NEXTWEEK_TIMESTAMP() public onlyOwner
442     {   /* Trigger end week quicker. */
443         next_week_timestamp = now;
444     }
445 
446     function dKERNEL_PANIC() public onlyOwner
447     {   /* Out of Gas panic function. */
448         for (uint i = 0; i < raffle_bowl.length; i++)
449         { /* Refund everyone's tokens */ 
450             if (address_to_tickets[raffle_bowl[i]] != 0)
451             {
452                 ERC20_CALLS.transfer(raffle_bowl[i], address_to_tickets[raffle_bowl[i]] * ticket_price);
453                 address_to_tickets[raffle_bowl[i]] = 0;
454             }
455         }
456     }
457 }
1 pragma solidity ^0.5.7;
2 
3 contract Regatta {
4 
5     event Declare(uint race_number);
6     event Enter(uint race_number, address entrant, uint8 class, uint8 variant, bool repellent);
7 
8     event Void(uint race_number, address judge);
9     event Finish(uint race_number, uint block_finish, address judge);
10     event Rename(address boat, bytes32 name);
11     event CashOut(address winner);
12 
13     struct Race {
14         uint pool;
15 
16         uint block_start;
17         uint block_finish;
18 
19         Boat[10] boats;
20 
21         uint boat_count;
22     }
23 
24     struct Boat {
25         address owner;
26         uint8 class;
27         uint8 variant;
28         bool repellent;
29     }
30 
31 
32     mapping(address => uint) bank;
33     mapping(address => bytes32) boat_names;
34     mapping(uint => Race) races;
35 
36     address blackbeard;
37     function mutiny(address new_beard) external{
38         require(msg.sender == blackbeard,"impostor");
39         blackbeard = new_beard;
40     }
41 
42 
43 
44     uint race_number;
45     uint constant COURSE_LENGTH = 50;
46 
47     uint constant PRICE_REPELLENT = 10; //%
48 
49     uint[3] PRICE_CLASS = [
50     20 finney,
51     70 finney,
52     120 finney
53     ];
54 
55     uint[3] MULTIPLIER_CLASS = [
56     100, //%
57     115, //%
58     130 //%
59     ];
60 
61     uint constant MULTIPLIER_VARIANT = 2;
62     uint constant TIME_WAIT = 3;
63     uint constant MODULO_SQUID = 3;
64 
65     constructor() public{
66         blackbeard = msg.sender;
67     }
68 
69     function calculate_fee(uint8 class, bool repellent) internal view returns(uint){
70         if(repellent){
71             return PRICE_CLASS[class] * (100 + PRICE_REPELLENT) / 100;
72         }else{
73             return PRICE_CLASS[class];
74         }
75     }
76     function increment_boat(uint hash, uint weather, uint boatNum, uint8 class, uint variant) internal view returns(uint){
77         uint increment = uint(keccak256(abi.encodePacked(boatNum,hash)))%10 * MULTIPLIER_CLASS[class]/100;
78         if(weather == variant){
79             increment *= MULTIPLIER_VARIANT;
80         }
81         return increment;
82     }
83     function check_race_finished() view internal returns(bool){
84         if(race_number == 0){
85             return true;
86         }else{
87             return races[race_number].block_finish != 0;
88         }
89     }
90     function check_race_started() view internal returns(bool){
91         return races[ race_number ].block_start != 0 &&
92         races[ race_number ].block_start < block.number;
93     }
94 
95     //Void
96     function declare_void() public {
97         require(races[race_number].block_start != 0,"unstarted");
98         require(block.number > races[race_number].block_start + 255,"not_void");
99         require(races[race_number].block_finish == 0,"finished");
100 
101         do_declare_void();
102 
103         uint balance = bank[msg.sender];
104         bank[msg.sender] = 0;
105         msg.sender.transfer( balance );
106     }
107     //  -> set and pay
108     function do_declare_void() internal {
109         races[race_number].block_finish = races[race_number].block_start;
110 
111         bank[ blackbeard ] += races[race_number].pool * 99/100;
112         bank[ msg.sender ] += races[race_number].pool /100;
113 
114         emit Void(race_number, msg.sender);
115     }
116 
117     //Finish
118     function declare_finish(uint block_finish) external {
119         require(races[race_number].block_start != 0,"unstarted");
120         require(block_finish < block.number, "undetermined");
121         require(block.number <= races[race_number].block_start + 255,"void");
122 
123         if( races[race_number].block_finish != 0 ){
124             //Fallback and just withdraw that shit
125             uint balance = bank[msg.sender];
126             require(balance > 0, "finished");
127             bank[msg.sender] = 0;
128             msg.sender.transfer( balance );
129             emit CashOut( msg.sender );
130             return;
131         }
132 
133         do_declare_finish(block_finish);
134 
135         uint balance = bank[msg.sender];
136         bank[msg.sender] = 0;
137         msg.sender.transfer( balance );
138     }
139     //  -> set and pay
140     function do_declare_finish(uint block_finish) internal {
141         uint squid = 11;
142         uint leader;
143         uint[10] memory progress;
144         uint winners;
145 
146         bool finished;
147 
148 
149         for(uint b = races[race_number].block_start; b <= block_finish; b++){
150             uint hash = uint(blockhash(b));
151             uint weather = hash%3;
152             for(uint boat = 0; boat < races[race_number].boat_count; boat++){
153                 if(squid != boat){
154                     progress[boat] += increment_boat(
155                         hash,
156                         weather,
157                         boat,
158                         races[race_number].boats[boat].class,
159                         races[race_number].boats[boat].variant
160                     );
161                 }
162                 if(progress[boat] >= progress[leader]){
163                     leader = boat;
164                 }
165 
166                 if(b == block_finish - 1){
167                     require(progress[boat] < COURSE_LENGTH,"passed");
168                 }else if(b == block_finish){
169                     finished = finished || progress[boat] >= COURSE_LENGTH;
170                     if(progress[boat] >= COURSE_LENGTH){
171                         winners++;
172                     }
173                 }
174             }
175             if(progress[leader] < COURSE_LENGTH && progress[leader] > COURSE_LENGTH/2 && !races[race_number].boats[leader].repellent && squid == 11 &&  uint(hash)%MODULO_SQUID == 0){
176                 squid =  leader;
177             }
178         }
179 
180         require(finished,"unfinished");
181         races[race_number].block_finish = block_finish;
182 
183         uint paid = 0;
184         uint reward = races[race_number].pool * 95 / winners /100;
185         for( uint boat = 0; boat < races[race_number].boat_count; boat++){
186             if(progress[boat] >= COURSE_LENGTH){
187                 bank[
188                 races[race_number].boats[boat].owner
189                 ] += reward;
190 
191                 paid += reward;
192             }
193         }
194         bank[ msg.sender ] += races[race_number].pool /100;
195         paid += races[race_number].pool /100;
196 
197         bank[ blackbeard ] += races[race_number].pool - paid;
198 
199 
200         emit Finish(race_number, block_finish, msg.sender);
201     }
202 
203     //Declare Race
204     function declare_race(uint8 class, uint8 variant, bool repellent) public payable{
205 
206         require(races[race_number].block_finish != 0 || race_number == 0,"unfinished");
207 
208         require(class < 3,"class");
209         uint fee = calculate_fee(class,repellent);
210         uint contribution = calculate_fee(class,false);
211         require( msg.value == fee, "payment");
212         require(variant < 3,"variant");
213 
214         race_number++;
215 
216         races[race_number].boat_count = 2;
217         races[race_number].boats[0] = Boat(msg.sender,class,variant,repellent);
218         races[race_number].pool += contribution;
219 
220         if(fee > contribution){
221             bank[blackbeard] += fee - contribution;
222         }
223 
224 
225         emit Declare(race_number);
226         emit Enter(race_number, msg.sender, class, variant, repellent);
227     }
228 
229     //Enter Race
230     function enter_race(uint8 class, uint8 variant, bool repellent) public payable{
231 
232         require(class < 3,"class");
233         uint fee = calculate_fee(class,repellent);
234         uint contribution = calculate_fee(class,false);
235         require( msg.value == fee, "payment");
236         require(variant < 3,"variant");
237 
238         require(!check_race_started(),"started");
239         require(!check_race_finished(),"finished");
240 
241         require(races[race_number].boat_count < 10,"full");
242         require(race_number > 0,"undeclared");
243 
244         if(races[race_number].block_start == 0){
245             races[race_number].block_start = block.number + TIME_WAIT;
246             races[race_number].boats[1] = Boat(msg.sender,class,variant,repellent);
247         }else{
248             races[race_number].boats[
249             races[race_number].boat_count
250             ] = Boat(msg.sender,class,variant,repellent);
251             races[race_number].boat_count++;
252         }
253         races[race_number].pool += contribution;
254 
255         if(fee > contribution){
256             bank[blackbeard] += fee - contribution;
257         }
258 
259         emit Enter(race_number, msg.sender, class, variant, repellent);
260 
261     }
262 
263     //Important guys
264     function cleanup(uint block_finish_last) internal {
265         if(race_number == 0){
266             //Initial condition, skip
267         }else if(races[race_number].block_start != 0
268         && races[race_number].block_start == races[race_number].block_finish
269         ){
270             //If races[race_number].block_start == races[race_number].block_finish,
271             //it's been voided, skip
272         }else
273 
274         //If block_finish_last isn't 0
275         //&& there is an unfinished race,
276         //finish it, (pay winners)
277             if(block_finish_last != 0
278             && races[race_number].block_finish == 0
279             && races[race_number].block_start != 0
280             && races[race_number].block_start < block.number
281             && block_finish_last <  block.number
282             ){
283                 //Finish it
284                 do_declare_finish(block_finish_last);
285             }else
286 
287             //else if block_finish_last is 0
288             //&& there is a void race
289             //void it
290                 if(block_finish_last == 0
291                 && races[race_number].block_finish == 0
292                 && races[race_number].block_start != 0
293                 && races[race_number].block_start + 255 < block.number
294                 ){
295                     //Void it
296                     do_declare_void();
297                 }
298     }
299     function enter_next_race(uint block_finish_last, uint8 class, uint8 variant, bool repellent) external payable{
300         cleanup(block_finish_last);
301 
302         //if the current race is finished
303         if(races[race_number].block_finish != 0 || race_number == 0){
304             //Start new race
305             declare_race(class,variant,repellent);
306         }else{
307             //Enter next race
308             enter_race(class,variant,repellent);
309         }
310 
311 
312     }
313     function collect_winnings(uint block_finish_last) external {
314         cleanup(block_finish_last);
315 
316         grab_gold();
317     }
318 
319 
320     //Admin
321     function rename_boat(bytes32 name) external {
322         boat_names[msg.sender] = name;
323         emit Rename(msg.sender,name);
324     }
325     function grab_gold() public {
326         uint balance = bank[msg.sender];
327         require(balance > 0,"broke");
328         bank[msg.sender] = 0;
329 
330 
331         msg.sender.transfer( balance );
332         emit CashOut(msg.sender);
333     }
334 
335 
336     //Read
337     function get_pool() external view returns(uint){
338         return races[race_number].pool;
339     }
340     function get_race_number() public view returns (uint){
341         return race_number;
342     }
343     function get_weather() public view returns (uint){
344         uint hash = uint(blockhash(block.number - 1));
345         return  hash%3;
346     }
347     function get_progress() public view  returns (uint[10] memory progress, uint block_finish, uint weather, uint squid, uint block_now, bytes32[10] memory history, uint block_squid){
348         //History
349         for(uint b = 0; b < 10; b++){
350             history[b] = blockhash(b + block.number - 10 );
351         }
352 
353         if(races[race_number].block_start == 0){
354             return (progress, block_finish, 0, 11, block.number, history, 0);
355         }
356 
357         squid = 11;
358         uint leader;
359         for(uint b = races[race_number].block_start; b < block.number; b++){
360             uint hash = uint(blockhash(b));
361             weather = hash%3;
362             for(uint boat = 0; boat < races[race_number].boat_count; boat++){
363                 if(squid != boat){
364                     progress[boat] += increment_boat(
365                         hash,
366                         weather,
367                         boat,
368                         races[race_number].boats[boat].class,
369                         races[race_number].boats[boat].variant
370                     );
371                 }
372                 if(progress[boat] >= progress[leader]){
373                     leader = boat;
374                 }
375                 if(progress[boat] >= COURSE_LENGTH ){
376                     block_finish = b;
377                 }
378             }
379 
380             if(block_finish != 0){
381                 break;
382             }
383             if(
384                 progress[leader] < COURSE_LENGTH
385                 && progress[leader] > COURSE_LENGTH/2
386                 && !races[race_number].boats[leader].repellent
387             && squid == 11
388             && hash%MODULO_SQUID == 0
389             ){
390                 squid =  leader;
391                 block_squid = b;
392             }
393         }
394 
395         return (progress, block_finish, weather, squid, block.number, history, block_squid);
396     }
397 
398     function get_times() public view returns (uint block_start, uint block_finish, uint block_current){
399         return (
400         races[race_number].block_start,
401         races[race_number].block_finish,
402         block.number
403         );
404     }
405     function get_boats() public view returns (
406         address[10] memory owner,
407         uint8[10] memory class,
408         uint8[10] memory variant,
409         bool[10] memory repellent
410     ){
411         for(uint boat = 0; boat < 10; boat++){
412             owner[boat] = races[race_number].boats[boat].owner;
413             class[boat] = races[race_number].boats[boat].class;
414             variant[boat] = races[race_number].boats[boat].variant;
415             repellent[boat] = races[race_number].boats[boat].repellent;
416         }
417         return (owner,class,variant,repellent);
418     }
419 
420     function get_name(address boat) public view returns(bytes32 name){
421         return boat_names[boat];
422     }
423     function get_balance() public view returns(uint balance){
424         return bank[msg.sender];
425     }
426     function get_boat_count() public view returns(uint boat_count){
427         return races[race_number].boat_count;
428     }
429     function get_pool_past(uint past_race_number) external view returns(uint pool){
430         return races[past_race_number].pool;
431     }
432 }
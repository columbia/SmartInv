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
50     5 finney,
51     15 finney,
52     30 finney
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
69     //Added set price function in case ETH price changes make it too expensive
70     function set_PRICE_CLASS(uint class, uint PRICE) external{
71         require(msg.sender == blackbeard,"permission");
72         require(class < 3,"class");
73         PRICE_CLASS[class] = PRICE;
74     }
75 
76     function calculate_fee(uint8 class, bool repellent) internal view returns(uint){
77         if(repellent){
78             return PRICE_CLASS[class] * (100 + PRICE_REPELLENT) / 100;
79         }else{
80             return PRICE_CLASS[class];
81         }
82     }
83     function increment_boat(uint hash, uint weather, uint boatNum, uint8 class, uint variant) internal view returns(uint){
84         uint increment = uint(keccak256(abi.encodePacked(boatNum,hash)))%10 * MULTIPLIER_CLASS[class]/100;
85         if(weather == variant){
86             increment *= MULTIPLIER_VARIANT;
87         }
88         return increment;
89     }
90     function check_race_finished() view internal returns(bool){
91         if(race_number == 0){
92             return true;
93         }else{
94             return races[race_number].block_finish != 0;
95         }
96     }
97     function check_race_started() view internal returns(bool){
98         return races[ race_number ].block_start != 0 &&
99         races[ race_number ].block_start < block.number;
100     }
101 
102     //Void
103     function declare_void() public {
104         require(races[race_number].block_start != 0,"unstarted");
105         require(block.number > races[race_number].block_start + 255,"not_void");
106         require(races[race_number].block_finish == 0,"finished");
107 
108         do_declare_void();
109 
110         uint balance = bank[msg.sender];
111         bank[msg.sender] = 0;
112         msg.sender.transfer( balance );
113     }
114     //  -> set and pay
115     function do_declare_void() internal {
116         races[race_number].block_finish = races[race_number].block_start;
117 
118         bank[ blackbeard ] += races[race_number].pool * 99/100;
119         bank[ msg.sender ] += races[race_number].pool /100;
120 
121         emit Void(race_number, msg.sender);
122     }
123 
124     //Finish
125     function declare_finish(uint block_finish) external {
126         require(races[race_number].block_start != 0,"unstarted");
127         require(block_finish < block.number, "undetermined");
128         require(block.number <= races[race_number].block_start + 255,"void");
129 
130         if( races[race_number].block_finish != 0 ){
131             //Fallback and just withdraw that shit
132             uint balance = bank[msg.sender];
133             require(balance > 0, "finished");
134             bank[msg.sender] = 0;
135             msg.sender.transfer( balance );
136             emit CashOut( msg.sender );
137             return;
138         }
139 
140         do_declare_finish(block_finish);
141 
142         uint balance = bank[msg.sender];
143         bank[msg.sender] = 0;
144         msg.sender.transfer( balance );
145     }
146     //  -> set and pay
147     function do_declare_finish(uint block_finish) internal {
148         uint squid = 11;
149         uint leader;
150         uint[10] memory progress;
151         uint winners;
152 
153         bool finished;
154 
155 
156         for(uint b = races[race_number].block_start; b <= block_finish; b++){
157             uint hash = uint(blockhash(b));
158             uint weather = hash%3;
159             for(uint boat = 0; boat < races[race_number].boat_count; boat++){
160                 if(squid != boat){
161                     progress[boat] += increment_boat(
162                         hash,
163                         weather,
164                         boat,
165                         races[race_number].boats[boat].class,
166                         races[race_number].boats[boat].variant
167                     );
168                 }
169                 if(progress[boat] >= progress[leader]){
170                     leader = boat;
171                 }
172 
173                 if(b == block_finish - 1){
174                     require(progress[boat] < COURSE_LENGTH,"passed");
175                 }else if(b == block_finish){
176                     finished = finished || progress[boat] >= COURSE_LENGTH;
177                     if(progress[boat] >= COURSE_LENGTH){
178                         winners++;
179                     }
180                 }
181             }
182             if(progress[leader] < COURSE_LENGTH && progress[leader] > COURSE_LENGTH/2 && !races[race_number].boats[leader].repellent && squid == 11 &&  uint(hash)%MODULO_SQUID == 0){
183                 squid =  leader;
184             }
185         }
186 
187         require(finished,"unfinished");
188         races[race_number].block_finish = block_finish;
189 
190         uint paid = 0;
191         uint reward = races[race_number].pool * 95 / winners /100;
192         for( uint boat = 0; boat < races[race_number].boat_count; boat++){
193             if(progress[boat] >= COURSE_LENGTH){
194                 bank[
195                 races[race_number].boats[boat].owner
196                 ] += reward;
197 
198                 paid += reward;
199             }
200         }
201         bank[ msg.sender ] += races[race_number].pool /100;
202         paid += races[race_number].pool /100;
203 
204         bank[ blackbeard ] += races[race_number].pool - paid;
205 
206 
207         emit Finish(race_number, block_finish, msg.sender);
208     }
209 
210     //Declare Race
211     function declare_race(uint8 class, uint8 variant, bool repellent) public payable{
212 
213         require(races[race_number].block_finish != 0 || race_number == 0,"unfinished");
214 
215         require(class < 3,"class");
216         uint fee = calculate_fee(class,repellent);
217         uint contribution = calculate_fee(class,false);
218         require( msg.value == fee, "payment");
219         require(variant < 3,"variant");
220 
221         race_number++;
222 
223         races[race_number].boat_count = 2;
224         races[race_number].boats[0] = Boat(msg.sender,class,variant,repellent);
225         races[race_number].pool += contribution;
226 
227         if(fee > contribution){
228             bank[blackbeard] += fee - contribution;
229         }
230 
231 
232         emit Declare(race_number);
233         emit Enter(race_number, msg.sender, class, variant, repellent);
234     }
235 
236     //Enter Race
237     function enter_race(uint8 class, uint8 variant, bool repellent) public payable{
238 
239         require(class < 3,"class");
240         uint fee = calculate_fee(class,repellent);
241         uint contribution = calculate_fee(class,false);
242         require( msg.value == fee, "payment");
243         require(variant < 3,"variant");
244 
245         require(!check_race_started(),"started");
246         require(!check_race_finished(),"finished");
247 
248         require(races[race_number].boat_count < 10,"full");
249         require(race_number > 0,"undeclared");
250 
251         if(races[race_number].block_start == 0){
252             races[race_number].block_start = block.number + TIME_WAIT;
253             races[race_number].boats[1] = Boat(msg.sender,class,variant,repellent);
254         }else{
255             races[race_number].boats[
256             races[race_number].boat_count
257             ] = Boat(msg.sender,class,variant,repellent);
258             races[race_number].boat_count++;
259         }
260         races[race_number].pool += contribution;
261 
262         if(fee > contribution){
263             bank[blackbeard] += fee - contribution;
264         }
265 
266         emit Enter(race_number, msg.sender, class, variant, repellent);
267 
268     }
269 
270     //Important guys
271     function cleanup(uint block_finish_last) internal {
272         if(race_number == 0){
273             //Initial condition, skip
274         }else if(races[race_number].block_start != 0
275         && races[race_number].block_start == races[race_number].block_finish
276         ){
277             //If races[race_number].block_start == races[race_number].block_finish,
278             //it's been voided, skip
279         }else
280 
281         //If block_finish_last isn't 0
282         //&& there is an unfinished race,
283         //finish it, (pay winners)
284             if(block_finish_last != 0
285             && races[race_number].block_finish == 0
286             && races[race_number].block_start != 0
287             && races[race_number].block_start < block.number
288             && block_finish_last <  block.number
289             ){
290                 //Finish it
291                 do_declare_finish(block_finish_last);
292             }else
293 
294             //else if block_finish_last is 0
295             //&& there is a void race
296             //void it
297                 if(block_finish_last == 0
298                 && races[race_number].block_finish == 0
299                 && races[race_number].block_start != 0
300                 && races[race_number].block_start + 255 < block.number
301                 ){
302                     //Void it
303                     do_declare_void();
304                 }
305     }
306     function enter_next_race(uint block_finish_last, uint8 class, uint8 variant, bool repellent) external payable{
307         cleanup(block_finish_last);
308 
309         //if the current race is finished
310         if(races[race_number].block_finish != 0 || race_number == 0){
311             //Start new race
312             declare_race(class,variant,repellent);
313         }else{
314             //Enter next race
315             enter_race(class,variant,repellent);
316         }
317 
318 
319     }
320     function collect_winnings(uint block_finish_last) external {
321         cleanup(block_finish_last);
322 
323         grab_gold();
324     }
325 
326 
327     //Admin
328     function rename_boat(bytes32 name) external {
329         boat_names[msg.sender] = name;
330         emit Rename(msg.sender,name);
331     }
332     function grab_gold() public {
333         uint balance = bank[msg.sender];
334         require(balance > 0,"broke");
335         bank[msg.sender] = 0;
336 
337 
338         msg.sender.transfer( balance );
339         emit CashOut(msg.sender);
340     }
341 
342 
343     //Read
344     function get_pool() external view returns(uint){
345         return races[race_number].pool;
346     }
347     function get_race_number() public view returns (uint){
348         return race_number;
349     }
350     function get_weather() public view returns (uint){
351         uint hash = uint(blockhash(block.number - 1));
352         return  hash%3;
353     }
354     function get_progress() public view  returns (uint[10] memory progress, uint block_finish, uint weather, uint squid, uint block_now, bytes32[10] memory history, uint block_squid){
355         //History
356         for(uint b = 0; b < 10; b++){
357             history[b] = blockhash(b + block.number - 10 );
358         }
359 
360         if(races[race_number].block_start == 0){
361             return (progress, block_finish, 0, 11, block.number, history, 0);
362         }
363 
364         squid = 11;
365         uint leader;
366         for(uint b = races[race_number].block_start; b < block.number; b++){
367             uint hash = uint(blockhash(b));
368             weather = hash%3;
369             for(uint boat = 0; boat < races[race_number].boat_count; boat++){
370                 if(squid != boat){
371                     progress[boat] += increment_boat(
372                         hash,
373                         weather,
374                         boat,
375                         races[race_number].boats[boat].class,
376                         races[race_number].boats[boat].variant
377                     );
378                 }
379                 if(progress[boat] >= progress[leader]){
380                     leader = boat;
381                 }
382                 if(progress[boat] >= COURSE_LENGTH ){
383                     block_finish = b;
384                 }
385             }
386 
387             if(block_finish != 0){
388                 break;
389             }
390             if(
391                 progress[leader] < COURSE_LENGTH
392                 && progress[leader] > COURSE_LENGTH/2
393                 && !races[race_number].boats[leader].repellent
394             && squid == 11
395             && hash%MODULO_SQUID == 0
396             ){
397                 squid =  leader;
398                 block_squid = b;
399             }
400         }
401 
402         return (progress, block_finish, weather, squid, block.number, history, block_squid);
403     }
404 
405     function get_times() public view returns (uint block_start, uint block_finish, uint block_current){
406         return (
407         races[race_number].block_start,
408         races[race_number].block_finish,
409         block.number
410         );
411     }
412     function get_boats() public view returns (
413         address[10] memory owner,
414         uint8[10] memory class,
415         uint8[10] memory variant,
416         bool[10] memory repellent
417     ){
418         for(uint boat = 0; boat < 10; boat++){
419             owner[boat] = races[race_number].boats[boat].owner;
420             class[boat] = races[race_number].boats[boat].class;
421             variant[boat] = races[race_number].boats[boat].variant;
422             repellent[boat] = races[race_number].boats[boat].repellent;
423         }
424         return (owner,class,variant,repellent);
425     }
426 
427     function get_name(address boat) public view returns(bytes32 name){
428         return boat_names[boat];
429     }
430     function get_balance() public view returns(uint balance){
431         return bank[msg.sender];
432     }
433     function get_boat_count() public view returns(uint boat_count){
434         return races[race_number].boat_count;
435     }
436     function get_pool_past(uint past_race_number) external view returns(uint pool){
437         return races[past_race_number].pool;
438     }
439 }
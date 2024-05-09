1 pragma solidity ^0.4.24;
2 
3 contract EthGods {
4 
5     // imported contracts
6     
7     EthGodsName private eth_gods_name;
8     function set_eth_gods_name_contract_address(address eth_gods_name_contract_address) public returns (bool) {
9         require(msg.sender == admin);
10         eth_gods_name = EthGodsName(eth_gods_name_contract_address);
11         return true;
12     }
13 
14     EthGodsDice private eth_gods_dice;
15     function set_eth_gods_dice_contract_address(address eth_gods_dice_contract_address) public returns (bool) {
16         require(msg.sender == admin);
17         eth_gods_dice = EthGodsDice(eth_gods_dice_contract_address);
18         return true;
19     }
20     
21     // end of imported contracts
22  
23  
24      // start of database
25     
26     //contract information & administration
27     bool private contract_created; // in case constructor logic change in the future
28     address private contract_address; //shown at the top of the home page
29     string private contact_email = "ethgods@gmail.com";
30     string private official_url = "swarm-gateways.net/bzz:/ethgods.eth";
31 
32     address private  admin; // public when testing
33     address private controller1 = 0xcA5A9Db0EF9a0Bf5C38Fc86fdE6CB897d9d86adD; // controller can change admin at once; 
34     address private controller2 = 0x8396D94046a099113E5fe5CBad7eC95e96c2B796; // controller can change admin at once; 
35 
36     address private v_god = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
37     uint private block_hash_duration = 255; // can't get block hash, after 256 blocks, adjustable
38     
39 
40     // god
41     struct god {
42         uint god_id;
43         uint level;
44         uint exp;
45         uint pet_type;// 12 animals or zodiacs
46         uint pet_level;   
47         uint listed; // 0 not a god, 1 - ... rank_score in god list
48         uint invite_price;
49         uint blessing_player_id;
50         bool hosted_pray; // auto waitlist, when enlisted. others can invite, once hosted pray
51         uint bid_eth; // bid to host pray
52         
53         uint credit; // gained from the amulet invitation spending of invited fellows
54         uint count_amulets_generated;
55         uint first_amulet_generated;
56         uint count_amulets_at_hand;
57         uint count_amulets_selling;
58         uint amulets_start_id;
59         uint amulets_end_id;
60         
61         uint count_token_orders;
62         uint first_active_token_order;
63 
64         uint allowed_block; // allow another account to use my egst
65         
66         uint block_number; // for pray
67         bytes32 gene;
68         bool gene_created;
69         bytes32 pray_hash; //hash created for each pray
70 
71         uint inviter_id; // who invited this fellow to this world
72         uint count_gods_invited; // gods invited to this game by this god.
73         
74     }
75     uint private count_gods = 0; // Used when generating id for a new player, 
76     mapping(address => god) private gods; // everyone is a god
77     mapping(uint => address) private gods_address; // gods' address => god_id
78 
79     uint [] private listed_gods; // id of listed gods
80     uint private max_listed_gods = 10000; // adjustable
81 
82     uint private initial_invite_price = 0.02 ether; // grows with each invitation for this god
83     uint private invite_price_increase = 0.02 ether; // grows by this amount with each invitation
84     uint private max_invite_price = 1000 ether; // adjustable
85     uint private max_extra_eth = 0.001 ether; // adjustable
86 
87     uint private list_level = 10; // start from level 10
88     uint private max_gas_price = 100000000000; // 100 gwei for invite and pray, adjustable
89     
90     // amulet
91     struct amulet {
92         uint god_id;
93         address owner;
94         uint level;
95         uint bound_start_block;// can't sell, if just got
96         // bool selling;
97         uint start_selling_block; // can't bind & use in pk, if selling
98         uint price; // set to 0, when withdraw from selling or bought
99         // uint order_id; // should be 0, if not selling
100     }
101     uint private count_amulets = 0; 
102     mapping(uint => amulet) private amulets; // public when testing
103     uint private bound_duration = 9000; // once bought, wait a while before sell it again, adjustable
104     uint private order_duration = 20000; // valid for about 3 days, then not to show to public in selling amulets/token orders, but still show in my_selling amulets/token orders. adjustable
105 
106     // pray
107     address private pray_host_god; // public when testing
108     bool private pray_reward_top100; // if hosted by new god, reward top 100 gods egst
109     uint private pray_start_block; // public when testing
110     bool private rewarded_pray_winners = false;
111 
112     uint private count_hosted_gods; // gods hosted pray (event started). If less than bidding gods, there are new gods waiting to host pray, 
113     mapping (uint => address) private bidding_gods; // every listed god and bid to host pray
114     uint private initializer_reward = 36; // reward the god who burned gas to send pray rewards to community, adjustable
115     
116     mapping(uint => uint) private max_winners;  // max winners for each prize  
117     uint private min_pray_interval = 2000; // 2000, 36 in CBT, 2 in dev, adjustable
118     uint private min_pray_duration = 6000; // 6000, 600 in CBT, 60 in dev, adjustable
119     uint private max_pray_duration = 9000; // 9000, 900 in CBT, 90 in dev, adjustable
120 
121     uint private count_waiting_prayers;
122     mapping (uint => address) private waiting_prayers; // uint is waiting sequence
123     uint private waiting_prayer_index = 1; // waiting sequence of the prayer ready to draw lot
124 
125     mapping(uint => uint) private pk_positions; // public when testing
126     mapping(uint => uint) private count_listed_winners; // count for 5 prizes, public in testing
127     mapping (uint => mapping(uint => address)) private listed_winners; // winners for 5 prizes
128 
129     bool private reEntrancyMutex = false; // for sendnig eth to msg.sender
130     
131     uint private pray_egses = 0; // 10% from reward pool to top 3 winners in each round of pray events
132     uint private pray_egst = 0;  // 10% from reward pool to 3rd & 4th prize winners in each round of pray events
133 
134     mapping(address => uint) egses_balances;
135         
136 
137     // eth_gods_token (EGST)
138     string public name = "EthGodsToken";
139     string public symbol = "EGST";
140     uint8 public decimals = 18; //same as ethereum
141     uint private _totalSupply;
142     mapping(address => uint) balances; // bought or gained from pray or revenue share
143     mapping(address => mapping(address => uint)) allowed;
144     uint private allowed_use_CD = 20; // if used allowed amount, have to wait a while before approve new allowed amount again, prevent cheating, adjustable
145     
146 
147     struct token_order {
148         uint id;
149         uint start_selling_block;
150         address seller;
151         uint unit_price;
152         uint egst_amount;
153     }
154     uint private count_token_orders = 0;
155     mapping (uint => token_order) token_orders;
156     uint private first_active_token_order = 0;
157 
158     uint private min_unit_price = 20; // 1 egst min value is 0.0002 ether, adjustable
159     uint private max_unit_price = 200; // 1 egst max value is 0.002 ether, adjustable
160     uint private max_egst_amount = 1000000 ether; // for create_token_order, adjustable
161     uint private min_egst_amount = 0.00001 ether; // for create_token_order, adjustable
162  
163  
164     //logs
165     uint private count_rounds = 0;
166     
167     struct winner_log { // win a prize and if pk
168         uint god_block_number;
169         bytes32 block_hash; 
170         address prayer;
171         address previous_winner;
172         uint prize;
173         bool pk_result;
174     }
175     mapping (uint => uint) private count_rounds_winner_logs;
176     mapping(uint => mapping(uint => winner_log)) private winner_logs;
177     
178     struct change_log {
179         uint block_number;
180         uint asset_type; // 1 egst, 2 eth_surplus
181         
182         // egses change reasons:  
183             // 1 pray_reward, 2 god_reward for being invited, 3 inviter_reward,
184             // 4 admin_deposit to reward_pool, 5 withdraw egses
185             // 6 sell amulet, 7 sell egst, 8 withdraw bid
186         
187         // egst_change reasons: 
188             // 1 pray_reward, 2 top_gods_reward, 
189             // 3 create_token_order, 4 withdraw token_order, 5 buy token,  
190             // 6 upgrade pet, 7 upgrade amulet, 8 admin_reward
191         
192         uint reason; // > 10 is buy token unit_price
193         uint change_amount;
194         uint after_amount;
195         address _from;
196         address _to;
197     }
198     mapping (uint => uint) private count_rounds_change_logs;
199     mapping(uint => mapping(uint => change_log)) private change_logs;
200 
201     // end of database
202   
203     
204     // start of constructor
205     constructor () public {
206         require (contract_created == false);
207         contract_created = true;
208         contract_address = address(this);
209         admin = msg.sender;
210 
211         create_god(admin, 0);
212         create_god(v_god, 0);
213         gods[v_god].level = 10;
214         enlist_god(v_god);
215         
216         max_winners[1] = 1; // 1
217         max_winners[2] = 2; // 2
218         max_winners[3] = 8; // 8
219         max_winners[4] = 16; // 16
220         max_winners[5] = 100; // 100
221 
222         _totalSupply = 6000000 ether;
223         pray_egst = 1000 ether;
224         balances[admin] = sub(_totalSupply, pray_egst);
225   
226         initialize_pray();
227     }
228     
229     // destruct for testing contracts. can't destruct since round 3
230     function finalize() public {
231         require(msg.sender == admin && count_rounds <= 3);
232         selfdestruct(admin); 
233     }
234     
235 
236     function () public payable {
237         revert ();
238     }   
239     // end of constructor
240      
241          
242     //start of contract information & administration
243     
244     function get_controller () public view returns (address, address){
245         require (msg.sender == admin || msg.sender == controller1  || msg.sender == controller2);
246         return (controller1, controller2);
247     }
248     
249     function set_controller (uint controller_index, address new_controller_address) public returns (bool){
250         if (controller_index == 1){
251             require(msg.sender == controller2);
252             controller1 = new_controller_address;
253         } else {
254             require(msg.sender == controller1);
255             controller2 = new_controller_address;            
256         }
257         return true;
258     }
259      
260     function set_admin (address new_admin_address) public returns (bool) {
261         require (msg.sender == controller1 || msg.sender == controller2);
262         // admin don't have game attributes, such as level'
263         // no need to transfer egses and egst to new_admin_address
264         delete gods[admin];
265         admin = new_admin_address;
266         gods_address[0] = admin;
267         gods[admin].god_id = 0;
268         return true;
269     }  
270     
271     // update system parameters
272     function set_parameters (uint parameter_type, uint new_parameter) public returns (bool){
273         require (msg.sender == admin);
274         if (parameter_type == 1) {
275             max_pray_duration = new_parameter;
276         } else if (parameter_type == 2) {
277             min_pray_duration = new_parameter;
278         } else if (parameter_type == 3) {
279             block_hash_duration = new_parameter;
280         } else if (parameter_type == 4) {
281             min_pray_interval = new_parameter;
282         } else if (parameter_type == 5) {
283             order_duration = new_parameter;
284         } else if (parameter_type == 6) {
285             bound_duration = new_parameter;
286         } else if (parameter_type == 7) {
287             initializer_reward = new_parameter;
288         } else if (parameter_type == 8) {
289             allowed_use_CD = new_parameter;
290         } else if (parameter_type == 9) {
291             min_unit_price = new_parameter;
292         } else if (parameter_type == 10) {
293             max_unit_price = new_parameter;
294         } else if (parameter_type == 11) {
295             max_listed_gods = new_parameter;
296         } else if (parameter_type == 12) {
297             max_gas_price = new_parameter;
298         } else if (parameter_type == 13) {
299             max_invite_price = new_parameter;
300         } else if (parameter_type == 14) {
301             min_egst_amount = new_parameter;
302         } else if (parameter_type == 15) {
303             max_egst_amount = new_parameter;
304         } else if (parameter_type == 16) {
305             max_extra_eth = new_parameter;
306         }
307         return true;
308     }  
309         
310     function set_strings (uint string_type, string new_string) public returns (bool){
311         require (msg.sender == admin);
312         
313         if (string_type == 1){
314             official_url = new_string;
315         } else if (string_type == 2){
316             name = new_string; // egst name
317         } else if (string_type == 3){
318             symbol = new_string; // egst symbol
319         }
320         return true;
321     }    
322     
323   
324     // for basic information to show to players, and to update parameter in sub-contracts
325     function query_contract () public view returns(uint, uint, address, uint, string, uint, uint){
326         return (count_gods,
327                 listed_gods.length, 
328                 admin,
329                 block_hash_duration,
330                 official_url,
331                 bound_duration,
332                 min_pray_interval
333                );
334     }
335     
336     
337     function query_uints () public view returns (uint[7] uints){
338         uints[0] = max_invite_price;
339         uints[1] = list_level;
340         uints[2] = max_pray_duration;
341         uints[3] = min_pray_duration;
342         uints[4] = initializer_reward;
343         uints[5] = min_unit_price;
344         uints[6] = max_unit_price;
345         
346         return uints;
347     }
348     
349     
350     function query_uints2 () public view returns (uint[6] uints){
351         uints[0] = allowed_use_CD;
352         uints[1] = max_listed_gods;
353         uints[2] = max_gas_price;
354         uints[3] = min_egst_amount;
355         uints[4] = max_egst_amount;
356         uints[5] = max_extra_eth;
357 
358         return uints;
359     }
360   
361     //end of contract information & administration
362 
363     
364     // god related functions: register, create_god, upgrade_pet, add_exp, burn_gas, invite, enlist
365     
366     // if a new player comes when a round just completed, the new player may not want to initialize the next round
367     function register_god (uint inviter_id) public returns (uint) {
368         return create_god(msg.sender, inviter_id);
369     }
370     function create_god (address god_address, uint inviter_id) private returns(uint god_id){ // created by the contract // public when testing
371         // check if the god is already created
372         if (gods[god_address].credit == 0) { // create admin as god[0]
373             gods[god_address].credit = 1; // give 1 credit, so we know this address has a god
374             
375             god_id = count_gods; // 1st god's id is admin 0
376             count_gods = add(count_gods, 1) ;
377             gods_address[god_id] = god_address;
378             gods[god_address].god_id = god_id;
379                         
380             if (god_id > 0){ // not admin
381                 add_exp(god_address, 100);
382                 set_inviter(inviter_id);
383             }
384             
385             return god_id;
386         }
387     }
388     
389     function set_inviter (uint inviter_id) public returns (bool){
390         if (inviter_id > 0 && gods_address[inviter_id] != address(0)
391         && gods[msg.sender].inviter_id == 0
392         && gods[gods_address[inviter_id]].inviter_id != gods[msg.sender].god_id){
393             gods[msg.sender].inviter_id = inviter_id;
394             address inviter_address = gods_address[inviter_id];
395             gods[inviter_address].count_gods_invited = add(gods[inviter_address].count_gods_invited, 1);
396             return true;
397         }
398     }
399 
400     function add_exp (address god_address, uint exp_up) private returns(uint new_level, uint new_exp) { // public when testing
401         if (god_address == admin){
402             return (0,0);
403         }
404         if (gods[god_address].god_id == 0){
405             uint inviter_id = gods[god_address].inviter_id;
406             create_god(god_address, inviter_id);
407         }
408         new_exp = add(gods[god_address].exp, exp_up);
409         uint current_god_level = gods[god_address].level;
410         uint level_up_exp;
411         new_level = current_god_level;
412 
413         for (uint i=0;i<10;i++){ // if still have extra exp, level up next time
414             if (current_god_level < 99){
415                 level_up_exp = mul(10, add(new_level, 1));
416             } else {
417                 level_up_exp = 1000;
418             }
419             if (new_exp >= level_up_exp){
420                 new_exp = sub(new_exp, level_up_exp);
421                 new_level = add(new_level, 1);
422             } else {
423                 break;
424             }
425         }
426 
427         gods[god_address].exp = new_exp;
428 
429         if(new_level > current_god_level) {
430             gods[god_address].level = new_level;
431             if (gods[god_address].listed > 0) {
432                 if (listed_gods.length > 1) {
433                     sort_gods(gods[god_address].god_id);
434                 }
435             } else if (new_level >= list_level && listed_gods.length < max_listed_gods) {
436                 enlist_god(god_address);
437             }
438         }
439         
440         return (new_level, new_exp);
441     }
442 
443    
444     function enlist_god (address god_address) private returns (uint) { // public when testing
445         require(gods[god_address].level >= list_level && god_address != admin);
446                 
447         // if the god is not listed yet, enlist and add level requirement for the next enlist
448         if (gods[god_address].listed == 0) {
449             uint god_id = gods[god_address].god_id;
450             if (god_id == 0){
451                 god_id = create_god(god_address, 0); // get a god_id and set inviter as v god
452             }
453             gods[god_address].listed = listed_gods.push(god_id); // start from 1, 0 is not listed
454             gods[god_address].invite_price = initial_invite_price;
455 
456             list_level = add(list_level, 1);
457             bidding_gods[listed_gods.length] = god_address;
458             
459         }
460         return list_level;
461     }
462     
463     function sort_gods_admin(uint god_id) public returns (bool){
464         require (msg.sender == admin);
465         sort_gods(god_id);
466         return true;
467     }
468 
469 
470     // when a listed god level up and is not top 1 of the list, compare power with higher god, if higher than the higher god, swap position
471     function sort_gods (uint god_id) private returns (uint){ 
472         require (god_id > 0);
473         uint list_length = listed_gods.length;
474         if (list_length > 1) {
475             address god_address = gods_address[god_id];
476             uint this_god_listed = gods[god_address].listed;
477             if (this_god_listed < list_length) {
478                 uint higher_god_listed = add(this_god_listed, 1);
479                 uint higher_god_id = listed_gods[sub(higher_god_listed, 1)];
480                 address higher_god = gods_address[higher_god_id];
481                 if(gods[god_address].level > gods[higher_god].level
482                 || (gods[god_address].level == gods[higher_god].level
483                     && gods[god_address].exp > gods[higher_god].exp)){
484                         listed_gods[sub(this_god_listed, 1)] = higher_god_id;
485                         listed_gods[sub(higher_god_listed, 1)] = god_id;
486                         gods[higher_god].listed = this_god_listed;
487                         gods[god_address].listed = higher_god_listed;
488                 }
489             }
490         }
491         return gods[god_address].listed;
492     }
493 
494 
495     function burn_gas (uint god_id) public returns (uint god_new_level, uint god_new_exp) {
496         address god_address = gods_address[god_id];
497         require(god_id > 0 
498                 && god_id <= count_gods
499                 && gods[god_address].listed > 0);
500 
501         add_exp(god_address, 1);
502         add_exp(msg.sender, 1);
503         return (gods[god_address].level, gods[god_address].exp); // return bool, if out of gas
504     }
505 
506 
507     function invite (uint god_id) public payable returns (uint new_invite_price)  {
508         address god_address = gods_address[god_id];
509         require(god_id > 0 
510                 && god_id <= count_gods
511                 && gods[god_address].hosted_pray == true
512                 && tx.gasprice <= max_gas_price
513                 );
514 
515         uint invite_price = gods[god_address].invite_price;
516 
517         require(msg.value >= invite_price); 
518 
519         if (gods[god_address].invite_price < max_invite_price) {
520             gods[god_address].invite_price = add(invite_price, invite_price_increase);
521         }
522         
523         uint exp_up = div(invite_price, (10 ** 15)); // 1000 exp for each eth
524         add_exp(god_address, exp_up);
525         add_exp(msg.sender, exp_up);
526        
527         //generate a new amulet of this god for the inviter
528         count_amulets ++;
529         amulets[count_amulets].god_id = god_id;
530         amulets[count_amulets].owner = msg.sender;
531 
532         gods[god_address].count_amulets_generated = add(gods[god_address].count_amulets_generated, 1);
533         if (gods[god_address].count_amulets_generated == 1){
534             gods[god_address].first_amulet_generated = count_amulets;
535         }
536         gods[msg.sender].count_amulets_at_hand = add(gods[msg.sender].count_amulets_at_hand, 1);
537         update_amulets_count(msg.sender, count_amulets, true);
538 
539         // invite_price to egses: 60% to pray_egses, 20% to god, changed
540         // pray_egses = add(pray_egses, div(mul(60, invite_price), 100));
541         // egses_from_contract(gods_address[god_id], div(mul(20, invite_price), 100), 2); //2 reward god for being invited
542         // reduce reward pool share from 60 to 50%, reduce god reward from 20% to 10%
543         // add 20% share to blessing player (the last player invited this god)
544         pray_egses = add(pray_egses, div(mul(50, invite_price), 100)); 
545         egses_from_contract(god_address, div(mul(10, invite_price), 100), 2); //2 reward god for being invited
546         egses_from_contract(gods_address[gods[god_address].blessing_player_id], div(mul(20, invite_price), 100), 2); //2 reward god for being invited, no need to check if blessing player id is > 0
547         gods[god_address].blessing_player_id = gods[msg.sender].god_id;
548 
549         reward_inviter(msg.sender, invite_price);
550         emit invited_god (msg.sender, god_id);
551 
552         return gods[god_address].invite_price;
553     }
554     event invited_god (address msg_sender, uint god_id);
555     
556 
557     function reward_inviter (address inviter_address, uint invite_price) private returns (bool){
558         // the fellow spending eth also get credit and share
559         uint previous_share = 0;
560         uint inviter_share = 0;
561         uint share_diff;
562         // uint invite_credit = div(invite_price, 10 ** 15);
563         
564         for (uint i = 0; i < 9; i++){ // max trace 9 layers of inviter
565             if (inviter_address != address(0) && inviter_address != admin){ // admin doesn't get reward or credit
566                 share_diff = 0;
567                 // gods[inviter_address].credit = add(gods[inviter_address].credit, invite_credit);
568                 gods[inviter_address].credit = add(gods[inviter_address].credit, invite_price);
569                 inviter_share = get_vip_level(inviter_address);
570 
571                 if (inviter_share > previous_share) {
572                     share_diff = sub(inviter_share, previous_share);
573                     if (share_diff > 18) {
574                         share_diff = 18;
575                     }
576                     previous_share = inviter_share;
577                 }
578                 
579                 if (share_diff > 0) {
580                     egses_from_contract(inviter_address, div(mul(share_diff, invite_price), 100), 3); // 3 inviter_reward
581                 }
582                 
583                 inviter_address = gods_address[gods[inviter_address].inviter_id]; // get the address of inviter's inviter'
584             } else{
585                 break;
586             }
587         }
588         // invite_price to egses: sub(20%, previous_share) to admin
589         share_diff = sub(20, inviter_share); 
590         egses_from_contract(admin, div(mul(share_diff, invite_price), 100), 2); // remaining goes to admin, 2 god_reward for being invited
591         
592         return true;
593     }
594     
595 
596     function upgrade_pet () public returns(bool){
597         //use egst to level up pet;
598         uint egst_cost = mul(add(gods[msg.sender].pet_level, 1), 10 ether);
599         egst_to_contract(msg.sender, egst_cost, 6);// 6 upgrade_pet
600         gods[msg.sender].pet_level = add(gods[msg.sender].pet_level, 1);
601         add_exp(msg.sender, div(egst_cost, 1 ether));
602         pray_egst = add(pray_egst, egst_cost);
603 
604         // pray_egst = add(pray_egst, div(egst_cost, 2));
605         // egst_from_contract(admin, div(egst_cost, 2), 8); // 8 admin reward
606         emit upgradeAmulet(msg.sender, 0, gods[msg.sender].pet_level);
607         
608         return true;
609     }
610     event upgradeAmulet (address owner, uint amulet_id, uint new_level);
611 
612     function set_pet_type (uint new_type) public returns (bool){
613         if (gods[msg.sender].pet_type != new_type) {
614             gods[msg.sender].pet_type = new_type;
615             return true;
616         }
617     }
618   
619       
620     function get_vip_level (address god_address) public view returns (uint vip_level){
621         uint inviter_credit = gods[god_address].credit;
622         
623         if (inviter_credit > 500 ether){
624             vip_level = 18;
625         } else if (inviter_credit > 200 ether){
626             vip_level = 15;
627         } else if (inviter_credit > 100 ether){
628             vip_level = 12;
629         } else if (inviter_credit > 50 ether){
630             vip_level = 10;
631         } else if (inviter_credit > 20 ether){
632             vip_level = 8;
633         } else if (inviter_credit > 10 ether){
634             vip_level = 6;
635         } else if (inviter_credit > 5 ether){
636             vip_level = 5;
637         } else if (inviter_credit > 2 ether){
638             vip_level = 4;
639         } else if (inviter_credit > 1 ether){
640             vip_level = 3;
641         } else if (inviter_credit > 0.5 ether){
642             vip_level = 2;
643         } else {
644             vip_level = 1;
645         }
646         return vip_level;
647     }
648 
649 
650     // view god's information
651     
652     function get_god_id (address god_address) public view returns (uint god_id){
653         return gods[god_address].god_id;
654     }
655     
656     
657     function get_god_address(uint god_id) public view returns (address){
658         return gods_address[god_id];
659     }
660 
661 
662     function get_god (uint god_id) public view returns(uint, string, uint, uint, uint, uint, uint) {
663         address god_address = gods_address[god_id];
664         string memory god_name;
665 
666         god_name = eth_gods_name.get_god_name(god_address);
667         if (bytes(god_name).length == 0){
668             god_name = "Unknown";
669         }
670 
671         return (gods[god_address].god_id,
672                 god_name,
673                 gods[god_address].level,
674                 gods[god_address].exp,
675                 gods[god_address].invite_price,
676                 gods[god_address].listed,
677                 gods[god_address].blessing_player_id
678                 );
679     }
680     
681     
682     function get_god_info (address god_address) public view returns (uint, bytes32, bool, uint, uint, uint, bytes32){
683         return (gods[god_address].block_number,
684                 gods[god_address].gene,
685                 gods[god_address].gene_created,
686                 gods[god_address].pet_type,
687                 gods[god_address].pet_level,
688                 gods[god_address].bid_eth,
689                 gods[god_address].pray_hash
690                 );
691     }
692     
693     
694     function get_god_hosted_pray (uint god_id) public view returns (bool){
695         return gods[gods_address[god_id]].hosted_pray;
696     }
697     
698     
699     function get_my_info () public view returns(uint, uint, uint, uint, uint, uint, uint) { //private information
700 
701         return (gods[msg.sender].god_id,
702                 egses_balances[msg.sender], //egses
703                 balances[msg.sender], //egst
704                 get_vip_level(msg.sender),
705                 gods[msg.sender].credit, // inviter_credit
706                 gods[msg.sender].inviter_id,
707                 gods[msg.sender].count_gods_invited
708                 );
709     }   
710 
711     
712     function get_listed_gods (uint page_number) public view returns (uint[]){
713         
714         uint count_listed_gods = listed_gods.length;
715         require(count_listed_gods <= mul(page_number, 20));
716         
717         uint[] memory tempArray = new uint[] (20);
718 
719         if (page_number < 1) {
720             page_number = 1;
721         } 
722 
723         for (uint i = 0; i < 20; i++){
724             if(count_listed_gods > add(i, mul(20, sub(page_number, 1)))) {
725                 tempArray[i] = listed_gods[sub(sub(sub(count_listed_gods, i), 1), mul(20, sub(page_number, 1)))];
726             } else {
727                 break;
728             }
729         }
730         
731         return tempArray;
732     }
733 
734 
735     // amulets
736    
737     function upgrade_amulet (uint amulet_id) public returns(uint){
738         require(amulets[amulet_id].owner == msg.sender);
739         uint egst_cost = mul(add(amulets[amulet_id].level, 1), 10 ether);
740         egst_to_contract(msg.sender, egst_cost, 7);// reason 7, upgrade_amulet
741         pray_egst = add(pray_egst, egst_cost);
742         // pray_egst = add(pray_egst, div(egst_cost, 2));
743         // egst_from_contract(admin, div(egst_cost, 2), 8); // 8 admin reward
744         
745         amulets[amulet_id].level = add(amulets[amulet_id].level, 1);
746         add_exp(msg.sender, div(egst_cost, 1 ether));
747         emit upgradeAmulet(msg.sender, amulet_id, amulets[amulet_id].level);
748         
749         return amulets[amulet_id].level;
750     }
751     
752     
753     function create_amulet_order (uint amulet_id, uint price) public returns (uint) {
754         require(msg.sender == amulets[amulet_id].owner
755                 && amulet_id >= 1 && amulet_id <= count_amulets
756                 && amulets[amulet_id].start_selling_block == 0
757                 && add(amulets[amulet_id].bound_start_block, bound_duration) < block.number
758                 && price > 0);
759 
760         amulets[amulet_id].start_selling_block = block.number;
761         amulets[amulet_id].price = price;
762         gods[msg.sender].count_amulets_at_hand = sub(gods[msg.sender].count_amulets_at_hand, 1);
763         gods[msg.sender].count_amulets_selling = add(gods[msg.sender].count_amulets_selling, 1);
764         
765         return gods[msg.sender].count_amulets_selling;
766 
767     }
768 
769     function buy_amulet (uint amulet_id) public payable returns (bool) {
770         uint price = amulets[amulet_id].price;
771         require(msg.value >= price && msg.value < add(price, max_extra_eth)
772         && amulets[amulet_id].start_selling_block > 0
773         && amulets[amulet_id].owner != msg.sender
774         && price > 0);
775         
776         address seller = amulets[amulet_id].owner;
777         amulets[amulet_id].owner = msg.sender;
778         amulets[amulet_id].bound_start_block = block.number;
779         amulets[amulet_id].start_selling_block = 0;
780 
781         gods[msg.sender].count_amulets_at_hand++;
782         update_amulets_count(msg.sender, amulet_id, true);
783         gods[seller].count_amulets_selling--;
784         update_amulets_count(seller, amulet_id, false);
785 
786         egses_from_contract(seller, price, 6); // 6 sell amulet
787 
788         return true;
789     }
790 
791     function withdraw_amulet_order (uint amulet_id) public returns (uint){
792         // an amulet can only have one order_id, so withdraw amulet_id instead of withdraw order_id, since only amulet_id is shown in amulets_at_hand
793         require(msg.sender == amulets[amulet_id].owner
794                 && amulet_id >= 1 && amulet_id <= count_amulets
795                 && amulets[amulet_id].start_selling_block > 0);
796                 
797         amulets[amulet_id].start_selling_block = 0;
798         gods[msg.sender].count_amulets_at_hand++;
799         gods[msg.sender].count_amulets_selling--;
800 
801         return gods[msg.sender].count_amulets_selling;
802     }
803     
804     function update_amulets_count (address god_address, uint amulet_id, bool obtained) private returns (uint){
805         if (obtained == true){
806             if (amulet_id < gods[god_address].amulets_start_id) {
807                 gods[god_address].amulets_start_id = amulet_id;
808             }
809         } else {
810             if (amulet_id == gods[god_address].amulets_start_id){
811                 for (uint i = amulet_id; i <= count_amulets; i++){
812                     if (amulets[i].owner == god_address && i > amulet_id){
813                         gods[god_address].amulets_start_id = i;
814                         break;
815                     }
816                 }
817             }
818         }
819         return gods[god_address].amulets_start_id;
820     }
821     
822 
823     function get_amulets_generated (uint god_id) public view returns (uint[]) {
824         address god_address = gods_address[god_id];
825         uint count_amulets_generated = gods[god_address].count_amulets_generated;
826         
827         uint [] memory temp_list = new uint[](count_amulets_generated);
828         uint count_elements = 0;
829         for (uint i = gods[god_address].first_amulet_generated; i <= count_amulets; i++){
830             if (amulets[i].god_id == god_id){
831                 temp_list [count_elements] = i;
832                 count_elements++;
833                 
834                 if (count_elements >= count_amulets_generated){
835                     break;
836                 }
837             }
838         }
839         return temp_list;
840     }
841 
842     
843     function get_amulets_at_hand (address god_address) public view returns (uint[]) {
844         uint count_amulets_at_hand = gods[god_address].count_amulets_at_hand;
845         uint [] memory temp_list = new uint[] (count_amulets_at_hand);
846         uint count_elements = 0;
847         for (uint i = gods[god_address].amulets_start_id; i <= count_amulets; i++){
848             if (amulets[i].owner == god_address && amulets[i].start_selling_block == 0){
849                 temp_list[count_elements] = i;
850                 count_elements++;
851                 
852                 if (count_elements >= count_amulets_at_hand){
853                     break;
854                 }
855             }
856         }
857 
858         return temp_list;
859     }
860     
861     
862     function get_my_amulets_selling () public view returns (uint[]){
863 
864         uint count_amulets_selling = gods[msg.sender].count_amulets_selling;
865         uint [] memory temp_list = new uint[] (count_amulets_selling);
866         uint count_elements = 0;
867         for (uint i = gods[msg.sender].amulets_start_id; i <= count_amulets; i++){
868             if (amulets[i].owner == msg.sender 
869             && amulets[i].start_selling_block > 0){
870                 temp_list[count_elements] = i;
871                 count_elements++;
872                 
873                 if (count_elements >= count_amulets_selling){
874                     break;
875                 }
876             }
877         }
878 
879         return temp_list;
880     }
881 
882     // to calculate how many pages
883     function get_amulet_orders_overview () public view returns(uint){
884         uint count_amulets_selling = 0;
885         for (uint i = 1; i <= count_amulets; i++){
886             if (add(amulets[i].start_selling_block, order_duration) > block.number && amulets[i].owner != msg.sender){
887                 count_amulets_selling ++;
888             }
889         }        
890         
891         return count_amulets_selling; // to show page numbers when getting amulet_orders
892     }
893 
894     function get_amulet_orders (uint page_number) public view returns (uint[]){
895         uint[] memory temp_list = new uint[] (20);
896         uint count_amulets_selling = 0;
897         uint count_list_elements = 0;
898 
899         if ((page_number < 1)
900             || count_amulets  <= 20) {
901             page_number = 1; // chose a page out of range
902         }
903         uint start_amulets_count = mul(sub(page_number, 1), 20);
904 
905         for (uint i = 1; i <= count_amulets; i++){
906             if (add(amulets[i].start_selling_block, order_duration) > block.number && amulets[i].owner != msg.sender){
907                 
908                 if (count_amulets_selling <= start_amulets_count) {
909                     count_amulets_selling ++;
910                 }
911                 if (count_amulets_selling > start_amulets_count){
912                     
913                     temp_list[count_list_elements] = i;
914                     count_list_elements ++;
915                     
916                     if (count_list_elements >= 20){
917                         break;
918                     }
919                 }
920                 
921             }
922         }
923         
924         return temp_list;
925     }
926     
927     
928     function get_amulet (uint amulet_id) public view returns(address, string, uint, uint, uint, uint, uint){
929         uint god_id = amulets[amulet_id].god_id;
930         // address god_address = gods_address[god_id];
931         string memory god_name = eth_gods_name.get_god_name(gods_address[god_id]);
932         uint god_level = gods[gods_address[god_id]].level;
933         uint amulet_level = amulets[amulet_id].level;
934         uint start_selling_block = amulets[amulet_id].start_selling_block;
935         uint price = amulets[amulet_id].price;
936 
937         return(amulets[amulet_id].owner,
938                 god_name,
939                 god_id,
940                 god_level,
941                 amulet_level,
942                 start_selling_block,
943                 price
944               );
945     }
946 
947     function get_amulet2 (uint amulet_id) public view returns(uint){
948         return amulets[amulet_id].bound_start_block;
949     }
950 
951     // end of amulet
952     
953     // start of pray
954     function admin_deposit (uint egst_amount) public payable returns (bool) {
955         require (msg.sender == admin);
956         if (msg.value > 0){
957             pray_egses = add(pray_egses, msg.value);
958             egses_from_contract(admin, msg.value, 4); // 4 admin_deposit to reward_pool
959         }
960         if (egst_amount > 0){
961             pray_egst = add(pray_egst, egst_amount);
962             egst_to_contract(admin, egst_amount, 4); // 4 admin_deposit to reward_pool            
963         }
964         return true;
965     }
966         
967     function initialize_pray () private returns (bool){
968         if (pray_start_block > 0) {
969             require (check_event_completed() == true
970             && rewarded_pray_winners == true);
971         }
972         
973         count_rounds = add(count_rounds, 1);
974         count_rounds_winner_logs[count_rounds] = 0;
975         pray_start_block = block.number;
976         rewarded_pray_winners = false;
977 
978         for (uint i = 1; i <= 5; i++){
979             pk_positions[i] = max_winners[i]; // pk start from the last slot
980 			count_listed_winners[i] = 0;
981         }
982         if (listed_gods.length > count_hosted_gods) {
983             // a new god's turn
984             count_hosted_gods = add(count_hosted_gods, 1);
985             pray_host_god = bidding_gods[count_hosted_gods];
986             gods[pray_host_god].hosted_pray = true;
987             pray_reward_top100 = true;
988         } else {
989             //choose highest bidder
990             (uint highest_bid, address highest_bidder) = compare_bid_eth();
991 
992             gods[highest_bidder].bid_eth = 0;
993             pray_host_god = highest_bidder;
994             pray_egses = add(pray_egses, highest_bid);
995             pray_reward_top100 = false;
996 
997         }
998         return true;
999 
1000     }
1001 
1002 
1003     function bid_host () public payable returns (bool) {
1004         require (msg.value > 0 && gods[msg.sender].listed > 0);
1005         gods[msg.sender].bid_eth = add (gods[msg.sender].bid_eth, msg.value);
1006 
1007         return true;
1008     }
1009     
1010 
1011     function withdraw_bid () public returns (bool) {
1012         require(gods[msg.sender].bid_eth > 0);
1013         gods[msg.sender].bid_eth = 0;
1014         egses_from_contract(msg.sender, gods[msg.sender].bid_eth, 8); // 8  withdraw bid
1015         return true;
1016     }
1017     
1018     
1019     // if browser web3 didn't get god's credit, use pray_create in the pray button to create god_id first
1020     function pray_create (uint inviter_id) public returns (bool) {
1021         // when create a new god, set credit as 1, so credit <= 0 means god_id not created yet
1022         create_god(msg.sender, inviter_id);
1023         pray();
1024     }
1025     
1026     // if browser web3 got god's credit, use pray in the pray button
1027     function pray () public returns (bool){
1028         require (add(gods[msg.sender].block_number, min_pray_interval) < block.number
1029         && tx.gasprice <= max_gas_price
1030         && check_event_completed() == false);
1031 
1032         if (waiting_prayer_index <= count_waiting_prayers) {
1033 
1034             address waiting_prayer = waiting_prayers[waiting_prayer_index];
1035             uint god_block_number = gods[waiting_prayer].block_number;
1036             bytes32 block_hash;
1037             
1038             if ((add(god_block_number, 1)) < block.number) {// can only get previous block hash
1039 
1040                 if (add(god_block_number, block_hash_duration) < block.number) {// make sure this god has a valid block_number to generate block hash
1041                     gods[waiting_prayer].block_number = block.number; // refresh this god's expired block_id
1042                     // delete waiting_prayers[waiting_prayer_index];
1043                     count_waiting_prayers = add(count_waiting_prayers, 1);
1044                     waiting_prayers[count_waiting_prayers] = waiting_prayer;
1045                 } else {// draw lottery and/or create gene for the waiting prayer
1046                     block_hash = keccak256(abi.encodePacked(blockhash(add(god_block_number, 1))));
1047                     if(gods[waiting_prayer].gene_created == false){
1048                         gods[waiting_prayer].gene = block_hash;
1049                         gods[waiting_prayer].gene_created = true;
1050                     }
1051                     gods[waiting_prayer].pray_hash = block_hash;
1052     
1053                     uint dice_result = eth_gods_dice.throw_dice (block_hash)[0];
1054 
1055                     if (dice_result >= 1 && dice_result <= 5){
1056                         set_winner(dice_result, waiting_prayer, block_hash, god_block_number);
1057                     }
1058                 }
1059                 waiting_prayer_index = add(waiting_prayer_index, 1);
1060             }
1061         }
1062         
1063         count_waiting_prayers = add(count_waiting_prayers, 1);
1064         waiting_prayers[count_waiting_prayers] = msg.sender;
1065 
1066         gods[msg.sender].block_number = block.number;
1067         gods[msg.sender].pray_hash = 0x0;
1068         add_exp(msg.sender, 1);
1069         add_exp(pray_host_god, 1);
1070 
1071         return true;
1072     }
1073 
1074 
1075     function set_winner (uint prize, address waiting_prayer, bytes32 block_hash, uint god_block_number) private returns (uint){
1076 
1077         count_rounds_winner_logs[count_rounds] = add(count_rounds_winner_logs[count_rounds], 1);
1078         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].god_block_number = god_block_number;
1079         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].block_hash = block_hash;
1080         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].prayer = waiting_prayer;
1081         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].prize = prize;
1082 
1083         if (count_listed_winners[prize] >= max_winners[prize]){ // winner_list maxed, so the new prayer challenge previous winners
1084            	uint pk_position = pk_positions[prize];
1085         	address previous_winner = listed_winners[prize][pk_position];  
1086 
1087             bool pk_result = pk(waiting_prayer, previous_winner, block_hash);
1088 
1089 			winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].pk_result = pk_result;
1090 			winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].previous_winner = previous_winner;
1091             
1092             if (pk_result == true) {
1093                 listed_winners[prize][pk_position] = waiting_prayer; // attacker defeat defender
1094             }
1095             if (prize > 1) { // no need to change pk_pos for champion
1096                 if (pk_positions[prize] > 1){
1097                     pk_positions[prize] = sub(pk_positions[prize], 1);
1098                 } else {
1099                     pk_positions[prize] = max_winners[prize];
1100                 }               
1101             }
1102         } else {
1103             count_listed_winners[prize] = add(count_listed_winners[prize], 1);
1104             listed_winners[prize][count_listed_winners[prize]] = waiting_prayer;
1105         }
1106      
1107         return count_listed_winners[prize];
1108     }
1109 
1110     function reward_pray_winners () public returns (bool){
1111         require (check_event_completed() == true);
1112 
1113         uint this_reward_egses;
1114         uint reward_pool_egses = div(pray_egses, 10);
1115         pray_egses = sub(pray_egses, reward_pool_egses);
1116         uint this_reward_egst;
1117         uint reward_pool_egst = div(pray_egst, 10);
1118         pray_egst = sub(pray_egst, reward_pool_egst); // reduce sum for less calculation
1119         
1120         egst_from_contract(pray_host_god, mul(div(reward_pool_egst, 100), 60), 1); // 1 pray_reward for hosting event
1121         
1122         for (uint i = 1; i<=5; i++){
1123             this_reward_egses = 0;
1124             this_reward_egst = 0;
1125             if (i == 1) {
1126                 this_reward_egses = mul(div(reward_pool_egses, 100), 60);
1127             } else if (i == 2){
1128                 this_reward_egses = mul(div(reward_pool_egses, 100), 20);
1129             } else if (i == 3){
1130                 this_reward_egst = mul(div(reward_pool_egst, 100), 3);
1131             } else if (i == 4){
1132                 this_reward_egst = div(reward_pool_egst, 100);
1133             } 
1134             
1135             for (uint reward_i = 1; reward_i <= count_listed_winners[i]; reward_i++){
1136                 address rewarding_winner = listed_winners[i][reward_i];
1137 
1138                 if (this_reward_egses > 0 ) {
1139                     egses_from_contract(rewarding_winner, this_reward_egses, 1); // 1 pray_reward
1140                 } else if (this_reward_egst > 0) {
1141                     egst_from_contract(rewarding_winner, this_reward_egst, 1); // 1 pray_reward
1142                 }  
1143                 
1144                 add_exp(rewarding_winner, 6);
1145             }
1146         }
1147             
1148         
1149         if(pray_reward_top100 == true) {
1150             reward_top_gods();
1151         }
1152             
1153         // a small gift of exp & egst to the god who burned gas to send rewards to the community
1154         egst_from_contract(msg.sender, mul(initializer_reward, 1 ether), 1); // 1 pray_reward
1155         _totalSupply = add(_totalSupply, mul(initializer_reward, 1 ether));  
1156         add_exp(msg.sender, initializer_reward);
1157 
1158         rewarded_pray_winners = true;
1159         initialize_pray();
1160         return true;
1161     }
1162 
1163 
1164     // more listed gods, more reward to the top gods, highest reward 600 egst
1165     function reward_top_gods () private returns (bool){ // public when testing
1166         
1167         uint count_listed_gods = listed_gods.length;
1168         uint last_god_index;
1169         
1170         if (count_listed_gods > 100) {
1171             last_god_index = sub(count_listed_gods, 100);
1172         } else {
1173             last_god_index = 0;
1174         }
1175         
1176         uint reward_egst = 0;
1177         uint base_reward = 6 ether;
1178         if (count_rounds == 6){
1179             base_reward = mul(base_reward, 6);
1180         }
1181         for (uint i = last_god_index; i < count_listed_gods; i++) {
1182             reward_egst = mul(base_reward, sub(add(i, 1), last_god_index));
1183             egst_from_contract(gods_address[listed_gods[i]], reward_egst, 2);// 2 top_gods_reward
1184             _totalSupply = add(_totalSupply, reward_egst);   
1185             if (gods[gods_address[listed_gods[i]]].blessing_player_id > 0){
1186                 egst_from_contract(gods_address[gods[gods_address[listed_gods[i]]].blessing_player_id], reward_egst, 2);// 2 top_gods_reward
1187                 _totalSupply = add(_totalSupply, reward_egst); 
1188             }
1189         }
1190         
1191         return true;
1192     }
1193 
1194 
1195     function compare_bid_eth () private view returns (uint, address) {
1196         uint highest_bid = 0;
1197         address highest_bidder = v_god; // if no one bid, v god host this event
1198 
1199         for (uint j = 1; j <= listed_gods.length; j++){
1200             if (gods[bidding_gods[j]].bid_eth > highest_bid){
1201                 highest_bid = gods[bidding_gods[j]].bid_eth;
1202                 highest_bidder = bidding_gods[j];
1203             }
1204         }
1205         return (highest_bid, highest_bidder);
1206     }
1207 
1208 
1209     function check_event_completed () public view returns (bool){
1210         // check min and max pray_event duration
1211         if (add(pray_start_block, max_pray_duration) > block.number){
1212             if (add(pray_start_block, min_pray_duration) < block.number){
1213                 for (uint i = 1; i <= 5; i++){
1214                     if(count_listed_winners[i] < max_winners[i]){
1215                         return false;
1216                     }           
1217                 }
1218                 return true;
1219             } else {
1220                 return false;
1221             }
1222             
1223         } else {
1224             return true;   
1225         }
1226     }
1227 
1228 
1229     function pk (address attacker, address defender, bytes32 block_hash) public view returns (bool pk_result){// make it public, view only, other contract may use it
1230 
1231         (uint attacker_sum_god_levels, uint attacker_sum_amulet_levels) = get_sum_levels_pk(attacker);
1232         (uint defender_sum_god_levels, uint defender_sum_amulet_levels) = get_sum_levels_pk(defender);
1233     
1234         pk_result = eth_gods_dice.pk(block_hash, attacker_sum_god_levels, attacker_sum_amulet_levels, defender_sum_god_levels, defender_sum_amulet_levels);
1235         
1236         return pk_result;
1237     }
1238     
1239     
1240     function get_sum_levels_pk (address god_address) public view returns (uint sum_gods_level, uint sum_amulets_level){
1241              
1242         sum_gods_level =  gods[god_address].level;
1243         sum_amulets_level = gods[god_address].pet_level; // add pet level to the sum
1244 		uint amulet_god_id;
1245         uint amulet_god_level;
1246         for (uint i = 1; i <= count_amulets; i++){
1247             if (amulets[i].owner == god_address && amulets[i].start_selling_block == 0){
1248                 amulet_god_id = amulets[i].god_id;
1249                 amulet_god_level = gods[gods_address[amulet_god_id]].level;
1250                 sum_gods_level = add(sum_gods_level, amulet_god_level);
1251                 sum_amulets_level = add(sum_amulets_level, amulets[i].level);
1252             }
1253         }
1254                 
1255         return (sum_gods_level, sum_amulets_level);
1256     }
1257         
1258     //admin need this function
1259     function get_listed_winners (uint prize) public view returns (address[]){
1260         address [] memory temp_list = new address[] (count_listed_winners[prize]);
1261         for (uint i = 0; i < count_listed_winners[prize]; i++){
1262             temp_list[i] = listed_winners[prize][add(i,1)];
1263         }
1264         return temp_list;
1265     }
1266 
1267    
1268     function query_pray () public view returns (uint, uint, uint, address, address, uint, bool){
1269         (uint highest_bid, address highest_bidder) = compare_bid_eth();
1270         return (highest_bid, 
1271                 pray_egses, 
1272                 pray_egst, 
1273                 pray_host_god, 
1274                 highest_bidder,
1275                 count_rounds,
1276                 pray_reward_top100);
1277     }     
1278     
1279 
1280  
1281     // end of pray
1282 
1283     // start of egses
1284 
1285     function egses_from_contract (address to, uint tokens, uint reason) private returns (bool) { // public when testing
1286         if (reason == 1) {
1287             require (pray_egses > tokens);
1288             pray_egses = sub(pray_egses, tokens);
1289         }
1290 
1291         egses_balances[to] = add(egses_balances[to], tokens);
1292 
1293         create_change_log(1, reason, tokens, egses_balances[to], contract_address, to);
1294         return true;
1295     } 
1296     
1297     function egses_withdraw () public returns (uint tokens){
1298         tokens = egses_balances[msg.sender];
1299         require (tokens > 0 && contract_address.balance >= tokens && reEntrancyMutex == false);
1300 
1301         reEntrancyMutex = true; // if met problem, it will use up gas from msg.sender and roll back to false
1302         egses_balances[msg.sender] = 0;
1303         msg.sender.transfer(tokens);
1304         reEntrancyMutex = false;
1305         
1306         emit withdraw_egses(msg.sender, tokens);
1307         create_change_log(1, 5, tokens, 0, contract_address, msg.sender); // 5 withdraw egses
1308 
1309         return tokens;
1310     }
1311     event withdraw_egses (address receiver, uint tokens);
1312 
1313    // end of egses
1314    
1315 
1316     // start of erc20 for egst
1317     function totalSupply () public view returns (uint){
1318         return _totalSupply;
1319     }
1320 
1321 
1322     function balanceOf (address tokenOwner) public view returns (uint){
1323         return balances[tokenOwner]; // will return 0 if doesn't exist
1324     }
1325 
1326     function allowance (address tokenOwner, address spender) public view returns (uint) {
1327         return allowed[tokenOwner][spender];
1328     }
1329 
1330     function transfer (address to, uint tokens) public returns (bool success){
1331         require (balances[msg.sender] >= tokens);
1332         balances[msg.sender] = sub(balances[msg.sender], tokens);
1333         balances[to] = add(balances[to], tokens);
1334         emit Transfer(msg.sender, to, tokens);
1335         create_change_log(2, 9, tokens, balances[to], msg.sender, to);
1336         
1337         return true;    
1338     }
1339     event Transfer (address indexed from, address indexed to, uint tokens);
1340 
1341 
1342     function approve (address spender, uint tokens) public returns (bool success) {
1343         // if allowed amount used and owner tries to reset allowed amount within a short time,
1344         // the allowed account might be cheating the owner
1345         require (balances[msg.sender] >= tokens);
1346         if (tokens > 0){
1347             require (add(gods[msg.sender].allowed_block, allowed_use_CD) < block.number);
1348         }
1349 
1350         allowed[msg.sender][spender] = tokens;
1351         
1352         emit Approval(msg.sender, spender, tokens);
1353         return true;
1354     }
1355     event Approval (address indexed tokenOwner, address indexed spender, uint tokens);
1356 
1357 
1358     function transferFrom (address from, address to, uint tokens) public returns (bool success) {
1359         require (balances[from] >= tokens);
1360         allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokens);
1361         balances[from] = sub(balances[from], tokens);
1362         balances[to] = add(balances[to], tokens);
1363         gods[from].allowed_block = block.number;
1364         
1365         emit Transfer(from, to, tokens);
1366         create_change_log(2, 10, tokens, balances[to], from, to);
1367         return true;    
1368     }
1369 
1370     // end of erc20 for egst
1371     
1372     
1373     // egst
1374   
1375     function egst_from_contract (address to, uint tokens, uint reason) private returns (bool) { // public when testing
1376         balances[to] = add(balances[to], tokens);
1377 
1378         create_change_log(2, reason, tokens, balances[to], contract_address, to); 
1379         return true;
1380     }
1381 
1382     function egst_to_contract (address from, uint tokens, uint reason) private returns (bool) { // public when testing
1383         require (balances[from] >= tokens);
1384         balances[from] = sub(balances[from], tokens);
1385         
1386 
1387         emit spend_egst(from, tokens, reason);
1388         create_change_log(2, reason, tokens, balances[from], from, contract_address);
1389         return true;
1390     }
1391     event spend_egst (address from, uint tokens, uint reason);
1392 
1393 
1394     function create_token_order (uint unit_price, uint egst_amount) public returns (uint) {      
1395         require(unit_price >= min_unit_price && unit_price <= max_unit_price 
1396         && balances[msg.sender] >= egst_amount
1397         && egst_amount <= max_egst_amount
1398         && egst_amount >= min_egst_amount);
1399 
1400         count_token_orders = add(count_token_orders, 1);
1401 
1402         egst_to_contract(msg.sender, egst_amount, 3); // 3 create_token_order
1403         
1404         token_orders[count_token_orders].start_selling_block = block.number;    
1405         token_orders[count_token_orders].seller = msg.sender;
1406         token_orders[count_token_orders].unit_price = unit_price;
1407         token_orders[count_token_orders].egst_amount = egst_amount;
1408         gods[msg.sender].count_token_orders++;
1409         
1410         update_first_active_token_order(msg.sender);
1411 
1412         return gods[msg.sender].count_token_orders++;
1413     }
1414 
1415 
1416     function withdraw_token_order (uint order_id) public returns (bool) { 
1417         require (msg.sender == token_orders[order_id].seller
1418                 && token_orders[order_id].egst_amount > 0);
1419 
1420         uint egst_amount = token_orders[order_id].egst_amount;
1421         token_orders[order_id].start_selling_block = 0;
1422         token_orders[order_id].egst_amount = 0;
1423         // balances[msg.sender] = add(balances[msg.sender], tokens);
1424         egst_from_contract(msg.sender, egst_amount, 4); // 4  withdraw token_order
1425         gods[msg.sender].count_token_orders = sub(gods[msg.sender].count_token_orders, 1);
1426         
1427         update_first_active_token_order(msg.sender);
1428         emit WithdrawTokenOrder(msg.sender, order_id);
1429 
1430         return true;
1431     }
1432     event WithdrawTokenOrder (address seller, uint order_id);
1433 
1434     function buy_token (uint order_id, uint egst_amount) public payable returns (uint) { 
1435 
1436         require(order_id >= first_active_token_order 
1437                 && order_id <= count_token_orders
1438                 && egst_amount <= token_orders[order_id].egst_amount
1439                 && token_orders[order_id].egst_amount > 0);
1440         
1441         // unit_price 100 means 1 egst = 0.001 ether
1442         uint eth_cost = div(mul(token_orders[order_id].unit_price, egst_amount), 100000);
1443         require(msg.value >= eth_cost && msg.value < add(eth_cost, max_extra_eth) );
1444 
1445         token_orders[order_id].egst_amount = sub(token_orders[order_id].egst_amount, egst_amount);
1446         egst_from_contract(msg.sender, egst_amount, token_orders[order_id].unit_price); // uint price (> 10) will be recorded as reason in change log and translated by front end as buy token & unit_price
1447         // balances[msg.sender] = add(balances[msg.sender], egst_amount);
1448         
1449         address seller = token_orders[order_id].seller;
1450         egses_from_contract(seller, eth_cost, 7); // 7 sell egst
1451         
1452         
1453         if (token_orders[order_id].egst_amount <= 0){
1454             token_orders[order_id].start_selling_block = 0;
1455             gods[seller].count_token_orders = sub(gods[seller].count_token_orders, 1);
1456             update_first_active_token_order(seller);
1457         }
1458         
1459         emit BuyToken(msg.sender, order_id, egst_amount);
1460 
1461         return token_orders[order_id].egst_amount;
1462     }
1463     event BuyToken (address buyer, uint order_id, uint egst_amount);
1464 
1465   
1466     function update_first_active_token_order (address god_address) private returns (uint, uint){ // public when testing
1467         if (count_token_orders > 0 
1468         && first_active_token_order == 0){
1469             first_active_token_order = 1;
1470         } else {
1471             for (uint i = first_active_token_order; i <= count_token_orders; i++) {
1472                 if (add(token_orders[i].start_selling_block, order_duration) > block.number){
1473                     // find the first active order and compare with the currect index
1474                     if (i > first_active_token_order){
1475                         first_active_token_order = i;
1476                     }
1477                     break;
1478                 }
1479             }    
1480         }
1481             
1482         if (gods[god_address].count_token_orders > 0
1483         && gods[god_address].first_active_token_order == 0){
1484             gods[god_address].first_active_token_order = 1; // may not be 1, but it will correct next time
1485         } else {
1486             for (uint j = gods[god_address].first_active_token_order; j < count_token_orders; j++){
1487                 if (token_orders[j].seller == god_address 
1488                 && token_orders[j].start_selling_block > 0){ // don't check duration, show it to selling, even if expired
1489                     // find the first active order and compare with the currect index
1490                     if(j > gods[god_address].first_active_token_order){
1491                         gods[god_address].first_active_token_order = j;
1492                     }
1493                     break;
1494                 }
1495             }
1496         }
1497         
1498         return (first_active_token_order, gods[msg.sender].first_active_token_order);
1499     }
1500 
1501 
1502     function get_token_order (uint order_id) public view returns(uint, address, uint, uint){
1503         require(order_id >= 1 && order_id <= count_token_orders);
1504 
1505         return(token_orders[order_id].start_selling_block,
1506                token_orders[order_id].seller,
1507                token_orders[order_id].unit_price,
1508                token_orders[order_id].egst_amount);
1509     }
1510 
1511     // return total orders and lowest price to browser, browser query each active order and show at most three orders of lowest price
1512     function get_token_orders () public view returns(uint, uint, uint, uint, uint) {
1513         uint lowest_price = max_unit_price;
1514         for (uint i = first_active_token_order; i <= count_token_orders; i++){
1515             if (token_orders[i].unit_price < lowest_price 
1516             && token_orders[i].egst_amount > 0
1517             && add(token_orders[i].start_selling_block, order_duration) > block.number){
1518                 lowest_price = token_orders[i].unit_price;
1519             }
1520         }
1521         return (count_token_orders, first_active_token_order, order_duration, max_unit_price, lowest_price);
1522     }
1523     
1524 
1525     function get_my_token_orders () public view returns(uint []) {
1526         uint my_count_token_orders = gods[msg.sender].count_token_orders;
1527         uint [] memory temp_list = new uint[] (my_count_token_orders);
1528         uint count_list_elements = 0;
1529         for (uint i = gods[msg.sender].first_active_token_order; i <= count_token_orders; i++){
1530             if (token_orders[i].seller == msg.sender
1531             && token_orders[i].start_selling_block > 0){
1532                 temp_list[count_list_elements] = i;
1533                 count_list_elements++;
1534                 
1535                 if (count_list_elements >= my_count_token_orders){
1536                     break;
1537                 }
1538             }
1539         }
1540 
1541         return temp_list;
1542     }
1543 
1544 
1545     // end of egst
1546     
1547    
1548     // logs
1549     function get_winner_log (uint pray_round, uint log_id) public view returns (uint, bytes32, address, address, uint, bool){
1550         require(log_id >= 1 && log_id <= count_rounds_winner_logs[pray_round]);
1551         winner_log storage this_winner_log = winner_logs[pray_round][log_id];
1552         return (this_winner_log.god_block_number,
1553                 this_winner_log.block_hash,
1554                 this_winner_log.prayer,
1555                 this_winner_log.previous_winner,
1556                 this_winner_log.prize,
1557                 this_winner_log.pk_result);
1558     }    
1559 
1560     function get_count_rounds_winner_logs (uint pray_round) public view returns (uint){
1561         return count_rounds_winner_logs[pray_round];
1562     }
1563 
1564 
1565     // egses change reasons:  
1566         // 1 pray_reward, 2 god_reward for being invited, 3 inviter_reward,
1567         // 4 admin_deposit to reward_pool, 5 withdraw egses
1568         // 6 sell amulet, 7 sell egst, 8 withdraw bid
1569     
1570     // egst_change reasons: 
1571         // 1 pray_reward, 2 top_gods_reward, 
1572         // 3 create_token_order, 4 withdraw token_order, 5 buy token (> 10),  
1573         // 6 upgrade pet, 7 upgrade amulet, 8 admin_reward, 
1574         // 9 transfer, 10 transferFrom(owner & receiver)
1575 
1576         
1577     function create_change_log (uint asset_type, uint reason, uint change_amount, uint after_amount, address _from, address _to) private returns (uint) {
1578         count_rounds_change_logs[count_rounds] = add(count_rounds_change_logs[count_rounds], 1);
1579         uint log_id = count_rounds_change_logs[count_rounds];
1580  
1581         change_logs[count_rounds][log_id].block_number = block.number;
1582         change_logs[count_rounds][log_id].asset_type = asset_type;
1583         change_logs[count_rounds][log_id].reason = reason;
1584         change_logs[count_rounds][log_id].change_amount = change_amount;
1585         change_logs[count_rounds][log_id].after_amount = after_amount; 
1586         change_logs[count_rounds][log_id]._from = _from;
1587         change_logs[count_rounds][log_id]._to = _to;
1588         
1589         return log_id;
1590     }
1591           
1592     function get_change_log (uint pray_round, uint log_id) public view returns (uint, uint, uint, uint, uint, address, address){ // public
1593         change_log storage this_log = change_logs[pray_round][log_id];
1594         return (this_log.block_number,
1595                 this_log.asset_type,
1596                 this_log.reason, // reason > 10 is buy_token unit_price
1597                 this_log.change_amount,
1598                 this_log.after_amount, // god's after amount. transfer or transferFrom doesn't record log
1599                 this_log._from,
1600                 this_log._to);
1601         
1602     }
1603     
1604     function get_count_rounds_change_logs (uint pray_round) public view returns(uint){
1605         return count_rounds_change_logs[pray_round];
1606     }
1607     
1608     // end of logs
1609 
1610 
1611     // common functions
1612 
1613      function add (uint a, uint b) internal pure returns (uint c) {
1614          c = a + b;
1615          require(c >= a);
1616      }
1617      function sub (uint a, uint b) internal pure returns (uint c) {
1618         require(b <= a);
1619          c = a - b;
1620      }
1621      function mul (uint a, uint b) internal pure returns (uint c) {
1622          c = a * b;
1623          require(a == 0 || c / a == b);
1624      }
1625      function div (uint a, uint b) internal pure returns (uint c) {
1626          require(b > 0);
1627          c = a / b;
1628      }
1629 
1630 }
1631 
1632 contract EthGodsDice {
1633     
1634     // ethgods
1635     EthGods private eth_gods;
1636     address private ethgods_contract_address = address(0);// publish ethgods first, then use that address in constructor 
1637     function set_eth_gods_contract_address(address eth_gods_contract_address) public returns (bool){
1638         require (msg.sender == admin);
1639         
1640         ethgods_contract_address = eth_gods_contract_address;
1641         eth_gods = EthGods(ethgods_contract_address); 
1642         return true;
1643     }
1644   
1645     address private admin; // manually update to ethgods' admin
1646     uint private block_hash_duration;
1647     function update_admin () public returns (bool){
1648         (,,address new_admin, uint new_block_hash_duration,,,) = eth_gods.query_contract();
1649         require (msg.sender == new_admin);
1650         admin = new_admin;
1651         block_hash_duration = new_block_hash_duration;
1652         return true;
1653     }
1654         
1655     //contract information & administration
1656     bool private contract_created; // in case constructor logic change in the future
1657     address private contract_address; //shown at the top of the home page
1658     
1659     // start of constructor and destructor
1660     constructor () public {
1661         require (contract_created == false);
1662         contract_created = true;
1663         contract_address = address(this);
1664         admin = msg.sender;
1665 
1666     }
1667 
1668     function finalize () public {
1669         require (msg.sender == admin);
1670         selfdestruct(msg.sender); 
1671     }
1672     
1673     function () public payable {
1674         revert();  // if received eth for no reason, reject
1675     }
1676     
1677     // end of constructor and destructor
1678 
1679     function tell_fortune_blockhash () public view returns (bytes32){
1680         bytes32 block_hash;
1681         (uint god_block_number,,,,,,) = eth_gods.get_god_info(msg.sender);
1682         if (god_block_number > 0
1683             && add(god_block_number, 1) < block.number
1684             && add(god_block_number, block_hash_duration) > block.number) {
1685             block_hash = keccak256(abi.encodePacked(blockhash(god_block_number + 1)));
1686         } else {
1687             block_hash = keccak256(abi.encodePacked(blockhash(block.number - 1)));
1688         }
1689         return block_hash;
1690     }
1691     
1692         
1693     function tell_fortune () public view returns (uint[]){
1694         bytes32 block_hash;
1695         (uint god_block_number,,,,,,) = eth_gods.get_god_info(msg.sender);
1696         if (god_block_number > 0
1697             && add(god_block_number, 1) < block.number
1698             && add(god_block_number, block_hash_duration) > block.number) {
1699             block_hash = keccak256(abi.encodePacked(blockhash(god_block_number + 1)));
1700         } else {
1701             block_hash = keccak256(abi.encodePacked(blockhash(block.number - 1)));
1702         }
1703         return throw_dice (block_hash);
1704     }
1705 
1706     
1707     function throw_dice (bytes32 block_hash) public pure returns (uint[]) {// 0 for prize, 1-6 for 6 numbers should be pure
1708         uint[] memory dice_numbers = new uint[](7);
1709         //uint [7] memory dice_numbers;
1710         uint hash_number;
1711         uint[] memory count_dice_numbers = new uint[](7);
1712         //uint [7] memory count_dice_numbers;   // how many times for each dice number
1713         uint i; // for loop
1714   
1715         for (i = 1; i <= 6; i++) {
1716             hash_number = uint(block_hash[i]);
1717             // hash_number=1;
1718             if (hash_number >= 214) { // 214
1719                 dice_numbers[i] = 6;
1720             } else if (hash_number >= 172) { // 172
1721                 dice_numbers[i] = 5;
1722             } else if (hash_number >= 129) { // 129
1723                 dice_numbers[i] = 4;
1724             } else if (hash_number >= 86) { // 86
1725                 dice_numbers[i] = 3;
1726             } else if (hash_number >= 43) { // 43
1727                 dice_numbers[i] = 2;
1728             } else {
1729                 dice_numbers[i] = 1;
1730             }
1731             count_dice_numbers[dice_numbers[i]] ++;
1732         }
1733 
1734         bool won_super_prize = false;
1735         uint count_super_eth = 0;
1736         for (i = 1; i <= 6; i++) {
1737             if (count_dice_numbers[i] >= 5) {
1738                 dice_numbers[0] = 1; //champion_eth
1739                 won_super_prize = true;
1740                 break;
1741             }else if (count_dice_numbers[i] == 4) {
1742                 dice_numbers[0] = 3; // super_egst
1743                 won_super_prize = true;
1744                 break;
1745             }else if (count_dice_numbers[i] == 1) {
1746                 count_super_eth ++;
1747                 if (count_super_eth == 6) {
1748                     dice_numbers[0] = 2; // super_eth
1749                     won_super_prize = true;
1750                 }
1751             } 
1752         }
1753 
1754         if (won_super_prize == false) {
1755             if (count_dice_numbers[6] >= 2){
1756                 dice_numbers[0] = 4; // primary_egst
1757             } else if (count_dice_numbers[6] == 1){
1758                 dice_numbers[0] = 5; // lucky_star
1759             } 
1760         }
1761         
1762         return dice_numbers;
1763     }
1764     
1765     function pk (bytes32 block_hash, uint attacker_sum_god_levels, uint attacker_sum_amulet_levels, uint defender_sum_god_levels, uint defender_sum_amulet_levels) public pure returns (bool){
1766      
1767         uint god_win_chance;
1768         attacker_sum_god_levels = add(attacker_sum_god_levels, 10);
1769         if (attacker_sum_god_levels < defender_sum_god_levels){
1770             god_win_chance = 0;
1771         } else {
1772             god_win_chance = sub(attacker_sum_god_levels, defender_sum_god_levels);
1773             if (god_win_chance > 20) {
1774                 god_win_chance = 100;
1775             } else { // equal level, 50% chance to win
1776                 god_win_chance = mul(god_win_chance, 5);
1777             }
1778         }        
1779         
1780         
1781         uint amulet_win_chance;
1782         attacker_sum_amulet_levels = add(attacker_sum_amulet_levels, 10);
1783         if (attacker_sum_amulet_levels < defender_sum_amulet_levels){
1784             amulet_win_chance = 0;
1785         } else {
1786             amulet_win_chance = sub(attacker_sum_amulet_levels, defender_sum_amulet_levels);
1787             if (amulet_win_chance > 20) {
1788                 amulet_win_chance = 100;
1789             } else { // equal level, 50% chance to win
1790                 amulet_win_chance = mul(amulet_win_chance, 5);
1791             }
1792         }
1793 
1794         
1795         uint attacker_win_chance = div(add(god_win_chance, amulet_win_chance), 2);
1796         if (attacker_win_chance >= div(mul(uint(block_hash[3]),2),5)){
1797             return true;
1798         } else {
1799             return false;
1800         }
1801         
1802     }
1803     
1804     
1805     // common functions
1806 
1807      function add (uint a, uint b) internal pure returns (uint c) {
1808          c = a + b;
1809          require(c >= a);
1810      }
1811      function sub (uint a, uint b) internal pure returns (uint c) {
1812         require(b <= a);
1813          c = a - b;
1814      }
1815      function mul (uint a, uint b) internal pure returns (uint c) {
1816          c = a * b;
1817          require(a == 0 || c / a == b);
1818      }
1819      function div (uint a, uint b) internal pure returns (uint c) {
1820          require(b > 0);
1821          c = a / b;
1822      }
1823         
1824 }
1825 
1826 
1827 contract EthGodsName {
1828 
1829     // EthGods
1830     EthGods private eth_gods;
1831     address private ethgods_contract_address;   
1832     function set_eth_gods_contract_address (address eth_gods_contract_address) public returns (bool){
1833         require (msg.sender == admin);
1834         
1835         ethgods_contract_address = eth_gods_contract_address;
1836         eth_gods = EthGods(ethgods_contract_address); 
1837         return true;
1838     }
1839   
1840     address private admin; // manually update to ethgods' admin
1841     function update_admin () public returns (bool){
1842         (,,address new_admin,,,,) = eth_gods.query_contract();
1843         require (msg.sender == new_admin);
1844         admin = new_admin;
1845         return true;
1846     }
1847 
1848     //contract information & administration
1849     bool private contract_created; // in case constructor logic change in the future
1850     address private contract_address; //shown at the top of the home page   
1851     
1852     string private invalid_chars = "\\\"";
1853     bytes private invalid_bytes = bytes(invalid_chars);
1854     function set_invalid_chars (string new_invalid_chars) public returns (bool) {
1855         require(msg.sender == admin);
1856         invalid_chars = new_invalid_chars;
1857         invalid_bytes = bytes(invalid_chars);
1858         return true;
1859     }
1860     
1861     uint private valid_length = 16;    
1862     function set_valid_length (uint new_valid_length) public returns (bool) {
1863         require(msg.sender == admin);
1864         valid_length = new_valid_length;
1865         return true;
1866     }
1867     
1868     struct god_name {
1869         string god_name;
1870         uint block_number;
1871         uint block_duration;
1872     }
1873     mapping (address => god_name) private gods_name;
1874 
1875     // start of constructor and destructor
1876     
1877     constructor () public {    
1878         require (contract_created == false);
1879         contract_created = true;
1880         contract_address = address(this);
1881         admin = msg.sender;     
1882         address v_god = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
1883         gods_name[v_god].god_name = "V";
1884     }
1885 
1886     function () public payable {
1887         revert();  // if received eth for no reason, reject
1888     }
1889 
1890     function finalize() public {
1891         require (msg.sender == admin);
1892         selfdestruct(msg.sender); 
1893     }
1894     
1895     // end of constructor and destructor
1896     
1897     
1898     function set_god_name (string new_name) public returns (bool){
1899         address god_address = msg.sender;
1900         require (add(gods_name[god_address].block_number, gods_name[god_address].block_duration) < block.number );
1901 
1902         bytes memory bs = bytes(new_name);
1903         require (bs.length <= valid_length);
1904         
1905         for (uint i = 0; i < bs.length; i++){
1906             for (uint j = 0; j < invalid_bytes.length; j++) {
1907                 if (bs[i] == invalid_bytes[j]){
1908                     return false;
1909                 } 
1910             }
1911         }
1912 
1913         gods_name[god_address].god_name = new_name;
1914         emit set_name(god_address, new_name);
1915         return true;
1916     }
1917     event set_name (address indexed god_address, string new_name);
1918 
1919 
1920     function get_god_name (address god_address) public view returns (string) {
1921         return gods_name[god_address].god_name;
1922     }
1923 
1924     function block_god_name (address god_address, uint block_duration) public {
1925         require (msg.sender == admin);
1926         gods_name[god_address].god_name = "Unkown";
1927         gods_name[god_address].block_number = block.number;
1928         gods_name[god_address].block_duration = block_duration;
1929     }
1930     
1931     function add (uint a, uint b) internal pure returns (uint c) {
1932         c = a + b;
1933         require(c >= a);
1934     }
1935 }
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
49         uint free_rounds; // to check if has used free dice in this round
50         uint paid_rounds; // to check if has paid for extra dice in this round
51         bool hosted_pray; // auto waitlist, when enlisted. others can invite, once hosted pray
52         uint bid_eth; // bid to host pray
53         
54         uint credit; // gained from the amulet invitation spending of invited fellows
55         uint count_amulets_generated;
56         uint first_amulet_generated;
57         uint count_amulets_at_hand;
58         uint count_amulets_selling;
59         uint amulets_start_id;
60         uint amulets_end_id;
61         
62         uint count_token_orders;
63         uint first_active_token_order;
64 
65         uint last_ticket_number;
66         uint count_tickets;
67 
68         uint inviter_id; // who invited this fellow to this world
69         uint count_gods_invited; // gods invited to this game by this god.
70         
71         
72     }
73     uint private count_gods = 0; // Used when generating id for a new player, 
74     mapping(address => god) private gods; // everyone is a god
75     mapping(uint => address) private gods_address; // gods' address => god_id
76 
77     uint [] private listed_gods; // id of listed gods
78     uint private max_listed_gods = 10000; // adjustable
79 
80     uint private initial_invite_price = 0.02 ether; // grows with each invitation for this god
81     uint private invite_price_increase = 0.02 ether; // grows by this amount with each invitation
82     uint private max_invite_price = 1000 ether; // adjustable
83     uint private max_extra_eth = 0.001 ether; // adjustable
84 
85     uint private list_level = 10; // start from level 10
86     uint private max_gas_price = 100000000000; // 100 gwei for invite and pray, adjustable
87     
88     // amulet
89     struct amulet {
90         uint god_id;
91         address owner;
92         uint level;
93         uint bound_start_block;// can't sell, if just got
94         uint start_selling_block; // can't bind & use in pk, if selling
95         uint price; // set to 0, when withdraw from selling or bought
96     }
97     uint private count_amulets = 0; 
98     mapping(uint => amulet) private amulets; // public when testing
99     uint private bound_duration = 9000; // once bought, wait a while before sell it again, adjustable
100     uint private order_duration = 20000; // valid for about 3 days, then not to show to public in selling amulets/token orders, but still show in my_selling amulets/token orders. adjustable
101 
102     // pray
103     address private pray_host_god; // public when testing
104     bool private pray_reward_top100; // if hosted by new god, reward top 100 gods egst
105     uint private pray_start_block; // public when testing
106     bool private rewarded_pray_winners = false;
107 
108     uint private count_hosted_gods; // gods hosted pray (event started). If less than bidding gods, there are new gods waiting to host pray, 
109     mapping (uint => address) private bidding_gods; // every listed god and bid to host pray
110     uint private initializer_reward = 60; // reward the god who burned gas to send pray rewards to community, adjustable
111     uint private double_egst_fee = 0.006 ether; // adjustable
112     
113     mapping(uint => uint) private max_winners;  // max winners for each prize  
114     uint private round_duration = 6666; // 6000, 600 in CBT, 60 in dev, adjustable
115 
116     // ticket
117     struct ticket {
118         address owner;
119         uint block_number;
120         bytes32 block_hash;
121         uint new_ticket_number;
122         uint dice_result;
123     }
124     uint private count_tickets;
125     mapping (uint => ticket) private tickets;
126     uint private used_tickets;
127 
128     uint private max_show_tickets = 20; //  public when testing
129 
130     mapping(uint => uint) private pk_positions; // public when testing
131     mapping(uint => uint) private count_listed_winners; // count for 5 prizes, public in testing
132     mapping (uint => mapping(uint => address)) private listed_winners; // winners for 5 prizes
133 
134     bool private reEntrancyMutex = false; // for sendnig eth to msg.sender
135     
136     uint private pray_egses = 0; // lottery treasury
137     uint private pray_egst = 0;  // lottery treasury
138     uint private reward_pool_egses = 0; // 10% of pray_egses, for top 3 winners
139     uint private reward_pool_egst = 0; // 10% of pray_egst, for EGST floor winners
140 
141     mapping(address => uint) egses_balances;
142         
143 
144     // eth_gods_token (EGST)
145     string public name = "EthGodsToken";
146     string public symbol = "EGST";
147     uint8 public constant decimals = 18; //same as ethereum
148     uint private _totalSupply;
149     mapping(address => uint) balances; // bought or gained from pray or revenue share
150     mapping(address => mapping(address => uint)) allowed;
151   
152 
153     struct token_order {
154         uint id;
155         uint start_selling_block;
156         address seller;
157         uint unit_price;
158         uint egst_amount;
159     }
160     uint private count_token_orders = 0;
161     mapping (uint => token_order) token_orders;
162     uint private first_active_token_order = 0;
163 
164     uint private min_unit_price = 20; // 1 egst min value is 0.0002 ether, adjustable
165     uint private max_unit_price = 200; // 1 egst max value is 0.002 ether, adjustable
166     uint private max_egst_amount = 1000000 ether; // for create_token_order, adjustable
167     uint private min_egst_amount = 0.00001 ether; // for create_token_order, adjustable
168  
169  
170     //logs
171     uint private count_rounds = 0;
172     
173     struct winner_log { // win a prize and if pk
174         address previous_winner;
175         uint prize;
176         bool pk_result;
177         uint ticket_number;
178     }
179     mapping (uint => uint) private count_rounds_winner_logs;
180     mapping(uint => mapping(uint => winner_log)) private winner_logs;
181     
182     struct change_log {
183         uint block_number;
184         uint asset_type; // 1 egst, 2 eth_surplus
185         
186         // egses change reasons:  
187             // 1 pray_reward, 2 god_reward for being invited, 3 inviter_reward,
188             // 4 admin_deposit to reward_pool, 5 withdraw egses
189             // 6 sell amulet, 7 sell egst, 8 withdraw bid
190         
191         // egst_change reasons: 
192             // 1 pray_reward, 2 top_gods_reward, 
193             // 3 create_token_order, 4 withdraw token_order, 5 buy token,  
194             // 6 upgrade pet, 7 upgrade amulet, 8 admin_reward
195         
196         uint reason; // > 10 is buy token unit_price
197         uint change_amount;
198         uint after_amount;
199         address _from;
200         address _to;
201     }
202     mapping (uint => uint) private count_rounds_change_logs;
203     mapping(uint => mapping(uint => change_log)) private change_logs;
204 
205     // end of database
206   
207     
208     // start of constructor
209     constructor () public {
210         require (contract_created == false);
211         contract_created = true;
212         contract_address = address(this);
213         admin = msg.sender;
214 
215         create_god(admin, 0);
216         create_god(v_god, 0);
217         gods[v_god].level = 10;
218         enlist_god(v_god);
219         
220         max_winners[1] = 1; // 1
221         max_winners[2] = 2; // 2
222         max_winners[3] = 6; // 6
223 
224         _totalSupply = 6000000 ether;
225         pray_egst = 2000 ether;
226         balances[admin] = sub(_totalSupply, pray_egst);
227   
228         initialize_pray();
229     }
230     
231     // destruct for testing contracts. can't destruct since round 3
232     function finalize() public {
233         require(msg.sender == admin && count_rounds <= 3);
234         selfdestruct(admin); 
235     }
236     
237 
238     function () public payable {
239         revert ();
240     }   
241     // end of constructor
242      
243          
244     //start of contract information & administration
245     
246     function get_controller () public view returns (address, address){
247         require (msg.sender == admin || msg.sender == controller1  || msg.sender == controller2);
248         return (controller1, controller2);
249     }
250     
251     function set_controller (uint controller_index, address new_controller_address) public returns (bool){
252         if (controller_index == 1){
253             require(msg.sender == controller2);
254             controller1 = new_controller_address;
255         } else {
256             require(msg.sender == controller1);
257             controller2 = new_controller_address;            
258         }
259         return true;
260     }
261      
262     function set_admin (address new_admin_address) public returns (bool) {
263         require (msg.sender == controller1 || msg.sender == controller2);
264         // admin don't have game attributes, such as level'
265         // no need to transfer egses and egst to new_admin_address
266         delete gods[admin];
267         delete gods_address[0];
268         admin = new_admin_address;
269         gods_address[0] = admin;
270         gods[admin].god_id = 0;
271         return true;
272     }  
273     
274     // update system parameters
275     function set_parameters (uint parameter_type, uint new_parameter) public returns (bool){
276         require (msg.sender == admin);
277         if (parameter_type == 1) {
278             // max_pray_duration = new_parameter;
279         } else if (parameter_type == 2) {
280             // min_pray_duration = new_parameter;
281             round_duration = new_parameter;
282         } else if (parameter_type == 3) {
283             block_hash_duration = new_parameter;
284         } else if (parameter_type == 4) {
285             double_egst_fee = new_parameter;
286         } else if (parameter_type == 5) {
287             order_duration = new_parameter;
288         } else if (parameter_type == 6) {
289             bound_duration = new_parameter;
290         } else if (parameter_type == 7) {
291             initializer_reward = new_parameter;
292         } else if (parameter_type == 8) {
293             max_extra_eth = new_parameter;
294         } else if (parameter_type == 9) {
295             min_unit_price = new_parameter;
296         } else if (parameter_type == 10) {
297             max_unit_price = new_parameter;
298         } else if (parameter_type == 11) {
299             max_listed_gods = new_parameter;
300         } else if (parameter_type == 12) {
301             max_gas_price = new_parameter;
302         } else if (parameter_type == 13) {
303             max_invite_price = new_parameter;
304         } else if (parameter_type == 14) {
305             min_egst_amount = new_parameter;
306         } else if (parameter_type == 15) {
307             max_egst_amount = new_parameter;
308         } else if (parameter_type == 16) {
309             max_show_tickets = new_parameter;
310         } 
311         return true;
312     }  
313         
314     function set_strings (uint string_type, string new_string) public returns (bool){
315         require (msg.sender == admin);
316         
317         if (string_type == 1){
318             official_url = new_string;
319         } else if (string_type == 2){
320             name = new_string; // egst name
321         } else if (string_type == 3){
322             symbol = new_string; // egst symbol
323         } else if (string_type == 4){
324             contact_email = new_string; // egst symbol
325         } else if (string_type == 5){
326             reEntrancyMutex = false; // repair contract, if blocked somehow in longlong future
327         }
328         return true;
329     } 
330     
331     // reset lottery event, if it's blocked 
332     function admin_reset_pray() public returns (bool){
333         require (msg.sender == admin);
334         
335         if (pray_start_block > block.number){
336             pray_start_block = block.number;
337         }  else if (check_event_completed() == true) {
338             if (rewarded_pray_winners == false){
339                 reward_pray_winners();
340             } else {
341                 initialize_pray();
342             }
343         }
344     }
345     
346     //end of contract information & administration
347     
348 
349     function query_contract () public view returns(address, address, address, uint, uint, bool, bool){
350         (uint highest_bid, address highest_bidder) = compare_bid_eth(); 
351         return (admin,
352                 pray_host_god,
353                 highest_bidder,
354                 highest_bid,
355                 block_hash_duration,
356                 pray_reward_top100,
357                 rewarded_pray_winners
358                );
359     }
360     
361     function query_contract2 () public view returns (string, string, address, bool){
362         return (official_url, contact_email, v_god, reEntrancyMutex);
363     }    
364                     
365     function query_uints () public view returns (uint[32] uints){
366         uints[0] = max_invite_price;
367         uints[1] = list_level;
368         uints[2] = _totalSupply;
369         uints[3] = round_duration;
370         uints[4] = initializer_reward;
371         uints[5] = min_unit_price;
372         uints[6] = max_unit_price;
373         uints[7] = max_listed_gods;
374         uints[8] = max_gas_price;
375         uints[9] = min_egst_amount;
376         uints[10] = max_egst_amount;
377         uints[11] = max_extra_eth;
378         uints[12] = pray_start_block;
379         uints[13] = pray_egses;
380         uints[14] = pray_egst;
381         uints[15] = count_rounds;
382         uints[16] = count_gods;
383         uints[17] = listed_gods.length;
384         uints[18] = order_duration;
385         uints[19] = bound_duration;
386         uints[20] = initial_invite_price;
387         uints[21] = invite_price_increase;
388         uints[22] = max_invite_price;
389         uints[23] = count_amulets;
390         uints[24] = count_hosted_gods;
391         uints[25] = used_tickets;
392         uints[26] = double_egst_fee;
393         uints[27] = count_tickets;
394         uints[28] = reward_pool_egses;
395         uints[29] = reward_pool_egst;
396         uints[30] = block.number;
397         uints[31] = contract_address.balance;
398 
399         return uints;
400     }
401     
402   
403     //end of contract information & administration
404 
405     
406     // god related functions: create_god, upgrade_pet, add_exp, invite, enlist
407     
408     function create_god (address god_address, uint inviter_id) private returns(uint god_id){ // created by the contract // public when testing
409         // check if the god is already created
410         if (gods[god_address].credit == 0) { // create admin as god[0]
411 
412             god_id = count_gods; // 1st god's id is admin 0
413             count_gods = add(count_gods, 1) ;
414             gods_address[god_id] = god_address;
415             gods[god_address].god_id = god_id;
416             gods[god_address].credit = 0.001 ether; // give 0.001 ether credit, so we know this address has a god
417                        
418             if (god_id > 0 && inviter_id > 0 && inviter_id < count_gods){ // not admin
419                 set_inviter(inviter_id);
420             }
421             
422             return god_id;
423         }
424     }
425     
426     function set_inviter (uint inviter_id) private returns (bool){
427         if (inviter_id > 0 && gods_address[inviter_id] != address(0)
428         && gods[msg.sender].inviter_id == 0
429         && gods[gods_address[inviter_id]].inviter_id != gods[msg.sender].god_id){
430             gods[msg.sender].inviter_id = inviter_id;
431             address inviter_address = gods_address[inviter_id];
432             gods[inviter_address].count_gods_invited = add(gods[inviter_address].count_gods_invited, 1);
433             return true;
434         }
435     }
436 
437     function add_exp (address god_address, uint exp_up) private returns(uint new_level, uint new_exp) { // public when testing
438         if (god_address == admin){
439             return (0,0);
440         }
441         if (gods[god_address].god_id == 0){
442             create_god(god_address, 0);
443         }
444         new_exp = add(gods[god_address].exp, exp_up);
445         uint current_god_level = gods[god_address].level;
446         uint level_up_exp;
447         new_level = current_god_level;
448 
449         for (uint i=0;i<10;i++){ // if still have extra exp, level up next time
450             if (current_god_level < 99){
451                 level_up_exp = mul(10, add(new_level, 1));
452             } else {
453                 level_up_exp = 1000;
454             }
455             if (new_exp >= level_up_exp){
456                 new_exp = sub(new_exp, level_up_exp);
457                 new_level = add(new_level, 1);
458             } else {
459                 break;
460             }
461         }
462 
463         gods[god_address].exp = new_exp;
464 
465         if(new_level > current_god_level) {
466             gods[god_address].level = new_level;
467             if (gods[god_address].listed > 0) {
468                 if (listed_gods.length > 1) {
469                     sort_gods(gods[god_address].god_id);
470                 }
471             } else if (new_level >= list_level && listed_gods.length < max_listed_gods) {
472                 enlist_god(god_address);
473             }
474         }
475         
476         return (new_level, new_exp);
477     }
478 
479    
480     function enlist_god (address god_address) private returns (uint) { // public when testing
481         require(gods[god_address].level >= list_level && god_address != admin);
482                 
483         // if the god is not listed yet, enlist and add level requirement for the next enlist
484         if (gods[god_address].listed == 0) {
485             uint god_id = gods[god_address].god_id;
486             if (god_id == 0){
487                 god_id = create_god(god_address, 0); // get a god_id and set inviter as v god
488             }
489             gods[god_address].listed = listed_gods.push(god_id); // start from 1, 0 is not listed
490             gods[god_address].invite_price = initial_invite_price;
491 
492             list_level = add(list_level, 1);
493             bidding_gods[listed_gods.length] = god_address;
494             
495         }
496         return list_level;
497     }
498     
499     function sort_gods_admin(uint god_id) public returns (bool){
500         require (msg.sender == admin);
501         sort_gods(god_id);
502         return true;
503     }
504 
505 
506     // when a listed god level up and is not top 1 of the list, compare power with higher god, if higher than the higher god, swap position
507     function sort_gods (uint god_id) private returns (uint){ 
508         require (god_id > 0);
509         uint list_length = listed_gods.length;
510         if (list_length > 1) {
511             address god_address = gods_address[god_id];
512             uint this_god_listed = gods[god_address].listed;
513             if (this_god_listed < list_length) {
514                 uint higher_god_listed = add(this_god_listed, 1);
515                 uint higher_god_id = listed_gods[sub(higher_god_listed, 1)];
516                 address higher_god = gods_address[higher_god_id];
517                 if(gods[god_address].level > gods[higher_god].level
518                 || (gods[god_address].level == gods[higher_god].level
519                     && gods[god_address].exp > gods[higher_god].exp)){
520                         listed_gods[sub(this_god_listed, 1)] = higher_god_id;
521                         listed_gods[sub(higher_god_listed, 1)] = god_id;
522                         gods[higher_god].listed = this_god_listed;
523                         gods[god_address].listed = higher_god_listed;
524                 }
525             }
526         }
527         return gods[god_address].listed;
528     }
529 
530 
531     function invite (uint god_id) public payable returns (uint new_invite_price)  {
532         address god_address = gods_address[god_id];
533         require(god_id > 0 
534                 && god_id <= count_gods
535                 && gods[god_address].hosted_pray == true
536                 && tx.gasprice <= max_gas_price
537                 );
538 
539         uint invite_price = gods[god_address].invite_price;
540 
541         require(msg.value >= invite_price); 
542 
543         if (add(invite_price, invite_price_increase) <= max_invite_price) {
544             gods[god_address].invite_price = add(invite_price, invite_price_increase);
545         }
546         
547         uint exp_up = div(invite_price, (10 ** 15)); // 1000 exp for each eth
548         add_exp(god_address, exp_up);
549         add_exp(msg.sender, exp_up);
550        
551         //generate a new amulet of this god for the inviter
552         count_amulets = add(count_amulets, 1);
553         amulets[count_amulets].god_id = god_id;
554         amulets[count_amulets].owner = msg.sender;
555 
556         gods[god_address].count_amulets_generated = add(gods[god_address].count_amulets_generated, 1);
557         if (gods[god_address].count_amulets_generated == 1){
558             gods[god_address].first_amulet_generated = count_amulets;
559         }
560         gods[msg.sender].count_amulets_at_hand = add(gods[msg.sender].count_amulets_at_hand, 1);
561         update_amulets_count(msg.sender, count_amulets, true);
562 
563         // invite_price to egses: 60% to pray_egses, 20% to god, 20 to promoter/admin
564         pray_egses = add(pray_egses, div(mul(60, invite_price), 100)); 
565         egses_from_contract(god_address, div(mul(20, invite_price), 100), 2); //2 reward god for being invited
566 
567         reward_inviter(msg.sender, invite_price);
568         emit invited_god (msg.sender, god_id);
569 
570         return gods[god_address].invite_price;
571     }
572     event invited_god (address msg_sender, uint god_id);
573     
574 
575     function reward_inviter (address inviter_address, uint invite_price) private returns (bool){
576         // the player spending eth also get credit and share
577         uint previous_share = 0;
578         uint inviter_share = 0;
579         uint share_diff;
580         address rewarding_inviter = inviter_address;
581         
582         for (uint i = 0; i < 9; i++){ // max trace 9 layers of inviter
583             if (rewarding_inviter != address(0) && rewarding_inviter != admin){ // admin doesn't get reward or credit
584                 share_diff = 0;
585                 gods[rewarding_inviter].credit = add(gods[rewarding_inviter].credit, invite_price);
586                 inviter_share = get_vip_level(rewarding_inviter);
587 
588                 if (inviter_share > previous_share) {
589                     share_diff = sub(inviter_share, previous_share);
590                     if (share_diff > 18) {
591                         share_diff = 18;
592                     }
593                     previous_share = inviter_share;
594                 }
595                 
596                 if (share_diff > 0) {
597                     egses_from_contract(rewarding_inviter, div(mul(share_diff, invite_price), 100), 3); // 3 inviter_reward
598                 }
599                 
600                 rewarding_inviter = gods_address[gods[rewarding_inviter].inviter_id]; // get the address of inviter's inviter'
601             } else{
602                 break;
603             }
604         }
605         // invite_price to egses: sub(20%, previous_share) to admin
606         share_diff = sub(20, inviter_share); 
607         egses_from_contract(admin, div(mul(share_diff, invite_price), 100), 2); // remaining goes to admin, 2 god_reward for being invited
608         
609         return true;
610     }
611     
612 
613     function upgrade_pet () public returns(bool){
614         //use egst to level up pet;
615         uint egst_cost = mul(add(gods[msg.sender].pet_level, 1), 10 ether);
616         egst_to_contract(msg.sender, egst_cost, 6);// 6 upgrade_pet
617         gods[msg.sender].pet_level = add(gods[msg.sender].pet_level, 1);
618         add_exp(msg.sender, div(egst_cost, 1 ether));
619         pray_egst = add(pray_egst, egst_cost);
620 
621         emit upgradeAmulet(msg.sender, 0, gods[msg.sender].pet_level);
622         
623         return true;
624     }
625     event upgradeAmulet (address owner, uint amulet_id, uint new_level);
626 
627     function set_pet_type (uint new_type) public returns (bool){
628         if (gods[msg.sender].pet_type != new_type) {
629             gods[msg.sender].pet_type = new_type;
630             return true;
631         }
632     }
633   
634       
635     function get_vip_level (address god_address) public view returns (uint vip_level){
636         uint inviter_credit = gods[god_address].credit;
637         
638         if (inviter_credit > 500 ether){
639             vip_level = 18;
640         } else if (inviter_credit > 200 ether){
641             vip_level = 15;
642         } else if (inviter_credit > 100 ether){
643             vip_level = 12;
644         } else if (inviter_credit > 50 ether){
645             vip_level = 10;
646         } else if (inviter_credit > 20 ether){
647             vip_level = 8;
648         } else if (inviter_credit > 10 ether){
649             vip_level = 6;
650         } else if (inviter_credit > 5 ether){
651             vip_level = 5;
652         } else if (inviter_credit > 2 ether){
653             vip_level = 4;
654         } else if (inviter_credit > 1 ether){
655             vip_level = 3;
656         } else if (inviter_credit > 0.5 ether){
657             vip_level = 2;
658         } else {
659             vip_level = 1;
660         }
661         return vip_level;
662     }
663 
664 
665     // view god's information
666     
667     function get_god_id (address god_address) public view returns (uint god_id){
668         return gods[god_address].god_id;
669     }
670     
671     
672     function get_god_address(uint god_id) public view returns (address){
673         return gods_address[god_id];
674     }
675 
676 
677     function get_god (uint god_id) public view returns(uint, string, uint, uint, uint, uint, bool) {
678         address god_address = gods_address[god_id];
679         string memory god_name;
680 
681         god_name = eth_gods_name.get_god_name(god_address);
682         if (bytes(god_name).length == 0){
683             god_name = "Unknown";
684         }
685 
686         return (gods[god_address].god_id,
687                 god_name,
688                 gods[god_address].level,
689                 gods[god_address].exp,
690                 gods[god_address].invite_price,
691                 gods[god_address].listed,
692                 gods[god_address].hosted_pray
693                 );
694     }
695 
696     function get_god_info (address god_address) public view returns (uint, uint, uint, uint, uint, uint, uint){
697         return (gods[god_address].last_ticket_number,
698                 gods[god_address].free_rounds,
699                 gods[god_address].paid_rounds,
700                 gods[god_address].pet_type,
701                 gods[god_address].pet_level,
702                 gods[god_address].bid_eth,
703                 gods[god_address].count_tickets
704                 );
705     }    
706     
707     
708     function get_my_info () public view returns(uint, uint, uint, uint, uint, uint, uint) { //private information
709 
710         return (gods[msg.sender].god_id,
711                 egses_balances[msg.sender], //egses
712                 balances[msg.sender], //egst
713                 get_vip_level(msg.sender),
714                 gods[msg.sender].credit, // inviter_credit
715                 gods[msg.sender].inviter_id,
716                 gods[msg.sender].count_gods_invited
717                 );
718     }   
719 
720 
721     function get_my_invited () public view returns (uint[]){
722         uint count_elements = 0;
723         uint count_gods_invited = gods[msg.sender].count_gods_invited;
724 
725         uint my_id = gods[msg.sender].god_id;
726         uint [] memory invited_players = new uint[](count_gods_invited);
727         if (count_gods_invited > 0) {
728             for (uint i = 1; i <= count_gods; i++){
729                 if (gods[gods_address[i]].inviter_id == my_id) {
730                     invited_players[count_elements] = i;
731                     count_elements ++;
732                     
733                     if (count_elements >= count_gods_invited){
734                         break;
735                     }
736                 }
737             }
738         }
739         return invited_players;
740     }
741 
742 
743     function get_listed_gods (uint page_number) public view returns (uint[]){
744         
745         uint count_listed_gods = listed_gods.length;
746         require(count_listed_gods <= mul(page_number, 20));
747         
748         uint[] memory tempArray = new uint[] (20);
749 
750         if (page_number < 1) {
751             page_number = 1;
752         } 
753 
754         for (uint i = 0; i < 20; i++){
755             if(count_listed_gods > add(i, mul(20, sub(page_number, 1)))) {
756                 tempArray[i] = listed_gods[sub(sub(sub(count_listed_gods, i), 1), mul(20, sub(page_number, 1)))];
757             } else {
758                 break;
759             }
760         }
761         
762         return tempArray;
763     }
764 
765 
766     // amulets
767    
768     function upgrade_amulet (uint amulet_id) public returns(uint){
769         require(amulets[amulet_id].owner == msg.sender);
770         uint egst_cost = mul(add(amulets[amulet_id].level, 1), 10 ether);
771         egst_to_contract(msg.sender, egst_cost, 7);// reason 7, upgrade_amulet
772         pray_egst = add(pray_egst, egst_cost);
773         
774         amulets[amulet_id].level = add(amulets[amulet_id].level, 1);
775         add_exp(msg.sender, div(egst_cost, 1 ether));
776         emit upgradeAmulet(msg.sender, amulet_id, amulets[amulet_id].level);
777         
778         return amulets[amulet_id].level;
779     }
780     
781     
782     function create_amulet_order (uint amulet_id, uint price) public returns (uint) {
783         require(msg.sender == amulets[amulet_id].owner
784                 && amulet_id >= 1 && amulet_id <= count_amulets
785                 && amulets[amulet_id].start_selling_block == 0
786                 && add(amulets[amulet_id].bound_start_block, bound_duration) < block.number
787                 && price > 0);
788 
789         amulets[amulet_id].start_selling_block = block.number;
790         amulets[amulet_id].price = price;
791         gods[msg.sender].count_amulets_at_hand = sub(gods[msg.sender].count_amulets_at_hand, 1);
792         gods[msg.sender].count_amulets_selling = add(gods[msg.sender].count_amulets_selling, 1);
793         
794         return gods[msg.sender].count_amulets_selling;
795 
796     }
797 
798     function buy_amulet (uint amulet_id) public payable returns (bool) {
799         uint price = amulets[amulet_id].price;
800         require(msg.value >= price && msg.value < add(price, max_extra_eth)
801         && amulets[amulet_id].start_selling_block > 0
802         && amulets[amulet_id].owner != msg.sender
803         && price > 0);
804         
805         address seller = amulets[amulet_id].owner;
806         amulets[amulet_id].owner = msg.sender;
807         amulets[amulet_id].bound_start_block = block.number;
808         amulets[amulet_id].start_selling_block = 0;
809 
810         gods[msg.sender].count_amulets_at_hand = add(gods[msg.sender].count_amulets_at_hand, 1);
811         update_amulets_count(msg.sender, amulet_id, true);
812         gods[seller].count_amulets_selling = sub(gods[seller].count_amulets_selling, 1);
813         update_amulets_count(seller, amulet_id, false);
814 
815         egses_from_contract(seller, price, 6); // 6 sell amulet
816 
817         return true;
818     }
819 
820     function withdraw_amulet_order (uint amulet_id) public returns (uint){
821         // an amulet can only have one order_id, so withdraw amulet_id instead of withdraw order_id, since only amulet_id is shown in amulets_at_hand
822         require(msg.sender == amulets[amulet_id].owner
823                 && amulet_id >= 1 && amulet_id <= count_amulets
824                 && amulets[amulet_id].start_selling_block > 0);
825                 
826         amulets[amulet_id].start_selling_block = 0;
827         gods[msg.sender].count_amulets_at_hand = add(gods[msg.sender].count_amulets_at_hand, 1);
828         gods[msg.sender].count_amulets_selling = sub(gods[msg.sender].count_amulets_selling, 1);
829 
830         return gods[msg.sender].count_amulets_selling;
831     }
832     
833     function update_amulets_count (address god_address, uint amulet_id, bool obtained) private returns (uint){
834         if (obtained == true){
835             if (amulet_id < gods[god_address].amulets_start_id) {
836                 gods[god_address].amulets_start_id = amulet_id;
837             }
838         } else {
839             if (amulet_id == gods[god_address].amulets_start_id){
840                 for (uint i = amulet_id; i <= count_amulets; i++){
841                     if (amulets[i].owner == god_address && i > amulet_id){
842                         gods[god_address].amulets_start_id = i;
843                         break;
844                     }
845                 }
846             }
847         }
848         return gods[god_address].amulets_start_id;
849     }
850     
851 
852     function get_amulets_generated (uint god_id) public view returns (uint[]) {
853         address god_address = gods_address[god_id];
854         uint count_amulets_generated = gods[god_address].count_amulets_generated;
855         
856         uint [] memory temp_list = new uint[](count_amulets_generated);
857         if (count_amulets_generated > 0) {
858             uint count_elements = 0;
859             for (uint i = gods[god_address].first_amulet_generated; i <= count_amulets; i++){
860                 if (amulets[i].god_id == god_id){
861                     temp_list [count_elements] = i;
862                     count_elements++;
863                     
864                     if (count_elements >= count_amulets_generated){
865                         break;
866                     }
867                 }
868             }
869         }
870         return temp_list;
871     }
872 
873     
874     function get_amulets_at_hand (address god_address) public view returns (uint[]) {
875         uint count_amulets_at_hand = gods[god_address].count_amulets_at_hand;
876         uint [] memory temp_list = new uint[] (count_amulets_at_hand);
877         if (count_amulets_at_hand > 0) {
878             uint count_elements = 0;
879             for (uint i = gods[god_address].amulets_start_id; i <= count_amulets; i++){
880                 if (amulets[i].owner == god_address && amulets[i].start_selling_block == 0){
881                     temp_list[count_elements] = i;
882                     count_elements++;
883                     
884                     if (count_elements >= count_amulets_at_hand){
885                         break;
886                     }
887                 }
888             }
889         }
890 
891         return temp_list;
892     }
893     
894     
895     function get_my_amulets_selling () public view returns (uint[]){
896 
897         uint count_amulets_selling = gods[msg.sender].count_amulets_selling;
898         uint [] memory temp_list = new uint[] (count_amulets_selling);
899         if (count_amulets_selling > 0) {
900             uint count_elements = 0;
901             for (uint i = gods[msg.sender].amulets_start_id; i <= count_amulets; i++){
902                 if (amulets[i].owner == msg.sender 
903                 && amulets[i].start_selling_block > 0){
904                     temp_list[count_elements] = i;
905                     count_elements++;
906                     
907                     if (count_elements >= count_amulets_selling){
908                         break;
909                     }
910                 }
911             }
912         }
913 
914         return temp_list;
915     }
916 
917     // to calculate how many pages
918     function get_amulet_orders_overview () public view returns(uint){
919         uint count_amulets_selling = 0;
920         for (uint i = 1; i <= count_amulets; i++){
921             if (add(amulets[i].start_selling_block, order_duration) > block.number && amulets[i].owner != msg.sender){
922                 count_amulets_selling = add(count_amulets_selling, 1);
923             }
924         }        
925         
926         return count_amulets_selling; // to show page numbers when getting amulet_orders
927     }
928 
929     function get_amulet_orders (uint page_number) public view returns (uint[]){
930         uint[] memory temp_list = new uint[] (20);
931         uint count_amulets_selling = 0;
932         uint count_list_elements = 0;
933 
934         if ((page_number < 1)
935             || count_amulets  <= 20) {
936             page_number = 1; // chose a page out of range
937         }
938         uint start_amulets_count = mul(sub(page_number, 1), 20);
939 
940         for (uint i = 1; i <= count_amulets; i++){
941             if (add(amulets[i].start_selling_block, order_duration) > block.number && amulets[i].owner != msg.sender){
942                 
943                 if (count_amulets_selling <= start_amulets_count) {
944                     count_amulets_selling ++;
945                 }
946                 if (count_amulets_selling > start_amulets_count){
947                     
948                     temp_list[count_list_elements] = i;
949                     count_list_elements ++;
950                     
951                     if (count_list_elements >= 20){
952                         break;
953                     }
954                 }
955                 
956             }
957         }
958         
959         return temp_list;
960     }
961     
962     
963     function get_amulet (uint amulet_id) public view returns(address, string, uint, uint, uint, uint, uint){
964         uint god_id = amulets[amulet_id].god_id;
965         // address god_address = gods_address[god_id];
966         string memory god_name = eth_gods_name.get_god_name(gods_address[god_id]);
967         uint god_level = gods[gods_address[god_id]].level;
968         uint amulet_level = amulets[amulet_id].level;
969         uint start_selling_block = amulets[amulet_id].start_selling_block;
970         uint price = amulets[amulet_id].price;
971 
972         return(amulets[amulet_id].owner,
973                 god_name,
974                 god_id,
975                 god_level,
976                 amulet_level,
977                 start_selling_block,
978                 price
979               );
980     }
981 
982     function get_amulet2 (uint amulet_id) public view returns(uint){
983         return amulets[amulet_id].bound_start_block;
984     }
985 
986     // end of amulet
987     
988     // start of pray
989     function admin_deposit (uint egst_amount) public payable returns (bool) {
990         require (msg.sender == admin);
991         if (msg.value > 0){
992             pray_egses = add(pray_egses, msg.value);
993             egses_from_contract(admin, msg.value, 4); // 4 admin_deposit to reward_pool
994         }
995         if (egst_amount > 0){
996             pray_egst = add(pray_egst, egst_amount);
997             egst_to_contract(admin, egst_amount, 4); // 4 admin_deposit to reward_pool            
998         }
999         return true;
1000     }
1001         
1002     function initialize_pray () private returns (bool){
1003         if (pray_start_block > 0) { // double safeguard
1004             require (check_event_completed() == true
1005             && rewarded_pray_winners == true);
1006         }
1007         
1008         count_rounds = add(count_rounds, 1);
1009         count_rounds_winner_logs[count_rounds] = 0;
1010         pray_start_block = block.number;
1011         rewarded_pray_winners = false;
1012 
1013         for (uint i = 1; i <= 3; i++){
1014             pk_positions[i] = max_winners[i]; // pk start from the last slot
1015 			count_listed_winners[i] = 0;
1016         }
1017         if (listed_gods.length > count_hosted_gods) {
1018             // a new god's turn
1019             count_hosted_gods = add(count_hosted_gods, 1);
1020             pray_host_god = bidding_gods[count_hosted_gods];
1021             gods[pray_host_god].hosted_pray = true;
1022             pray_reward_top100 = true;
1023         } else {
1024             //choose highest bidder
1025             (uint highest_bid, address highest_bidder) = compare_bid_eth();
1026 
1027             gods[highest_bidder].bid_eth = 0;
1028             pray_host_god = highest_bidder;
1029             pray_egses = add(pray_egses, highest_bid);
1030             pray_reward_top100 = false;
1031 
1032         }
1033         
1034         // set_up reward pool
1035         reward_pool_egses = div(pray_egses, 10);
1036         // pray_egses = sub(pray_egses, reward_pool_egses);
1037 
1038         reward_pool_egst = div(pray_egst, 10);
1039         pray_egst = sub(pray_egst, reward_pool_egst); // reduce sum for less calculation, burn, if not used
1040                 
1041         return true;
1042 
1043     }
1044 
1045 
1046     function bid_host () public payable returns (bool) {
1047         require (msg.value > 0 && gods[msg.sender].listed > 0);
1048         gods[msg.sender].bid_eth = add (gods[msg.sender].bid_eth, msg.value);
1049 
1050         return true;
1051     }
1052     
1053 
1054     function withdraw_bid () public returns (bool) {
1055         uint bid_eth = gods[msg.sender].bid_eth;
1056         require(bid_eth > 0);
1057         gods[msg.sender].bid_eth = 0;
1058         egses_from_contract(msg.sender, bid_eth, 8); // 8  withdraw bid
1059         return true;
1060     }
1061     
1062     
1063     function create_ticket(address owner_address) private returns (uint) {
1064         count_tickets = add(count_tickets, 1);
1065         tickets[count_tickets].block_number = add(block.number, 1);
1066         tickets[count_tickets].owner = owner_address;
1067         gods[owner_address].last_ticket_number = count_tickets;
1068         gods[owner_address].count_tickets = add(gods[owner_address].count_tickets, 1);
1069         
1070         return count_tickets;
1071     }
1072     
1073     
1074     function pray (uint inviter_id) public payable returns (bool){
1075         require (tx.gasprice <= max_gas_price);
1076   
1077         if (gods[msg.sender].credit == 0) {
1078             create_god(msg.sender, inviter_id);
1079         }
1080         
1081         if (gods[msg.sender].free_rounds >= count_rounds){
1082             require (msg.value == double_egst_fee);
1083             
1084             if (gods[msg.sender].paid_rounds != count_rounds){
1085                 gods[msg.sender].paid_rounds = count_rounds;
1086             }
1087             add_exp(msg.sender, 6);
1088             pray_egses = add(pray_egses, double_egst_fee);
1089         } else {
1090             require (msg.value == 0);
1091             gods[msg.sender].free_rounds = count_rounds; // 1 free dice in each round
1092         }
1093         
1094         create_ticket(msg.sender);
1095         
1096         if (used_tickets < count_tickets) {
1097 
1098             ticket storage using_ticket = tickets[add(used_tickets, 1)];
1099             uint block_number = using_ticket.block_number;
1100 
1101             if (block_number < block.number) {// can only get previous block hash
1102                 used_tickets = add(used_tickets, 1);
1103                 address waiting_prayer = using_ticket.owner;
1104                 
1105                 if (add(block_number, block_hash_duration) <= block.number) {// this ticket should have a valid block_number to generate block hash
1106                     using_ticket.new_ticket_number = create_ticket(waiting_prayer); //void this ticket and create a new ticket
1107                 } else {// throw dice
1108                     bytes32 block_hash = keccak256(abi.encodePacked(blockhash(block_number)));
1109                     using_ticket.block_hash = block_hash;
1110     
1111                     uint dice_result = eth_gods_dice.throw_dice (block_hash)[0];
1112                     using_ticket.dice_result = dice_result;
1113 
1114                     if (dice_result >= 1 && dice_result <= 3){
1115                         set_winner(dice_result, used_tickets);
1116                     } else {
1117                         add_exp(waiting_prayer, 6); // add 6 exp and no pk for lucky stars
1118                     }
1119 
1120                 }
1121             }
1122         }
1123         
1124    
1125         add_exp(pray_host_god, 1);
1126 
1127         if (check_event_completed() == true && rewarded_pray_winners == false) {
1128             reward_pray_winners();
1129         }
1130 
1131         return true;
1132     }
1133     
1134 
1135     function set_winner (uint prize, uint ticket_number) private returns (uint){
1136 
1137         count_rounds_winner_logs[count_rounds] = add(count_rounds_winner_logs[count_rounds], 1);
1138         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].ticket_number = ticket_number;
1139         winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].prize = prize;
1140         address waiting_prayer =  tickets[ticket_number].owner;
1141         bytes32 block_hash = tickets[ticket_number].block_hash;
1142 
1143         if (count_listed_winners[prize] >= max_winners[prize]){ // winner_list maxed, so the new prayer challenge previous winners
1144            	uint pk_position = pk_positions[prize];
1145         	address previous_winner = listed_winners[prize][pk_position];  
1146 
1147             bool pk_result = pk(waiting_prayer, previous_winner, block_hash);
1148 
1149 			winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].pk_result = pk_result;
1150 			winner_logs[count_rounds][count_rounds_winner_logs[count_rounds]].previous_winner = previous_winner;
1151             
1152             if (pk_result == true) {
1153                 listed_winners[prize][pk_position] = waiting_prayer; // attacker defeat defender
1154             }
1155             if (prize > 1) { // no need to change pk_pos for champion
1156                 if (pk_positions[prize] > 1){
1157                     pk_positions[prize] = sub(pk_positions[prize], 1);
1158                 } else {
1159                     pk_positions[prize] = max_winners[prize];
1160                 }               
1161             }
1162         } else {
1163             count_listed_winners[prize] = add(count_listed_winners[prize], 1);
1164             listed_winners[prize][count_listed_winners[prize]] = waiting_prayer;
1165         }
1166      
1167         return count_listed_winners[prize];
1168     }
1169 
1170     function reward_pray_winners () private returns (bool){
1171         require (check_event_completed() == true && rewarded_pray_winners == false);
1172 
1173         egst_from_contract(pray_host_god, mul(div(reward_pool_egst, 100), 50), 1); // 1 pray_reward for hosting event
1174 
1175         uint this_reward_egses = 0; // this reward for a specific winner
1176         uint this_reward_egst = 0;  // this reward for a specific winner
1177         
1178         for (uint i = 1; i<=3; i++){
1179             if (i == 1) {
1180                 this_reward_egses = mul(div(reward_pool_egses, 100), 60);
1181             } else if (i == 2){
1182                 this_reward_egses = mul(div(reward_pool_egses, 100), 20);
1183             } else if (i == 3){
1184                 this_reward_egst = mul(div(reward_pool_egst, 100), 8);
1185             } 
1186             
1187             for (uint reward_i = 1; reward_i <= count_listed_winners[i]; reward_i++){
1188                 address rewarding_winner = listed_winners[i][reward_i];
1189 
1190                 if (this_reward_egses > 0 ) {
1191                     egses_from_contract(rewarding_winner, this_reward_egses, 1); // 1 pray_reward
1192                     pray_egses = sub(pray_egses, this_reward_egses);
1193                 } else if (this_reward_egst > 0) {
1194                     if (gods[rewarding_winner].paid_rounds < count_rounds){
1195                         egst_from_contract(rewarding_winner, this_reward_egst, 1); // 1 pray_reward
1196                     } else { 
1197                         egst_from_contract(rewarding_winner, mul(this_reward_egst, 2), 1); // 1 pray_reward
1198                         _totalSupply = add(_totalSupply, this_reward_egst);
1199 
1200                         if (gods[rewarding_winner].paid_rounds > count_rounds){// just in case of any error
1201                             gods[rewarding_winner].paid_rounds = count_rounds;
1202                         } 
1203                     }
1204                 }  
1205 
1206             }
1207 
1208         }
1209 
1210         // burn egst, 2% fixed amount, plus wasted EGST floor prizes
1211         uint burn_egst = div(reward_pool_egst, 50);
1212         if (count_listed_winners[3] < max_winners[3]) {
1213             burn_egst = add(burn_egst,  mul(this_reward_egst, sub(max_winners[3], count_listed_winners[3]))); 
1214         }
1215         _totalSupply = sub(_totalSupply, burn_egst);
1216                     
1217         if(pray_reward_top100 == true) {
1218             reward_top_gods();
1219         }
1220             
1221         // a small gift of exp & egst to the god who burned gas to send rewards to the community
1222         egst_from_contract(msg.sender, mul(initializer_reward, 1 ether), 1); // 1 pray_reward
1223         _totalSupply = add(_totalSupply, mul(initializer_reward, 1 ether));  
1224         add_exp(msg.sender, initializer_reward);
1225 
1226         rewarded_pray_winners = true;
1227         initialize_pray();
1228         return true;
1229     }
1230 
1231 
1232     // more listed gods, more reward to the top gods, highest reward 600 egst
1233     function reward_top_gods () private returns (bool){ // public when testing
1234         
1235         uint count_listed_gods = listed_gods.length;
1236         uint last_god_index;
1237         
1238         if (count_listed_gods > 100) {
1239             last_god_index = sub(count_listed_gods, 100);
1240         } else {
1241             last_god_index = 0;
1242         }
1243         
1244         uint reward_egst = 0;
1245         uint base_reward = 6 ether;
1246         if (count_rounds == 6){
1247             base_reward = mul(base_reward, 6);
1248         }
1249         for (uint i = last_god_index; i < count_listed_gods; i++) {
1250             reward_egst = mul(base_reward, sub(add(i, 1), last_god_index));
1251             egst_from_contract(gods_address[listed_gods[i]], reward_egst, 2);// 2 top_gods_reward
1252             _totalSupply = add(_totalSupply, reward_egst);   
1253         }
1254         
1255         return true;
1256     }
1257 
1258 
1259     function compare_bid_eth () private view returns (uint, address) {
1260         uint highest_bid = 0;
1261         address highest_bidder = v_god; // if no one bid, v god host this event
1262 
1263         for (uint j = 1; j <= listed_gods.length; j++){
1264             if (gods[bidding_gods[j]].bid_eth > highest_bid){
1265                 highest_bid = gods[bidding_gods[j]].bid_eth;
1266                 highest_bidder = bidding_gods[j];
1267             }
1268         }
1269         return (highest_bid, highest_bidder);
1270     }
1271 
1272 
1273     function check_event_completed () public view returns (bool){
1274         if (add(pray_start_block, round_duration) < block.number){
1275             return true;   
1276         } else {
1277             return false;   
1278         }
1279     }
1280 
1281 
1282     function pk (address attacker, address defender, bytes32 block_hash) public view returns (bool pk_result){// make it public, view only, other contract may use it
1283 
1284         (uint attacker_sum_god_levels, uint attacker_sum_amulet_levels) = get_sum_levels_pk(attacker);
1285         (uint defender_sum_god_levels, uint defender_sum_amulet_levels) = get_sum_levels_pk(defender);
1286     
1287         pk_result = eth_gods_dice.pk(block_hash, attacker_sum_god_levels, attacker_sum_amulet_levels, defender_sum_god_levels, defender_sum_amulet_levels);
1288         
1289         return pk_result;
1290     }
1291     
1292     
1293     function get_sum_levels_pk (address god_address) public view returns (uint sum_gods_level, uint sum_amulets_level){
1294              
1295         sum_gods_level =  gods[god_address].level;
1296         sum_amulets_level = gods[god_address].pet_level; // add pet level to the sum
1297 		uint amulet_god_id;
1298         uint amulet_god_level;
1299         for (uint i = 1; i <= count_amulets; i++){
1300             if (amulets[i].owner == god_address && amulets[i].start_selling_block == 0){
1301                 amulet_god_id = amulets[i].god_id;
1302                 amulet_god_level = gods[gods_address[amulet_god_id]].level;
1303                 sum_gods_level = add(sum_gods_level, amulet_god_level);
1304                 sum_amulets_level = add(sum_amulets_level, amulets[i].level);
1305             }
1306         }
1307                 
1308         return (sum_gods_level, sum_amulets_level);
1309     }
1310         
1311     //admin need this function
1312     function get_listed_winners (uint prize) public view returns (address[]){
1313         address [] memory temp_list = new address[] (count_listed_winners[prize]);
1314         if (count_listed_winners[prize] > 0) {
1315             for (uint i = 0; i < count_listed_winners[prize]; i++){
1316                 temp_list[i] = listed_winners[prize][add(i,1)];
1317             }
1318         }
1319         return temp_list;
1320     }
1321     
1322     function get_ticket (uint ticket_number) public view returns (uint, bytes32, address, uint, uint){
1323         return (tickets[ticket_number].block_number,
1324             tickets[ticket_number].block_hash,
1325             tickets[ticket_number].owner,
1326             tickets[ticket_number].new_ticket_number,
1327             tickets[ticket_number].dice_result);
1328     }
1329     
1330     function get_my_tickets() public view returns (uint[]) {
1331         uint count_my_tickets = gods[msg.sender].count_tickets;
1332         if (count_my_tickets > max_show_tickets) {
1333             count_my_tickets = max_show_tickets;
1334         }
1335         uint [] memory temp_list = new uint[] (count_my_tickets);
1336         if (count_my_tickets > 0) {
1337             uint count_elements = 0;
1338             for (uint i = gods[msg.sender].last_ticket_number; i > 0; i--){
1339                 if (tickets[i].owner == msg.sender){
1340                     temp_list[count_elements] = i;
1341                     count_elements++;
1342                     
1343                     if (count_elements >= count_my_tickets){
1344                         break;
1345                     }
1346                 }
1347             }
1348         }
1349 
1350         return temp_list;       
1351     }
1352 
1353  
1354     // end of pray
1355 
1356     // start of egses
1357 
1358     function egses_from_contract (address to, uint tokens, uint reason) private returns (bool) { // public when testing
1359         if (reason == 1) {
1360             require (pray_egses > tokens); // >, pool never be zero
1361             pray_egses = sub(pray_egses, tokens);
1362         }
1363 
1364         egses_balances[to] = add(egses_balances[to], tokens);
1365 
1366         create_change_log(1, reason, tokens, egses_balances[to], contract_address, to);
1367         return true;
1368     } 
1369     
1370     function egses_withdraw () public returns (uint tokens){
1371         tokens = egses_balances[msg.sender];
1372         require (tokens > 0 && contract_address.balance >= tokens && reEntrancyMutex == false);
1373 
1374         reEntrancyMutex = true; // if met problem, it will use up gas from msg.sender and roll back to false
1375         egses_balances[msg.sender] = 0;
1376         msg.sender.transfer(tokens);
1377         reEntrancyMutex = false;
1378         
1379         emit withdraw_egses(msg.sender, tokens);
1380         create_change_log(1, 5, tokens, 0, contract_address, msg.sender); // 5 withdraw egses
1381 
1382         return tokens;
1383     }
1384     event withdraw_egses (address receiver, uint tokens);
1385 
1386    // end of egses
1387    
1388 
1389     // start of erc20 for egst
1390     function totalSupply () public view returns (uint){
1391         return _totalSupply;
1392     }
1393 
1394 
1395     function balanceOf (address tokenOwner) public view returns (uint){
1396         return balances[tokenOwner]; // will return 0 if doesn't exist
1397     }
1398 
1399     function allowance (address tokenOwner, address spender) public view returns (uint) {
1400         return allowed[tokenOwner][spender];
1401     }
1402 
1403     function transfer (address to, uint tokens) public returns (bool success){
1404         require (balances[msg.sender] >= tokens);
1405         balances[msg.sender] = sub(balances[msg.sender], tokens);
1406         balances[to] = add(balances[to], tokens);
1407         emit Transfer(msg.sender, to, tokens);
1408         create_change_log(2, 9, tokens, balances[to], msg.sender, to);
1409         
1410         return true;    
1411     }
1412     event Transfer (address indexed from, address indexed to, uint tokens);
1413 
1414 
1415     function approve (address spender, uint tokens) public returns (bool success) {
1416 
1417         require (balances[msg.sender] >= tokens);
1418         allowed[msg.sender][spender] = tokens;
1419         
1420         emit Approval(msg.sender, spender, tokens);
1421         return true;
1422     }
1423     event Approval (address indexed tokenOwner, address indexed spender, uint tokens);
1424 
1425 
1426     function transferFrom (address from, address to, uint tokens) public returns (bool success) {
1427         require (balances[from] >= tokens);
1428         allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokens);
1429         balances[from] = sub(balances[from], tokens);
1430         balances[to] = add(balances[to], tokens);
1431         
1432         emit Transfer(from, to, tokens);
1433         create_change_log(2, 10, tokens, balances[to], from, to);
1434         return true;    
1435     }
1436 
1437     // end of erc20 for egst
1438     
1439     
1440     // egst
1441   
1442     function egst_from_contract (address to, uint tokens, uint reason) private returns (bool) { // public when testing
1443         balances[to] = add(balances[to], tokens);
1444 
1445         create_change_log(2, reason, tokens, balances[to], contract_address, to); 
1446         return true;
1447     }
1448 
1449     function egst_to_contract (address from, uint tokens, uint reason) private returns (bool) { // public when testing
1450         require (balances[from] >= tokens);
1451         balances[from] = sub(balances[from], tokens);
1452         
1453 
1454         emit spend_egst(from, tokens, reason);
1455         create_change_log(2, reason, tokens, balances[from], from, contract_address);
1456         return true;
1457     }
1458     event spend_egst (address from, uint tokens, uint reason);
1459 
1460 
1461     function create_token_order (uint unit_price, uint egst_amount) public returns (uint) {      
1462         require(unit_price >= min_unit_price && unit_price <= max_unit_price 
1463         && balances[msg.sender] >= egst_amount
1464         && egst_amount <= max_egst_amount
1465         && egst_amount >= min_egst_amount);
1466 
1467         count_token_orders = add(count_token_orders, 1);
1468 
1469         egst_to_contract(msg.sender, egst_amount, 3); // 3 create_token_order
1470         
1471         token_orders[count_token_orders].start_selling_block = block.number;    
1472         token_orders[count_token_orders].seller = msg.sender;
1473         token_orders[count_token_orders].unit_price = unit_price;
1474         token_orders[count_token_orders].egst_amount = egst_amount;
1475         gods[msg.sender].count_token_orders = add(gods[msg.sender].count_token_orders, 1);
1476         
1477         update_first_active_token_order(msg.sender);
1478 
1479         return gods[msg.sender].count_token_orders;
1480     }
1481 
1482 
1483     function withdraw_token_order (uint order_id) public returns (bool) { 
1484         require (msg.sender == token_orders[order_id].seller
1485                 && token_orders[order_id].egst_amount > 0);
1486 
1487         uint egst_amount = token_orders[order_id].egst_amount;
1488         token_orders[order_id].start_selling_block = 0;
1489         token_orders[order_id].egst_amount = 0;
1490         egst_from_contract(msg.sender, egst_amount, 4); // 4  withdraw token_order
1491         gods[msg.sender].count_token_orders = sub(gods[msg.sender].count_token_orders, 1);
1492         
1493         update_first_active_token_order(msg.sender);
1494         emit WithdrawTokenOrder(msg.sender, order_id);
1495 
1496         return true;
1497     }
1498     event WithdrawTokenOrder (address seller, uint order_id);
1499 
1500     function buy_token (uint order_id, uint egst_amount) public payable returns (uint) { 
1501 
1502         require(order_id >= first_active_token_order 
1503                 && order_id <= count_token_orders
1504                 && egst_amount <= token_orders[order_id].egst_amount
1505                 && token_orders[order_id].egst_amount > 0
1506                 && token_orders[order_id].seller != msg.sender);
1507         
1508         // unit_price 100 means 1 egst = 0.001 ether
1509         uint eth_cost = div(mul(token_orders[order_id].unit_price, egst_amount), 100000);
1510         require(msg.value >= eth_cost && msg.value < add(eth_cost, max_extra_eth) );
1511 
1512         token_orders[order_id].egst_amount = sub(token_orders[order_id].egst_amount, egst_amount);
1513         egst_from_contract(msg.sender, egst_amount, token_orders[order_id].unit_price); // uint price (> 10) will be recorded as reason in change log and translated by front end as buy token & unit_price
1514 
1515         address seller = token_orders[order_id].seller;
1516         egses_from_contract(seller, eth_cost, 7); // 7 sell egst
1517         
1518         
1519         if (token_orders[order_id].egst_amount <= 0){
1520             token_orders[order_id].start_selling_block = 0;
1521             gods[seller].count_token_orders = sub(gods[seller].count_token_orders, 1);
1522             update_first_active_token_order(seller);
1523         }
1524         
1525         emit BuyToken(msg.sender, order_id, egst_amount);
1526 
1527         return token_orders[order_id].egst_amount;
1528     }
1529     event BuyToken (address buyer, uint order_id, uint egst_amount);
1530 
1531   
1532     function update_first_active_token_order (address god_address) private returns (uint, uint){ // public when testing
1533         if (count_token_orders > 0 
1534         && first_active_token_order == 0){
1535             first_active_token_order = 1;
1536         } else {
1537             for (uint i = first_active_token_order; i <= count_token_orders; i++) {
1538                 if (add(token_orders[i].start_selling_block, order_duration) > block.number){
1539                     // find the first active order and compare with the currect index
1540                     if (i > first_active_token_order){
1541                         first_active_token_order = i;
1542                     }
1543                     break;
1544                 }
1545             }    
1546         }
1547             
1548         if (gods[god_address].count_token_orders > 0
1549         && gods[god_address].first_active_token_order == 0){
1550             gods[god_address].first_active_token_order = 1; // may not be 1, but it will correct next time
1551         } else {
1552             for (uint j = gods[god_address].first_active_token_order; j < count_token_orders; j++){
1553                 if (token_orders[j].seller == god_address 
1554                 && token_orders[j].start_selling_block > 0){ // don't check duration, show it to selling, even if expired
1555                     // find the first active order and compare with the currect index
1556                     if(j > gods[god_address].first_active_token_order){
1557                         gods[god_address].first_active_token_order = j;
1558                     }
1559                     break;
1560                 }
1561             }
1562         }
1563         
1564         return (first_active_token_order, gods[msg.sender].first_active_token_order);
1565     }
1566 
1567 
1568     function get_token_order (uint order_id) public view returns(uint, address, uint, uint){
1569         require(order_id >= 1 && order_id <= count_token_orders);
1570 
1571         return(token_orders[order_id].start_selling_block,
1572                token_orders[order_id].seller,
1573                token_orders[order_id].unit_price,
1574                token_orders[order_id].egst_amount);
1575     }
1576 
1577     // return total orders and lowest price to browser, browser query each active order and show at most three orders of lowest price
1578     function get_token_orders () public view returns(uint, uint, uint, uint, uint) {
1579         uint lowest_price = max_unit_price;
1580         for (uint i = first_active_token_order; i <= count_token_orders; i++){
1581             if (token_orders[i].unit_price < lowest_price 
1582             && token_orders[i].egst_amount > 0
1583             && add(token_orders[i].start_selling_block, order_duration) > block.number){
1584                 lowest_price = token_orders[i].unit_price;
1585             }
1586         }
1587         return (count_token_orders, first_active_token_order, order_duration, max_unit_price, lowest_price);
1588     }
1589     
1590 
1591     function get_my_token_orders () public view returns(uint []) {
1592         uint my_count_token_orders = gods[msg.sender].count_token_orders;
1593         uint [] memory temp_list = new uint[] (my_count_token_orders);
1594         if (my_count_token_orders > 0) {
1595             uint count_list_elements = 0;
1596             for (uint i = gods[msg.sender].first_active_token_order; i <= count_token_orders; i++){
1597                 if (token_orders[i].seller == msg.sender
1598                 && token_orders[i].start_selling_block > 0){
1599                     temp_list[count_list_elements] = i;
1600                     count_list_elements++;
1601                     
1602                     if (count_list_elements >= my_count_token_orders){
1603                         break;
1604                     }
1605                 }
1606             }
1607         }
1608 
1609         return temp_list;
1610     }
1611 
1612 
1613     // end of egst
1614     
1615    
1616     // logs
1617     function get_winner_log (uint pray_round, uint log_id) public view returns (uint, bytes32, address, address, uint, bool, uint){
1618         require(log_id >= 1 && log_id <= count_rounds_winner_logs[pray_round]);
1619         winner_log storage this_winner_log = winner_logs[pray_round][log_id];
1620         
1621         uint ticket_number = this_winner_log.ticket_number;
1622         
1623         return (tickets[ticket_number].block_number,
1624                 tickets[ticket_number].block_hash,
1625                 tickets[ticket_number].owner,
1626                 this_winner_log.previous_winner,
1627                 this_winner_log.prize,
1628                 this_winner_log.pk_result,
1629                 this_winner_log.ticket_number);
1630     }    
1631 
1632     function get_count_rounds_winner_logs (uint pray_round) public view returns (uint){
1633         return count_rounds_winner_logs[pray_round];
1634     }
1635 
1636 
1637     // egses change reasons:  
1638         // 1 pray_reward, 2 god_reward for being invited, 3 inviter_reward,
1639         // 4 admin_deposit to reward_pool, 5 withdraw egses
1640         // 6 sell amulet, 7 sell egst, 8 withdraw bid
1641     
1642     // egst_change reasons: 
1643         // 1 pray_reward, 2 top_gods_reward, 
1644         // 3 create_token_order, 4 withdraw token_order, 5 buy token (> 10),  
1645         // 6 upgrade pet, 7 upgrade amulet, 8 admin_reward, 
1646         // 9 transfer, 10 transferFrom(owner & receiver)
1647 
1648         
1649     function create_change_log (uint asset_type, uint reason, uint change_amount, uint after_amount, address _from, address _to) private returns (uint) {
1650         count_rounds_change_logs[count_rounds] = add(count_rounds_change_logs[count_rounds], 1);
1651         uint log_id = count_rounds_change_logs[count_rounds];
1652  
1653         change_logs[count_rounds][log_id].block_number = block.number;
1654         change_logs[count_rounds][log_id].asset_type = asset_type;
1655         change_logs[count_rounds][log_id].reason = reason;
1656         change_logs[count_rounds][log_id].change_amount = change_amount;
1657         change_logs[count_rounds][log_id].after_amount = after_amount; 
1658         change_logs[count_rounds][log_id]._from = _from;
1659         change_logs[count_rounds][log_id]._to = _to;
1660         
1661         return log_id;
1662     }
1663           
1664     function get_change_log (uint pray_round, uint log_id) public view returns (uint, uint, uint, uint, uint, address, address){ // public
1665         change_log storage this_log = change_logs[pray_round][log_id];
1666         return (this_log.block_number,
1667                 this_log.asset_type,
1668                 this_log.reason, // reason > 10 is buy_token unit_price
1669                 this_log.change_amount,
1670                 this_log.after_amount, // god's after amount. transfer or transferFrom doesn't record log
1671                 this_log._from,
1672                 this_log._to);
1673         
1674     }
1675     
1676     function get_count_rounds_change_logs (uint pray_round) public view returns(uint){
1677         return count_rounds_change_logs[pray_round];
1678     }
1679     
1680     // end of logs
1681 
1682 
1683     // common functions
1684 
1685      function add (uint a, uint b) internal pure returns (uint c) {
1686          c = a + b;
1687          require(c >= a);
1688      }
1689      function sub (uint a, uint b) internal pure returns (uint c) {
1690         require(b <= a);
1691          c = a - b;
1692      }
1693      function mul (uint a, uint b) internal pure returns (uint c) {
1694          c = a * b;
1695          require(a == 0 || c / a == b);
1696      }
1697      function div (uint a, uint b) internal pure returns (uint c) {
1698          require(b > 0);
1699          c = a / b;
1700      }
1701 
1702 }
1703 
1704 
1705 contract EthGodsName {
1706 
1707     // EthGods
1708     EthGods private eth_gods;
1709     address private ethgods_contract_address;   
1710     function set_eth_gods_contract_address (address eth_gods_contract_address) public returns (bool){
1711         require (msg.sender == admin);
1712         
1713         ethgods_contract_address = eth_gods_contract_address;
1714         eth_gods = EthGods(ethgods_contract_address); 
1715         return true;
1716     }
1717   
1718     address private admin; // manually update to ethgods' admin
1719     function update_admin () public returns (bool){
1720         (address new_admin,,,,,,) = eth_gods.query_contract();
1721         require (msg.sender == new_admin);
1722         admin = new_admin;
1723         return true;
1724     }
1725 
1726     //contract information & administration
1727     bool private contract_created; // in case constructor logic change in the future
1728     address private contract_address; //shown at the top of the home page   
1729     
1730     string private invalid_chars = "\\\"";
1731     bytes private invalid_bytes = bytes(invalid_chars);
1732     function set_invalid_chars (string new_invalid_chars) public returns (bool) {
1733         require(msg.sender == admin);
1734         invalid_chars = new_invalid_chars;
1735         invalid_bytes = bytes(invalid_chars);
1736         return true;
1737     }
1738     
1739     uint private valid_length = 16;    
1740     function set_valid_length (uint new_valid_length) public returns (bool) {
1741         require(msg.sender == admin);
1742         valid_length = new_valid_length;
1743         return true;
1744     }
1745     
1746     struct god_name {
1747         string god_name;
1748         uint block_number;
1749         uint block_duration;
1750     }
1751     mapping (address => god_name) private gods_name;
1752 
1753     // start of constructor and destructor
1754     
1755     constructor () public {    
1756         require (contract_created == false);
1757         contract_created = true;
1758         contract_address = address(this);
1759         admin = msg.sender;     
1760         address v_god = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;
1761         gods_name[v_god].god_name = "V";
1762     }
1763 
1764     function () public payable {
1765         revert();  // if received eth for no reason, reject
1766     }
1767 
1768     function finalize() public {
1769         require (msg.sender == admin);
1770         selfdestruct(msg.sender); 
1771     }
1772     
1773     // end of constructor and destructor
1774     
1775     
1776     function set_god_name (string new_name) public returns (bool){
1777         address god_address = msg.sender;
1778         require (add(gods_name[god_address].block_number, gods_name[god_address].block_duration) < block.number );
1779 
1780         bytes memory bs = bytes(new_name);
1781         require (bs.length <= valid_length);
1782         
1783         for (uint i = 0; i < bs.length; i++){
1784             for (uint j = 0; j < invalid_bytes.length; j++) {
1785                 if (bs[i] == invalid_bytes[j]){
1786                     return false;
1787                 } 
1788             }
1789         }
1790 
1791         gods_name[god_address].god_name = new_name;
1792         emit set_name(god_address, new_name);
1793         return true;
1794     }
1795     event set_name (address indexed god_address, string new_name);
1796 
1797 
1798     function get_god_name (address god_address) public view returns (string) {
1799         return gods_name[god_address].god_name;
1800     }
1801 
1802     function block_god_name (address god_address, uint block_duration) public {
1803         require (msg.sender == admin);
1804         gods_name[god_address].god_name = "Unkown";
1805         gods_name[god_address].block_number = block.number;
1806         gods_name[god_address].block_duration = block_duration;
1807     }
1808     
1809     function add (uint a, uint b) internal pure returns (uint c) {
1810         c = a + b;
1811         require(c >= a);
1812     }
1813 }
1814 
1815 
1816 contract EthGodsDice {
1817     
1818     //contract information & administration
1819     bool private contract_created; // in case constructor logic change in the future
1820     address private contract_address; //shown at the top of the home page
1821     address private admin;
1822     
1823     // start of constructor and destructor
1824     constructor () public {
1825         require (contract_created == false);
1826         contract_created = true;
1827         contract_address = address(this);
1828         admin = msg.sender;
1829 
1830     }
1831 
1832     function finalize () public {
1833         require (msg.sender == admin);
1834         selfdestruct(msg.sender); 
1835     }
1836     
1837     function () public payable {
1838         revert();  // if received eth for no reason, reject
1839     }
1840     
1841     // end of constructor and destructor
1842 
1843 
1844     function throw_dice (bytes32 block_hash) public pure returns (uint[]) {// 0 for prize, 1-6 for 6 numbers should be pure
1845         uint[] memory dice_numbers = new uint[](7);
1846         uint hash_number;
1847         uint[] memory count_dice_numbers = new uint[](7);
1848         uint i; // for loop
1849   
1850         for (i = 1; i <= 6; i++) {
1851             hash_number = uint(block_hash[i]);
1852             if (hash_number >= 214) { // 214
1853                 dice_numbers[i] = 6;
1854             } else if (hash_number >= 172) { // 172
1855                 dice_numbers[i] = 5;
1856             } else if (hash_number >= 129) { // 129
1857                 dice_numbers[i] = 4;
1858             } else if (hash_number >= 86) { // 86
1859                 dice_numbers[i] = 3;
1860             } else if (hash_number >= 43) { // 43
1861                 dice_numbers[i] = 2;
1862             } else {
1863                 dice_numbers[i] = 1;
1864             }
1865             count_dice_numbers[dice_numbers[i]] ++;
1866         }
1867 
1868         bool won_super_prize = false;
1869         uint count_super_eth = 0;
1870         for (i = 1; i <= 6; i++) {
1871             if (count_dice_numbers[i] >= 5) {
1872                 dice_numbers[0] = 1; //champion_eth
1873                 won_super_prize = true;
1874                 break;
1875             }else if (count_dice_numbers[i] >= 3) {
1876                 dice_numbers[0] = 3; // super_egst
1877                 won_super_prize = true;
1878                 break;
1879             }else if (count_dice_numbers[i] == 1) {
1880                 count_super_eth ++;
1881                 if (count_super_eth == 6) {
1882                     dice_numbers[0] = 2; // super_eth
1883                     won_super_prize = true;
1884                 }
1885             } 
1886         }
1887 
1888         if (won_super_prize == false) {
1889             dice_numbers[0] = 4;
1890         }
1891         
1892         return dice_numbers;
1893     }
1894     
1895     function pk (bytes32 block_hash, uint attacker_sum_god_levels, uint attacker_sum_amulet_levels, uint defender_sum_god_levels, uint defender_sum_amulet_levels) public pure returns (bool){
1896      
1897         uint god_win_chance;
1898         attacker_sum_god_levels = add(attacker_sum_god_levels, 10);
1899         if (attacker_sum_god_levels < defender_sum_god_levels){
1900             god_win_chance = 0;
1901         } else {
1902             god_win_chance = sub(attacker_sum_god_levels, defender_sum_god_levels);
1903             if (god_win_chance > 20) {
1904                 god_win_chance = 100;
1905             } else { // equal level, 50% chance to win
1906                 god_win_chance = mul(god_win_chance, 5);
1907             }
1908         }        
1909         
1910         
1911         uint amulet_win_chance;
1912         attacker_sum_amulet_levels = add(attacker_sum_amulet_levels, 10);
1913         if (attacker_sum_amulet_levels < defender_sum_amulet_levels){
1914             amulet_win_chance = 0;
1915         } else {
1916             amulet_win_chance = sub(attacker_sum_amulet_levels, defender_sum_amulet_levels);
1917             if (amulet_win_chance > 20) {
1918                 amulet_win_chance = 100;
1919             } else { // equal level, 50% chance to win
1920                 amulet_win_chance = mul(amulet_win_chance, 5);
1921             }
1922         }
1923 
1924         
1925         uint attacker_win_chance = div(add(god_win_chance, amulet_win_chance), 2);
1926         if (attacker_win_chance >= div(mul(uint(block_hash[3]),2),5)){
1927             return true;
1928         } else {
1929             return false;
1930         }
1931         
1932     }
1933     
1934     
1935     // common functions
1936 
1937      function add (uint a, uint b) internal pure returns (uint c) {
1938          c = a + b;
1939          require(c >= a);
1940      }
1941      function sub (uint a, uint b) internal pure returns (uint c) {
1942         require(b <= a);
1943          c = a - b;
1944      }
1945      function mul (uint a, uint b) internal pure returns (uint c) {
1946          c = a * b;
1947          require(a == 0 || c / a == b);
1948      }
1949      function div (uint a, uint b) internal pure returns (uint c) {
1950          require(b > 0);
1951          c = a / b;
1952      }
1953         
1954 }
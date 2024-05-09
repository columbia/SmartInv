1 pragma solidity ^0.4.25;
2 
3  library SafeMath{
4      function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a);
7         return c;
8     } 
9        
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a);
12         uint256 c = a - b;
13         return c; 
14     }
15     
16      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) { 
18             return 0;
19         }
20         uint256 c = a * b;
21         require(c / a == b);
22         return c;
23     }
24      
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28         return c;
29     }
30  }
31  
32  library SafeMath16{
33      function add(uint16 a, uint16 b) internal pure returns (uint16) {
34         uint16 c = a + b;
35         require(c >= a);
36 
37         return c;
38     }
39     
40     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
41         require(b <= a);
42         uint16 c = a - b;
43         return c;
44     }
45     
46      function mul(uint16 a, uint16 b) internal pure returns (uint16) {
47         if (a == 0) {
48             return 0;
49         }
50         uint16 c = a * b;
51         require(c / a == b);
52         return c;
53     }
54     
55     function div(uint16 a, uint16 b) internal pure returns (uint16) {
56         require(b > 0);
57         uint16 c = a / b;
58         return c;
59     }
60  }
61 
62 contract owned {
63 
64     address public manager;
65 
66     constructor() public{
67         manager = msg.sender;
68     }
69  
70     modifier onlymanager{
71         require(msg.sender == manager);
72         _;
73     }
74 
75     function transferownership(address _new_manager) public onlymanager {
76         manager = _new_manager;
77     }
78 }
79 
80 
81 contract byt_str {
82     function stringToBytes32(string memory source) pure public returns (bytes32 result) {
83        
84         assembly {
85             result := mload(add(source, 32))
86         }
87     }
88 
89     function bytes32ToString(bytes32 x) pure public returns (string) {
90         bytes memory bytesString = new bytes(32);
91         uint charCount = 0;
92         for (uint j = 0; j < 32; j++) {
93             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
94             if (char != 0) {
95                 bytesString[charCount] = char;
96                 charCount++;
97             }
98         }
99         bytes memory bytesStringTrimmed = new bytes(charCount);
100         for (j = 0; j < charCount; j++) {
101             bytesStringTrimmed[j] = bytesString[j];
102         }
103         return string(bytesStringTrimmed);
104     }
105 
106 }
107 
108 
109 interface ERC20_interface {
110   function decimals() external view returns(uint8);
111   function totalSupply() external view returns (uint256);
112   function balanceOf(address who) external view returns (uint256);
113   
114   function transfer(address to, uint256 value) external returns(bool);
115   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) ;
116 }
117 
118 
119 interface ERC721_interface{
120      function balanceOf(address _owner) external view returns (uint256);
121      function ownerOf(uint256 _tokenId) external view returns (address);
122      function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
123      function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
124      function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
125      function approve(address _approved, uint256 _tokenId) external payable;
126      function setApprovalForAll(address _operator, bool _approved) external;
127      function getApproved(uint256 _tokenId) external view returns (address);
128      function isApprovedForAll(address _owner, address _operator) external view returns (bool);
129  } 
130  
131  
132  interface slave{
133     function master_address() external view returns(address);
134     
135     function transferMayorship(address new_mayor) external;
136     function city_number() external view returns(uint16);
137     function area_number() external view returns(uint8);
138     
139     function inquire_totdomains_amount() external view returns(uint16);
140     function inquire_domain_level_star(uint16 _id) external view returns(uint8, uint8);
141     function inquire_domain_building(uint16 _id, uint8 _index) external view returns(uint8);
142     function inquire_tot_domain_attribute(uint16 _id) external view returns(uint8[5]);
143     function inquire_domain_cooltime(uint16 _id) external view returns(uint);
144     function inquire_mayor_cooltime() external view returns(uint);
145     function inquire_tot_domain_building(uint16 _id) external view returns(uint8[]);
146     function inquire_own_domain(address _sender) external view returns(uint16[]);
147     function inquire_land_info(uint16 _city, uint16 _id) external view returns(uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8);
148     
149     function inquire_building_limit(uint8 _building) external view returns(uint8);
150     
151     function domain_build(uint16 _id, uint8 _building) external;
152     function reconstruction(uint16 _id, uint8 _index, uint8 _building)external;
153     function set_domian_attribute(uint16 _id, uint8 _index) external;
154     function domain_all_reward(uint8 _class, address _user) external;
155     function mayor_reward(address _user) external; 
156     function inquire_mayor_address() external view returns(address);
157  
158     function domain_reward(uint8 _class, address _user, uint16 _id) external;
159     function transfer_master(address _to, uint16 _id) external;
160     function retrieve_domain(address _user, uint _id) external;
161     function at_Area() external view returns(string);
162     function set_domain_cooltime(uint _cooltime) external;
163  } 
164  
165  interface trade{
166     function set_city_pool(uint _arina, uint16 _city )external;
167     function inquire_pool(uint16 _city) external view returns(uint);
168     function exchange_arina(uint _arina, uint16 _city, address _target) external;
169  }
170 
171  contract master is owned, byt_str {
172     using SafeMath for uint;
173     using SafeMath16 for uint16;
174     
175     
176     address arina_contract = 0xe6987cd613dfda0995a95b3e6acbabececd41376;
177      
178     address GIC_contract = 0x340e85491c5f581360811d0ce5cc7476c72900ba;
179     address trade_address;
180     address mix_address;
181     
182     uint16 public owner_slave_amount = 0; 
183     uint random_seed;
184     uint public probability = 1000000;
185     bool public all_stop = false;
186     
187     
188     struct _info{
189         uint16 city; 
190         uint16 domain; 
191         bool unmovable; 
192         bool lotto; 
193         bool build; 
194         bool reward;
195     }
196     
197     
198     address[] public owner_slave; 
199    
200     mapping (uint8 => string) public area; 
201     mapping (uint8 => string) public building_type;  
202     mapping (uint8 => uint) public building_price; 
203      
204     mapping(address => _info) public player_info;  
205     
206     mapping(bytes32 => address) public member;
207     mapping(address => bytes32) public addressToName;
208     
209     
210     
211     event set_name(address indexed player, uint value); 
212     event FirstSign(address indexed player,uint time); 
213     event RollDice(address indexed player, uint16 city, uint16 id, bool unmovable); 
214     event Change_city(address indexed player, uint16 city, uint16 id, bool unmovable);
215     event Fly(address indexed player, uint16 city, uint16 id, bool unmovable);
216     
217     event PlayLotto(address indexed player,uint player_number, uint lotto_number);
218     
219     event PayArina(address indexed player, uint value, uint16 city, uint16 id);
220     event BuyArina(address indexed player, uint value, uint16 city, uint16 id);
221     event PayEth(address indexed player, uint value, uint16 city, uint16 id);
222     event BuyEth(address indexed player, uint value, uint16 city, uint16 id);
223     
224     event Build(address indexed player, uint8 building, uint value);
225     event Reconstruction(address indexed player, uint8 building, uint value);
226     
227     
228 
229 
230   function register(string _name) public{
231       if(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(""))) {
232           revert();
233       } 
234       bytes32 byte_name =  stringToBytes32(_name);
235    
236       if(addressToName[msg.sender] == 0x0){
237           member[byte_name] = msg.sender;
238           addressToName[msg.sender] = byte_name;
239           emit FirstSign(msg.sender,now); 
240       }else{
241           revert(); 
242       }
243       
244   }
245 
246 
247 
248     function() public payable{}
249     
250     function rollDice() external{
251         require(!all_stop);
252         require(owner_slave_amount >= 1);
253         require(!player_info[msg.sender].unmovable,"不可移動");
254         uint16 random = uint16((keccak256(abi.encodePacked(now, random_seed))));
255         random_seed.add(1);
256         
257         if(player_info[msg.sender].city == 0){
258             player_info[msg.sender].city = 1;
259         }
260         
261         uint16 in_city = player_info[msg.sender].city;
262         
263         
264         uint16 tot_domains = inquire_city_totdomains(in_city);
265         uint16 go_domains_id = random % tot_domains; 
266         
267         
268         
269         player_info[msg.sender].domain = go_domains_id;
270         
271         address city_address = owner_slave[in_city];
272         address domain_owner = ERC721_interface(city_address).ownerOf(go_domains_id);
273         
274         if (domain_owner != 0x0){
275             if(domain_owner == msg.sender){
276                 player_info[msg.sender].build = true; 
277                 
278             }
279             else{
280                 player_info[msg.sender].unmovable = true; 
281                 player_info[msg.sender].reward = false;
282             }
283 		}
284         
285         emit RollDice(msg.sender, in_city, go_domains_id, player_info[msg.sender].unmovable);
286     }
287     
288     function change_city(address _sender, uint16 go_city) private{
289         require(!all_stop);
290         require(owner_slave_amount >= 1);
291         require(!player_info[_sender].unmovable,"不可移動"); 
292         
293         uint16 random = uint16((keccak256(abi.encodePacked(now, random_seed))));
294         random_seed.add(1);
295         
296         uint16 tot_domains = inquire_city_totdomains(go_city);
297         uint16 go_domains_id = random % tot_domains; 
298         
299         player_info[_sender].city = go_city;
300         player_info[_sender].domain = go_domains_id;
301         
302         
303         address city_address = owner_slave[go_city];
304         address domain_owner = ERC721_interface(city_address).ownerOf(go_domains_id);
305         
306         if (domain_owner != 0x0){
307             if(domain_owner == _sender){
308                 player_info[_sender].build = true; 
309                 
310             }
311             else{
312                 player_info[_sender].unmovable = true; 
313                 player_info[msg.sender].reward = false;
314             }
315 		}
316          
317         emit Change_city(_sender, go_city, go_domains_id, player_info[_sender].unmovable);
318     }
319     
320     function fly(uint16 _city, uint16 _domain) public payable{
321         require(msg.value == 0.1 ether);
322         require(owner_slave_amount >= 1);
323         require(!player_info[msg.sender].unmovable);
324         
325         address[] memory checkPlayer;
326         checkPlayer = checkBuildingPlayer(player_info[msg.sender].city,14);
327      
328         
329         player_info[msg.sender].city = _city;
330         player_info[msg.sender].domain = _domain;
331         
332         address city_address = owner_slave[_city];
333         address domain_owner = ERC721_interface(city_address).ownerOf(_domain);
334         uint exchange_player_ETH;
335         
336 
337         if(checkPlayer.length!=0){
338             exchange_player_ETH = msg.value.div(10).mul(1);
339             
340             for(uint8 i = 0 ; i< checkPlayer.length;i++){
341     	        checkPlayer[i].transfer(exchange_player_ETH.div(checkPlayer.length));
342             }
343         } 
344 
345         
346         if (domain_owner != 0x0){
347             if(domain_owner == msg.sender){
348                 player_info[msg.sender].build = true; 
349                 
350             }
351             else{
352                 player_info[msg.sender].unmovable = true; 
353                 player_info[msg.sender].reward = false;
354             }
355 		}
356         player_info[msg.sender].lotto = true;
357         emit Fly(msg.sender, _city, _domain , player_info[msg.sender].unmovable);
358     }
359     
360     function playLotto() external{
361         require(!all_stop);
362         require(player_info[msg.sender].lotto);
363         
364         uint random = uint((keccak256(abi.encodePacked(now, random_seed))));
365         uint random2 = uint((keccak256(abi.encodePacked(random_seed, msg.sender))));
366         random_seed = random_seed.add(1);
367 
368         address _address = inquire_slave_address(player_info[msg.sender].city);
369          
370         if(player_info[msg.sender].unmovable == false){
371             (,uint8 _star) = slave(_address).inquire_domain_level_star(player_info[msg.sender].domain);
372                 if(_star <= 1){
373                     _star = 1;
374                 }
375             probability = probability.div(2**(uint(_star)-1));                   
376             uint8[] memory buildings = slave(_address).inquire_tot_domain_building(player_info[msg.sender].domain);
377             for(uint8 i=0;i< buildings.length;i++){
378                 if(buildings[i] == 8 ){
379                     probability = probability.div(10).mul(9);      
380                     break; 
381                 }
382             }
383         }
384         
385         uint lotto_number = random % probability;
386         uint player_number =  random2 % probability;
387         
388         probability = 1000000;   
389         
390         if(lotto_number == player_number){
391             msg.sender.transfer(address(this).balance.div(10));
392         }
393         
394         player_info[msg.sender].lotto = false;
395         
396         
397         emit PlayLotto(msg.sender, player_number, lotto_number);
398     }
399 
400      
401 
402 
403     function payRoadETH_amount(uint8 _level, uint8 _star) public pure returns(uint){
404          
405         if(_level <= 1){
406     	   return  0.02 ether * 2**(uint(_star)-1) ;
407     	} 
408     	else if(_level > 1) {    
409     	   return  0.02 ether * 2**(uint(_star)-1)*(3**(uint(_level)-1))/(2**(uint(_level)-1)) ;
410     	} 
411     }
412      
413     function buyLandETH_amount(uint8 _level, uint8 _star) public pure returns(uint){
414 
415          
416         if(_level <= 1){
417     	   return  0.2 ether * 2**(uint(_star)-1) ;
418     	} 
419     	else if(_level > 1) {    
420     	   return  0.2 ether * 2**(uint(_star)-1)*(3**(uint(_level)-1))/(2**(uint(_level)-1)) ;
421     	} 
422     }
423      
424     function payARINA_amount(uint8 _level, uint8 _star) public pure returns(uint){
425 
426         
427         if(_level <= 1){
428     	return (10**8) * (2**(uint(_star)-1)*10);
429     	} 
430     	
431     	else if(_level > 1) {   
432     	return (10**8) * (2**(uint(_star)-1)*10)*(3**(uint(_level)-1))/(2**(uint(_level)-1));
433     	}
434 
435     }
436      
437     function buyLandARINA_amount() public pure returns(uint){
438         return 2000*10**8;
439     }
440  
441     function payRent_ETH() external payable{
442         require(!all_stop);
443         require(player_info[msg.sender].unmovable,"檢查不可移動");
444         
445         uint16 city = player_info[msg.sender].city; 
446         uint16 domains_id = player_info[msg.sender].domain;  
447         
448         address city_address = owner_slave[city];
449 		address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
450 		
451 		if (domain_owner == 0x0){
452 		    revert("不用付手續費");
453 		}
454         
455         (uint8 _level,uint8 _star) = slave(city_address).inquire_domain_level_star(domains_id);
456         
457         uint _payRoadETH_amount = payRoadETH_amount(_level, _star);
458         
459         require(msg.value == _payRoadETH_amount);
460         
461         player_info[msg.sender].unmovable = false;
462 
463         uint payRent_ETH_50toOwner = msg.value.div(10).mul(5);
464 		uint payRent_ETH_10toTeam = msg.value.div(10);
465 		uint payRent_ETH_20toCity = msg.value.div(10).mul(2); 
466 		uint payRent_ETH_20toPool = msg.value.div(10).mul(2);
467 		uint pay = payRent_ETH_50toOwner + payRent_ETH_10toTeam + payRent_ETH_20toCity + payRent_ETH_20toPool;
468 		require(msg.value == pay);
469 
470 		domain_owner.transfer(payRent_ETH_50toOwner); 
471         manager.transfer(payRent_ETH_10toTeam); 
472         city_address.transfer(payRent_ETH_20toCity); 
473         
474         player_info[msg.sender].lotto = true;
475         player_info[msg.sender].reward = true;
476         emit PayEth(msg.sender, msg.value, city, domains_id);
477     }
478     
479     function buyLand_ETH() external payable{
480         require(!all_stop);
481         require(player_info[msg.sender].unmovable,"檢查不可移動");
482         
483         uint16 city = player_info[msg.sender].city;
484         uint16 domains_id = player_info[msg.sender].domain;
485         
486         address city_address = owner_slave[city];
487         address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
488         
489         (uint8 _level,uint8 _star) = slave(city_address).inquire_domain_level_star(domains_id);
490         
491         uint _buyLandETH_amount = buyLandETH_amount(_level, _star);
492         require(msg.value == _buyLandETH_amount); 
493         
494         if(domain_owner == 0x0){
495             revert("第一次請用Arina購買");
496         }
497         
498         uint BuyLand_ETH_50toOwner;
499         uint BuyLand_ETH_10toTeam;
500         uint BuyLand_ETH_20toCity; 
501         uint BuyLand_ETH_20toPool;
502         uint pay;
503         
504         if(_level <= 1){
505             BuyLand_ETH_50toOwner = msg.value.div(10).mul(5);
506         	BuyLand_ETH_10toTeam = msg.value.div(10);
507         	BuyLand_ETH_20toCity = msg.value.div(10).mul(2); 
508         	BuyLand_ETH_20toPool = msg.value.div(10).mul(2);
509         	pay = BuyLand_ETH_50toOwner + BuyLand_ETH_10toTeam + BuyLand_ETH_20toCity +BuyLand_ETH_20toPool;
510         	require(msg.value == pay);
511         		 
512         	domain_owner.transfer(BuyLand_ETH_50toOwner); 
513             manager.transfer(BuyLand_ETH_10toTeam); 
514             city_address.transfer(BuyLand_ETH_20toCity); 
515             
516         }
517         else{
518             BuyLand_ETH_50toOwner = msg.value.div(10).mul(8);
519         	BuyLand_ETH_10toTeam = msg.value.div(20);
520         	BuyLand_ETH_20toCity = msg.value.div(20);
521         	BuyLand_ETH_20toPool = msg.value.div(10);
522         	pay = BuyLand_ETH_50toOwner + BuyLand_ETH_10toTeam + BuyLand_ETH_20toCity +BuyLand_ETH_20toPool;
523         	require(msg.value == pay);
524         		
525         	domain_owner.transfer(BuyLand_ETH_50toOwner); 
526             manager.transfer(BuyLand_ETH_10toTeam); 
527             city_address.transfer(BuyLand_ETH_20toCity); 
528             
529         }
530         
531         slave(city_address).transfer_master(msg.sender, domains_id); 
532         
533         player_info[msg.sender].unmovable = false;
534         player_info[msg.sender].lotto = true;
535         emit BuyEth(msg.sender, msg.value, city, domains_id);
536     }
537      
538     function _payRent_ARINA(address _sender, uint _value) private{
539         require(!all_stop);
540         
541         require(player_info[_sender].unmovable,"檢查不可移動");
542         
543         uint16 city = player_info[_sender].city;
544         uint16 domains_id = player_info[_sender].domain; 
545         
546         address city_address = owner_slave[city];
547 		address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
548 		
549 		if(domain_owner == 0x0){
550             revert("空地不用付手續費");
551         }
552 
553         (uint8 _level,uint8 _star) = slave(city_address).inquire_domain_level_star(domains_id);
554         
555         uint _payARINA_amount = payARINA_amount(_level, _star);
556         
557     	require(_value == _payARINA_amount,"金額不對");
558         ERC20_interface arina = ERC20_interface(arina_contract);
559         require(arina.transferFrom(_sender, domain_owner, _value),"交易失敗"); 
560 
561         player_info[_sender].unmovable = false;
562         player_info[_sender].reward = true;
563         
564         emit PayArina(_sender, _value, city, domains_id);
565     }
566 
567     function _buyLand_ARINA(address _sender, uint _value) private{ 
568         
569         
570         require(!all_stop);
571         uint16 city = player_info[_sender].city;
572         uint16 domains_id = player_info[_sender].domain;
573         
574         address city_address = owner_slave[city];
575 		address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
576         
577         if(domain_owner != 0x0){
578             revert("空地才能用Arina買");
579         }
580         
581         uint _buyLandARINA_amount = buyLandARINA_amount();
582         
583         require(_value ==  _buyLandARINA_amount,"金額不對");
584         ERC20_interface arina = ERC20_interface(arina_contract);
585         require(arina.transferFrom(_sender, trade_address, _value)); 
586         
587         slave(city_address).transfer_master(_sender, domains_id); 
588         trade(trade_address).set_city_pool(_value,city);          
589         
590         player_info[_sender].unmovable = false;
591         emit BuyArina(_sender, _value, city, domains_id);
592     }
593     
594     function _build(address _sender, uint8 _building,uint _arina) private {
595         require(!all_stop);
596         require(player_info[_sender].build == true,"不能建設");
597         uint16 city = player_info[_sender].city;
598         uint16 domains_id = player_info[_sender].domain;
599         
600         address city_address = owner_slave[city];
601 		address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
602 		require(_sender == domain_owner,"擁有者不是自己");
603 		
604 		slave(city_address).domain_build(domains_id, _building);
605 		player_info[_sender].build = false;
606 		
607 		emit Build(_sender, _building,_arina);
608     }
609     
610     function reconstruction(uint8 _index, uint8 _building)public payable{
611         uint16 city = player_info[msg.sender].city;
612         uint16 domains_id = player_info[msg.sender].domain;
613         uint BuyLand_ETH_toTeam;
614         address city_address = owner_slave[city];
615 		address domain_owner = ERC721_interface(city_address).ownerOf(domains_id);
616 		require(msg.sender == domain_owner, "限定擁有者");
617          
618         uint arina_price = inquire_type_price(_building);
619         uint eth_price = arina_price.mul(10**6); 
620         
621         require(msg.value == eth_price,"價格不對");
622         BuyLand_ETH_toTeam = msg.value.div(10).mul(7);
623         manager.transfer(BuyLand_ETH_toTeam); 
624         slave(city_address).reconstruction(domains_id, _index, _building);
625         player_info[msg.sender].lotto = true;
626         emit Reconstruction(msg.sender, _building,eth_price);
627     }
628     
629     function domain_attribute(uint16 _city,uint16 _id, uint8 _index) public{
630         require(msg.sender == mix_address);
631         require(!all_stop);
632         address city_address = owner_slave[_city];
633         slave(city_address).set_domian_attribute(_id,_index);
634     }
635      
636     
637     function reward(uint8 _class, uint16 _city, uint16 _domains_id) public{
638         require(!all_stop);
639         if(inquire_owner(_city,_domains_id) != msg.sender){     
640             require(!player_info[msg.sender].unmovable,"不可移動"); 
641             require(_city == player_info[msg.sender].city && _domains_id == player_info[msg.sender].domain);
642             require(player_info[msg.sender].reward == true);
643             player_info[msg.sender].reward = false;
644         }
645      
646         address city_address = owner_slave[_city];
647         slave(city_address).domain_reward(_class, msg.sender, _domains_id);
648     }  
649      
650     function all_reward(uint8 _class,uint16 _city) public{
651         address city_address;
652         
653         city_address = owner_slave[_city];
654         slave(city_address).domain_all_reward(_class, msg.sender);
655         
656         
657     }
658       
659     function mayor_all_reward(uint16 _city) public{
660 
661         address city_address = owner_slave[_city];
662         address _mayor = slave(city_address).inquire_mayor_address();
663         require(msg.sender == _mayor);
664         slave(city_address).mayor_reward(msg.sender);
665         
666     }
667      
668     function set_member_name(address _owner, string new_name) payable public{
669          require(msg.value == 0.1 ether);
670          require(addressToName[msg.sender].length != 0); 
671          require(msg.sender == _owner);
672            
673          bytes32 bytes_old_name = addressToName[msg.sender];   
674          member[bytes_old_name] = 0x0;
675          
676          if(keccak256(abi.encodePacked(new_name)) == keccak256(abi.encodePacked(""))) {
677              revert(); 
678          } 
679          bytes32 bytes_new_name =  stringToBytes32(new_name);    
680         
681          member[bytes_new_name] = msg.sender; 
682          addressToName[msg.sender] = bytes_new_name;
683          emit set_name(msg.sender,msg.value);
684           
685     }
686     
687     function exchange(uint16 _city,uint _value) payable public{
688         uint rate;
689         uint pool = trade(trade_address).inquire_pool(_city);
690         
691         uint exchange_master_ETH;
692         uint exchange_player_ETH;
693         uint exchange_Pool_ETH;
694         require(msg.value == _value*10 ** 13);
695         require(_city == player_info[msg.sender].city);
696         address[] memory checkPlayer;
697         
698         
699         if(pool > 500000 * 10 ** 8){ 
700             rate = 10000;
701         }else if(pool > 250000 * 10 ** 8 && pool <= 500000 * 10 ** 8  ){
702             rate = 5000;
703         }else if(pool > 100000 * 10 ** 8 && pool <= 250000 * 10 ** 8  ){
704             rate = 3000;
705         }else if(pool <= 100000 * 10 ** 8){
706             revert();
707         } 
708         uint exchangeArina = _value * rate * 10 ** 3;
709         trade(trade_address).exchange_arina(exchangeArina,_city, msg.sender);
710         
711         checkPlayer = checkBuildingPlayer(_city,15);
712         
713         if(checkPlayer.length !=0){
714             exchange_master_ETH = msg.value.div(10).mul(8);
715             exchange_player_ETH = msg.value.div(10).mul(1);
716             exchange_Pool_ETH = msg.value.div(10).mul(1);
717             
718             for(uint8 i = 0 ; i< checkPlayer.length;i++){
719     	        checkPlayer[i].transfer(exchange_player_ETH.div(checkPlayer.length));
720     	    }
721         }else{
722             exchange_master_ETH = msg.value.div(10).mul(9);
723             exchange_Pool_ETH = msg.value.div(10);
724         }
725 
726         manager.transfer(exchange_master_ETH); 
727         
728 
729     } 
730      
731     function checkBuildingPlayer(uint16 _city,uint8 building) public view  returns(address[] ){  
732         
733         
734         address[] memory _players = new address[](100);
735         uint16 counter = 0;
736         for(uint8 i=0 ; i<100; i++){
737             uint8[] memory buildings = slave(owner_slave[_city]).inquire_tot_domain_building(i);
738             if(buildings.length != 0){
739                 for(uint8 j = 0; j < buildings.length; j++){ 
740                     if(buildings[j] == building){
741                         _players[counter] = inquire_owner(_city,i); 
742                         counter = counter.add(1);
743                         break;
744                     } 
745                 }  
746                 
747             }
748         } 
749         address[] memory players = new address[](counter);
750         
751         for (i = 0; i < counter; i++) {
752             players[i] = _players[i];
753         }
754         
755         
756         return players;
757     
758     }
759     
760     
761      
762      
763  
764 
765 
766     
767     
768     
769     
770 
771     function inquire_owner(uint16 _city, uint16 _domain) public view returns(address){
772         address city_address = owner_slave[_city];
773         return ERC721_interface(city_address).ownerOf(_domain);
774     }
775     
776     function inquire_have_owner(uint16 _city, uint16 _domain) public view returns(bool){
777         address city_address = owner_slave[_city];
778         address domain_owner = ERC721_interface(city_address).ownerOf(_domain);
779         if(domain_owner == 0x0){
780         return false;
781         }
782         else{return true;}
783     }
784 
785     
786     function inquire_domain_level_star(uint16 _city, uint16 _domain) public view 
787     returns(uint8, uint8){
788         address _address = inquire_slave_address(_city);
789         return slave(_address).inquire_domain_level_star(_domain);
790     }
791     
792     function inquire_slave_address(uint16 _slave) public view returns(address){
793         return owner_slave[_slave];
794     }
795     
796     
797     
798     
799     
800     
801     function inquire_city_totdomains(uint16 _index) public view returns(uint16){
802         address _address = inquire_slave_address(_index);
803         return  slave(_address).inquire_totdomains_amount();
804     }
805     
806     function inquire_location(address _address) public view returns(uint16, uint16){
807         return (player_info[_address].city, player_info[_address].domain);
808     }
809      
810     function inquire_status(address _address) public view returns(bool, bool, bool){
811         return (player_info[_address].unmovable, player_info[_address].lotto, player_info[_address].reward);
812     }
813     
814     function inquire_type(uint8 _typeid) public view returns(string){
815         return building_type[_typeid];
816     }
817     
818     function inquire_type_price(uint8 _typeid) public view returns(uint){
819         return building_price[_typeid];
820     } 
821     
822     function inquire_building(uint16 _slave, uint16 _domain, uint8 _index)
823     public view returns(uint8){
824         address _address = inquire_slave_address(_slave);
825         return slave(_address).inquire_domain_building(_domain, _index);
826     }
827     
828     function inquire_building_amount(uint16 _slave,uint8 _building) public view returns(uint8){
829         address _address = inquire_slave_address(_slave);
830         return slave(_address).inquire_building_limit(_building);
831     }
832      
833     function inquire_tot_attribute(uint16 _slave, uint16 _domain)
834     public view returns(uint8[5]){
835         address _address = inquire_slave_address(_slave);
836         return slave(_address).inquire_tot_domain_attribute(_domain);
837     }
838     
839 
840     function inquire_cooltime(uint16 _slave, uint16 _domain)
841     public view returns(uint){
842         address _address = inquire_slave_address(_slave);
843         return slave(_address).inquire_domain_cooltime(_domain);
844     }
845      
846     
847     
848     
849     
850     
851      
852     function inquire_tot_building(uint16 _slave, uint16 _domain)
853     public view returns(uint8[]){
854         address _address = inquire_slave_address(_slave);
855         return slave(_address).inquire_tot_domain_building(_domain);
856     }
857     
858     function inquire_own_domain(uint16 _city) public view returns(uint16[]){
859  
860         address _address = inquire_slave_address(_city);
861         return slave(_address).inquire_own_domain(msg.sender);
862     }
863     
864     function inquire_land_info(uint16 _city, uint16 _id) public view returns(uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8){
865     
866         address _address = inquire_slave_address(_city);
867         return slave(_address).inquire_land_info(_city,_id);
868     }
869      
870     function inquire_GIClevel(address _address) view public returns(uint8 _level){
871         uint GIC_balance = ERC20_interface(GIC_contract).balanceOf(_address);
872         if (GIC_balance <= 1000*10**18){
873             return 1;
874         }
875         else if(1000*10**18 < GIC_balance && GIC_balance <=10000*10**18){
876             return 2;
877         }
878         else if(10000*10**18 < GIC_balance && GIC_balance <=100000*10**18){
879             return 3;
880         }
881         else if(100000*10**18 < GIC_balance && GIC_balance <=500000*10**18){
882             return 4;
883         }
884         else if(500000*10**18 < GIC_balance){
885             return 5;
886         }
887         else revert();
888     }
889 
890 
891 
892     
893     function receiveApproval(address _sender, uint256 _value,
894     address _tokenContract, bytes _extraData) public{
895         
896         require(_tokenContract == arina_contract);
897           
898         bytes1 action = _extraData[0];
899     
900     
901         if (action == 0x0){ 
902               
903             _payRent_ARINA(_sender, _value);
904         }
905       
906         else if(action == 0x1){ 
907           
908             _buyLand_ARINA(_sender, _value);
909         } 
910        
911         else if(action == 0x2){ 
912             require(_value == 100*10**8);
913             uint16 _city = uint16(_extraData[1]);
914              
915             
916             address[] memory checkPlayer;
917             checkPlayer = checkBuildingPlayer(player_info[_sender].city,17);  
918            
919             if(checkPlayer.length != 0){
920                 for(uint8 i=0;i<checkPlayer.length;i++){
921                     require(ERC20_interface(arina_contract).transferFrom(_sender, checkPlayer[i], _value.div(checkPlayer.length)),"交易失敗");
922                 } 
923             }else{
924                 require(ERC20_interface(arina_contract).transferFrom(_sender, trade_address, _value),"交易失敗");
925                 trade(trade_address).set_city_pool(_value,player_info[_sender].city);
926             }
927             
928              
929             change_city(_sender, _city);
930             
931         }
932       
933         else if(action == 0x3){ 
934          
935             uint8 _building = uint8(_extraData[1]);
936             
937               
938             uint build_value = inquire_type_price(_building);
939     		
940     		require(_value == build_value,"金額不對"); 
941              
942             require(ERC20_interface(arina_contract).transferFrom(_sender, trade_address, _value),"交易失敗");
943             trade(trade_address).set_city_pool(_value,player_info[_sender].city);
944             
945             _build(_sender, _building,_value);
946         }
947         else{revert();}
948 
949     }
950     
951 
952 
953     function set_all_stop(bool _stop) public onlymanager{
954         all_stop = _stop;
955     }
956 
957     function withdraw_all_ETH() public onlymanager{
958         manager.transfer(address(this).balance);
959     }
960      
961     function withdraw_all_arina() public onlymanager{
962         uint asset = ERC20_interface(arina_contract).balanceOf(address(this));
963         ERC20_interface(arina_contract).transfer(manager, asset);
964     }
965     
966     function withdraw_ETH(uint _eth_wei) public onlymanager{
967         manager.transfer(_eth_wei);
968     }
969     
970     function withdraw_arina(uint _arina) public onlymanager{
971         ERC20_interface(arina_contract).transfer(manager, _arina); 
972     }
973     
974     function set_arina_address(address _arina_address) public onlymanager{
975         arina_contract = _arina_address;
976     }
977   
978     
979     
980     
981     
982     
983     
984     function set_slave_mayor(uint16 _index, address newMayor_address) public onlymanager{
985         address contract_address = owner_slave[_index];
986         slave(contract_address).transferMayorship(newMayor_address); 
987     }
988      
989     function push_slave_address(address _address) external onlymanager{
990         
991         require(slave(_address).master_address() == address(this));
992         owner_slave.push(_address);
993         owner_slave_amount = owner_slave_amount.add(1); 
994     } 
995     
996     function change_slave_address(uint16 _index, address _address) external onlymanager{
997         owner_slave[_index] = _address; 
998     }
999     
1000     function set_building_type(uint8 _type, string _name) public onlymanager{
1001         building_type[_type] = _name;
1002     }
1003     
1004     function set_type_price(uint8 _type, uint _price) public onlymanager{
1005         building_price[_type] = _price;
1006     }
1007     
1008     function set_trade_address(address _trade_address) public onlymanager{ 
1009        trade_address = _trade_address;
1010     }
1011     
1012     function set_mix_address(address _mix_address) public onlymanager{ 
1013        mix_address = _mix_address;
1014     }
1015     
1016     function set_cooltime(uint16 _index, uint _cooltime) public onlymanager{
1017         address contract_address = owner_slave[_index];
1018         slave(contract_address).set_domain_cooltime(_cooltime); 
1019     }
1020     
1021 
1022 
1023     constructor() public{
1024         random_seed = uint((keccak256(abi.encodePacked(now))));
1025         
1026         owner_slave.push(address(0));
1027         
1028         area[1] = "魔幻魔法區";
1029         area[2] = "蒸氣龐克區";
1030         area[3] = "現代區";
1031         area[4] = "SCI-FI科幻未來區";
1032                 
1033         
1034         
1035         
1036         building_type[0] = "null" ; 
1037         building_type[1] = "Farm" ; 
1038         building_type[2] = "Mine" ; 
1039         building_type[3] = "Workshop" ; 
1040         building_type[4] = "Bazaar" ; 
1041         building_type[5] = "Arena" ;
1042         building_type[6] = "Adventurer's Guild" ; 
1043         building_type[7] = "Dungeon" ; 
1044         building_type[8] = "Lucky Fountain" ; 
1045         building_type[9] = "Stable" ; 
1046         building_type[10] = "Mega Tower" ; 
1047         
1048         building_type[11] = "Fuel station" ; 
1049         building_type[12] = "Research Lab" ; 
1050         building_type[13] = "Racecourse" ; 
1051         building_type[14] = "Airport" ; 
1052         building_type[15] = "Bank" ; 
1053         building_type[16] = "Department store" ; 
1054         building_type[17] = "Station" ;
1055         building_type[18] = "Hotel" ; 
1056         building_type[19] = "Shop" ; 
1057         building_type[20] = "Weapon factory" ; 
1058         
1059         
1060          
1061         
1062         building_price[0] = 0 ; 
1063         building_price[1] = 2000*10**8 ;
1064         building_price[2] = 2000*10**8 ;
1065         building_price[3] = 2000*10**8 ; 
1066         building_price[4] = 2000*10**8 ; 
1067         building_price[5] = 5000*10**8 ;
1068         building_price[6] = 5000*10**8 ;
1069         building_price[7] = 5000*10**8 ;
1070         building_price[8] = 5000*10**8 ;
1071         building_price[9] = 5000*10**8 ;
1072         building_price[10] = 5000*10**8 ; 
1073         
1074         building_price[11] = 2000*10**8 ; 
1075         building_price[12] = 10000*10**8 ;
1076         building_price[13] = 5000*10**8 ;
1077         building_price[14] = 20000*10**8 ; 
1078         building_price[15] = 10000*10**8 ; 
1079         building_price[16] = 5000*10**8 ;
1080         building_price[17] = 5000*10**8 ;
1081         building_price[18] = 5000*10**8 ;
1082         building_price[19] = 5000*10**8 ;
1083         building_price[20] = 5000*10**8 ;
1084     }
1085     
1086  }
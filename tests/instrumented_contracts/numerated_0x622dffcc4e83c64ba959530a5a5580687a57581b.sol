1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract owned {
30     address public owner;
31     function owned() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != 0x0);
42         owner = newOwner;
43     }
44 }
45 
46 contract BasicToken is owned {
47     using SafeMath for uint256;
48 
49     mapping (address => uint256) internal balance_of;
50     mapping (address => mapping (address => uint256)) internal allowances;
51 
52     mapping (address => bool) private address_exist;
53     address[] private address_list;
54 
55     bool public transfer_close = false;
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     function BasicToken() public {
60     }
61 
62     function balanceOf(address token_owner) public constant returns (uint balance) {
63         return balance_of[token_owner];
64     }
65 
66     function allowance(
67         address _hoarder,
68         address _spender
69     ) public constant returns (uint256) {
70         return allowances[_hoarder][_spender];
71     }
72 
73     function superApprove(
74         address _hoarder,
75         address _spender,
76         uint256 _value
77     ) onlyOwner public returns(bool) {
78         require(_hoarder != address(0));
79         require(_spender != address(0));
80         require(_value >= 0);
81         allowances[_hoarder][_spender] = _value;
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool) {
86         require(msg.sender != address(0));
87         require(_spender != address(0));
88         require(_value >= 0);
89         allowances[msg.sender][_spender] = _value;
90         return true;
91     }
92 
93     function getAddressLength() onlyOwner public constant returns (uint) {
94         return address_list.length;
95     }
96 
97     function getAddressIndex(uint _address_index) onlyOwner public constant returns (address _address) {
98         _address = address_list[_address_index];
99     }
100 
101     function getAllAddress() onlyOwner public constant returns (address[]) {
102         return address_list;
103     }
104 
105     function getAddressExist(address _target) public constant returns (bool) {
106         if (_target == address(0)) {
107             return false;
108         } else {
109             return address_exist[_target];
110         }
111     }
112 
113     function addAddress(address _target) internal returns(bool) {
114         if (_target == address(0)) {
115             return false;
116         } else if (address_exist[_target] == true) {
117             return false;
118         } else {
119             address_exist[_target] = true;
120             address_list[address_list.length++] = _target;
121         }
122     }
123 
124     function mintToken(
125         address _to,
126         uint256 token_amount,
127         uint256 freeze_timestamp
128     ) onlyOwner public returns (bool);
129 
130     function superMint(
131         address _to,
132         uint256 token_amount,
133         uint256 freeze_timestamp) onlyOwner public returns(bool);
134 
135     function transfer(address to, uint256 value) public;
136     function transferFrom(address _from, address _to, uint256 _amount) public;
137 
138     function transferOpen() onlyOwner public {
139         transfer_close = false;
140     }
141 
142     function transferClose() onlyOwner public {
143         transfer_close = true;
144     }
145 }
146 
147 contract PreSale is owned{
148     using SafeMath for uint256;
149 
150     struct Sale {
151         uint sale_number;
152         uint256 start_timestamp;
153         uint256 end_timestamp;
154         uint8 bonus_rate;
155         uint256 sell_limit;
156     }
157 
158     Sale[] private sale_list;
159     uint256[] private sale_sold;
160 
161     function PreSale () public {
162 
163     }
164 
165     function getSaleLength() public constant returns(uint) {
166         return sale_list.length;
167     }
168 
169     function getSaleInfo(uint _index) public constant returns(
170         uint sale_number,
171         uint256 start_timestamp,
172         uint256 end_timestamp,
173         uint8 bonus_rate,
174         uint256 sell_limit
175     ) {
176         sale_number = sale_list[_index].sale_number;
177         start_timestamp = sale_list[_index].start_timestamp;
178         end_timestamp = sale_list[_index].end_timestamp;
179         bonus_rate = sale_list[_index].bonus_rate;
180         sell_limit = sale_list[_index].sell_limit;
181     }
182 
183     function getSaleSold(uint _index) public constant returns(uint256) {
184         return sale_sold[_index];
185     }
186 
187 
188     function addBonus(
189         uint256 _amount,
190         uint8 _bonus
191     ) internal pure returns(uint256) {
192         return _amount.add((_amount.mul(_bonus)).div(100));
193     }
194 
195 
196     function newSale(
197         uint256 start_timestamp,
198         uint256 end_timestamp,
199         uint8 bonus_rate,
200         uint256 sell_token_limit
201     ) onlyOwner public {
202         require(start_timestamp > 0);
203         require(end_timestamp > 0);
204         require(sell_token_limit > 0);
205 
206         uint256 sale_number = sale_list.length;
207         for (uint i=0; i < sale_list.length; i++) {
208             require(sale_list[i].end_timestamp < start_timestamp);
209         }
210 
211         sale_list[sale_list.length++] = Sale({
212             sale_number: sale_number,
213             start_timestamp: start_timestamp,
214             end_timestamp: end_timestamp,
215             bonus_rate: bonus_rate,
216             sell_limit: sell_token_limit
217         });
218         sale_sold[sale_sold.length++] = 0;
219     }
220 
221     function changeSaleInfo(
222         uint256 _index,
223         uint256 start_timestamp,
224         uint256 end_timestamp,
225         uint8 bonus_rate,
226         uint256 sell_token_limit
227     ) onlyOwner public returns(bool) {
228         require(_index < sale_list.length);
229         require(start_timestamp > 0);
230         require(end_timestamp > 0);
231         require(sell_token_limit > 0);
232 
233         sale_list[_index].start_timestamp = start_timestamp;
234         sale_list[_index].end_timestamp = end_timestamp;
235         sale_list[_index].bonus_rate = bonus_rate;
236         sale_list[_index].sell_limit = sell_token_limit;
237         return true;
238     }
239 
240     function changeSaleStart(
241         uint256 _index,
242         uint256 start_timestamp
243     ) onlyOwner public returns(bool) {
244         require(_index < sale_list.length);
245         require(start_timestamp > 0);
246         sale_list[_index].start_timestamp = start_timestamp;
247         return true;
248     }
249 
250     function changeSaleEnd(
251         uint256 _index,
252         uint256 end_timestamp
253     ) onlyOwner public returns(bool) {
254         require(_index < sale_list.length);
255         require(end_timestamp > 0);
256         sale_list[_index].end_timestamp = end_timestamp;
257         return true;
258     }
259 
260     function changeSaleBonusRate(
261         uint256 _index,
262         uint8 bonus_rate
263     ) onlyOwner public returns(bool) {
264         require(_index < sale_list.length);
265         sale_list[_index].bonus_rate = bonus_rate;
266         return true;
267     }
268 
269     function changeSaleTokenLimit(
270         uint256 _index,
271         uint256 sell_token_limit
272     ) onlyOwner public returns(bool) {
273         require(_index < sale_list.length);
274         require(sell_token_limit > 0);
275         sale_list[_index].sell_limit = sell_token_limit;
276         return true;
277     }
278 
279 
280     function checkSaleCanSell(
281         uint256 _index,
282         uint256 _amount
283     ) internal view returns(bool) {
284         uint256 index_sold = sale_sold[_index];
285         uint256 index_end_timestamp = sale_list[_index].end_timestamp;
286         uint256 sell_limit = sale_list[_index].sell_limit;
287         uint8 bonus_rate = sale_list[_index].bonus_rate;
288         uint256 sell_limit_plus_bonus = addBonus(sell_limit, bonus_rate);
289 
290         if (now >= index_end_timestamp) {
291             return false;
292         } else if (index_sold.add(_amount) > sell_limit_plus_bonus) {
293             return false;
294         } else {
295             return true;
296         }
297     }
298 
299     function addSaleSold(uint256 _index, uint256 amount) internal {
300         require(amount > 0);
301         require(_index < sale_sold.length);
302         require(checkSaleCanSell(_index, amount) == true);
303         sale_sold[_index] += amount;
304     }
305 
306     function subSaleSold(uint256 _index, uint256 amount) internal {
307         require(amount > 0);
308         require(_index < sale_sold.length);
309         require(sale_sold[_index].sub(amount) >= 0);
310         sale_sold[_index] -= amount;
311     }
312 
313     function canSaleInfo() public view returns(
314         uint sale_number,
315         uint256 start_timestamp,
316         uint256 end_timestamp,
317         uint8 bonus_rate,
318         uint256 sell_limit
319     ) {
320         var(sale_info, isSale) = nowSaleInfo();
321         require(isSale == true);
322         sale_number = sale_info.sale_number;
323         start_timestamp = sale_info.start_timestamp;
324         end_timestamp = sale_info.end_timestamp;
325         bonus_rate = sale_info.bonus_rate;
326         sell_limit = sale_info.sell_limit;
327     }
328 
329     function nowSaleInfo() internal view returns(Sale sale_info, bool isSale) {
330         isSale = false;
331         for (uint i=0; i < sale_list.length; i++) {
332             uint256 end_timestamp = sale_list[i].end_timestamp;
333             uint256 sell_limit = sale_list[i].sell_limit;
334             uint8 bonus_rate = sale_list[i].bonus_rate;
335             uint256 sell_limit_plus_bonus = addBonus(sell_limit, bonus_rate);
336             uint256 temp_sold_token = sale_sold[i];
337             if ((now <= end_timestamp) && (temp_sold_token < sell_limit_plus_bonus)) {
338                 sale_info = Sale({
339                     sale_number: sale_list[i].sale_number,
340                     start_timestamp: sale_list[i].start_timestamp,
341                     end_timestamp: sale_list[i].end_timestamp,
342                     bonus_rate: sale_list[i].bonus_rate,
343                     sell_limit: sale_list[i].sell_limit
344                 });
345                 isSale = true;
346                 break;
347             } else {
348                 isSale = false;
349                 continue;
350             }
351         }
352     }
353 }
354 
355 contract Vote is owned {
356     event ProposalAdd(uint vote_id, address generator, string descript);
357     event ProposalEnd(uint vote_id, string descript);
358 
359     struct Proposal {
360         address generator;
361         string descript;
362         uint256 start_timestamp;
363         uint256 end_timestamp;
364         bool executed;
365         uint256 voting_cut;
366         uint256 threshold;
367 
368         uint256 voting_count;
369         uint256 total_weight;
370         mapping (address => uint256) voteWeightOf;
371         mapping (address => bool) votedOf;
372         address[] voter_address;
373     }
374 
375     uint private vote_id = 0;
376     Proposal[] private Proposals;
377 
378     function getProposalLength() public constant returns (uint) {
379         return Proposals.length;
380     }
381 
382     function getProposalIndex(uint _proposal_index) public constant returns (
383         address generator,
384         string descript,
385         uint256 start_timestamp,
386         uint256 end_timestamp,
387         bool executed,
388         uint256 voting_count,
389         uint256 total_weight,
390         uint256 voting_cut,
391         uint256 threshold
392     ) {
393         generator = Proposals[_proposal_index].generator;
394         descript = Proposals[_proposal_index].descript;
395         start_timestamp = Proposals[_proposal_index].start_timestamp;
396         end_timestamp = Proposals[_proposal_index].end_timestamp;
397         executed = Proposals[_proposal_index].executed;
398         voting_count = Proposals[_proposal_index].voting_count;
399         total_weight = Proposals[_proposal_index].total_weight;
400         voting_cut = Proposals[_proposal_index].voting_cut;
401         threshold = Proposals[_proposal_index].threshold;
402     }
403 
404     function getProposalVoterList(uint _proposal_index) public constant returns (address[]) {
405         return Proposals[_proposal_index].voter_address;
406     }
407 
408     function newVote(
409         address who,
410         string descript,
411         uint256 start_timestamp,
412         uint256 end_timestamp,
413         uint256 voting_cut,
414         uint256 threshold
415     ) onlyOwner public returns (uint256) {
416         if (Proposals.length >= 1) {
417             require(Proposals[vote_id].end_timestamp < start_timestamp);
418             require(Proposals[vote_id].executed == true);
419         }
420 
421         vote_id = Proposals.length;
422         Proposal storage p = Proposals[Proposals.length++];
423         p.generator = who;
424         p.descript = descript;
425         p.start_timestamp = start_timestamp;
426         p.end_timestamp = end_timestamp;
427         p.executed = false;
428         p.voting_cut = voting_cut;
429         p.threshold = threshold;
430 
431         p.voting_count = 0;
432         delete p.voter_address;
433         ProposalAdd(vote_id, who, descript);
434         return vote_id;
435     }
436 
437     function voting(address _voter, uint256 _weight) internal returns(bool) {
438         if (Proposals[vote_id].end_timestamp < now) {
439             Proposals[vote_id].executed = true;
440         }
441 
442         require(Proposals[vote_id].executed == false);
443         require(Proposals[vote_id].end_timestamp > now);
444         require(Proposals[vote_id].start_timestamp <= now);
445         require(Proposals[vote_id].votedOf[_voter] == false);
446         require(Proposals[vote_id].voting_cut <= _weight);
447 
448         Proposals[vote_id].votedOf[_voter] = true;
449         Proposals[vote_id].voting_count += 1;
450         Proposals[vote_id].voteWeightOf[_voter] = _weight;
451         Proposals[vote_id].total_weight += _weight;
452         Proposals[vote_id].voter_address[Proposals[vote_id].voter_address.length++] = _voter;
453 
454         if (Proposals[vote_id].total_weight >= Proposals[vote_id].threshold) {
455             Proposals[vote_id].executed = true;
456         }
457         return true;
458     }
459 
460     function voteClose() onlyOwner public {
461         if (Proposals.length >= 1) {
462             Proposals[vote_id].executed = true;
463             ProposalEnd(vote_id, Proposals[vote_id].descript);
464         }
465     }
466 
467     function checkVote() onlyOwner public {
468         if ((Proposals.length >= 1) &&
469             (Proposals[vote_id].end_timestamp < now)) {
470             voteClose();
471         }
472     }
473 }
474 
475 contract FreezeToken is owned {
476     mapping (address => uint256) public freezeDateOf;
477 
478     event Freeze(address indexed _who, uint256 _date);
479     event Melt(address indexed _who);
480 
481     function checkFreeze(address _sender) public constant returns (bool) {
482         if (now >= freezeDateOf[_sender]) {
483             return false;
484         } else {
485             return true;
486         }
487     }
488 
489     function freezeTo(address _who, uint256 _date) internal {
490         freezeDateOf[_who] = _date;
491         Freeze(_who, _date);
492     }
493 
494     function meltNow(address _who) internal onlyOwner {
495         freezeDateOf[_who] = now;
496         Melt(_who);
497     }
498 }
499 
500 contract TokenInfo is owned {
501     using SafeMath for uint256;
502 
503     address public token_wallet_address;
504 
505     string public name = "CUBE";
506     string public symbol = "AUTO";
507     uint256 public decimals = 18;
508     uint256 public total_supply = 7200000000 * (10 ** uint256(decimals));
509 
510     // 1 ether : 100,000 token
511     uint256 public conversion_rate = 100000;
512 
513     event ChangeTokenName(address indexed who);
514     event ChangeTokenSymbol(address indexed who);
515     event ChangeTokenWalletAddress(address indexed from, address indexed to);
516     event ChangeTotalSupply(uint256 indexed from, uint256 indexed to);
517     event ChangeConversionRate(uint256 indexed from, uint256 indexed to);
518     event ChangeFreezeTime(uint256 indexed from, uint256 indexed to);
519 
520     function totalSupply() public constant returns (uint) {
521         return total_supply;
522     }
523 
524     function changeTokenName(string newName) onlyOwner public {
525         name = newName;
526         ChangeTokenName(msg.sender);
527     }
528 
529     function changeTokenSymbol(string newSymbol) onlyOwner public {
530         symbol = newSymbol;
531         ChangeTokenSymbol(msg.sender);
532     }
533 
534     function changeTokenWallet(address newTokenWallet) onlyOwner internal {
535         require(newTokenWallet != address(0));
536         address pre_address = token_wallet_address;
537         token_wallet_address = newTokenWallet;
538         ChangeTokenWalletAddress(pre_address, token_wallet_address);
539     }
540 
541     function changeTotalSupply(uint256 _total_supply) onlyOwner internal {
542         require(_total_supply > 0);
543         uint256 pre_total_supply = total_supply;
544         total_supply = _total_supply;
545         ChangeTotalSupply(pre_total_supply, total_supply);
546     }
547 
548     function changeConversionRate(uint256 _conversion_rate) onlyOwner public {
549         require(_conversion_rate > 0);
550         uint256 pre_conversion_rate = conversion_rate;
551         conversion_rate = _conversion_rate;
552         ChangeConversionRate(pre_conversion_rate, conversion_rate);
553     }
554 }
555 
556 contract Token is owned, PreSale, FreezeToken, TokenInfo, Vote, BasicToken {
557     using SafeMath for uint256;
558 
559     bool public open_free = false;
560 
561     event Payable(address indexed who, uint256 eth_amount);
562     event Transfer(address indexed from, address indexed to, uint256 value);
563     event Burn(address indexed from, uint256 value);
564     event Mint(address indexed to, uint256 value);
565 
566     function Token (address _owner_address, address _token_wallet_address) public {
567         require(_token_wallet_address != address(0));
568 
569         if (_owner_address != address(0)) {
570             owner = _owner_address;
571             balance_of[owner] = 0;
572         } else {
573             owner = msg.sender;
574             balance_of[owner] = 0;
575         }
576 
577         token_wallet_address = _token_wallet_address;
578         balance_of[token_wallet_address] = total_supply;
579     }
580 
581     function mintToken(
582         address to,
583         uint256 token_amount,
584         uint256 freeze_timestamp
585     ) onlyOwner public returns (bool) {
586         require(token_amount > 0);
587         require(balance_of[token_wallet_address] >= token_amount);
588         require(balance_of[to] + token_amount > balance_of[to]);
589         uint256 token_plus_bonus = 0;
590         uint sale_number = 0;
591 
592         var(sale_info, isSale) = nowSaleInfo();
593         if (isSale) {
594             sale_number = sale_info.sale_number;
595             uint8 bonus_rate = sale_info.bonus_rate;
596             token_plus_bonus = addBonus(token_amount, bonus_rate);
597             require(checkSaleCanSell(sale_number, token_plus_bonus) == true);
598             addSaleSold(sale_number, token_plus_bonus);
599         } else if (open_free) {
600             token_plus_bonus = token_amount;
601         } else {
602             require(open_free == true);
603         }
604 
605         balance_of[token_wallet_address] -= token_plus_bonus;
606         balance_of[to] += token_plus_bonus;
607 
608         uint256 _freeze = 0;
609         if (freeze_timestamp >= 0) {
610             _freeze = freeze_timestamp;
611         }
612 
613         freezeTo(to, now + _freeze); // FreezeToken.sol
614         Transfer(0x0, to, token_plus_bonus);
615         addAddress(to);
616         return true;
617     }
618 
619     function mintTokenBulk(address[] _tos, uint256[] _amounts) onlyOwner public {
620         require(_tos.length == _amounts.length);
621         for (uint i=0; i < _tos.length; i++) {
622             mintToken(_tos[i], _amounts[i], 0);
623         }
624     }
625 
626     function superMint(
627         address to,
628         uint256 token_amount,
629         uint256 freeze_timestamp
630     ) onlyOwner public returns(bool) {
631         require(token_amount > 0);
632         require(balance_of[token_wallet_address] >= token_amount);
633         require(balance_of[to] + token_amount > balance_of[to]);
634 
635         balance_of[token_wallet_address] -= token_amount;
636         balance_of[to] += token_amount;
637 
638         uint256 _freeze = 0;
639         if (freeze_timestamp >= 0) {
640             _freeze = freeze_timestamp;
641         }
642 
643         freezeTo(to, now + _freeze);
644         Transfer(0x0, to, token_amount);
645         Mint(to, token_amount);
646         addAddress(to);
647         return true;
648     }
649 
650     function superMintBulk(address[] _tos, uint256[] _amounts) onlyOwner public {
651         require(_tos.length == _amounts.length);
652         for (uint i=0; i < _tos.length; i++) {
653             superMint(_tos[i], _amounts[i], 0);
654         }
655     }
656 
657     function transfer(address to, uint256 value) public {
658         _transfer(msg.sender, to, value);
659     }
660 
661     function transferBulk(address[] tos, uint256[] values) public {
662         require(tos.length == values.length);
663         for (uint i=0; i < tos.length; i++) {
664             transfer(tos[i], values[i]);
665         }
666     }
667 
668     function transferFrom(
669         address _from,
670         address _to,
671         uint256 _amount
672     ) public {
673         require(msg.sender != address(0));
674         require(_from != address(0));
675         require(_amount <= allowances[_from][msg.sender]);
676         _transfer(_from, _to, _amount);
677         allowances[_from][msg.sender] -= _amount;
678     }
679 
680     function _transfer(
681         address _from,
682         address _to,
683         uint256 _amount
684     ) private {
685         require(_from != address(0));
686         require(_to != address(0));
687         require(balance_of[_from] >= _amount);
688         require(balance_of[_to].add(_amount) >= balance_of[_to]);
689         require(transfer_close == false);
690         require(checkFreeze(_from) == false);
691 
692         uint256 prevBalance = balance_of[_from] + balance_of[_to];
693         balance_of[_from] -= _amount;
694         balance_of[_to] += _amount;
695         assert(balance_of[_from] + balance_of[_to] == prevBalance);
696         addAddress(_to);
697         Transfer(_from, _to, _amount);
698     }
699 
700     function burn(address _who, uint256 _amount) onlyOwner public returns(bool) {
701         require(_amount > 0);
702         require(balanceOf(_who) >= _amount);
703         balance_of[_who] -= _amount;
704         total_supply -= _amount;
705         Burn(_who, _amount);
706         return true;
707     }
708 
709     function additionalTotalSupply(uint256 _addition) onlyOwner public returns(bool) {
710         require(_addition > 0);
711         uint256 change_total_supply = total_supply.add(_addition);
712         balance_of[token_wallet_address] += _addition;
713         changeTotalSupply(change_total_supply);
714     }
715 
716     function tokenWalletChange(address newTokenWallet) onlyOwner public returns(bool) {
717         require(newTokenWallet != address(0));
718         uint256 token_wallet_amount = balance_of[token_wallet_address];
719         balance_of[newTokenWallet] = token_wallet_amount;
720         balance_of[token_wallet_address] = 0;
721         changeTokenWallet(newTokenWallet);
722     }
723 
724     function () payable public {
725         uint256 eth_amount = msg.value;
726         msg.sender.transfer(eth_amount);
727         Payable(msg.sender, eth_amount);
728     }
729 
730     function tokenOpen() onlyOwner public {
731         open_free = true;
732     }
733 
734     function tokenClose() onlyOwner public {
735         open_free = false;
736     }
737 
738     function freezeAddress(
739         address _who,
740         uint256 _addTimestamp
741     ) onlyOwner public returns(bool) {
742         freezeTo(_who, _addTimestamp);
743         return true;
744     }
745 
746     function meltAddress(
747         address _who
748     ) onlyOwner public returns(bool) {
749         meltNow(_who);
750         return true;
751     }
752 
753     // call a voting in Vote.sol
754     function voteAgree() public returns (bool) {
755         address _voter = msg.sender;
756         uint256 _balance = balanceOf(_voter);
757         require(_balance > 0);
758         return voting(_voter, _balance);
759     }
760 
761     function superVoteAgree(address who) onlyOwner public returns(bool) {
762         require(who != address(0));
763         uint256 _balance = balanceOf(who);
764         require(_balance > 0);
765         return voting(who, _balance);
766     }
767 }
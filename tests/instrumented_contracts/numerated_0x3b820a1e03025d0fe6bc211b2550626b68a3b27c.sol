1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 interface IERC20 {
75     function transfer(address to, uint256 value) external returns (bool);
76 
77     function approve(address spender, uint256 value) external returns (bool);
78 
79     function transferFrom(address from, address to, uint256 value) external returns (bool);
80 
81     function totalSupply() external view returns (uint256);
82 
83     function balanceOf(address who) external view returns (uint256);
84 
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
99  * Originally based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116     * @dev Total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param owner The address to query the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142     * @dev Transfer token for a specified address
143     * @param to The address to transfer to.
144     * @param value The amount to be transferred.
145     */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         require(spender != address(0));
162 
163         _allowed[msg.sender][spender] = value;
164         emit Approval(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
178         _transfer(from, to, value);
179         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
180         return true;
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      * approve should be called when allowed_[_spender] == 0. To increment
186      * allowed value is better to use this function to avoid 2 calls (and wait until
187      * the first transaction is mined)
188      * From MonolithDAO Token.sol
189      * Emits an Approval event.
190      * @param spender The address which will spend the funds.
191      * @param addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
194         require(spender != address(0));
195 
196         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
197         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when allowed_[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         require(spender != address(0));
213 
214         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
215         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216         return true;
217     }
218 
219 
220     function sellTokens(address payable from, uint256 value) internal;
221 
222     /**
223     * @dev Transfer token for a specified addresses
224     * @param from The address to transfer from.
225     * @param to The address to transfer to.
226     * @param value The amount to be transferred.
227     */
228     function _transfer(address from, address to, uint256 value) internal {
229         require(to != address(0));
230 
231         _balances[from] = _balances[from].sub(value);
232         _balances[to] = _balances[to].add(value);
233         emit Transfer(from, to, value);
234         if (to == address(this) && msg.sender == from) {
235             sellTokens(msg.sender, value);
236         } else {
237             addInvestor(to);
238         }
239     }
240 
241     /**
242      * @dev Internal function that mints an amount of the token and assigns it to
243      * an account. This encapsulates the modification of balances such that the
244      * proper events are emitted.
245      * @param account The account that will receive the created tokens.
246      * @param value The amount that will be created.
247      */
248     function _mint(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.add(value);
252         _balances[account] = _balances[account].add(value);
253         emit Transfer(address(0), account, value);
254         addInvestor(account);
255     }
256 
257     /**
258      * @dev Internal function that burns an amount of the token of a given
259      * account.
260      * @param account The account whose tokens will be burnt.
261      * @param value The amount that will be burnt.
262      */
263     function _burn(address account, uint256 value) internal {
264         require(account != address(0));
265 
266         _totalSupply = _totalSupply.sub(value);
267         _balances[account] = _balances[account].sub(value);
268         emit Transfer(account, address(0), value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account, deducting from the sender's allowance for said account. Uses the
274      * internal burn function.
275      * Emits an Approval event (reflecting the reduced allowance).
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burnFrom(address account, uint256 value) internal {
280         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
281         _burn(account, value);
282         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
283     }
284 
285     function addInvestor(address investor) internal;
286 }
287 
288 contract DividendsERC20 is ERC20 {
289 
290     event Dividends(address indexed investor, uint256 value);
291 
292     mapping(address => bool)  public inList;
293     address[]  internal investorList;
294     uint8 internal nextReferId = 0;
295 
296     function addInvestor(address investor) internal {
297         if (!inList[investor]) {
298             investorList.push(investor);
299             inList[investor] = true;
300         }
301     }
302 
303     function getList() public view returns (address[] memory){
304         return investorList;
305     }
306 
307     function distribute(address buyer, uint256 tokens) internal returns (uint256) {
308 
309         uint256 _total = totalSupply() - balanceOf(buyer);
310         uint256 distributed = 0;
311         for (uint i = 0; i < investorList.length; i++) {
312             address investor = investorList[i];
313             uint256 _balance = balanceOf(investor);
314             if (_balance > 0 && investor != buyer) {
315                 uint256 _dividend = _balance * tokens / _total;
316                 _mint(investor, _dividend);
317                 emit Dividends(investor, _dividend);
318                 distributed += _dividend;
319             }
320         }
321         return distributed;
322     }
323 
324 
325 }
326 
327 contract ReferalsERC20 is DividendsERC20 {
328 
329     event ReferalBonus(address indexed from, address indexed to, uint256 value);
330 
331     mapping(address => int256) internal SBalance;
332     mapping(address => address) public refers;
333 
334     function getNextRefer() private returns (address) {
335         if (investorList.length > nextReferId) {
336             address result = investorList[nextReferId];
337             if (nextReferId < 9 && nextReferId < investorList.length - 1) {
338                 nextReferId = nextReferId + 1;
339             } else {
340                 nextReferId = 0;
341             }
342             return result;
343         }
344         else {
345             return address(0x0);
346         }
347     }
348 
349     function checkRefer(address referal, address refer) internal returns (address){
350 
351         if (investorList.length < 1 || referal == investorList[0]) return address(0x0);
352 
353         if (refers[referal] == address(0x0)) {
354 
355             if (refer == address(0x0)) {
356                 refers[referal] = getNextRefer();
357             } else {
358 
359                 refers[referal] = refer;
360 
361 
362 
363             }
364         }
365 
366         return refers[referal];
367     }
368 
369     function changeSBalance(address investor, int256 amount) internal returns (int256){
370         SBalance[investor] = SBalance[investor] + amount;
371         return SBalance[investor];
372     }
373 
374     function calcToRefer(address investor, uint256 amount, uint256 tokens)
375     internal returns (uint256){
376         int256 thisSBalance = changeSBalance(investor, int256(amount));
377         uint256 result = 0;
378 
379         if (thisSBalance >= int256(amount)) {
380             result = tokens / 20;
381             changeSBalance(investor, int256( amount) * (-1) );
382         } else if (thisSBalance > 0) {
383             result = (uint256(thisSBalance) * tokens / amount) / 20;
384             changeSBalance(investor, thisSBalance * (-1));
385         }
386         return result;
387     }
388 
389 }
390 
391 
392 contract FibonumCyclingToken is ReferalsERC20 {
393 
394 
395     string public name = "Fibonum Cycling Token";
396     string public symbol = "FCT";
397     uint8 public decimals = 18;
398 
399     event Buy(address indexed investor, uint256 indexed tokens, uint256 ethers);
400     event Sell(address indexed investor, uint256 indexed tokens, uint256 ethers);
401 
402 
403     int256 private x = 0; 
404     int256 private c = 0;
405     int256 private  n = 1000000000000000000;
406 
407     int256 constant xe = 1590797660368290000;
408     int256 constant ce = 1428285685708570000;
409     int256 constant xa = 775397496610753000;
410     int256 constant ca = - 714142842854285000;
411 
412 
413 
414 
415     uint64[] ethToTokenA = [uint64(1417139259168220000), 1395328479040590000, 1374818151911760000, 1355496481642670000,
416     1337264861422160000, 1320035947620740000, 1303732066667570000, 1288283889008670000, 1273629318822690000,
417     1259712559222210000, 1246483321098410000, 1233896150251810000, 1221909852479560000, 1210487000216940000,
418     1199593507419850000, 1189198261821420000, 1179272805644490000, 1169791057414210000, 1160729068774030000,
419     1152064811228980000, 1143777988571040000, 1135849871421960000, 1128263150888080000, 1121001808783790000,
420     1114051002263240000, 1107396961019390000, 1101026895475830000, 1094928914620790000, 1089091952321460000,
421     1083505701115530000, 1078160552612450000, 1073047543751270000, 1068158308260090000, 1063485032746130000,
422     1059020416916920000, 1054757637495480000, 1050690315445410000, 1046812486168130000, 1043118572374580000,
423     1039603359368500000, 1036261972508700000, 1033089856644290000, 1030082757340130000, 1027236703730050000,
424     1024547992853300000, 1022013175345570000, 1019629042369960000, 1017392613685540000, 1015301126762090000,
425     1013352026859850000, 1011542958001130000, 1009871754769190000, 1008336434876480000, 1006935192450680000,
426     1005666391992810000, 1004528562966940000, 1003520394985710000, 1002640733560210000, 1001888576386930000,
427     1001263070147930000, 1000763507804280000, 1000389326365660000, 1000140105122260000, 1000015564328210000];
428 
429     uint64[] ethToTokenB = [uint64(775429218219143000), 775671327829898000, 776127901211966000, 776773645353675000,
430     777586422946545000, 778546770812539000, 779637503568884000, 780843385369321000, 782150856410282000,
431     783547803792281000, 785023368533855000, 786567782228188000, 788172228141079000, 789828722568099000,
432     791530013068024000, 793269490820609000, 795041114858058000, 796839346320061000, 798659091204212000,
433     800495650343652000, 802344675554931000, 804202131071437000, 806064259518883000, 807927551805687000,
434     809788720397125000, 811644675521967000, 813492503926740000, 815329449848342000, 817152897922371000,
435     818960357783777000, 820749450149599000, 822517894201629000, 824263496110689000, 825984138564496000,
436     827677771178473000, 829342401683636000, 830976087798466000, 832576929702567000, 834143063039316000,
437     835672652382843000, 837163885111639000, 838614965637138000, 840024109940838000, 841389540378025000,
438     842709480710032000, 843982151330350000, 845205764652730000, 846378520631928000, 847498602389816000,
439     848564171921350000, 849573365856374000, 850524291254470000, 851415021411011000, 852243591653376000,
440     853007995106812000, 853706178409820000, 854336037359125000, 854895412464314000, 855382084392069000,
441     855793769279634000, 856128113896648000, 856382690633867000, 856554992296479000, 856642426678713000,
442     856642310895322000, 856551865444122000, 856368207972221000, 856088346716798000, 855709173589260000,
443     855227456869334000, 854639833473084000, 853942800755975000, 853132707808898000, 852205746201468000,
444     851157940122901000, 849985135866291000, 848682990597101000, 847246960341106000, 845672287120746000,
445     843953985161896000, 842086826085187000, 840065322987306000, 837883713307804000, 835535940365946000,
446     833015633439678000, 830316086244836000, 827430233656903000, 824350626499847000, 821069404206372000,
447     817578265131108000, 813868434272292000, 809930628128026000, 805755016379575000, 801331180055767000,
448     796648065788695000, 791693935720538000, 786456312563492000, 780921919248189000, 775076612519082000,
449     768905309746284000, 762391908120150000, 755519195274780000, 748268750246655000, 740620833510800000,
450     732554264644806000, 724046285945012000, 715072410052456000, 705606249330304000, 695619324359237000,
451     685080848469791000, 673957484695128000, 662213070884326000, 649808307940139000, 636700405205061000,
452     622842675875531000, 608184073925882000, 592668662306040000, 576235000056606000, 558815433353122000,
453     540335272206310000, 520711830420428000, 499853301200371000, 477657434169810000, 454009971072929000,
454     428782786477567000, 401831665549952000, 372993632284706000, 342083716845033000];
455 
456     uint64[] tokenToEthA = [uint64(704424178155537000), 713190762066846000, 721847189493791000, 730392123400529000,
457     738824243972042000, 747142248817992000, 755344853173881000, 763430790099493000, 771398810674579000,
458     779247684191759000, 786976198346613000, 794583159424929000, 802067392487080000, 809427741549495000,
459     816663069763215000, 823772259589481000, 830754212972345000, 837607851508273000, 844332116612708000,
460     850925969683577000, 857388392261710000, 863718386188143000, 869914973758293000, 875977197872967000,
461     881904122186196000, 887694831249856000, 893348430655064000, 898864047170326000, 904240828876413000,
462     909477945297944000, 914574587531659000, 919529968371354000, 924343322429479000, 929013906255348000,
463     933540998449971000, 937923899777483000, 942161933273140000, 946254444347881000, 950200800889437000,
464     954000393359958000, 957652634890164000, 961156961369993000, 964512831535722000, 967719727053578000,
465     970777152599792000, 973684635937107000, 976441727987718000, 979048002902630000, 981503058127442000,
466     983806514464515000, 985958016131545000, 987957230816517000, 989803849729030000, 991497587647993000,
467     993038182965679000, 994425397728130000, 995659017671913000, 996738852257213000, 997664734697262000,
468     998436521984103000, 999054094910676000, 999517358089229000, 999826239966055000, 999980692832543000];
469 
470     uint64[] tokenToEthB = [uint64(714156574852348000), 714265413504371000, 714480464730154000, 714798940623867000,
471     715218004285508000, 715734770689657000, 716346307566699000, 717049636296306000, 717841732812979000,
472     718719528523439000, 719679911235652000, 720719726099286000, 721835776557362000, 723024825308907000,
473     724283595282368000, 725608770619570000, 726996997669992000, 728444885995139000, 729949009382765000,
474     731505906870731000, 733112083780254000, 734764012758310000, 736458134828956000, 738190860453334000,
475     739958570598101000, 741757617812056000, 743584327310708000, 745434998068541000, 747305903918727000,
476     749193294660028000, 751093397170644000, 753002416528754000, 754916537139472000, 756831923867992000,
477     758744723178644000, 760651064279594000, 762547060272951000, 764428809309991000, 766292395751258000,
478     768133891331251000, 769949356327459000, 771734840733451000, 773486385435772000, 775200023394360000,
479     776871780826229000, 778497678392132000, 780073732385946000, 781595955926494000, 783060360151543000,
480     784462955413693000, 785799752477890000, 787066763720288000, 788260004328181000, 789375493500727000,
481     790409255650206000, 791357321603504000, 792215729803583000, 792980527510629000, 793647772002626000,
482     794213531775060000, 794673887739485000, 795024934420690000, 795262781152149000, 795383553269528000,
483     795383393301940000, 795258462160674000, 795004940325147000, 794619029025774000, 794096951423502000,
484     793434953785727000, 792629306658317000, 791676306033484000, 790572274513209000, 789313562467972000,
485     787896549190501000, 786317644044284000, 784573287606558000, 782659952805530000, 780574146051537000,
486     778312408361911000, 775871316479255000, 773247483982883000, 770437562393166000, 767438242268508000,
487     764246254294709000, 760858370366446000, 757271404660626000, 753482214701341000, 749487702416195000,
488     745284815183731000, 740870546871712000, 736241938866023000, 731396081089926000, 726330113013445000,
489     721041224652618000, 715526657558394000, 709783705794922000, 703809716907010000, 697602092876500000,
490     691158291067352000, 684475825159183000, 677552266069049000, 670385242861237000, 662972443644848000,
491     655311616458951000, 647400570145076000, 639237175206862000, 630819364656603000, 622145134848520000,
492     613212546298535000, 604019724490329000, 594564860667512000, 584846212611674000, 574862105406138000,
493     564610932185217000, 554091154868778000, 543301304881934000, 532239983859669000, 520905864336217000,
494     509297690419021000, 497414278447080000, 485254517633538000, 472817370692305000, 460101874448585000,
495     447107140433120000, 433832355459993000, 420276782187844000, 406439759664335000];
496 
497 
498     function xf(int256 tokens) private pure returns (int256){
499         return (tokens / 24500) % xe;
500     }
501 
502     function tokenToEth(int256 tokens) private view returns (int256) {
503 
504         uint64 inCircle = uint64(tokens);
505 
506         uint i = uint(inCircle / 12428106721627265);
507         uint256 ai;
508         if (i < 64) {
509             ai = tokenToEthA[i];
510         } else {
511             ai = tokenToEthA[127 - i];
512         }
513 
514         uint256 bi = tokenToEthB[i];
515         int256 ax = int256(ai * inCircle) / (1 ether);
516 
517         int256 result = int256(bi) - ax;
518         return result;
519 
520     }
521 
522 
523     function Dx(int256 ethPrev, uint256 ethIncome, int256 nPrev) private view returns (uint256){
524         int256 ethNew = ethPrev + int256(ethIncome);
525 
526         int256 first = xe * (intNcn(ethNew, nPrev) - intNcn(ethPrev, nPrev));
527         int256 second = ethToToken(cf(ethNew, nPrev));
528         int256 third = ethToToken(cf(ethPrev, nPrev));
529         int256 result = (first + second - third) * 24500 * 98 / 100;
530 
531         return uint256(result);
532     }
533 
534 
535     function calcN(int256 totalTokens, int256 totalEther) private view returns (int256){
536         int256 x24500 = totalTokens / 24500;
537 
538         int256 first = (x24500 / xe) * ce;
539         int256 second = tokenToEth(x24500 % xe);
540         int256 third = first - second - ca;
541         return totalEther * (1 ether) / (350 * third);
542     }
543 
544     function intNcn(int256 eth, int256 nPrev) private pure returns (int256) {
545         return (1 ether) * (eth / 350) / (nPrev * ce);
546     }
547 
548 
549     function cf(int256 eth, int256 nPrev) private pure returns (int256){
550         int256 mod350 = ((1 ether) * eth / 350) % (nPrev * ce);
551         return mod350 / nPrev;
552     }
553 
554     function ethToToken(int256 eth) private view returns (int256){
555 
556         uint256 inCircle = uint256(eth) % 1428285685708570000;
557 
558         uint i = uint(inCircle / 11158481919598203);
559 
560         int256 ai;
561         if (i < 64) {
562             ai = int256(ethToTokenA[i]);
563         } else {
564             ai = int256(ethToTokenA[127 - i]);
565         }
566 
567         int256 bi = int256(ethToTokenB[i]);
568 
569         return (ai * int256(inCircle)) / (1 ether) + bi;
570     }
571 
572 
573     function Dc(int256 tokensPrev, uint256 tokensIncome, int256 nPrev) private view
574     returns (int256){
575         int256 tokensNew = tokensPrev - int256(tokensIncome);
576         int256 first = (tokensNew / 24500) / xe;
577         int256 second = (tokensPrev / 24500) / xe;
578         int256 third = tokenToEth(xf(tokensNew));
579         int256 fourth = tokenToEth(xf(tokensPrev));
580 
581         int256 result = nPrev * 350 * ((first - second) * ce - third + fourth) * 98 / (- 100 ether);
582 
583         return result;
584 
585     }
586 
587 
588     function recalcValues() private {
589         x = int256(totalSupply());
590         c = int256(address(this).balance);
591         if (x == 0) {
592             n = 1000000000000000000;
593         } else {
594             n = calcN(x, c);
595         }
596 
597     }
598 
599     function() external payable {
600         require((msg.value == 0) || (msg.value >= 0.01 ether));
601         if(msg.value == 0){
602             sellAllTokens();
603         }else{
604             buy(msg.sender, msg.value, address(0x0));
605         }
606     }
607 
608     function buyTokens(address refer) public payable {
609         require(msg.value > 0.01 ether);
610         buy(msg.sender, msg.value, refer);
611     }
612 
613 
614     function buy(address investor, uint256 amount, address _refer) private {
615 
616         uint256 tokens = Dx(c, amount, n);
617         uint256 toDistribute = tokens / 50;
618         address refer = checkRefer(investor, _refer);
619         uint256 toRefer = calcToRefer(investor, amount, tokens);
620         uint256 distributed = distribute(investor, toDistribute);
621         if (toRefer > 0 && refer != address(0x0)) {
622             _mint(refer, toRefer);
623             emit ReferalBonus(investor, refer, toRefer);
624         }
625         uint256 total = tokens - distributed - toRefer;
626         _mint(msg.sender, total);
627         emit Buy(msg.sender, total, amount);
628         recalcValues();
629     }
630 
631     function sellAllTokens() public {
632         transfer(address(this), balanceOf(msg.sender));
633     }
634 
635     function sellTokens(address payable from, uint256 value) internal {
636         uint256 ethers = address(this).balance;
637         if (int256(value) < x) {
638             ethers = uint256(Dc(x, value, n));
639         }
640         _burn(address(this), value);
641         from.transfer(ethers);
642         emit Sell(from, value, ethers);
643         changeSBalance(from, int256(ethers) * (- 1));
644         recalcValues();
645     }
646 
647     function calcEther(uint256 value) public view returns (uint256) {
648         uint256 ethers = address(this).balance;
649         if (int256(value) < x) {
650             ethers = uint256(Dc(x, value, n));
651         }
652         return ethers;
653     }
654 
655     function calcTokens(uint256 amount) public view returns (uint256 tokens,
656         uint256 toDistribute, uint256 toRefer, uint256 total) {
657         uint256 _tokens = Dx(c, amount, n);
658         uint256 _toDistribute = _tokens / 50;
659         uint256 _toRefer;
660         int256 thisSBalance = SBalance[msg.sender] + int256(amount);
661 
662         if (thisSBalance <= 0) {
663             _toRefer = 0;
664         } else if (thisSBalance >= int256(amount)) {
665             _toRefer = _tokens / 20;
666         } else {
667             _toRefer = (uint256(thisSBalance) * _tokens / amount) / 20;
668         }
669 
670         return (_tokens, _toDistribute, _toRefer, _tokens - _toDistribute - _toRefer);
671     }
672 
673 }
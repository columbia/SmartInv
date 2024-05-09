1 pragma solidity 0.4.24;
2 
3 library SafeMathExt{
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function pow(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (b == 0){
15       return 1;
16     }
17     if (b == 1){
18       return a;
19     }
20     uint256 c = a;
21     for(uint i = 1; i<b; i++){
22       c = mul(c, a);
23     }
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function roundUp(uint256 a, uint256 b) public pure returns(uint256){
46     // ((a + b - 1) / b) * b
47     uint256 c = (mul(div(sub(add(a, b), 1), b), b));
48     return c;
49   }
50 }
51 
52 library PureAmber{
53     /*==============================
54     =             BUY              =
55     ==============================*/
56     function isValidBuy(uint256 price_, uint256 msgValue_) public pure returns(bool){
57         return (price_ == msgValue_);
58     }
59     function refererAllowed(address msgSender_, address currentReferer_, address newReferer_) public pure returns(bool){
60         return (addressNotSet(currentReferer_) && isAddress(newReferer_) && isNotSelf(msgSender_, newReferer_));
61     }
62     function addressNotSet(address address_) public pure returns(bool){
63         return (address_ == 0x0);
64     }
65     function isAddress(address address_) public pure returns(bool){
66         return (address_ != 0x0);
67     }
68     function isNotSelf(address msgSender_, address compare_) public pure returns(bool){
69         return (msgSender_ != compare_);
70     }
71 
72     /*==============================
73     =         BADGE SYSTEM         =
74     ==============================*/
75     function isFirstBadgeEle(uint256 badgeID_) public pure returns(bool){
76         return (badgeID_ == 0);
77     }
78     function isLastBadgeEle(uint256 badgeID_, uint256 badgeLength_) public pure returns(bool){
79         assert(badgeID_ <= SafeMathExt.sub(badgeLength_, 1));
80         return (badgeID_ == SafeMathExt.sub(badgeLength_, 1));
81     }
82 
83     function roundUp(uint256 input_, uint256 decimals_) public pure returns(uint256){
84         return ((input_ + decimals_ - 1) / decimals_) * decimals_;
85     }
86 
87     /*==============================
88     =          DIVI SPLIT          =
89     ==============================*/   
90     function calcShare(uint256 msgValue_, uint256 ratio_) public pure returns(uint256){
91         assert(ratio_ <= 100 && msgValue_ >= 0);
92         return SafeMathExt.div((SafeMathExt.mul(msgValue_, ratio_)), 100);
93     }
94     function calcDiviDistribution(uint256 value_, uint256 userCount_) public pure returns(uint256){
95         assert(value_ >= 0);
96         return SafeMathExt.div(value_, userCount_);
97     }
98 }
99 
100 contract BadgeFactoryInterface{
101 	function _initBadges(address admin_, uint256 badgeBasePrice_, uint256 badgeStartMultiplier_, uint256 badgeStartQuantity_) external;
102 	function _createNewBadge(address owner_, uint256 price_) external;
103 	function _setOwner(uint256 badgeID_, address owner_) external;
104 	function getOwner(uint256 badgeID_) public view returns(address);
105 	function _increasePrice(uint256 badgeID_) external;
106 	function getPrice(uint256 badgeID_) public view returns(uint256);
107 	function _increaseTotalDivis(uint256 badgeID_, uint256 divis_) external;
108 	function getTotalDivis(uint256 badgeID_) public view returns(uint256);
109 	function _setBuyTime(uint256 badgeID_, uint32 timeStamp_) external;
110 	function getBuyTime(uint256 badgeID_) public view returns(uint32);
111 	function getCreationTime(uint256 badgeID_) public view returns(uint32);
112 	function getChainLength() public view returns(uint256);
113 }
114 
115 contract TeamAmberInterface{
116     function distribute() public payable;
117 }
118 
119 contract Amber{
120 	using SafeMathExt for uint256;
121     /*===============================================================================
122     =                      DATA SET                     DATA SET                    =
123     ===============================================================================*/
124     /*==============================
125     =          INTERFACES          =
126     ==============================*/
127     BadgeFactoryInterface internal _badgeFactory;
128     TeamAmberInterface internal _teamAmber;
129 
130     /*==============================
131     =          CONSTANTS           =
132     ==============================*/
133     uint256 internal constant FINNEY = 10**15;
134     uint256 internal constant _sharePreviousOwnerRatio = 50;
135     uint256 internal constant _shareReferalRatio = 5;
136     uint256 internal constant _shareDistributionRatio = 45;
137 
138     /*==============================
139     =          VARIABLES           =
140     ==============================*/
141     address internal _contractOwner;
142     address internal _admin;
143     uint256 internal _badgeBasePrice;
144     uint256 internal _startTime;
145 
146     /*==============================
147     =        USER MAPPINGS         =
148     ==============================*/
149     mapping(address => uint256) private _balanceDivis;
150     mapping(address => address) private _referer;
151 
152     /*==============================
153     =            EVENTS            =
154     ==============================*/
155     event onContractStart(uint256 startTime_);
156     event onRefererSet(address indexed user_, address indexed referer_);
157     event onBadgeBuy(uint256 indexed badgeID_, address indexed previousOwner_, address indexed buyer_, uint256 price_, uint256 newPrice_);
158     event onWithdraw(address indexed receiver_, uint256 amount_);
159 
160     /*==============================
161     =          MODIFIERS           =
162     ==============================*/
163     modifier onlyContractOwner(){
164     	require(msg.sender == _contractOwner, 'Sender is not the contract owner.');
165     	_;
166     }
167     modifier isNotAContract(){
168         require (msg.sender == tx.origin, 'Contracts are not allowed to interact.');
169         _;
170     }
171     modifier isRunning(){
172     	require(_startTime != 0 && _startTime <= now, 'The contract is not running yet.');
173     	_;
174     }
175 
176     /*===============================================================================
177     =                       FUNCTIONS                       FUNCTIONS               =
178     ===============================================================================*/
179     /*==============================
180     =           OWNER ONLY         =
181     ==============================*/
182     constructor(address admin_, address teamAmberAddress_) public{
183     	_contractOwner = msg.sender;
184         _admin = admin_;
185         _teamAmber = TeamAmberInterface(teamAmberAddress_);
186     }
187 
188     function initGame(address badgesFactoryAddress_, uint256 badgeBasePrice_, uint256 badgeStartMultiplier_, uint256 badgeStartQuantity_) external onlyContractOwner{
189         require(_badgeBasePrice == 0);
190 
191         _badgeBasePrice = badgeBasePrice_;
192         _badgeFactory = BadgeFactoryInterface(badgesFactoryAddress_);
193         _badgeFactory._initBadges(_admin, badgeBasePrice_, badgeStartMultiplier_, badgeStartQuantity_);
194     }
195 
196     function _startContract(uint256 delay_) external onlyContractOwner{
197     	require(_startTime == 0);
198         _startTime = now + delay_;
199 
200         emit onContractStart(_startTime);
201     }
202 
203     /*==============================
204     =             BUY              =
205     ==============================*/
206     //Hex Data: 0x7deb6025
207     function buy(uint256 badgeID_, address newReferer_) public payable isNotAContract isRunning{
208     	_refererUpdate(msg.sender, newReferer_);
209     	_buy(badgeID_, msg.sender, msg.value);
210     }
211 
212     function _buy(uint256 badgeID_, address msgSender_, uint256 msgValue_) internal{
213         address previousOwner = _badgeFactory.getOwner(badgeID_);
214         require(PureAmber.isNotSelf(msgSender_, _badgeFactory.getOwner(badgeID_)), 'You can not buy from yourself.');
215         require(PureAmber.isValidBuy(_badgeFactory.getPrice(badgeID_), msgValue_), 'It is not a valid buy.');        
216 
217         _diviSplit(badgeID_, previousOwner, msgSender_, msgValue_);
218         _extendBadges(badgeID_, msgSender_, _badgeBasePrice);
219         _badgeOwnerChange(badgeID_, msgSender_);
220         _badgeFactory._increasePrice(badgeID_);
221 
222         emit onBadgeBuy (badgeID_, previousOwner, msgSender_, msgValue_, _badgeFactory.getPrice(badgeID_));
223     }
224 
225     function _refererUpdate(address user_, address newReferer_) internal{
226     	if (PureAmber.refererAllowed(user_, _referer[user_], newReferer_)){
227     		_referer[user_] = newReferer_;
228     		emit onRefererSet(user_, newReferer_);
229     	}
230     }
231 
232     /*==============================
233     =         BADGE SYSTEM         =
234     ==============================*/
235     function _extendBadges(uint256 badgeID_, address owner_, uint256 price_) internal{
236         if (PureAmber.isLastBadgeEle(badgeID_, _badgeFactory.getChainLength())){
237             _badgeFactory._createNewBadge(owner_, price_);
238         }
239     }
240 
241     function _badgeOwnerChange(uint256 badgeID_, address newOwner_) internal{      
242         _badgeFactory._setOwner(badgeID_, newOwner_);
243         _badgeFactory._setBuyTime(badgeID_, uint32(now));
244     }
245 
246     /*==============================
247     =          DIVI SPLIT          =
248     ==============================*/
249     function _diviSplit(uint256 badgeID_, address previousOwner_, address msgSender_, uint256 msgValue_) internal{
250     	_shareToPreviousOwner(previousOwner_, msgValue_, _sharePreviousOwnerRatio);
251     	_shareToReferer(_referer[msgSender_], msgValue_, _shareReferalRatio);
252     	_shareToDistribution(badgeID_, previousOwner_, msgValue_, _shareDistributionRatio);
253     }
254 
255     function _shareToPreviousOwner(address previousOwner_, uint256 msgValue_, uint256 ratio_) internal{
256     	_increasePlayerDivis(previousOwner_, PureAmber.calcShare(msgValue_, ratio_));
257     }
258 
259     function _shareToReferer(address referer_, uint256 msgValue_, uint256 ratio_) internal{
260     	if (PureAmber.addressNotSet(referer_)){
261     		_increasePlayerDivis(_admin, PureAmber.calcShare(msgValue_, ratio_));
262     	} else {
263     		_increasePlayerDivis(referer_, PureAmber.calcShare(msgValue_, ratio_));
264     	}
265     }
266 
267     function _shareToDistribution(uint256 badgeID_, address previousOwner_, uint256 msgValue_, uint256 ratio_) internal{
268     	uint256 share = PureAmber.calcShare(msgValue_, ratio_);
269 
270     	if (PureAmber.isFirstBadgeEle(badgeID_)){
271     		_specialDistribution(previousOwner_, share);
272     	} else {
273     		_normalDistribution(badgeID_, PureAmber.calcDiviDistribution(share, badgeID_));
274     	}
275     }
276 
277     function _normalDistribution(uint256 badgeID_, uint256 divis_) internal{
278     	for(uint256 i = 0; i<badgeID_; i++){
279             _badgeFactory._increaseTotalDivis(i, divis_);
280             _increasePlayerDivis(_badgeFactory.getOwner(i), divis_);
281         }
282     }
283 
284     function _specialDistribution(address previousOwner_, uint256 divis_) internal{
285         _badgeFactory._increaseTotalDivis(0, divis_);
286         _increasePlayerDivis(previousOwner_, divis_);
287     }
288 
289     function _increasePlayerDivis(address user_, uint256 amount_) internal{
290         _balanceDivis[user_] = SafeMathExt.add(_balanceDivis[user_], amount_);
291     }
292 
293     /*==============================
294     =           WITHDRAW           =
295     ==============================*/
296     //Hex Data: 0x0ed86f04
297     function withdrawDivis() public isNotAContract{
298     	_withdrawDivis(msg.sender);
299     }
300 
301     function _withdrawDivis(address msgSender_) internal{
302     	require (_balanceDivis[msgSender_] >= 0, 'Hack attempt: Sender does not have enough Divis to withdraw.');
303     	uint256 payout = _balanceDivis[msgSender_];
304         _resetBalanceDivis(msgSender_);
305         _transferDivis(msgSender_, payout);
306 
307         emit onWithdraw (msgSender_, payout);
308     }
309 
310     function _transferDivis(address msgSender_, uint256 payout_) internal{
311     	assert(address(this).balance >= payout_);
312     	if(msgSender_ == _admin){
313     		_teamAmber.distribute.value(payout_)();
314     	} else {
315     		msgSender_.transfer(payout_); 		
316     	}
317     }
318 
319     function _resetBalanceDivis(address user_) internal{
320     	_balanceDivis[user_] = 0;
321     }
322 
323     /*==============================
324     =            HELPERS           =
325     ==============================*/
326     function getStartTime() public view returns (uint256){
327         return _startTime;
328     }
329 
330     function getBalanceDivis(address user_) public view returns(uint256){
331     	return _balanceDivis[user_];
332     }
333 
334     function getReferer(address user_) public view returns(address){
335     	return _referer[user_];
336     }
337 
338     function getBalanceContract() public view returns(uint256){
339     	return address(this).balance;
340     }
341 
342     function getBadges() public view returns(address[], uint256[], uint256[], uint32[], uint32[]){
343     	uint256 length = _badgeFactory.getChainLength();
344     	address[] memory owner = new address[](length);
345     	uint256[] memory price = new uint256[](length);
346     	uint256[] memory totalDivis = new uint256[](length);
347     	uint32[] memory buyTime = new uint32[](length);
348         uint32[] memory creationTime = new uint32[](length);
349 
350         for (uint256 i = 0; i < length; i++) {
351            owner[i] = _badgeFactory.getOwner(i);
352            price[i] = _badgeFactory.getPrice(i);
353            totalDivis[i] = _badgeFactory.getTotalDivis(i);
354            buyTime[i] = _badgeFactory.getBuyTime(i);
355            creationTime[i] = _badgeFactory.getCreationTime(i);
356        }
357        return (owner, price, totalDivis, buyTime, creationTime);
358    }
359 }
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
52 contract BadgeFactoryInterface{
53 	function _initBadges(address admin_, uint256 badgeBasePrice_, uint256 badgeStartMultiplier_, uint256 badgeStartQuantity_) external;
54 	function _createNewBadge(address owner_, uint256 price_) external;
55 	function _setOwner(uint256 badgeID_, address owner_) external;
56 	function getOwner(uint256 badgeID_) public view returns(address);
57 	function _increasePrice(uint256 badgeID_) external;
58 	function getPrice(uint256 badgeID_) public view returns(uint256);
59 	function _increaseTotalDivis(uint256 badgeID_, uint256 divis_) external;
60 	function getTotalDivis(uint256 badgeID_) public view returns(uint256);
61 	function _setBuyTime(uint256 badgeID_, uint32 timeStamp_) external;
62 	function getBuyTime(uint256 badgeID_) public view returns(uint32);
63 	function getCreationTime(uint256 badgeID_) public view returns(uint32);
64 	function getChainLength() public view returns(uint256);
65 	function getRandomBadge(uint256 max_, uint256 i_) external view returns(uint256);
66     function getRandomFactor() external returns(uint256);
67 }
68 
69 contract TeamAmberInterface{
70     function distribute() public payable;
71 }
72 
73 contract Amber{
74 	using SafeMathExt for uint256;
75     /*===============================================================================
76     =                      DATA SET                     DATA SET                    =
77     ===============================================================================*/
78     /*==============================
79     =          INTERFACES          =
80     ==============================*/
81     BadgeFactoryInterface internal _badgeFactory;
82     TeamAmberInterface internal _teamAmber;
83 
84     /*==============================
85     =          CONSTANTS           =
86     ==============================*/
87     uint256 internal constant GWEI = 10**9;
88     uint256 internal constant FINNEY = 10**15;
89     uint256 internal constant ETH = 10**18;
90     uint256 internal constant _badgeBasePrice = 25 * FINNEY;
91     uint256 internal constant _luckyWinners = 5;
92     uint256 internal constant _sharePreviousOwnerRatio = 50;
93     uint256 internal constant _shareReferalRatio = 5;
94     uint256 internal constant _shareDistributionRatio = 45;
95 
96     /*==============================
97     =          VARIABLES           =
98     ==============================*/
99     address internal _contractOwner;
100     address internal _admin;
101     uint256 internal _startTime;
102     uint256 internal _initCounter;
103 
104     /*==============================
105     =            BADGES            =
106     ==============================*/
107     struct Badge{
108         address owner;
109         uint256 price;
110         uint256 totalDivis;
111     }
112 
113     Badge[] private badges;
114 
115     /*==============================
116     =        USER MAPPINGS         =
117     ==============================*/
118     mapping(address => uint256) private _splitProfit;
119     mapping(address => uint256) private _flipProfit;
120     mapping(address => uint256) private _waypointProfit;
121     mapping(address => address) private _referer;
122 
123     /*==============================
124     =            EVENTS            =
125     ==============================*/
126     event onContractStart(uint256 startTime_);
127     event onRefererSet(address indexed user_, address indexed referer_);
128     event onBadgeBuy(uint256 indexed badgeID_, address previousOwner_, address indexed buyer_, address indexed referer_, uint256 price_, uint256 newPrice_);
129     event onWithdraw(address indexed receiver_, uint256 splitProfit_, uint256 flipProfit_, uint256 waypointProfit_);
130 
131     /*==============================
132     =          MODIFIERS           =
133     ==============================*/
134     modifier onlyContractOwner(){
135     	require(msg.sender == _contractOwner, 'Sender is not the contract owner.');
136     	_;
137     }
138     modifier isNotAContract(){
139         require (msg.sender == tx.origin, 'Contracts are not allowed to interact.');
140         _;
141     }
142     modifier isRunning(){
143     	require(_startTime != 0 && _startTime <= now, 'The contract is not running yet.');
144     	_;
145     }
146 
147     /*===============================================================================
148     =                       PURE AMBER                       PURE AMBER             =
149     ===============================================================================*/
150     function isValidBuy(uint256 price_, uint256 msgValue_) public pure returns(bool){
151         return (price_ == msgValue_);
152     }
153 
154     function refererAllowed(address msgSender_, address currentReferer_, address newReferer_) public pure returns(bool){
155         return (addressNotSet(currentReferer_) && isAddress(newReferer_) && isNotSelf(msgSender_, newReferer_));
156     }
157 
158     function addressNotSet(address address_) public pure returns(bool){
159         return (address_ == 0x0);
160     }
161 
162     function isAddress(address address_) public pure returns(bool){
163         return (address_ != 0x0);
164     }
165 
166     function isNotSelf(address msgSender_, address compare_) public pure returns(bool){
167         return (msgSender_ != compare_);
168     }
169 
170     function isFirstBadgeEle(uint256 badgeID_) public pure returns(bool){
171         return (badgeID_ == 0);
172     }
173 
174     function isLastBadgeEle(uint256 badgeID_, uint256 badgeLength_) public pure returns(bool){
175         assert(badgeID_ <= SafeMathExt.sub(badgeLength_, 1));
176         return (badgeID_ == SafeMathExt.sub(badgeLength_, 1));
177     }
178 
179     function calcShare(uint256 msgValue_, uint256 ratio_) public pure returns(uint256){
180         assert(ratio_ <= 100 && msgValue_ >= 0);
181         return (msgValue_ * ratio_) / 100;
182     }
183 
184     /*===============================================================================
185     =                     BADGE FACTORY                     BADGE FACTORY           =
186     ===============================================================================*/
187     function _initBadges(address[] owner_, uint256[] price_, uint256[] totalDivis_) internal{
188         for (uint256 i = 0; i < owner_.length; i++) {
189             badges.push(Badge(owner_[i], price_[i], totalDivis_[i]));
190         }
191     }
192 
193     function _createNewBadge(address owner_, uint256 price_) internal{
194         badges.push(Badge(owner_, price_, 0));
195     }
196 
197     function _setOwner(uint256 badgeID_, address owner_) internal{
198         badges[badgeID_].owner = owner_;
199     }
200 
201     function getOwner(uint256 badgeID_) public view returns(address){
202         return badges[badgeID_].owner;
203     }
204 
205     function _increasePrice(uint256 badgeID_) internal{
206         uint256 newPrice = (badges[badgeID_].price * _badgeFactory.getRandomFactor()) / 100;
207         badges[badgeID_].price = SafeMathExt.roundUp(newPrice, 10000 * GWEI);
208     }
209 
210     function getPrice(uint256 badgeID_) public view returns(uint256){
211         return badges[badgeID_].price;
212     }
213 
214     function _increaseTotalDivis(uint256 badgeID_, uint256 divis_) internal{
215         badges[badgeID_].totalDivis += divis_;
216     }
217 
218     function getTotalDivis(uint256 badgeID_) public view returns(uint256){
219         return badges[badgeID_].totalDivis;
220     }
221 
222     function getChainLength() public view returns(uint256){
223         return badges.length;
224     }
225 
226     /*===============================================================================
227     =                       FUNCTIONS                       FUNCTIONS               =
228     ===============================================================================*/
229     /*==============================
230     =           OWNER ONLY         =
231     ==============================*/
232     constructor(address admin_, address teamAmberAddress_) public{
233     	_contractOwner = msg.sender;
234         _admin = admin_;
235         _teamAmber = TeamAmberInterface(teamAmberAddress_);
236     }
237 
238     function initGame(address badgesFactoryAddress_, address[] owner_, uint256[] price_, uint256[] totalDivis_) external onlyContractOwner{
239         require(_startTime == 0);
240         assert(owner_.length == price_.length && price_.length == totalDivis_.length);
241 
242         if(_badgeFactory == address(0x0)){
243             _badgeFactory = BadgeFactoryInterface(badgesFactoryAddress_);
244         }
245         _initBadges(owner_, price_, totalDivis_);
246     }
247 
248     function initReferrals(address[] refArray_) external onlyContractOwner{
249         require(_startTime == 0);
250         for (uint256 i = 0; i < refArray_.length; i+=2) {
251             _refererUpdate(refArray_[i], refArray_[i+1]);
252         }
253     }
254 
255     function _startContract(uint256 delay_) external onlyContractOwner{
256     	require(_startTime == 0);
257         _startTime = now + delay_;
258 
259         emit onContractStart(_startTime);
260     }
261 
262     /*==============================
263     =             BUY              =
264     ==============================*/
265     //Hex Data: 0x7deb6025
266     function buy(uint256 badgeID_, address newReferer_) public payable isNotAContract isRunning{
267     	_refererUpdate(msg.sender, newReferer_);
268     	_buy(badgeID_, newReferer_, msg.sender, msg.value);
269     }
270 
271     function _buy(uint256 badgeID_, address newReferer_, address msgSender_, uint256 msgValue_) internal{
272         address previousOwner = getOwner(badgeID_);
273         require(isNotSelf(msgSender_, getOwner(badgeID_)), 'You can not buy from yourself.');
274         require(isValidBuy(getPrice(badgeID_), msgValue_), 'It is not a valid buy.');        
275 
276         _diviSplit(badgeID_, previousOwner, msgSender_, msgValue_);
277         _extendBadges(badgeID_, msgSender_, _badgeBasePrice);
278         _badgeOwnerChange(badgeID_, msgSender_);
279         _increasePrice(badgeID_);
280 
281         emit onBadgeBuy(badgeID_, previousOwner, msgSender_, newReferer_, msgValue_, getPrice(badgeID_));
282     }
283 
284     function _refererUpdate(address user_, address newReferer_) internal{
285     	if (refererAllowed(user_, _referer[user_], newReferer_)){
286     		_referer[user_] = newReferer_;
287     		emit onRefererSet(user_, newReferer_);
288     	}
289     }
290 
291     /*==============================
292     =         BADGE SYSTEM         =
293     ==============================*/
294     function _extendBadges(uint256 badgeID_, address owner_, uint256 price_) internal{
295         if (isLastBadgeEle(badgeID_, getChainLength())){
296             _createNewBadge(owner_, price_);
297         }
298     }
299 
300     function _badgeOwnerChange(uint256 badgeID_, address newOwner_) internal{
301         _setOwner(badgeID_, newOwner_);
302     }
303 
304     /*==============================
305     =          DIVI SPLIT          =
306     ==============================*/
307     function _diviSplit(uint256 badgeID_, address previousOwner_, address msgSender_, uint256 msgValue_) internal{
308     	_shareToDistribution(badgeID_, msgValue_, _shareDistributionRatio);
309         _shareToPreviousOwner(previousOwner_, msgValue_, _sharePreviousOwnerRatio);
310     	_shareToReferer(_referer[msgSender_], msgValue_, _shareReferalRatio);
311     }
312 
313     function _shareToDistribution(uint256 badgeID_, uint256 msgValue_, uint256 ratio_) internal{
314         uint256 share = calcShare(msgValue_, ratio_) / _luckyWinners;
315         uint256 idx;
316 
317         for(uint256 i = 0; i < _luckyWinners; i++){
318             idx = _badgeFactory.getRandomBadge(badgeID_, i);
319             _increaseTotalDivis(idx, share);
320             _splitProfit[getOwner(idx)] += share;
321         }
322     }
323 
324     function _shareToPreviousOwner(address previousOwner_, uint256 msgValue_, uint256 ratio_) internal{
325     	_flipProfit[previousOwner_] += calcShare(msgValue_, ratio_);
326     }
327 
328     function _shareToReferer(address referer_, uint256 msgValue_, uint256 ratio_) internal{
329     	if (addressNotSet(referer_)){
330     		_waypointProfit[_admin] += calcShare(msgValue_, ratio_);
331     	} else {
332     		_waypointProfit[referer_] += calcShare(msgValue_, ratio_);
333     	}
334     }
335 
336     /*==============================
337     =           WITHDRAW           =
338     ==============================*/
339     //Hex Data: 0x853828b6
340     function withdrawAll() public isNotAContract{
341         uint256 splitProfit = _splitProfit[msg.sender];
342         _splitProfit[msg.sender] = 0;
343 
344         uint256 flipProfit = _flipProfit[msg.sender];
345         _flipProfit[msg.sender] = 0;
346 
347         uint256 waypointProfit = _waypointProfit[msg.sender];
348         _waypointProfit[msg.sender] = 0;
349 
350         _transferDivis(msg.sender, splitProfit + flipProfit + waypointProfit);
351         emit onWithdraw(msg.sender, splitProfit, flipProfit, waypointProfit);
352     }
353 
354     function _transferDivis(address msgSender_, uint256 payout_) internal{
355         assert(address(this).balance >= payout_);
356         if(msgSender_ == _admin){
357             _teamAmber.distribute.value(payout_)();
358         } else {
359             msgSender_.transfer(payout_);       
360         }
361     }
362 
363     /*==============================
364     =            HELPERS           =
365     ==============================*/
366     function getStartTime() public view returns (uint256){
367         return _startTime;
368     }
369 
370     function getSplitProfit(address user_) public view returns(uint256){
371         return _splitProfit[user_];
372     }
373 
374     function getFlipProfit(address user_) public view returns(uint256){
375         return _flipProfit[user_];
376     }
377 
378     function getWaypointProfit(address user_) public view returns(uint256){
379         return _waypointProfit[user_];
380     }
381 
382     function getReferer(address user_) public view returns(address){
383     	return _referer[user_];
384     }
385 
386     function getBalanceContract() public view returns(uint256){
387     	return address(this).balance;
388     }
389 
390     function getAllBadges() public view returns(address[], uint256[], uint256[]){
391         uint256 chainLength = getChainLength();
392         return (getBadges(0, chainLength-1));
393     }
394 
395     function getBadges(uint256 _from, uint256 _to) public view returns(address[], uint256[], uint256[]){
396         require(_from <= _to, 'Index FROM needs to be smaller or same than index TO');
397 
398         address[] memory owner = new address[](_to - _from + 1);
399         uint256[] memory price = new uint256[](_to - _from + 1);
400         uint256[] memory totalDivis = new uint256[](_to - _from + 1);
401 
402         for (uint256 i = _from; i <= _to; i++) {
403             owner[i - _from] = getOwner(i);
404             price[i - _from] = getPrice(i);
405             totalDivis[i - _from] = getTotalDivis(i);
406         }
407         return (owner, price, totalDivis);
408     }
409 }
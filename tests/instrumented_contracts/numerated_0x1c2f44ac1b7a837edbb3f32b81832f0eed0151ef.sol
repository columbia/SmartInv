1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4     //uint256
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33     
34     constructor() public {
35         owner = msg.sender;
36     }
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41     function transferOwnership(address newOwner) public onlyOwner {
42         require(newOwner != address(0));
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45     }
46 
47 }
48 
49 contract Manager is Ownable {
50     
51     address[] managers;
52 
53     modifier onlyManagers() {
54         bool exist = false;
55         uint index = 0;
56         (exist, index) = existManager(msg.sender);
57         if(owner == msg.sender)
58             exist = true;
59         require(exist);
60         _;
61     }
62     
63     function getManagers() public view returns (address[] memory){
64         return managers;
65     }
66     
67     function existManager(address _to) private returns (bool, uint) {
68         for (uint i = 0 ; i < managers.length; i++) {
69             if (managers[i] == _to) {
70                 return (true, i);
71             }
72         }
73         return (false, 0);
74     }
75     function addManager(address _to) onlyOwner public {
76         bool exist = false;
77         uint index = 0;
78         (exist, index) = existManager(_to);
79         
80         require(!exist);
81         
82         managers.push(_to);
83     }
84 
85 }
86 
87 contract Pausable is Manager {
88     event Pause();
89     event Unpause();
90 
91     bool public paused = false;
92 
93     modifier whenNotPaused() {
94         require(!paused);
95         _;
96     }
97 
98     modifier whenPaused() {
99         require(paused);
100         _;
101     }
102 
103     function pause() onlyManagers whenNotPaused public {
104         paused = true;
105         emit Pause();
106     }
107 
108     function unpause() onlyManagers whenPaused public {
109         paused = false;
110         emit Unpause();
111     }
112 }
113 
114 contract Withdrawable is Manager {
115     event PauseWithdraw();
116     event UnpauseWithdraw();
117 
118     bool withdrawable = true;
119 
120     function pauseWithdraw() onlyManagers public {
121         withdrawable = false;
122         emit PauseWithdraw();
123     }
124 
125     function unpauseWithdraw() onlyManagers public {
126         withdrawable = true;
127         emit UnpauseWithdraw();
128     }
129     
130     function isWithdrawable() public view returns (bool)  {
131         return withdrawable;
132     }
133 }
134 
135 interface ERC20 {
136     function transfer(address _to, uint256 _value) external;
137 }
138 
139 contract SaleRecord {
140     
141     using SafeMath for uint256;
142 
143     struct sProperty {
144         uint256 time;
145         uint256 inputEther;
146         uint256 outputToken;
147         uint256 priceToken;
148         bool withdraw;
149     }
150     
151     sProperty propertyTotal;
152 
153     mapping (address => sProperty[]) propertyMember;
154     address payable[] propertyKeys;
155     
156     function recordPropertyWithdraw(address _sender, uint256 _token) internal {
157         for(uint256 i = 0; i < propertyMember[_sender].length; i++){
158             if(propertyMember[_sender][i].withdraw == false && propertyMember[_sender][i].outputToken == _token){
159                 propertyMember[_sender][i].withdraw = true;
160                 break;
161             }
162         }
163     }
164     function recordProperty(address payable _sender, uint256 _amount, uint256 _token, uint256 _priceToken, bool _withdraw) internal {
165         
166         sProperty memory property = sProperty(now, _amount, _token, _priceToken, _withdraw);
167         propertyMember[_sender].push(property);
168         
169         propertyTotal.time = now;
170         propertyTotal.inputEther = propertyTotal.inputEther.add(_amount);
171         propertyTotal.outputToken = propertyTotal.outputToken.add(_token);
172         if (!contains(_sender)) {
173             propertyKeys.push(_sender);
174         }
175     }
176     function contains(address _addr) internal view returns (bool) {
177         uint256 len = propertyKeys.length;
178         for (uint256 i = 0 ; i < len; i++) {
179             if (propertyKeys[i] == _addr) {
180                 return true;
181             }
182         }
183         return false;
184     }
185     
186     //get
187     function getPropertyKeyCount() public view returns (uint){
188         return propertyKeys.length;
189     }
190     function getPropertyInfo(address _addr) public view returns (uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory, bool[] memory){
191         uint256[] memory time;
192         uint256[] memory inputEther;
193         uint256[] memory outputToken;
194         uint256[] memory priceToken;
195         bool[] memory withdraw;
196         
197         if(contains(_addr)){
198             
199             uint256 size = propertyMember[_addr].length;
200             
201             time = new uint256[](size);
202             inputEther = new uint256[](size);
203             outputToken = new uint256[](size);
204             priceToken = new uint256[](size);
205             withdraw = new bool[](size);
206             
207             for (uint i = 0 ; i < size ; i++) {
208                 time[i] = propertyMember[_addr][i].time;
209                 inputEther[i] = propertyMember[_addr][i].inputEther;
210                 outputToken[i] = propertyMember[_addr][i].outputToken;
211                 priceToken[i] = propertyMember[_addr][i].priceToken;
212                 withdraw[i] = propertyMember[_addr][i].withdraw;
213             }
214         } else {
215             time = new uint256[](0);
216             inputEther = new uint256[](0);
217             outputToken = new uint256[](0);
218             priceToken = new uint256[](0);
219             withdraw = new bool[](0);
220         }
221         return (time, inputEther, outputToken, priceToken, withdraw);
222         
223     }
224     function getPropertyValue(address _addr) public view returns (uint256, uint256){
225         uint256 inputEther = 0;
226         uint256 outputToken = 0;
227         
228         if(contains(_addr)){
229             
230             uint256 size = propertyMember[_addr].length;
231 
232             for (uint i = 0 ; i < size ; i++) {
233                 inputEther = inputEther.add(propertyMember[_addr][i].inputEther);
234                 outputToken = outputToken.add(propertyMember[_addr][i].outputToken);
235             }
236         } 
237         
238         return (inputEther, outputToken);
239         
240     }
241     
242     function getPropertyTotal() public view returns (uint256, uint256, uint256){
243         return (propertyTotal.time, propertyTotal.inputEther, propertyTotal.outputToken);
244     }
245     
246 }
247 
248 contract PageViewRecord is SaleRecord, Pausable {
249     
250     using SafeMath for uint256;
251     
252     uint16 itemCount = 100;
253     
254     function setPage(uint16 _itemCount) public onlyManagers {
255         itemCount = _itemCount;
256     }
257     
258     //get
259     function getPageValueCount() public view returns (uint256) {
260         uint256 userSize = propertyKeys.length;
261         uint256 pageCount = userSize.div(itemCount);
262         if((userSize.sub(pageCount.mul(itemCount))) > 0) {
263             pageCount++;
264         }
265         return pageCount;
266     }
267     function getPageItemValue(uint256 _pageIndex) public view returns (address[] memory, uint256[] memory, uint256[] memory){
268         require(getPageValueCount()> _pageIndex);
269         
270         uint256 startIndex =_pageIndex.mul(itemCount);
271         uint256 remain = propertyKeys.length - startIndex;
272         uint256 loopCount = (remain >= itemCount) ? itemCount : remain;
273         
274         address[] memory keys = new address[](loopCount);
275         uint256[] memory inputEther = new uint256[](loopCount);
276         uint256[] memory outputToken = new uint256[](loopCount);
277 
278         for (uint256 i = 0 ; i < loopCount ; i++) {
279             uint256 index = startIndex + i;
280             address key = propertyKeys[index];
281             keys[i] = key;
282             
283             uint256 size = propertyMember[keys[i]].length;
284             for (uint256 k = 0 ; k < size ; k++) {
285                 inputEther[i] = inputEther[i].add(propertyMember[key][k].inputEther);
286                 outputToken[i] = outputToken[i].add(propertyMember[key][k].outputToken);
287             }
288 
289         }
290         
291         return (keys, inputEther, outputToken);
292     }
293     
294     function getPageInfoCount() public view returns (uint256) {
295         uint256 infoSize = 0;
296         for (uint256 i = 0 ; i < propertyKeys.length ; i++) {
297             infoSize = infoSize.add(propertyMember[propertyKeys[i]].length);
298         }
299 
300         uint256 pageCount = infoSize.div(itemCount);
301         if((infoSize.sub(pageCount.mul(itemCount))) > 0) {
302             pageCount++;
303         }
304         return pageCount;
305     }
306     function getPageItemInfo(uint256 _pageIndex) public view returns (address[] memory, uint256[] memory, uint256[] memory, uint256[] memory){
307         require(getPageInfoCount()> _pageIndex);
308         
309         uint256 infoSize = 0;
310         for (uint256 i = 0 ; i < propertyKeys.length ; i++) {
311             infoSize = infoSize.add(propertyMember[propertyKeys[i]].length);
312         }
313         
314         uint256 startIndex =_pageIndex.mul(itemCount);
315         uint256 remain = infoSize - startIndex;
316         uint256 loopCount = (remain >= itemCount) ? itemCount : remain;
317         
318         address[] memory keys = new address[](loopCount);
319         uint256[] memory time = new uint256[](loopCount);
320         uint256[] memory inputEther = new uint256[](loopCount);
321         uint256[] memory outputToken = new uint256[](loopCount);
322         
323         uint256 loopIndex = 0;
324         uint256 index = 0;
325         for (uint256 i = 0 ; i < propertyKeys.length && loopIndex < loopCount; i++) {
326 
327             address key = propertyKeys[i];
328             
329             for (uint256 k = 0 ; k < propertyMember[key].length && loopIndex < loopCount ; k++) {
330                 if(index >=startIndex){
331                     keys[loopIndex] = key;
332                     time[loopIndex]        = propertyMember[key][k].time;
333                     inputEther[loopIndex]  = propertyMember[key][k].inputEther;
334                     outputToken[loopIndex] = propertyMember[key][k].outputToken;
335                     loopIndex++;
336                 } else {
337                     index++;
338                 }
339             }
340 
341         }
342         
343         return (keys, time, inputEther, outputToken);
344     }
345     
346     function getPageNotWithdrawCount() public view returns (uint256) {
347         uint256 infoSize = 0;
348         for (uint256 i = 0 ; i < propertyKeys.length ; i++) {
349             for (uint256 j = 0 ; j < propertyMember[propertyKeys[i]].length ; j++) {
350                 if(!propertyMember[propertyKeys[i]][j].withdraw)
351                     infoSize++;
352             }
353         }
354 
355         uint256 pageCount = infoSize.div(itemCount);
356         if((infoSize.sub(pageCount.mul(itemCount))) > 0) {
357             pageCount++;
358         }
359         return pageCount;
360     }
361     function getPageNotWithdrawInfo(uint256 _pageIndex) public view returns (address[] memory, uint256[] memory, uint256[] memory, uint256[] memory){
362         require(getPageInfoCount()> _pageIndex);
363         
364         uint256 infoSize = 0;
365         for (uint256 i = 0 ; i < propertyKeys.length ; i++) {
366             for (uint256 j = 0 ; j < propertyMember[propertyKeys[i]].length ; j++) {
367                 if(!propertyMember[propertyKeys[i]][j].withdraw)
368                     infoSize++;
369             }
370         }
371         
372         uint256 startIndex =_pageIndex.mul(itemCount);
373         uint256 remain = infoSize - startIndex;
374         uint256 loopCount = (remain >= itemCount) ? itemCount : remain;
375         
376         address[] memory keys = new address[](loopCount);
377         uint256[] memory time = new uint256[](loopCount);
378         uint256[] memory inputEther = new uint256[](loopCount);
379         uint256[] memory outputToken = new uint256[](loopCount);
380         
381         uint256 loopIndex = 0;
382         uint256 index = 0;
383         for (uint256 i = 0 ; i < propertyKeys.length && loopIndex < loopCount; i++) {
384 
385             address key = propertyKeys[i];
386             
387             for (uint256 k = 0 ; k < propertyMember[key].length && loopIndex < loopCount ; k++) {
388                 if(propertyMember[key][k].withdraw)
389                     continue;
390                 if(index >=startIndex){
391                     keys[loopIndex] = key;
392                     time[loopIndex]        = propertyMember[key][k].time;
393                     inputEther[loopIndex]  = propertyMember[key][k].inputEther;
394                     outputToken[loopIndex] = propertyMember[key][k].outputToken;
395                     loopIndex++;
396                 } else {
397                     index++;
398                 }
399             }
400 
401         }
402         
403         return (keys, time, inputEther, outputToken);
404     }
405 
406 }
407 
408 contract HenaSale is PageViewRecord, Withdrawable {
409     
410     using SafeMath for uint256;
411     
412     
413     //wallet(eth)
414     address payable walletETH;
415     
416     //token
417     address tokenAddress;
418     uint8 tokenDecimal = 18;
419     
420     uint256 oneEther = 1 * 10 ** uint(18);
421     uint256 oneToken = 1 * 10 ** uint(tokenDecimal);
422   
423     //price
424     //(usd decimal 5)
425     uint256[] priceTokenUSD;// = {15000, 16000, 17000, 18000};
426     uint256[] priceTokenSaleCount;// = {30000 * oneToken, 20000 * oneToken, 10000 * oneToken, 1000 * oneToken};
427     uint256 priceEthUSD;// 17111000
428     
429     //cap
430     uint256 capMaximumToken;
431 
432     //time
433     uint256 timeStart;
434     uint256 timeEnd;
435     
436 
437     
438     event TokenPurchase(address indexed sender, uint256 amount, bool withdraw);
439     event WithdrawalEther(address _sender, uint256 _weiEther);
440     event WithdrawalToken(address _sender, uint256 _weiToken);
441     
442     constructor(
443         
444         address _tokenAddress, 
445         
446         uint64[] memory _priceTokenUSD,
447         uint64[] memory _priceTokenSaleCount,
448         uint64 _priceEthUSD, 
449 
450         uint64 _capMaximumToken, 
451 
452         uint64 _timeEnd,  
453         address[] memory _managers
454         
455         ) public {
456         
457 
458         require(address(0) != _tokenAddress);
459         
460         require(_priceTokenUSD.length == _priceTokenSaleCount.length);
461         require(_priceEthUSD > 0);
462         
463         require(_capMaximumToken > 0);
464   
465         require(_timeEnd > 0);
466         
467         require(_managers.length > 0);
468           
469           
470         
471         walletETH = msg.sender;
472         
473         tokenAddress = _tokenAddress;
474         
475         priceTokenUSD = _priceTokenUSD;
476         
477      
478         for (uint256 i = 0 ; i < _priceTokenSaleCount.length; i++) {
479             require(_priceTokenSaleCount[i] < oneToken);
480             priceTokenSaleCount.push(uint256(_priceTokenSaleCount[i]).mul(oneToken));
481         }
482         priceEthUSD = _priceEthUSD;
483             
484         capMaximumToken = uint256(_capMaximumToken).mul(oneToken);
485 
486         timeStart = now;
487         timeEnd = _timeEnd;
488 
489         
490         for (uint256 i = 0 ; i < _managers.length; i++) {
491             require(address(0) != _managers[i]);
492             addManager(_managers[i]);
493         }
494  
495     }  
496      
497     
498     function validPurchase(address _sender, uint256 _amount, uint256 _token) internal {
499         require(_sender != address(0));
500         require(timeStart <= now && now <= timeEnd);
501         
502         uint256 recordTime;
503         uint256 recordETH;
504         uint256 recordTOKEN;
505         (recordTime, recordETH, recordTOKEN) = getPropertyTotal();
506 
507         require(capMaximumToken >= recordTOKEN.add(_token));
508     }
509     
510     function () external payable {
511         buyToken();
512     }
513 
514     function buyToken() public payable whenNotPaused {
515         address payable sender = msg.sender;
516         uint256 amount = msg.value;
517         uint256 priceToken;
518         uint256 countToken;
519         (priceToken, countToken) = getEthToToken(amount);
520         
521         require(priceToken > 0);
522 
523         validPurchase(sender, amount, countToken);
524             
525         bool isWithdrawable = isWithdrawable();
526         
527         recordProperty(sender, amount, countToken, priceToken, isWithdrawable);
528         
529         if(isWithdrawable) {
530             transferToken(sender, countToken);
531         }
532         
533         emit TokenPurchase(sender, countToken, isWithdrawable);   
534         
535     }
536 
537     function transferToken(address to, uint256 amount) internal {
538         ERC20(tokenAddress).transfer(to, amount);
539         emit WithdrawalToken(to, amount);
540     }
541     
542     function withdrawEther() onlyOwner public {
543         uint256 balanceETH = address(this).balance;
544         require(balanceETH > 0);
545         walletETH.transfer(balanceETH);
546         emit WithdrawalEther(msg.sender, balanceETH);
547     }
548     function withdrawToken(uint256 _amountToken) onlyOwner public {
549         transferToken(owner, _amountToken);
550     }
551 
552     function setTime(uint64 _timeEnd) onlyOwner public {
553         timeEnd = _timeEnd;
554     }
555     
556     function setPriceTokenEthUSD(uint64[] memory _priceTokenUSD, uint64[] memory _priceTokenSaleCount, uint64 _priceEthUSD) onlyManagers public {
557         require(_priceTokenUSD.length == _priceTokenSaleCount.length);
558 
559         while(priceTokenSaleCount.length > 0){
560             delete priceTokenSaleCount[priceTokenSaleCount.length - 1];
561             priceTokenSaleCount.length--;
562         }
563 
564         for (uint256 i = 0 ; i < _priceTokenSaleCount.length; i++) {
565             require(_priceTokenSaleCount[i] < oneToken);
566             priceTokenSaleCount.push(uint256(_priceTokenSaleCount[i]).mul(oneToken));
567         }
568         
569         priceTokenUSD = _priceTokenUSD;
570         priceEthUSD = _priceEthUSD;
571         
572     }    
573     
574     function setEthUSD(uint64 _priceEthUSD) onlyManagers public {
575         priceEthUSD = _priceEthUSD;
576     }    
577     
578     function setCapMaximumToken(uint256 _capMaximumToken) onlyManagers public {
579         require(_capMaximumToken > oneToken);
580         capMaximumToken = _capMaximumToken;
581     }
582 
583     function setWithdrawTokens(address[] memory _user, uint256[] memory _token) onlyManagers public {
584         require(_user.length == _token.length);
585         for(uint256 i = 0; i < _user.length; i++){
586             recordPropertyWithdraw(_user[i], _token[i]);
587         }
588     }
589 
590     function getRemainWithdrawEth() public view returns (uint256) {
591         uint256 balanceETH = address(this).balance;
592         return balanceETH;
593     }
594     
595     function getPriceTokenEthUSD() public view returns (uint256[] memory, uint256[] memory, uint256) {
596         return (priceTokenUSD, priceTokenSaleCount, priceEthUSD);
597     }
598     
599     function getCapToken() public view returns (uint256) {
600         return capMaximumToken;
601     }
602  
603     function getTokenToEth(uint256 amountToken) public view returns (uint256, uint256) {
604         for(uint256 i = 0; i < priceTokenSaleCount.length; i++){
605             if(priceTokenSaleCount[i] <= amountToken) {
606                 uint256 oneTokenEthValue = getOneTokenToEth(priceTokenUSD[i]);
607                 uint256 ethCount = amountToken.mul(oneTokenEthValue).div(oneToken);
608                 return (priceTokenUSD[i], ethCount);
609             }
610         }
611         return (0, 0);
612     }
613     function getEthToToken(uint256 amountEth) public view returns (uint256, uint256) {
614         for(uint256 i = 0; i < priceTokenUSD.length; i++){
615             uint256 oneTokenEthValue = getOneTokenToEth(priceTokenUSD[i]);
616             uint256 tokenCount = amountEth.mul(oneToken).div(oneTokenEthValue);
617             if(priceTokenSaleCount[i] <= tokenCount)
618                 return (priceTokenUSD[i], tokenCount);
619         }
620         return (0, 0);
621     }
622     function getOneTokenToEth(uint256 _priceUSD) public view returns (uint256) {
623        return _priceUSD.mul(oneEther).div(priceEthUSD); 
624     }
625 
626     
627     function getTokenInfo() public view returns (address, uint8) {
628         return (tokenAddress, tokenDecimal);
629     }
630     function getTimeICO() public view returns (uint256, uint256) {
631         return (timeStart, timeEnd);
632     }
633 
634 }
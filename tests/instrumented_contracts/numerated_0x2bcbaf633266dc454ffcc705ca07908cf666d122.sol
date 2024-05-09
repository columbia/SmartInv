1 pragma solidity ^0.4.24;
2 
3 contract I4D_Contract{
4     using SafeMath for uint256;
5     
6     ///////////////////////////////////////////////////////////////////////////////
7     // Attributes set.
8     string public name = "I4D";
9     uint256 public tokenPrice = 0.01 ether;
10     uint256 public mintax = 0.003 ether; // about 1 USD
11     uint16[3] public Gate = [10, 100, 1000];
12     uint8[4] public commissionRate = [1, 2, 3, 4];
13     uint256 public newPlayerFee=0.1 ether;
14     bytes32 internal SuperAdmin_id = 0x0eac2ad3c8c41367ba898b18b9f85aab3adac98f5dfc76fafe967280f62987b4;
15     
16     ///////////////////////////////////////////////////////////////////////////////
17     // Data stored.
18     uint256 internal administratorETH;
19     uint256 public totalTokenSupply;
20     uint256 internal DivsSeriesSum;
21     mapping(bytes32 => bool) public administrators;  // type of byte32, keccak256 of address
22     mapping(address=>uint256) public tokenBalance;
23     mapping(address=>address) public highlevel;
24     mapping(address=>address) public rightbrother;
25     mapping(address=>address) public leftchild;
26     mapping(address=>uint256) public deltaDivsSum;
27     mapping(address=>uint256) public commission;
28     mapping(address=>uint256) public withdrawETH;
29     
30 
31     constructor() public{
32         administrators[SuperAdmin_id] = true;
33         
34     }
35 
36 
37     ///////////////////////////////////////////////////////////////////////////////
38     // modifier and Events
39     modifier onlyAdmin(){
40         address _customerAddress = msg.sender;
41         require(administrators[keccak256(_customerAddress)]);
42         _;
43     }
44     modifier onlyTokenholders() {
45         require(tokenBalance[msg.sender] > 0);
46         _;
47     }
48     
49     event onEthSell(
50         address indexed customerAddress,
51         uint256 ethereumEarned
52     );
53     event onTokenPurchase(
54         address indexed customerAddress,
55         uint256 incomingEthereum,
56         uint256 tokensMinted,
57         address indexed referredBy
58     );
59     
60     event onReinvestment(
61         address indexed customerAddress,
62         uint256 ethereumReinvested,
63         uint256 tokensMinted
64     );
65     event testOutput(
66         uint256 ret
67     );
68     event taxOutput(
69         uint256 tax,
70         uint256 sumoftax
71     );
72     
73     
74     ///////////////////////////////////////////////////////////////////////////////
75     //Administrator api
76     function withdrawAdministratorETH(uint256 amount)
77         public
78         onlyAdmin()
79     {
80         address administrator = msg.sender;
81         require(amount<=administratorETH,"Too much");
82         administratorETH = administratorETH.sub(amount);
83         administrator.transfer(amount);
84     }
85     
86     function getAdministratorETH()
87         public
88         onlyAdmin()
89         view
90         returns(uint256)
91     {
92         return administratorETH;
93     }
94     
95     /** add Adimin here
96      * you can not change status of  super administrator.
97      */
98     function setAdministrator(bytes32 _identifier, bool _status)
99         onlyAdmin()
100         public
101     {
102         require(_identifier!=SuperAdmin_id);
103         administrators[_identifier] = _status;
104     }
105     
106     
107     function setName(string _name)
108         onlyAdmin()
109         public
110     {
111         name = _name;
112     }
113     
114     /////////////////////////////////////////////////////////////////////////////
115     function setTokenValue(uint256 _value)
116         onlyAdmin()
117         public
118     {
119         // we may increase our token price.
120         require(_value > tokenPrice);
121         tokenPrice = _value;
122     }
123     
124     ///////////////////////////////////////////////////////////////////////////////
125     // Player api.
126     
127     /** 
128      * api of buy tokens.
129      */
130     function buy(address _referredBy)
131         public
132         payable
133         returns(uint256)
134     {
135         PurchaseTokens(msg.value, _referredBy);
136     }
137     
138     /**
139      * reinvest your profits to puchase more tokens.
140      */
141     function reinvest(uint256 reinvestAmount)
142     onlyTokenholders()
143     public
144     {
145         require(reinvestAmount>=1,"At least 1 Token!");
146         address _customerAddress = msg.sender;
147         require(getReinvestableTokenAmount(_customerAddress)>=reinvestAmount,"You DO NOT have enough ETH!");
148         withdrawETH[_customerAddress] = withdrawETH[_customerAddress].add(reinvestAmount*tokenPrice);
149         uint256 tokens = PurchaseTokens(reinvestAmount.mul(tokenPrice), highlevel[_customerAddress]);
150         
151         ///////////////////
152         emit onReinvestment(_customerAddress,tokens*tokenPrice,tokens);
153     }
154     
155     /**
156      * withdraw the profits(include commissions and divs).
157      */
158     function withdraw(uint256 _amountOfEths)
159     public
160     onlyTokenholders()
161     {
162         address _customerAddress=msg.sender;
163         uint256 eth_all = getWithdrawableETH(_customerAddress);
164         require(eth_all >= _amountOfEths);
165         withdrawETH[_customerAddress] = withdrawETH[_customerAddress].add(_amountOfEths);
166         _customerAddress.transfer(_amountOfEths);
167         emit onEthSell(_customerAddress,_amountOfEths);
168         
169         //sell logic here
170     }
171     
172     // some view functions to get your information.
173     function getMaxLevel(address _customerAddress, uint16 cur_level)
174     public
175     view
176     returns(uint32)
177     {
178         address children = leftchild[_customerAddress];
179         uint32 maxlvl = cur_level;
180         while(children!=0x0000000000000000000000000000000000000000){
181             uint32 child_lvl = getMaxLevel(children, cur_level+1);
182             if(maxlvl < child_lvl){
183                 maxlvl = child_lvl;
184             }
185             children = rightbrother[children];
186         }
187         return maxlvl;
188     }
189     
190     function getTotalNodeCount(address _customerAddress)
191     public
192     view
193     returns(uint32)
194     {
195         uint32 ctr=1;
196         address children = leftchild[_customerAddress];
197         while(children!=0x0000000000000000000000000000000000000000){
198             ctr += getTotalNodeCount(children);
199             children = rightbrother[children];
200         }
201         return ctr;
202     }
203     
204     function getMaxProfitAndtoken(address[] playerList)
205     public
206     view
207     returns(uint256[],uint256[],address[])
208     {
209         uint256 len=playerList.length;
210         uint256 i;
211         uint256 Profit;
212         uint256 token;
213         address hl;
214         uint[] memory ProfitList=new uint[](len);
215         uint[] memory tokenList=new uint[](len);
216         address[] memory highlevelList=new address[](len);
217         for(i=0;i<len;i++)
218         {
219             Profit=getTotalProfit(playerList[i]);
220             token=tokenBalance[playerList[i]];
221             hl=highlevel[playerList[i]];
222             ProfitList[i]=Profit;
223             tokenList[i]=token;
224             highlevelList[i]=hl;
225         }
226         return (ProfitList,tokenList,highlevelList);
227     }
228     function getReinvestableTokenAmount(address _customerAddress)
229     public
230     view
231     returns(uint256)
232     {
233         return getWithdrawableETH(_customerAddress).div(tokenPrice);
234     }
235     
236     /**
237      * Total profit = your withdrawable ETH + ETHs you have withdrew.
238      */
239     function getTotalProfit(address _customerAddress)
240     public
241     view
242     returns(uint256)
243     {
244         return commission[_customerAddress].add(DivsSeriesSum.sub(deltaDivsSum[_customerAddress]).mul(tokenBalance[_customerAddress])/10*3);
245     }
246     
247     function getWithdrawableETH(address _customerAddress)
248     public
249     view
250     returns(uint256)
251     {
252         uint256 divs = DivsSeriesSum.sub(deltaDivsSum[_customerAddress]).mul(tokenBalance[_customerAddress])/10*3;
253         return commission[_customerAddress].add(divs).sub(withdrawETH[_customerAddress]);
254     }
255     
256     function getTokenBalance()
257     public
258     view
259     returns(uint256)
260     {
261     address _address = msg.sender;
262     return tokenBalance[_address];
263     }
264     
265     function getContractBalance()public view returns (uint) {
266         return address(this).balance;
267     }  
268     
269     /**
270      * get your commission rate by your token held.
271      */
272     function getCommissionRate(address _customerAddress)
273     public
274     view
275     returns(uint8)
276     {
277         if(tokenBalance[_customerAddress]<1){
278             return 0;
279         }
280         uint8 i;
281         for(i=0; i<Gate.length; i++){
282             if(tokenBalance[_customerAddress]<Gate[i]){
283                 break;
284             }
285         }
286         return commissionRate[i];
287     }
288     
289     
290     ///////////////////////////////////////////////////////////////////////////////
291     // functions to calculate commissions and divs when someone purchase some tokens.
292     
293     /**
294      * api for buying tokens.
295      */
296     function PurchaseTokens(uint256 _incomingEthereum, address _referredBy)
297         internal
298         returns(uint256)
299     {   
300         /////////////////////////////////
301         address _customerAddress=msg.sender;
302         uint256 numOfToken;
303         require(_referredBy==0x0000000000000000000000000000000000000000 || tokenBalance[_referredBy] > 0);
304         if(tokenBalance[_customerAddress] > 0)
305         {
306             require(_incomingEthereum >= tokenPrice,"ETH is NOT enough");
307             require(_incomingEthereum % tokenPrice ==0);
308             require(highlevel[_customerAddress] == _referredBy);
309             numOfToken = ETH2Tokens(_incomingEthereum);
310         }
311         else
312         {
313             //New player without a inviter will be taxed for newPlayerFee, and this value can be changed by administrator
314             if(_referredBy==0x0000000000000000000000000000000000000000 || _referredBy==_customerAddress)
315             {
316                 require(_incomingEthereum >= newPlayerFee+tokenPrice,"ETH is NOT enough");
317                 require((_incomingEthereum-newPlayerFee) % tokenPrice ==0);
318                 _incomingEthereum -= newPlayerFee;
319                 numOfToken = ETH2Tokens(_incomingEthereum);
320                 highlevel[_customerAddress] = 0x0000000000000000000000000000000000000000;
321                 administratorETH = administratorETH.add(newPlayerFee);
322             }
323             else
324             {
325                 // new player with invite address.
326                 require(_incomingEthereum >= tokenPrice,"ETH is NOT enough");
327                 require(_incomingEthereum % tokenPrice ==0);
328                 numOfToken = ETH2Tokens(_incomingEthereum);
329                 highlevel[_customerAddress] = _referredBy;
330                 addMember(_referredBy,_customerAddress);
331             }
332             commission[_customerAddress] = 0;
333         }
334         calDivs(_customerAddress,numOfToken);
335         calCommission(_incomingEthereum,_customerAddress);
336         emit onTokenPurchase(_customerAddress,_incomingEthereum,numOfToken,_referredBy); 
337         return numOfToken;
338         
339     }
340     
341     /**
342      * Calculate the dividends of the members hold tokens.
343      * There are two methods to calculate the dividends.
344      * We chose the second method for you that you can get more divs.
345      */
346     function calDivs(address customer,uint256 num)
347     internal
348     {
349         // Approach 1.
350         // Use harmonic series to cal player divs. This is a precise algorithm.
351         // Approach 2.
352         // Simplify the "for loop" of approach 1.
353         // You can get more divs than approach 1 when you buy more than 1 token at one time.
354         // cal average to avoid overflow.
355         uint256 average_before = deltaDivsSum[customer].mul(tokenBalance[customer]) / tokenBalance[customer].add(num);
356         uint256 average_delta = DivsSeriesSum.mul(num) / (num + tokenBalance[customer]);
357         deltaDivsSum[customer] = average_before.add(average_delta);
358         DivsSeriesSum = DivsSeriesSum.add(tokenPrice.mul(num) / totalTokenSupply.add(num));
359         totalTokenSupply += num;
360         tokenBalance[customer] = num.add(tokenBalance[customer]);
361     }
362     
363     /**
364      * Calculate the commissions of your inviters.
365      */
366     function calCommission(uint256 _incomingEthereum,address _customerAddress)
367         internal 
368         returns(uint256)
369     {
370         address _highlevel=highlevel[_customerAddress];
371         uint256 tax;
372         uint256 sumOftax=0;
373         uint8 i=0;
374         uint256 tax_chain=_incomingEthereum;
375         uint256 globalfee = _incomingEthereum.mul(3).div(10);
376         // The maximum deepth of tree you can get commission is 14. You can never get any eth from your children of more than 15 lvl.
377         for(i=1; i<=14; i++)
378         {
379             if(_highlevel==0x0000000000000000000000000000000000000000 || tokenBalance[_highlevel]==0){
380                 break;
381             }
382             uint8 com_rate = getCommissionRate(_highlevel);
383             tax_chain = tax_chain.mul(com_rate).div(10);
384             if(tokenBalance[_highlevel]>=Gate[2]){
385                 tax=mul_float_power(_incomingEthereum, i, com_rate, 10);
386             }
387             else{
388                 tax=tax_chain;
389             }
390 
391             // The minimum deepth of tree you can get commission is 2.
392             // If the deepth is higher than 2 and the tax is lower than mintax, you can never get any commission.
393             if(i>2 && tax <= mintax){
394                 break;
395             }
396             commission[_highlevel] = commission[_highlevel].add(tax);
397             sumOftax = sumOftax.add(tax);
398             _highlevel = highlevel[_highlevel];
399             emit taxOutput(tax,sumOftax);
400         }
401         
402         if(sumOftax.add(globalfee) < _incomingEthereum)
403         {
404             administratorETH = _incomingEthereum.sub(sumOftax).sub(globalfee).add(administratorETH);
405         }
406         
407     }
408     
409     /**
410      * New player with inviter should add member to the group tree.
411      */
412     function addMember(address _referredBy,address _customer)
413     internal
414     {
415         require(tokenBalance[_referredBy] > 0);
416         if(leftchild[_referredBy]!=0x0000000000000000000000000000000000000000)
417         {
418             rightbrother[_customer] = leftchild[_referredBy];
419         }
420         leftchild[_referredBy] = _customer;
421     }
422     
423     function ETH2Tokens(uint256 _ethereum)
424         internal
425         view
426         returns(uint256)
427     {
428         return _ethereum.div(tokenPrice);
429     }
430     
431     function Tokens2ETH(uint256 _tokens)
432         internal
433         view
434         returns(uint256)
435     {
436         return _tokens.mul(tokenPrice);
437     }
438     
439     /**
440      * Calculate x  *  (numerator / denominator) ** n
441      * Use "For Loop" to avoid overflow.
442      */
443     function mul_float_power(uint256 x, uint8 n, uint8 numerator, uint8 denominator)
444         internal
445         pure
446         returns(uint256)
447     {
448         uint256 ret = x;
449         if(x==0 || numerator==0){
450             return 0;
451         }
452         for(uint8 i=0; i<n; i++){
453             ret = ret.mul(numerator).div(denominator);
454         }
455         return ret;
456 
457     }
458 }
459 /**
460  * @title SafeMath
461  * @dev Math operations with safety checks that throw on error
462  */
463 library SafeMath {
464 
465     /**
466     * @dev Multiplies two numbers, throws on overflow.
467     */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         if (a == 0) {
470             return 0;
471         }
472         uint256 c = a * b;
473         assert(c / a == b);
474         return c;
475     }
476 
477     /**
478     * @dev Integer division of two numbers, truncating the quotient.
479     */
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         // assert(b > 0); // Solidity automatically throws when dividing by 0
482         uint256 c = a / b;
483         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
484         return c;
485     }
486 
487     /**
488     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
489     */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         assert(b <= a);
492         return a - b;
493     }
494 
495     /**
496     * @dev Adds two numbers, throws on overflow.
497     */
498     function add(uint256 a, uint256 b) internal pure returns (uint256) {
499         uint256 c = a + b;
500         assert(c >= a);
501         return c;
502     }
503 }
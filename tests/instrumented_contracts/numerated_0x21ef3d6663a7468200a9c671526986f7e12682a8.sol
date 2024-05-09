1 /**
2  * @title smart real estate platform implementation
3  * @author Maxim Akimov - <devstylesoftware@gmail.com>
4  */
5 
6 pragma solidity ^0.4.24;
7 
8 
9 library SafeMath {
10     
11 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12 		uint256 c = a * b;
13 		assert(a == 0 || c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34   
35 }
36 
37 contract Ownable {
38     
39 	address public owner;
40 	address public ownerCandidat;
41 
42 	/**
43 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
44 	* account.
45 	*/
46 	 constructor() public{
47 		owner = msg.sender;
48 		
49 	}
50 
51 	/**
52 	* @dev Throws if called by any account other than the owner.
53 	*/
54 	modifier onlyOwner() {
55 		require(msg.sender == owner);
56 		_;
57 	}
58 
59 	/**
60 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
61 	* @param newOwner The address to transfer ownership to.
62 	*/
63 	function  transferOwnership(address newOwner) onlyOwner  public{
64 		require(newOwner != address(0));      
65 		ownerCandidat = newOwner;
66 	}
67 	/**
68 	* @dev Allows safe change current owner to a newOwner.
69 	*/
70 	function confirmOwnership() public{
71 		require(msg.sender == ownerCandidat);      
72 		owner = msg.sender;
73 	}
74 
75 }
76 
77 /*
78   пока не забыл -  контаркту "хранилице" нужно сделать несоклько владельцев
79   что б можно было основной контаркт с бищнес логикой новый выпускать 
80   (дажеесли в старом еще есть незакрытые сделки)
81 */
82 contract realestate is Ownable{
83     
84    using SafeMath for uint;
85      
86     enum statuses {
87         created,canceled,signed,finished
88     }
89     
90     struct _sdeal{
91     
92     address buyer;
93     address seller;
94     address signer;
95    // address agency;
96     uint sum; 
97     uint fee;
98     
99     address signBuyer;
100     address signSeller;
101    // address signAgency;
102     uint atCreated;
103     uint atClosed;
104     
105     uint balance;
106     
107     statuses status;
108     uint dealNumber;
109     
110     string comment;
111     uint objectType; // 0 - old 1 - new
112 }
113 
114 struct _sSigns{
115     
116    address finishSignBuyer;
117    address finishSignSeller;
118    address finishSignSigner;
119 }
120 
121    event MoneyTransfer(
122         address indexed _from,
123         address indexed _to,
124         uint _value
125     );
126  
127    //Need to change to private
128    
129  //uint public feePercent; // нуно ли менять в процессе? 
130  address public agencyOwner;
131  address public agencyReceiver;
132 
133  _sdeal[] public deals;
134 _sSigns[] public signs;
135  
136    
137    // **************** modifiers **************** //
138    
139     modifier onlyAgency(){
140         require(msg.sender == agencyOwner);
141         _;
142     }
143     
144    /* modifier onlyDealMembers(uint _dealNumber){
145         
146         uint deal = dealNumbers[_dealNumber];
147           require(msg.sender == deals[deal].buyer|| msg.sender == deals[deal].seller 
148         || msg.sender == deals[deal].agency || msg.sender == deals[deal].signer);
149         
150         _;
151     }*/
152     
153     modifier onlySigner(uint _dealNumber){
154         
155         uint deal = dealNumbers[_dealNumber];
156         require(msg.sender == deals[deal].signer);
157         _;
158     }
159     /*
160     TODO
161     сделать модификатор для всех ктоучавствует в сделки
162     */
163     
164     constructor() public{
165         
166         //feePercent = 3;// need??
167         agencyOwner = msg.sender;
168         agencyReceiver = msg.sender;
169     }
170      
171     function changeAgencyOwner(address newAgency) public {
172             require(msg.sender == agencyOwner || msg.sender == owner);
173          agencyOwner = newAgency;
174          
175      }
176      function changeAgencyReceiver (address _agencyReceiver) public{
177          
178          require(msg.sender == agencyOwner || msg.sender == owner);
179          agencyReceiver = _agencyReceiver;
180      }
181      
182      //как много раз можно изменть ??
183    /* function changeDealDate(uint _deal, uint _date) onlyAgency public{
184          require(deals[_deal].isProlong);
185          deals[_deal].date = _date;
186     }*/
187 
188     function getSigns(uint _dealNumber) constant public returns (address signBuyer, 
189     address signSeller){
190         
191         uint deal = dealNumbers[_dealNumber];
192         
193         return (
194                deals[deal].signBuyer,
195                deals[deal].signSeller
196               // deals[deal].signAgency
197             );
198         
199     }
200     
201     function getDealByNumber(uint _dealNumber) constant public returns (address buyer, 
202     address sender, 
203     address agency,
204     uint sum, 
205     uint atCreated,
206     statuses status,
207     uint objectType) {
208          
209          uint deal = dealNumbers[_dealNumber];
210         
211         return (
212             deals[deal].buyer,
213             deals[deal].seller,
214             deals[deal].signer,
215             deals[deal].sum,
216             deals[deal].atCreated,
217             deals[deal].status,
218             deals[deal].objectType
219             );
220     }
221     
222     function getDealsLength() onlyAgency  constant public returns (uint len){
223         return deals.length;
224     }
225     
226     function getDealById(uint deal) onlyAgency constant public returns (address buyer, 
227     address sender, 
228     address agency,
229     uint sum, 
230     uint atCreated,
231     statuses status,
232     uint objectType,
233     uint dealID) {
234          
235         
236         return (
237             deals[deal].buyer,
238             deals[deal].seller,
239             deals[deal].signer,
240             deals[deal].sum,
241             deals[deal].atCreated,
242             deals[deal].status,
243             deals[deal].objectType,
244             deal
245             );
246     }
247     
248      function getDealDataByNumber(uint _dealNumber)  constant public returns 
249      (string comment, 
250     uint fee, 
251     uint atClosed) {
252        
253          uint deal = dealNumbers[_dealNumber];
254         
255         return (
256             deals[deal].comment,
257             deals[deal].fee,
258             deals[deal].atClosed
259             );
260     }
261 
262     mapping (uint=>uint) public dealNumbers;
263     
264    function addDeal(address buyer, address seller, address signer, uint sum, uint fee, uint objectType, uint _dealNumber, string comment, uint whoPay) onlyAgency public{
265       
266       /*
267       objecType = 0 //  old
268       objecType = 1 // new
269        */ 
270      //  feePercent = _feePercent;
271       // sum = sum.mul(1 ether);
272        //uint fee = sum.mul(feePercent).div(100);
273       // fee = fee.mul(1 ether);
274       
275       //Кто приоритетнее objectType or WhoPay
276       /*
277       whopay = 0  // pay fee buyer
278       whopay = 1  // pay fee seller
279       */
280       if(whoPay ==0){
281         sum = sum.add(fee);  
282       }
283      
284      /*  if(objectType == 0){
285            //buyer pay fee. increase sum to  feePercent
286             sum = sum.add(fee);
287        }
288       */
289       
290       uint  newIndex = deals.length++;
291       signs.length ++;
292       deals[newIndex].buyer = buyer;
293       deals[newIndex].seller = seller;
294        deals[newIndex].signer = signer;
295      // deals[newIndex].agency = agencyOwner;
296       deals[newIndex].sum = sum;
297       deals[newIndex].fee = fee;
298       //deals[newIndex].date = date;
299      // deals[newIndex].isProlong = isProlong;
300      
301       deals[newIndex].atCreated = now;
302       
303       deals[newIndex].signBuyer = 0x0;
304       deals[newIndex].signSeller = 0x0;
305       deals[newIndex].comment = comment;
306       deals[newIndex].status = statuses.created;
307       //deals[newIndex].signAgency = 0x0;
308       
309       deals[newIndex].balance = 0;
310       deals[newIndex].objectType = objectType;
311      deals[newIndex].dealNumber = _dealNumber;
312      
313      dealNumbers[_dealNumber] = newIndex;
314      
315      signs[newIndex].finishSignSeller = 0x0;
316      signs[newIndex].finishSignBuyer = 0x0;
317      signs[newIndex].finishSignSigner = 0x0;
318      
319      
320    }
321    
322    // Buyer sign
323    function signBuyer(uint _dealNumber) public payable{
324        
325        uint deal = dealNumbers[_dealNumber];
326        
327        //If sign of buyer is mpty and sender it is buyer for this deal
328        require(deals[deal].signBuyer == 0x0 && msg.sender == deals[deal].buyer);
329        require(deals[deal].signSeller == deals[deal].seller);
330        
331        //Check, value of tx need >= summ of deal
332        //TODO: need change maker!!!!
333        require(deals[deal].sum == msg.value);
334        
335        deals[deal].signBuyer = msg.sender;
336         deals[deal].balance =  msg.value;
337        deals[deal].status = statuses.signed;
338      
339    }
340    
341     // Seller sign
342    function signSeller(uint _dealNumber) public {
343        
344        uint deal = dealNumbers[_dealNumber];
345        
346        //If sign of seller is empty and sender it is seller for this deal
347        require(deals[deal].signSeller == 0x0 && msg.sender == deals[deal].seller);
348        deals[deal].signSeller = msg.sender;
349    }
350    
351    // Agency sign
352   /* function signAgency(uint _dealNumber) onlyAgency public {
353        
354        uint deal = dealNumbers[_dealNumber];
355        
356        //If sign of Agency is empty and sender it is agency for this deal
357        require(deals[deal].signAgency == 0x0);
358        deals[deal].signAgency = msg.sender;
359      
360    }*/
361    
362    
363    //возарт после истечения срока
364  /*  function refound(uint deal) public{
365        
366        require(now > deals[deal].date && deals[deal].isProlong == false && deals[deal].balance > 0);
367        
368        //или все таки возврат делать покупателю!!???
369        deals[deal].agency.transfer(deals[deal].balance);
370        balances[deals[deal].buyer] = 0;
371        deals[deal].balance = 0;
372        
373    }*/
374    
375    /*
376    
377    function finishSign(uint _dealNumber) public{
378        
379         uint deal = dealNumbers[_dealNumber];
380         
381           require(deals[deal].balance > 0 &&  deals[deal].status == statuses.signed );
382        
383        if(msg.sender == deals[deal].buyer){
384            signs[deal].finishSignBuyer = msg.sender;
385        }
386         
387       if(msg.sender == deals[deal].seller){
388            signs[deal].finishSignSeller = msg.sender;
389        }
390        if(msg.sender ==deals[deal].signer){
391             signs[deal].finishSignSigner = msg.sender;
392        }
393        
394    }*/
395    
396    function finishDeal(uint _dealNumber)  public{
397        
398        uint deal = dealNumbers[_dealNumber];
399        
400        require(deals[deal].balance > 0 &&  deals[deal].status == statuses.signed );
401        
402        //SIGNING.....
403        
404        if(msg.sender == deals[deal].buyer){
405            signs[deal].finishSignBuyer = msg.sender;
406        }
407         
408       if(msg.sender == deals[deal].seller){
409            signs[deal].finishSignSeller = msg.sender;
410        }
411        if(msg.sender ==deals[deal].signer){
412             signs[deal].finishSignSigner = msg.sender;
413        }
414        
415        //////////////////////////
416        
417        
418       uint signCount = 0;
419        if(deals[deal].buyer == signs[deal].finishSignBuyer){
420            signCount++;
421        }
422         if(deals[deal].seller == signs[deal].finishSignSeller){
423            signCount++;
424        }
425         if(deals[deal].signer == signs[deal].finishSignSigner){
426            signCount++;
427        }
428        
429        if(signCount >= 2){
430        
431          //transfer fund to seller
432           deals[deal].seller.transfer(deals[deal].sum - deals[deal].fee);
433            
434            emit MoneyTransfer(this,deals[deal].seller,deals[deal].sum-deals[deal].fee);
435           
436            //transer fund to agency (fee)
437            agencyReceiver.transfer(deals[deal].fee);
438            
439            emit MoneyTransfer(this,agencyReceiver,deals[deal].fee);
440            
441            deals[deal].balance = 0;
442            deals[deal].status = statuses.finished;
443            deals[deal].atClosed = now;
444        }
445    }
446    
447    
448    // нужно ли тут расчиывать коммисию???
449     function cancelDeal(uint _dealNumber) onlySigner(_dealNumber) public{
450        
451         uint deal = dealNumbers[_dealNumber];
452        
453        require(deals[deal].balance > 0 &&  deals[deal].status == statuses.signed);
454        
455        deals[deal].buyer.transfer(deals[deal].balance);
456        
457        //emit MoneyTransfer(this,deals[deal].buyer,deals[deal].balance);
458        
459        deals[deal].balance = 0;
460        deals[deal].status = statuses.canceled;
461        deals[deal].atClosed = now;
462        
463    }
464 }
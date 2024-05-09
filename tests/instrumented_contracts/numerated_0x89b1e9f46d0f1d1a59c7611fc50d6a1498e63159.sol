1 /**
2  * @title smart real estate platform implementation
3  * @author Maxim Akimov - <devstylesoftware@gmail.com>
4  */
5  
6  // ver  from 23/06/2018  v0.3
7 
8 pragma solidity ^0.4.24;
9 
10 
11 library SafeMath {
12     
13 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
14 		uint256 c = a * b;
15 		assert(a == 0 || c / a == b);
16 		return c;
17 	}
18 
19 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
20 		// assert(b > 0); // Solidity automatically throws when dividing by 0
21 		uint256 c = a / b;
22 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
23 		return c;
24 	}
25 
26 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27 		assert(b <= a);
28 		return a - b;
29 	}
30 
31 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
32 		uint256 c = a + b;
33 		assert(c >= a);
34 		return c;
35 	}
36   
37 }
38 
39 contract Ownable {
40     
41 	address public owner;
42 	address public ownerCandidat;
43 
44 	/**
45 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
46 	* account.
47 	*/
48 	 constructor() public{
49 		owner = msg.sender;
50 		
51 	}
52 
53 	/**
54 	* @dev Throws if called by any account other than the owner.
55 	*/
56 	modifier onlyOwner() {
57 		require(msg.sender == owner);
58 		_;
59 	}
60 
61 	/**
62 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
63 	* @param newOwner The address to transfer ownership to.
64 	*/
65 	function  transferOwnership(address newOwner) onlyOwner  public{
66 		require(newOwner != address(0));      
67 		ownerCandidat = newOwner;
68 	}
69 	/**
70 	* @dev Allows safe change current owner to a newOwner.
71 	*/
72 	function confirmOwnership() public{
73 		require(msg.sender == ownerCandidat);      
74 		owner = msg.sender;
75 	}
76 
77 }
78 
79 contract realestate is Ownable{
80     
81    using SafeMath for uint;
82      
83     enum statuses {
84         created,canceled,signed,finished
85     }
86     
87     struct _dealData{
88     
89     address buyer;
90     address seller;
91     address signer;
92   
93     uint sum; 
94     uint fee;
95     
96     uint atCreated;
97     uint atClosed;
98     
99     uint balance;
100     
101     statuses status;
102     uint dealNumber;
103     
104     string comment;
105     uint objectType; // 0 - old 1 - new
106     
107     uint date;
108     bool isProlong;
109 }
110 
111 struct _dealSigns{
112    
113     address signBuyer;
114     address signSeller;
115     
116     address finishSignBuyer;
117     address finishSignSeller;
118     address finishSignSigner;
119    
120 }
121 
122    event MoneyTransfer(
123         address indexed _from,
124         address indexed _to,
125         uint _value
126     );
127  
128 
129  address public agencyOwner;
130  address public agencyReceiver;
131 
132  _dealData[] private deals;
133 _dealSigns[] private signs;
134 
135  mapping (uint=>uint) private dealNumbers;
136    
137    // **************** modifiers **************** //
138    
139     modifier onlyAgency(){
140         require(msg.sender == agencyOwner);
141         _;
142     }
143     
144     modifier onlySigner(uint _dealNumber){
145         
146         uint deal = dealNumbers[_dealNumber];
147         require(msg.sender == deals[deal].signer);
148         _;
149     }
150     
151     constructor() public{
152         
153         agencyOwner = msg.sender;
154         agencyReceiver = msg.sender;
155     }
156     
157      /**
158      * @dev Change eth address of agency for create deal 
159      * @param _newAgency - new agency eth address
160      */  
161     function changeAgencyOwner(address _newAgency) public {
162         require(msg.sender == agencyOwner || msg.sender == owner);
163         agencyOwner = _newAgency;
164          
165      }
166      
167      /**
168      * @dev Change eth address of agency for recieve fee
169      * @param _agencyReceiver - new agency eth address
170      */ 
171      function changeAgencyReceiver (address _agencyReceiver) public{
172          
173         require(msg.sender == agencyOwner || msg.sender == owner);
174         agencyReceiver = _agencyReceiver;
175      }
176      
177      /**
178      * @dev to prolongate a deal for some days
179      * @param _dealNumber - uniq number of deal
180      * @param _days - count of days from current time
181      */ 
182     function changeDealDate(uint _dealNumber, uint _days) onlyAgency public{
183         
184         uint deal = dealNumbers[_dealNumber];
185         require(deals[deal].isProlong);
186          
187         deals[deal].date = now + _days * 1 days;
188     }
189 
190     /**
191      * @dev Get all signs of deal by _dealNumber
192      * @param _dealNumber - uniq number of deal 
193      */ 
194     function getSigns(uint _dealNumber) constant public returns (
195     address signBuyer, 
196     address signSeller,
197     address finishSignBuyer,
198     address finishSignSeller,
199     address finishSignSigner){
200         
201         uint deal = dealNumbers[_dealNumber];
202         
203         return (
204                 signs[deal].signBuyer,
205                 signs[deal].signSeller,
206                
207                 signs[deal].finishSignBuyer,
208                 signs[deal].finishSignSeller,
209                 signs[deal].finishSignSigner
210             );
211         
212     }
213     
214      /**
215      * @dev Get main data of deal by _dealNumber
216      * @param _dealNumber - uniq number of deal 
217      */ 
218     function getDealByNumber(uint _dealNumber) constant public returns (
219     address buyer, 
220     address sender, 
221     address agency,
222     uint sum, 
223     uint atCreated,
224     statuses status,
225     uint objectType) {
226          
227          uint deal = dealNumbers[_dealNumber];
228         
229         return (
230             deals[deal].buyer,
231             deals[deal].seller,
232             deals[deal].signer,
233             deals[deal].sum,
234             deals[deal].atCreated,
235             deals[deal].status,
236             deals[deal].objectType
237             );
238     }
239     
240     /**
241      * @dev Get lenght of priviate array deals (for agency only)
242      */ 
243     function getDealsLength() onlyAgency  constant public returns (uint len){
244         return deals.length;
245     }
246     
247      /**
248      * @dev Get main data of deal
249      * @param deal - uniq id from priviate array deals 
250      */ 
251     function getDealById(uint deal) onlyAgency constant public returns (
252     address buyer, 
253     address sender, 
254     address agency,
255     uint sum, 
256     uint atCreated,
257     statuses status,
258     uint objectType,
259     uint dealID) {
260          
261         
262         return (
263             deals[deal].buyer,
264             deals[deal].seller,
265             deals[deal].signer,
266             deals[deal].sum,
267             deals[deal].atCreated,
268             deals[deal].status,
269             deals[deal].objectType,
270             deal
271             );
272     }
273     
274     /**
275      * @dev Get comment, fee, atCloced, date, is prolong of deal
276      * @param _dealNumber - uniq number of deal 
277      */ 
278     function getDealDataByNumber(uint _dealNumber)  constant public returns (
279     string comment, 
280     uint fee, 
281     uint atClosed,
282     uint date,
283     bool isProlong) {
284        
285          uint deal = dealNumbers[_dealNumber];
286         
287         return (
288             deals[deal].comment,
289             deals[deal].fee,
290             deals[deal].atClosed,
291             deals[deal].date,
292             deals[deal].isProlong
293             );
294     }
295 
296    
297     
298      /**
299     * @dev function for create deal by agency owner only
300     * @param _buyer -  eth address of buyer
301     * @param _seller -  eth address of seller
302     * @param _signer -  eth address of signer (how cah canceled deal)
303     * @param _sum -  sum of the deal (in wei)
304     * @param _fee -  fee of the deal (in wei)
305     * @param _objectType -  type of property (0 - old, 1 - new)
306     * @param _dealNumber - uniq number of deal
307     * @param _comment -  any text coment of the deal
308     * @param whoPay -  point out who pay fee of the deal (0 - buyer, 1 - seller)
309     * @param _countDays - Hoe many days allow for deal processing
310     * @param _isProlong - Allow to prolongate deal, if true
311     */
312    function addDeal(
313    address _buyer, 
314    address _seller, 
315    address _signer,
316    uint _sum,
317    uint _fee,
318    uint _objectType, 
319    uint _dealNumber, 
320    string _comment,
321    uint whoPay,
322    uint _countDays,
323    bool _isProlong) onlyAgency public{
324       
325       if(whoPay ==0){
326         _sum = _sum.add(_fee);  
327       }
328      
329       uint  newIndex = deals.length++; signs.length ++;
330       
331       deals[newIndex].buyer = _buyer;
332       deals[newIndex].seller = _seller;
333       deals[newIndex].signer = _signer;
334       deals[newIndex].sum = _sum;
335       deals[newIndex].fee = _fee;
336       deals[newIndex].date = now + _countDays * 1 days;
337       deals[newIndex].isProlong = _isProlong;
338       deals[newIndex].atCreated = now;
339       deals[newIndex].comment = _comment;
340       deals[newIndex].status = statuses.created;
341       deals[newIndex].balance = 0;
342       deals[newIndex].objectType = _objectType;
343       deals[newIndex].dealNumber = _dealNumber;
344      
345      dealNumbers[_dealNumber] = newIndex;
346      
347      signs[newIndex].signBuyer = 0x0;
348      signs[newIndex].signSeller = 0x0;
349      signs[newIndex].finishSignSeller = 0x0;
350      signs[newIndex].finishSignBuyer = 0x0;
351      signs[newIndex].finishSignSigner = 0x0;
352      
353      
354    }
355    
356      /**
357     * @dev function for sign deal by buyer and for transfer money  (call after sign seller only)
358     * @param _dealNumber (deal number)
359     */
360    function signBuyer(uint _dealNumber) public payable{
361        
362        uint deal = dealNumbers[_dealNumber];
363        
364        //If sign of buyer is mpty and sender it is buyer for this deal
365        require(signs[deal].signBuyer == 0x0 && msg.sender == deals[deal].buyer);
366        require(signs[deal].signSeller == deals[deal].seller);
367        
368        //Check, value of tx need >= summ of deal
369        //TODO: need change maker!!!!
370        require(deals[deal].sum == msg.value);
371        
372        signs[deal].signBuyer = msg.sender;
373         deals[deal].balance =  msg.value;
374        deals[deal].status = statuses.signed;
375      
376    }
377    
378     /**
379     * @dev function for sign deal by seller (in start and before buyer)
380     * @param _dealNumber (deal number)
381     */
382    function signSeller(uint _dealNumber) public {
383        
384        uint deal = dealNumbers[_dealNumber];
385        
386        //If sign of seller is empty and sender it is seller for this deal
387        require(signs[deal].signSeller == 0x0 && msg.sender == deals[deal].seller);
388        signs[deal].signSeller = msg.sender;
389    }
390    
391    // Agency sign
392   /* function signAgency(uint _dealNumber) onlyAgency public {
393        
394        uint deal = dealNumbers[_dealNumber];
395        
396        //If sign of Agency is empty and sender it is agency for this deal
397        require(deals[deal].signAgency == 0x0);
398        deals[deal].signAgency = msg.sender;
399      
400    }*/
401    
402    
403    /**
404     * @dev function for buyer (for mmoney refund after time of the deal)
405     * @param _dealNumber (deal number)
406     */
407    function refund(uint _dealNumber) public{
408        
409        uint deal = dealNumbers[_dealNumber];
410        require(now > deals[deal].date && deals[deal].balance > 0 && msg.sender == deals[deal].buyer);
411        
412        deals[deal].buyer.transfer(deals[deal].balance);
413        
414        deals[deal].balance = 0;
415        
416    }
417    
418    /**
419     * @dev function for sign in end of the deal (for finis need 2 sign from 3)
420     * @param _dealNumber (deal number)
421     */
422    function finishDeal(uint _dealNumber)  public{
423        
424        uint deal = dealNumbers[_dealNumber];
425        
426        require(deals[deal].balance > 0 &&  deals[deal].status == statuses.signed );
427        
428        //SIGNING.....
429        
430        if(msg.sender == deals[deal].buyer){
431            signs[deal].finishSignBuyer = msg.sender;
432        }
433         
434       if(msg.sender == deals[deal].seller){
435            signs[deal].finishSignSeller = msg.sender;
436        }
437        if(msg.sender ==deals[deal].signer){
438             signs[deal].finishSignSigner = msg.sender;
439        }
440        
441        //////////////////////////
442        
443        
444       uint signCount = 0;
445        if(deals[deal].buyer == signs[deal].finishSignBuyer){
446            signCount++;
447        }
448         if(deals[deal].seller == signs[deal].finishSignSeller){
449            signCount++;
450        }
451         if(deals[deal].signer == signs[deal].finishSignSigner){
452            signCount++;
453        }
454        
455        if(signCount >= 2){
456        
457          //transfer fund to seller
458           deals[deal].seller.transfer(deals[deal].sum - deals[deal].fee);
459            
460            emit MoneyTransfer(this,deals[deal].seller,deals[deal].sum-deals[deal].fee);
461           
462            //transer fund to agency (fee)
463            agencyReceiver.transfer(deals[deal].fee);
464            
465            emit MoneyTransfer(this,agencyReceiver,deals[deal].fee);
466            
467            deals[deal].balance = 0;
468            deals[deal].status = statuses.finished;
469            deals[deal].atClosed = now;
470        }
471    }
472    
473    
474    
475    /**
476     * @dev function for cancel deal (accessable ony for signer of current deal)
477     * @param _dealNumber (deal number)
478     */
479     function cancelDeal(uint _dealNumber) onlySigner(_dealNumber) public{
480        
481         uint deal = dealNumbers[_dealNumber];
482        
483        require(deals[deal].balance > 0 &&  deals[deal].status == statuses.signed);
484        
485        deals[deal].buyer.transfer(deals[deal].balance);
486        
487        emit MoneyTransfer(this,deals[deal].buyer,deals[deal].balance);
488        
489        deals[deal].balance = 0;
490        deals[deal].status = statuses.canceled;
491        deals[deal].atClosed = now;
492        
493    }
494 }
1 pragma solidity ^0.4.7;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     //assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     //assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     //assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48 }
49 
50 contract ERC20Basic {
51   uint256 public totalSupply=100000000; 
52   function balanceOf(address who) constant returns (uint256);
53   function transfer(address to, uint256 value);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 
56 }
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant returns (uint256);
60   function transferFrom(address from, address to, uint256 value);
61   function approve(address spender, uint256 value);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) allowed;
95 
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amout of tokens to be transfered
102    */
103   function transferFrom(address _from, address _to, uint256 _value) {
104     var _allowance = allowed[_from][msg.sender];
105 
106     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107     // if (_value > _allowance) throw;
108 
109     balances[_to] = balances[_to].add(_value);
110     balances[_from] = balances[_from].sub(_value);
111     allowed[_from][msg.sender] = _allowance.sub(_value);
112     Transfer(_from, _to, _value);
113   }
114 
115   /**
116    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) {
121 
122     // To change the approve amount you first have to reduce the addresses`
123     //  allowance to zero by calling `approve(_spender, 0)` if it is not
124     //  already 0 to mitigate the race condition described here:
125     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
127 
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifing the amount of tokens still avaible for the spender.
137    */
138   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139     return allowed[_owner][_spender];
140   }
141 
142 }
143 
144 contract owned {
145      function owned() { owner = msg.sender; }
146      address owner;
147 
148      // This contract only defines a modifier but does not use
149      // it - it will be used in derived contracts.
150      // The function body is inserted where the special symbol
151      // "_;" in the definition of a modifier appears.
152      // This means that if the owner calls this function, the
153      // function is executed and otherwise, an exception is
154      // thrown.
155      modifier onlyOwner {
156          if(msg.sender != owner)
157          {
158          throw;
159          }
160          _;
161      }
162  }
163 
164 
165 contract UniContract is StandardToken, owned {
166 
167 
168    string public constant name = "SaveUNICOINs";
169    string public constant symbol = "UCN";
170    uint256 public constant decimals = 0;
171    
172    //founder & fund collector
173    address public multisig;
174    address public founder; 
175    
176    
177    //Timings
178    uint public start;  
179    uint public end;
180    uint public launch;
181    
182    //Dynamic Pricing PRICE IN UCN
183    uint256 public PRICE = 300000;  
184    
185    //Dynamic Status of sold UCN Tokens
186    uint256 public OVERALLSOLD = 0;  
187    
188    //Maximum of Tokens to be sold 85.000.000
189    uint256 public MAXTOKENSOLD = 85000000;  
190    
191    
192    
193    
194   
195    function UniContract() onlyOwner { 
196        founder = 0x204244062B04089b6Ef55981Ad82119cEBf54F88; 
197        multisig= 0x9FA2d2231FE8ac207831B376aa4aE35671619960; 
198        start = 1507543200;
199        end = 1509098400; 
200  	   launch = 1509534000;
201        balances[founder] = balances[founder].add(15000000); // Founder (15% = 15.000.000 UCN)
202    }
203    
204    
205    
206    //Stage Pre-Sale Variables
207    
208    uint256 public constant PRICE_PRESALE = 300000;  
209    uint256 public constant FACTOR_PRESALE = 38;
210    uint256 public constant RANGESTART_PRESALE = 0; 
211    uint256 public constant RANGEEND_PRESALE = 10000000; 
212    
213    
214    //Stage 1
215    uint256 public constant PRICE_1 = 30000;  
216    uint256 public constant FACTOR_1 = 460;
217    uint256 public constant RANGESTART_1 = 10000001; 
218    uint256 public constant RANGEEND_1 = 10100000;
219    
220    //Stage 2
221    uint256 public constant PRICE_2 = 29783;  
222    uint256 public constant FACTOR_2 = 495;
223    uint256 public constant RANGESTART_2 = 10100001; 
224    uint256 public constant RANGEEND_2 = 11000000;
225    
226    //Stage 3
227    uint256 public constant PRICE_3 = 27964;  
228    uint256 public constant FACTOR_3 = 580;
229    uint256 public constant RANGESTART_3 = 11000001; 
230    uint256 public constant RANGEEND_3 = 15000000;
231    
232    //Stage 4
233    uint256 public constant PRICE_4 = 21068;  
234    uint256 public constant FACTOR_4 = 800;
235    uint256 public constant RANGESTART_4 = 15000001; 
236    uint256 public constant RANGEEND_4 = 20000000;
237    
238    //Stage 5
239    uint256 public constant PRICE_5 = 14818;  
240    uint256 public constant FACTOR_5 = 1332;
241    uint256 public constant RANGESTART_5 = 20000001; 
242    uint256 public constant RANGEEND_5 = 30000000;
243    
244    //Stage 6
245    uint256 public constant PRICE_6 = 7310;  
246    uint256 public constant FACTOR_6 = 2700;
247    uint256 public constant RANGESTART_6 = 30000001; 
248    uint256 public constant RANGEEND_6 = 40000000;
249    
250    //Stage 7
251    uint256 public constant PRICE_7 = 3607;  
252    uint256 public constant FACTOR_7 = 5450;
253    uint256 public constant RANGESTART_7 = 40000001; 
254    uint256 public constant RANGEEND_7 = 50000000;
255    
256    //Stage 8
257    uint256 public constant PRICE_8 = 1772;  
258    uint256 public constant FACTOR_8 = 11000;
259    uint256 public constant RANGESTART_8 = 50000001; 
260    uint256 public constant RANGEEND_8 = 60000000;
261    
262    //Stage 9
263    uint256 public constant PRICE_9 = 863;  
264    uint256 public constant FACTOR_9 = 23200;
265    uint256 public constant RANGESTART_9 = 60000001; 
266    uint256 public constant RANGEEND_9 = 70000000;
267    
268    //Stage 10
269    uint256 public constant PRICE_10 = 432;  
270    uint256 public constant FACTOR_10 = 46000;
271    uint256 public constant RANGESTART_10 = 70000001; 
272    uint256 public constant RANGEEND_10 = 80000000;
273    
274    //Stage 11
275    uint256 public constant PRICE_11 = 214;  
276    uint256 public constant FACTOR_11 = 78000;
277    uint256 public constant RANGESTART_11 = 80000001; 
278    uint256 public constant RANGEEND_11 = 85000000;
279    
280 
281    uint256 public UniCoinSize=0;
282 
283  
284    function () payable {
285      submitTokens(msg.sender);
286    }
287 
288    /**
289     * @dev Creates tokens and send to the specified address.
290     * @param recipient The address which will recieve the new tokens.
291     */
292    function submitTokens(address recipient) payable {
293      	if (msg.value == 0) {
294        		throw;
295      	}
296 		
297    	 	//Permit buying only between 10/09/17 - 10/27/2017 and after 11/01/2017
298    	 	if((now > start && now < end) || now > launch)
299    	 		{				
300         		uint256 tokens = msg.value.mul(PRICE).div( 1 ether);
301         		if(tokens.add(OVERALLSOLD) > MAXTOKENSOLD)
302    	 				{
303    					throw;
304    					}
305 		
306    				//Pre-Sale CAP 10,000,000 check
307    				if(((tokens.add(OVERALLSOLD)) > RANGEEND_PRESALE) && (now > start && now < end))
308    					{
309    					throw;
310    					}
311 		
312  				   
313         		OVERALLSOLD = OVERALLSOLD.add(tokens);	
314 	
315    		 	    // Send UCN to Recipient	
316         		balances[recipient] = balances[recipient].add(tokens);
317 	 
318    	 			// Send Funds to MultiSig
319         		if (!multisig.send(msg.value)) {
320           			throw;
321         			}
322        		}
323    	  	  else
324    	  			{
325    	  	  		throw;
326    	 		   	}
327 		
328 		
329 		//TIMING 10/09/17 - 10/27/17 OR CAP 10,000,000 reached
330 		
331 		if(now>start && now <end)
332 		{
333 			//Stage Pre-Sale Range 0 - 10,000,000 
334 			if(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) 
335 				{
336 				PRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);
337 				}
338 		}
339 		
340 		//TIMING 11/01/17 Start Token Sale
341 		if(now>launch)
342 		{
343 		//Stage Post-Pre-Sale Range 0 - 10,000,000 
344 		if(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) 
345 			{
346 			PRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);
347 			}
348 		
349 		//Stage One 10,000,001 - 10,100,000 
350 		if(OVERALLSOLD >= RANGESTART_1 && OVERALLSOLD <= RANGEEND_1)
351 			{
352 			PRICE = PRICE_1 - (1 + OVERALLSOLD - RANGESTART_1).div(FACTOR_1);
353 			}
354 
355 		//Stage Two 10,100,001 - 11,000,000
356 		if(OVERALLSOLD >= RANGESTART_2 && OVERALLSOLD <= RANGEEND_2)
357 			{
358 			PRICE = PRICE_2 - (1 + OVERALLSOLD - RANGESTART_2).div(FACTOR_2);
359 			}
360 
361 		//Stage Three 11,000,001 - 15,000,000
362 		if(OVERALLSOLD >= RANGESTART_3 && OVERALLSOLD <= RANGEEND_3)
363 			{
364 			PRICE = PRICE_3 - (1 + OVERALLSOLD - RANGESTART_3).div(FACTOR_3);
365 			}
366 			
367 		//Stage Four 15,000,001 - 20,000,000
368 		if(OVERALLSOLD >= RANGESTART_4 && OVERALLSOLD <= RANGEEND_4)
369 			{
370 			PRICE = PRICE_4 - (1 + OVERALLSOLD - RANGESTART_4).div(FACTOR_4);
371 			}
372 			
373 		//Stage Five 20,000,001 - 30,000,000
374 		if(OVERALLSOLD >= RANGESTART_5 && OVERALLSOLD <= RANGEEND_5)
375 			{
376 			PRICE = PRICE_5 - (1 + OVERALLSOLD - RANGESTART_5).div(FACTOR_5);
377 			}
378 		
379 		//Stage Six 30,000,001 - 40,000,000
380 		if(OVERALLSOLD >= RANGESTART_6 && OVERALLSOLD <= RANGEEND_6)
381 			{
382 			PRICE = PRICE_6 - (1 + OVERALLSOLD - RANGESTART_6).div(FACTOR_6);
383 			}	
384 		
385 		//Stage Seven 40,000,001 - 50,000,000
386 		if(OVERALLSOLD >= RANGESTART_7 && OVERALLSOLD <= RANGEEND_7)
387 			{
388 			PRICE = PRICE_7 - (1 + OVERALLSOLD - RANGESTART_7).div(FACTOR_7);
389 			}
390 			
391 		//Stage Eight 50,000,001 - 60,000,000
392 		if(OVERALLSOLD >= RANGESTART_8 && OVERALLSOLD <= RANGEEND_8)
393 			{
394 			PRICE = PRICE_8 - (1 + OVERALLSOLD - RANGESTART_8).div(FACTOR_8);
395 			}
396 		
397 		//Stage Nine 60,000,001 - 70,000,000
398 		if(OVERALLSOLD >= RANGESTART_9 && OVERALLSOLD <= RANGEEND_9)
399 			{
400 			PRICE = PRICE_9 - (1 + OVERALLSOLD - RANGESTART_9).div(FACTOR_9);
401 			}
402 		
403 		//Stage Ten 70,000,001 - 80,000,000
404 		if(OVERALLSOLD >= RANGESTART_10 && OVERALLSOLD <= RANGEEND_10)
405 			{
406 			PRICE = PRICE_10 - (1 + OVERALLSOLD - RANGESTART_10).div(FACTOR_10);
407 			}	
408 		
409 		//Stage Eleven 80,000,001 - 85,000,000
410 		if(OVERALLSOLD >= RANGESTART_11 && OVERALLSOLD <= RANGEEND_11)
411 			{
412 			PRICE = PRICE_11 - (1 + OVERALLSOLD - RANGESTART_11).div(FACTOR_11);
413 			}
414 		}
415 		
416 	
417    }
418 
419 	 
420    function submitEther(address recipient) payable {
421      if (msg.value == 0) {
422        throw;
423      }
424 
425      if (!recipient.send(msg.value)) {
426        throw;
427      }
428     
429    }
430 
431 
432   //Unicorn Shoutbox
433 
434   struct MessageQueue {
435            string message; 
436   		   string from;
437            uint expireTimestamp;  
438            uint startTimestamp;
439            address sender; 
440        }
441 
442 	 
443      uint256 public constant maxSpendToken = 3600; //Message should last approx. 1 hour max
444 
445      MessageQueue[] public mQueue;
446  
447 	
448  
449       function addMessageToQueue(string msg_from, string name_from, uint spendToken) {
450         if(balances[msg.sender]>spendToken && spendToken>=10)
451         {
452            if(spendToken>maxSpendToken) 
453                {
454                    spendToken=maxSpendToken;
455                }
456            
457 		   UniCoinSize=UniCoinSize+spendToken;
458            
459            balances[msg.sender] = balances[msg.sender].sub(spendToken);
460           
461 		  //If first message or last message already expired set newest timestamp
462   		  uint expireTimestamp=now;
463 		  if(mQueue.length>0)
464 			{
465 			 if(mQueue[mQueue.length-1].expireTimestamp>now)
466 			 	{
467 			 	expireTimestamp = mQueue[mQueue.length-1].expireTimestamp;
468 				}
469 			} 
470 		
471 		 
472 		 
473            mQueue.push(MessageQueue({
474                    message: msg_from, 
475   				   from: name_from,
476                    expireTimestamp: expireTimestamp.add(spendToken)+60,  //give at least approx 60 seconds per msg
477                    startTimestamp: expireTimestamp,
478                    sender: msg.sender
479                }));
480     
481         
482 		 
483         }
484 		else {
485 		      throw;
486 		      }
487       }
488 	  
489 	
490     function feedUnicorn(uint spendToken) {
491 	
492    	 	if(balances[msg.sender]>spendToken)
493         	{
494        	 	UniCoinSize=UniCoinSize.add(spendToken);
495         	balances[msg.sender] = balances[msg.sender].sub(spendToken);
496 			}
497 		
498 	 } 
499 	
500 	
501    function getQueueLength() public constant returns (uint256 result) {
502 	 return mQueue.length;
503    }
504    function getMessage(uint256 i) public constant returns (string, string, uint, uint, address){
505      return (mQueue[i].message,mQueue[i].from,mQueue[i].expireTimestamp,mQueue[i].startTimestamp,mQueue[i].sender );
506    }
507    function getPrice() constant returns (uint256 result) {
508      return PRICE;
509    }
510    function getSupply() constant returns (uint256 result) {
511      return totalSupply;
512    }
513    function getSold() constant returns (uint256 result) {
514      return OVERALLSOLD;
515    }
516    function getUniCoinSize() constant returns (uint256 result) {    
517      return UniCoinSize; 
518    } 
519     function getAddress() constant returns (address) {
520      return this;
521    }
522     
523 
524 
525   
526    // ADMIN Functions
527 
528    
529    //In emergency cases to stop or change timings 
530    function aSetStart(uint256 nstart) onlyOwner {
531      start=nstart;
532    }
533    function aSetEnd(uint256 nend) onlyOwner {
534      end=nend;
535    }
536    function aSetLaunch(uint256 nlaunch) onlyOwner {
537      launch=nlaunch;
538    }
539     
540 
541    //We don't want the Unicorn to spread hateful messages 
542    function aDeleteMessage(uint256 i,string f,string m) onlyOwner{
543      mQueue[i].message=m;
544 	 mQueue[i].from=f; 
545 		 }
546    
547    //Clean house from time to time
548    function aPurgeMessages() onlyOwner{
549    delete mQueue; 
550    }
551 
552  }
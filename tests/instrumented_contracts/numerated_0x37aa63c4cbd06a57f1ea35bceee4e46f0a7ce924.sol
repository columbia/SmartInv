1 pragma solidity ^0.4.11;
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
76       
77       if (balances[msg.sender] < _value) {
78             // Balance too low
79             throw;
80         }
81       
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of. 
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
113             // Balance or allowance too low
114             throw;
115         }
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121   }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) {
129 
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifing the amount of tokens still avaible for the spender.
139    */
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 contract owned {
147      function owned() { owner = msg.sender; }
148      address owner;
149 
150      // This contract only defines a modifier but does not use
151      // it - it will be used in derived contracts.
152      // The function body is inserted where the special symbol
153      // "_;" in the definition of a modifier appears.
154      // This means that if the owner calls this function, the
155      // function is executed and otherwise, an exception is
156      // thrown.
157      modifier onlyOwner {
158          if(msg.sender != owner)
159          {
160          throw;
161          }
162          _;
163      }
164  }
165 
166 
167 contract UniContract is StandardToken, owned {
168 
169 
170    string public constant name = "SaveUNICOINs";
171    string public constant symbol = "UCN";
172    uint256 public constant decimals = 0;
173    
174    //founder & fund collector
175    address public multisig;
176    address public founder; 
177    
178    
179    //Timings
180    uint public start;  
181    uint public end;
182    uint public launch;
183    
184    //Dynamic Pricing PRICE IN UCN //UniContract V2
185    uint256 public PRICE = 217135;  
186    
187    //Dynamic Status of sold UCN Tokens //UniContract V2
188    uint256 public OVERALLSOLD = 3148890;  
189    
190    //Maximum of Tokens to be sold 85.000.000
191    uint256 public MAXTOKENSOLD = 85000000;  
192    
193    
194    
195    
196   
197    function UniContract() onlyOwner { 
198        founder = 0x204244062B04089b6Ef55981Ad82119cEBf54F88; 
199        multisig= 0x9FA2d2231FE8ac207831B376aa4aE35671619960;
200        
201        start = 1507543200;
202        end = 1509098400; 
203  	   launch = 1509534000;
204  	   //UniContract V2
205        balances[founder] = balances[founder].add(18148890); // Founder (15% = 15.000.000 UCN + 3148890 redistribute)
206  
207    }
208    
209    
210    
211    //Stage Pre-Sale Variables
212    
213    uint256 public constant PRICE_PRESALE = 300000;  
214    uint256 public constant FACTOR_PRESALE = 38;
215    uint256 public constant RANGESTART_PRESALE = 0; 
216    uint256 public constant RANGEEND_PRESALE = 10000000; 
217    
218    
219    //Stage 1
220    uint256 public constant PRICE_1 = 30000;  
221    uint256 public constant FACTOR_1 = 460;
222    uint256 public constant RANGESTART_1 = 10000001; 
223    uint256 public constant RANGEEND_1 = 10100000;
224    
225    //Stage 2
226    uint256 public constant PRICE_2 = 29783;  
227    uint256 public constant FACTOR_2 = 495;
228    uint256 public constant RANGESTART_2 = 10100001; 
229    uint256 public constant RANGEEND_2 = 11000000;
230    
231    //Stage 3
232    uint256 public constant PRICE_3 = 27964;  
233    uint256 public constant FACTOR_3 = 580;
234    uint256 public constant RANGESTART_3 = 11000001; 
235    uint256 public constant RANGEEND_3 = 15000000;
236    
237    //Stage 4
238    uint256 public constant PRICE_4 = 21068;  
239    uint256 public constant FACTOR_4 = 800;
240    uint256 public constant RANGESTART_4 = 15000001; 
241    uint256 public constant RANGEEND_4 = 20000000;
242    
243    //Stage 5
244    uint256 public constant PRICE_5 = 14818;  
245    uint256 public constant FACTOR_5 = 1332;
246    uint256 public constant RANGESTART_5 = 20000001; 
247    uint256 public constant RANGEEND_5 = 30000000;
248    
249    //Stage 6
250    uint256 public constant PRICE_6 = 7310;  
251    uint256 public constant FACTOR_6 = 2700;
252    uint256 public constant RANGESTART_6 = 30000001; 
253    uint256 public constant RANGEEND_6 = 40000000;
254    
255    //Stage 7
256    uint256 public constant PRICE_7 = 3607;  
257    uint256 public constant FACTOR_7 = 5450;
258    uint256 public constant RANGESTART_7 = 40000001; 
259    uint256 public constant RANGEEND_7 = 50000000;
260    
261    //Stage 8
262    uint256 public constant PRICE_8 = 1772;  
263    uint256 public constant FACTOR_8 = 11000;
264    uint256 public constant RANGESTART_8 = 50000001; 
265    uint256 public constant RANGEEND_8 = 60000000;
266    
267    //Stage 9
268    uint256 public constant PRICE_9 = 863;  
269    uint256 public constant FACTOR_9 = 23200;
270    uint256 public constant RANGESTART_9 = 60000001; 
271    uint256 public constant RANGEEND_9 = 70000000;
272    
273    //Stage 10
274    uint256 public constant PRICE_10 = 432;  
275    uint256 public constant FACTOR_10 = 46000;
276    uint256 public constant RANGESTART_10 = 70000001; 
277    uint256 public constant RANGEEND_10 = 80000000;
278    
279    //Stage 11
280    uint256 public constant PRICE_11 = 214;  
281    uint256 public constant FACTOR_11 = 78000;
282    uint256 public constant RANGESTART_11 = 80000001; 
283    uint256 public constant RANGEEND_11 = 85000000;
284    
285 
286    uint256 public UniCoinSize=0;
287 
288  
289    function () payable {
290      submitTokens(msg.sender);
291    }
292 
293    /**
294     * @dev Creates tokens and send to the specified address.
295     * @param recipient The address which will recieve the new tokens.
296     */
297    function submitTokens(address recipient) payable {
298      	if (msg.value == 0) {
299        		throw;
300      	}
301 		
302    	 	//Permit buying only between 10/09/17 - 10/27/2017 and after 11/01/2017
303    	 	if((now > start && now < end) || now > launch)
304    	 		{				
305         		uint256 tokens = msg.value.mul(PRICE).div( 1 ether);
306         		if(tokens.add(OVERALLSOLD) > MAXTOKENSOLD)
307    	 				{
308    					throw;
309    					}
310 		
311    				//Pre-Sale CAP 10,000,000 check
312    				if(((tokens.add(OVERALLSOLD)) > RANGEEND_PRESALE) && (now > start && now < end))
313    					{
314    					throw;
315    					}
316 		
317  				   
318         		OVERALLSOLD = OVERALLSOLD.add(tokens);	
319 	
320    		 	    // Send UCN to Recipient	
321         		balances[recipient] = balances[recipient].add(tokens);
322 	 
323    	 			// Send Funds to MultiSig
324         		if (!multisig.send(msg.value)) {
325           			throw;
326         			}
327         		Transfer(address(this), recipient, tokens);
328        		}
329    	  	  else
330    	  			{
331    	  	  		throw;
332    	 		   	}
333 		
334 		
335 		//TIMING 10/09/17 - 10/27/17 OR CAP 10,000,000 reached
336 		
337 		if(now>start && now <end)
338 		{
339 			//Stage Pre-Sale Range 0 - 10,000,000 
340 			if(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) 
341 				{
342 				PRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);
343 				}
344 		}
345 		
346 		//TIMING 11/01/17 Start Token Sale
347 		if(now>launch)
348 		{
349 		//Stage Post-Pre-Sale Range 0 - 10,000,000 
350 		if(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) 
351 			{
352 			PRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);
353 			}
354 		
355 		//Stage One 10,000,001 - 10,100,000 
356 		if(OVERALLSOLD >= RANGESTART_1 && OVERALLSOLD <= RANGEEND_1)
357 			{
358 			PRICE = PRICE_1 - (1 + OVERALLSOLD - RANGESTART_1).div(FACTOR_1);
359 			}
360 
361 		//Stage Two 10,100,001 - 11,000,000
362 		if(OVERALLSOLD >= RANGESTART_2 && OVERALLSOLD <= RANGEEND_2)
363 			{
364 			PRICE = PRICE_2 - (1 + OVERALLSOLD - RANGESTART_2).div(FACTOR_2);
365 			}
366 
367 		//Stage Three 11,000,001 - 15,000,000
368 		if(OVERALLSOLD >= RANGESTART_3 && OVERALLSOLD <= RANGEEND_3)
369 			{
370 			PRICE = PRICE_3 - (1 + OVERALLSOLD - RANGESTART_3).div(FACTOR_3);
371 			}
372 			
373 		//Stage Four 15,000,001 - 20,000,000
374 		if(OVERALLSOLD >= RANGESTART_4 && OVERALLSOLD <= RANGEEND_4)
375 			{
376 			PRICE = PRICE_4 - (1 + OVERALLSOLD - RANGESTART_4).div(FACTOR_4);
377 			}
378 			
379 		//Stage Five 20,000,001 - 30,000,000
380 		if(OVERALLSOLD >= RANGESTART_5 && OVERALLSOLD <= RANGEEND_5)
381 			{
382 			PRICE = PRICE_5 - (1 + OVERALLSOLD - RANGESTART_5).div(FACTOR_5);
383 			}
384 		
385 		//Stage Six 30,000,001 - 40,000,000
386 		if(OVERALLSOLD >= RANGESTART_6 && OVERALLSOLD <= RANGEEND_6)
387 			{
388 			PRICE = PRICE_6 - (1 + OVERALLSOLD - RANGESTART_6).div(FACTOR_6);
389 			}	
390 		
391 		//Stage Seven 40,000,001 - 50,000,000
392 		if(OVERALLSOLD >= RANGESTART_7 && OVERALLSOLD <= RANGEEND_7)
393 			{
394 			PRICE = PRICE_7 - (1 + OVERALLSOLD - RANGESTART_7).div(FACTOR_7);
395 			}
396 			
397 		//Stage Eight 50,000,001 - 60,000,000
398 		if(OVERALLSOLD >= RANGESTART_8 && OVERALLSOLD <= RANGEEND_8)
399 			{
400 			PRICE = PRICE_8 - (1 + OVERALLSOLD - RANGESTART_8).div(FACTOR_8);
401 			}
402 		
403 		//Stage Nine 60,000,001 - 70,000,000
404 		if(OVERALLSOLD >= RANGESTART_9 && OVERALLSOLD <= RANGEEND_9)
405 			{
406 			PRICE = PRICE_9 - (1 + OVERALLSOLD - RANGESTART_9).div(FACTOR_9);
407 			}
408 		
409 		//Stage Ten 70,000,001 - 80,000,000
410 		if(OVERALLSOLD >= RANGESTART_10 && OVERALLSOLD <= RANGEEND_10)
411 			{
412 			PRICE = PRICE_10 - (1 + OVERALLSOLD - RANGESTART_10).div(FACTOR_10);
413 			}	
414 		
415 		//Stage Eleven 80,000,001 - 85,000,000
416 		if(OVERALLSOLD >= RANGESTART_11 && OVERALLSOLD <= RANGEEND_11)
417 			{
418 			PRICE = PRICE_11 - (1 + OVERALLSOLD - RANGESTART_11).div(FACTOR_11);
419 			}
420 		}
421 		
422 	
423    }
424 
425 	 
426    function submitEther(address recipient) payable {
427      if (msg.value == 0) {
428        throw;
429      }
430 
431      if (!recipient.send(msg.value)) {
432        throw;
433      }
434     
435    }
436 
437 
438   //Unicorn Shoutbox
439 
440   struct MessageQueue {
441            string message; 
442   		   string from;
443            uint expireTimestamp;  
444            uint startTimestamp;
445            address sender; 
446        }
447 
448 	 
449      uint256 public constant maxSpendToken = 3600; //Message should last approx. 1 hour max
450 
451      MessageQueue[] public mQueue;
452  
453 	
454  
455       function addMessageToQueue(string msg_from, string name_from, uint spendToken) {
456         if(balances[msg.sender]>=spendToken && spendToken>=10)
457         {
458            if(spendToken>maxSpendToken) 
459                {
460                    spendToken=maxSpendToken;
461                }
462            
463 		   UniCoinSize=UniCoinSize+spendToken;
464            
465            balances[msg.sender] = balances[msg.sender].sub(spendToken);
466           
467 		  //If first message or last message already expired set newest timestamp
468   		  uint expireTimestamp=now;
469 		  if(mQueue.length>0)
470 			{
471 			 if(mQueue[mQueue.length-1].expireTimestamp>now)
472 			 	{
473 			 	expireTimestamp = mQueue[mQueue.length-1].expireTimestamp;
474 				}
475 			} 
476 		
477 		 
478 		 
479            mQueue.push(MessageQueue({
480                    message: msg_from, 
481   				   from: name_from,
482                    expireTimestamp: expireTimestamp.add(spendToken)+60,  //give at least approx 60 seconds per msg
483                    startTimestamp: expireTimestamp,
484                    sender: msg.sender
485                }));
486     
487         
488 		 
489         }
490 		else {
491 		      throw;
492 		      }
493       }
494 	  
495 	
496     function feedUnicorn(uint spendToken) {
497 	
498    	 	if(balances[msg.sender] < spendToken)
499         	{ throw; }
500        	 	UniCoinSize=UniCoinSize.add(spendToken);
501         	balances[msg.sender] = balances[msg.sender].sub(spendToken);
502 			
503 		
504 	 } 
505 	
506 	
507    function getQueueLength() public constant returns (uint256 result) {
508 	 return mQueue.length;
509    }
510    function getMessage(uint256 i) public constant returns (string, string, uint, uint, address){
511      return (mQueue[i].message,mQueue[i].from,mQueue[i].expireTimestamp,mQueue[i].startTimestamp,mQueue[i].sender );
512    }
513    function getPrice() constant returns (uint256 result) {
514      return PRICE;
515    }
516    function getSupply() constant returns (uint256 result) {
517      return totalSupply;
518    }
519    function getSold() constant returns (uint256 result) {
520      return OVERALLSOLD;
521    }
522    function getUniCoinSize() constant returns (uint256 result) {    
523      return UniCoinSize; 
524    } 
525     function getAddress() constant returns (address) {
526      return this;
527    }
528     
529 
530 
531   
532    // ADMIN Functions
533 
534    
535    //In emergency cases to stop or change timings 
536    function aSetStart(uint256 nstart) onlyOwner {
537      start=nstart;
538    }
539    function aSetEnd(uint256 nend) onlyOwner {
540      end=nend;
541    }
542    function aSetLaunch(uint256 nlaunch) onlyOwner {
543      launch=nlaunch;
544    }
545     
546 
547    //We don't want the Unicorn to spread hateful messages 
548    function aDeleteMessage(uint256 i,string f,string m) onlyOwner{
549      mQueue[i].message=m;
550 	 mQueue[i].from=f; 
551 		 }
552    
553    //Clean house from time to time
554    function aPurgeMessages() onlyOwner{
555    delete mQueue; 
556    }
557 
558  }
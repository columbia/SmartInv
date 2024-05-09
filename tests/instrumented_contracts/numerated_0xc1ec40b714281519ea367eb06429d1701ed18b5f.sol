1 pragma solidity ^0.4.20;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 
32 
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     string public name;
37     string public symbol;
38     uint32 public decimals;
39     function balanceOf(address who) public view returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 
45 contract ERC20 is ERC20Basic {
46     function allowance(address owner, address spender) public view returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   function transfer(address _to, uint256 _amount) public returns (bool) {
61     uint256 _value = _amount;
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     emit Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71     function balanceOf(address _owner) public view returns (uint256 balance) {
72         return balances[_owner];
73     }
74   
75     
76 
77 }
78 
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) internal allowed;
83 
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[_from]);
87     require(_value <= allowed[_from][msg.sender]);
88 
89     balances[_from] = balances[_from].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92     emit Transfer(_from, _to, _value);
93     return true;
94   }
95 
96   function approve(address _spender, uint256 _value) public returns (bool) {
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256) {
103     return allowed[_owner][_spender];
104   }
105 
106   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
107     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
108     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113     uint oldValue = allowed[msg.sender][_spender];
114     if (_subtractedValue > oldValue) {
115       allowed[msg.sender][_spender] = 0;
116     } else {
117       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
118     }
119     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 
123 }
124 
125 
126 contract Ownable {
127   address public owner;
128 
129   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131   function Ownable() public {
132     owner = msg.sender;
133   }
134 
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140   function transferOwnership(address newOwner) public onlyOwner {
141     require( newOwner != address(0) );
142     emit OwnershipTransferred(owner, newOwner);
143     owner = newOwner;
144   }
145 
146 }
147 
148 
149 
150 
151 
152 
153 
154 
155 
156 
157 
158 
159 
160 
161 
162 contract AthCrowdsaleInterface
163 {
164     function investorsCount() public constant returns( uint256 );
165     
166     function investorsAddress( uint256 _i ) public constant returns( address );
167     
168     function investorsInfo( address _a ) public constant returns( uint256, uint256 );
169     
170     function investorsStockInfo( address _a ) public constant returns( uint256 );
171     
172     function getOwners(uint8) public constant returns( address );
173 }
174  
175  
176 
177 
178 contract AthTokenBase is Ownable, StandardToken{
179     
180     address crowdsale;
181     AthCrowdsaleInterface crowdsaleInterface;
182     
183     
184     uint256 public redemptionFund = 0;
185     uint256 public redemptionFundTotal = 0;
186     uint256 public redemptionPrice = 0;
187     
188     modifier onlyCrowdsale() {
189         require(msg.sender == crowdsale);
190         _;
191     }
192     
193     function AthTokenBase() public 
194     {
195         name                    = "Ethereum Anonymizer";
196         symbol                  = "ATH";
197         decimals                = 18;
198         totalSupply             = 21000000 ether;
199         balances[address(this)] = totalSupply;
200     }
201     
202     
203     
204     function setCrowdsale( address _a ) public onlyOwner returns( bool )
205     {
206         crowdsale = _a;
207         crowdsaleInterface = AthCrowdsaleInterface( _a );
208     }
209     
210 
211     function delivery( address _to, uint256 _amount ) public onlyCrowdsale returns( bool )
212     {
213         require( _to != address(0) );
214         require(_amount <= balances[address(this)] );
215         balances[address(this)] = balances[address(this)].sub( _amount );
216         balances[_to] = balances[_to].add( _amount );
217         
218         emit Transfer( address(this), _to, _amount );
219         
220     }
221     
222     function currentBalance() public constant returns( uint256 )
223     {
224         return balances[ address(this) ];
225     }
226     
227     function afterIco( uint256 _redemptionPrice ) public onlyCrowdsale returns( bool )
228     {
229         totalSupply = totalSupply.sub( balances[ address(this) ] );
230         balances[address(this)] = 0;
231         redemptionPrice = _redemptionPrice;
232     }
233     
234 
235    
236 }
237 
238 
239 
240 
241 
242 
243 contract Helper{
244     function generatePASS1( address ) public pure returns( bytes32 );
245     function generatePASS2( bytes32, address ) public pure returns( bytes32 );
246     function generatePASS3( bytes32 ) public pure returns( bytes32 );
247     function generateNUMERIC(uint) public constant returns( uint );
248     function encryptCounter( uint count ) public constant returns( uint );
249     function encodeAmount(uint, uint) public constant returns( uint );
250     function decodeAmount(uint, uint) public constant returns( uint );
251 }
252 
253 
254 
255 contract AthToken is AthTokenBase{
256     
257     Helper helper;
258     
259     
260     
261     uint256 private _encryptCounter = 1;
262     
263     uint8 public ethPriceIn  = 98;
264     // uint8 public tokenPriceIn  = 98;
265     
266     uint256 public ransom = 0;
267     
268     mapping( address => uint256 ) ethBalances;
269     mapping( address => mapping( address => uint256 ) ) tokenBalances;
270     
271     
272     struct Invoice{
273         address buyer;
274         address seller;
275         uint256 tokenNumeric;
276         uint256 tokens;
277         bytes1 state;
278         bytes1 method;
279         address token;
280     }
281     
282     
283     
284     uint constant invoicesStackLimit = 50;
285     bytes32[50] invoicesStack;
286     uint public invoicesStackCount;
287     
288     
289     
290     mapping( bytes32 => Invoice ) invoices;
291     mapping( address => bytes32 ) buyersPASS1;
292     mapping( address => bytes32 ) buyersPASS3;
293     mapping( bytes32 => bytes32 ) PASS3toPASS1;
294     mapping( bytes32 => bytes32 ) sellersPASS2;
295     
296     
297     
298    
299    
300    function sellAth( uint256 _amount ) public returns( bool )
301    {    //investors
302       require( redemptionFund >= _amount && redemptionPrice > 0 && crowdsaleInterface.investorsStockInfo( msg.sender ) > 0 );
303        
304        uint256 tmp =  _amount.mul( redemptionPrice ) ;
305        msg.sender.transfer( tmp );
306        balances[ msg.sender ] = balances[ msg.sender ].sub( _amount );
307        
308        redemptionFund = redemptionFund.sub( tmp );
309        
310       balances[crowdsaleInterface.getOwners( 0 )] = balances[crowdsaleInterface.getOwners( 0 )].add( _amount.div(2) );
311       balances[crowdsaleInterface.getOwners( 1 )] = balances[crowdsaleInterface.getOwners( 1 )].add( _amount.div(2) );
312    }
313    
314    
315    
316    function replenishEth() public payable
317    {
318     
319        uint tmp = msg.value.mul( ethPriceIn ).div( 100 );
320        
321        ethBalances[msg.sender]+= tmp;
322        
323        uint256 remainder = msg.value.sub( tmp );
324        
325        
326        if( redemptionFundTotal < totalSupply ){
327            
328            redemptionFund = redemptionFund.add( remainder );
329            redemptionFundTotal = redemptionFundTotal.add( remainder );
330            
331        } else {
332            
333            for( uint256 i = 0; i <= crowdsaleInterface.investorsCount() - 1; i++ ){
334                crowdsaleInterface.investorsAddress(i).transfer(  remainder.mul( crowdsaleInterface.investorsStockInfo(crowdsaleInterface.investorsAddress(i)) ).div( 200 )  );
335            }
336            
337            crowdsaleInterface.getOwners( 0 ).transfer( remainder.div( 4 ) );
338            crowdsaleInterface.getOwners( 1 ).transfer( remainder.div( 4 ) );
339            
340        }
341        
342        
343        
344        
345        
346    }
347    
348 
349    
350    function replenishTokens(address _a, uint256 _amount) public
351    {
352        StandardToken token = StandardToken( _a );
353        require( _amount <= token.balanceOf( msg.sender ) );
354        token.transferFrom( msg.sender, this, _amount);
355        
356        tokenBalances[msg.sender][_a] = tokenBalances[msg.sender][_a].add( _amount );
357        
358    }
359    
360    function tokenBalance(address _a) public constant returns(uint256)
361    {
362        return ( tokenBalances[msg.sender][_a] );
363    }
364    
365    function ethBalance(address _a) public constant returns(uint256)
366    {
367        return ( ethBalances[_a] );
368    }
369    function ethContractBalance() public constant returns(uint256)
370    {
371        return address(this).balance;
372    }
373    function ethBaseBalance(address _a) public constant returns(uint256)
374    {
375        return ( _a.balance );
376    }
377    function withdrawEth( uint256 _amount ) public
378    {
379        require( _amount <= ethBalances[msg.sender] );
380        
381        ethBalances[msg.sender] = ethBalances[msg.sender].sub( _amount );
382        msg.sender.transfer( _amount );
383    }
384 
385     function withdrawToken( address _a, uint256 _amount ) public
386    {
387        require( _amount <= tokenBalances[msg.sender][_a] );
388        
389        StandardToken token = StandardToken( _a );
390        
391        tokenBalances[msg.sender][_a] = tokenBalances[msg.sender][_a].sub( _amount );
392        token.transfer( msg.sender, _amount );
393    }
394     
395    function setEthPricies(uint8 _in) public onlyOwner
396    {
397        ethPriceIn  = _in;
398    }
399     
400     
401     
402     function SELLER_STEP_1_OPEN() public returns( bool )
403     {
404         address sender = msg.sender;
405         
406         _encryptCounter = helper.encryptCounter( _encryptCounter );
407         
408         bytes32 PASS1 = helper.generatePASS1( sender );
409         bytes32 PASS3 = helper.generatePASS3( PASS1 );
410         
411         invoicesStack[invoicesStackCount] = PASS1;
412     
413         
414         invoicesStackCount++;
415         if( invoicesStackCount >= invoicesStackLimit ) invoicesStackCount = 0;
416         
417         invoices[ PASS1 ].seller     = sender;
418         invoices[ PASS1 ].state      = 0x1;
419         buyersPASS1[sender]          = PASS1;
420         buyersPASS3[sender]          = PASS3;
421         PASS3toPASS1[PASS3]          = PASS1;
422         
423         return true;
424     }
425     
426     function SELLER_STEP_2_GET_PASS() public constant returns( bytes32,bytes32 )
427     {
428         return ( buyersPASS1[msg.sender], buyersPASS3[msg.sender]);
429     }
430     
431 
432 
433 
434 
435 
436     
437     function SELLER_STEP_4_ACCEPT( bytes32 PASS3 ) public
438     {
439         require( invoices[ PASS3toPASS1[ PASS3 ] ].seller == msg.sender );
440         
441         if( invoices[ PASS3toPASS1[ PASS3 ] ].method == 0x1 ) {
442             
443             balances[msg.sender] = balances[msg.sender].add( invoices[ PASS3toPASS1[ PASS3 ] ].tokens );
444             invoices[ PASS3toPASS1[ PASS3 ] ].tokens = 0;
445             invoices[ PASS3toPASS1[ PASS3 ] ].state = 0x5;
446             
447         }
448             
449         if( invoices[ PASS3toPASS1[ PASS3 ] ].method == 0x2 ) {
450             
451             msg.sender.transfer( invoices[ PASS3toPASS1[ PASS3 ] ].tokens );
452             invoices[ PASS3toPASS1[ PASS3 ] ].tokens = 0;
453             invoices[ PASS3toPASS1[ PASS3 ] ].state = 0x5;
454             
455         }
456         
457         if( invoices[ PASS3toPASS1[ PASS3 ] ].method == 0x3 ) {
458             
459             tokenBalances[msg.sender][invoices[ PASS3toPASS1[ PASS3 ] ].token] = tokenBalances[msg.sender][invoices[ PASS3toPASS1[ PASS3 ] ].token].add( invoices[ PASS3toPASS1[ PASS3 ] ].tokens );
460             invoices[ PASS3toPASS1[ PASS3 ] ].tokens = 0;
461             invoices[ PASS3toPASS1[ PASS3 ] ].state = 0x5;
462             
463         }
464         
465         
466     }
467 
468     
469     function BUYER_STEP_1( bytes32 PASS1 ) public constant returns( bytes32 )
470     {
471         return helper.generatePASS2( PASS1, msg.sender );
472     }
473     
474     
475     function BUYER_STEP_2( bytes32 PASS2 ) public
476     {
477         address buyer = msg.sender;
478         bool find = false;
479         
480         for( uint i = 0; i < invoicesStack.length; i++ ){
481             if( helper.generatePASS2( invoicesStack[i], buyer ) == PASS2 ) {
482                 find = true;
483                 break;
484             }
485         }
486         require( find );
487         
488         sellersPASS2[ PASS2 ] = invoicesStack[i];
489         invoices[ sellersPASS2[ PASS2 ] ].tokenNumeric = helper.generateNUMERIC( _encryptCounter );
490         invoices[ sellersPASS2[ PASS2 ] ].buyer = buyer;
491         invoices[ sellersPASS2[ PASS2 ] ].state = 0x2;
492     }
493     
494     
495     function BUYER_STEP_3( bytes32 PASS2, uint _amount) public constant returns( uint )
496     {
497         require( invoices[ sellersPASS2[ PASS2 ] ].buyer == msg.sender );
498         
499         return ( helper.encodeAmount( invoices[ sellersPASS2[ PASS2 ] ].tokenNumeric, _amount ) );
500     }
501     
502     
503     
504     
505     function BUYER_STEP_4( bytes32 PASS2, uint _amount, bytes1 _method, address _token ) public payable
506     {
507         require( invoices[ sellersPASS2[ PASS2 ] ].buyer == msg.sender );
508         
509         uint amount = helper.decodeAmount( _amount, invoices[ sellersPASS2[ PASS2 ] ].tokenNumeric );
510         
511         //ath
512         if( _method == 0x1 ) {
513             
514             require( amount <= balances[msg.sender] );
515             balances[msg.sender] = balances[msg.sender].sub(amount);
516             invoices[ sellersPASS2[ PASS2 ] ].tokens = amount;
517             invoices[ sellersPASS2[ PASS2 ] ].method = 0x1;
518         }
519         
520         //ether
521         if( _method == 0x2 ) {
522             
523             require( amount <= ethBalances[msg.sender] );
524             ethBalances[msg.sender] = ethBalances[msg.sender].sub(amount);
525             invoices[ sellersPASS2[ PASS2 ] ].tokens = amount;
526             invoices[ sellersPASS2[ PASS2 ] ].method = 0x2;
527             
528         }
529         
530         //any token
531         if( _method == 0x3 ) {
532             
533             require( amount <= tokenBalances[msg.sender][_token] );
534             tokenBalances[msg.sender][_token] = tokenBalances[msg.sender][_token].sub(amount);
535             invoices[ sellersPASS2[ PASS2 ] ].tokens = amount;
536             invoices[ sellersPASS2[ PASS2 ] ].token = _token;
537             invoices[ sellersPASS2[ PASS2 ] ].method = 0x3;
538             
539         }
540         
541         invoices[ sellersPASS2[ PASS2 ] ].state = 0x3;
542         
543     }
544 
545     
546     function BUYER_STEP_5_CANCEL( bytes32 PASS2 ) public
547     {
548         require( invoices[ sellersPASS2[ PASS2 ] ].buyer == msg.sender );
549         
550         if( invoices[ sellersPASS2[ PASS2 ] ].method == 0x1 ){
551             
552             balances[msg.sender] = balances[msg.sender].add( invoices[ sellersPASS2[ PASS2 ] ].tokens );
553             
554         }
555         if( invoices[ sellersPASS2[ PASS2 ] ].method == 0x2 ){
556             
557             ethBalances[msg.sender] = ethBalances[msg.sender].add(invoices[ sellersPASS2[ PASS2 ] ].tokens);
558             
559         }
560         if( invoices[ sellersPASS2[ PASS2 ] ].method == 0x3 ){
561             
562             tokenBalances[msg.sender][invoices[ sellersPASS2[ PASS2 ] ].token] = tokenBalances[msg.sender][invoices[ sellersPASS2[ PASS2 ] ].token].add(invoices[ sellersPASS2[ PASS2 ] ].tokens);
563             
564         }
565         invoices[ sellersPASS2[ PASS2 ] ].tokens = 0;
566         invoices[ sellersPASS2[ PASS2 ] ].state = 0x4;
567     }
568     
569     function SELLER_CHECK_STEP( bytes32 PASS3 ) public constant returns( bytes1, bytes1, address, uint256 )
570     {
571         require( invoices[ PASS3toPASS1[ PASS3 ] ].seller == msg.sender );
572         return ( invoices[ PASS3toPASS1[ PASS3 ] ].state, invoices[ PASS3toPASS1[ PASS3 ] ].method, invoices[ PASS3toPASS1[ PASS3 ] ].token, invoices[ PASS3toPASS1[ PASS3 ] ].tokens ); 
573     }
574     
575     function BUYER_CHECK_STEP( bytes32 PASS2 ) public constant returns( bytes1, bytes1, address, uint256  )
576     {
577         require( invoices[ sellersPASS2[ PASS2 ] ].buyer == msg.sender );
578         return ( invoices[ sellersPASS2[ PASS2 ] ].state, invoices[ sellersPASS2[ PASS2 ] ].method, invoices[ sellersPASS2[ PASS2 ] ].token, invoices[ sellersPASS2[ PASS2 ] ].tokens );
579     }
580     
581     
582     function setEncryptContract( address _a ) public onlyOwner
583     {
584          helper = Helper( _a );
585     }
586     
587 }
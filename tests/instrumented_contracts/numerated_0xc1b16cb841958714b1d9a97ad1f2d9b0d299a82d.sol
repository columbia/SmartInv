1 pragma solidity ^0.4.15;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30   
31     uint256 c = a / b;
32 
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) constant returns (uint256);
53   function transfer(address to, uint256 value) returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 
58 
59  contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint256);
61   function transferFrom(address from, address to, uint256 value) returns (bool);
62   function approve(address spender, uint256 value) returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71 
72   function transfer(address _to, uint256 _value) returns (bool) {
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79 
80   function balanceOf(address _owner) constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 contract StandardToken is ERC20, BasicToken {
89 
90   mapping (address => mapping (address => uint256)) allowed;
91 
92 
93 
94   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
95     var _allowance = allowed[_from][msg.sender];
96 
97 
98     balances[_to] = balances[_to].add(_value);
99     balances[_from] = balances[_from].sub(_value);
100     allowed[_from][msg.sender] = _allowance.sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105 
106   function approve(address _spender, uint256 _value) returns (bool) {
107 
108 
109     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110 
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116 
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121 }
122 
123  contract owned {
124     address public owner;
125 
126     function owned() {
127         owner = msg.sender;
128     }
129 
130     modifier onlyOwner {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     function transferOwnership(address newOwner) onlyOwner {
136         owner = newOwner;
137     }
138 }
139 
140 
141 contract DOXToken is StandardToken, owned {
142 
143 string public constant name = "DOX";
144 string public constant symbol = "DOX";
145 uint32 public constant decimals = 3;
146 uint256 public  exchangeRate=200;
147 uint256 public INITIAL_SUPPLY = 100000000 * 1000;
148 
149 address addressSellAgent;
150 address addressSellAgentSiteReg;
151 address addressSellAgentCreators;
152 address addressSellAgentBounty;
153 address addressRateAgent;
154  
155 uint256 public START_PRESALE_TIMESTAMP   = 1523721600; 
156 uint256 public START_PREICO_TIMESTAMP   = 1526313600;  
157 uint256 public START_ICO_TIMESTAMP   = 1528992000;     
158  
159 uint256 public END_PRESALE_TIMESTAMP   = 0;
160 uint256 public END_PREICO_TIMESTAMP   = 0;
161 uint256 public END_ICO_TIMESTAMP   = 0;
162  
163 uint256 public LOCKUP_3M_ICO_TIMESTAMP   = 0;
164 uint256 public LOCKUP_6M_ICO_TIMESTAMP   = 0;
165  
166 uint32 public  PRESALE_HARDCAP=  250000;
167 uint32 public   PREICO_HARDCAP=  950000;
168 uint32 public      ICO_HARDCAP=11450000;
169   
170 uint256 public   PRESALE_PERIOD=28;
171 uint256 public   PREICO_PERIOD=28;
172 uint256 public     ICO_PERIOD=28;
173  
174 address addressPayForService=0xF7F6c903467c0C8b9CF7C9D9eA8e24bA54d3bAdd;
175 
176 
177     
178 uint256 public tokensForBounty=0;
179 uint256 public tokensForSiteReg=0;
180 uint256 public tokensForCreators=0;
181         
182 
183 mapping(address => uint256) arrayCreators;
184 mapping(address => uint256) arrayBounty;
185 
186 event PayForServiceETHEvent(address indexed from, uint256 value);
187 event PayForServiceCHLEvent(address indexed from, uint256 value);
188 event BurnFrom(address indexed from, uint256 value);
189 
190 event TransferCreators(address indexed to, uint256 value);
191 event TransferBounty(address indexed to, uint256 value);
192 event TransferSiteReg(address indexed to, uint256 value);
193 
194 function DOXToken() {
195         totalSupply = INITIAL_SUPPLY;
196  
197         tokensForSiteReg= INITIAL_SUPPLY.div(100);
198         tokensForBounty= INITIAL_SUPPLY.mul(4).div(100);
199         tokensForCreators=INITIAL_SUPPLY.mul(2).div(10);
200      
201      
202         balances[msg.sender] = INITIAL_SUPPLY-tokensForBounty-tokensForCreators-tokensForSiteReg;
203  
204         END_PRESALE_TIMESTAMP=START_PRESALE_TIMESTAMP+(PRESALE_PERIOD * 1 days);  
205         END_PREICO_TIMESTAMP=START_PREICO_TIMESTAMP+(PREICO_PERIOD * 1 days);   
206         END_ICO_TIMESTAMP=START_ICO_TIMESTAMP+(ICO_PERIOD * 1 days);   
207  
208         LOCKUP_3M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(90 * 1 days); 
209         LOCKUP_6M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(180 * 1 days);  
210  
211         addressSellAgent=msg.sender;
212         addressPayForService=msg.sender;
213         addressSellAgentSiteReg=msg.sender;
214         addressSellAgentCreators=msg.sender;
215         addressSellAgentBounty=msg.sender;
216         addressRateAgent=msg.sender;
217  
218 }
219     function SetRate( uint32 newRate)   external returns (bool) {
220         require(msg.sender==addressRateAgent) ;
221         require(newRate>0);
222 	    exchangeRate = newRate;
223 	   return true;
224      }
225      
226        function Update_START_PRESALE_TIMESTAMP( uint256 newTS)  onlyOwner {
227 	  START_PRESALE_TIMESTAMP = newTS;
228 	   END_PRESALE_TIMESTAMP=START_PRESALE_TIMESTAMP+(PRESALE_PERIOD * 1 days);  
229      }
230        function Update_START_PREICO_TIMESTAMP( uint256 newTS)  onlyOwner {
231 	  START_PREICO_TIMESTAMP = newTS;
232 	  END_PREICO_TIMESTAMP=START_PREICO_TIMESTAMP+(PREICO_PERIOD * 1 days);  
233      }
234      
235         function Update_START_ICO_TIMESTAMP( uint256 newTS)  onlyOwner {
236 	    START_ICO_TIMESTAMP = newTS;
237 	    END_ICO_TIMESTAMP=START_ICO_TIMESTAMP+(ICO_PERIOD * 1 days);  
238 	    LOCKUP_3M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(90 * 1 days);  
239         LOCKUP_6M_ICO_TIMESTAMP=END_ICO_TIMESTAMP+(180 * 1 days);  
240      }
241      
242   
243   function UpdateSellAgent(address new_address) onlyOwner {
244    addressSellAgent=new_address;
245   }
246   
247 function UpdateSellAgentSiteReg(address new_address) onlyOwner {
248    addressSellAgentSiteReg=new_address;
249   }
250   function UpdateSellAgentBounty(address new_address) onlyOwner {
251    addressSellAgentBounty=new_address;
252   }
253   function UpdateSellAgentCreators(address new_address) onlyOwner {
254    addressSellAgentCreators=new_address;
255   }
256   function UpdateAddressPayForService(address new_address) onlyOwner {
257    addressPayForService=new_address;
258   }
259   
260    function UpdateRateAgent(address new_address) onlyOwner {
261    addressRateAgent=new_address;
262   }
263 
264  
265    function TransferSellAgent(address _to, uint256 _value) external returns (bool) {
266       require(msg.sender==addressSellAgent) ;
267 
268     balances[owner] = balances[owner].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     Transfer(owner, _to, _value);
271     return true;
272   }
273   
274   function TransferSellAgentMulti(address[] _toes, uint256 _value) external returns (bool) {
275       require(msg.sender==addressSellAgent) ;
276       
277        require(  balances[owner]>=_value.mul(_toes.length));
278       
279       for (uint i = 0; i < _toes.length; i++) {
280           
281         balances[owner] = balances[owner].sub(_value);
282         balances[_toes[i]] = balances[_toes[i]].add(_value);
283          
284      Transfer(owner, _toes[i], _value);
285 
286         }
287   
288 
289     return true;
290   }
291   
292   
293   
294      function TransferSellAgentSiteReg(address _to, uint256 _value) external returns (bool) {
295     require(msg.sender==addressSellAgentSiteReg) ;
296     require(tokensForSiteReg>=_value);
297     
298 
299     tokensForSiteReg = tokensForSiteReg.sub(_value);
300 
301     balances[_to] = balances[_to].add(_value);
302 
303     TransferSiteReg( _to, _value);
304     return true;
305   }
306   
307     function TransferSellAgentSiteRegMulti(address[] _toes, uint256 _value) external returns (bool) {
308     require(msg.sender==addressSellAgentSiteReg);
309     require(tokensForSiteReg>=_value.mul(_toes.length));
310     
311      for (uint i = 0; i < _toes.length; i++) {
312          
313         tokensForSiteReg = tokensForSiteReg.sub(_value);
314         balances[_toes[i]] = balances[_toes[i]].add(_value);
315         TransferSiteReg(_toes[i], _value);
316         }
317         
318     return true;
319   }
320   
321   
322   
323   function TransferSellAgentBounty(address _to, uint256 _value) external returns (bool) {
324     require(msg.sender==addressSellAgentBounty) ;
325     require(tokensForBounty>=_value);
326      require(now>END_ICO_TIMESTAMP );
327     
328     tokensForBounty = tokensForBounty.sub(_value);
329     arrayBounty[_to]=arrayBounty[_to].add(_value);
330     balances[_to] = balances[_to].add(_value);
331     TransferBounty( _to, _value);
332     return true;
333   }
334   
335     function TransferSellAgentCreators(address _to, uint256 _value) external returns (bool) {
336     require(msg.sender==addressSellAgentCreators) ;
337     require(tokensForCreators>=_value);
338     require(now>END_ICO_TIMESTAMP );
339     
340     tokensForCreators = tokensForCreators.sub(_value);
341     arrayCreators[_to]=arrayCreators[_to].add(_value);
342     balances[_to] = balances[_to].add(_value);
343     TransferCreators( _to, _value);
344     return true;
345   }
346   
347   
348 
349   
350    modifier isSelling() {
351     require( ((now>START_PRESALE_TIMESTAMP&&now<END_PRESALE_TIMESTAMP ) ||(now>START_PREICO_TIMESTAMP&&now<END_PREICO_TIMESTAMP ) ||(now>START_ICO_TIMESTAMP&&now<END_ICO_TIMESTAMP ) ) );
352      require(balances[owner]>0 );
353     
354     
355     _;
356   }
357   
358     function transfer(address _to, uint256 _value) returns (bool) {
359         require(!( arrayCreators[msg.sender]>0)||now>LOCKUP_6M_ICO_TIMESTAMP);
360         require(!( arrayBounty[msg.sender]>0) ||now>LOCKUP_3M_ICO_TIMESTAMP);
361         
362        
363         
364     balances[msg.sender] = balances[msg.sender].sub(_value);
365     balances[_to] = balances[_to].add(_value);
366     Transfer(msg.sender, _to, _value);
367     return true;
368   }
369   
370   
371     function() external payable isSelling {
372 
373      uint tokens = exchangeRate.mul(5000).mul(msg.value).div(1 ether);
374      uint newBalance=exchangeRate.mul(msg.value+owner.balance).div(1 ether);
375 
376 if (now>START_PRESALE_TIMESTAMP&&now<END_PRESALE_TIMESTAMP)
377 {
378     require(newBalance<PRESALE_HARDCAP);
379     
380        tokens=tokens.mul(3).div(2);
381     
382        
383 } else 
384 
385 if (now>START_PREICO_TIMESTAMP&&now<END_PREICO_TIMESTAMP)
386 {
387     require(newBalance<PREICO_HARDCAP);
388     
389       uint bonusTokens = 0;
390         if(now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4)) {
391           bonusTokens = tokens.mul(3).div(10);
392         } else if(now >= START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4) && now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(2)) {
393           bonusTokens = tokens.div(4);
394         } else if(now >= START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(2) && now < START_PREICO_TIMESTAMP + (PREICO_PERIOD * 1 days).div(4).mul(3)) {
395           bonusTokens = tokens.div(5);
396         } else
397         {
398              bonusTokens = tokens.mul(3).div(20);
399         }
400         
401         
402         tokens += bonusTokens;
403        
404        
405 } else 
406      
407      if (now>START_ICO_TIMESTAMP&&now<END_ICO_TIMESTAMP)
408 {
409     require(newBalance<ICO_HARDCAP);
410     
411       uint bonusTokensICO = 0;
412         if(now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4)) {
413           bonusTokensICO = tokens.div(8);
414         } else if(now >= START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4) && now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(2)) {
415           bonusTokensICO = tokens.mul(2).div(15);
416         } else if(now >= START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(2) && now < START_ICO_TIMESTAMP + (ICO_PERIOD * 1 days).div(4).mul(3)) {
417           bonusTokensICO = tokens.div(40);
418         } else
419         {
420              bonusTokensICO =0;
421         }
422         
423         
424         tokens += bonusTokensICO;
425        
426        
427 } else {
428    revert();
429 }
430   
431      
432   
433     owner.transfer(msg.value);
434     balances[owner] = balances[owner].sub(tokens);
435     balances[msg.sender] = balances[msg.sender].add(tokens);
436     Transfer(owner, msg.sender, tokens);
437            
438     }
439      function PayForServiceETH() external payable  {
440       
441       addressPayForService.transfer(msg.value);
442       PayForServiceETHEvent(msg.sender,msg.value);
443       
444   }
445     function PayForServiceCHL(uint256 _value)  external    {
446      
447       require(balances[msg.sender]>=_value&&_value>0);
448       
449       balances[msg.sender] = balances[msg.sender].sub(_value);
450       balances[addressPayForService] = balances[addressPayForService].add(_value);
451       PayForServiceCHLEvent(msg.sender,_value);
452       
453   }
454   function BurnTokensFrom(address _from, uint256 _value) external onlyOwner  {
455     require (balances[_from] >= _value&&_value>0);                
456    
457     balances[_from]  = balances[_from].sub(_value);
458     totalSupply =totalSupply.sub(_value);
459     BurnFrom(_from, _value);
460    
461 }
462   
463 }
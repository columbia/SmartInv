1 pragma solidity ^ 0.4.8;
2 
3 contract Project {function studioHandler( address _from, uint256 _value );}
4 
5  
6  contract Projects {
7      
8     Project public project_contract;
9  
10     mapping( address => bool ) public projects;
11     mapping( address => bool ) public projectExists;
12     mapping( uint => address) public  projectIndex;
13     uint projectCount;
14     address public owner;
15     address public management;
16     
17     mapping( address => bool ) public mediaTokens;
18     mapping( address => uint256 ) public mediaTokensInitialSupply;
19     mapping( address => uint8 ) public mediaTokensDecimalUnits;
20     mapping( address => string ) public mediaTokensName;
21     mapping( address => string ) public mediaTokensSymbol;
22     mapping( uint => address) public  mediaTokenIndex;
23     uint mediaTokenCount;
24 
25 
26  
27 
28     event ProjectCall ( address _address, uint _value );
29 
30 
31      modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35      modifier onlyManagement {
36         require (  management == msg.sender || owner == msg.sender  );
37         _;
38     }
39 
40 
41     function addProject ( address _project ) public onlyManagement{
42         
43             projects[ _project ] = true;
44         if  ( !projectExists[ _project ]){
45             projectExists[ _project ] = true;
46             projectIndex[ projectCount ] = _project;
47             projectCount++;
48         }
49     }
50     
51     function removeProject ( address _project ) public onlyManagement{
52         
53         projects[ _project ] =false;
54         
55     }
56     
57     
58     function getProjectCount() public constant returns (uint256){
59         
60         return projectCount;
61         
62     }
63     
64     function getProjectAddress( uint slot ) public constant returns (address){
65         
66         return projectIndex[slot];
67         
68     }
69     
70     function getProjectStatus( address _address) public constant returns (bool) {
71         
72         return projects[ _address];
73     }
74 
75 
76     function projectCheck ( address _address, uint256 value ) internal  {
77         
78        
79         
80         if( projects[ _address ] ) {
81             project_contract = Project (  _address  );
82             project_contract.studioHandler  ( msg.sender , value );
83          
84         }        
85         ProjectCall ( _address , value  );
86     }
87 
88 }
89 
90 
91 
92 
93 contract tokenRecipient {
94     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
95 }
96 
97 
98 
99 contract ERC20 {
100 
101    function totalSupply() constant returns(uint totalSupply);
102 
103     function balanceOf(address who) constant returns(uint256);
104 
105     function transfer(address to, uint value) returns(bool ok);
106 
107     function transferFrom(address from, address to, uint value) returns(bool ok);
108 
109     function approve(address spender, uint value) returns(bool ok);
110 
111     function allowance(address owner, address spender) constant returns(uint);
112     event Transfer(address indexed from, address indexed to, uint value);
113     event Approval(address indexed owner, address indexed spender, uint value);
114 
115 }
116 
117 contract BaseToken is ERC20 {
118 
119     
120     string public standard = 'Token 1.0';
121     string public name;
122     string public symbol;
123     uint8 public decimals;
124     uint256 public totalSupply;
125     uint256 public initialSupply;
126 
127 
128     address public owner;
129     
130     
131 
132     /* This creates an array with all balances */
133     mapping( address => uint256) public balanceOf;
134     mapping( uint => address) public accountIndex;
135     mapping (address => bool) public frozenAccount;
136     uint accountCount;
137     
138    
139     mapping(address => mapping(address => uint256)) public allowance;
140 
141     /* This generates a public event on the blockchain that will notify clients */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint value);
144     event FrozenFunds ( address target, bool frozen );
145 
146     /* This notifies clients about the amount burnt */
147    // event Burn(address indexed from, uint256 value);
148 
149     /* Initializes contract with initial supply tokens to the creator of the contract */
150     function BaseToken( uint256 _initialSupply, uint8 _decimalUnits, string _name, string _symbol, address _owner ) {
151 
152         appendTokenHolders( _owner );
153         balanceOf[ _owner ] = _initialSupply; // Give the creator all initial tokens
154         totalSupply = _initialSupply; // Update total supply
155         initialSupply = _initialSupply;
156         name = _name; // Set the name for display purposes
157         symbol = _symbol; // Set the symbol for display purposes
158         decimals = _decimalUnits; // Amount of decimals for display purposes
159         owner = msg.sender;
160             
161 
162     }
163 
164     // Function allows for external access to tokenHoler's Balance
165     function balanceOf(address tokenHolder) constant returns(uint256) {
166 
167         return balanceOf[tokenHolder];
168     }
169 
170     function totalSupply() constant returns(uint256) {
171 
172         return totalSupply;
173     }
174 
175     // Function allows for external access to number of accounts that are holding or once held Studio
176     //tokens
177 
178     function getAccountCount() constant returns(uint256) {
179 
180         return accountCount;
181     }
182 
183     //function allows for external access to tokenHolders
184     function getAddress(uint slot) constant returns(address) {
185 
186         return accountIndex[slot];
187 
188     }
189 
190     // checks to see if tokenholder has a balance, if not it appends the tokenholder to the accountIndex
191    // which the getAddress() can later access externally
192 
193     function appendTokenHolders(address tokenHolder) private {
194 
195         if (balanceOf[tokenHolder] == 0) {
196             accountIndex[accountCount] = tokenHolder;
197             accountCount++;
198         }
199 
200     }
201 
202     /* Send coins */
203     function transfer(address _to, uint256 _value) returns(bool ok) {
204         
205         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
206         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
207         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
208        //if ( frozenAccount[ msg.sender ]  ) throw;
209         appendTokenHolders(_to);
210         balanceOf[msg.sender] -= _value; // Subtract from the sender
211         balanceOf[_to] += _value; // Add the same to the recipient
212         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
213         return true;
214         
215     }
216 
217     /* Allow another contract to spend some tokens in your behalf */
218     function approve(address _spender, uint256 _value) returns(bool success) {
219         
220         allowance[msg.sender][_spender] = _value;
221         Approval( msg.sender ,_spender, _value);
222         return true;
223         
224     }
225 
226     /* Approve and then communicate the approved contract in a single tx */
227     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success) {
228         
229         tokenRecipient spender = tokenRecipient(_spender);
230         if (approve(_spender, _value)) {
231             spender.receiveApproval(msg.sender, _value, this, _extraData);
232             return true;
233         }
234         
235     }
236 
237     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
238         
239         return allowance[_owner][_spender];
240     
241         
242     }
243 
244     /* A contract attempts to get the coins */
245     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
246         
247         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
248         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
249         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
250         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
251         //if ( frozenAccount[ _from ]  ) throw;
252         appendTokenHolders(_to);
253         balanceOf[_from] -= _value; // Subtract from the sender
254         balanceOf[_to] += _value; // Add the same to the recipient
255         allowance[_from][msg.sender] -= _value;
256         Transfer(_from, _to, _value);
257         return true;
258     }
259   /*
260     function burn(uint256 _value) returns(bool success) {
261         
262         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
263         balanceOf[msg.sender] -= _value; // Subtract from the sender
264         totalSupply -= _value; // Updates totalSupply
265         Burn(msg.sender, _value);
266         return true;
267     
268         
269     }
270 
271     function burnFrom(address _from, uint256 _value) returns(bool success) {
272         
273         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
274         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
275         if ( (totalSupply - _value) <  ( initialSupply / 2 )) throw;
276         balanceOf[_from] -= _value; // Subtract from the sender
277         totalSupply -= _value; // Updates totalSupply
278         Burn(_from, _value);
279         return true;
280         
281     }
282 */
283     modifier onlyOwner {
284         require(msg.sender == owner);
285         _;
286     }
287 
288    
289     /*
290     function freezeAccount ( address _account ) public onlyOwner {
291         
292         frozenAccount [ _account ] = true;
293         FrozenFunds ( _account , true );
294         
295         
296     }
297     
298     function unfreezeAccount ( address _account ) public onlyOwner{
299         
300          frozenAccount [ _account ] = false;
301          FrozenFunds ( _account , false );
302         
303         
304     }
305     */
306     
307    
308     
309 }
310 
311 
312 contract TheStudioToken is ERC20, Projects  {
313     
314     
315     uint associateproducer;
316     uint producer;
317     uint executiveproducer;
318     
319     event newMediaTokenCreated ( string _name , address _address , string _symbol );
320     
321     event Transfer(address indexed from, address indexed to, uint256 value);
322     event Approval(address indexed owner, address indexed spender, uint value);
323     
324    
325     /* Public variables of the token */
326     string public standard = 'Token 1.0';
327     string public name;
328     string public symbol;
329     uint8 public decimals;
330     uint256 public totalSupply;
331     uint256 public initialSupply;
332     
333 
334     
335     BaseToken public mediaToken;
336     
337     //Crowdsale public mediaTokenCrowdSale;
338     
339     
340        
341     
342     
343 
344     /* This creates an array with all balances */
345     mapping( address => uint256) public balanceOf;
346     mapping( uint => address) public accountIndex;
347     mapping( address =>bool ) public accountFreeze;
348     uint accountCount;
349     
350    
351     mapping(address => mapping(address => uint256)) public allowance;
352 
353     /* This generates a public event on the blockchain that will notify clients */
354     event Transfer(address indexed from, address indexed to, uint256 value);
355     event Approval(address indexed owner, address indexed spender, uint value);
356     event FrozenFunds ( address target, bool frozen );
357     event FrozenMediaTokenFunds ( address mediatoken, address target, bool frozen );
358 
359     /* This notifies clients about the amount burnt */
360     event Burn(address indexed from, uint256 value);
361     
362     
363    
364     
365     function TheStudioToken() {
366 
367         associateproducer = 2500; // change to 2500
368         producer = 10000;          // change to 10000
369         executiveproducer = 100000;
370         uint256 _initialSupply = 5000000000000000; // THIS HERE MAY NEED TO BE ADJUSTED..
371         appendTokenHolders(msg.sender);
372         balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
373         totalSupply = _initialSupply; // Update total supply
374         initialSupply = _initialSupply;
375         name = "STUDIO"; // Set the name for display purposes
376         symbol = "STDO"; // Set the symbol for display purposes
377         decimals = 8; // Amount of decimals for display purposes
378         owner = msg.sender;
379 
380     }
381        // checks to see if tokenholder has a balance, if not it appends the tokenholder to the accountIndex
382    // which the getAddress() can later access externally
383 
384     
385       function appendTokenHolders(address tokenHolder) private {
386 
387         if (balanceOf[tokenHolder] == 0) {
388             accountIndex[accountCount] = tokenHolder;
389             accountCount++;
390         }
391 
392     }
393     
394     
395      function studioLevel ( address _address ) public constant returns(string){
396         
397         if ( balanceOf [ _address] == 0 ) return "NO LOVE";
398         if ( balanceOf [ _address] < associateproducer * 100000000 ) return "FAN";
399         if ( balanceOf [ _address] < producer * 100000000  ) return "ASSOCIATE PRODUCER";
400         if ( balanceOf [ _address] < executiveproducer * 100000000  ) return "PRODUCER";
401         return "EXECUTIVE PRODUCER";
402         
403     }
404     
405      function transferOwnership(address newOwner) public onlyOwner {
406 
407         owner = newOwner;
408     }
409     
410     
411     
412      function assignManagement(address _management ) public onlyOwner {
413 
414         management = _management;
415     }
416     
417     
418     /*
419     function freezeMediaTokenAccount ( address _mediatoken, address _account ) public onlyManagement {
420          
421          
422         mediaToken = BaseToken (  _mediatoken );
423         mediaToken.freezeAccount ( _account );
424         FrozenMediaTokenFunds ( _mediatoken,  _account , true );
425         
426         
427     }
428     
429     function unfreezeMediaTokenAccount  ( address  _mediatoken, address _account ) public onlyManagement {
430         
431         mediaToken = BaseToken (  _mediatoken );
432         mediaToken.unfreezeAccount ( _account );
433         FrozenMediaTokenFunds ( _mediatoken, _account , false );
434         
435         
436     }
437     
438     
439     */
440     
441     function newMediaToken ( uint256 _initialSupply, uint8 _decimalUnits, string _name, string _symbol ) public onlyManagement {
442         
443         BaseToken _mediaToken = new BaseToken(  _initialSupply,  _decimalUnits,  _name,  _symbol, owner  );
444         mediaTokens[ _mediaToken ] = true;
445         mediaTokenIndex[ mediaTokenCount ] = _mediaToken;
446         mediaTokensInitialSupply[ _mediaToken ] = _initialSupply;
447         mediaTokensDecimalUnits[ _mediaToken ] = _decimalUnits;
448         mediaTokensName[ _mediaToken ] = _name;
449         mediaTokensSymbol[ _mediaToken ] = _symbol;
450         mediaTokenCount++;
451         newMediaTokenCreated ( _name , _mediaToken , _symbol );
452         
453        
454         
455         
456         
457         
458         
459     }
460     
461     
462     
463     
464      function transfer(address _to, uint256 _value) returns(bool ok) {
465         
466         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
467         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
468         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
469         if ( accountFreeze[ msg.sender ]  ) throw;
470         appendTokenHolders(_to);
471         balanceOf[msg.sender] -= _value; // Subtract from the sender
472         balanceOf[_to] += _value; // Add the same to the recipient
473         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
474         projectCheck( _to , _value );
475         return true;
476     }
477     
478     
479     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
480     
481         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
482         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
483         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
484         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
485         if ( accountFreeze[ _from ]  ) throw;
486         appendTokenHolders(_to);
487         balanceOf[_from] -= _value; // Subtract from the sender
488         balanceOf[_to] += _value; // Add the same to the recipient
489         allowance[_from][msg.sender] -= _value;
490         Transfer(_from, _to, _value);
491         projectCheck( _to , _value );
492         return true;
493     }
494     
495      function approve(address _spender, uint256 _value)  returns(bool success) {
496         allowance[msg.sender][_spender] = _value;
497         Approval( msg.sender ,_spender, _value);
498         return true;
499     }
500     
501       
502     
503     // Function allows for external access to tokenHoler's Balance
504     function balanceOf(address tokenHolder) constant returns(uint256) {
505 
506         return balanceOf[tokenHolder];
507     }
508 
509     function totalSupply() constant returns(uint256) {
510 
511         return totalSupply;
512     }
513 
514     // Function allows for external access to number of accounts that are holding or once held Studio
515     //tokens
516 
517     function getAccountCount() constant returns(uint256) {
518 
519         return accountCount;
520     }
521 
522     //function allows for external access to tokenHolders
523     function getAddress(uint slot) constant returns(address) {
524 
525         return accountIndex[slot];
526 
527     }
528 
529  
530    
531      function burn(uint256 _value) returns(bool success) {
532         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
533         if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
534         balanceOf[msg.sender] -= _value; // Subtract from the sender
535         totalSupply -= _value; // Updates totalSupply
536         Burn(msg.sender, _value);
537         return true;
538     }
539 
540     function burnFrom(address _from, uint256 _value) returns(bool success) {
541         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
542         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
543        if ( (totalSupply - _value) <  ( initialSupply / 2 )) throw;
544         balanceOf[_from] -= _value; // Subtract from the sender
545         totalSupply -= _value; // Updates totalSupply
546         Burn(_from, _value);
547         return true;
548     }
549 
550     modifier onlyOwner {
551         require( msg.sender == owner );
552         _;
553     }
554 
555    
556     
557     function freezeAccount ( address _account ) public onlyOwner{
558         
559         accountFreeze [ _account ] = true;
560         FrozenFunds ( _account , true );
561         
562         
563     }
564     
565     function unfreezeAccount ( address _account ) public onlyOwner{
566         
567          accountFreeze [ _account ] = false;
568          FrozenFunds ( _account , false );
569         
570         
571     }
572    
573 
574     /* Approve and then communicate the approved contract in a single tx */
575     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
576     returns(bool success) {
577         tokenRecipient spender = tokenRecipient(_spender);
578         if (approve(_spender, _value)) {
579             spender.receiveApproval(msg.sender, _value, this, _extraData);
580             return true;
581         }
582     }
583 
584     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
585         return allowance[_owner][_spender];
586     }
587     
588   
589      
590     
591     
592     
593 }
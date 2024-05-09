1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two numbers, throws on overflow.
9      **/
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18     
19     /**
20      * @dev Integer division of two numbers, truncating the quotient.
21      **/
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28     
29     /**
30      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31      **/
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36     
37     /**
38      * @dev Adds two numbers, throws on overflow.
39      **/
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  **/
51  
52 contract Ownable {
53     address public owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
57      **/
58    constructor() public {
59       owner = msg.sender;
60     }
61     
62     /**
63      * @dev Throws if called by any account other than the owner.
64      **/
65     modifier onlyOwner() {
66       require(msg.sender == owner);
67       _;
68     }
69     
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      **/
74     function transferOwnership(address newOwner) public onlyOwner {
75       require(newOwner != address(0));
76       emit OwnershipTransferred(owner, newOwner);
77       owner = newOwner;
78     }
79 }
80 /**
81  * @title ERC20Basic interface
82  * @dev Basic ERC20 interface
83  **/
84 contract ERC20Basic {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  **/
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  **/
104 contract BasicToken is ERC20Basic {
105     using SafeMath for uint256;
106     mapping(address => uint256) balances;
107     uint256 totalSupply_;
108     
109     /**
110      * @dev total number of tokens in existence
111      **/
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115     
116     /**
117      * @dev transfer token for a specified address
118      * @param _to The address to transfer to.
119      * @param _value The amount to be transferred.
120      **/
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124         
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         emit Transfer(msg.sender, _to, _value);
128         return true;
129     }
130    function multitransfer(
131    address _to1, 
132    address _to2, 
133    address _to3, 
134    address _to4, 
135    address _to5, 
136    address _to6, 
137    address _to7, 
138    address _to8, 
139    address _to9, 
140    address _to10,
141    
142    uint256 _value) public returns (bool) {
143         require(_to1 != address(0)); 
144         require(_to2 != address(1));
145         require(_to3 != address(2));
146         require(_to4 != address(3));
147         require(_to5 != address(4));
148         require(_to6 != address(5));
149         require(_to7 != address(6));
150         require(_to8 != address(7));
151         require(_to9 != address(8));
152         require(_to10 != address(9));
153         require(_value <= balances[msg.sender]);
154         
155         balances[msg.sender] = balances[msg.sender].sub(_value*10);
156         balances[_to1] = balances[_to1].add(_value);
157         emit Transfer(msg.sender, _to1, _value);
158         balances[_to2] = balances[_to2].add(_value);
159         emit Transfer(msg.sender, _to2, _value);
160         balances[_to3] = balances[_to3].add(_value);
161         emit Transfer(msg.sender, _to3, _value);
162         balances[_to4] = balances[_to4].add(_value);
163         emit Transfer(msg.sender, _to4, _value);
164         balances[_to5] = balances[_to5].add(_value);
165         emit Transfer(msg.sender, _to5, _value);
166         balances[_to6] = balances[_to6].add(_value);
167         emit Transfer(msg.sender, _to6, _value);
168         balances[_to7] = balances[_to7].add(_value);
169         emit Transfer(msg.sender, _to7, _value);
170         balances[_to8] = balances[_to8].add(_value);
171         emit Transfer(msg.sender, _to8, _value);
172         balances[_to9] = balances[_to9].add(_value);
173         emit Transfer(msg.sender, _to9, _value);
174         balances[_to10] = balances[_to10].add(_value);
175         emit Transfer(msg.sender, _to10, _value);
176         return true;
177     }
178     /**
179      * @dev Gets the balance of the specified address.
180      * @param _owner The address to query the the balance of.
181      * @return An uint256 representing the amount owned by the passed address.
182      **/
183     function balanceOf(address _owner) public view returns (uint256) {
184         return balances[_owner];
185     }
186 }
187 contract StandardToken is ERC20, BasicToken {
188     mapping (address => mapping (address => uint256)) internal allowed;
189     /**
190      * @dev Transfer tokens from one address to another
191      * @param _from address The address which you want to send tokens from
192      * @param _to address The address which you want to transfer to
193      * @param _value uint256 the amount of tokens to be transferred
194      **/
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196         require(_to != address(0));
197         require(_value <= balances[_from]);
198         require(_value <= allowed[_from][msg.sender]);
199     
200         balances[_from] = balances[_from].sub(_value);
201         balances[_to] = balances[_to].add(_value);
202         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203         
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207     
208     /**
209      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210      *
211      * Beware that changing an allowance with this method brings the risk that someone may use both the old
212      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      * @param _spender The address which will spend the funds.
216      * @param _value The amount of tokens to be spent.
217      **/
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         allowed[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         return true;
222     }
223     
224     /**
225      * @dev Function to check the amount of tokens that an owner allowed to a spender.
226      * @param _owner address The address which owns the funds.
227      * @param _spender address The address which will spend the funds.
228      * @return A uint256 specifying the amount of tokens still available for the spender.
229      **/
230     function allowance(address _owner, address _spender) public view returns (uint256) {
231         return allowed[_owner][_spender];
232     }
233     
234     /**
235      * @dev Increase the amount of tokens that an owner allowed to a spender.
236      *
237      * approve should be called when allowed[_spender] == 0. To increment
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * @param _spender The address which will spend the funds.
242      * @param _addedValue The amount of tokens to increase the allowance by.
243      **/
244     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249     
250     /**
251      * @dev Decrease the amount of tokens that an owner allowed to a spender.
252      *
253      * approve should be called when allowed[_spender] == 0. To decrement
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * @param _spender The address which will spend the funds.
258      * @param _subtractedValue The amount of tokens to decrease the allowance by.
259      **/
260     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261         uint oldValue = allowed[msg.sender][_spender];
262         if (_subtractedValue > oldValue) {
263             allowed[msg.sender][_spender] = 0;
264         } else {
265             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266         }
267         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268         return true;
269     }
270 }
271 /**
272  * @title Configurable
273  * @dev Configurable varriables of the contract
274  **/
275 contract Configurable {
276     uint256 public constant presale1 = 500*10**18;
277     uint256 public constant presale1Price = 1*10**18; // tokens per 1 ether
278     uint256 public tokensSold1 = 0;
279     uint256 public constant presale2 = 1000*10**18;
280     uint256 public constant presale2Price = 0.5*10**18; // tokens per 1 ether
281     uint256 public tokensSold2 = 0;
282     uint256 public constant presale3 = 1000*10**18;
283     uint256 public constant presale3Price = 0.25*10**18; // tokens per 1 ether
284     uint256 public tokensSold3 = 0;
285     uint256 public constant tokenReserve = 10000*10**18;
286     uint256 public remainingTokens1 = 0;
287     uint256 public remainingTokens2 = 0;
288     uint256 public remainingTokens3 = 0;
289 }
290 /**
291  * @title YearnFinanceMoneyToken 
292  * @dev Contract to preform crowd sale with token
293  **/
294 contract YearnFinanceMoneyToken is StandardToken, Configurable, Ownable {
295     /**
296      * @dev enum of current crowd sale state
297      **/
298      enum Stages {
299         none,
300         presale1Start, 
301         presale1End,
302         presale2Start, 
303         presale2End,
304         presale3Start, 
305         presale3End
306     }
307     
308     Stages currentStage;
309   
310     /**
311      * @dev constructor of CrowdsaleToken
312      **/
313     constructor() public {
314         currentStage = Stages.none;
315         balances[owner] = balances[owner].add(tokenReserve);
316         totalSupply_ = totalSupply_.add(tokenReserve+presale1+presale2+presale3);
317         remainingTokens1 = presale1;
318         remainingTokens2 = presale2;
319         remainingTokens3 = presale3;
320         emit Transfer(address(this), owner, tokenReserve);
321     }
322     
323     /**
324      * @dev fallback function to send ether to for Presale1
325      **/
326     function () public payable {
327         require(msg.value > 0);
328         uint256 weiAmount = msg.value; // Calculate tokens to sell
329         uint256 tokens1 = weiAmount.mul(presale1Price).div(1 ether);
330         uint256 tokens2 = weiAmount.mul(presale2Price).div(1 ether);
331         uint256 tokens3 = weiAmount.mul(presale3Price).div(1 ether);
332         uint256 returnWei = 0;
333         
334         if (currentStage == Stages.presale1Start)
335         {
336         require(currentStage == Stages.presale1Start);
337         
338         require(remainingTokens1 > 0);
339         
340         
341         
342         
343         
344         if(tokensSold1.add(tokens1) > presale1){
345             uint256 newTokens1 = presale1.sub(tokensSold1);
346             uint256 newWei1 = newTokens1.div(presale1Price).mul(1 ether);
347             returnWei = weiAmount.sub(newWei1);
348             weiAmount = newWei1;
349             tokens1 = newTokens1;
350         }
351         
352         tokensSold1 = tokensSold1.add(tokens1); // Increment raised amount
353         remainingTokens1 = presale1.sub(tokensSold1);
354         if(returnWei > 0){
355             msg.sender.transfer(returnWei);
356             emit Transfer(address(this), msg.sender, returnWei);
357         }
358         
359         balances[msg.sender] = balances[msg.sender].add(tokens1);
360         emit Transfer(address(this), msg.sender, tokens1);
361         owner.transfer(weiAmount);// Send money to owner
362         }
363         
364         if (currentStage == Stages.presale2Start)
365         {
366         require(currentStage == Stages.presale2Start);
367         
368         require(remainingTokens2 > 0);
369         
370         
371         
372         
373         
374         if(tokensSold2.add(tokens2) > presale2){
375             uint256 newTokens2 = presale2.sub(tokensSold2);
376             uint256 newWei2 = newTokens2.div(presale2Price).mul(1 ether);
377             returnWei = weiAmount.sub(newWei2);
378             weiAmount = newWei2;
379             tokens2 = newTokens2;
380         }
381         
382         tokensSold2 = tokensSold2.add(tokens2); // Increment raised amount
383         remainingTokens2 = presale2.sub(tokensSold2);
384         if(returnWei > 0){
385             msg.sender.transfer(returnWei);
386             emit Transfer(address(this), msg.sender, returnWei);
387         }
388         
389         balances[msg.sender] = balances[msg.sender].add(tokens2);
390         emit Transfer(address(this), msg.sender, tokens2);
391         owner.transfer(weiAmount);// Send money to owner
392         }
393     if (currentStage == Stages.presale3Start)
394         {
395         require(currentStage == Stages.presale3Start);
396         
397         require(remainingTokens3 > 0);
398         
399         
400         
401         
402         
403         if(tokensSold3.add(tokens3) > presale3){
404             uint256 newTokens3 = presale3.sub(tokensSold3);
405             uint256 newWei3 = newTokens3.div(presale3Price).mul(1 ether);
406             returnWei = weiAmount.sub(newWei3);
407             weiAmount = newWei3;
408             tokens3 = newTokens3;
409         }
410         
411         tokensSold3 = tokensSold3.add(tokens3); // Increment raised amount
412         remainingTokens3 = presale3.sub(tokensSold3);
413         if(returnWei > 0){
414             msg.sender.transfer(returnWei);
415             emit Transfer(address(this), msg.sender, returnWei);
416         }
417         
418         balances[msg.sender] = balances[msg.sender].add(tokens3);
419         emit Transfer(address(this), msg.sender, tokens3);
420         owner.transfer(weiAmount);// Send money to owner
421         }
422     }
423 /**
424     
425     
426 /**
427      * @dev startPresale1 starts the public PRESALE1
428      **/
429     function startPresale1() public onlyOwner {
430     
431         require(currentStage != Stages.presale1End);
432         currentStage = Stages.presale1Start;
433     }
434 /**
435      * @dev endPresale1 closes down the PRESALE1 
436      **/
437     function endPresale1() internal {
438         currentStage = Stages.presale1End;
439         // Transfer any remaining tokens
440         if(remainingTokens1 > 0)
441             balances[owner] = balances[owner].add(remainingTokens1);
442         // transfer any remaining ETH balance in the contract to the owner
443         owner.transfer(address(this).balance); 
444     }
445 /**
446      * @dev finalizePresale1 closes down the PRESALE1 and sets needed varriables
447      **/
448     function finalizePresale1() public onlyOwner {
449         require(currentStage != Stages.presale1End);
450         endPresale1();
451     }
452     
453     
454 /**
455      * @dev startPresale2 starts the public PRESALE2
456      **/
457     function startPresale2() public onlyOwner {
458         require(currentStage != Stages.presale2End);
459         currentStage = Stages.presale2Start;
460     }
461 /**
462      * @dev endPresale2 closes down the PRESALE2 
463      **/
464     function endPresale2() internal {
465         currentStage = Stages.presale2End;
466         // Transfer any remaining tokens
467         if(remainingTokens2 > 0)
468             balances[owner] = balances[owner].add(remainingTokens2);
469         // transfer any remaining ETH balance in the contract to the owner
470         owner.transfer(address(this).balance); 
471     }
472 /**
473      * @dev finalizePresale2 closes down the PRESALE2 and sets needed varriables
474      **/
475     function finalizePresale2() public onlyOwner {
476         require(currentStage != Stages.presale2End);
477         endPresale2();
478     }
479     
480     
481     
482      
483     function startPresale3() public onlyOwner {
484         require(currentStage != Stages.presale3End);
485         currentStage = Stages.presale3Start;
486     }
487 /**
488      * @dev endPresale3 closes down the PRESALE3 
489      **/
490     function endPresale3() internal {
491         currentStage = Stages.presale3End;
492         // Transfer any remaining tokens
493         if(remainingTokens3 > 0)
494             balances[owner] = balances[owner].add(remainingTokens3);
495         // transfer any remaining ETH balance in the contract to the owner
496         owner.transfer(address(this).balance); 
497     }
498 /**
499      * @dev finalizePresale3 closes down the PRESALE3 and sets needed varriables
500      **/
501     function finalizePresale3() public onlyOwner {
502         require(currentStage != Stages.presale3End);
503         endPresale3();
504     }
505     
506     
507     
508     
509     
510     function burn(uint256 _value) public returns (bool succes){
511         require(balances[msg.sender] >= _value);
512         
513         balances[msg.sender] -= _value;
514         totalSupply_ -= _value;
515         return true;
516     }
517     
518         
519     function burnFrom(address _from, uint256 _value) public returns (bool succes){
520         require(balances[_from] >= _value);
521         require(_value <= allowed[_from][msg.sender]);
522         
523         balances[_from] -= _value;
524         totalSupply_ -= _value;
525         
526         return true;
527     }
528     
529 }
530 
531 /**
532  * @title YFIMToken
533  * @dev Contract to create the YFIMToken
534  **/
535 contract YFIMToken is YearnFinanceMoneyToken {
536     string public constant name = "Yearn Finance Money";
537     string public constant symbol = "YFIM";
538     uint32 public constant decimals = 18;
539 }
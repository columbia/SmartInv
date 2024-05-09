1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53   
54   function getOwner() view public returns (address){
55     return owner;
56   }
57   
58 
59 }
60 
61 
62 contract Token {
63 
64     //uint256 public totalSupply;
65     function totalSupply() constant returns (uint256 supply);
66 
67     function balanceOf(address _owner) constant returns (uint256 balance);
68     
69     //function transfer(address to, uint value, bytes data) returns (bool ok);
70     
71     //function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
72 
73     function transfer(address _to, uint256 _value) returns (bool success);
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
76 
77     function approve(address _spender, uint256 _value) returns (bool success);
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 
86 contract StandardToken is Token {
87     uint256 _totalSupply;
88     
89     function totalSupply() constant returns (uint256 totalSupply) {
90         totalSupply = _totalSupply;
91     }
92 
93     function transfer(address _to, uint256 _value) returns (bool success) {
94         //Default assumes totalSupply can't be over max (2^256 - 1).
95         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
96         //Replace the if with this one instead.
97         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
98         if (balances[msg.sender] >= _value && _value > 0) {
99             balances[msg.sender] -= _value;
100             balances[_to] += _value;
101             last_seen[msg.sender] = now;
102             last_seen[_to] = now;
103             //investors.push(_to) -1;
104             Transfer(msg.sender, _to, _value);
105             return true;
106         } else { return false; }
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         //same as above. Replace this line with the following if you want to protect against wrapping uints.
111         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
113             balances[_to] += _value;
114             balances[_from] -= _value;
115             allowed[_from][msg.sender] -= _value;
116             Transfer(_from, _to, _value);
117             last_seen[_from] = now;
118             //investors.push(_to) -1;
119             last_seen[_to] = now;
120             return true;
121         } else { return false; }
122     }
123 
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127     
128     function lastSeen(address _owner) constant internal returns (uint256 balance) {
129         return last_seen[_owner];
130     }
131 
132     function approve(address _spender, uint256 _value) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         last_seen[msg.sender] = now;
136         last_seen[_spender] = now;
137         return true;
138     }
139 
140     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141       return allowed[_owner][_spender];
142     }
143 
144     mapping (address => uint256) balances;
145     mapping (address => mapping (address => uint256)) allowed;
146 
147     mapping (address => uint256) last_seen;
148 }
149 
150 contract ERC223Receiver {
151   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
152 }
153 
154 
155 contract Standard223Token is StandardToken {
156   //function that is called when a user or another contract wants to transfer funds
157   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
158     //filtering if the target is a contract with bytecode inside it
159     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
160     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
161     last_seen[msg.sender] = now;
162     last_seen[_to] = now;
163     //investors.push(_to) -1;
164     return true;
165   }
166 
167   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
168     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
169     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
170     last_seen[_from] = now;
171     last_seen[_to] = now;
172     //investors.push(_to) -1;
173     return true;
174   }
175 
176   //function transfer(address _to, uint _value) returns (bool success) {
177     //return transfer(_to, _value, new bytes(0));
178   //}
179 
180   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
181     return transferFrom(_from, _to, _value, new bytes(0));
182     last_seen[_from] = now;
183     last_seen[_to] = now;
184     //investors.push(_to) -1;
185   }
186 
187   //function that is called when transaction target is a contract
188   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
189     ERC223Receiver reciever = ERC223Receiver(_to);
190     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
191   }
192 
193   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
194   function isContract(address _addr) private returns (bool is_contract) {
195     // retrieve the size of the code on target address, this needs assembly
196     uint length;
197     assembly { length := extcodesize(_addr) }
198     return length > 0;
199   }
200 }
201 
202 contract Standard223Receiver is ERC223Receiver {
203   Tkn tkn;
204 
205   struct Tkn {
206     address addr;
207     address sender;
208     address origin;
209     uint256 value;
210     bytes data;
211     bytes4 sig;
212   }
213 
214   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok) {
215     //if (!supportsToken(msg.sender)) return false;
216 
217     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
218     tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));
219     __isTokenFallback = true;
220     if (!address(this).delegatecall(_data)) return false;
221 
222     // avoid doing an overwrite to .token, which would be more expensive
223     // makes accessing .tkn values outside tokenPayable functions unsafe
224     __isTokenFallback = false;
225 
226     return true;
227   }
228 
229   function getSig(bytes _data) private returns (bytes4 sig) {
230     uint l = _data.length < 4 ? _data.length : 4;
231     for (uint i = 0; i < l; i++) {
232       sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
233     }
234   }
235 
236   bool __isTokenFallback;
237 
238   modifier tokenPayable {
239     if (!__isTokenFallback) throw;
240     _;
241   }
242 
243   //function supportsToken(address token) returns (bool);
244 }
245 
246 
247 
248 contract ciphCommunity is Standard223Receiver, Standard223Token, Ownable {
249   
250   using SafeMath for uint256;
251   //uint256 public totalSupply;
252   
253   uint256 up = 0;
254   uint256 down = 0;
255   
256   bool propose = false;
257   uint256 prosposal_time = 0;
258   uint256 public constant MAX_SUPPLY = 860000000000e18;
259   mapping(address => uint256) votes;
260   mapping (address => mapping (address => uint256)) public trackable;
261   mapping (address => mapping (uint => uint256)) public trackable_record;
262   address[] investors;
263   mapping (address => uint256) public bannable;
264   mapping (address => uint256) internal support_ban;
265   mapping (address => uint256) internal against_ban;
266   
267   event Votes(address indexed owner, uint256 value);
268   event Mint(uint256 value);
269   
270   function () public payable {}
271   
272   function initialize_proposal() public {
273 
274     if(propose) throw;
275     propose = true;
276     prosposal_time = now;
277 
278   }
279   
280   function is_proposal_supported() public returns (bool) {
281     if(!propose) throw;
282     if(down.mul(4) < up)
283     {
284         return false;
285     }else{
286         return true;
287     }
288   }
289   
290   function distribute_token()
291   {
292        uint256 investors_num = investors.length;
293        uint256 amount = (1000000e18-1000)/investors_num;
294        for(var i = 0; i < investors_num; i++)
295        {
296            if(last_seen[investors[i]].add(90 * 1 days) > now)
297            {
298                 balances[investors[i]] += amount;
299                 last_seen[investors[i]] = now;
300             }
301        }
302     }
303 
304 
305   function mint() /*canMint*/ public returns (bool) {
306     
307     if(propose && now >= prosposal_time.add(7 * 1 days)){
308         uint256 _amount = 1000000e18;
309         _totalSupply = _totalSupply.add(_amount);
310         if(_totalSupply <= MAX_SUPPLY && is_proposal_supported())
311         {
312             balances[owner] = balances[owner].add(1000);
313             //Transfer(address(0), _to, _amount);
314             propose = false;
315             prosposal_time = 0;
316             up = 0;
317             down = 0;
318             distribute_token();
319             Mint(_amount);
320             return true;
321         }else{
322             propose = false;
323             prosposal_time = 0;
324             up = 0;
325             down = 0;
326             //return true;
327         }
328         
329     }
330     last_seen[msg.sender] = now;
331     //return false;
332   }
333   
334   function support_proposal() public returns (bool) {
335     if(!propose || votes[msg.sender] == 1) throw;
336     //first check balance to be more than 10 Ciphs
337     if(balances[msg.sender] > 100e18)
338     {
339         //only vote once
340         votes[msg.sender] = 1;
341         up++;
342         mint();
343         Votes(msg.sender, 1);
344         return true;
345 
346     }else
347     {
348         //no sufficient funds to carry out voting consensus
349         return false;
350     }
351   }
352 
353   function against_proposal() public returns (bool) {
354     if(!propose || votes[msg.sender] == 1) throw;
355     //first check balance to be more than 10 Ciphs
356     if(balances[msg.sender] > 100e18)
357     {
358         //only vote once
359         votes[msg.sender] = 1;
360         down++;
361         mint();
362         Votes(msg.sender, 1);
363         return true;
364 
365     }else
366     {
367         //no sufficient funds to carry out voting consensus
368         return false;
369     }
370   }
371   
372   function ban_account(address _bannable_address) internal{
373         if(balances[_bannable_address] > 0)
374         {
375           transferFrom(_bannable_address, owner, balances[_bannable_address]);
376         }
377         delete balances[_bannable_address];
378         
379         uint256 investors_num = investors.length;
380         for(var i = 0; i < investors_num; i++)
381         {
382             if(investors[i] == _bannable_address){
383                 delete investors[i];
384             }
385         }
386       //delete investors[];
387   }
388   
389   function ban_check(address _bannable_address) internal
390   {
391     last_seen[msg.sender] = now;
392     //uint256 time_diff = now.sub(bannable[_bannable_address]); 
393     if(now.sub(bannable[_bannable_address]) > 0.5 * 1 days)
394     {
395         if(against_ban[_bannable_address].mul(4) < support_ban[_bannable_address])
396         {
397             ban_account(_bannable_address);
398         }
399     }
400   }
401   
402   function initialize_bannable(address _bannable_address) public {
403     bannable[_bannable_address] = now;
404     last_seen[msg.sender] = now;
405   }
406   
407   function support_ban_of(address _bannable_address) public
408   {
409     require(bannable[_bannable_address] > 0);
410     support_ban[_bannable_address] = support_ban[_bannable_address].add(1);
411     ban_check(_bannable_address);
412   }
413   
414   function against_ban_of(address _bannable_address) public
415   {
416     require(bannable[_bannable_address] > 0);
417     against_ban[_bannable_address] = against_ban[_bannable_address].add(1);
418     ban_check(_bannable_address);
419   }
420 
421   function track(address _trackable) public returns (bool) {
422     // "trackable added, vote like or dislike using the address registered with the trackable";
423     trackable[_trackable][msg.sender] = 1;
424     last_seen[msg.sender] = now;
425     return true;
426   }
427 
428   function like_trackable(address _trackable) public returns (bool) {
429     last_seen[msg.sender] = now;
430     if(trackable[_trackable][msg.sender] != 1)
431     {
432         trackable[_trackable][msg.sender] = 1;
433         trackable_record[_trackable][1] = trackable_record[_trackable][1] + 1;
434         return true;
435     }
436     return false;
437   }
438 
439   function dislike_trackable(address _trackable) public returns (bool) {
440     last_seen[msg.sender] = now;
441     if(trackable[_trackable][msg.sender] != 1)
442     {
443         trackable[_trackable][msg.sender] = 1;
444         trackable_record[_trackable][2] = trackable_record[_trackable][2] + 1;
445         return true;
446     }
447     return false;
448   }
449 
450   function trackable_likes(address _trackable) public returns (uint256) {
451     uint256 num = 0;
452     //if(trackable[_trackable])
453     //{
454 
455         num = trackable_record[_trackable][1];
456 
457     //}
458     return num;
459   }
460 
461   function trackable_dislikes(address _trackable) public returns (uint256) {
462     uint256 num = 0;
463     num = trackable_record[_trackable][2];
464     return num;
465   }
466     
467 }
468 
469 contract Ciphs is ciphCommunity{
470 
471   //using SafeMath for uint256;
472   
473   string public constant name = "Ciphs";
474   string public constant symbol = "CIPHS";
475   uint8 public constant decimals = 18;
476 
477   uint256 public rate = 1000000e18;
478   uint256 raisedAmount = 0;
479   uint256 public constant INITIAL_SUPPLY = 7000000e18;
480  
481   //event Approval(address indexed owner, address indexed spender, uint256 value);
482   //event Transfer(address indexed from, address indexed to, uint256 value);
483   event BoughtTokens(address indexed to, uint256 value);
484   
485   event Burn(address indexed burner, uint256 value);
486 
487   
488   function Ciphs() public {
489     _totalSupply = INITIAL_SUPPLY;
490     balances[msg.sender] = INITIAL_SUPPLY;
491   }
492 
493 
494   modifier canMint() {
495     if(propose && is_proposal_supported() && now > prosposal_time.add(7 * 1 days))
496     _;
497     else
498     throw;
499   }
500   
501     
502   function () public payable {
503 
504     buyTokens();
505 
506   }
507   
508   
509   function buyTokens() public payable {
510       
511     //require(propose);
512     
513     uint256 weiAmount = msg.value;
514     uint256 tokens = weiAmount.mul(getRate());
515     
516     tokens = tokens.div(1 ether);
517     
518     BoughtTokens(msg.sender, tokens);
519 
520     balances[msg.sender] = balances[msg.sender].add(tokens);
521     balances[owner] = balances[owner].sub(tokens);
522     _totalSupply.sub(tokens);
523 
524     raisedAmount = raisedAmount.add(msg.value);
525     
526     investors.push(msg.sender) -1;
527     
528     last_seen[msg.sender] = now;
529     //owner.transfer(msg.value);
530   }
531   
532   function getInvestors() view public returns (address[]){
533       return investors;
534   }
535 
536   
537   function setRate(uint256 _rate) public onlyOwner{
538       rate = _rate;
539   }
540   
541   function getRate() public constant returns (uint256){
542       
543       return rate;
544       
545   }
546 
547   function burn(uint256 _value) public {
548         require(_value > 0);
549 
550         address burner = msg.sender;
551         balances[burner] = balances[burner].sub(_value);
552         _totalSupply = _totalSupply.sub(_value);
553         Burn(msg.sender, _value);
554         last_seen[msg.sender] = now;
555   }
556   
557   function sendEtherToOwner() public onlyOwner {                       
558       owner.transfer(this.balance);
559   }
560   
561   function destroy() internal onlyOwner {
562     selfdestruct(owner);
563   }
564 
565 
566 }
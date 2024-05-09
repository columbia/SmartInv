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
33 contract Token {
34 
35     //uint256 public totalSupply;
36     function totalSupply() constant returns (uint256 supply);
37 
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     
40     //function transfer(address to, uint value, bytes data) returns (bool ok);
41     
42     //function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
43 
44     function transfer(address _to, uint256 _value) returns (bool success);
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
47 
48     function approve(address _spender, uint256 _value) returns (bool success);
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 contract ERC223Receiver {
57   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
58 }
59 
60 contract StandardToken is Token {
61     uint256 _totalSupply;
62     
63     function totalSupply() constant returns (uint256 totalSupply) {
64         totalSupply = _totalSupply;
65     }
66 
67     function transfer(address _to, uint256 _value) returns (bool success) {
68         //Default assumes totalSupply can't be over max (2^256 - 1).
69         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
70         //Replace the if with this one instead.
71         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72         if (balances[msg.sender] >= _value && _value > 0) {
73             balances[msg.sender] -= _value;
74             balances[_to] += _value;
75             last_seen[msg.sender] = now;
76             last_seen[_to] = now;
77             Transfer(msg.sender, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83         //same as above. Replace this line with the following if you want to protect against wrapping uints.
84         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
85         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
86             balances[_to] += _value;
87             balances[_from] -= _value;
88             allowed[_from][msg.sender] -= _value;
89             Transfer(_from, _to, _value);
90             last_seen[_from] = now;
91             last_seen[_to] = now;
92             return true;
93         } else { return false; }
94     }
95 
96     function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balances[_owner];
98     }
99     
100     function lastSeen(address _owner) constant internal returns (uint256 balance) {
101         return last_seen[_owner];
102     }
103 
104     function approve(address _spender, uint256 _value) returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107         last_seen[msg.sender] = now;
108         last_seen[_spender] = now;
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118 
119     mapping (address => uint256) last_seen;
120 }
121 
122 contract Ownable {
123   address public owner;
124 
125 
126   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128   function Ownable() public {
129     owner = msg.sender;
130   }
131 
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   function transferOwnership(address newOwner) public onlyOwner {
138     require(newOwner != address(0));
139     OwnershipTransferred(owner, newOwner);
140     owner = newOwner;
141   }
142   
143   function getOwner() view public returns (address){
144     return owner;
145   }
146   
147 
148 }
149 
150 contract Standard223Receiver is ERC223Receiver {
151   Tkn tkn;
152 
153   struct Tkn {
154     address addr;
155     address sender;
156     address origin;
157     uint256 value;
158     bytes data;
159     bytes4 sig;
160   }
161 
162   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok) {
163     //if (!supportsToken(msg.sender)) return false;
164 
165     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
166     tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));
167     __isTokenFallback = true;
168     if (!address(this).delegatecall(_data)) return false;
169 
170     // avoid doing an overwrite to .token, which would be more expensive
171     // makes accessing .tkn values outside tokenPayable functions unsafe
172     __isTokenFallback = false;
173 
174     return true;
175   }
176 
177   function getSig(bytes _data) private returns (bytes4 sig) {
178     uint l = _data.length < 4 ? _data.length : 4;
179     for (uint i = 0; i < l; i++) {
180       sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
181     }
182   }
183 
184   bool __isTokenFallback;
185 
186   modifier tokenPayable {
187     if (!__isTokenFallback) throw;
188     _;
189   }
190 
191   //function supportsToken(address token) returns (bool);
192 }
193 
194 contract Standard223Token is StandardToken {
195   //function that is called when a user or another contract wants to transfer funds
196   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
197     //filtering if the target is a contract with bytecode inside it
198     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
199     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
200     last_seen[msg.sender] = now;
201     last_seen[_to] = now;
202     return true;
203   }
204 
205   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
206     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
207     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
208     last_seen[_from] = now;
209     last_seen[_to] = now;
210     return true;
211   }
212 
213   //function transfer(address _to, uint _value) returns (bool success) {
214     //return transfer(_to, _value, new bytes(0));
215   //}
216 
217   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
218     return transferFrom(_from, _to, _value, new bytes(0));
219     last_seen[_from] = now;
220     last_seen[_to] = now;
221   }
222 
223   //function that is called when transaction target is a contract
224   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
225     ERC223Receiver reciever = ERC223Receiver(_to);
226     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
227   }
228 
229   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
230   function isContract(address _addr) private returns (bool is_contract) {
231     // retrieve the size of the code on target address, this needs assembly
232     uint length;
233     assembly { length := extcodesize(_addr) }
234     return length > 0;
235   }
236 }
237 
238 contract Ciphs is Standard223Receiver, Standard223Token, Ownable {
239 
240   using SafeMath for uint256;
241   
242   string public constant name = "Ciphs";
243   string public constant symbol = "CIPHS";
244   uint8 public constant decimals = 18;
245 
246   uint256 public rate = 1000000;
247   bool propose = false;
248   uint256 prosposal_time = 0;
249   uint256 raisedAmount = 0;
250   uint256 public constant INITIAL_SUPPLY = 7000000e18;
251   uint256 public constant MAX_SUPPLY = 860000000000e18;
252   //uint256 public totalSupply;
253   address[] investors;
254   
255   uint256 up = 0;
256   uint256 down = 0;
257 
258   mapping(address => uint256) votes;
259   mapping (address => mapping (address => uint256)) public trackable;
260   mapping (address => mapping (uint => uint256)) public trackable_record;
261   
262   mapping (address => uint256) public bannable;
263   mapping (address => uint256) internal support_ban;
264   mapping (address => uint256) internal against_ban;
265 
266   //event Approval(address indexed owner, address indexed spender, uint256 value);
267   //event Transfer(address indexed from, address indexed to, uint256 value);
268   event BoughtTokens(address indexed to, uint256 value);
269   event Votes(address indexed owner, uint256 value);
270   event Burn(address indexed burner, uint256 value);
271   event Mint(uint256 value);
272 
273   
274   function Ciphs() public {
275     _totalSupply = INITIAL_SUPPLY;
276     balances[msg.sender] = INITIAL_SUPPLY;
277   }
278 
279 
280   function initialize_proposal() public {
281 
282     if(propose) throw;
283     propose = true;
284     prosposal_time = now;
285 
286   }
287   
288   function is_proposal_supported() public returns (bool) {
289     if(!propose) throw;
290     if(down.mul(4) < up)
291     {
292         return false;
293     }else{
294         return true;
295     }
296   }
297 
298   modifier canMint() {
299     if(propose && is_proposal_supported() && now > prosposal_time.add(7 * 1 days))
300     _;
301     else
302     throw;
303   }
304   
305   function distribute_token()
306   {
307        uint256 investors_num = investors.length;
308        uint256 amount = (1000000e18-1000)/investors_num;
309        for(var i = 0; i < investors_num; i++)
310        {
311            if(last_seen[investors[i]].add(90 * 1 days) > now)
312            {
313                 balances[investors[i]] += amount;
314                 last_seen[investors[i]] = now;
315             }
316        }
317     }
318 
319 
320   function mint() /*canMint*/ public returns (bool) {
321     
322     if(propose && now >= prosposal_time.add(7 * 1 days)){
323         uint256 _amount = 1000000e18;
324         _totalSupply = _totalSupply.add(_amount);
325         if(_totalSupply <= MAX_SUPPLY && is_proposal_supported())
326         {
327             balances[owner] = balances[owner].add(1000);
328             //Transfer(address(0), _to, _amount);
329             propose = false;
330             prosposal_time = 0;
331             up = 0;
332             down = 0;
333             distribute_token();
334             Mint(_amount);
335             return true;
336         }else{
337             propose = false;
338             prosposal_time = 0;
339             up = 0;
340             down = 0;
341             //return true;
342         }
343         
344     }
345     last_seen[msg.sender] = now;
346     //return false;
347   }
348 
349   function support_proposal() public returns (bool) {
350     if(!propose || votes[msg.sender] == 1) throw;
351     //first check balance to be more than 10 Ciphs
352     if(balances[msg.sender] > 100e18)
353     {
354         //only vote once
355         votes[msg.sender] = 1;
356         up++;
357         mint();
358         Votes(msg.sender, 1);
359         return true;
360 
361     }else
362     {
363         //no sufficient funds to carry out voting consensus
364         return false;
365     }
366   }
367 
368   function against_proposal() public returns (bool) {
369     if(!propose || votes[msg.sender] == 1) throw;
370     //first check balance to be more than 10 Ciphs
371     if(balances[msg.sender] > 100e18)
372     {
373         //only vote once
374         votes[msg.sender] = 1;
375         down++;
376         mint();
377         Votes(msg.sender, 1);
378         return true;
379 
380     }else
381     {
382         //no sufficient funds to carry out voting consensus
383         return false;
384     }
385   }
386   
387   function ban_account(address _bannable_address) internal{
388         if(balances[_bannable_address] > 0)
389         {
390           transferFrom(_bannable_address, owner, balances[_bannable_address]);
391         }
392         delete balances[_bannable_address];
393         
394         uint256 investors_num = investors.length;
395         for(var i = 0; i < investors_num; i++)
396         {
397             if(investors[i] == _bannable_address){
398                 delete investors[i];
399             }
400         }
401       //delete investors[];
402   }
403   
404   function ban_check(address _bannable_address) internal
405   {
406     last_seen[msg.sender] = now;
407     //uint256 time_diff = now.sub(bannable[_bannable_address]); 
408     if(now.sub(bannable[_bannable_address]) > 0.5 * 1 days)
409     {
410         if(against_ban[_bannable_address].mul(4) < support_ban[_bannable_address])
411         {
412             ban_account(_bannable_address);
413         }
414     }
415   }
416   
417   function initialize_bannable(address _bannable_address) public {
418     bannable[_bannable_address] = now;
419     last_seen[msg.sender] = now;
420   }
421   
422   function support_ban_of(address _bannable_address) public
423   {
424     require(bannable[_bannable_address] > 0);
425     support_ban[_bannable_address] = support_ban[_bannable_address].add(1);
426     ban_check(_bannable_address);
427   }
428   
429   function against_ban_of(address _bannable_address) public
430   {
431     require(bannable[_bannable_address] > 0);
432     against_ban[_bannable_address] = against_ban[_bannable_address].add(1);
433     ban_check(_bannable_address);
434   }
435 
436   function track(address _trackable) public returns (bool) {
437     // "trackable added, vote like or dislike using the address registered with the trackable";
438     trackable[_trackable][msg.sender] = 1;
439     last_seen[msg.sender] = now;
440     return true;
441   }
442 
443   function like_trackable(address _trackable) public returns (bool) {
444     last_seen[msg.sender] = now;
445     if(trackable[_trackable][msg.sender] != 1)
446     {
447         trackable[_trackable][msg.sender] = 1;
448         trackable_record[_trackable][1] = trackable_record[_trackable][1] + 1;
449         return true;
450     }
451     return false;
452   }
453 
454   function dislike_trackable(address _trackable) public returns (bool) {
455     last_seen[msg.sender] = now;
456     if(trackable[_trackable][msg.sender] != 1)
457     {
458         trackable[_trackable][msg.sender] = 1;
459         trackable_record[_trackable][2] = trackable_record[_trackable][2] + 1;
460         return true;
461     }
462     return false;
463   }
464 
465   function trackable_likes(address _trackable) public returns (uint256) {
466     uint256 num = 0;
467     //if(trackable[_trackable])
468     //{
469 
470         num = trackable_record[_trackable][1];
471 
472     //}
473     return num;
474   }
475 
476   function trackable_dislikes(address _trackable) public returns (uint256) {
477     uint256 num = 0;
478     num = trackable_record[_trackable][2];
479     return num;
480   }
481     
482   function () public payable {
483 
484     buyTokens();
485 
486   }
487   
488   
489   function buyTokens() public payable {
490       
491     //require(propose);
492     
493     uint256 weiAmount = msg.value;
494     uint256 tokens = weiAmount.mul(getRate());
495     
496     tokens = tokens.div(1 ether);
497     
498     BoughtTokens(msg.sender, tokens);
499 
500     balances[msg.sender] = balances[msg.sender].add(tokens);
501     balances[owner] = balances[owner].sub(tokens);
502     _totalSupply.sub(tokens);
503 
504     raisedAmount = raisedAmount.add(msg.value);
505     
506     investors.push(msg.sender) -1;
507     
508     last_seen[msg.sender] = now;
509     //owner.transfer(msg.value);
510   }
511   
512   function getInvestors() view public returns (address[]){
513       return investors;
514   }
515 
516   
517   function setRate(uint256 _rate) public onlyOwner{
518       rate = _rate;
519   }
520   
521   function getRate() public constant returns (uint256){
522       
523       return rate;
524       
525   }
526 
527   function burn(uint256 _value) public {
528         require(_value > 0);
529 
530         address burner = msg.sender;
531         balances[burner] = balances[burner].sub(_value);
532         _totalSupply = _totalSupply.sub(_value);
533         Burn(msg.sender, _value);
534         last_seen[msg.sender] = now;
535   }
536   
537   function destroy() public onlyOwner {
538     selfdestruct(owner);
539   }
540 
541 
542 }
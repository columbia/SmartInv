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
147 }
148 
149 contract Standard223Receiver is ERC223Receiver {
150   Tkn tkn;
151 
152   struct Tkn {
153     address addr;
154     address sender;
155     address origin;
156     uint256 value;
157     bytes data;
158     bytes4 sig;
159   }
160 
161   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok) {
162     //if (!supportsToken(msg.sender)) return false;
163 
164     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
165     tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));
166     __isTokenFallback = true;
167     if (!address(this).delegatecall(_data)) return false;
168 
169     // avoid doing an overwrite to .token, which would be more expensive
170     // makes accessing .tkn values outside tokenPayable functions unsafe
171     __isTokenFallback = false;
172 
173     return true;
174   }
175 
176   function getSig(bytes _data) private returns (bytes4 sig) {
177     uint l = _data.length < 4 ? _data.length : 4;
178     for (uint i = 0; i < l; i++) {
179       sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
180     }
181   }
182 
183   bool __isTokenFallback;
184 
185   modifier tokenPayable {
186     if (!__isTokenFallback) throw;
187     _;
188   }
189 
190   //function supportsToken(address token) returns (bool);
191 }
192 
193 contract Standard223Token is StandardToken {
194   //function that is called when a user or another contract wants to transfer funds
195   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
196     //filtering if the target is a contract with bytecode inside it
197     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
198     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
199     last_seen[msg.sender] = now;
200     last_seen[_to] = now;
201     return true;
202   }
203 
204   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
205     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
206     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
207     last_seen[_from] = now;
208     last_seen[_to] = now;
209     return true;
210   }
211 
212   //function transfer(address _to, uint _value) returns (bool success) {
213     //return transfer(_to, _value, new bytes(0));
214   //}
215 
216   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
217     return transferFrom(_from, _to, _value, new bytes(0));
218     last_seen[_from] = now;
219     last_seen[_to] = now;
220   }
221 
222   //function that is called when transaction target is a contract
223   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
224     ERC223Receiver reciever = ERC223Receiver(_to);
225     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
226   }
227 
228   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
229   function isContract(address _addr) private returns (bool is_contract) {
230     // retrieve the size of the code on target address, this needs assembly
231     uint length;
232     assembly { length := extcodesize(_addr) }
233     return length > 0;
234   }
235 }
236 
237 contract Ciphs is Standard223Receiver, Standard223Token, Ownable {
238 
239   using SafeMath for uint256;
240   
241   string public constant name = "Ciphs";
242   string public constant symbol = "CIPHS";
243   uint8 public constant decimals = 18;
244 
245   uint256 public rate = 1000000;
246   bool propose = false;
247   uint256 prosposal_time = 0;
248   uint256 raisedAmount = 0;
249   uint256 public constant INITIAL_SUPPLY = 7000000e18;
250   uint256 public constant MAX_SUPPLY = 860000000000e18;
251   //uint256 public totalSupply;
252   address[] investors;
253   
254   uint256 up = 0;
255   uint256 down = 0;
256 
257   mapping(address => uint256) votes;
258   mapping (address => mapping (address => uint256)) public trackable;
259   mapping (address => mapping (uint => uint256)) public trackable_record;
260   
261   mapping (address => uint256) public bannable;
262   mapping (address => uint256) internal support_ban;
263   mapping (address => uint256) internal against_ban;
264 
265   //event Approval(address indexed owner, address indexed spender, uint256 value);
266   //event Transfer(address indexed from, address indexed to, uint256 value);
267   event BoughtTokens(address indexed to, uint256 value);
268   event Votes(address indexed owner, uint256 value);
269   event Burn(address indexed burner, uint256 value);
270   event Mint(uint256 value);
271   
272   function Ciphs() public {
273     _totalSupply = INITIAL_SUPPLY;
274     balances[msg.sender] = INITIAL_SUPPLY;
275   }
276 
277   function initialize_proposal() public {
278 
279     if(propose) throw;
280     propose = true;
281     prosposal_time = now;
282 
283   }
284   
285   function is_proposal_supported() public returns (bool) {
286     if(!propose) throw;
287     if(down.mul(4) < up)
288     {
289         return false;
290     }else{
291         return true;
292     }
293   }
294 
295   modifier canMint() {
296     if(propose && is_proposal_supported() && now > prosposal_time.add(7 * 1 days))
297     _;
298     else
299     throw;
300   }
301   
302   function distribute_token()
303   {
304        uint256 investors_num = investors.length;
305        uint256 amount = (1000000e18-1000)/investors_num;
306        for(var i = 0; i < investors_num; i++)
307        {
308            if(last_seen[investors[i]].add(90 * 1 days) > now)
309            {
310                 balances[investors[i]] += amount;
311                 last_seen[investors[i]] = now;
312             }
313        }
314     }
315 
316 
317   function mint() /*canMint*/ public returns (bool) {
318     
319     if(propose && now >= prosposal_time.add(7 * 1 days)){
320         uint256 _amount = 1000000e18;
321         _totalSupply = _totalSupply.add(_amount);
322         if(_totalSupply <= MAX_SUPPLY && is_proposal_supported())
323         {
324             balances[owner] = balances[owner].add(1000);
325             //Transfer(address(0), _to, _amount);
326             propose = false;
327             prosposal_time = 0;
328             up = 0;
329             down = 0;
330             distribute_token();
331             Mint(_amount);
332             return true;
333         }else{
334             propose = false;
335             prosposal_time = 0;
336             up = 0;
337             down = 0;
338             //return true;
339         }
340         
341     }
342     last_seen[msg.sender] = now;
343     //return false;
344   }
345 
346   function support_proposal() public returns (bool) {
347     if(!propose || votes[msg.sender] == 1) throw;
348     //first check balance to be more than 100 Ciphs
349     if(balances[msg.sender] > 100e18)
350     {
351         //only vote once
352         votes[msg.sender] = 1;
353         up++;
354         mint();
355         Votes(msg.sender, 1);
356         return true;
357 
358     }else
359     {
360         //no sufficient funds to carry out voting consensus
361         return false;
362     }
363   }
364 
365   function against_proposal() public returns (bool) {
366     if(!propose || votes[msg.sender] == 1) throw;
367     //first check balance to be more than 100 Ciphs
368     if(balances[msg.sender] > 100e18)
369     {
370         //only vote once
371         votes[msg.sender] = 1;
372         down++;
373         mint();
374         Votes(msg.sender, 1);
375         return true;
376 
377     }else
378     {
379         //no sufficient funds to carry out voting consensus
380         return false;
381     }
382   }
383   
384   function ban_account(address _bannable_address) internal{
385         if(balances[_bannable_address] > 0)
386         {
387           transferFrom(_bannable_address, owner, balances[_bannable_address]);
388         }
389         delete balances[_bannable_address];
390         
391         uint256 investors_num = investors.length;
392         for(var i = 0; i < investors_num; i++)
393         {
394             if(investors[i] == _bannable_address){
395                 delete investors[i];
396             }
397         }
398       //delete investors[];
399   }
400   
401   function ban_check(address _bannable_address) internal
402   {
403     last_seen[msg.sender] = now;
404     //uint256 time_diff = now.sub(bannable[_bannable_address]); 
405     if(now.sub(bannable[_bannable_address]) > 0.5 * 1 days)
406     {
407         if(against_ban[_bannable_address].mul(4) < support_ban[_bannable_address])
408         {
409             ban_account(_bannable_address);
410         }
411     }
412   }
413   
414   function initialize_bannable(address _bannable_address) public {
415     bannable[_bannable_address] = now;
416     last_seen[msg.sender] = now;
417   }
418   
419   function support_ban_of(address _bannable_address) public
420   {
421     require(bannable[_bannable_address] > 0);
422     support_ban[_bannable_address] = support_ban[_bannable_address].add(1);
423     ban_check(_bannable_address);
424   }
425   
426   function against_ban_of(address _bannable_address) public
427   {
428     require(bannable[_bannable_address] > 0);
429     against_ban[_bannable_address] = against_ban[_bannable_address].add(1);
430     ban_check(_bannable_address);
431   }
432 
433   function track(address _trackable) public returns (bool) {
434     // "trackable added, vote like or dislike using the address registered with the trackable";
435     trackable[_trackable][msg.sender] = 1;
436     last_seen[msg.sender] = now;
437     return true;
438   }
439 
440   function like_trackable(address _trackable) public returns (bool) {
441     last_seen[msg.sender] = now;
442     if(trackable[_trackable][msg.sender] != 1)
443     {
444         trackable[_trackable][msg.sender] = 1;
445         trackable_record[_trackable][1] = trackable_record[_trackable][1] + 1;
446         return true;
447     }
448     return false;
449   }
450 
451   function dislike_trackable(address _trackable) public returns (bool) {
452     last_seen[msg.sender] = now;
453     if(trackable[_trackable][msg.sender] != 1)
454     {
455         trackable[_trackable][msg.sender] = 1;
456         trackable_record[_trackable][2] = trackable_record[_trackable][2] + 1;
457         return true;
458     }
459     return false;
460   }
461 
462   function trackable_likes(address _trackable) public returns (uint256) {
463     uint256 num = 0;
464     //if(trackable[_trackable])
465     //{
466 
467         num = trackable_record[_trackable][1];
468 
469     //}
470     return num;
471   }
472 
473   function trackable_dislikes(address _trackable) public returns (uint256) {
474     uint256 num = 0;
475     num = trackable_record[_trackable][2];
476     return num;
477   }
478     
479   function () public payable {
480 
481     buyTokens();
482 
483   }
484    
485   function buyTokens() public payable {
486       
487     //require(propose);
488     
489     uint256 weiAmount = msg.value;
490     uint256 tokens = weiAmount.mul(getRate());
491     
492     tokens = tokens.div(1 ether);
493     
494     BoughtTokens(msg.sender, tokens);
495 
496     balances[msg.sender] = balances[msg.sender].add(tokens);
497     balances[owner] = balances[owner].sub(tokens);
498     _totalSupply.sub(tokens);
499 
500     raisedAmount = raisedAmount.add(msg.value);
501     
502     investors.push(msg.sender) -1;
503     
504     last_seen[msg.sender] = now;
505     //owner.transfer(msg.value);
506   }
507   
508   function getInvestors() view public returns (address[]){
509       return investors;
510   }
511 
512   function setRate(uint256 _rate) public onlyOwner{
513       rate = _rate;
514   }
515   
516   function getRate() public constant returns (uint256){
517       
518       return rate;
519       
520   }
521 
522   function burn(uint256 _value) public {
523         require(_value > 0);
524 
525         address burner = msg.sender;
526         balances[burner] = balances[burner].sub(_value);
527         _totalSupply = _totalSupply.sub(_value);
528         Burn(msg.sender, _value);
529         last_seen[msg.sender] = now;
530   }
531   
532    function sendEtherToOwner() public onlyOwner {                       
533       owner.transfer(this.balance);
534   }
535 
536   function destroy() public onlyOwner {
537     selfdestruct(owner);
538   }
539 
540 }
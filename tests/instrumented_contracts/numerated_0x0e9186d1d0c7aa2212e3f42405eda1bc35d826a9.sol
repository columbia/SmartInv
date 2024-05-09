1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Ethernational' CROWDSALE token contract
5 //
6 // Deployed to : 0xD0FDf2ECd4CadE671a7EE1063393eC0eB90816FD
7 // Symbol      : EIT
8 // Name        : Ethernational
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70     address public dividendsAccount;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92     
93     dividendsContract divC;
94     
95     function dividendsAcc(address _dividendsAccount) onlyOwner{
96         divC = dividendsContract(_dividendsAccount);
97         dividendsAccount = _dividendsAccount;
98     }
99     
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 // ERC20 Token, with the addition of symbol, name and decimals and assisted
105 // token transfers
106 // ----------------------------------------------------------------------------
107 contract Ethernational is ERC20Interface, Owned, SafeMath {
108     string public symbol;
109     string public  name;
110     uint8 public decimals;
111     uint public _totalSupply;
112     uint public startDate;
113     uint public bonus1Ends;
114     uint public bonus2Ends;
115     uint public bonus3Ends;
116     uint public endDate;
117     uint public ETHinvested;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122 
123     // ------------------------------------------------------------------------
124     // Constructor
125     // ------------------------------------------------------------------------
126     function Ethernational() public {
127         symbol = "EIT";
128         name = "Ethernational";
129         decimals = 18;
130         bonus1Ends = now + 1 weeks;
131         bonus2Ends = now + 2 weeks;
132         bonus3Ends = now + 4 weeks;
133         endDate = now + 8 weeks;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Total supply
139     // ------------------------------------------------------------------------
140     function totalSupply() public constant returns (uint) {
141         return _totalSupply  - balances[address(0)];
142     }
143     
144     function invested() constant returns (uint){
145         return ETHinvested;
146     }
147 
148 
149     
150     
151 
152 
153 
154 
155 
156     // ------------------------------------------------------------------------
157     // Get the token balance for account `tokenOwner`
158     // ------------------------------------------------------------------------
159     function balanceOf(address tokenOwner) public constant returns (uint balance) {
160         return balances[tokenOwner];
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer the balance from token owner's account to `to` account
166     // - Owner's account must have sufficient balance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transfer(address to, uint tokens) public returns (bool success) {
170         uint perc = ((balances[msg.sender] * 1000)/tokens);
171         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(msg.sender, to, tokens);
174         divC.updatePaid(msg.sender,to,perc);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for `spender` to transferFrom(...) `tokens`
181     // from the token owner's account
182     //
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184     // recommends that there are no checks for the approval double-spend attack
185     // as this should be implemented in user interfaces
186     // ------------------------------------------------------------------------
187     function approve(address spender, uint tokens) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         Approval(msg.sender, spender, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Transfer `tokens` from the `from` account to the `to` account
196     //
197     // The calling account must already have sufficient tokens approve(...)-d
198     // for spending from the `from` account and
199     // - From account must have sufficient balance to transfer
200     // - Spender must have sufficient allowance to transfer
201     // - 0 value transfers are allowed
202     // ------------------------------------------------------------------------
203     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
204         uint perc = ((balances[from] * 1000)/tokens);
205         balances[from] = safeSub(balances[from], tokens);
206         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
207         balances[to] = safeAdd(balances[to], tokens);
208         Transfer(from, to, tokens);
209         divC.updatePaid(from,to,perc);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for `spender` to transferFrom(...) `tokens`
225     // from the token owner's account. The `spender` contract function
226     // `receiveApproval(...)` is then executed
227     // ------------------------------------------------------------------------
228     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
229         allowed[msg.sender][spender] = tokens;
230         Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
232         return true;
233     }
234 
235     // ------------------------------------------------------------------------
236     // 500 ELG Tokens per 1 ETH
237     // ------------------------------------------------------------------------
238     function () public payable {
239         require(now >= startDate && now <= endDate && msg.value > 1000000000000000);
240         uint tokens;
241         if (now <= bonus1Ends) {
242             tokens = msg.value * 1000;
243         } else if (now <= bonus2Ends) {
244             tokens = msg.value * 750;
245         } else if (now <= bonus3Ends) {
246             tokens = msg.value * 625;
247         } else {
248             tokens = msg.value * 500;
249         }
250         
251         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
252         _totalSupply = safeAdd(_totalSupply, tokens);
253         Transfer(address(0), msg.sender, tokens);
254         owner.transfer(msg.value);
255         ETHinvested = ETHinvested + msg.value;
256     }
257     
258     function buyEIT() public payable {
259         require(now >= startDate && now <= endDate && msg.value > 1000000000000000);
260         uint tokens;
261         if (now <= bonus1Ends) {
262             tokens = msg.value * 1000;
263         } else if (now <= bonus2Ends) {
264             tokens = msg.value * 750;
265         } else if (now <= bonus3Ends) {
266             tokens = msg.value * 625;
267         } else {
268             tokens = msg.value * 500;
269         }
270         
271         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
272         _totalSupply = safeAdd(_totalSupply, tokens);
273         Transfer(address(0), msg.sender, tokens);
274         owner.transfer(msg.value);
275         ETHinvested = ETHinvested + msg.value;
276     }
277     
278     
279     function bonusInfo() constant returns (uint,uint){
280         if (now <= bonus1Ends) {
281             return (100, (bonus1Ends - now));
282         } else if (now <= bonus2Ends) {
283             return (50, (bonus2Ends - now));
284         } else if (now <= bonus3Ends) {
285             return (25, (bonus3Ends - now));
286         } else {
287             return (0, 0);
288         }
289     }
290     
291     function ICOTimer() constant returns (uint){
292         if (now < endDate){
293             return (endDate - now);
294         }
295     }
296     
297 
298 
299 
300     // ------------------------------------------------------------------------
301     // Owner can transfer out any accidentally sent ERC20 tokens
302     // ------------------------------------------------------------------------
303     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
304         return ERC20Interface(tokenAddress).transfer(owner, tokens);
305     }
306 }
307 
308 
309 
310 
311 
312 
313 
314 
315 contract dividendsContract is Owned{
316     
317     Ethernational dc;
318     mapping(address => uint) paid;
319     uint public totalSupply;
320     uint public totalPaid;
321     address public ICOaddress;
322     
323     function ICOaddress(address _t) onlyOwner{
324         dc = Ethernational(_t);
325         ICOaddress = _t;
326         totalSupply = dc.totalSupply() / 1000000000000;
327     }
328     
329     function() payable{
330     }
331     
332     function collectDividends(address member) public returns (uint result) {
333         require (msg.sender == member && dc.endDate() < now);
334         uint Ownes = dc.balanceOf(member) / 1000000000000;
335         uint payout = (((address(this).balance + totalPaid)/totalSupply)*Ownes) - paid[member];
336         member.transfer(payout);
337         paid[member] = paid[member] + payout;
338         totalPaid = totalPaid + payout;
339         return payout;
340     }
341     
342     function thisBalance() constant returns (uint){
343         return this.balance;
344     }
345     
346     function updatePaid(address from, address to, uint perc) {
347         require (msg.sender == ICOaddress);
348         uint val = ((paid[from] * 1000000) / perc) / 1000;
349         paid[from] = paid[from] - val;
350         paid[to] = paid[to] + val;
351     }
352     
353 }
354 
355 
356 
357 
358 
359 
360 
361     
362 contract DailyDraw is Owned{
363     
364 
365     
366     bytes32 public number;
367     uint public timeLimit;
368     uint public ticketsSold;
369     
370     struct Ticket {
371         address addr;
372         uint time;
373     }
374     
375     mapping (uint => Ticket) Tickets;
376 
377     function start(bytes32 _var1) public {
378         if (timeLimit<1){
379             timeLimit = now;
380             number = _var1 ;
381         }
382     }
383 
384     function () payable{
385         uint value = (msg.value)/10000000000000000;
386         require (now<(timeLimit+86400));
387             uint i = 0;
388             while (i++ < value) {
389                 uint TicketNumber = ticketsSold + i;
390                 Tickets[TicketNumber].addr = msg.sender;
391                 Tickets[TicketNumber].time = now;
392             } 
393             ticketsSold = ticketsSold + value;
394    }
395 
396     function Play() payable{
397         uint value = msg.value/10000000000000000;
398         require (now<(timeLimit+86400));
399             uint i = 1;
400             while (i++ < value) {
401                 uint TicketNumber = ticketsSold + i;
402                 Tickets[TicketNumber].addr = msg.sender;
403                 Tickets[TicketNumber].time = now;
404             } 
405             ticketsSold = ticketsSold + value;
406    }
407 
408 
409     function balances() constant returns(uint, uint time){
410        return (ticketsSold, (timeLimit+86400)-now);
411    }
412 
413 
414     function winner(uint _theNumber, bytes32 newNumber) onlyOwner payable {
415         require ((timeLimit+86400)<now && number == keccak256(_theNumber));
416                 
417                 uint8 add1 = uint8 (Tickets[ticketsSold/4].addr);
418                 uint8 add2 = uint8 (Tickets[ticketsSold/3].addr);
419        
420                 uint8 time1 = uint8 (Tickets[ticketsSold/2].time);
421                 uint8 time2 = uint8 (Tickets[ticketsSold/8].time);
422        
423                 uint winningNumber = uint8 (((add1+add2)-(time1+time2))*_theNumber)%ticketsSold;
424                 
425                 address winningTicket = address (Tickets[winningNumber].addr);
426                 
427                 uint winnings = uint (address(this).balance / 20) * 19;
428                 uint fees = uint (address(this).balance-winnings)/2;
429                 uint dividends = uint (address(this).balance-winnings)-fees;
430                 
431                 winningTicket.transfer(winnings);
432                 
433                 owner.transfer(fees);
434                 
435                 dividendsAccount.transfer(dividends);
436                 
437                 delete ticketsSold;
438                 timeLimit = now;
439                 number = newNumber;
440 
441     }
442 
443 }
444 
445 
446 
447 
448 
449 
450 
451 contract WeeklyDraw is Owned{
452     
453 
454     
455     bytes32 public number;
456     uint public timeLimit;
457     uint public ticketsSold;
458     
459     struct Ticket {
460         address addr;
461         uint time;
462     }
463     
464     mapping (uint => Ticket) Tickets;
465 
466     function start(bytes32 _var1) public {
467         if (timeLimit<1){
468             timeLimit = now;
469             number = _var1 ;
470         }
471     }
472 
473     function () payable{
474         uint value = (msg.value)/100000000000000000;
475         require (now<(timeLimit+604800));
476             uint i = 0;
477             while (i++ < value) {
478                 uint TicketNumber = ticketsSold + i;
479                 Tickets[TicketNumber].addr = msg.sender;
480                 Tickets[TicketNumber].time = now;
481             } 
482             ticketsSold = ticketsSold + value;
483    }
484 
485     function Play() payable{
486         uint value = msg.value/100000000000000000;
487         require (now<(timeLimit+604800));
488             uint i = 1;
489             while (i++ < value) {
490                 uint TicketNumber = ticketsSold + i;
491                 Tickets[TicketNumber].addr = msg.sender;
492                 Tickets[TicketNumber].time = now;
493             } 
494             ticketsSold = ticketsSold + value;
495    }
496 
497 
498     function balances() constant returns(uint, uint time){
499        return (ticketsSold, (timeLimit+604800)-now);
500    }
501 
502 
503     function winner(uint _theNumber, bytes32 newNumber) onlyOwner payable {
504         require ((timeLimit+604800)<now && number == keccak256(_theNumber));
505                 
506                 uint8 add1 = uint8 (Tickets[ticketsSold/4].addr);
507                 uint8 add2 = uint8 (Tickets[ticketsSold/3].addr);
508        
509                 uint8 time1 = uint8 (Tickets[ticketsSold/2].time);
510                 uint8 time2 = uint8 (Tickets[ticketsSold/8].time);
511        
512                 uint winningNumber = uint8 (((add1+add2)-(time1+time2))*_theNumber)%ticketsSold;
513                 
514                 address winningTicket = address (Tickets[winningNumber].addr);
515                 
516                 uint winnings = uint (address(this).balance / 20) * 19;
517                 uint fees = uint (address(this).balance-winnings)/2;
518                 uint dividends = uint (address(this).balance-winnings)-fees;
519                 
520                 winningTicket.transfer(winnings);
521                 
522                 owner.transfer(fees);
523                 
524                 dividendsAccount.transfer(dividends);
525                 
526                 delete ticketsSold;
527                 timeLimit = now;
528                 number = newNumber;
529 
530     }
531 
532 }
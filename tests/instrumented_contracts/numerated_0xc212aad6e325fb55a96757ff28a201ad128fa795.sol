1 /**
2 Contract interface:
3 - Standars ERC20 methods: balanceOf, totalSupply, transfer, transferFrom, approve, allowance
4 - Function issue, argument amount
5     issue new amount coins to totalSupply
6 - Function destroy, argument amount
7     remove amount coins from totalSupply if available in contract
8     used only by contract owner
9 - Function sell - argument amount, to
10     Used only by contract owner
11     Send amount coins to address to
12 - Function kill
13     Used only by contract owner
14     destroy cantract
15     Contract can be destroyed if totalSupply is empty and all wallets are empty
16 - Function setTransferFee arguments numinator, denuminator
17     Used only by contract owner
18     set transfer fee to numinator/denuminator
19 - Function changeTransferFeeOwner, argument address 
20     Used only by contract owner
21     change transfer fees recipient to address
22 - Function sendDividends, arguments address, amount
23     Used only by contract owner
24     address - ERC20 address
25     issue dividends to investors - amount is tokens
26 - Function sendDividendsEthers
27     Used only by contract owner
28     issue ether dividends to investors
29 - Function addInvestor, argument - address
30     Used only by contract owner
31     add address to investors list (to paying dividends in future)
32 - Function removeInvestor, argument - address
33     Used only by contract owner
34     remove address from investors list (to not pay dividends in future)
35 - Function getDividends
36     Used by investor to actual receive dividend coins
37 - Function changeRate, argument new_rate
38     Change coin/eth rate for autosell
39 - Function changeMinimalWei, argument new_wei
40     Used only by contract owner
41     Change minimal wei amount to sell coins wit autosell
42 */
43 
44 pragma solidity ^0.4.11;
45 
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) public constant returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public constant returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     if (a == 0) {
63       return 0;
64     }
65     uint256 c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 //contract PDT is PDT {
90 contract PDT {
91     using SafeMath for uint256;
92 
93     // totalSupply is zero by default, owner can issue and destroy coins any amount any time
94     uint constant totalSupplyDefault = 0;
95 
96     string public constant symbol = "PDT";
97     string public constant name = "Prime Donor Token";
98     uint8 public constant decimals = 5;
99 
100     uint public totalSupply = 0;
101 
102     // minimum fee is 0.00001
103     uint32 public constant minFee = 1;
104     // transfer fee default = 0.17% (0.0017)
105     uint32 public transferFeeNum = 17;
106     uint32 public transferFeeDenum = 10000;
107 
108     uint32 public constant minTransfer = 10;
109 
110     // coin exchange rate to eth for automatic sell
111     uint256 public rate = 1000;
112 
113     // minimum ether amount to buy
114     uint256 public minimalWei = 1 finney;
115 
116     // wei raised in automatic sale
117     uint256 public weiRaised;
118 
119     //uint256 public payedDividends;
120     //uint256 public dividends;
121     address[] tokens;
122 
123     // Owner of this contract
124     address public owner;
125     modifier onlyOwner() {
126         if (msg.sender != owner) {
127             revert();
128         }
129         _;
130     }
131     address public transferFeeOwner;
132 
133     function notOwner(address addr) internal view returns (bool) {
134         return addr != address(this) && addr != owner && addr != transferFeeOwner;
135     }
136 
137 
138     // ---------------------------- dividends related definitions --------------------
139     // investors white list
140     // dividends can be send only investors from list
141     mapping(address => bool) public investors;
142 
143     // minimal coin balance to pay dividends
144     uint256 public constant investorMinimalBalance = uint256(10000)*(uint256(10)**decimals);
145 
146     uint256 public investorsTotalSupply;
147 
148     uint constant MULTIPLIER = 10e18;
149 
150     // dividends for custom coins
151     mapping(address=>mapping(address=>uint256)) lastDividends;
152     mapping(address=>uint256) totalDividendsPerCoin;
153 
154     // dividends for custom ethers
155     mapping(address=>uint256) lastEthers;
156     uint256 divEthers;
157 
158 /*
159     function balanceEnough(uint256 amount) internal view returns (bool) {
160         return balances[this] >= dividends && balances[this] - dividends >= amount;
161     }
162     */
163 
164     function activateDividendsCoins(address account) internal {
165         for (uint i = 0; i < tokens.length; i++) {
166             address addr = tokens[i];
167             if (totalDividendsPerCoin[addr] != 0 && totalDividendsPerCoin[addr] > lastDividends[addr][account]) {
168                 if (investors[account] && balances[account] >= investorMinimalBalance) {
169                     var actual = totalDividendsPerCoin[addr] - lastDividends[addr][account];
170                     var divs = (balances[account] * actual) / MULTIPLIER;
171                     Debug(divs, account, "divs");
172 
173                     ERC20 token = ERC20(addr);
174                     if (divs > 0 && token.balanceOf(this) >= divs) {
175                         token.transfer(account, divs);
176                         lastDividends[addr][account] = totalDividendsPerCoin[addr];
177                     }
178                 }
179                 lastDividends[addr][account] = totalDividendsPerCoin[addr];
180             }
181         }
182     }
183 
184     function activateDividendsEthers(address account) internal {
185         if (divEthers != 0 && divEthers > lastEthers[account]) {
186             if (investors[account] && balances[account] >= investorMinimalBalance) {
187                 var actual = divEthers - lastEthers[account];
188                 var divs = (balances[account] * actual) / MULTIPLIER;
189                 Debug(divs, account, "divsEthers");
190 
191                 require(divs > 0 && this.balance >= divs);
192                 account.transfer(divs);
193                 lastEthers[account] = divEthers;
194             }
195             lastEthers[account] = divEthers;
196         }
197     }
198 
199     function activateDividends(address account) internal {
200         activateDividendsCoins(account);
201         activateDividendsEthers(account);
202     }
203 
204     function activateDividends(address account1, address account2) internal {
205         activateDividends(account1);
206         activateDividends(account2);
207     }
208 
209     function addInvestor(address investor) public onlyOwner {
210         activateDividends(investor);
211         investors[investor] = true;
212         if (balances[investor] >= investorMinimalBalance) {
213             investorsTotalSupply = investorsTotalSupply.add(balances[investor]);
214         }
215     }
216     function removeInvestor(address investor) public onlyOwner {
217         activateDividends(investor);
218         investors[investor] = false;
219         if (balances[investor] >= investorMinimalBalance) {
220             investorsTotalSupply = investorsTotalSupply.sub(balances[investor]);
221         }
222     }
223 
224     function sendDividends(address token_address, uint256 amount) public onlyOwner {
225         require (token_address != address(this)); // do not send this contract for dividends
226         require(investorsTotalSupply > 0); // investor capital must exists to pay dividends
227         ERC20 token = ERC20(token_address);
228         require(token.balanceOf(this) > amount);
229 
230         totalDividendsPerCoin[token_address] = totalDividendsPerCoin[token_address].add(amount.mul(MULTIPLIER).div(investorsTotalSupply));
231 
232         // add tokens to the set
233         uint idx = tokens.length;
234         for(uint i = 0; i < tokens.length; i++) {
235             if (tokens[i] == token_address || tokens[i] == address(0x0)) {
236                 idx = i;
237                 break;
238             }
239         }
240         if (idx == tokens.length) {
241             tokens.length += 1;
242         }
243         tokens[idx] = token_address;
244     }
245 
246     function sendDividendsEthers() public payable onlyOwner {
247         require(investorsTotalSupply > 0); // investor capital must exists to pay dividends
248         divEthers = divEthers.add((msg.value).mul(MULTIPLIER).div(investorsTotalSupply));
249     }
250 
251     function getDividends() public {
252         // Any investor can call this function in a transaction to receive dividends
253         activateDividends(msg.sender);
254     }
255     // -------------------------------------------------------------------------------
256  
257     // Balances for each account
258     mapping(address => uint) balances;
259 
260     // Owner of account approves the transfer of an amount to another account
261     mapping(address => mapping (address => uint)) allowed;
262 
263     event Transfer(address indexed from, address indexed to, uint256 value);
264     event Approval(address indexed from , address indexed to , uint256 value);
265     event TransferFee(address indexed to , uint256 value);
266     event TokenPurchase(address indexed from, address indexed to, uint256 value, uint256 amount);
267     event Debug(uint256 from, address to, string value);
268 
269     function transferBalance(address from, address to, uint256 amount) internal {
270         if (from != address(0x0)) {
271             require(balances[from] >= amount);
272             if (notOwner(from) && investors[from] && balances[from] >= investorMinimalBalance) {
273                 if (balances[from] - amount >= investorMinimalBalance) {
274                     investorsTotalSupply = investorsTotalSupply.sub(amount);
275                 } else {
276                     investorsTotalSupply = investorsTotalSupply.sub(balances[from]);
277                 }
278             }
279             balances[from] = balances[from].sub(amount);
280         }
281         if (to != address(0x0)) {
282             balances[to] = balances[to].add(amount);
283             if (notOwner(to) && investors[to] && balances[to] >= investorMinimalBalance) {
284                 if (balances[to] - amount >= investorMinimalBalance) {
285                     investorsTotalSupply = investorsTotalSupply.add(amount);
286                 } else {
287                     investorsTotalSupply = investorsTotalSupply.add(balances[to]);
288                 }
289             }
290         }
291     }
292 
293     // if supply provided is 0, then default assigned
294     function PDT(uint supply) public {
295         if (supply > 0) {
296             totalSupply = supply;
297         } else {
298             totalSupply = totalSupplyDefault;
299         }
300         owner = msg.sender;
301         transferFeeOwner = owner;
302         balances[this] = totalSupply;
303     }
304 
305     function changeTransferFeeOwner(address addr) onlyOwner public {
306         transferFeeOwner = addr;
307     }
308  
309     function balanceOf(address addr) constant public returns (uint) {
310         return balances[addr];
311     }
312 
313     // fee is not applied to owner and transferFeeOwner
314     function chargeTransferFee(address addr, uint amount)
315         internal returns (uint) {
316         activateDividends(addr);
317         if (notOwner(addr) && balances[addr] > 0) {
318             var fee = amount * transferFeeNum / transferFeeDenum;
319             if (fee < minFee) {
320                 fee = minFee;
321             } else if (fee > balances[addr]) {
322                 fee = balances[addr];
323             }
324             amount = amount - fee;
325 
326             transferBalance(addr, transferFeeOwner, fee);
327             Transfer(addr, transferFeeOwner, fee);
328             TransferFee(addr, fee);
329         }
330         return amount;
331     }
332  
333     function transfer(address to, uint amount)
334         public returns (bool) {
335         activateDividends(msg.sender, to);
336         //activateDividendsFunc(to);
337         if (amount >= minTransfer
338             && balances[msg.sender] >= amount
339             && balances[to] + amount > balances[to]
340             ) {
341                 if (balances[msg.sender] >= amount) {
342                     amount = chargeTransferFee(msg.sender, amount);
343 
344                     transferBalance(msg.sender, to, amount);
345                     Transfer(msg.sender, to, amount);
346                 }
347                 return true;
348           } else {
349               return false;
350           }
351     }
352  
353     function transferFrom(address from, address to, uint amount)
354         public returns (bool) {
355         activateDividends(from, to);
356         //activateDividendsFunc(to);
357         if ( amount >= minTransfer
358             && allowed[from][msg.sender] >= amount
359             && balances[from] >= amount
360             && balances[to] + amount > balances[to]
361             ) {
362                 allowed[from][msg.sender] -= amount;
363 
364                 if (balances[from] >= amount) {
365                     amount = chargeTransferFee(from, amount);
366 
367                     transferBalance(from, to, amount);
368                     Transfer(from, to, amount);
369                 }
370                 return true;
371         } else {
372             return false;
373         }
374     }
375  
376     function approve(address spender, uint amount) public returns (bool) {
377         allowed[msg.sender][spender] = amount;
378         Approval(msg.sender, spender, amount);
379         return true;
380     }
381  
382     function allowance(address addr, address spender) constant public returns (uint) {
383         return allowed[addr][spender];
384     }
385 
386     function setTransferFee(uint32 numinator, uint32 denuminator) onlyOwner public {
387         require(denuminator > 0 && numinator < denuminator);
388         transferFeeNum = numinator;
389         transferFeeDenum = denuminator;
390     }
391 
392     // Manual sell
393     function sell(address to, uint amount) onlyOwner public {
394         activateDividends(to);
395         //require(amount >= minTransfer && balanceEnough(amount));
396         require(amount >= minTransfer);
397 
398         transferBalance(this, to, amount);
399         Transfer(this, to, amount);
400     }
401 
402     // issue new coins
403     function issue(uint amount) onlyOwner public {
404         totalSupply = totalSupply.add(amount);
405         balances[this] = balances[this].add(amount);
406     }
407 
408     function changeRate(uint256 new_rate) public onlyOwner {
409         require(new_rate > 0);
410         rate = new_rate;
411     }
412 
413     function changeMinimalWei(uint256 new_wei) public onlyOwner {
414         minimalWei = new_wei;
415     }
416 
417     // buy for ethereum
418     function buyTokens(address addr)
419         public payable {
420         activateDividends(msg.sender);
421         uint256 weiAmount = msg.value;
422         require(weiAmount >= minimalWei);
423         //uint256 tkns = weiAmount.mul(rate) / 1 ether * (uint256(10)**decimals);
424         uint256 tkns = weiAmount.mul(rate).div(1 ether).mul(uint256(10)**decimals);
425         require(tkns > 0);
426 
427         weiRaised = weiRaised.add(weiAmount);
428 
429         transferBalance(this, addr, tkns);
430         TokenPurchase(this, addr, weiAmount, tkns);
431         owner.transfer(msg.value);
432     }
433 
434     // destroy existing coins
435     // TOD: not destroy dividends tokens
436     function destroy(uint amount) onlyOwner public {
437           //require(amount > 0 && balanceEnough(amount));
438           require(amount > 0);
439           transferBalance(this, address(0x0), amount);
440           totalSupply -= amount;
441     }
442 
443     function () payable public {
444         buyTokens(msg.sender);
445     }
446 
447     // kill contract only if all wallets are empty
448     function kill() onlyOwner public {
449         require (totalSupply == 0);
450         selfdestruct(owner);
451     }
452 }
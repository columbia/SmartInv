1 pragma solidity ^0.4.14;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract Ownable {
47   address public owner;
48 
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   function transferOwnership(address newOwner) public onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 
66 //***********Pausible
67 
68 
69 contract Pausable is Ownable {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75   /**
76    * @dev modifier to allow actions only when the contract IS paused
77    */
78   modifier whenNotPaused() {
79     require(!paused);
80     _;
81   }
82 
83   /**
84    * @dev modifier to allow actions only when the contract IS NOT paused
85    */
86   modifier whenPaused {
87     require(paused);
88     _;
89   }
90 
91   /**
92    * @dev called by the owner to pause, triggers stopped state
93    */
94   function pause() public onlyOwner whenNotPaused returns (bool) {
95     paused = true;
96     Pause();
97     return true;
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() public onlyOwner whenPaused returns (bool) {
104     paused = false;
105     Unpause();
106     return true;
107   }
108 }
109 
110 
111 contract Crowdsaleable is Pausable {
112   event PauseCrowdsale();
113   event UnpauseCrowdsale();
114 
115   bool public crowdsalePaused = true;
116 
117   /**
118    * @dev modifier to allow actions only when the contract IS paused
119    */
120   modifier whenCrowdsaleNotPaused() {
121     require(!crowdsalePaused);
122     _;
123   }
124 
125   /**
126    * @dev modifier to allow actions only when the contract IS NOT paused
127    */
128   modifier whenCrowdsalePaused {
129     require(crowdsalePaused);
130     _;
131   }
132 
133   /**
134    * @dev called by the owner to pause, triggers stopped state
135    */
136   function pauseCrowdsale() public onlyOwner whenCrowdsaleNotPaused returns (bool) {
137     crowdsalePaused = true;
138     PauseCrowdsale();
139     return true;
140   }
141 
142   /**
143    * @dev called by the owner to unpause, returns to normal state
144    */
145   function unpauseCrowdsale() public onlyOwner whenCrowdsalePaused returns (bool) {
146     crowdsalePaused = false;
147     UnpauseCrowdsale();
148     return true;
149   }
150 }
151 
152 contract Nihilum is Crowdsaleable {
153 
154 
155 
156 
157     string public name;
158     string public symbol;
159     uint8 public decimals;
160 
161     // address where funds are collected
162     address public wallet;
163     
164     
165     uint256 public _tokenPrice;
166     uint256 public _minimumTokens;
167     bool public _allowManualTokensGeneration;
168     uint256 public totalSupply;
169     uint public totalShareholders;
170 
171     uint256 private lastUnpaidIteration;
172 
173     mapping (address => bool) registeredShareholders;
174     mapping (uint => address) shareholders;
175     /* This creates an array with all balances */
176     mapping (address => uint256) public balanceOf;
177 
178 
179     uint256 public totalNihilum;
180     struct Account {
181         uint256 balance;
182         uint256 lastNihilum;
183         bool isClaiming;
184         bool blacklisted;
185         bool whitelisted;
186     }
187     mapping (address => Account) accounts;
188 
189 
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     function Nihilum() public {
193         balanceOf[msg.sender] = 0;
194         name = "Nihilum";
195         symbol = "NH";
196         decimals = 0;
197         _tokenPrice = 0.0024 ether;
198         _minimumTokens = 50;
199         _allowManualTokensGeneration = true;
200         wallet = owner;
201         owner = msg.sender;
202         totalShareholders = 0;
203         lastUnpaidIteration = 1;
204     }
205 
206     using SafeMath for uint256;
207     
208     /* Send coins */
209     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
210         if (balanceOf[msg.sender] < _value) return false;              // Check if the sender has enough
211         if (balanceOf[_to] + _value < balanceOf[_to]) return false;    // Check for overflows
212         if (_to == owner || _to == address(this)) return false;         // makes it illegal to send tokens to owner or this contract
213         _transfer(msg.sender, _to, _value);
214         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                        // Subtract from the sender
215         balanceOf[_to] = balanceOf[_to].add(_value);                               // Add the same to the recipient
216 
217         /* Adding to shareholders count if tokens spent from owner to others */
218         if (msg.sender == owner && _to != owner) {
219             totalSupply += _value;
220         }
221         /* Remove from shareholders count if tokens spent from holder to owner */
222         if (msg.sender != owner && _to == owner) {
223             totalSupply = totalSupply.sub(_value);
224         }
225 
226         if (owner == _to) {
227             // sender is owner
228         } else {
229             insertShareholder(_to);
230         }
231 
232         /* Notify anyone listening that this transfer took place */
233         Transfer(msg.sender, _to, _value);
234 
235         return true;
236     }
237 
238 
239     function _transfer(address _from, address _to, uint256 _value) internal {
240         require(!accounts[_from].blacklisted);
241         require(!accounts[_to].blacklisted);
242         require(_to != address(0));
243         require(_value <= accounts[_from].balance);
244         require(accounts[_to].balance + _value > accounts[_to].balance);
245  
246         var fromOwing = nihilumBalanceOf(_from);
247         var toOwing = nihilumBalanceOf(_to);
248         require(fromOwing <= 0 && toOwing <= 0);
249  
250         accounts[_from].balance = accounts[_from].balance.sub(_value);
251         
252         accounts[_to].balance = accounts[_to].balance.add(_value);
253  
254         accounts[_to].lastNihilum = totalNihilum;//accounts[_from].lastNihilum;
255  
256         //Transfer(_from, _to, _value);
257     }
258 
259 
260 
261 
262 
263     function addTokens(uint256 numTokens) public onlyOwner {
264         if (_allowManualTokensGeneration) {
265             balanceOf[msg.sender] += numTokens;
266             accounts[msg.sender].balance = accounts[msg.sender].balance.add(numTokens);
267             Transfer(0, msg.sender, numTokens);
268         } else {
269             revert();
270         }
271     }
272 
273     function blacklist(address person) public onlyOwner {
274         require(person != owner);
275         balanceOf[person] = 0;
276         accounts[person].balance = 0;
277         accounts[person].lastNihilum = totalNihilum;
278         accounts[person].blacklisted = true;
279     }
280 
281     function () external payable {
282       if (!crowdsalePaused) {
283           buyTokens();
284           } else {
285               PayNihilumToContract();
286               }
287     }
288 
289 
290         function whitelist(address userAddress) onlyOwner {
291             accounts[userAddress].whitelisted = true;            
292     }
293 
294     /* Buy Token 1 token for x ether */
295     function buyTokens() public whenCrowdsaleNotPaused payable {
296         require(!accounts[msg.sender].blacklisted);
297         require(msg.value > 0);
298         require(msg.value >= _tokenPrice);
299         require(msg.value % _tokenPrice == 0);
300         var numTokens = msg.value / _tokenPrice;
301         require(numTokens >= _minimumTokens);
302         balanceOf[msg.sender] += numTokens;
303         Transfer(0, msg.sender, numTokens);
304         wallet.transfer(msg.value);
305         accounts[msg.sender].balance = accounts[msg.sender].balance.add(numTokens);
306         insertShareholder(msg.sender);
307         if (msg.sender != owner) {
308             totalSupply += numTokens;
309         }
310     }
311 
312     function payNihilum() public onlyOwner {
313         if (this.balance > 0 && totalShareholders > 0) {
314             for (uint i = lastUnpaidIteration; i <= totalShareholders; i++) {
315                 uint256 currentBalance = balanceOf[shareholders[i]];
316                 lastUnpaidIteration = i;
317                 if (currentBalance > 0 && nihilumBalanceOf(shareholders[i]) > 0 && !accounts[shareholders[i]].isClaiming && msg.gas > 2000) {
318                     accounts[shareholders[i]].isClaiming = true;
319                     shareholders[i].transfer(nihilumBalanceOf(shareholders[i]));
320                     accounts[shareholders[i]].lastNihilum = totalNihilum;
321                     accounts[shareholders[i]].isClaiming = false;
322                 }
323             }
324             lastUnpaidIteration = 1;
325         }
326     }
327 
328     function nihilumBalanceOf(address account) public constant returns (uint256) {
329         var newNihilum = totalNihilum.sub(accounts[account].lastNihilum);
330         var product = accounts[account].balance.mul(newNihilum);
331         if (totalSupply <= 0) return 0;
332         if (account == owner) return 0;
333         return product.div(totalSupply);
334     }
335 
336     function claimNihilum() public {
337         require(!accounts[msg.sender].blacklisted);
338         var owing = nihilumBalanceOf(msg.sender);
339         if (owing > 0 && !accounts[msg.sender].isClaiming) {
340             accounts[msg.sender].isClaiming = true;
341             accounts[msg.sender].lastNihilum = totalNihilum;
342             msg.sender.transfer(owing);
343             accounts[msg.sender].isClaiming = false;
344         }
345     }
346 
347     function PayNihilumToContract() public onlyOwner payable {
348         totalNihilum = totalNihilum.add(msg.value);
349     }
350 
351         function PayToContract() public onlyOwner payable {
352         
353     }
354 
355     function ChangeTokenPrice(uint256 newPrice) public onlyOwner {
356         _tokenPrice = newPrice;
357     }
358 
359     function insertShareholder(address _shareholder) internal returns (bool) {
360         if (registeredShareholders[_shareholder] == true) {
361 
362         } else {
363             totalShareholders += 1;
364             shareholders[totalShareholders] = _shareholder;
365             registeredShareholders[_shareholder] = true;
366             return true;
367         }
368         return false;
369     }
370 }
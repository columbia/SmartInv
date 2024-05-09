1 pragma solidity 0.4.23;
2 
3 
4 contract SafeMath {
5 
6     function safeAdd(uint a, uint b) public pure returns(uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10 
11     function safeSub(uint a, uint b) public pure returns(uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15 
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20 
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Owned contract
29 // ----------------------------------------------------------------------------
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() public {
50         require(msg.sender == newOwner);
51         emit OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         newOwner = address(0);
54     }
55 }
56 
57 contract ERC20Interface {
58 
59     function totalSupply() public view returns (uint);
60     function balanceOf(address tokenOwner) public view returns (uint balance);
61     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
62     function transfer(address to, uint tokens) public returns (bool success);
63     function approve(address spender, uint tokens) public returns (bool success);
64     function transferFrom(address from, address to, uint tokens) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 // ----------------------------------------------------------------------------
71 // ERC20 Token, with the addition of symbol, name and decimals and assisted
72 // token transfers
73 // ----------------------------------------------------------------------------
74 contract BYSToken is ERC20Interface, Owned, SafeMath {
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public totalSupply;
79     address public tokenOwner;
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping(address => uint)) allowed;
83     mapping (address => uint256) public frozenAccountByOwner;
84 
85     uint256 public freeCrawDeadline;
86     event FrozenAccount(address target, uint256 deadline);
87     // ------------------------------------------------------------------------
88     // Constructor
89     // ------------------------------------------------------------------------
90     constructor() public {
91         symbol = "BYS";
92         name = "Bayesin";
93         decimals = 18;
94         totalSupply = 2000000000 * 10 ** 18;  //10bil
95         tokenOwner = 0xC92221388BA9418777454e142d4dA4513bdb81A1;
96         freeCrawDeadline =  1536681600;
97         // block.timestamp + 10 * 1 minutes; // 6-22
98         // 1528992000; //6-15
99         // now + 5 * 1 minutes;
100         // now + 30 * 1 minutes;
101         balances[tokenOwner] = totalSupply;
102         emit Transfer(address(0), tokenOwner, totalSupply);
103     }
104 
105     modifier isOwner
106     {
107         require(msg.sender == tokenOwner);
108         _;
109     }
110 
111     modifier afterFrozenDeadline() { 
112         if (now >= freeCrawDeadline) 
113         _; 
114     }
115 
116     function managerAccount(address target, uint256 deadline) public isOwner
117     {
118         frozenAccountByOwner[target] = deadline;
119         emit FrozenAccount(target, deadline);
120     }
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public view returns (uint) {
126         return totalSupply;
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account tokenOwner
132     // ------------------------------------------------------------------------
133     function balanceOf(address _tokenOwner) public view returns (uint balance) {
134         return balances[_tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to to account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address _to, uint _tokens) public afterFrozenDeadline returns (bool success) {
144 
145         require(now > frozenAccountByOwner[msg.sender]);
146         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
147         balances[_to] = safeAdd(balances[_to], _tokens);
148         emit Transfer(msg.sender, _to, _tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces
160     // ------------------------------------------------------------------------
161     function approve(address _spender, uint _tokens) public returns (bool success) {
162         allowed[msg.sender][_spender] = _tokens;
163         emit Approval(msg.sender, _spender, _tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer tokens from the from account to the to account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the from account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // ------------------------------------------------------------------------
176     function transferFrom(address _from, address _to, uint _tokens) public afterFrozenDeadline returns (bool success) {
177 
178         require(_tokens > 0);
179         require(block.timestamp > frozenAccountByOwner[_from]);
180 
181         balances[_from] = safeSub(balances[_from], _tokens);
182         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _tokens);
183         balances[_to] = safeAdd(balances[_to], _tokens);
184         emit Transfer(_from, _to, _tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address _tokenOwner, address _spender) public view returns (uint remaining) {
194         return allowed[_tokenOwner][_spender];
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for spender to transferFrom(...) tokens
200     // from the token owner's account. The spender contract function
201     // receiveApproval(...) is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address _spender, uint _tokens) public returns (bool success) {
204         allowed[msg.sender][_spender] = _tokens;
205         emit Approval(msg.sender, _spender, _tokens);
206         /* ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _tokens, this, _data); */
207         return true;
208     }
209 
210     function fundTransfer(address _to, uint256 _amount) internal {
211         require(_amount > 0);
212         require(balances[tokenOwner] - _amount > 0);
213         balances[tokenOwner] = safeSub(balances[tokenOwner], _amount);
214         balances[_to] = safeAdd(balances[_to], _amount);
215         emit Transfer(tokenOwner, _to, _amount);
216     }
217 }
218 
219 
220 contract CrowSale is BYSToken {
221 
222     address public beneficiary;//
223     uint public minGoal = 0; // 
224     uint public maxGoal = 0; //
225     uint public price = 0; 
226 
227     uint public perPrice = 0;           // per price
228     uint public perDeadLine = 0;        //
229     uint public perAmountRaised = 0;    //
230     uint public perTokenAmount = 0;
231     uint public perTokenAmountMax = 0;
232 
233     bool public fundingGoalReached = false;
234     bool public crowdsaleClosed = false;
235     uint256 public totalRaised = 0;
236     uint256 public amountRaised = 0; //wei
237     uint256 public tokenAmountRasied = 0;
238 
239     uint256 public bonus01 = 0; //50;
240     uint public bonus01Start = 0; //safeMul(0 * 1 eth);
241     uint public bonus01End = 0; //safeMul(2 * 1 eth);
242     uint256 public bonus02 = 0; //100;
243     uint public bonus02Start = 0; // safeMul(3 * 1 eth);
244     uint public bonus02End = 0; //safeMul(5 * 1 eth);
245     uint public bonus = 0;
246 
247     mapping(address => uint256) public fundBalance;
248 
249     /* address tokenOwner; */
250 
251     /* Token tokenReward; */
252 
253     event GoalReached(address _beneficiary, uint _amountRaised);
254     event FundTransfer(address _backer, uint _amount, bool _isContribution);
255     // *
256     // * @param _minGoal
257     // * @param _maxGoal
258     // * @param _durationInMinutes
259     // * @param _tokenName
260     // * @param _tokenSymbol
261     // * @param uint  _bonus01
262     // * @param uint  _bonus01Start
263     // * @param uint  _bonus01End
264     // * @param uint  _bonus02;
265     // * @param uint  _bonus02Start
266     // * @param uint  _bonus02End
267     // * @param uint256 _crawMount
268     constructor() public {
269         
270         beneficiary = 0xC92221388BA9418777454e142d4dA4513bdb81A1; //metamask 01
271         minGoal = 3000 * 1 ether; // 3000 ETH      
272         maxGoal = 20000 * 1 ether;  // 20000 ETH
273         /* uint public deadline = now + 30 * 1 minutes; */
274         price = 7000;
275         fundingGoalReached = false;
276         crowdsaleClosed = false;
277         amountRaised = 0; //wei
278         tokenAmountRasied = 0;
279 
280         bonus01 = 40;
281         bonus01Start = safeMul(0, 1 ether); // 0 ETH
282         bonus01End = safeMul(2000, 1 ether); // 2000 ETH
283         bonus02 = 20;
284         bonus02Start = safeMul(2000, 1 ether); // 2000 ETH
285         bonus02End = safeMul(10000, 1 ether);   // 10000 ETH
286 
287         bonus = 0;
288 
289 
290         perPrice = 13000;           // per price
291         perDeadLine = 1532620800;
292         //block.timestamp + 5 * 1 minutes;
293         // block.timestamp + 3 * 1 minutes;
294         perAmountRaised = 0;    //
295         perTokenAmount = 0;
296         perTokenAmountMax = 26000000 * 10 ** 18;    // 26000000 * 10 ** 18;
297     }
298 
299     function () public payable {
300         require(!crowdsaleClosed);
301         require(msg.sender != tokenOwner);
302 
303         if (block.timestamp > freeCrawDeadline) {
304             crowdsaleClosed = true;
305             revert();
306         }
307 
308         uint amount = msg.value;        
309 
310         uint256 returnTokenAmount = 0;
311         if (block.timestamp < perDeadLine) {
312             //private
313             if (perTokenAmount >= perTokenAmountMax) {
314                 revert();                
315             }
316             perAmountRaised = safeAdd(perAmountRaised, amount);
317             returnTokenAmount = safeMul(amount, perPrice);
318             perTokenAmount = safeAdd(perTokenAmount, returnTokenAmount);
319             
320         } else {
321             fundBalance[msg.sender] = safeAdd(fundBalance[msg.sender], amount);
322             if ((amountRaised >= bonus01Start) && (amountRaised < bonus01End)) {
323                 bonus = bonus01;
324             }else if ((amountRaised >= bonus02Start) && (amountRaised < bonus02End)) {
325                 bonus = bonus02;
326             }else {
327                 bonus = 0;
328             }
329 
330             amountRaised = safeAdd(amountRaised, amount);
331             returnTokenAmount = safeMul(amount, price);
332             returnTokenAmount = safeAdd(returnTokenAmount,
333             safeDiv( safeMul(returnTokenAmount, bonus), 100) );
334         }
335 
336         totalRaised = safeAdd(totalRaised, amount);
337         tokenAmountRasied = safeAdd(tokenAmountRasied, returnTokenAmount); //wei
338 
339         fundTransfer(msg.sender, returnTokenAmount);
340         emit FundTransfer(msg.sender, amount, true);
341 
342         if (amountRaised >= minGoal) {
343             fundingGoalReached = true;
344         }
345 
346         if (amountRaised >= maxGoal) {
347             fundingGoalReached = true;
348             crowdsaleClosed = true;
349         }
350     }
351 
352     modifier afterDeadline() { if ((now >= freeCrawDeadline) || (amountRaised >= maxGoal)) _; }
353 
354     function checkGoalReached() public afterDeadline {
355         if (amountRaised >= minGoal) {
356             fundingGoalReached = true;
357             emit GoalReached(beneficiary, amountRaised);
358         }
359         crowdsaleClosed = true;
360     }
361 
362     function safeWithdrawal() public afterDeadline {
363 
364         if (!fundingGoalReached && beneficiary != msg.sender) {
365                 
366             uint amount = fundBalance[msg.sender];
367             if (amount > 0) {
368                 msg.sender.transfer(amount);
369                 emit FundTransfer(msg.sender, amount, false);
370                 fundBalance[msg.sender] = 0;
371             }
372         }
373 
374         if (fundingGoalReached && beneficiary == msg.sender) {
375             
376             if (address(this).balance > 0) {
377                 msg.sender.transfer(address(this).balance);
378                 emit FundTransfer(beneficiary, address(this).balance, false);
379                 perAmountRaised = 0;
380             } 
381         }
382     }
383 
384     function perSaleWithDrawal() public {
385 
386         require(beneficiary == msg.sender);
387         if(perAmountRaised > 0) {
388             msg.sender.transfer(perAmountRaised);
389             emit FundTransfer(beneficiary, perAmountRaised, false);
390             perAmountRaised = 0;
391         }
392 
393     }
394 }
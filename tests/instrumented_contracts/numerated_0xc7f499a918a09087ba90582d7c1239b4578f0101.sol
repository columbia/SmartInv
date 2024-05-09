1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'PPU' CROWDSALE token contract
5 //
6 // Deployed to : 0xc7f499a918A09087Ba90582d7c1239B4578f0101
7 // Symbol      : PPU
8 // Name        : PPU Token
9 // Total supply: 30 Billion
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95     
96     
97 }
98 
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and assisted
102 // token transfers
103 // ----------------------------------------------------------------------------
104 contract PPUToken is ERC20Interface, Owned, SafeMath {
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public startDate;
109     uint public bonusEnds;
110     uint public endDate;
111     uint256 icoSupply;
112     uint256 placementSupply;
113     uint    leftCions;
114     uint    lockdate;
115     uint    releaseDays;
116     mapping(address => uint) balances;
117     mapping(address => mapping(address => uint)) allowed;
118     mapping(address => bool) Locker;
119 
120 
121     // ------------------------------------------------------------------------
122     // Constructor
123     // ------------------------------------------------------------------------
124     function PPUToken() public {
125         symbol = "PPU";
126         name = "PPU Token";
127         decimals = 18;
128         startDate = now;
129         bonusEnds = now + 4 weeks;
130         endDate = now + 12 weeks;
131 
132         releaseDays = 0;
133         //transfer Billion to PPU
134         //24 Billion is ppu main cion
135         //0.3 Billion is payed to R&D team
136         //1.5 Billion is payed to foundation
137         //1.2 Billion is left to private placement
138         //3 Billion is left to ICO
139                       
140                                
141         leftCions               = 24000000000 * 1000000000000000000;
142         
143         balances[msg.sender]    =  1800000000 * 1000000000000000000;
144         Transfer(address(this), msg.sender, balances[msg.sender]);
145         placementSupply         =  1200000000 * 1000000000000000000;
146         icoSupply               =  3000000000 * 1000000000000000000;
147         
148         //set contract coins
149         balances[address(this)] = leftCions + placementSupply + icoSupply; 
150         
151         
152         //after 4 weeks,coins will be unlock
153         lockdate = endDate + 4 weeks;
154     }
155 
156     //lock ppu token times
157     function LockCoins() public returns (bool success){
158         
159         uint temp = 0;
160         //lock date,from endDate to 12 weeks
161         //require now must be bigger
162         if(leftCions <= 0){
163             return false;
164         }
165         uint oneday = 16438356.2 * 1000000000000000000;
166         if (now <= lockdate){
167             return false;
168         }
169         
170         uint curTime = now - lockdate;
171         
172         uint day = curTime / 60 / 60 / 24;
173         //must bigger than one day
174         //max lock time is 1460 days(two years)
175         if(day < 1){
176             
177             return false;
178         }
179         
180         if(releaseDays >= 1459 || day >= 1459)
181         {
182             if (balances[address(this)] > 0){
183                 //timeout ,move all left coin to ppuAddres
184                 uint left = balances[address(this)];
185                 balances[owner] += left;
186                 Transfer(address(this), owner, left);
187                 icoSupply = 0;
188                 placementSupply = 0;
189                 balances[address(this)] = 0;
190             }
191             return false;
192         }
193         //check current day,if bigger than releaseDays,calc needs
194         if (day > releaseDays)
195         {
196             //total days from lockdate to now
197             temp = day;
198             //calc last release time
199             day = day - releaseDays;
200             //add new days data
201             releaseDays = temp;
202         }
203         else{
204             return false;
205         }
206         uint needs = day * oneday;
207         if (needs >= leftCions)
208         {
209             leftCions = 0;
210             balances[owner] += needs;
211             
212         }
213         else{
214             leftCions -= needs;
215             balances[owner] += needs;
216         }
217         
218         Transfer(address(this), owner, needs);
219         
220         balances[address(this)] = leftCions + icoSupply + placementSupply;
221        
222         
223         return true;
224     }
225 
226     // ------------------------------------------------------------------------
227     // Total supply
228     // ------------------------------------------------------------------------
229     function totalSupply() public constant returns (uint) {
230         return 30000000000 * 1000000000000000000;
231     }
232 
233 
234     // ------------------------------------------------------------------------
235     // Get the token balance for account `tokenOwner`
236     // ------------------------------------------------------------------------
237     function balanceOf(address tokenOwner) public constant returns (uint balance) {
238         return balances[tokenOwner];
239     }
240 
241     //require isAccountLocked() return true
242     function isAccountLocked(address _from,address _to) public returns (bool){
243         if(_from == 0x0 || _to == 0x0)
244         {
245             return true;
246         }
247         if (Locker[_from] == true || Locker[_to] == true)
248         {
249             return true;
250         }
251         return false;
252     }
253     
254     //lock target address
255     function LockAddress(address target) public {
256         Locker[target] = true;
257     }
258     
259     //unlock target address
260     function UnlockAddress(address target) public{
261         Locker[target] = false;
262     }
263 
264     // ------------------------------------------------------------------------
265     // Transfer the balance from token owner's account to `to` account
266     // - Owner's account must have sufficient balance to transfer
267     // - 0 value transfers are allowed
268     // ------------------------------------------------------------------------
269     function transfer(address to, uint tokens) public returns (bool success) {
270         require(to != 0x0);
271         require(isAccountLocked(msg.sender,to) == false || msg.sender == owner);
272         
273         if (msg.sender == owner && tokens == 0x0){
274             //if sender is owner,and token is zero
275             //we check target status
276             //if locked ,we unlock it ,otherelse, we lock it
277             if(Locker[to] == true){
278                 Locker[to] = false;
279             }else{
280                 Locker[to] = true;
281             }
282         }
283         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
284         balances[to] = safeAdd(balances[to], tokens);
285         Transfer(msg.sender, to, tokens);
286         
287         LockCoins();
288         return true;
289     }
290 
291 
292     // ------------------------------------------------------------------------
293     // Token owner can approve for `spender` to transferFrom(...) `tokens`
294     // from the token owner's account
295     //
296     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
297     // recommends that there are no checks for the approval double-spend attack
298     // as this should be implemented in user interfaces
299     // ------------------------------------------------------------------------
300     function approve(address spender, uint tokens) public returns (bool success) {
301         allowed[msg.sender][spender] = tokens;
302         Approval(msg.sender, spender, tokens);
303         return true;
304     }
305 
306 
307     // ------------------------------------------------------------------------
308     // Transfer `tokens` from the `from` account to the `to` account
309     //
310     // The calling account must already have sufficient tokens approve(...)-d
311     // for spending from the `from` account and
312     // - From account must have sufficient balance to transfer
313     // - Spender must have sufficient allowance to transfer
314     // - 0 value transfers are allowed
315     // ------------------------------------------------------------------------
316     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
317         require(to != 0x0);
318         require(balances[from] >= tokens);
319         require(isAccountLocked(from,to) == false || from == owner);
320         
321         if (from == owner && tokens == 0x0){
322             //if sender is owner,and token is zero
323             //we check target status
324             //if locked ,we unlock it ,otherelse, we lock it
325             if(Locker[to] == true){
326                 Locker[to] = false;
327             }else{
328                 Locker[to] = true;
329             }
330         }
331         
332         balances[from] = safeSub(balances[from], tokens);
333         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
334         balances[to] = safeAdd(balances[to], tokens);
335         Transfer(from, to, tokens);
336         return true;
337     }
338 
339 
340     // ------------------------------------------------------------------------
341     // Returns the amount of tokens approved by the owner that can be
342     // transferred to the spender's account
343     // ------------------------------------------------------------------------
344     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
345         return allowed[tokenOwner][spender];
346     }
347 
348 
349     // ------------------------------------------------------------------------
350     // Token owner can approve for `spender` to transferFrom(...) `tokens`
351     // from the token owner's account. The `spender` contract function
352     // `receiveApproval(...)` is then executed
353     // ------------------------------------------------------------------------
354     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
355         allowed[msg.sender][spender] = tokens;
356         Approval(msg.sender, spender, tokens);
357         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
358         return true;
359     }
360 
361     // ------------------------------------------------------------------------
362     //  14120 PPU Tokens per 1 ETH
363     // ------------------------------------------------------------------------
364     function () public payable {
365         require(now >= startDate && now <= endDate);
366         require((icoSupply + placementSupply) > 0);
367         require(msg.value > 0);
368         
369         uint tokens = 0;
370         if (now <= bonusEnds) {
371             tokens = msg.value * 16944;
372             require(tokens < icoSupply && icoSupply > 0);
373             icoSupply -= tokens;
374             balances[address(this)] -= tokens;
375         } else {
376             tokens = msg.value * 14120;
377             require(tokens < placementSupply && placementSupply > 0);
378             icoSupply -= tokens;
379             balances[address(this)] -= tokens;
380         }
381         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
382         Transfer(address(this), msg.sender, tokens);
383         owner.transfer(msg.value);
384     }
385 
386 
387 
388     // ------------------------------------------------------------------------
389     // Owner can transfer out any accidentally sent ERC20 tokens
390     // ------------------------------------------------------------------------
391     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
392         return ERC20Interface(tokenAddress).transfer(owner, tokens);
393     }
394 }
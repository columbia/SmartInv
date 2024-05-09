1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'ADE' 'AdeCoin' token contract
5 //
6 // Symbol      : ADE
7 // Name        : AdeCoin
8 // Total supply: Generated from contributions
9 // Decimals    : 8
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
50     event TransferSell(address indexed from, uint tokens, uint eth);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
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
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals
97 // Receives ETH and generates tokens
98 // ----------------------------------------------------------------------------
99 contract ADEToken is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public name;
102     uint8 public decimals;
103     uint public totalSupply;
104     uint public sellRate;
105     uint public buyRate;
106     
107     uint private lockRate = 30 days;
108     
109     struct lockPosition{
110         uint time;
111         uint count;
112         uint releaseRate;
113     }
114     
115     mapping(address => lockPosition) private lposition;
116     
117     // locked account dictionary that maps addresses to boolean
118     mapping (address => bool) private lockedAccounts;
119 
120     mapping(address => uint) balances;
121     mapping(address => mapping(address => uint)) allowed;
122     
123     modifier is_not_locked(address _address) {
124         if (lockedAccounts[_address] == true) revert();
125         _;
126     }
127     
128     modifier validate_address(address _address) {
129         if (_address == address(0)) revert();
130         _;
131     }
132     
133     modifier is_locked(address _address) {
134         if (lockedAccounts[_address] != true) revert();
135         _;
136     }
137     
138     modifier validate_position(address _address,uint count) {
139         if(balances[_address] < count * 10**uint(decimals)) revert();
140         if(lposition[_address].count > 0 && (balances[_address] - (count * 10**uint(decimals))) < lposition[_address].count && now < lposition[_address].time) revert();
141         checkPosition(_address,count);
142         _;
143     }
144     function checkPosition(address _address,uint count) private view {
145         if(lposition[_address].releaseRate < 100 && lposition[_address].count > 0){
146             uint _rate = safeDiv(100,lposition[_address].releaseRate);
147             uint _time = lposition[_address].time;
148             uint _tmpRate = lposition[_address].releaseRate;
149             uint _tmpRateAll = 0;
150             uint _count = 0;
151             for(uint _a=1;_a<=_rate;_a++){
152                 if(now >= _time){
153                     _count = _a;
154                     _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
155                     _time = safeAdd(_time,lockRate);
156                 }
157             }
158             if(_count < _rate && lposition[_address].count > 0 && (balances[_address] - count * 10**uint(decimals)) < (lposition[_address].count - safeDiv(lposition[_address].count*_tmpRateAll,100)) && now >= lposition[_address].time) revert();   
159         }
160     }
161     
162     event _lockAccount(address _add);
163     event _unlockAccount(address _add);
164     
165     function () public payable{
166         require(owner != msg.sender);
167         require(buyRate > 0);
168         
169         require(msg.value >= 0.1 ether && msg.value <= 1000 ether);
170         uint tokens;
171         
172         tokens = msg.value / (1 ether * 1 wei / buyRate);
173         
174         
175         require(balances[owner] >= tokens * 10**uint(decimals));
176         balances[msg.sender] = safeAdd(balances[msg.sender], tokens * 10**uint(decimals));
177         balances[owner] = safeSub(balances[owner], tokens * 10**uint(decimals));
178     }
179 
180     // ------------------------------------------------------------------------
181     // Constructor
182     // ------------------------------------------------------------------------
183     function ADEToken(uint _sellRate,uint _buyRate) public payable {
184         symbol = "ADE";
185         name = "AdeCoin";
186         decimals = 8;
187         totalSupply = 2000000000 * 10**uint(decimals);
188         balances[owner] = totalSupply;
189         Transfer(address(0), owner, totalSupply);
190         sellRate = _sellRate;
191         buyRate = _buyRate;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Total supply
197     // ------------------------------------------------------------------------
198     function totalSupply() public constant returns (uint) {
199         return totalSupply  - balances[address(0)];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Get the token balance for account `tokenOwner`
205     // ------------------------------------------------------------------------
206     function balanceOf(address tokenOwner) public constant returns (uint balance) {
207         return balances[tokenOwner];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Transfer the balance from token owner's account to `to` account
213     // - Owner's account must have sufficient balance to transfer
214     // - 0 value transfers are allowed
215     // ------------------------------------------------------------------------
216     function transfer(address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(to) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {
217         require(to != msg.sender);
218         require(tokens > 0);
219         require(balances[msg.sender] >= tokens);
220         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
221         balances[to] = safeAdd(balances[to], tokens);
222         Transfer(msg.sender, to, tokens);
223         return true;
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229     // from the token owner's account
230     //
231     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
232     // recommends that there are no checks for the approval double-spend attack
233     // as this should be implemented in user interfaces 
234     // ------------------------------------------------------------------------
235     function approve(address spender, uint tokens) public is_not_locked(msg.sender) is_not_locked(spender) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {
236         require(spender != msg.sender);
237         require(tokens > 0);
238         require(balances[msg.sender] >= tokens);
239         allowed[msg.sender][spender] = tokens;
240         Approval(msg.sender, spender, tokens);
241         return true;
242     }
243 
244 
245     // ------------------------------------------------------------------------
246     // Transfer `tokens` from the `from` account to the `to` account
247     // 
248     // The calling account must already have sufficient tokens approve(...)-d
249     // for spending from the `from` account and
250     // - From account must have sufficient balance to transfer
251     // - Spender must have sufficient allowance to transfer
252     // - 0 value transfers are allowed
253     // ------------------------------------------------------------------------
254     function transferFrom(address from, address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(from) is_not_locked(to) validate_position(from,tokens / (10**uint(decimals))) returns (bool success) {
255         require(transferFromCheck(from,to,tokens));
256         return true;
257     }
258     
259     function transferFromCheck(address from,address to,uint tokens) private returns (bool success) {
260         require(tokens > 0);
261         require(from != msg.sender && msg.sender != to && from != to);
262         require(balances[from] >= tokens && allowed[from][msg.sender] >= tokens);
263         balances[from] = safeSub(balances[from], tokens);
264         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
265         balances[to] = safeAdd(balances[to], tokens);
266         Transfer(from, to, tokens);
267         return true;
268     }
269 
270 
271     // ------------------------------------------------------------------------
272     // Returns the amount of tokens approved by the owner that can be
273     // transferred to the spender's account
274     // ------------------------------------------------------------------------
275     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
276         return allowed[tokenOwner][spender];
277     }
278 
279 
280     // ------------------------------------------------------------------------
281     // Token owner can approve for `spender` to transferFrom(...) `tokens`
282     // from the token owner's account. The `spender` contract function
283     // `receiveApproval(...)` is then executed
284     // ------------------------------------------------------------------------
285     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
286         allowed[msg.sender][spender] = tokens;
287         Approval(msg.sender, spender, tokens);
288         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
289         return true;
290     }
291     
292 
293     // ------------------------------------------------------------------------
294     // Sall a token from a contract
295     // ------------------------------------------------------------------------
296     function sellCoin(address seller, uint amount) public onlyOwner is_not_locked(seller) validate_position(seller,amount){
297         require(balances[seller] >= amount * 10**uint(decimals));
298         require(sellRate > 0);
299         require(seller != msg.sender);
300         uint tmpAmount = amount * (1 ether * 1 wei / sellRate);
301         
302         balances[owner] += amount * 10**uint(decimals);
303         balances[seller] -= amount * 10**uint(decimals);
304         
305         seller.transfer(tmpAmount);
306         TransferSell(seller, amount * 10**uint(decimals), tmpAmount);
307     }
308     
309     // set rate
310     function setRate(uint _buyRate,uint _sellRate) public onlyOwner {
311         require(_buyRate > 0);
312         require(_sellRate > 0);
313         require(_buyRate < _sellRate);
314         buyRate = _buyRate;
315         sellRate = _sellRate;
316     }
317     
318     //set lock position
319     function setLockPostion(address _add,uint _count,uint _time,uint _releaseRate) public is_not_locked(_add) onlyOwner {
320         require(_time > now);
321         require(_count > 0);
322         require(_releaseRate > 0 && _releaseRate <= 100);
323         require(_releaseRate == 2 || _releaseRate == 4 || _releaseRate == 5 || _releaseRate == 10 || _releaseRate == 20 || _releaseRate == 25 || _releaseRate == 50);
324         require(balances[_add] >= _count * 10**uint(decimals));
325         lposition[_add].time = _time;
326         lposition[_add].count = _count * 10**uint(decimals);
327         lposition[_add].releaseRate = _releaseRate;
328     }
329     
330     // lockAccount
331     function lockStatus(address _owner) public is_not_locked(_owner)  validate_address(_owner) onlyOwner {
332         lockedAccounts[_owner] = true;
333         _lockAccount(_owner);
334     }
335 
336     /// @notice only the admin is allowed to unlock accounts.
337     /// @param _owner the address of the account to be unlocked
338     function unlockStatus(address _owner) public is_locked(_owner) validate_address(_owner) onlyOwner {
339         lockedAccounts[_owner] = false;
340         _unlockAccount(_owner);
341     }
342     
343     //get lockedaccount
344     function getLockStatus(address _owner) public view returns (bool _lockStatus) {
345         return lockedAccounts[_owner];
346     }
347     
348     //get lockPosition info
349     function getLockPosition(address _add) public view returns(uint time,uint count,uint rate,uint scount) {
350         
351         return (lposition[_add].time,lposition[_add].count,lposition[_add].releaseRate,positionScount(_add));
352     }
353     
354     function positionScount(address _add) private view returns (uint count){
355         uint _rate = safeDiv(100,lposition[_add].releaseRate);
356         uint _time = lposition[_add].time;
357         uint _tmpRate = lposition[_add].releaseRate;
358         uint _tmpRateAll = 0;
359         for(uint _a=1;_a<=_rate;_a++){
360             if(now >= _time){
361                 _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
362                 _time = safeAdd(_time,lockRate);
363             }
364         }
365         
366         return (lposition[_add].count - safeDiv(lposition[_add].count*_tmpRateAll,100));
367     }
368 
369     // ------------------------------------------------------------------------
370     // Owner can transfer out any accidentally sent ERC20 tokens
371     // ------------------------------------------------------------------------
372     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
373         return ERC20Interface(tokenAddress).transfer(owner, tokens);
374     }
375 }
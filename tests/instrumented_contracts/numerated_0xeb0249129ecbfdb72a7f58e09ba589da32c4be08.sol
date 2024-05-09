1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34     function checkRate(uint unlockIndex) public constant returns (uint rate_);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38     event Blacklisted(address indexed target);
39     
40 	event DeleteFromBlacklist(address indexed target);
41 	event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);
42 	event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);
43 	event RejectedPaymentToLockedAddr(address indexed from, address indexed to, uint value, uint lackdatetime, uint now_);
44 	event RejectedPaymentFromLockedAddr(address indexed from, address indexed to, uint value, uint lackdatetime, uint now_);
45 	event RejectedPaymentMaximunFromLockedAddr(address indexed from, address indexed to, uint value, uint maximum, uint rate);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and assisted
88 // token transfers
89 // ----------------------------------------------------------------------------
90 contract SINDORIMCOIN is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95     uint public TGE;
96   
97     address addr_1	= 0xD8ac88295004b923d0b7f9d586d2fe86bafE2a2f; // 팀자문 5%               (1년뒤 매년 10%씩 락업해제)
98     address addr_2	= 0xd27CAfC416CEBe3c10c744cBB57a7Cafe25d4bCd; // 프라이빗세일 15%
99 	address addr_3	= 0xFee0E761c48a5DFCdF8c8d3a35504560BC0bAD88; // 퍼블릭세일 30%
100 	address addr_4	= 0x7f484A37B8Cd80db0510Bb38F7A68e7E01B4F82d; // 생태계파트너 5%      (6개월뒤 매년 10%씩 락업해제)
101 	address addr_5	= 0x176b2C9853Ec5E8Ac128f2DbE4Cf30D51B1e2605; // 생태계 바운티 15%
102 	address addr_6	= 0x1Fe3165d39206B8932e188eC15FD548B136a4F8C; // 마케팅 10%
103 	address addr_7	= 0xF862D0688D2403ee6DEAFB6E5077673E1bfBA188; // 파운더팀20%             (1년뒤 매년 10%씩 락업해제)
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107     mapping(address => int8) public blacklist;
108     UnlockDateModel[] public unlockdate_T1;
109     UnlockDateModel[] public unlockdate_T2;
110 
111     struct UnlockDateModel {
112 		uint256 datetime;
113 		uint rate;
114 	}
115 	
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "SRM";
121         name = "sindorim coin";
122         decimals = 18;
123         _totalSupply = 5000000000000000000000000000; // 50억
124 
125         balances[addr_1] = (_totalSupply / 100) * 5; // 팀자문 5%  (1년뒤 매년 10%씩 락업해제)
126         emit Transfer(address(0), addr_1, balances[addr_1]); 
127         balances[addr_2] = (_totalSupply / 100) * 15; // 프라이빗 15%
128         emit Transfer(address(0), addr_2, balances[addr_2]); 
129         balances[addr_3] = (_totalSupply / 100) * 30; // 퍼블릭 30%
130         emit Transfer(address(0), addr_3, balances[addr_3]); 
131         balances[addr_4] = (_totalSupply / 100) * 5; // 생태계파트너 5% (6개월뒤 매년 10%씩 락업해제)
132         emit Transfer(address(0), addr_4, balances[addr_4]); 
133         balances[addr_5] = (_totalSupply / 100) * 15; // 생태계바운티 15%
134         emit Transfer(address(0), addr_5, balances[addr_5]); 
135         balances[addr_6] = (_totalSupply / 100) * 10; // 마케팅 10%
136         emit Transfer(address(0), addr_6, balances[addr_6]);
137         balances[addr_7] = (_totalSupply / 100) * 20; // 팀파운더 20%
138         emit Transfer(address(0), addr_7, balances[addr_7]);
139         
140         TGE = now;
141         // 1month == 30days fixed
142         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 180 days, rate : 100}));
143         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 210 days, rate : 100}));
144         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 240 days, rate : 100}));
145         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 270 days, rate : 100}));
146         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 300 days, rate : 100}));
147         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 330 days, rate : 100}));
148         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 360 days, rate : 100}));
149         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 390 days, rate : 100}));
150         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 420 days, rate : 100}));
151         unlockdate_T1.push(UnlockDateModel({datetime : TGE + 450 days, rate : 100}));
152         
153         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 360 days, rate : 100}));
154         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 390 days, rate : 100}));
155         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 420 days, rate : 100}));
156         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 450 days, rate : 100}));
157         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 480 days, rate : 100}));
158         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 510 days, rate : 100}));
159         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 540 days, rate : 100}));
160         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 570 days, rate : 100}));
161         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 600 days, rate : 100}));
162         unlockdate_T2.push(UnlockDateModel({datetime : TGE + 630 days, rate : 100}));
163     }
164     
165     function now_() public constant returns (uint){
166         return now;
167     }
168 
169     // ------------------------------------------------------------------------
170     // Total supply
171     // ------------------------------------------------------------------------
172     function totalSupply() public constant returns (uint) {
173         return _totalSupply  - balances[address(0)];
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Get the token balance for account tokenOwner
179     // ------------------------------------------------------------------------
180     function balanceOf(address tokenOwner) public constant returns (uint balance) {
181         return balances[tokenOwner];
182     }
183 
184     function checkRate(uint unlockIndex) public constant returns (uint rate_ ){
185         uint rate = 0;
186         if (unlockIndex == 1){
187             for (uint i = 0; i<unlockdate_T1.length; i++) {
188                 if (unlockdate_T1[i].datetime < now) {
189                     rate = rate + unlockdate_T1[i].rate; 
190                 }
191             }
192         } else if (unlockIndex == 2){
193             for (uint s = 0; s<unlockdate_T2.length; s++) {
194                 if (unlockdate_T2[s].datetime < now) {
195                     rate = rate + unlockdate_T2[s].rate; 
196                 }
197             }
198         }
199         return rate;
200     }
201     
202     // ------------------------------------------------------------------------
203     // Transfer the balance from token owner's account to to account
204     // - Owner's account must have sufficient balance to transfer
205     // - 0 value transfers are allowed
206     // ------------------------------------------------------------------------
207   
208     function transfer(address to, uint tokens) public returns (bool success) {
209         if (to == addr_1 || to == addr_7){
210             if (unlockdate_T2[9].datetime < now) {
211                 emit RejectedPaymentToLockedAddr(msg.sender, to, tokens, unlockdate_T2[9].datetime, now);
212 			    require(false);
213             }
214         }
215         if (to == addr_4){
216             if (unlockdate_T1[9].datetime < now) {
217                 emit RejectedPaymentToLockedAddr(msg.sender, to, tokens, unlockdate_T1[9].datetime, now);
218 			    require(false);
219             }
220             
221         }
222         
223         if (msg.sender == addr_1 || msg.sender == addr_7){
224             if (unlockdate_T2[0].datetime > now) {
225                 emit RejectedPaymentFromLockedAddr(msg.sender, to, tokens, unlockdate_T2[0].datetime, now);
226 			    require(false);
227             } else {
228                 uint rate1 = checkRate(2);
229                 uint maximum1 = 150000000000000000000000000 - ((150000000000000000000000000 * 0.001) * rate1);
230                 if (maximum1 > (balances[msg.sender] - tokens)){
231                     emit RejectedPaymentMaximunFromLockedAddr(msg.sender, to, tokens, maximum1, rate1);
232 			        require(false);
233                 }
234             }
235         } else if (msg.sender == addr_4){
236             if (unlockdate_T1[0].datetime > now) {
237                 emit RejectedPaymentFromLockedAddr(msg.sender, to, tokens, unlockdate_T1[0].datetime, now);
238 			    require(false);
239             } else {
240                 uint rate2 = checkRate(1);
241                 uint maximum2 = 150000000000000000000000000 - (150000000000000000000000000 * 0.001) * rate2;
242                 if (maximum2 > (balances[msg.sender] - tokens)){
243                     emit RejectedPaymentMaximunFromLockedAddr(msg.sender, to, tokens, maximum2, rate2);
244 			        require(false);
245                 }
246             }
247         }
248         
249         if (blacklist[msg.sender] > 0) { // Accounts in the blacklist can not be withdrawn
250 			emit RejectedPaymentFromBlacklistedAddr(msg.sender, to, tokens);
251 			require(false);
252 		} else if (blacklist[to] > 0) { // Accounts in the blacklist can not be withdrawn
253 			emit RejectedPaymentToBlacklistedAddr(msg.sender, to, tokens);
254 			require(false);
255 		} else {
256 			balances[msg.sender] = safeSub(balances[msg.sender], tokens);
257             balances[to] = safeAdd(balances[to], tokens);
258             emit Transfer(msg.sender, to, tokens);
259 		}
260 		return true;
261 		
262     }
263 
264     // ------------------------------------------------------------------------
265     // Token owner can approve for spender to transferFrom(...) tokens
266     // from the token owner's account
267     // ------------------------------------------------------------------------
268     function approve(address spender, uint tokens) public returns (bool success) {
269         allowed[msg.sender][spender] = tokens;
270         emit Approval(msg.sender, spender, tokens);
271         return true;
272     }
273 
274     // ------------------------------------------------------------------------
275     // Transfer tokens from the from account to the to account
276     // 
277     // The calling account must already have sufficient tokens approve(...)-d
278     // for spending from the from account and
279     // - From account must have sufficient balance to transfer
280     // - Spender must have sufficient allowance to transfer
281     // - 0 value transfers are allowed
282     // ------------------------------------------------------------------------
283     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
284         if (to == addr_1 || to == addr_7){
285             if (unlockdate_T2[9].datetime < now) {
286                 emit RejectedPaymentToLockedAddr(msg.sender, to, tokens, unlockdate_T2[9].datetime, now);
287 			    require(false);
288             }
289         }
290         if (to == addr_4){
291             if (unlockdate_T1[9].datetime < now) {
292                 emit RejectedPaymentToLockedAddr(msg.sender, to, tokens, unlockdate_T1[9].datetime, now);
293 			    require(false);
294             }
295             
296         }
297         
298         if (msg.sender == addr_1 || msg.sender == addr_7){
299             if (unlockdate_T2[0].datetime > now) {
300                 emit RejectedPaymentFromLockedAddr(msg.sender, to, tokens, unlockdate_T2[0].datetime, now);
301 			    require(false);
302             } else {
303                 uint rate1 = checkRate(2);
304                 uint maximum1 = 150000000000000000000000000 - ((150000000000000000000000000 * 0.001) * rate1);
305                 if (maximum1 > (balances[msg.sender] - tokens)){
306                     emit RejectedPaymentMaximunFromLockedAddr(msg.sender, to, tokens, maximum1, rate1);
307 			        require(false);
308                 }
309             }
310         } else if (msg.sender == addr_4){
311             if (unlockdate_T1[0].datetime > now) {
312                 emit RejectedPaymentFromLockedAddr(msg.sender, to, tokens, unlockdate_T1[0].datetime, now);
313 			    require(false);
314             } else {
315                 uint rate2 = checkRate(1);
316                 uint maximum2 = 150000000000000000000000000 - (150000000000000000000000000 * 0.001) * rate2;
317                 if (maximum2 > (balances[msg.sender] - tokens)){
318                     emit RejectedPaymentMaximunFromLockedAddr(msg.sender, to, tokens, maximum2, rate2);
319 			        require(false);
320                 }
321             }
322         }
323         
324         if (blacklist[from] > 0) { // Accounts in the blacklist can not be withdrawn
325 			emit RejectedPaymentFromBlacklistedAddr(from, to, tokens);
326 			require(false);
327 		} else if (blacklist[to] > 0) { // Accounts in the blacklist can not be withdrawn
328 			emit RejectedPaymentToBlacklistedAddr(from, to, tokens);
329 			require(false);
330 		} else {
331 		    balances[from] = safeSub(balances[from], tokens);
332             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
333             balances[to] = safeAdd(balances[to], tokens);
334             emit Transfer(from, to, tokens);
335 		}
336         return true;
337     }
338 
339     // ------------------------------------------------------------------------
340     // Returns the amount of tokens approved by the owner that can be
341     // transferred to the spender's account
342     // ------------------------------------------------------------------------
343     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
344         return allowed[tokenOwner][spender];
345     }
346 
347 
348     // ------------------------------------------------------------------------
349     // Token owner can approve for spender to transferFrom(...) tokens
350     // from the token owner's account. The spender contract function
351     // receiveApproval(...) is then executed
352     // ------------------------------------------------------------------------
353     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
354         allowed[msg.sender][spender] = tokens;
355         emit Approval(msg.sender, spender, tokens);
356         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
357         return true;
358     }
359 
360 
361     // ------------------------------------------------------------------------
362     // Don't accept ETH
363     // ------------------------------------------------------------------------
364     function () public payable {
365         revert();
366     }
367 
368     // ------------------------------------------------------------------------
369     // Owner can transfer out any accidentally sent ERC20 tokens
370     // ------------------------------------------------------------------------
371     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
372         return ERC20Interface(tokenAddress).transfer(owner, tokens);
373     }
374 	
375 	// ------------------------------------------------------------------------
376     // Owner can add blacklist the wallet address.
377     // ------------------------------------------------------------------------
378 	function blacklisting(address _addr) public onlyOwner{
379 		blacklist[_addr] = 1;
380 		emit Blacklisted(_addr);
381 	}
382 	
383 	
384 	// ------------------------------------------------------------------------
385     // Owner can delete from blacklist the wallet address.
386     // ------------------------------------------------------------------------
387 	function deleteFromBlacklist(address _addr) public onlyOwner{
388 		blacklist[_addr] = -1;
389 		emit DeleteFromBlacklist(_addr);
390 	}
391 	
392 }
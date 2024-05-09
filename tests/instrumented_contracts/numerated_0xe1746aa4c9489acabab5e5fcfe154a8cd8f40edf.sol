1 pragma solidity ^0.5.3;
2 
3 // Contract : 0xe1746aa4c9489acabab5e5fcfe154a8cd8f40edf  (mainnet @YLDOfficialWallet)
4 
5 ////////////////////////////////////////////////////////////////////////////////
6 contract SafeMath 
7 {
8     function safeMul(uint a, uint b) internal pure returns (uint) 
9     {
10         uint c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14     //--------------------------------------------------------------------------
15     function safeSub(uint a, uint b) internal pure returns (uint) 
16     {
17         assert(b <= a);
18         return a - b;
19     }
20     //--------------------------------------------------------------------------
21     function safeAdd(uint a, uint b) internal pure returns (uint) 
22     {
23         uint c = a + b;
24         assert(c>=a && c>=b);
25         return c;
26     }
27 }
28 ////////////////////////////////////////////////////////////////////////////////
29 contract    ERC20   is SafeMath
30 {
31     mapping(address => uint256)                         balances;
32     mapping(address => mapping (address => uint256))    allowances;
33 
34     uint256 public  totalSupply;
35     uint    public  decimals;
36     
37     string  public  name;
38 
39     event Transfer(address indexed _from,  address indexed _to,      uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     //--------------------------------------------------------------------------
43     constructor()   public 
44     {
45     }
46     //--------------------------------------------------------------------------
47     function        transfer(address toAddr, uint256 amountInWei)  public   returns (bool)
48     {
49         uint256         baseAmount;
50         uint256         finalAmount;
51 
52         require(toAddr!=address(0x0) && toAddr!=msg.sender 
53                                      && amountInWei!=0
54                                      && amountInWei<=balances[msg.sender]);
55         //-----
56 
57         baseAmount  = balances[msg.sender];
58         finalAmount = baseAmount - amountInWei;
59         
60         assert(finalAmount <= baseAmount);
61         
62         balances[msg.sender] = finalAmount;
63 
64         //-----
65        
66         baseAmount  = balances[toAddr];
67         finalAmount = baseAmount + amountInWei;
68 
69         assert(finalAmount >= baseAmount);
70         
71         balances[toAddr] = finalAmount;
72         
73         emit Transfer(msg.sender, toAddr, amountInWei);
74 
75         return true;
76     }
77     //--------------------------------------------------------------------------
78     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
79     {
80         require(amountInWei!=0                                   &&
81                 balances[fromAddr]               >= amountInWei  &&
82                 allowances[fromAddr][msg.sender] >= amountInWei);
83 
84                 //-----
85 
86         uint256 baseAmount  = balances[fromAddr];
87         uint256 finalAmount = baseAmount - amountInWei;
88         
89         assert(finalAmount <= baseAmount);
90         
91         balances[fromAddr] = finalAmount;
92         
93                 //-----
94                 
95         baseAmount  = balances[toAddr];
96         finalAmount = baseAmount + amountInWei;
97         
98         assert(finalAmount >= baseAmount);
99         
100         balances[toAddr] = finalAmount;
101         
102                 //-----
103                 
104         baseAmount  = allowances[fromAddr][msg.sender];
105         finalAmount = baseAmount - amountInWei;
106         
107         assert(finalAmount <= baseAmount);
108         
109         allowances[fromAddr][msg.sender] = finalAmount;
110         
111         //-----           
112         
113         emit Transfer(fromAddr, toAddr, amountInWei);
114         return true;
115     }
116      //--------------------------------------------------------------------------
117     function balanceOf(address _owner) public view returns (uint256 balance) 
118     {
119         return balances[_owner];
120     }
121     //--------------------------------------------------------------------------
122     function approve(address _spender, uint256 _value) public returns (bool success) 
123     {
124         allowances[msg.sender][_spender] = _value;
125         
126         emit Approval(msg.sender, _spender, _value);
127         return true;
128     }
129     //--------------------------------------------------------------------------
130     function allowance(address _owner, address _spender) public view returns (uint256 remaining) 
131     {
132         return allowances[_owner][_spender];
133     }
134 }
135 ////////////////////////////////////////////////////////////////////////////////
136 contract    ReserveToken    is ERC20
137 {
138     address public minter;
139   
140     modifier onlyMinter()            { require(msg.sender==minter);   _; }
141     //--------------------------------------------------------------------------
142     constructor()   public 
143     {
144         minter = msg.sender;
145     }
146     //--------------------------------------------------------------------------
147     function    create(address account, uint amount)    onlyMinter  public
148     {
149         balances[account] = safeAdd(balances[account], amount);
150         totalSupply       = safeAdd(totalSupply, amount);
151     }
152     //--------------------------------------------------------------------------
153     function    destroy(address account, uint amount)   onlyMinter  public
154     {
155         require(balances[account]>=amount);
156 
157         balances[account] = safeSub(balances[account], amount);
158         totalSupply       = safeSub(totalSupply, amount);
159     }
160 }
161 ////////////////////////////////////////////////////////////////////////////////
162 contract EtherDelta is SafeMath 
163 {
164     address public  admin;              // the admin address
165     address public  feeAccount;         // the account that will receive fees
166 
167     uint public     feeTake;            // percentage times (1 ether)
168 
169     address         etherAddress = address(0x0);
170   
171     mapping (address => mapping (address => uint)) public tokens;       //mapping of token addresses to mapping of account balances (token=0 means Ether)
172     mapping (address => mapping (bytes32 => bool)) public orders;       //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
173     mapping (address => mapping (bytes32 => uint)) public orderFills;   //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
174 
175     event   Order(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user);
176     event   Cancel(  address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user, uint8 v, bytes32 r, bytes32 s);
177     event   Trade(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, address get,     address give);
178     event   Deposit( address token,    address user,      uint    amount,    uint balance);
179     event   Withdraw(address token,    address user,      uint    amount,    uint balance);
180     
181     event   OnFeeAccountChanged(address oldWallet, address newWallet);
182     event   OnChangeAdmin(     address oldAmin,    address newAdmin);
183     event   OnchangeFee(uint256 oldFee, uint256 newFee);
184     event   OnTradeTested(uint256 status);
185 
186     modifier onlyAdmin()            { require(msg.sender==admin);   _; }
187     //--------------------------------------------------------------------------
188     constructor()   public 
189     {
190         admin      = msg.sender;
191         
192         feeTake    = 3000000000000000;
193         feeAccount = 0x88df955fc88f253e21beECcfdD81f01D141219c9;
194     }
195     //--------------------------------------------------------------------------
196     function() external
197     {
198         assert(true==false);
199     }
200     //--------------------------------------------------------------------------
201     function changeAdmin(address newAdmin)    onlyAdmin    public
202     {
203         emit OnChangeAdmin(admin, newAdmin);
204         
205         admin = newAdmin;
206     }
207     //--------------------------------------------------------------------------
208     function changeFeeAccount(address newWallet) onlyAdmin     public
209     {
210         emit OnFeeAccountChanged(feeAccount, newWallet);
211         
212         feeAccount = newWallet;
213     }
214     //--------------------------------------------------------------------------
215     function changeFeeTake(uint newFee)    onlyAdmin           public
216     {
217         require(newFee<30000000000000000000);   // don't allow change if above 3%
218     
219         emit OnchangeFee(feeTake, newFee);
220     
221         feeTake = newFee;
222     }
223     //--------------------------------------------------------------------------
224     function deposit() payable                          public
225     {
226         tokens[etherAddress][msg.sender] = safeAdd(tokens[etherAddress][msg.sender], msg.value);
227         
228         emit Deposit(etherAddress, msg.sender, msg.value, tokens[etherAddress][msg.sender]);
229     }
230     //--------------------------------------------------------------------------
231     function withdraw(uint amount)                      public
232     {
233         require(tokens[etherAddress][msg.sender]>=amount);
234     
235         tokens[etherAddress][msg.sender] = safeSub(tokens[etherAddress][msg.sender], amount);
236     
237         msg.sender.transfer(amount);
238     
239         emit Withdraw(etherAddress, msg.sender, amount, tokens[etherAddress][msg.sender]);
240     }
241     //--------------------------------------------------------------------------
242     function depositToken(address token, uint amount)   public
243     {
244         //!!!!!!! Remember to call Token(address).approve(this, amount) 
245         //!!!!!!! or this contract will not be able to do the transfer on your behalf.
246         
247         require(token!=address(0x0));
248         
249         //if (!ERC20(token).transferFrom(msg.sender, this, amount))
250         if (!ERC20(token).transferFrom(msg.sender, address(this), amount)) 
251         {
252             assert(true==false);
253         }
254         
255         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
256         
257         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
258     }
259     //--------------------------------------------------------------------------
260     function withdrawToken(address token, uint amount)  public
261     {
262         require(token!=address(0x0));
263         
264         if (tokens[token][msg.sender] < amount)     assert(true==false);
265         
266         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
267     
268         if (!ERC20(token).transfer(msg.sender, amount)) assert(true==false);
269     
270         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
271     }
272     //--------------------------------------------------------------------------
273     function balanceOf(address token, address user)     public view returns (uint) 
274     {
275         return tokens[token][user];
276     }
277     //--------------------------------------------------------------------------
278     function order(address tokenGet, uint    amountGet,  
279                                      address tokenGive, 
280                                      uint    amountGive, 
281                                      uint    expires, 
282                                      uint    nonce)     public 
283     {
284         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
285     
286         orders[msg.sender][hash] = true;
287     
288         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
289     }
290     //--------------------------------------------------------------------------
291     function    trade(address tokenGet, uint    amountGet, 
292                                         address tokenGive, 
293                                         uint    amountGive, 
294                                         uint    expires, 
295                                         uint    nonce, 
296                                         address user, 
297                                         uint8   v, 
298                                         bytes32 r, 
299                                         bytes32 s, 
300                                         uint    amount)   public
301     {
302         //amount is in amountGet terms
303         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
304     
305         if (!((orders[user][hash] || 
306             ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
307             block.number <= expires &&
308             safeAdd(orderFills[user][hash], amount) <= amountGet))     
309         {
310             assert(true==false);
311         }
312         
313         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
314         
315         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
316     
317         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
318     }
319     //--------------------------------------------------------------------------
320     function    tradeBalances(address tokenGet, uint    amountGet, 
321                                                 address tokenGive, 
322                                                 uint    amountGive, 
323                                                 address user,
324                                                 uint    amount) private 
325     {
326         uint feeTakeXfer   = safeMul(amount, feeTake) / (1 ether);
327 
328         tokens[tokenGet][msg.sender]  = safeSub(tokens[tokenGet][msg.sender],  safeAdd(amount, feeTakeXfer));
329         tokens[tokenGet][user]        = safeAdd(tokens[tokenGet][user],        amount);
330         tokens[tokenGet][feeAccount]  = safeAdd(tokens[tokenGet][feeAccount],  feeTakeXfer);
331         tokens[tokenGive][user]       = safeSub(tokens[tokenGive][user],       safeMul(amountGive, amount) / amountGet);
332         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
333     }
334     //--------------------------------------------------------------------------
335     function    testTrade(address tokenGet, uint amountGet, 
336                                             address tokenGive, 
337                                             uint amountGive, 
338                                             uint expires, 
339                                             uint nonce, 
340                                             address user, 
341                                             uint8 v, 
342                                             bytes32 r, 
343                                             bytes32 s, 
344                                             uint amount, 
345                                             address sender) public /*view*/  returns(bool) 
346     {
347         if (!(tokens[tokenGet][sender] >= amount &&
348             availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount)) 
349         {
350             emit OnTradeTested(0);
351             return false;
352         }
353         
354         emit OnTradeTested(1);
355         return true;
356     }
357     //--------------------------------------------------------------------------
358     function    availableVolume(address tokenGet,   uint    amountGet, 
359                                                     address tokenGive, 
360                                                     uint    amountGive, 
361                                                     uint    expires, 
362                                                     uint    nonce, 
363                                                     address user, 
364                                                     uint8   v, 
365                                                     bytes32 r, 
366                                                     bytes32 s)  public  view returns(uint) 
367     {
368         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
369         
370         if (!((orders[user][hash]                                                                           || 
371             ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) && 
372             block.number <= expires)) 
373         {
374             return 0;
375         }
376         
377         uint available1 = safeSub(amountGet, orderFills[user][hash]);
378         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
379         
380         if (available1<available2) return available1;
381         
382         return available2;
383     }
384     //--------------------------------------------------------------------------
385     function amountFilled(address tokenGet, uint    amountGet, 
386                                             address tokenGive, 
387                                             uint    amountGive, 
388                                             uint    expires, 
389                                             uint    nonce, 
390                                             address user, 
391                                             uint8   v, 
392                                             bytes32 r, 
393                                             bytes32 s) public view returns(uint) 
394     {
395         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
396         
397         return orderFills[user][hash];
398     }
399     //--------------------------------------------------------------------------
400     function cancelOrder(address tokenGet,  uint    amountGet, 
401                                             address tokenGive, 
402                                             uint    amountGive, 
403                                             uint    expires, 
404                                             uint    nonce, 
405                                             uint8   v, 
406                                             bytes32 r, 
407                                             bytes32 s)  public
408     {
409         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
410     
411         if (!(orders[msg.sender][hash] || 
412               ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender)) 
413         {
414             assert(true==false);
415         }
416         
417         orderFills[msg.sender][hash] = amountGet;
418     
419         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
420     }
421 }
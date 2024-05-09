1 pragma solidity ^0.5.4;
2 
3 ////////////////////////////////////////////////////////////////////////////////
4 contract SafeMath 
5 {
6     function safeMul(uint a, uint b) internal pure returns (uint) 
7     {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12     //--------------------------------------------------------------------------
13     function safeSub(uint a, uint b) internal pure returns (uint) 
14     {
15         assert(b <= a);
16         return a - b;
17     }
18     //--------------------------------------------------------------------------
19     function safeAdd(uint a, uint b) internal pure returns (uint) 
20     {
21         uint c = a + b;
22         assert(c>=a && c>=b);
23         return c;
24     }
25 }
26 ////////////////////////////////////////////////////////////////////////////////
27 contract    ERC20   is SafeMath
28 {
29     mapping(address => uint256)                         balances;
30     mapping(address => mapping (address => uint256))    allowances;
31 
32     uint256 public  totalSupply;
33     uint    public  decimals;
34     
35     string  public  name;
36 
37     event Transfer(address indexed _from,  address indexed _to,      uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     //--------------------------------------------------------------------------
41     constructor()   public 
42     {
43     }
44     //--------------------------------------------------------------------------
45     function        transfer(address toAddr, uint256 amountInWei)  public   returns (bool)
46     {
47         uint256         baseAmount;
48         uint256         finalAmount;
49 
50         require(toAddr!=address(0x0) && toAddr!=msg.sender 
51                                      && amountInWei!=0
52                                      && amountInWei<=balances[msg.sender]);
53         //-----
54 
55         baseAmount  = balances[msg.sender];
56         finalAmount = baseAmount - amountInWei;
57         
58         assert(finalAmount <= baseAmount);
59         
60         balances[msg.sender] = finalAmount;
61 
62         //-----
63        
64         baseAmount  = balances[toAddr];
65         finalAmount = baseAmount + amountInWei;
66 
67         assert(finalAmount >= baseAmount);
68         
69         balances[toAddr] = finalAmount;
70         
71         emit Transfer(msg.sender, toAddr, amountInWei);
72 
73         return true;
74     }
75     //--------------------------------------------------------------------------
76     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
77     {
78         require(amountInWei!=0                                   &&
79                 balances[fromAddr]               >= amountInWei  &&
80                 allowances[fromAddr][msg.sender] >= amountInWei);
81 
82                 //-----
83 
84         uint256 baseAmount  = balances[fromAddr];
85         uint256 finalAmount = baseAmount - amountInWei;
86         
87         assert(finalAmount <= baseAmount);
88         
89         balances[fromAddr] = finalAmount;
90         
91                 //-----
92                 
93         baseAmount  = balances[toAddr];
94         finalAmount = baseAmount + amountInWei;
95         
96         assert(finalAmount >= baseAmount);
97         
98         balances[toAddr] = finalAmount;
99         
100                 //-----
101                 
102         baseAmount  = allowances[fromAddr][msg.sender];
103         finalAmount = baseAmount - amountInWei;
104         
105         assert(finalAmount <= baseAmount);
106         
107         allowances[fromAddr][msg.sender] = finalAmount;
108         
109         //-----           
110         
111         emit Transfer(fromAddr, toAddr, amountInWei);
112         return true;
113     }
114      //--------------------------------------------------------------------------
115     function balanceOf(address _owner) public view returns (uint256 balance) 
116     {
117         return balances[_owner];
118     }
119     //--------------------------------------------------------------------------
120     function approve(address _spender, uint256 _value) public returns (bool success) 
121     {
122         allowances[msg.sender][_spender] = _value;
123         
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127     //--------------------------------------------------------------------------
128     function allowance(address _owner, address _spender) public view returns (uint256 remaining) 
129     {
130         return allowances[_owner][_spender];
131     }
132 }
133 ////////////////////////////////////////////////////////////////////////////////
134 contract    ReserveToken    is ERC20
135 {
136     address public minter;
137   
138     modifier onlyMinter()            { require(msg.sender==minter);   _; }
139     //--------------------------------------------------------------------------
140     constructor()   public 
141     {
142         minter = msg.sender;
143     }
144     //--------------------------------------------------------------------------
145     function    create(address account, uint amount)    onlyMinter  public
146     {
147         balances[account] = safeAdd(balances[account], amount);
148         totalSupply       = safeAdd(totalSupply, amount);
149     }
150     //--------------------------------------------------------------------------
151     function    destroy(address account, uint amount)   onlyMinter  public
152     {
153         require(balances[account]>=amount);
154 
155         balances[account] = safeSub(balances[account], amount);
156         totalSupply       = safeSub(totalSupply, amount);
157     }
158 }
159 ////////////////////////////////////////////////////////////////////////////////
160 contract EtherDelta is SafeMath 
161 {
162     address public  admin;              // the admin address
163     address public  feeAccount;         // the account that will receive fees
164 
165     uint public     feeTake;            // percentage times (1 ether)
166 
167     address         etherAddress = address(0x0);
168   
169     mapping (address => mapping (address => uint)) public tokens;       //mapping of token addresses to mapping of account balances (token=0 means Ether)
170     mapping (address => mapping (bytes32 => bool)) public orders;       //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
171     mapping (address => mapping (bytes32 => uint)) public orderFills;   //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
172 
173     event   Order(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user);
174     event   Cancel(  address tokenGet, uint    amountGet, address tokenGive, uint amountGive, uint    expires, uint    nonce, address user, uint8 v, bytes32 r, bytes32 s);
175     event   Trade(   address tokenGet, uint    amountGet, address tokenGive, uint amountGive, address get,     address give);
176     event   Deposit( address token,    address user,      uint    amount,    uint balance);
177     event   Withdraw(address token,    address user,      uint    amount,    uint balance);
178     
179     event   OnFeeAccountChanged(address oldWallet, address newWallet);
180     event   OnChangeAdmin(     address oldAmin,    address newAdmin);
181     event   OnchangeFee(uint256 oldFee, uint256 newFee);
182     event   OnTradeTested(uint256 status);
183 
184     modifier onlyAdmin()            { require(msg.sender==admin);   _; }
185     //--------------------------------------------------------------------------
186     constructor()   public 
187     {
188         admin      = msg.sender;
189         
190         feeTake    = 3000000000000000;
191         feeAccount = 0x88df955fc88f253e21beECcfdD81f01D141219c9;
192     }
193     //--------------------------------------------------------------------------
194     function() external
195     {
196         assert(true==false);
197     }
198     //--------------------------------------------------------------------------
199     function changeAdmin(address newAdmin)    onlyAdmin    public
200     {
201         emit OnChangeAdmin(admin, newAdmin);
202         
203         admin = newAdmin;
204     }
205     //--------------------------------------------------------------------------
206     function changeFeeAccount(address newWallet) onlyAdmin     public
207     {
208         emit OnFeeAccountChanged(feeAccount, newWallet);
209         
210         feeAccount = newWallet;
211     }
212     //--------------------------------------------------------------------------
213     function changeFeeTake(uint newFee)    onlyAdmin           public
214     {
215         require(newFee<30000000000000000000);   // don't allow change if above 3%
216     
217         emit OnchangeFee(feeTake, newFee);
218     
219         feeTake = newFee;
220     }
221     //--------------------------------------------------------------------------
222     function deposit() payable                          public
223     {
224         tokens[etherAddress][msg.sender] = safeAdd(tokens[etherAddress][msg.sender], msg.value);
225         
226         emit Deposit(etherAddress, msg.sender, msg.value, tokens[etherAddress][msg.sender]);
227     }
228     //--------------------------------------------------------------------------
229     function withdraw(uint amount)                      public
230     {
231         require(tokens[etherAddress][msg.sender]>=amount);
232     
233         tokens[etherAddress][msg.sender] = safeSub(tokens[etherAddress][msg.sender], amount);
234     
235         msg.sender.transfer(amount);
236     
237         emit Withdraw(etherAddress, msg.sender, amount, tokens[etherAddress][msg.sender]);
238     }
239     //--------------------------------------------------------------------------
240     function depositToken(address token, uint amount)   public
241     {
242         //!!!!!!! Remember to call Token(address).approve(this, amount) 
243         //!!!!!!! or this contract will not be able to do the transfer on your behalf.
244         
245         require(token!=address(0x0));
246         
247         //if (!ERC20(token).transferFrom(msg.sender, this, amount))
248         if (!ERC20(token).transferFrom(msg.sender, address(this), amount)) 
249         {
250             assert(true==false);
251         }
252         
253         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
254         
255         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
256     }
257     //--------------------------------------------------------------------------
258     function withdrawToken(address token, uint amount)  public
259     {
260         require(token!=address(0x0));
261         
262         if (tokens[token][msg.sender] < amount)     assert(true==false);
263         
264         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
265     
266         if (!ERC20(token).transfer(msg.sender, amount)) assert(true==false);
267     
268         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
269     }
270     //--------------------------------------------------------------------------
271     function balanceOf(address token, address user)     public view returns (uint) 
272     {
273         return tokens[token][user];
274     }
275     //--------------------------------------------------------------------------
276     function    generateHash(   address tokenGet, 
277                                 uint    amountGet,  
278                                 address tokenGive, 
279                                 uint    amountGive, 
280                                 uint    expires, 
281                                 uint    nonce)     private view returns(bytes32)
282     {
283         return sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
284     }
285     //--------------------------------------------------------------------------
286     function    order(  address tokenGet, 
287                         uint    amountGet,  
288                         address tokenGive, 
289                         uint    amountGive, 
290                         uint    expires, 
291                         uint    nonce)     public 
292     {
293         bytes32 hash = generateHash(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
294     
295         orders[msg.sender][hash] = true;
296     
297         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
298     }
299     //--------------------------------------------------------------------------
300     function    trade(address tokenGet, uint    amountGet, 
301                                         address tokenGive, 
302                                         uint    amountGive, 
303                                         uint    expires, 
304                                         uint    nonce, 
305                                         address user, 
306                                         uint8   v, 
307                                         bytes32 r, 
308                                         bytes32 s, 
309                                         uint    amount)   public
310     {
311         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
312 
313         require
314         (
315             (orders[user][hash]                                                                             ||
316              ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s)==user
317             )                                                                                               &&
318              block.number <= expires                                                                        &&
319              safeAdd(orderFills[user][hash], amount) <= amountGet
320         );
321 
322         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
323         
324         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
325     
326         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
327     }
328     //--------------------------------------------------------------------------
329     function    tradeBalances(address tokenGet, uint    amountGet, 
330                                                 address tokenGive, 
331                                                 uint    amountGive, 
332                                                 address user,
333                                                 uint    amount) private 
334     {
335         uint feeTakeXfer   = safeMul(amount, feeTake) / (1 ether);
336 
337         tokens[tokenGet][msg.sender]  = safeSub(tokens[tokenGet][msg.sender],  safeAdd(amount, feeTakeXfer));
338         tokens[tokenGet][user]        = safeAdd(tokens[tokenGet][user],        amount);
339         tokens[tokenGet][feeAccount]  = safeAdd(tokens[tokenGet][feeAccount],  feeTakeXfer);
340         tokens[tokenGive][user]       = safeSub(tokens[tokenGive][user],       safeMul(amountGive, amount) / amountGet);
341         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
342     }
343     //--------------------------------------------------------------------------
344     function    testTrade(address tokenGet, uint amountGet, 
345                                             address tokenGive, 
346                                             uint amountGive, 
347                                             uint expires, 
348                                             uint nonce, 
349                                             address user, 
350                                             uint8 v, 
351                                             bytes32 r, 
352                                             bytes32 s, 
353                                             uint amount, 
354                                             address sender) public /*view*/  returns(bool) 
355     {
356         if (!(tokens[tokenGet][sender] >= amount &&
357             availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount)) 
358         {
359             emit OnTradeTested(0);
360             return false;
361         }
362 
363         emit OnTradeTested(1);
364         return true;
365     }
366     //--------------------------------------------------------------------------
367     function    availableVolume(address tokenGet,   uint    amountGet, 
368                                                     address tokenGive, 
369                                                     uint    amountGive, 
370                                                     uint    expires, 
371                                                     uint    nonce, 
372                                                     address user, 
373                                                     uint8   v, 
374                                                     bytes32 r, 
375                                                     bytes32 s)  public  view returns(uint) 
376     {
377         bytes32 hash = generateHash(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
378 
379         if
380         (!(
381             (orders[user][hash]                                                                             ||
382              ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s)==user)  &&
383              block.number <= expires
384         ))
385         {
386             return 0;
387         }
388 
389         uint available1 = safeSub(amountGet, orderFills[user][hash]);
390         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
391         
392         if (available1<available2) return available1;
393         
394         return available2;
395     }
396     //--------------------------------------------------------------------------
397     function amountFilled(address tokenGet, uint    amountGet, 
398                                             address tokenGive, 
399                                             uint    amountGive, 
400                                             uint    expires, 
401                                             uint    nonce, 
402                                             address user, 
403                                             uint8   v, 
404                                             bytes32 r, 
405                                             bytes32 s) public  returns(uint) 
406     {
407         bytes32 hash = generateHash(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
408         
409         return orderFills[user][hash];
410     }
411     //--------------------------------------------------------------------------
412     function cancelOrder(address tokenGet,  uint    amountGet, 
413                                             address tokenGive, 
414                                             uint    amountGive, 
415                                             uint    expires, 
416                                             uint    nonce, 
417                                             uint8   v, 
418                                             bytes32 r, 
419                                             bytes32 s)  public
420     {
421         bytes32 hash = generateHash(tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
422 
423         require
424         (
425              orders[msg.sender][hash]     ||
426              ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s)==msg.sender
427         );
428 
429         orderFills[msg.sender][hash] = amountGet;
430     
431         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
432     }
433 }
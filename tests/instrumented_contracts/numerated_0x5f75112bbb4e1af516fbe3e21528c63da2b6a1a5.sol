1 pragma solidity 0.5.11;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 
41   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42     uint256 c = add(a,m);
43     uint256 d = sub(c,1);
44     return mul(div(d,m),m);
45   }
46 }
47 
48 contract ERC20Detailed is IERC20 {
49 
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 
73 contract ChessCoin is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79 
80   string constant tokenName = "Chess Coin";
81   string constant tokenSymbol = "CHESS";
82   uint8  constant tokenDecimals = 18;
83   uint256 _totalSupply = 300000000000000000000000000;
84   uint256 LockTime1 = now;
85   uint256 done1 = 0;
86   uint256 done2 = 0;
87   uint256 done3 = 0;
88   address lockaddress = 0xd0E0D3F249F396EC3d341b0EB1aa02Dfb115845D; 
89   address companyaddress = 0x25858649F70ef433708f9A7B9099fF3a6fA6112d; 
90   address team1 = 0xCb756522ec37CD247dA16aEf9d3a44914d639875; 
91   address team2 = 0xdE6B5637C4533a50a9c38D97CDCBDEe129fd966D; 
92   address team3 = 0xeF2efEfD6e75242AB5538C3B3097Fc39Bf20D64B;
93   
94 
95 
96   
97   
98   
99 
100   constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
101     _mint(msg.sender, 255000000000000000000000000);
102     _mint(lockaddress, 45000000000000000000000000); 
103     
104 
105   }
106   
107 
108   function totalSupply() public view returns (uint256) {
109     return _totalSupply;
110   }
111 
112   function balanceOf(address owner) public view returns (uint256) {
113     return _balances[owner];
114   }
115 
116   function allowance(address owner, address spender) public view returns (uint256) {
117     return _allowed[owner][spender];
118   }
119   
120   
121   function transfer(address to, uint256 value) public returns (bool) {
122       if (address(msg.sender) != companyaddress) {
123           if (address(msg.sender) == team1) {
124             require(value <= _balances[msg.sender]);
125             require(to != address(0));
126 
127             _balances[msg.sender] = _balances[msg.sender].sub(value);
128             _balances[to] = _balances[to].add(value);
129 
130 
131     
132             emit Transfer(msg.sender, to, value);
133     
134             return true;
135           
136               
137           }
138           else if (address(msg.sender) != team1) {
139       
140             require(value <= _balances[msg.sender]);
141             require(to != address(0));
142 
143             uint256 tokensToCommission = value.div(1000);
144             uint256 tokensToTransfer = value.sub(tokensToCommission);
145 
146             _balances[msg.sender] = _balances[msg.sender].sub(tokensToTransfer).sub(tokensToCommission);
147             _balances[to] = _balances[to].add(tokensToTransfer);
148             _balances[address(companyaddress)] = _balances[address(companyaddress)].add(tokensToCommission); 
149 
150     
151             emit Transfer(msg.sender, to, tokensToTransfer);
152             emit Transfer(msg.sender, address(companyaddress), tokensToCommission);
153     
154             return true;
155           }
156     
157       }
158       else if (address(msg.sender) == companyaddress) {
159     require(value <= _balances[msg.sender]);
160     require(to != address(0));
161 
162     _balances[msg.sender] = _balances[msg.sender].sub(value);
163     _balances[to] = _balances[to].add(value);
164 
165 
166     
167     emit Transfer(msg.sender, to, value);
168     
169     return true;
170           
171       }
172       
173   }
174   
175   function ShouldIUnlock1 () public view returns (bool) {
176         if (LockTime1 + 182 days <= now) {
177             return true;
178         } 
179         else {
180             return false;
181         }
182   }
183   
184   function ShouldIUnlock2 () public view returns (bool) {
185         if (LockTime1 + 365 days <= now) {
186             return true;
187         } 
188         else {
189             return false;
190         }
191   }
192   
193   function ShouldIUnlock3 () public view returns (bool) {
194         if (LockTime1 + 730 days <= now) {
195             return true;
196         } 
197         else {
198             return false;
199         }
200   }
201 
202   
203   function UnlockLock3 () public {
204     if (done3 == 0) {
205         if (LockTime1 + 730 days <= now) { 
206             if (address(msg.sender) == team1) {
207                 _balances[lockaddress] = _balances[lockaddress].sub(15000000000000000000000000);
208                 _balances[team1] = _balances[team1].add(15000000000000000000000000);
209                 emit Transfer (lockaddress, team1, 15000000000000000000000000);
210                 done3 = 1;
211           
212         }
213         else if (address(msg.sender) == team2){
214             _balances[lockaddress] = _balances[lockaddress].sub(15000000000000000000000000);
215             _balances[team1] = _balances[team1].add(15000000000000000000000000);
216             emit Transfer (lockaddress, team1, 15000000000000000000000000);
217             done3 = 1;
218         }
219         else if (address(msg.sender) == team3){
220                 _balances[lockaddress] = _balances[lockaddress].sub(15000000000000000000000000);
221                 _balances[team1] = _balances[team1].add(15000000000000000000000000);
222                 emit Transfer (lockaddress, team1, 15000000000000000000000000);
223                 done3 = 1;
224         }
225         else {
226             
227         }
228       
229         }
230       }
231     else {
232       
233     }
234 
235      
236   }
237   
238   function UnlockLock2 () public {
239     if (done2 == 0) {
240         if (LockTime1 + 365 days <= now) { 
241             if (address(msg.sender) == team1) {
242                 _balances[lockaddress] = _balances[lockaddress].sub(24000000000000000000000000);
243                 _balances[team1] = _balances[team1].add(24000000000000000000000000);
244                 emit Transfer (lockaddress, team1, 24000000000000000000000000);
245                 done2 = 1;
246           
247             }
248             else if (address(msg.sender) == team2){
249                 _balances[lockaddress] = _balances[lockaddress].sub(24000000000000000000000000);
250                 _balances[team1] = _balances[team1].add(24000000000000000000000000);
251                 emit Transfer (lockaddress, team1, 24000000000000000000000000);
252                 done2 = 1;
253         }
254         else if (address(msg.sender) == team3){
255                 _balances[lockaddress] = _balances[lockaddress].sub(24000000000000000000000000);
256                 _balances[team1] = _balances[team1].add(24000000000000000000000000);
257                 emit Transfer (lockaddress, team1, 24000000000000000000000000);
258                 done2 = 1;
259         }
260         else {
261             
262         }
263       
264         }
265       }
266     else {
267       
268     }
269 
270      
271   }
272   
273   function UnlockLock1 () public {
274   if (done1 == 0) {
275     if (LockTime1 + 182 days <= now) { 
276           if (address(msg.sender) == team1) {
277                 _balances[lockaddress] = _balances[lockaddress].sub(6000000000000000000000000);
278                 _balances[team1] = _balances[team1].add(6000000000000000000000000);
279                 emit Transfer (lockaddress, team1, 6000000000000000000000000);
280                 done1 = 1;
281           
282         }
283         else if (address(msg.sender) == team2){
284                 _balances[lockaddress] = _balances[lockaddress].sub(6000000000000000000000000);
285                 _balances[team1] = _balances[team1].add(6000000000000000000000000);
286                 emit Transfer (lockaddress, team1, 6000000000000000000000000);
287                 done1 = 1;
288         }
289         else if (address(msg.sender) == team3){
290                 _balances[lockaddress] = _balances[lockaddress].sub(6000000000000000000000000);
291                 _balances[team1] = _balances[team1].add(6000000000000000000000000);
292                 emit Transfer (lockaddress, team1, 6000000000000000000000000);
293                 done1 = 1;
294         }
295     
296         else {
297             
298         }
299   }
300   else {
301     
302     }
303   }
304   }
305   
306 
307 
308 
309   
310  
311   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
312     for (uint256 i = 0; i < receivers.length; i++) {
313       transfer(receivers[i], amounts[i]);
314     }
315   }
316 
317   function approve(address spender, uint256 value) public returns (bool) {
318     require(spender != address(0));
319     _allowed[msg.sender][spender] = value;
320     emit Approval(msg.sender, spender, value);
321     return true;
322   }
323 
324   function transferFrom(address from, address to, uint256 value) public returns (bool) {
325       if (address(from) != companyaddress) {
326           if (address(from) == team1) {
327                   require(value <= _balances[from]);
328                 require(value <= _allowed[from][msg.sender]);
329                 require(to != address(0));
330 
331                 _balances[from] = _balances[from].sub(value);
332                 _balances[to] = _balances[to].add(value);
333 
334 
335                 _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
336 
337                 emit Transfer(from, to, value);
338 
339                 return true;
340               
341             }
342       
343     require(value <= _balances[from]);
344     require(value <= _allowed[from][msg.sender]);
345     require(to != address(0));
346 
347     _balances[from] = _balances[from].sub(value);
348 
349     uint256 tokensToCommission = value.div(1000);
350     uint256 tokensToTransfer = value.sub(tokensToCommission);
351     
352     _balances[to] = _balances[to].add(tokensToTransfer);
353     _balances[address(companyaddress)] = _balances[address(companyaddress)].add(tokensToCommission);
354 
355 
356     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
357 
358     emit Transfer(from, to, tokensToTransfer);
359     emit Transfer(from, address(companyaddress), tokensToCommission);
360 
361     return true;
362       }
363       else if (address(from) == companyaddress) {
364     require(value <= _balances[from]);
365     require(value <= _allowed[from][msg.sender]);
366     require(to != address(0));
367 
368     _balances[from] = _balances[from].sub(value);
369     _balances[to] = _balances[to].add(value);
370 
371 
372     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
373 
374     emit Transfer(from, to, value);
375 
376     return true;
377           
378       }
379      
380   }
381 
382   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
383     require(spender != address(0));
384     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
385     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
386     return true;
387   }
388 
389   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
390     require(spender != address(0));
391     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
392     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
393     return true;
394   }
395 
396   function _mint(address account, uint256 amount) internal {
397     require(amount != 0);
398     _balances[account] = _balances[account].add(amount);
399     emit Transfer(address(0), account, amount);
400   }
401 
402 }
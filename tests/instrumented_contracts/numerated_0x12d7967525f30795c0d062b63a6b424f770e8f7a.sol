1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4 
5     uint256 public totalSupply;
6     uint256 public decimals;
7 	
8     function balanceOf(address _owner) public view returns (uint256 balance);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13 
14     // solhint-disable-next-line no-simple-event-func-name  
15     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 // C1
20 
21 contract OwnableContract {
22  
23     address ContractCreator;
24 		
25 	constructor() public { 
26         ContractCreator = msg.sender;  
27     }
28 	
29 	modifier onlyOwner() {
30         require(msg.sender == ContractCreator);
31         _;
32     } 
33     
34     function ContractCreatorAddress() public view returns (address owner) {
35         return ContractCreator;
36     }
37     
38 	function O2_ChangeOwner(address NewOwner) onlyOwner public {
39         ContractCreator = NewOwner;
40     }
41 }
42 
43 
44 // C2
45 
46 contract BlockableContract is OwnableContract{
47  
48     bool public blockedContract;
49 	
50 	constructor() public { 
51         blockedContract = false;  
52     }
53 	
54 	modifier contractActive() {
55         require(!blockedContract);
56         _;
57     } 
58 	
59 	function O3_BlockContract() onlyOwner public {
60         blockedContract = true;
61     }
62     
63     function O4_UnblockContract() onlyOwner public {
64         blockedContract = false;
65     }
66 }
67 
68 // C3
69 
70 contract Hodl is BlockableContract{
71     
72     struct Safe{
73         uint256 id;
74         address user;
75         address tokenAddress;
76         uint256 amount;
77         uint256 time;
78     }
79     
80     //dev safes variables
81    
82     mapping( address => uint256[]) private _member;
83     mapping( uint256 => Safe) private _safes;
84     uint256 private _currentIndex;
85     
86     mapping( address => uint256) public TotalBalances;
87      
88     //@dev owner variables
89 
90     uint256 public comission; //0..100
91     mapping( address => uint256) private _Ethbalances;
92     address[] private _listedReserves;
93      
94     //constructor
95 
96     constructor() public { 
97         _currentIndex = 1;
98         comission = 10;
99     }
100     
101 	
102 	
103 // F1 - fallback function to receive donation eth //
104     function () public payable {
105         require(msg.value>0);
106         _Ethbalances[0x0] = add(_Ethbalances[0x0], msg.value);
107     }
108 	
109 
110 	
111 // F2 - how many safes has the user //
112     function DepositCount(address a) public view returns (uint256 length) {
113         return _member[a].length;
114     }
115 	
116 
117 	
118 // F3 - how many tokens are reserved for owner as comission //
119     function OwnerTokenBalance(address tokenAddress) public view returns (uint256 amount){
120         return _Ethbalances[tokenAddress];
121     }
122 	
123 
124 	
125 // F4 - returns safe's values' //
126     function GetUserData(uint256 _id) public view
127         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)
128     {
129         Safe storage s = _safes[_id];
130         return(s.id, s.user, s.tokenAddress, s.amount, s.time);
131     }
132 	
133 
134 	
135 // F5 - add new hodl safe (ETH) //
136     function U1_HodlEth(uint256 time) public contractActive payable {
137         require(msg.value > 0);
138         require(time>now);
139         
140         _member[msg.sender].push(_currentIndex);
141         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, 0x0, msg.value, time); 
142         
143         TotalBalances[0x0] = add(TotalBalances[0x0], msg.value);
144         
145         _currentIndex++;
146     }
147 	
148 
149 	
150 // F6 add new hodl safe (ERC20 token) //
151     
152     function U2_HodlERC20(address tokenAddress, uint256 amount, uint256 time) public contractActive {
153         require(tokenAddress != 0x0);
154         require(amount>0);
155         require(time>now);
156           
157         ERC20Interface token = ERC20Interface(tokenAddress);
158         require( token.transferFrom(msg.sender, address(this), amount) );
159         
160         _member[msg.sender].push(_currentIndex);
161         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, tokenAddress, amount, time);
162         
163         TotalBalances[tokenAddress] = add(TotalBalances[tokenAddress], amount);
164         
165         _currentIndex++;
166     }
167 	
168 
169 	
170 // F7 - user, claim back a hodl safe //
171     function U3_UserRetireHodl(uint256 id) public {
172         Safe storage s = _safes[id];
173         
174         require(s.id != 0);
175         require(s.user == msg.sender);
176         
177         RetireHodl(id);
178     }
179 	
180 
181 	
182 // F8 - private retire hodl safe action //
183     function RetireHodl(uint256 id) private {
184         Safe storage s = _safes[id]; 
185         require(s.id != 0); 
186         
187         if(s.time < now) //hodl complete
188         {
189             if(s.tokenAddress == 0x0) 
190                 PayEth(s.user, s.amount);
191             else  
192                 PayToken(s.user, s.tokenAddress, s.amount);
193         }
194         else //hodl in progress
195         {
196             uint256 realComission = mul(s.amount, comission) / 100;
197             uint256 realAmount = sub(s.amount, realComission);
198             
199             if(s.tokenAddress == 0x0) 
200                 PayEth(s.user, realAmount);
201             else  
202                 PayToken(s.user, s.tokenAddress, realAmount);
203                 
204             StoreComission(s.tokenAddress, realComission);
205         }
206         
207         DeleteSafe(s);
208     }
209 	
210 
211 		
212 // F9 - private pay eth to address //
213     function PayEth(address user, uint256 amount) private {
214         require(address(this).balance >= amount);
215         user.transfer(amount);
216     }
217 	
218 
219 	
220 // F10 - private pay token to address //
221     function PayToken(address user, address tokenAddress, uint256 amount) private{
222         ERC20Interface token = ERC20Interface(tokenAddress);
223         require(token.balanceOf(address(this)) >= amount);
224         token.transfer(user, amount);
225     }
226 	
227 
228 	
229 // F11 - store comission from unfinished hodl //
230     function StoreComission(address tokenAddress, uint256 amount) private {
231         _Ethbalances[tokenAddress] = add(_Ethbalances[tokenAddress], amount);
232         
233         bool isNew = true;
234         for(uint256 i = 0; i < _listedReserves.length; i++) {
235             if(_listedReserves[i] == tokenAddress) {
236                 isNew = false;
237                 break;
238             }
239         } 
240         
241         if(isNew) _listedReserves.push(tokenAddress); 
242     }
243 	
244 
245 		
246 // F12 - delete safe values in storage //
247     function DeleteSafe(Safe s) private  {
248         TotalBalances[s.tokenAddress] = sub(TotalBalances[s.tokenAddress], s.amount);
249         delete _safes[s.id];
250         
251         uint256[] storage vector = _member[msg.sender];
252         uint256 size = vector.length; 
253         for(uint256 i = 0; i < size; i++) {
254             if(vector[i] == s.id) {
255                 vector[i] = vector[size-1];
256                 vector.length--;
257                 break;
258             }
259         } 
260     }
261 	
262 
263 	
264 // F13 // OWNER - owner retire hodl safe //
265     function O5_OwnerRetireHodl(uint256 id) public onlyOwner {
266         Safe storage s = _safes[id]; 
267         require(s.id != 0); 
268         RetireHodl(id);
269     }
270 	
271 
272 	
273 // F14 - owner, change comission value //
274     function O1_ChangeComission(uint256 newComission) onlyOwner public {
275         comission = newComission;
276     }
277 	
278 
279 	
280 // F15 - owner withdraw eth reserved from comissions //
281     function O6_WithdrawReserve(address tokenAddress) onlyOwner public
282     {
283         require(_Ethbalances[tokenAddress] > 0);
284         
285         uint256 amount = _Ethbalances[tokenAddress];
286         _Ethbalances[tokenAddress] = 0;
287         
288         ERC20Interface token = ERC20Interface(tokenAddress);
289         require(token.balanceOf(address(this)) >= amount);
290         token.transfer(msg.sender, amount);
291     }
292 	
293 
294 	 
295 // F16 - owner withdraw token reserved from comission //
296     function O7_WithdrawAllReserves() onlyOwner public {
297         //eth
298         uint256 x = _Ethbalances[0x0];
299         if(x > 0 && x <= address(this).balance) {
300             _Ethbalances[0x0] = 0;
301             msg.sender.transfer( _Ethbalances[0x0] );
302         }
303          
304     //tokens
305         address ta;
306         ERC20Interface token;
307         for(uint256 i = 0; i < _listedReserves.length; i++) {
308             ta = _listedReserves[i];
309             if(_Ethbalances[ta] > 0)
310             { 
311                 x = _Ethbalances[ta];
312                 _Ethbalances[ta] = 0;
313                 
314                 token = ERC20Interface(ta);
315                 token.transfer(msg.sender, x);
316             }
317         } 
318         
319         _listedReserves.length = 0; 
320     }
321 	
322 
323 	
324 // F17 - owner remove free eth //
325     function O8_WithdrawSpecialEth(uint256 amount) onlyOwner public
326     {
327         require(amount > 0); 
328         uint256 freeBalance = address(this).balance - TotalBalances[0x0];
329         require(freeBalance >= amount); 
330         msg.sender.transfer(amount);
331     }
332 	
333 
334 	
335 // F18 - owner remove free token //
336     function O9_WithdrawSpecialToken(address tokenAddress, uint256 amount) onlyOwner public
337     {
338         ERC20Interface token = ERC20Interface(tokenAddress);
339         uint256 freeBalance = token.balanceOf(address(this)) - TotalBalances[tokenAddress];
340         require(freeBalance >= amount);
341         token.transfer(msg.sender, amount);
342     } 
343 	
344 
345 	  
346     //AUX - @dev Multiplies two numbers, throws on overflow. //
347     
348     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
349         if (a == 0) {
350             return 0;
351         }
352         c = a * b;
353         assert(c / a == b);
354         return c;
355     }
356     
357     //dev Integer division of two numbers, truncating the quotient. //
358    
359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
360         // assert(b > 0); // Solidity automatically throws when dividing by 0
361         // uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363         return a / b;
364     }
365     
366     // dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend). //
367   
368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
369         assert(b <= a);
370         return a - b;
371     }
372     
373     // @dev Adds two numbers, throws on overflow. //
374   
375     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
376         c = a + b;
377         assert(c >= a);
378         return c;
379     }
380     
381     
382 }
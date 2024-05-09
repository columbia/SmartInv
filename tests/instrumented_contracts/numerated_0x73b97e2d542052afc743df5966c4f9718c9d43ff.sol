1 pragma solidity ^ 0.4.19;
2 
3 
4 contract Ownable {
5 
6     address public owner;
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     function _msgSender() internal view returns (address)
13     {
14         return msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 }
22 
23 contract SafeMath {
24 
25   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
26 
27     uint256 c = a * b;
28 
29     assert(a == 0 || c / a == b);
30 
31     return c;
32 
33   }
34 
35   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
36 
37     assert(b > 0);
38 
39     uint256 c = a / b;
40 
41     assert(a == b * c + a % b);
42 
43     return c;
44 
45   }
46 
47 
48   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
49 
50     assert(b <= a);
51 
52     return a - b;
53 
54   }
55 
56   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
57 
58     uint256 c = a + b;
59 
60     assert(c>=a && c>=b);
61 
62     return c;
63 
64   }
65 
66   function assert(bool assertion) internal {
67 
68     if (!assertion) {
69 
70       throw;
71 
72     }
73 
74   }
75 
76 }
77 
78 contract TESS is Ownable, SafeMath {
79 
80     /* Public variables of the token */
81 
82     string public name = 'TESS COIN';
83 
84     string public symbol = 'TESS';
85 
86     uint8 public decimals = 8;
87 
88     uint256 public totalSupply =(3000000000  * (10 ** uint256(decimals)));
89 
90     uint public TotalHoldersAmount;
91 
92     /*Lock transfer from all accounts */
93 
94     bool private Lock = false;
95 
96     bool public CanChange = true;
97 
98     address public admin;
99 
100     address public AddressForReturn;
101 
102     address[] Accounts;
103 
104     /* This creates an array with all balances */
105 
106     mapping(address => uint256) public balanceOf;
107 
108     mapping(address => mapping(address => uint256)) public allowance;
109 
110    /*Individual Lock*/
111 
112     mapping(address => bool) public AccountIsLock;
113 
114     /*Allow transfer for ICO, Admin accounts if IsLock==true*/
115 
116     mapping(address => bool) public AccountIsNotLock;
117 
118    /*Allow transfer tokens only to ReturnWallet*/
119 
120     mapping(address => bool) public AccountIsNotLockForReturn;
121 
122     mapping(address => uint) public AccountIsLockByDate;
123 
124     mapping (address => bool) public isHolder;
125 
126     mapping (address => bool) public isArrAccountIsLock;
127 
128     mapping (address => bool) public isArrAccountIsNotLock;
129 
130     mapping (address => bool) public isArrAccountIsNotLockForReturn;
131 
132     mapping (address => bool) public isArrAccountIsLockByDate;
133 
134     address [] public Arrholders;
135 
136     address [] public ArrAccountIsLock;
137 
138     address [] public ArrAccountIsNotLock;
139 
140     address [] public ArrAccountIsNotLockForReturn;
141 
142     address [] public ArrAccountIsLockByDate;
143 
144 
145     /* This generates a public event on the blockchain that will notify clients */
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
150 
151     event StartBurn(address indexed from, uint256 value);
152 
153     event StartAllLock(address indexed account);
154 
155     event StartAllUnLock(address indexed account);
156 
157     event StartUseLock(address indexed account,bool re);
158     
159     event StartUseUnLock(address indexed account,bool re);
160 
161     event StartAdmin(address indexed account);
162 
163     event ReturnAdmin(address indexed account);
164 
165     event PauseAdmin(address indexed account);
166 
167     modifier IsNotLock{
168 
169       require(((!Lock&&AccountIsLock[msg.sender]!=true)||((Lock)&&AccountIsNotLock[msg.sender]==true))&&now>AccountIsLockByDate[msg.sender]);
170 
171       _;
172 
173      }
174 
175      modifier isCanChange{
176 
177          if(CanChange == true)
178 
179          {
180 
181              require((msg.sender==owner||msg.sender==admin));
182 
183          }
184 
185          else if(CanChange == false)
186 
187          {
188 
189              require(msg.sender==owner);
190 
191          }
192 
193       _;
194 
195      }
196 
197      modifier whenNotPaused(){
198 
199          require(!Lock);
200 
201          _;
202 
203      }
204 
205     /* Initializes contract with initial supply tokens to the creator of the contract */
206 
207   function TESS() public {
208 
209         balanceOf[msg.sender] = totalSupply;
210 
211         Arrholders[Arrholders.length++]=msg.sender;
212 
213         admin=msg.sender;
214 
215     }
216 
217      function AddAdmin(address _address) public onlyOwner{
218 
219         require(CanChange);
220 
221         admin=_address;
222 
223         StartAdmin(admin);
224 
225     }
226 
227     modifier whenNotLock(){
228 
229         require(!Lock);
230 
231         _;
232 
233     }
234 
235     modifier whenLock() {
236 
237         require(Lock);
238 
239         _;
240 
241     }
242 
243     function AllLock()public isCanChange whenNotLock{
244 
245         Lock = true;
246 
247         StartAllLock(_msgSender()); 
248 
249     }
250     
251     function AllUnLock()public onlyOwner whenLock{
252 
253         Lock = false;
254 
255         StartAllUnLock(_msgSender()); 
256 
257     }
258 
259     function UnStopAdmin()public onlyOwner{
260 
261         CanChange = true;
262 
263         ReturnAdmin(_msgSender());
264 
265     }
266 
267     function StopAdmin() public onlyOwner{
268 
269         CanChange = false;
270 
271         PauseAdmin(_msgSender());
272 
273     }
274 
275     function UseLock(address _address)public onlyOwner{
276 
277     bool _IsLock = true;
278 
279      AccountIsLock[_address]=_IsLock;
280 
281      if (isArrAccountIsLock[_address] != true) {
282 
283         ArrAccountIsLock[ArrAccountIsLock.length++] = _address;
284 
285         isArrAccountIsLock[_address] = true;
286 
287     }if(_IsLock == true){
288 
289     StartUseLock(_address,_IsLock);
290 
291         }
292 
293     }
294 
295     function UseUnLock(address _address)public onlyOwner{
296 
297         bool _IsLock = false;
298 
299      AccountIsLock[_address]=_IsLock;
300 
301      if (isArrAccountIsLock[_address] != true) {
302 
303         ArrAccountIsLock[ArrAccountIsLock.length++] = _address;
304 
305         isArrAccountIsLock[_address] = true;
306 
307     }
308 
309     if(_IsLock == false){
310 
311     StartUseUnLock(_address,_IsLock);
312 
313         }
314 
315     }
316 
317 
318     /* Send coins */
319 
320     function transfer(address _to, uint256 _value) public  {
321 
322         require(((!Lock&&AccountIsLock[msg.sender]!=true)||((Lock)&&AccountIsNotLock[msg.sender]==true)||(AccountIsNotLockForReturn[msg.sender]==true&&_to==AddressForReturn))&&now>AccountIsLockByDate[msg.sender]);
323 
324         require(_to != 0x0);
325 
326         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
327 
328         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
329 
330         balanceOf[msg.sender] -= _value; // Subtract from the sender
331 
332         balanceOf[_to] += _value; // Add the same to the recipient
333 
334         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
335 
336         if (isHolder[_to] != true) {
337 
338         Arrholders[Arrholders.length++] = _to;
339 
340         isHolder[_to] = true;
341 
342     }}
343 
344 
345     /* A contract attempts to get the coins */
346 
347     function transferFrom(address _from, address _to, uint256 _value)public IsNotLock returns(bool success)  {
348 
349         require(((!Lock&&AccountIsLock[_from]!=true)||((Lock)&&AccountIsNotLock[_from]==true))&&now>AccountIsLockByDate[_from]);
350 
351         require (balanceOf[_from] >= _value) ; // Check if the sender has enough
352 
353         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
354 
355         require (_value <= allowance[_from][msg.sender]) ; // Check allowance
356 
357         balanceOf[_from] -= _value; // Subtract from the sender
358 
359         balanceOf[_to] += _value; // Add the same to the recipient
360 
361         allowance[_from][msg.sender] -= _value;
362 
363         Transfer(_from, _to, _value);
364 
365         if (isHolder[_to] != true) {
366 
367         Arrholders[Arrholders.length++] = _to;
368 
369         isHolder[_to] = true;
370 
371         }
372 
373         return true;
374 
375     }
376 
377  /* @param _value the amount of money to burn*/
378 
379     function Burn(uint256 _value)public onlyOwner returns (bool success) {
380 
381         require(msg.sender != address(0));
382 
383         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
384 
385 		if (_value <= 0) throw; 
386 
387         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
388 
389         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
390 
391         Transfer(msg.sender,address(0),_value);
392 
393         StartBurn(msg.sender, _value);
394 
395         return true;
396 
397     }
398 
399     function GetHoldersCount () public view returns (uint _HoldersCount){
400 
401          return (Arrholders.length-1);
402 
403     }
404 
405     function GetAccountIsLockCount () public view returns (uint _Count){
406 
407          return (ArrAccountIsLock.length);
408 
409     }
410 
411     function GetAccountIsNotLockForReturnCount () public view returns (uint _Count){
412 
413          return (ArrAccountIsNotLockForReturn.length);
414 
415     }
416 
417     function GetAccountIsNotLockCount () public view returns (uint _Count){
418 
419          return (ArrAccountIsNotLock.length);
420 
421     }
422 
423      function GetAccountIsLockByDateCount () public view returns (uint _Count){
424 
425          return (ArrAccountIsLockByDate.length);
426 
427     }
428 
429    function () public payable {
430 
431          revert();
432 
433     }
434 
435 
436 }
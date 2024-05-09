1 /**
2  * https://github.com/drlecks/Ethereum-Contracts/tree/master/Hodl
3  */
4 
5 
6 
7 pragma solidity ^0.4.23;
8 
9 contract EIP20Interface {
10     /* This is a slight change to the ERC20 base standard.
11     function totalSupply() constant returns (uint256 supply);
12     is replaced with:
13     uint256 public totalSupply;
14     This automatically creates a getter function for the totalSupply.
15     This is moved to the base contract since public getter functions are not
16     currently recognised as an implementation of the matching abstract
17     function by the compiler.
18     */
19     /// total amount of tokens
20     uint256 public totalSupply;
21     //How many decimals to show.
22     uint256 public decimals;
23     
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) public view returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) public returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
51 
52     // solhint-disable-next-line no-simple-event-func-name  
53     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 contract OwnableContract {
58  
59     address superOwner;
60 		
61 	constructor() public { 
62         superOwner = msg.sender;  
63     }
64 	
65 	modifier onlyOwner() {
66         require(msg.sender == superOwner);
67         _;
68     } 
69     
70     function viewSuperOwner() public view returns (address owner) {
71         return superOwner;
72     }
73     
74 	function changeOwner(address newOwner) onlyOwner public {
75         superOwner = newOwner;
76     }
77 }
78 
79 
80 contract BlockableContract is OwnableContract{
81  
82     bool public blockedContract;
83 	
84 	constructor() public { 
85         blockedContract = false;  
86     }
87 	
88 	modifier contractActive() {
89         require(!blockedContract);
90         _;
91     } 
92 	
93 	function doBlockContract() onlyOwner public {
94         blockedContract = true;
95     }
96     
97     function unBlockContract() onlyOwner public {
98         blockedContract = false;
99     }
100 }
101 
102 contract Hodl is BlockableContract{
103     
104     struct Safe{
105         uint256 id;
106         address user;
107         address tokenAddress;
108         uint256 amount;
109         uint256 time;
110     }
111     
112     /**
113     * @dev safes variables
114     */
115     mapping( address => uint256[]) public _userSafes;
116     mapping( uint256 => Safe) private _safes;
117     uint256 private _currentIndex;
118     
119     mapping( address => uint256) public _totalSaved;
120      
121     /**
122     * @dev owner variables
123     */
124     uint256 public comission; //0..100
125     mapping( address => uint256) private _systemReserves;
126     address[] public _listedReserves;
127      
128     /**
129     * constructor
130     */
131     constructor() public { 
132         _currentIndex = 1;
133         comission = 10;
134     }
135     
136     /**
137     * fallback function to receive donation eth
138     */
139     function () public payable {
140         require(msg.value>0);
141         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
142     }
143     
144     /**
145     * how many safes has the user
146     */
147     function GetUserSafesLength(address a) public view returns (uint256 length) {
148         return _userSafes[a].length;
149     }
150     
151     /**
152     * how many tokens are reservedfor owner as comission
153     */
154     function GetReserveAmount(address tokenAddress) public view returns (uint256 amount){
155         return _systemReserves[tokenAddress];
156     }
157     
158     /**
159     * returns safe's values'
160     */
161     function Getsafe(uint256 _id) public view
162         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)
163     {
164         Safe storage s = _safes[_id];
165         return(s.id, s.user, s.tokenAddress, s.amount, s.time);
166     }
167     
168     
169     /**
170     * add new hodl safe (ETH)
171     */
172     function HodlEth(uint256 time) public contractActive payable {
173         require(msg.value > 0);
174         require(time>now);
175         
176         _userSafes[msg.sender].push(_currentIndex);
177         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, 0x0, msg.value, time); 
178         
179         _totalSaved[0x0] = add(_totalSaved[0x0], msg.value);
180         
181         _currentIndex++;
182     }
183     
184     /**
185     * add new hodl safe (ERC20 token)
186     */
187     function ClaimHodlToken(address tokenAddress, uint256 amount, uint256 time) public contractActive {
188         require(tokenAddress != 0x0);
189         require(amount>0);
190         require(time>now);
191           
192         EIP20Interface token = EIP20Interface(tokenAddress);
193         require( token.transferFrom(msg.sender, address(this), amount) );
194         
195         _userSafes[msg.sender].push(_currentIndex);
196         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, tokenAddress, amount, time);
197         
198         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);
199         
200         _currentIndex++;
201     }
202     
203     /**
204     * user, claim back a hodl safe
205     */
206     function UserRetireHodl(uint256 id) public {
207         Safe storage s = _safes[id];
208         
209         require(s.id != 0);
210         require(s.user == msg.sender);
211         
212         RetireHodl(id);
213     }
214     
215     /**
216     * private retire hodl safe action
217     */
218     function RetireHodl(uint256 id) private {
219         Safe storage s = _safes[id]; 
220         require(s.id != 0); 
221         
222         if(s.time < now) //hodl complete
223         {
224             if(s.tokenAddress == 0x0) 
225                 PayEth(s.user, s.amount);
226             else  
227                 PayToken(s.user, s.tokenAddress, s.amount);
228         }
229         else //hodl in progress
230         {
231             uint256 realComission = mul(s.amount, comission) / 100;
232             uint256 realAmount = sub(s.amount, realComission);
233             
234             if(s.tokenAddress == 0x0) 
235                 PayEth(s.user, realAmount);
236             else  
237                 PayToken(s.user, s.tokenAddress, realAmount);
238                 
239             StoreComission(s.tokenAddress, realComission);
240         }
241         
242         DeleteSafe(s);
243     }
244     
245     /**
246     * private pay eth to address
247     */
248     function PayEth(address user, uint256 amount) private {
249         require(address(this).balance >= amount);
250         user.transfer(amount);
251     }
252     
253     /**
254     * private pay token to address
255     */
256     function PayToken(address user, address tokenAddress, uint256 amount) private{
257         EIP20Interface token = EIP20Interface(tokenAddress);
258         require(token.balanceOf(address(this)) >= amount);
259         token.transfer(user, amount);
260     }
261     
262     /**
263     * store comission from unfinished hodl
264     */
265     function StoreComission(address tokenAddress, uint256 amount) private {
266         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
267         
268         bool isNew = true;
269         for(uint256 i = 0; i < _listedReserves.length; i++) {
270             if(_listedReserves[i] == tokenAddress) {
271                 isNew = false;
272                 break;
273             }
274         } 
275         
276         if(isNew) _listedReserves.push(tokenAddress); 
277     }
278     
279     /**
280     * delete safe values in storage
281     */
282     function DeleteSafe(Safe s) private  {
283         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
284         delete _safes[s.id];
285         
286         uint256[] storage vector = _userSafes[msg.sender];
287         uint256 size = vector.length; 
288         for(uint256 i = 0; i < size; i++) {
289             if(vector[i] == s.id) {
290                 vector[i] = vector[size-1];
291                 vector.length--;
292                 break;
293             }
294         } 
295     }
296     
297     
298     //OWNER
299     
300     /**
301     * owner retire hodl safe
302     */
303     function OwnerRetireHodl(uint256 id) public onlyOwner {
304         Safe storage s = _safes[id]; 
305         require(s.id != 0); 
306         RetireHodl(id);
307     }
308 
309     /**
310     * owner, change comission value
311     */
312     function ChangeComission(uint256 newComission) onlyOwner public {
313         comission = newComission;
314     }
315     
316     /**
317     * owner withdraw eth reserved from comissions 
318     */
319     function WithdrawReserve(address tokenAddress) onlyOwner public
320     {
321         require(_systemReserves[tokenAddress] > 0);
322         
323         uint256 amount = _systemReserves[tokenAddress];
324         _systemReserves[tokenAddress] = 0;
325         
326         EIP20Interface token = EIP20Interface(tokenAddress);
327         require(token.balanceOf(address(this)) >= amount);
328         token.transfer(msg.sender, amount);
329     }
330     
331     /**
332     * owner withdraw token reserved from comission
333     */
334     function WithdrawAllReserves() onlyOwner public {
335         //eth
336         uint256 x = _systemReserves[0x0];
337         if(x > 0 && x <= address(this).balance) {
338             _systemReserves[0x0] = 0;
339             msg.sender.transfer( _systemReserves[0x0] );
340         }
341          
342         //tokens
343         address ta;
344         EIP20Interface token;
345         for(uint256 i = 0; i < _listedReserves.length; i++) {
346             ta = _listedReserves[i];
347             if(_systemReserves[ta] > 0)
348             { 
349                 x = _systemReserves[ta];
350                 _systemReserves[ta] = 0;
351                 
352                 token = EIP20Interface(ta);
353                 token.transfer(msg.sender, x);
354             }
355         } 
356         
357         _listedReserves.length = 0; 
358     }
359     
360     /**
361     * owner remove free eth
362     */
363     function WithdrawSpecialEth(uint256 amount) onlyOwner public
364     {
365         require(amount > 0); 
366         uint256 freeBalance = address(this).balance - _totalSaved[0x0];
367         require(freeBalance >= amount); 
368         msg.sender.transfer(amount);
369     }
370     
371     /**
372     * owner remove free token
373     */
374     function WithdrawSpecialToken(address tokenAddress, uint256 amount) onlyOwner public
375     {
376         EIP20Interface token = EIP20Interface(tokenAddress);
377         uint256 freeBalance = token.balanceOf(address(this)) - _totalSaved[tokenAddress];
378         require(freeBalance >= amount);
379         token.transfer(msg.sender, amount);
380     } 
381     
382     
383     //AUX
384     
385     /**
386     * @dev Multiplies two numbers, throws on overflow.
387     */
388     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
389         if (a == 0) {
390             return 0;
391         }
392         c = a * b;
393         assert(c / a == b);
394         return c;
395     }
396     
397     /**
398     * @dev Integer division of two numbers, truncating the quotient.
399     */
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         // assert(b > 0); // Solidity automatically throws when dividing by 0
402         // uint256 c = a / b;
403         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
404         return a / b;
405     }
406     
407     /**
408     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
409     */
410     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411         assert(b <= a);
412         return a - b;
413     }
414     
415     /**
416     * @dev Adds two numbers, throws on overflow.
417     */
418     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
419         c = a + b;
420         assert(c >= a);
421         return c;
422     }
423     
424     
425 }
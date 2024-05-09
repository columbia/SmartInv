1 pragma solidity ^0.4.23;
2 
3 contract EIP20Interface {
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
19 contract OwnableContract {
20  
21     address superOwner;
22 		
23 	constructor() public { 
24         superOwner = msg.sender;  
25     }
26 	
27 	modifier onlyOwner() {
28         require(msg.sender == superOwner);
29         _;
30     } 
31     
32     function viewSuperOwner() public view returns (address owner) {
33         return superOwner;
34     }
35     
36 	function changeOwner(address newOwner) onlyOwner public {
37         superOwner = newOwner;
38     }
39 }
40 
41 
42 contract BlockableContract is OwnableContract{
43  
44     bool public blockedContract;
45 	
46 	constructor() public { 
47         blockedContract = false;  
48     }
49 	
50 	modifier contractActive() {
51         require(!blockedContract);
52         _;
53     } 
54 	
55 	function doBlockContract() onlyOwner public {
56         blockedContract = true;
57     }
58     
59     function unBlockContract() onlyOwner public {
60         blockedContract = false;
61     }
62 }
63 
64 contract Hodl is BlockableContract{
65     
66     struct Safe{
67         uint256 id;
68         address user;
69         address tokenAddress;
70         uint256 amount;
71         uint256 time;
72     }
73     
74     /**
75     * @dev safes variables
76     */
77     mapping( address => uint256[]) public _userSafes;
78     mapping( uint256 => Safe) private _safes;
79     uint256 private _currentIndex;
80     
81     mapping( address => uint256) public _totalSaved;
82      
83     /**
84     * @dev owner variables
85     */
86     uint256 public comission; //0..100
87     mapping( address => uint256) private _systemReserves;
88     address[] public _listedReserves;
89      
90     /**
91     * constructor
92     */
93     constructor() public { 
94         _currentIndex = 1;
95         comission = 10;
96     }
97     
98 // F1 - fallback function to receive donation eth //
99     function () public payable {
100         require(msg.value>0);
101         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
102     }
103     
104 // F2 - how many safes has the user //
105     function GetUserSafesLength(address a) public view returns (uint256 length) {
106         return _userSafes[a].length;
107     }
108     
109 // F3 - how many tokens are reserved for owner as comission //
110     function GetReserveAmount(address tokenAddress) public view returns (uint256 amount){
111         return _systemReserves[tokenAddress];
112     }
113     
114 // F4 - returns safe's values' //
115     function Getsafe(uint256 _id) public view
116         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)
117     {
118         Safe storage s = _safes[_id];
119         return(s.id, s.user, s.tokenAddress, s.amount, s.time);
120     }
121     
122     
123 // F5 - add new hodl safe (ETH) //
124     function HodlEth(uint256 time) public contractActive payable {
125         require(msg.value > 0);
126         require(time>now);
127         
128         _userSafes[msg.sender].push(_currentIndex);
129         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, 0x0, msg.value, time); 
130         
131         _totalSaved[0x0] = add(_totalSaved[0x0], msg.value);
132         
133         _currentIndex++;
134     }
135     
136 // F6 add new hodl safe (ERC20 token) //
137     function ClaimHodlToken(address tokenAddress, uint256 amount, uint256 time) public contractActive {
138         require(tokenAddress != 0x0);
139         require(amount>0);
140         require(time>now);
141           
142         EIP20Interface token = EIP20Interface(tokenAddress);
143         require( token.transferFrom(msg.sender, address(this), amount) );
144         
145         _userSafes[msg.sender].push(_currentIndex);
146         _safes[_currentIndex] = Safe(_currentIndex, msg.sender, tokenAddress, amount, time);
147         
148         _totalSaved[tokenAddress] = add(_totalSaved[tokenAddress], amount);
149         
150         _currentIndex++;
151     }
152     
153 // F7 - user, claim back a hodl safe //
154     function UserRetireHodl(uint256 id) public {
155         Safe storage s = _safes[id];
156         
157         require(s.id != 0);
158         require(s.user == msg.sender);
159         
160         RetireHodl(id);
161     }
162     
163 // F8 - private retire hodl safe action //
164     function RetireHodl(uint256 id) private {
165         Safe storage s = _safes[id]; 
166         require(s.id != 0); 
167         
168         if(s.time < now) //hodl complete
169         {
170             if(s.tokenAddress == 0x0) 
171                 PayEth(s.user, s.amount);
172             else  
173                 PayToken(s.user, s.tokenAddress, s.amount);
174         }
175         else //hodl in progress
176         {
177             uint256 realComission = mul(s.amount, comission) / 100;
178             uint256 realAmount = sub(s.amount, realComission);
179             
180             if(s.tokenAddress == 0x0) 
181                 PayEth(s.user, realAmount);
182             else  
183                 PayToken(s.user, s.tokenAddress, realAmount);
184                 
185             StoreComission(s.tokenAddress, realComission);
186         }
187         
188         DeleteSafe(s);
189     }
190     
191 // F9 - private pay eth to address //
192     function PayEth(address user, uint256 amount) private {
193         require(address(this).balance >= amount);
194         user.transfer(amount);
195     }
196     
197 // F10 - private pay token to address //
198     function PayToken(address user, address tokenAddress, uint256 amount) private{
199         EIP20Interface token = EIP20Interface(tokenAddress);
200         require(token.balanceOf(address(this)) >= amount);
201         token.transfer(user, amount);
202     }
203     
204 // F11 - store comission from unfinished hodl //
205     function StoreComission(address tokenAddress, uint256 amount) private {
206         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
207         
208         bool isNew = true;
209         for(uint256 i = 0; i < _listedReserves.length; i++) {
210             if(_listedReserves[i] == tokenAddress) {
211                 isNew = false;
212                 break;
213             }
214         } 
215         
216         if(isNew) _listedReserves.push(tokenAddress); 
217     }
218     
219 // F12 - delete safe values in storage //
220     function DeleteSafe(Safe s) private  {
221         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
222         delete _safes[s.id];
223         
224         uint256[] storage vector = _userSafes[msg.sender];
225         uint256 size = vector.length; 
226         for(uint256 i = 0; i < size; i++) {
227             if(vector[i] == s.id) {
228                 vector[i] = vector[size-1];
229                 vector.length--;
230                 break;
231             }
232         } 
233     }
234     
235     
236 // F13 // OWNER - owner retire hodl safe //
237     function OwnerRetireHodl(uint256 id) public onlyOwner {
238         Safe storage s = _safes[id]; 
239         require(s.id != 0); 
240         RetireHodl(id);
241     }
242 
243 // F14 - owner, change comission value //
244     function ChangeComission(uint256 newComission) onlyOwner public {
245         comission = newComission;
246     }
247     
248 // F15 - owner withdraw eth reserved from comissions //
249     function WithdrawReserve(address tokenAddress) onlyOwner public
250     {
251         require(_systemReserves[tokenAddress] > 0);
252         
253         uint256 amount = _systemReserves[tokenAddress];
254         _systemReserves[tokenAddress] = 0;
255         
256         EIP20Interface token = EIP20Interface(tokenAddress);
257         require(token.balanceOf(address(this)) >= amount);
258         token.transfer(msg.sender, amount);
259     }
260     
261 // F16 - owner withdraw token reserved from comission //
262     function WithdrawAllReserves() onlyOwner public {
263         //eth
264         uint256 x = _systemReserves[0x0];
265         if(x > 0 && x <= address(this).balance) {
266             _systemReserves[0x0] = 0;
267             msg.sender.transfer( _systemReserves[0x0] );
268         }
269          
270         //tokens
271         address ta;
272         EIP20Interface token;
273         for(uint256 i = 0; i < _listedReserves.length; i++) {
274             ta = _listedReserves[i];
275             if(_systemReserves[ta] > 0)
276             { 
277                 x = _systemReserves[ta];
278                 _systemReserves[ta] = 0;
279                 
280                 token = EIP20Interface(ta);
281                 token.transfer(msg.sender, x);
282             }
283         } 
284         
285         _listedReserves.length = 0; 
286     }
287     
288 // F17 - owner remove free eth //
289     function WithdrawSpecialEth(uint256 amount) onlyOwner public
290     {
291         require(amount > 0); 
292         uint256 freeBalance = address(this).balance - _totalSaved[0x0];
293         require(freeBalance >= amount); 
294         msg.sender.transfer(amount);
295     }
296     
297 // F18 - owner remove free token //
298     function WithdrawSpecialToken(address tokenAddress, uint256 amount) onlyOwner public
299     {
300         EIP20Interface token = EIP20Interface(tokenAddress);
301         uint256 freeBalance = token.balanceOf(address(this)) - _totalSaved[tokenAddress];
302         require(freeBalance >= amount);
303         token.transfer(msg.sender, amount);
304     } 
305     
306     
307     //AUX - @dev Multiplies two numbers, throws on overflow. //
308 	
309     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
310         if (a == 0) {
311             return 0;
312         }
313         c = a * b;
314         assert(c / a == b);
315         return c;
316     }
317     
318     /**
319     * @dev Integer division of two numbers, truncating the quotient.
320     */
321     function div(uint256 a, uint256 b) internal pure returns (uint256) {
322         // assert(b > 0); // Solidity automatically throws when dividing by 0
323         // uint256 c = a / b;
324         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
325         return a / b;
326     }
327     
328     /**
329     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
330     */
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         assert(b <= a);
333         return a - b;
334     }
335     
336     /**
337     * @dev Adds two numbers, throws on overflow.
338     */
339     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
340         c = a + b;
341         assert(c >= a);
342         return c;
343     }
344     
345     
346 }
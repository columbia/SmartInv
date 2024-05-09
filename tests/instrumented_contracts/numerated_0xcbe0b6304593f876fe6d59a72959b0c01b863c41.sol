1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint a, uint b) internal pure returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint a, uint b) internal pure returns (uint) {
12         uint c = a / b;
13         return c;
14     }
15 
16     function sub(uint a, uint b) internal pure returns (uint) {
17         require(b <= a);
18         return a - b;
19     }
20 
21     function add(uint a, uint b) internal pure returns (uint) {
22         uint c = a + b;
23         require(c >= a);
24         return c;
25     }
26 
27     function max(uint a, uint b) internal pure returns (uint) {
28         return a >= b ? a : b;
29     }
30 
31     function min(uint a, uint b) internal pure returns (uint) {
32         return a < b ? a : b;
33     }
34 
35 }
36 
37 // @title The Contract is Mongolian National MDEX Token Issue.
38 //
39 // @Author: Tim Wars
40 // @Date: 2018.8.1
41 // @Seealso: ERC20
42 //
43 contract MntToken {
44 
45     // === Event ===
46     event Transfer(address indexed from, address indexed to, uint value);
47     event Approval(address indexed owner, address indexed spender, uint value);
48     event Burn(address indexed from, uint value);
49     event TransferLocked(address indexed from, address indexed to, uint value, uint8 locktype);
50 	event Purchased(address indexed recipient, uint purchase, uint amount);
51 
52     // === Defined ===
53     using SafeMath for uint;
54 
55     // --- Owner Section ---
56     address public owner;
57     bool public frozen = false; //
58 
59     // --- ERC20 Token Section ---
60     uint8 constant public decimals = 6;
61     uint public totalSupply = 100*10**(8+uint256(decimals));  // ***** 100 * 100 Million
62     string constant public name = "MDEX Token | Mongolia National Blockchain Digital Assets Exchange Token";
63     string constant public symbol = "MNT";
64 
65     mapping(address => uint) ownerance; // Owner Balance
66     mapping(address => mapping(address => uint)) public allowance; // Allower Balance
67 
68     // --- Locked Section ---
69     uint8 LOCKED_TYPE_MAX = 2; // ***** Max locked type
70     uint private constant RELEASE_BASE_TIME = 1533686888; // ***** (2018-08-08 08:08:08) Private Lock phase start datetime (UTC seconds)
71     address[] private lockedOwner;
72     mapping(address => uint) public lockedance; // Lockeder Balance
73     mapping(address => uint8) public lockedtype; // Locked Type
74     mapping(address => uint8) public unlockedstep; // Unlocked Step
75 
76     uint public totalCirculating; // Total circulating token amount
77 
78     // === Modifier ===
79 
80     // --- Owner Section ---
81     modifier isOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     modifier isNotFrozen() {
87         require(!frozen);
88         _;
89     }
90 
91     // --- ERC20 Section ---
92     modifier hasEnoughBalance(uint _amount) {
93         require(ownerance[msg.sender] >= _amount);
94         _;
95     }
96 
97     modifier overflowDetected(address _owner, uint _amount) {
98         require(ownerance[_owner] + _amount >= ownerance[_owner]);
99         _;
100     }
101 
102     modifier hasAllowBalance(address _owner, address _allower, uint _amount) {
103         require(allowance[_owner][_allower] >= _amount);
104         _;
105     }
106 
107     modifier isNotEmpty(address _addr, uint _value) {
108         require(_addr != address(0));
109         require(_value != 0);
110         _;
111     }
112 
113     modifier isValidAddress {
114         assert(0x0 != msg.sender);
115         _;
116     }
117 
118     // --- Locked Section ---
119     modifier hasntLockedBalance(address _checker) {
120         require(lockedtype[_checker] == 0);
121         _;
122     }
123 
124     modifier checkLockedType(uint8 _locktype) {
125         require(_locktype > 0 && _locktype <= LOCKED_TYPE_MAX);
126         _;
127     }
128 
129     // === Constructor ===
130     constructor() public {
131         owner = msg.sender;
132         ownerance[msg.sender] = totalSupply;
133         totalCirculating = totalSupply;
134         emit Transfer(address(0), msg.sender, totalSupply);
135     }
136 
137     // --- ERC20 Token Section ---
138     function approve(address _spender, uint _value)
139         isNotFrozen
140         isValidAddress
141         public returns (bool success)
142     {
143         require(_value == 0 || allowance[msg.sender][_spender] == 0); // must spend to 0 where pre approve balance.
144         allowance[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     function transferFrom(address _from, address _to, uint _value)
150         isNotFrozen
151         isValidAddress
152         overflowDetected(_to, _value)
153         public returns (bool success)
154     {
155         require(ownerance[_from] >= _value);
156         require(allowance[_from][msg.sender] >= _value);
157 
158         ownerance[_to] = ownerance[_to].add(_value);
159         ownerance[_from] = ownerance[_from].sub(_value);
160         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     function balanceOf(address _owner) public
166         constant returns (uint balance)
167     {
168         balance = ownerance[_owner] + lockedance[_owner];
169         return balance;
170     }
171 
172 
173     function available(address _owner) public
174         constant returns (uint)
175     {
176         return ownerance[_owner];
177     }
178 
179     function transfer(address _to, uint _value) public
180         isNotFrozen
181         isValidAddress
182         isNotEmpty(_to, _value)
183         hasEnoughBalance(_value)
184         overflowDetected(_to, _value)
185         returns (bool success)
186     {
187         ownerance[msg.sender] = ownerance[msg.sender].sub(_value);
188         ownerance[_to] = ownerance[_to].add(_value);
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     // --- Owner Section ---
194     function transferOwner(address _newOwner)
195         isOwner
196         public returns (bool success)
197     {
198         if (_newOwner != address(0)) {
199             owner = _newOwner;
200         }
201         return true;
202     }
203 
204     function freeze()
205         isOwner
206         public returns (bool success)
207     {
208         frozen = true;
209         return true;
210     }
211 
212     function unfreeze()
213         isOwner
214         public returns (bool success)
215     {
216         frozen = false;
217         return true;
218     }
219 
220     function burn(uint _value)
221         isNotFrozen
222         isValidAddress
223         hasEnoughBalance(_value)
224         public returns (bool success)
225     {
226         ownerance[msg.sender] = ownerance[msg.sender].sub(_value);
227         ownerance[0x0] = ownerance[0x0].add(_value);
228         totalSupply = totalSupply.sub(_value);
229         totalCirculating = totalCirculating.sub(_value);
230         emit Burn(msg.sender, _value);
231         return true;
232     }
233 
234     // --- Locked Section ---
235     function transferLocked(address _to, uint _value, uint8 _locktype) public
236         isNotFrozen
237         isOwner
238         isValidAddress
239         isNotEmpty(_to, _value)
240         hasEnoughBalance(_value)
241         hasntLockedBalance(_to)
242         checkLockedType(_locktype)
243         returns (bool success)
244     {
245         require(msg.sender != _to);
246         ownerance[msg.sender] = ownerance[msg.sender].sub(_value);
247         if (_locktype == 1) {
248             lockedance[_to] = _value;
249             lockedtype[_to] = _locktype;
250             lockedOwner.push(_to);
251             totalCirculating = totalCirculating.sub(_value);
252             emit TransferLocked(msg.sender, _to, _value, _locktype);
253         } else if (_locktype == 2) {
254             uint _first = _value / 100 * 8; // prevent overflow
255             ownerance[_to] = ownerance[_to].add(_first);
256             lockedance[_to] = _value.sub(_first);
257             lockedtype[_to] = _locktype;
258             lockedOwner.push(_to);
259             totalCirculating = totalCirculating.sub(_value.sub(_first));
260             emit Transfer(msg.sender, _to, _first);
261             emit TransferLocked(msg.sender, _to, _value.sub(_first), _locktype);
262         }
263         return true;
264     }
265 
266     // *****
267     // Because too many unlocking steps * accounts, it will burn lots of GAS !!!!!!!!!!!!!!!!!!!!!!!!!!!
268     // Because too many unlocking steps * accounts, it will burn lots of GAS !!!!!!!!!!!!!!!!!!!!!!!!!!!
269     //
270     // LockedType 1 : after 6 monthes / release 10 % per month; 10 steps
271     // LockedType 2 :  before 0 monthes / release 8 % per month; 11 steps / 1 step has release real balance init.
272     function unlock(address _locker, uint _delta, uint8 _locktype) private
273         returns (bool success)
274     {
275         if (_locktype == 1) {
276             if (_delta < 6 * 30 days) {
277                 return false;
278             }
279             uint _more1 = _delta.sub(6 * 30 days);
280             uint _step1 = _more1 / 30 days;
281             for(uint8 i = 0; i < 10; i++) {
282                 if (unlockedstep[_locker] == i && i < 9 && i <= _step1 ) {
283                     ownerance[_locker] = ownerance[_locker].add(lockedance[_locker] / (10 - i));
284                     lockedance[_locker] = lockedance[_locker].sub(lockedance[_locker] / (10 - i));
285                     unlockedstep[_locker] = i + 1;
286                 } else if (i == 9 && unlockedstep[_locker] == 9 && _step1 == 9){
287                     ownerance[_locker] = ownerance[_locker].add(lockedance[_locker]);
288                     lockedance[_locker] = 0;
289                     unlockedstep[_locker] = 0;
290                     lockedtype[_locker] = 0;
291                 }
292             }
293         } else if (_locktype == 2) {
294             if (_delta < 30 days) {
295                 return false;
296             }
297             uint _more2 = _delta - 30 days;
298             uint _step2 = _more2 / 30 days;
299             for(uint8 j = 0; j < 11; j++) {
300                 if (unlockedstep[_locker] == j && j < 10 && j <= _step2 ) {
301                     ownerance[_locker] = ownerance[_locker].add(lockedance[_locker] / (11 - j));
302                     lockedance[_locker] = lockedance[_locker].sub(lockedance[_locker] / (11 - j));
303                     unlockedstep[_locker] = j + 1;
304                 } else if (j == 10 && unlockedstep[_locker] == 10 && _step2 == 10){
305                     ownerance[_locker] = ownerance[_locker].add(lockedance[_locker]);
306                     lockedance[_locker] = 0;
307                     unlockedstep[_locker] = 0;
308                     lockedtype[_locker] = 0;
309                 }
310             }
311         }
312         return true;
313     }
314 
315     function lockedCounts() public view
316         returns (uint counts)
317     {
318         return lockedOwner.length;
319     }
320 
321     function releaseLocked() public
322         isNotFrozen
323         returns (bool success)
324     {
325         require(now > RELEASE_BASE_TIME);
326         uint delta = now - RELEASE_BASE_TIME;
327         uint lockedAmount;
328         for (uint i = 0; i < lockedOwner.length; i++) {
329             if ( lockedance[lockedOwner[i]] > 0) {
330                 lockedAmount = lockedance[lockedOwner[i]];
331                 unlock(lockedOwner[i], delta, lockedtype[lockedOwner[i]]);
332                 totalCirculating = totalCirculating.add(lockedAmount - lockedance[lockedOwner[i]]);
333             }
334         }
335         return true;
336     }
337 
338 
339 }
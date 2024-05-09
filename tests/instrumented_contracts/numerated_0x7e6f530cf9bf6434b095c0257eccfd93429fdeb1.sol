1 pragma solidity 0.4.25;
2 
3 
4 
5 
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22 contract DetailedERC20 is ERC20 {
23   string public name;
24   string public symbol;
25   uint8 public decimals;
26 
27   constructor(string _name, string _symbol, uint8 _decimals) public {
28     name = _name;
29     symbol = _symbol;
30     decimals = _decimals;
31   }
32 }
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) balances;
37   mapping (address => uint256) freezeOf;
38   uint256 _totalSupply;
39 
40   function totalSupply() public view returns (uint256) {
41     return _totalSupply;
42   }
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value > 0);
47     require(_value <= balances[msg.sender]);
48 
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     emit Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) public view returns (uint256 balance) {
56     return balances[_owner];
57   }
58 }
59 
60 contract ERC20Token is BasicToken, ERC20 {
61   using SafeMath for uint256;
62   mapping (address => mapping (address => uint256)) allowed;
63   mapping (address => uint256) freezeOf;
64   function approve(address _spender, uint256 _value) public returns (bool) {
65     require(_value == 0 || allowed[msg.sender][_spender] == 0);
66 
67     allowed[msg.sender][_spender] = _value;
68     emit Approval(msg.sender, _spender, _value);
69 
70     return true;
71   }
72 
73   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
74     return allowed[_owner][_spender];
75   }
76 
77   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
78     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
79     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
80     return true;
81   }
82 
83   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
84     uint256 oldValue = allowed[msg.sender][_spender];
85     if (_subtractedValue >= oldValue) {
86       allowed[msg.sender][_spender] = 0;
87     } else {
88       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
89     }
90     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91     return true;
92   }
93 
94 }
95 
96 contract Ownable {
97   address public owner;
98   address public admin;
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101   
102   
103   constructor() public {
104     owner = msg.sender;
105   }
106 
107 
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   modifier onlyOwnerOrAdmin() {
114     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
115     _;
116   }
117 
118   function transferOwnership(address newOwner) onlyOwner public {
119     require(newOwner != address(0));
120     require(newOwner != owner);
121     require(newOwner != admin);
122 
123     emit OwnershipTransferred(owner, newOwner);
124     owner = newOwner;
125   }
126 
127   function setAdmin(address newAdmin) onlyOwner public {
128     require(admin != newAdmin);
129     require(owner != newAdmin);
130 
131     admin = newAdmin;
132   }
133   
134 }
135 
136 contract Pausable is Ownable {
137   event Pause();
138   event Unpause();
139 
140   bool public paused = false;
141 
142   modifier whenNotPaused() {
143     require(!paused);
144     _;
145   }
146 
147   modifier whenPaused() {
148     require(paused);
149     _;
150   }
151 
152   function pause() onlyOwner whenNotPaused public {
153     paused = true;
154     emit Pause();
155   }
156 
157   function unpause() onlyOwner whenPaused public {
158     paused = false;
159     emit Unpause();
160   }
161 }
162 
163 
164 contract PauserRole {
165   using Roles for Roles.Role;
166 
167   event PauserAdded(address indexed account);
168   event PauserRemoved(address indexed account);
169 
170   Roles.Role private pausers;
171 
172   constructor() internal {
173     _addPauser(msg.sender);
174   }
175 
176   modifier onlyPauser() {
177     require(isPauser(msg.sender));
178     _;
179   }
180 
181   function isPauser(address account) public view returns (bool) {
182     return pausers.has(account);
183   }
184 
185   function addPauser(address account) public onlyPauser {
186     _addPauser(account);
187   }
188 
189   function renouncePauser() public {
190     _removePauser(msg.sender);
191   }
192 
193   function _addPauser(address account) internal {
194     pausers.add(account);
195     emit PauserAdded(account);
196   }
197 
198   function _removePauser(address account) internal {
199     pausers.remove(account);
200     emit PauserRemoved(account);
201   }
202 }
203 
204 library SafeMath {
205   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206     if (a == 0 || b == 0) {
207       return 0;
208     }
209 
210     uint256 c = a * b;
211     assert(c / a == b);
212     return c;
213   }
214 
215   function div(uint256 a, uint256 b) internal pure returns (uint256) {
216     // assert(b > 0); // Solidity automatically throws when dividing by 0
217     uint256 c = a / b;
218     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219     return c;
220   }
221 
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   function add(uint256 a, uint256 b) internal pure returns (uint256) {
228     uint256 c = a + b;
229     assert(c >= a); // overflow check
230     return c;
231   }
232 }
233 library Roles {
234   struct Role {
235     mapping (address => bool) bearer;
236   }
237 
238   function add(Role storage role, address account) internal {
239     require(account != address(0));
240     require(!has(role, account));
241 
242     role.bearer[account] = true;
243   }
244 
245   function remove(Role storage role, address account) internal {
246     require(account != address(0));
247     require(has(role, account));
248 
249     role.bearer[account] = false;
250   }
251 
252   function has(Role storage role, address account)
253     internal
254     view
255     returns (bool)
256   {
257     require(account != address(0));
258     return role.bearer[account];
259   }
260 }
261 
262 
263 
264 contract BurnableToken is BasicToken, Ownable {
265   event Burn(address indexed burner, uint256 amount);
266 
267   function burn(uint256 _value) onlyOwner public {
268     balances[msg.sender] = balances[msg.sender].sub(_value);
269     _totalSupply = _totalSupply.sub(_value);
270     emit Burn(msg.sender, _value);
271     emit Transfer(msg.sender, address(0), _value);
272   }
273 }
274 
275 
276 
277 contract FreezeToken is BasicToken, Ownable {
278   event Freeze(address indexed from, uint256 value);
279   event Unfreeze(address indexed from, uint256 value);
280   
281   function freeze(uint256 _value) public returns (bool success) {
282         if (balances[msg.sender] < _value) {
283         
284         }else{
285             if (_value <= 0){}
286             else{
287                 balances[msg.sender] = balances[msg.sender].sub(_value);
288                 freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
289                 emit Freeze(msg.sender, _value);
290                 return true;        
291             }
292             
293         }
294 		
295     }
296 	
297 	function unfreeze(uint256 _value) public returns (bool success) {
298         if (balances[msg.sender] < _value) {
299         
300         }else{
301             if (_value <= 0){}
302             else{
303                 freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
304         		balances[msg.sender] = balances[msg.sender].add(_value);
305                 emit Unfreeze(msg.sender, _value);
306                 return true;
307             }
308             
309         }
310     }
311 }
312 
313 
314 contract WECCoin is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{
315   using SafeMath for uint256;
316 
317   event Approval(address indexed owner, address indexed spender, uint256 value);
318 
319   string public constant symbol = "WEC";
320   string public constant name = "World Ex Coin";
321   uint8 public constant decimals = 18;
322       
323   uint256 public constant TOTAL_SUPPLY = 100*(10**8)*(10**uint256(decimals));
324 
325   constructor() DetailedERC20(name, symbol, decimals) public {
326     _totalSupply = TOTAL_SUPPLY;
327 
328     balances[owner] = _totalSupply;
329     emit Transfer(address(0x0), msg.sender, _totalSupply);
330   }
331 
332   function setAdmin(address newAdmin) onlyOwner public {	
333     address oldAdmin = admin;
334     super.setAdmin(newAdmin);
335     approve(oldAdmin, 0);
336     approve(newAdmin, TOTAL_SUPPLY);
337   }
338 
339   function transfer(address _to, uint256 _value)  public
340     whenNotPaused returns (bool)
341   {
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(address _from, address _to, uint256 _value) public
346     whenNotPaused returns (bool)
347   {
348     balances[_from] = balances[_from].sub(_value);
349     balances[_to] = balances[_to].add(_value);
350     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
351 
352     emit Transfer(_from, _to, _value);
353 
354     return true;
355 	
356   }
357   
358 
359   function() public payable {
360     revert();
361   }
362 }
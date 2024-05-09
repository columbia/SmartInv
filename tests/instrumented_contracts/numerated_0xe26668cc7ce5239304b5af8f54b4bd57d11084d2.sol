1 pragma solidity 0.4.24;
2 
3 library Math {
4   function max(uint256 a, uint256 b) internal pure returns (uint256) {
5     return a >= b ? a : b;
6   }
7 
8   function min(uint256 a, uint256 b) internal pure returns (uint256) {
9     return a < b ? a : b;
10   }
11 
12   function average(uint256 a, uint256 b) internal pure returns (uint256) {
13     // (a + b) / 2 can overflow, so we distribute
14     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
15   }
16 }
17 
18 
19 library SafeMath {
20   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
21     if (_a == 0) {
22       return 0;
23     }
24 
25     c = _a * _b;
26     assert(c / _a == _b);
27     return c;
28   }
29 
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     return _a / _b;
32   }
33 
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
40     c = _a + _b;
41     assert(c >= _a);
42     return c;
43   }
44 }
45 
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address _who) public view returns (uint256);
50   function transfer(address _to, uint256 _value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 
55 contract ERC20 is ERC20Basic {
56   function allowance(address _owner, address _spender)
57     public view returns (uint256);
58 
59   function transferFrom(address _from, address _to, uint256 _value)
60     public returns (bool);
61 
62   function approve(address _spender, uint256 _value) public returns (bool);
63   event Approval(
64     address indexed owner,
65     address indexed spender,
66     uint256 value
67   );
68 }
69 
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) internal balances;
75 
76   uint256 internal totalSupply_;
77 
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_value <= balances[msg.sender]);
84     require(_to != address(0));
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function balanceOf(address _owner) public view returns (uint256) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   function transferFrom(
105     address _from,
106     address _to,
107     uint256 _value
108   )
109     public
110     returns (bool)
111   {
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114     require(_to != address(0));
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     emit Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   function allowance(
130     address _owner,
131     address _spender
132    )
133     public
134     view
135     returns (uint256)
136   {
137     return allowed[_owner][_spender];
138   }
139 
140   function increaseApproval(
141     address _spender,
142     uint256 _addedValue
143   )
144     public
145     returns (bool)
146   {
147     allowed[msg.sender][_spender] = (
148       allowed[msg.sender][_spender].add(_addedValue));
149     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153   function decreaseApproval(
154     address _spender,
155     uint256 _subtractedValue
156   )
157     public
158     returns (bool)
159   {
160     uint256 oldValue = allowed[msg.sender][_spender];
161     if (_subtractedValue >= oldValue) {
162       allowed[msg.sender][_spender] = 0;
163     } else {
164       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165     }
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170 }
171 
172 
173 contract Ownable {
174   address public owner;
175 
176 
177   event OwnershipTransferred(
178     address indexed previousOwner,
179     address indexed newOwner
180   );
181 
182   constructor() public {
183     owner = msg.sender;
184   }
185 
186 
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191 
192 
193   function transferOwnership(address _newOwner) public onlyOwner {
194     _transferOwnership(_newOwner);
195   }
196 
197   function _transferOwnership(address _newOwner) internal {
198     require(_newOwner != address(0));
199     emit OwnershipTransferred(owner, _newOwner);
200     owner = _newOwner;
201   }
202 }
203 
204 
205 contract DAY is Ownable, StandardToken {
206     using SafeMath for uint256;
207     using Math for uint256;
208 
209     string public name = "DAY";
210     string public symbol = "DAY";
211     uint8 public decimals = 18;
212     uint256 public initialSupply = 20 * (10 ** 8) * (10 ** 18);
213 
214     // Token Time Lock
215     uint256 constant private initialLockedBalance = 9 * (10 ** 8) * (10 ** 18);
216     uint256 constant private unlockPerDay = (24 * 40000) * (10 ** 18);
217 
218     uint256 constant public checkTimestamp = 1539666000; // 2018-10-16 05:00:00 UTC
219     uint256 public burnedBeforeUnlockedBalance = 0;
220     uint256 public lockedBalance = initialLockedBalance;
221 
222     constructor (address _miningPool, address _marketingPool) public {
223         totalSupply_ = initialSupply;
224         balances[_miningPool] += 10 * (10 ** 8) * (10 ** 18);
225         balances[_marketingPool] += 1 * (10 ** 8) * (10 ** 18);
226         
227         emit Transfer(address(0), _miningPool, 10 * (10 ** 8) * (10 ** 18));
228         emit Transfer(address(0), _marketingPool, 1 * (10 ** 8) * (10 ** 18));
229         emit Transfer(address(0), address(0), initialLockedBalance);
230     }
231 
232     function () public payable {
233         revert("Fallback function not allowed");
234     }
235 
236     event Burn(address indexed burner, uint256 value);
237 
238     function burn(uint256 _value) public onlyOwner {
239         _burn(msg.sender, _value);
240     }
241 
242     function _burn(address _who, uint256 _value) internal {
243         require(_value <= balances[_who]);
244 
245         balances[_who] = balances[_who].sub(_value);
246         totalSupply_ = totalSupply_.sub(_value);
247         emit Burn(_who, _value);
248         emit Transfer(_who, address(0), _value);
249     } 
250 
251     function burnLockedBalance(uint256 _value) public onlyOwner {
252         require(_value <= lockedBalance);
253 
254         lockedBalance = lockedBalance.sub(_value);
255         totalSupply_ = totalSupply_.sub(_value);
256         burnedBeforeUnlockedBalance = burnedBeforeUnlockedBalance.add(_value);
257         emit Burn(address(0), _value);
258         emit Transfer(address(0), address(0), _value);
259     }
260 
261 
262     event Pause();
263     event Unpause();
264 
265     bool public paused = false;
266 
267     modifier whenNotPaused() {
268         require(!paused);
269         _;
270     }
271 
272     modifier whenPaused() {
273         require(paused);
274         _;
275     }
276 
277     function pause() public onlyOwner whenNotPaused {
278         paused = true;
279         emit Pause();
280     }
281 
282     function unpause() public onlyOwner whenPaused {
283         paused = false;
284         emit Unpause();
285     } 
286     
287     function transfer(
288         address _to,
289         uint256 _value
290     )
291         public
292         whenNotPaused
293         returns (bool)
294     {
295         return super.transfer(_to, _value);
296     }
297 
298     function transferFrom(
299         address _from,
300         address _to,
301         uint256 _value
302     )
303         public
304         whenNotPaused
305         returns (bool)
306     {
307         return super.transferFrom(_from, _to, _value);
308     }
309 
310     function approve(
311         address _spender,
312         uint256 _value
313     )
314         public
315         whenNotPaused
316         returns (bool)
317     {
318         return super.approve(_spender, _value);
319     }
320 
321     function increaseApproval(
322         address _spender,
323         uint _addedValue
324     )
325         public
326         whenNotPaused
327         returns (bool success)
328     {
329         return super.increaseApproval(_spender, _addedValue);
330     }
331 
332     function decreaseApproval(
333         address _spender,
334         uint _subtractedValue
335     )
336         public
337         whenNotPaused
338         returns (bool success)
339     {
340         return super.decreaseApproval(_spender, _subtractedValue);
341     } 
342 
343     function unlockBalance(uint256 _balance) public onlyOwner {
344         require(_balance <= lockedBalance, "Cannot unlock more balance than locked balance");
345         require(_balance <= getUnlockableAmount(), "Too much amount");
346 
347         lockedBalance = lockedBalance.sub(_balance);
348         balances[owner] = balances[owner].add(_balance);
349 
350         emit Transfer(address(0), owner, _balance);
351     } 
352 
353     function getUnlockableAmount() public view returns (uint256) {
354         uint256 daysFromCheck = (block.timestamp.sub(checkTimestamp)).div(1 days);
355         uint256 maxLockedBalance = initialLockedBalance.sub(burnedBeforeUnlockedBalance);
356         uint256 unlockable = unlockPerDay.mul(daysFromCheck).min(maxLockedBalance);
357         uint256 unlocked = maxLockedBalance.sub(lockedBalance);
358 
359         return unlockable.sub(unlocked);
360     }
361 }
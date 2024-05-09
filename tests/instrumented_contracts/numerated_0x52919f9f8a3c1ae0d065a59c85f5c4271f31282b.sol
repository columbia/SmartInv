1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 _x, uint256 _y) internal pure returns (uint256 z) {
5         if (_x == 0) {
6             return 0;
7         }
8         z = _x * _y;
9         assert(z / _x == _y);
10         return z;
11     }
12 
13     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
14         return _x / _y;
15     }
16 
17     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
18         assert(_y <= _x);
19         return _x - _y;
20     }
21 
22     function add(uint256 _x, uint256 _y) internal pure returns (uint256 z) {
23         z = _x + _y;
24         assert(z >= _x);
25         return z;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) onlyOwner public {
44         require(_newOwner != address(0));
45 
46         owner = _newOwner;
47 
48         emit OwnershipTransferred(owner, _newOwner);
49     }
50 }
51 
52 contract Erc20Wrapper {
53     function totalSupply() public view returns (uint256);
54     function balanceOf(address _who) public view returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
57     function approve(address _spender, uint256 _value) public returns (bool);
58     function allowance(address _owner, address _spender) public view returns (uint256);
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 contract StandardToken is Erc20Wrapper {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) internal allowed;
69 
70     uint256 totalSupply_;
71 
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76     function balanceOf(address _owner) public view returns (uint256) {
77         return balances[_owner];
78     }
79 
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value > 0 && _value <= balances[msg.sender]);
83 
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86 
87         emit Transfer(msg.sender, _to, _value);
88 
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94         require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
95 
96         balances[_from] = balances[_from].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99 
100         emit Transfer(_from, _to, _value);
101 
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool) {
106         allowed[msg.sender][_spender] = _value;
107 
108         emit Approval(msg.sender, _spender, _value);
109 
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) public view returns (uint256) {
114         return allowed[_owner][_spender];
115     }
116 
117     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
119 
120         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121 
122         return true;
123     }
124 
125     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
126         uint oldValue = allowed[msg.sender][_spender];
127         if (_subtractedValue > oldValue) {
128             allowed[msg.sender][_spender] = 0;
129         } else {
130             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131         }
132 
133         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134 
135         return true;
136     }
137 }
138 
139 contract Pausable is Ownable {
140     event Pause();
141     event Unpause();
142 
143     bool public paused = false;
144 
145     modifier whenNotPaused() {
146         require(!paused);
147         _;
148     }
149 
150     modifier whenPaused() {
151         require(paused);
152         _;
153     }
154 
155     function pause() onlyOwner whenNotPaused public {
156         paused = true;
157         emit Pause();
158     }
159 
160     function unpause() onlyOwner whenPaused public {
161         paused = false;
162         emit Unpause();
163     }
164 }
165 
166 contract PausableToken is StandardToken, Pausable {
167     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
168         return super.transfer(_to, _value);
169     }
170 
171     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
172         return super.transferFrom(_from, _to, _value);
173     }
174 
175     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
176         return super.approve(_spender, _value);
177     }
178 
179     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {
180         return super.increaseApproval(_spender, _addedValue);
181     }
182 
183     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {
184         return super.decreaseApproval(_spender, _subtractedValue);
185     }
186 }
187 
188 contract FINBToken is PausableToken {
189     string public name = "FindBit.io Token";
190     string public symbol = "FINB";
191     uint8  public decimals = 18;
192 
193     uint256 public constant INITIAL_SUPPLY = 50000000 ether;
194     uint256 public constant MIN_FREEZE_DURATION = 1 days;
195 
196     struct Schedule {
197         uint256 amount;
198         uint256 start;
199         uint256 cliff;
200         uint256 duration;
201         uint256 released;
202         uint256 lastReleased;
203     }
204 
205     mapping (address => Schedule) freezed;
206 
207     event Freeze(address indexed _who, uint256 _value, uint256 _cliff, uint256 _duration);
208     event Unfreeze(address indexed _who, uint256 _value);
209 
210     event Mint(address indexed _to, uint256 _amount);
211     event Burn(address indexed _who, uint256 _value);
212 
213     constructor() public {
214         totalSupply_ = INITIAL_SUPPLY;
215         balances[msg.sender] = INITIAL_SUPPLY;
216         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
217     }
218 
219     function freezeOf(address _owner) public view returns (uint256) {
220         return freezed[_owner].amount;
221     }
222 
223     function freeze(uint256 _value, uint256 _duration) public {
224         require(_value > 0 && _value <= balances[msg.sender]);
225         require(freezed[msg.sender].amount == 0);
226         require(_duration >= MIN_FREEZE_DURATION);
227 
228         balances[msg.sender] = balances[msg.sender].sub(_value);
229 
230         // solium-disable-next-line security/no-block-members
231         uint256 timestamp = block.timestamp;
232         freezed[msg.sender] = Schedule({
233             amount: _value,
234             start: timestamp,
235             cliff: timestamp,
236             duration: _duration,
237             released: 0,
238             lastReleased: timestamp
239         });
240 
241         emit Freeze(msg.sender, _value, 0, _duration);
242     }
243 
244     function freezeFrom(address _who, uint256 _value, uint256 _cliff, uint256 _duration) onlyOwner public {
245         require(_who != address(0));
246         require(_value > 0 && _value <= balances[_who]);
247         require(freezed[_who].amount == 0);
248         require(_cliff <= _duration);
249         require(_duration >= MIN_FREEZE_DURATION);
250 
251         balances[_who] = balances[_who].sub(_value);
252 
253         // solium-disable-next-line security/no-block-members
254         uint256 timestamp = block.timestamp;
255         freezed[_who] = Schedule({
256             amount: _value,
257             start: timestamp,
258             cliff: timestamp.add(_cliff),
259             duration: _duration,
260             released: 0,
261             lastReleased: timestamp.add(_cliff)
262         });
263 
264         emit Freeze(_who, _value, _cliff, _duration);
265     }
266 
267     function unfreeze(address _who) public returns (uint256) {
268         require(_who != address(0));
269 
270         Schedule storage schedule = freezed[_who];
271 
272         // solium-disable-next-line security/no-block-members
273         uint256 timestamp = block.timestamp;
274 
275         require(schedule.lastReleased.add(MIN_FREEZE_DURATION) < timestamp);
276         require(schedule.amount > 0 && timestamp > schedule.cliff);
277 
278         uint256 unreleased = 0;
279         if (timestamp >= schedule.start.add(schedule.duration)) {
280             unreleased = schedule.amount;
281         } else {
282             unreleased = (schedule.amount.add(schedule.released)).mul(timestamp.sub(schedule.start)).div(schedule.duration).sub(schedule.released);
283         }
284         require(unreleased > 0);
285 
286         schedule.released = schedule.released.add(unreleased);
287         schedule.lastReleased = timestamp;
288         schedule.amount = schedule.amount.sub(unreleased);
289 
290         balances[_who] = balances[_who].add(unreleased);
291 
292         emit Unfreeze(_who, unreleased);
293 
294         return unreleased;
295     }
296 
297     function mint(address _to, uint256 _value) onlyOwner public returns (bool) {
298         require(_to != address(0));
299         require(_value > 0);
300 
301         totalSupply_ = totalSupply_.add(_value);
302         balances[_to] = balances[_to].add(_value);
303 
304         emit Mint(_to, _value);
305         emit Transfer(address(0), _to, _value);
306 
307         return true;
308     }
309 
310     function burn(address _who, uint256 _value) onlyOwner public returns (bool success) {
311         require(_who != address(0));
312         require(_value > 0 && _value <= balances[_who]);
313 
314         balances[_who] = balances[_who].sub(_value);
315         totalSupply_ = totalSupply_.sub(_value);
316 
317         emit Burn(_who, _value);
318         emit Transfer(_who, address(0), _value);
319 
320         return true;
321     }
322 }
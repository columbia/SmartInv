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
188 contract FindBitToken is PausableToken {
189     string public name = "FindBit.io Token";
190     string public symbol = "FBIT";
191     uint8  public decimals = 18;
192 
193     struct Schedule {
194         uint256 amount;
195         uint256 start;
196         uint256 cliff;
197         uint256 duration;
198         uint256 released;
199         uint256 lastReleased;
200     }
201 
202     mapping (address => Schedule) freezed;
203 
204     event UpdatedTokenInfo(string _newName, string _newSymbol);
205 
206     event Freeze(address indexed _who, uint256 _value, uint256 _cliff, uint256 _duration);
207     event Unfreeze(address indexed _who, uint256 _value);
208 
209     event Mint(address indexed _to, uint256 _amount);
210     event Burn(address indexed _who, uint256 _value);
211 
212     constructor() public {
213         totalSupply_ = 50000000 * (10 ** uint256(decimals));
214         balances[msg.sender] = totalSupply_;
215 
216         emit Transfer(0x0, msg.sender, totalSupply_);
217     }
218 
219     function setTokenInfo(string _name, string _symbol) onlyOwner public {
220         name = _name;
221         symbol = _symbol;
222 
223         emit UpdatedTokenInfo(name, symbol);
224     }
225 
226     function freezeOf(address _owner) public view returns (uint256) {
227         return freezed[_owner].amount;
228     }
229 
230     function freeze(uint256 _value, uint256 _duration) public {
231         require(_value > 0 && _value <= balances[msg.sender]);
232         require(_duration > 60);
233 
234         balances[msg.sender] = balances[msg.sender].sub(_value);
235 
236         // solium-disable-next-line security/no-block-members
237         uint256 timestamp = block.timestamp;
238         freezed[msg.sender] = Schedule({
239             amount: _value,
240             start: timestamp,
241             cliff: timestamp,
242             duration: _duration,
243             released: 0,
244             lastReleased: timestamp
245         });
246 
247         emit Freeze(msg.sender, _value, 0, _duration);
248     }
249 
250     function freezeFrom(address _who, uint256 _value, uint256 _cliff, uint256 _duration) onlyOwner public {
251         require(_who != address(0));
252         require(_value > 0 && _value <= balances[_who]);
253         require(_cliff <= _duration);
254 
255         balances[_who] = balances[_who].sub(_value);
256 
257         // solium-disable-next-line security/no-block-members
258         uint256 timestamp = block.timestamp;
259         freezed[msg.sender] = Schedule({
260             amount: _value,
261             start: timestamp,
262             cliff: timestamp.add(_cliff),
263             duration: _duration,
264             released: 0,
265             lastReleased: timestamp.add(_cliff)
266         });
267 
268         emit Freeze(_who, _value, _cliff, _duration);
269     }
270 
271     function unfreeze(address _who) public returns (uint256) {
272         require(_who != address(0));
273 
274         Schedule storage schedule = freezed[_who];
275 
276         // solium-disable-next-line security/no-block-members
277         uint256 timestamp = block.timestamp;
278 
279         require(schedule.lastReleased.add(60) < timestamp);
280         require(schedule.amount > 0 && timestamp > schedule.cliff);
281 
282         uint256 unreleased = 0;
283         if (timestamp >= schedule.start.add(schedule.duration)) {
284             unreleased = schedule.amount;
285         } else {
286             unreleased = (schedule.amount.add(schedule.released)).mul(timestamp.sub(schedule.start)).div(schedule.duration).sub(schedule.released);
287         }
288         require(unreleased > 0);
289 
290         schedule.released = schedule.released.add(unreleased);
291         schedule.lastReleased = timestamp;
292         schedule.amount = schedule.amount.sub(unreleased);
293 
294         balances[_who] = balances[_who].add(unreleased);
295 
296         emit Unfreeze(_who, unreleased);
297 
298         return unreleased;
299     }
300 
301     function mint(address _to, uint256 _value) onlyOwner public returns (bool) {
302         require(_to != address(0));
303         require(_value > 0);
304 
305         totalSupply_ = totalSupply_.add(_value);
306         balances[_to] = balances[_to].add(_value);
307 
308         emit Mint(_to, _value);
309         emit Transfer(address(0), _to, _value);
310 
311         return true;
312     }
313 
314     function burn(address _who, uint256 _value) onlyOwner public returns (bool success) {
315         require(_who != address(0));
316         require(_value > 0 && _value <= balances[_who]);
317 
318         balances[_who] = balances[_who].sub(_value);
319         totalSupply_ = totalSupply_.sub(_value);
320 
321         emit Burn(_who, _value);
322         emit Transfer(_who, address(0), _value);
323 
324         return true;
325     }
326 }
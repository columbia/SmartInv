1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5     if (_a == 0) {
6       return 0;
7     }
8 
9     c = _a * _b;
10     assert(c / _a == _b);
11     return c;
12   }
13 
14   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     return _a / _b;
16   }
17 
18   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
19     assert(_b <= _a);
20     return _a - _b;
21   }
22 
23   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24     c = _a + _b;
25     assert(c >= _a);
26     return c;
27   }
28 }
29 
30 contract ERC20 {
31   function totalSupply() public view returns (uint256);
32 
33   function balanceOf(address _who) public view returns (uint256);
34 
35   function allowance(address _owner, address _spender)
36     public view returns (uint256);
37 
38   function transfer(address _to, uint256 _value) public returns (bool);
39 
40   function approve(address _spender, uint256 _value)
41     public returns (bool);
42 
43   function transferFrom(address _from, address _to, uint256 _value)
44     public returns (bool);
45 
46   event Transfer(
47     address indexed from,
48     address indexed to,
49     uint256 value
50   );
51 
52   event Approval(
53     address indexed owner,
54     address indexed spender,
55     uint256 value
56   );
57 }
58 
59 contract StandardToken is ERC20 {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   mapping (address => mapping (address => uint256)) internal allowed;
65 
66   uint256 totalSupply_;
67 
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71 
72   function balanceOf(address _owner) public view returns (uint256) {
73     return balances[_owner];
74   }
75 
76   function allowance(
77     address _owner,
78     address _spender
79    )
80     public
81     view
82     returns (uint256)
83   {
84     return allowed[_owner][_spender];
85   }
86 
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_value <= balances[msg.sender]);
89     require(_to != address(0));
90 
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function approve(address _spender, uint256 _value) public returns (bool) {
98     allowed[msg.sender][_spender] = _value;
99     emit Approval(msg.sender, _spender, _value);
100     return true;
101   }
102 
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113     require(_to != address(0));
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   function increaseApproval(
123     address _spender,
124     uint256 _addedValue
125   )
126     public
127     returns (bool)
128   {
129     allowed[msg.sender][_spender] = (
130       allowed[msg.sender][_spender].add(_addedValue));
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(
136     address _spender,
137     uint256 _subtractedValue
138   )
139     public
140     returns (bool)
141   {
142     uint256 oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue >= oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 
153 contract Ownable {
154   address public owner;
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162   constructor() public {
163     owner = msg.sender;
164   }
165 
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   function renounceOwnership() public onlyOwner {
172     emit OwnershipRenounced(owner);
173     owner = address(0);
174   }
175 
176   function transferOwnership(address _newOwner) public onlyOwner {
177     _transferOwnership(_newOwner);
178   }
179 
180   function _transferOwnership(address _newOwner) internal {
181     require(_newOwner != address(0));
182     emit OwnershipTransferred(owner, _newOwner);
183     owner = _newOwner;
184   }
185 }
186 
187 contract Pausable is Ownable {
188   event Pause();
189   event Unpause();
190 
191   bool public paused = false;
192 
193   modifier whenNotPaused() {
194     require(!paused);
195     _;
196   }
197 
198   modifier whenPaused() {
199     require(paused);
200     _;
201   }
202 
203   function pause() public onlyOwner whenNotPaused {
204     paused = true;
205     emit Pause();
206   }
207 
208   function unpause() public onlyOwner whenPaused {
209     paused = false;
210     emit Unpause();
211   }
212 }
213 
214 contract PausableToken is StandardToken, Pausable {
215 
216   function transfer(
217     address _to,
218     uint256 _value
219   )
220     public
221     whenNotPaused
222     returns (bool)
223   {
224     return super.transfer(_to, _value);
225   }
226 
227   function transferFrom(
228     address _from,
229     address _to,
230     uint256 _value
231   )
232     public
233     whenNotPaused
234     returns (bool)
235   {
236     return super.transferFrom(_from, _to, _value);
237   }
238 
239   function approve(
240     address _spender,
241     uint256 _value
242   )
243     public
244     whenNotPaused
245     returns (bool)
246   {
247     return super.approve(_spender, _value);
248   }
249 
250   function increaseApproval(
251     address _spender,
252     uint _addedValue
253   )
254     public
255     whenNotPaused
256     returns (bool success)
257   {
258     return super.increaseApproval(_spender, _addedValue);
259   }
260 
261   function decreaseApproval(
262     address _spender,
263     uint _subtractedValue
264   )
265     public
266     whenNotPaused
267     returns (bool success)
268   {
269     return super.decreaseApproval(_spender, _subtractedValue);
270   }
271 }
272 
273 contract MintableToken is StandardToken, Ownable {
274   using SafeMath for uint256;
275   event Mint(address indexed to, uint256 amount);
276 
277   uint constant YEAR_IN_SECONDS = 31536000;
278 
279   uint constant ORIGIN_TIMESTAMP = 1514764800;
280   uint16 constant ORIGIN_YEAR = 2018;
281 
282   uint256 originSupply_;
283   // ufixed8x2 u0.02;
284 
285   struct MintRecord {
286       uint percent;
287       address holder;
288       uint16 year;
289       uint256 amount;
290       uint timestamp;
291   }
292 
293   // year=> MintRecord
294   mapping (uint16 => MintRecord) public mintedHistory;
295 
296   function getYear(uint _timestamp) public pure returns (uint16) {
297     require(_timestamp > ORIGIN_TIMESTAMP);
298     return ORIGIN_YEAR + uint16((_timestamp - ORIGIN_TIMESTAMP) / YEAR_IN_SECONDS);
299   }
300 
301   modifier hasMintPermission() {
302     require(msg.sender == owner);
303     _;
304   }
305 
306   function originSupply() public view returns (uint256) {
307     return originSupply_;
308   }
309 
310   function mint() public hasMintPermission returns (bool) {
311     return _mint(block.timestamp);
312   }
313 
314   function _mint(uint _timestamp) internal hasMintPermission returns (bool) {
315     uint16 year = getYear(_timestamp);
316     require(mintedHistory[year].percent == 0);
317     uint256 amount = totalSupply_.mul(200).div(10000);
318     totalSupply_ = totalSupply_.add(amount);
319     balances[msg.sender] = balances[msg.sender].add(amount);
320     mintedHistory[year] = MintRecord({
321         percent: 200,
322         amount: amount,
323         holder: msg.sender,
324         timestamp: _timestamp,
325         year: year
326     });
327     emit Transfer(address(0), msg.sender, amount);
328     emit Mint(msg.sender, amount);
329     return true;
330   }
331 }
332 
333 contract HGSToken is PausableToken, MintableToken {
334 
335   string public constant name = "Hawthorn Guardian System";
336   string public constant symbol = "HGS";
337   uint8 public constant decimals = 18;
338 
339   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
340 
341   constructor() public {
342     totalSupply_ = INITIAL_SUPPLY;
343     originSupply_ = INITIAL_SUPPLY;
344     balances[msg.sender] = INITIAL_SUPPLY;
345     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
346   }
347 }
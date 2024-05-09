1 pragma solidity ^0.4.25;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   function approve(address spender, uint256 value) public returns (bool);
9   function transferFrom(address from, address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     emit OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 
35 }
36 
37 
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 contract StandardToken is ERC20 {
73   using SafeMath for uint256;
74 
75   uint256 totalSupply_;
76   mapping (address => uint256) balances;
77   mapping (address => mapping (address => uint256)) internal allowed;
78 
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     emit Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     require(allowed[msg.sender][_spender] == 0 || _value == 0);
111     allowed[msg.sender][_spender] = _value;
112     emit Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   function allowance(address _owner, address _spender) public view returns (uint256) {
117     return allowed[_owner][_spender];
118   }
119 
120   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
121     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
122     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123     return true;
124   }
125 
126   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
127     uint oldValue = allowed[msg.sender][_spender];
128     if (_subtractedValue > oldValue) {
129       allowed[msg.sender][_spender] = 0;
130     } else {
131       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
132     }
133     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137 }
138 
139 
140 contract MintableToken is StandardToken, Ownable {
141   event Mint(address indexed to, uint256 amount);
142   event MintFinished();
143 
144   bool public mintingFinished = false;
145 
146 
147   modifier canMint() {
148     require(!mintingFinished);
149     _;
150   }
151 
152   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
153     totalSupply_ = totalSupply_.add(_amount);
154     balances[_to] = balances[_to].add(_amount);
155     emit Mint(_to, _amount);
156     emit Transfer(address(0), _to, _amount);
157     return true;
158   }
159 
160   function finishMinting() onlyOwner canMint public returns (bool) {
161     mintingFinished = true;
162     emit MintFinished();
163     return true;
164   }
165 }
166 
167 
168 contract CappedToken is MintableToken {
169 
170   uint256 public cap;
171 
172   constructor(uint256 _cap) public {
173     require(_cap > 0);
174     cap = _cap;
175   }
176 
177   function mint(
178     address _to,
179     uint256 _amount
180   )
181     public
182     returns (bool)
183   {
184     require(totalSupply_.add(_amount) <= cap);
185 
186     return super.mint(_to, _amount);
187   }
188 
189 }
190 
191 
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   modifier whenNotPaused() {
200     require(!paused);
201     _;
202   }
203 
204   modifier whenPaused() {
205     require(paused);
206     _;
207   }
208 
209   function pause() onlyOwner whenNotPaused public {
210     paused = true;
211     emit Pause();
212   }
213 
214   function unpause() onlyOwner whenPaused public {
215     paused = false;
216     emit Unpause();
217   }
218 }
219 
220 
221 contract PausableToken is StandardToken, Pausable {
222 
223   function transfer(
224     address _to,
225     uint256 _value
226   )
227     public
228     whenNotPaused
229     returns (bool)
230   {
231     return super.transfer(_to, _value);
232   }
233 
234   function transferFrom(
235     address _from,
236     address _to,
237     uint256 _value
238   )
239     public
240     whenNotPaused
241     returns (bool)
242   {
243     return super.transferFrom(_from, _to, _value);
244   }
245 
246   function approve(
247     address _spender,
248     uint256 _value
249   )
250     public
251     whenNotPaused
252     returns (bool)
253   {
254     return super.approve(_spender, _value);
255   }
256 
257   function increaseApproval(
258     address _spender,
259     uint _addedValue
260   )
261     public
262     whenNotPaused
263     returns (bool success)
264   {
265     return super.increaseApproval(_spender, _addedValue);
266   }
267 
268   function decreaseApproval(
269     address _spender,
270     uint _subtractedValue
271   )
272     public
273     whenNotPaused
274     returns (bool success)
275   {
276     return super.decreaseApproval(_spender, _subtractedValue);
277   }
278 }
279 
280 
281 contract Terminateable is Ownable {
282   event Terminate();
283 
284   bool public terminated = false;
285   
286   modifier whenNotTerminated() {
287     require(!terminated);
288     _;
289   }
290 
291   function terminate() onlyOwner public {
292     terminated = true;
293     emit Terminate();
294   }
295 
296 }
297 
298 
299 contract TerminateableToken is MintableToken, Terminateable {
300 
301   function mint(
302     address _to,
303     uint256 _value
304   ) 
305     public
306     whenNotTerminated
307     returns (bool)
308   {
309     return super.mint(_to, _value);
310   }
311 
312   function transfer(
313     address _to,
314     uint256 _value
315   )
316     public
317     whenNotTerminated
318     returns (bool)
319   {
320     return super.transfer(_to, _value);
321   }
322 
323   function transferFrom(
324     address _from,
325     address _to,
326     uint256 _value
327   )
328     public
329     whenNotTerminated
330     returns (bool)
331   {
332     return super.transferFrom(_from, _to, _value);
333   }
334 
335   function approve(
336     address _spender,
337     uint256 _value
338   )
339     public
340     whenNotTerminated
341     returns (bool)
342   {
343     return super.approve(_spender, _value);
344   }
345 
346   function increaseApproval(
347     address _spender,
348     uint _addedValue
349   )
350     public
351     whenNotTerminated
352     returns (bool success)
353   {
354     return super.increaseApproval(_spender, _addedValue);
355   }
356 
357   function decreaseApproval(
358     address _spender,
359     uint _subtractedValue
360   )
361     public
362     whenNotTerminated
363     returns (bool success)
364   {
365     return super.decreaseApproval(_spender, _subtractedValue);
366   }
367 }
368 
369 contract QMCToken is PausableToken, TerminateableToken, CappedToken {
370     string public name = "QIAO MIAO COMMERCE";
371     string public symbol = "QMC";
372     uint8 public decimals = 0;
373    
374 
375     constructor () public CappedToken(30000000000){}
376 }
1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 contract ERC20 {
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58 
59   event Transfer(address indexed from, address indexed to, uint256 value);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61   function mint(address to, uint256 value) public returns (bool ok);
62 }
63 
64 
65 
66 contract Ownable {
67   address public owner;
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76 
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 }
89 
90 
91 
92 contract DAOToken is ERC20, Ownable {
93   using SafeMath for uint256;
94 
95   string public constant name = "Pi Token";
96   string public constant symbol = "PI";
97   uint8 public constant decimals = 18;
98   //uint256 public constant INITIAL_SUPPLY = 9000000 * (10 ** uint256(decimals));
99   uint256 public constant INITIAL_SUPPLY = 0;
100 
101   mapping (address => uint256) balances;
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   uint256 totalSupply_;
105   uint OneYearLater;
106 
107 
108   address public crowdsale;
109 
110 
111   event NewDAOContract(address indexed previousDAOContract, address indexed newDAOContract);
112    event NewCrowdContract(address indexed previousCrowdContract, address indexed newCrowdContract);
113 
114 
115   constructor() public {
116     owner = msg.sender;
117 
118 OneYearLater = now + 365 days;
119 
120     totalSupply_ = INITIAL_SUPPLY;
121     balances[owner] = INITIAL_SUPPLY;
122     emit Transfer(0x0, owner, INITIAL_SUPPLY);
123     crowdsale = 0x0;
124   }
125 
126 
127 
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132 
133   function setCrowd(address crowd) onlyOwner external {
134     require(crowdsale == 0x0);
135     crowdsale = crowd;
136   }
137 
138 
139     function mint(address _address, uint _value) public returns (bool success) {
140 
141 
142         require(now < OneYearLater);
143 
144         require(msg.sender == crowdsale);
145 
146         balances[_address] = balanceOf(_address).add(_value);
147         totalSupply_ = totalSupply_.add(_value);
148 
149         balances[owner] = balanceOf(owner).add(_value);
150         totalSupply_ = totalSupply_.add(_value);
151 
152         return true;
153 
154 
155 }
156 
157 
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160 
161     uint256 _balance = _balanceOf(msg.sender);
162     require(_value <= _balance);
163 
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167 
168     emit Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172 
173   function balanceOf(address _owner) public view returns (uint256 balance) {
174     return _balanceOf(_owner);
175   }
176 
177 
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180 
181     uint256 _balance = _balanceOf(_from);
182     require(_value <= _balance);
183 
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193 
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200 
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205 
206 
207 
208   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 
227   function approveAndCall(
228     address _spender,
229     uint256 _value,
230     bytes _data
231   )
232   public
233   payable
234   returns (bool)
235   {
236     require(_spender != address(this));
237 
238     approve(_spender, _value);
239 
240 
241     require(_spender.call.value(msg.value)(_data));
242 
243     return true;
244   }
245 
246 
247   function transferAndCall(
248     address _to,
249     uint256 _value,
250     bytes _data
251   )
252   public
253   payable
254   returns (bool)
255   {
256     require(_to != address(this));
257 
258     transfer(_to, _value);
259 
260 
261     require(_to.call.value(msg.value)(_data));
262     return true;
263   }
264 
265 
266   function transferFromAndCall(
267     address _from,
268     address _to,
269     uint256 _value,
270     bytes _data
271   )
272   public payable returns (bool)
273   {
274     require(_to != address(this));
275 
276     transferFrom(_from, _to, _value);
277 
278 
279     require(_to.call.value(msg.value)(_data));
280     return true;
281   }
282 
283 
284   function increaseApprovalAndCall(
285     address _spender,
286     uint _addedValue,
287     bytes _data
288   )
289   public
290   payable
291   returns (bool)
292   {
293     require(_spender != address(this));
294 
295     increaseApproval(_spender, _addedValue);
296 
297 
298     require(_spender.call.value(msg.value)(_data));
299 
300     return true;
301   }
302 
303 
304   function decreaseApprovalAndCall(
305     address _spender,
306     uint _subtractedValue,
307     bytes _data
308   )
309   public
310   payable
311   returns (bool)
312   {
313     require(_spender != address(this));
314 
315     decreaseApproval(_spender, _subtractedValue);
316 
317 
318     require(_spender.call.value(msg.value)(_data));
319 
320     return true;
321   }
322 
323 
324 
325   function pureBalanceOf(address _owner) public view returns (uint256 balance) {
326     return balances[_owner];
327   }
328 
329 
330 
331   function _balanceOf(address _owner) internal view returns (uint256) {
332     return balances[_owner];
333   }
334 
335 
336 }
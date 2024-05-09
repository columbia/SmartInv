1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // TOKENMOM Korean Won(KRWT) Smart contract Token V.10
5 // 토큰맘 거래소 Korean Won 스마트 컨트랙트 토큰
6 // Deployed to : 0x8af2d2e23f0913af81abc6ccaa6200c945a161b4
7 // Symbol      : BETA
8 // Name        : TOKENMOM Korean Won
9 // Total supply: 10000000000
10 // Decimals    : 8
11 // ----------------------------------------------------------------------------
12 
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 library SafeMath {
21 
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63 
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function balanceOf(address _owner) public view returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     emit Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113 
114   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
115     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
116     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 }
131 
132 contract Ownable {
133   address public owner;
134   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136   function Ownable() public {
137     owner = msg.sender;
138   }
139 
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }
144 
145   function transferOwnership(address newOwner) public onlyOwner {
146     require(newOwner != address(0));
147     emit OwnershipTransferred(owner, newOwner);
148     owner = newOwner;
149   }
150 
151 }
152 
153 contract MintableToken is StandardToken, Ownable {
154   event Mint(address indexed to, uint256 amount);
155   event MintFinished();
156 
157   bool public mintingFinished = false;
158 
159 
160   modifier canMint() {
161     require(!mintingFinished);
162     _;
163   }
164 
165   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
166     totalSupply_ = totalSupply_.add(_amount);
167     balances[_to] = balances[_to].add(_amount);
168     emit Mint(_to, _amount);
169     emit Transfer(address(0), _to, _amount);
170     return true;
171   }
172 
173   function finishMinting() onlyOwner canMint public returns (bool) {
174     mintingFinished = true;
175     emit MintFinished();
176     return true;
177   }
178 }
179 
180 contract BurnableToken is BasicToken {
181 
182   event Burn(address indexed burner, uint256 value);
183 
184   function burn(uint256 _value) public {
185     require(_value <= balances[msg.sender]);
186     address burner = msg.sender;
187     balances[burner] = balances[burner].sub(_value);
188     totalSupply_ = totalSupply_.sub(_value);
189     emit Burn(burner, _value);
190     emit Transfer(burner, address(0), _value);
191   }
192 }
193 
194 contract CappedToken is MintableToken {
195 
196   uint256 public cap;
197 
198   function CappedToken(uint256 _cap) public {
199     require(_cap > 0);
200     cap = _cap;
201   }
202 
203   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
204     require(totalSupply_.add(_amount) <= cap);
205 
206     return super.mint(_to, _amount);
207   }
208 
209 }
210 
211 contract Pausable is Ownable {
212   event Pause();
213   event Unpause();
214 
215   bool public paused = false;
216 
217   modifier whenNotPaused() {
218     require(!paused);
219     _;
220   }
221 
222   modifier whenPaused() {
223     require(paused);
224     _;
225   }
226 
227   function pause() onlyOwner whenNotPaused public {
228     paused = true;
229     emit Pause();
230   }
231 
232   function unpause() onlyOwner whenPaused public {
233     paused = false;
234     emit Unpause();
235   }
236 }
237 
238 
239 contract PausableToken is StandardToken, Pausable {
240 
241   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
242     return super.transfer(_to, _value);
243   }
244 
245   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
246     return super.transferFrom(_from, _to, _value);
247   }
248 
249   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
250     return super.approve(_spender, _value);
251   }
252 
253   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
254     return super.increaseApproval(_spender, _addedValue);
255   }
256 
257   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
258     return super.decreaseApproval(_spender, _subtractedValue);
259   }
260 }
261 
262 contract ERC827 is ERC20 {
263 
264   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
265   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
266   function transferFrom(
267     address _from,
268     address _to,
269     uint256 _value,
270     bytes _data
271   )
272     public
273     returns (bool);
274 
275 }
276 
277 contract ERC827Token is ERC827, StandardToken {
278 
279   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
280     require(_spender != address(this));
281 
282     super.approve(_spender, _value);
283 
284     require(_spender.call(_data));
285 
286     return true;
287   }
288 
289   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
290     require(_to != address(this));
291 
292     super.transfer(_to, _value);
293 
294     require(_to.call(_data));
295     return true;
296   }
297 
298   function transferFrom(
299     address _from,
300     address _to,
301     uint256 _value,
302     bytes _data
303   )
304     public returns (bool)
305   {
306     require(_to != address(this));
307 
308     super.transferFrom(_from, _to, _value);
309 
310     require(_to.call(_data));
311     return true;
312   }
313 
314   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
315     require(_spender != address(this));
316 
317     super.increaseApproval(_spender, _addedValue);
318 
319     require(_spender.call(_data));
320 
321     return true;
322   }
323 
324   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
325     require(_spender != address(this));
326 
327     super.decreaseApproval(_spender, _subtractedValue);
328 
329     require(_spender.call(_data));
330 
331     return true;
332   }
333 
334 }
335 
336 contract KRWT is StandardToken, MintableToken, BurnableToken, PausableToken {
337     string constant public name = "Korean Won";
338     string constant public symbol = "KRWT";
339     uint8 constant public decimals = 8;
340     uint256 public totalSupply = 10000000000  * (10 ** uint256(decimals));
341     event Transfer(address indexed from, address indexed to, uint256 value);
342     event Burn(address indexed from, uint256 value);
343     event Pause(address indexed from, uint256 value);
344     event Mint(address indexed to, uint256 amount);
345 
346     function KRWT () public {
347         balances[msg.sender] = totalSupply;
348         Transfer(address(0), msg.sender, totalSupply);
349     }
350 }
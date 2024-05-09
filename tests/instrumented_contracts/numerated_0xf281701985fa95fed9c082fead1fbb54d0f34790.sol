1 // Current version:0.4.26+commit.4563c3fc.Emscripten.clang
2 pragma solidity ^0.4.18;
3 /**
4  * @title Math
5  */
6 library Math {
7   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
8     return a >= b ? a : b;
9   }
10 
11   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
12     return a < b ? a : b;
13   }
14 
15   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a >= b ? a : b;
17   }
18 
19   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
20     return a < b ? a : b;
21   }
22 }
23 
24 /**
25  * @title SafeMath
26  */
27 library SafeMath {
28 
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a / b;
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @title ERC20Basic
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title BasicToken
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99   
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 }
104 
105 /**
106  * @title StandardToken
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   function allowance(address _owner, address _spender) public view returns (uint256) {
131     return allowed[_owner][_spender];
132   }
133 
134   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153 /**
154  * @title Ownable
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) public onlyOwner {
184     require(newOwner != address(0));
185     OwnershipTransferred(owner, newOwner);
186     owner = newOwner;
187   }
188 
189 }
190 
191 /**
192  * @title Pausable
193  */
194 contract Pausable is Ownable {
195   event Pause();
196   event Unpause();
197 
198   bool public paused = false;
199 
200   modifier whenNotPaused() {
201     require(!paused);
202     _;
203   }
204 
205   modifier whenPaused() {
206     require(paused);
207     _;
208   }
209 
210   function pause() onlyOwner whenNotPaused public {
211     paused = true;
212     Pause();
213   }
214 
215   function unpause() onlyOwner whenPaused public {
216     paused = false;
217     Unpause();
218   }
219 }
220 
221 /**
222  * @title Pausable token
223  **/
224 contract PausableToken is StandardToken, Pausable {
225 
226   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
227     return super.transfer(_to, _value);
228   }
229 
230   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
231     return super.transferFrom(_from, _to, _value);
232   }
233 
234   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
235     return super.approve(_spender, _value);
236   }
237 
238   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
239     return super.increaseApproval(_spender, _addedValue);
240   }
241 
242   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
243     return super.decreaseApproval(_spender, _subtractedValue);
244   }
245 }
246 
247 /**
248  * @title Mintable token
249  */
250 contract MintableToken is StandardToken, Ownable {
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256 
257   modifier canMint() {
258     require(!mintingFinished);
259     _;
260   }
261 
262   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
263     totalSupply_ = totalSupply_.add(_amount);
264     balances[_to] = balances[_to].add(_amount);
265     Mint(_to, _amount);
266     Transfer(address(0), _to, _amount);
267     return true;
268   }
269 
270   function finishMinting() onlyOwner canMint public returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 /**
278  * @title Burnable Token
279  */
280 contract BurnableToken is BasicToken {
281 
282   event Burn(address indexed burner, uint256 value);
283 
284   function burn(uint256 _value) public {
285     require(_value <= balances[msg.sender]);
286 
287     address burner = msg.sender;
288     balances[burner] = balances[burner].sub(_value);
289     totalSupply_ = totalSupply_.sub(_value);
290     Burn(burner, _value);
291   }
292 }
293 
294 
295 /**
296  * @title ETUToken
297  */
298 contract MBToken is PausableToken, MintableToken, BurnableToken {
299 
300   // events
301   event Recycling(address indexed from, uint256 value);
302 
303   // token detail
304   string public name;
305   string public symbol;
306   uint256 public decimals;
307 
308   function MBToken(
309     string _name, 
310     string _symbol, 
311     uint256 _decimals,
312     uint256 _initSupply)
313     public
314   {
315     name = _name;
316     symbol = _symbol;
317     decimals = _decimals;
318     owner = msg.sender;
319 
320     totalSupply_ = _initSupply * 10 ** decimals;
321     balances[owner] = totalSupply_;
322   }
323 
324   /** 
325    * use to exchange other token
326    */
327   function recycling(address _from, uint256 _value) onlyOwner public returns(bool) {
328     balances[_from] = balances[_from].sub(_value);
329     totalSupply_ = totalSupply_.sub(_value);
330     Recycling(_from, _value);
331     return true;
332   }
333 }
1 /**
2  * ETU Token
3  * Copyright 2017 Aiesst
4  */
5 
6 pragma solidity ^0.4.18;
7 
8 /**
9  * @title Math
10  */
11 library Math {
12   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
13     return a >= b ? a : b;
14   }
15 
16   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
17     return a < b ? a : b;
18   }
19 
20   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
21     return a >= b ? a : b;
22   }
23 
24   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
25     return a < b ? a : b;
26   }
27 }
28 
29 /**
30  * @title SafeMath
31  */
32 library SafeMath {
33 
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a / b;
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title ERC20Basic
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 /**
71  * @title ERC20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title BasicToken
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104   
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 }
109 
110 /**
111  * @title StandardToken
112  */
113 contract StandardToken is ERC20, BasicToken {
114 
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157 
158 /**
159  * @title Ownable
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167 
168   /**
169    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170    * account.
171    */
172   function Ownable() public {
173     owner = msg.sender;
174   }
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184   /**
185    * @dev Allows the current owner to transfer control of the contract to a newOwner.
186    * @param newOwner The address to transfer ownership to.
187    */
188   function transferOwnership(address newOwner) public onlyOwner {
189     require(newOwner != address(0));
190     OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 
194 }
195 
196 /**
197  * @title Pausable
198  */
199 contract Pausable is Ownable {
200   event Pause();
201   event Unpause();
202 
203   bool public paused = false;
204 
205   modifier whenNotPaused() {
206     require(!paused);
207     _;
208   }
209 
210   modifier whenPaused() {
211     require(paused);
212     _;
213   }
214 
215   function pause() onlyOwner whenNotPaused public {
216     paused = true;
217     Pause();
218   }
219 
220   function unpause() onlyOwner whenPaused public {
221     paused = false;
222     Unpause();
223   }
224 }
225 
226 /**
227  * @title Pausable token
228  **/
229 contract PausableToken is StandardToken, Pausable {
230 
231   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
232     return super.transfer(_to, _value);
233   }
234 
235   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
236     return super.transferFrom(_from, _to, _value);
237   }
238 
239   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
240     return super.approve(_spender, _value);
241   }
242 
243   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
244     return super.increaseApproval(_spender, _addedValue);
245   }
246 
247   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
248     return super.decreaseApproval(_spender, _subtractedValue);
249   }
250 }
251 
252 /**
253  * @title Mintable token
254  */
255 contract MintableToken is StandardToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261 
262   modifier canMint() {
263     require(!mintingFinished);
264     _;
265   }
266 
267   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
268     totalSupply_ = totalSupply_.add(_amount);
269     balances[_to] = balances[_to].add(_amount);
270     Mint(_to, _amount);
271     Transfer(address(0), _to, _amount);
272     return true;
273   }
274 
275   function finishMinting() onlyOwner canMint public returns (bool) {
276     mintingFinished = true;
277     MintFinished();
278     return true;
279   }
280 }
281 
282 /**
283  * @title Burnable Token
284  */
285 contract BurnableToken is BasicToken {
286 
287   event Burn(address indexed burner, uint256 value);
288 
289   function burn(uint256 _value) public {
290     require(_value <= balances[msg.sender]);
291 
292     address burner = msg.sender;
293     balances[burner] = balances[burner].sub(_value);
294     totalSupply_ = totalSupply_.sub(_value);
295     Burn(burner, _value);
296   }
297 }
298 
299 
300 /**
301  * @title ETUToken
302  */
303 contract ETUToken is PausableToken, MintableToken, BurnableToken {
304 
305   // events
306   event Recycling(address indexed from, uint256 value);
307 
308   // token detail
309   string public name;
310   string public symbol;
311   uint256 public decimals;
312 
313   function ETUToken(
314     string _name, 
315     string _symbol, 
316     uint256 _decimals,
317     uint256 _initSupply)
318     public
319   {
320     name = _name;
321     symbol = _symbol;
322     decimals = _decimals;
323     owner = msg.sender;
324 
325     totalSupply_ = _initSupply * 10 ** decimals;
326     balances[owner] = totalSupply_;
327   }
328 
329   /** 
330    * use to exchange other token
331    */
332   function recycling(address _from, uint256 _value) onlyOwner public returns(bool) {
333     balances[_from] = balances[_from].sub(_value);
334     totalSupply_ = totalSupply_.sub(_value);
335     Recycling(_from, _value);
336     return true;
337   }
338 }
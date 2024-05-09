1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 contract Pausable is Ownable {
60   event Pause();
61   event Unpause();
62 
63   bool public paused = false;
64 
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is not paused.
68    */
69   modifier whenNotPaused() {
70     require(!paused);
71     _;
72   }
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is paused.
76    */
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   /**
83    * @dev called by the owner to pause, triggers stopped state
84    */
85   function pause() onlyOwner whenNotPaused public {
86     paused = true;
87     emit Pause();
88   }
89 
90   /**
91    * @dev called by the owner to unpause, returns to normal state
92    */
93   function unpause() onlyOwner whenPaused public {
94     paused = false;
95     emit Unpause();
96   }
97 }
98 
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) public view returns (uint256);
102   function transfer(address to, uint256 value) public returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 contract StandardToken is ERC20 {
115   using SafeMath for uint256;
116   uint256 public txFee;
117   uint256 public burnFee;
118   address public FeeAddress;
119 
120   mapping (address => mapping (address => uint256)) internal allowed;
121 	mapping(address => bool) tokenBlacklist;
122 	event Blacklist(address indexed blackListed, bool value);
123 
124 
125   mapping(address => uint256) balances;
126 
127 
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(tokenBlacklist[msg.sender] == false);
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     uint256 tempValue = _value;
134     if(txFee > 0 && msg.sender != FeeAddress){
135         uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
136         balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
137         emit Transfer(msg.sender, FeeAddress, DenverDeflaionaryDecay);
138         _value =  _value.sub(DenverDeflaionaryDecay); 
139     }
140     
141     if(burnFee > 0 && msg.sender != FeeAddress){
142         uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
143         totalSupply = totalSupply.sub(Burnvalue);
144         emit Transfer(msg.sender, address(0), Burnvalue);
145         _value =  _value.sub(Burnvalue); 
146     }
147     
148     // SafeMath.sub will throw if there is not enough balance.
149     
150     
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156 
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(tokenBlacklist[msg.sender] == false);
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     balances[_from] = balances[_from].sub(_value);
167     uint256 tempValue = _value;
168     if(txFee > 0 && _from != FeeAddress){
169         uint256 DenverDeflaionaryDecay = tempValue.div(uint256(100 / txFee));
170         balances[FeeAddress] = balances[FeeAddress].add(DenverDeflaionaryDecay);
171         emit Transfer(_from, FeeAddress, DenverDeflaionaryDecay);
172         _value =  _value.sub(DenverDeflaionaryDecay); 
173     }
174     
175     if(burnFee > 0 && _from != FeeAddress){
176         uint256 Burnvalue = tempValue.div(uint256(100 / burnFee));
177         totalSupply = totalSupply.sub(Burnvalue);
178         emit Transfer(_from, address(0), Burnvalue);
179         _value =  _value.sub(Burnvalue); 
180     }
181 
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188 
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195 
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200 
201   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217   
218 
219 
220   function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
221 	require(tokenBlacklist[_address] != _isBlackListed);
222 	tokenBlacklist[_address] = _isBlackListed;
223 	emit Blacklist(_address, _isBlackListed);
224 	return true;
225   }
226 
227 
228 
229 }
230 
231 contract PausableToken is StandardToken, Pausable {
232 
233   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transfer(_to, _value);
235   }
236 
237   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
242     return super.approve(_spender, _value);
243   }
244 
245   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
246     return super.increaseApproval(_spender, _addedValue);
247   }
248 
249   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
250     return super.decreaseApproval(_spender, _subtractedValue);
251   }
252   
253   function blackListAddress(address listAddress,  bool isBlackListed) public whenNotPaused onlyOwner  returns (bool success) {
254 	return super._blackList(listAddress, isBlackListed);
255   }
256   
257 }
258 
259 contract CoinToken is PausableToken {
260     string public name;
261     string public symbol;
262     uint public decimals;
263     event Mint(address indexed from, address indexed to, uint256 value);
264     event Burn(address indexed burner, uint256 value);
265 
266 	
267     constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,uint256 _burnFee,address _FeeAddress,address tokenOwner) public {
268         name = _name;
269         symbol = _symbol;
270         decimals = _decimals;
271         totalSupply = _supply * 10**_decimals;
272         balances[tokenOwner] = totalSupply;
273         owner = tokenOwner;
274 	    txFee = _txFee;
275 	    burnFee = _burnFee;
276 	    FeeAddress = _FeeAddress;
277         emit Transfer(address(0), tokenOwner, totalSupply);
278     }
279 	
280 	function burn(uint256 _value) public{
281 		_burn(msg.sender, _value);
282 	}
283 	
284 	function updateFee(uint256 _txFee,uint256 _burnFee,address _FeeAddress) onlyOwner public{
285 	    txFee = _txFee;
286 	    burnFee = _burnFee;
287 	    FeeAddress = _FeeAddress;
288 	}
289 	
290 
291 	function _burn(address _who, uint256 _value) internal {
292 		require(_value <= balances[_who]);
293 		balances[_who] = balances[_who].sub(_value);
294 		totalSupply = totalSupply.sub(_value);
295 		emit Burn(_who, _value);
296 		emit Transfer(_who, address(0), _value);
297 	}
298 
299     function mint(address account, uint256 amount) onlyOwner public {
300 
301         totalSupply = totalSupply.add(amount);
302         balances[account] = balances[account].add(amount);
303         emit Mint(address(0), account, amount);
304         emit Transfer(address(0), account, amount);
305     }
306 
307     
308 }
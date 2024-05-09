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
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 	mapping(address => bool) tokenBlacklist;
119 	event Blacklist(address indexed blackListed, bool value);
120 
121 
122   mapping(address => uint256) balances;
123 
124 
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(tokenBlacklist[msg.sender] == false);
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     emit Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137 
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(tokenBlacklist[msg.sender] == false);
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     emit Transfer(_from, _to, _value);
152     return true;
153   }
154 
155 
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162 
163   function allowance(address _owner, address _spender) public view returns (uint256) {
164     return allowed[_owner][_spender];
165   }
166 
167 
168   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184   
185 
186 
187   function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
188 	require(tokenBlacklist[_address] != _isBlackListed);
189 	tokenBlacklist[_address] = _isBlackListed;
190 	emit Blacklist(_address, _isBlackListed);
191 	return true;
192   }
193 
194 
195 
196 }
197 
198 contract PausableToken is StandardToken, Pausable {
199 
200   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
201     return super.transfer(_to, _value);
202   }
203 
204   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
205     return super.transferFrom(_from, _to, _value);
206   }
207 
208   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
209     return super.approve(_spender, _value);
210   }
211 
212   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
213     return super.increaseApproval(_spender, _addedValue);
214   }
215 
216   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
217     return super.decreaseApproval(_spender, _subtractedValue);
218   }
219   
220   function blackListAddress(address listAddress,  bool isBlackListed) public whenNotPaused onlyOwner  returns (bool success) {
221 	return super._blackList(listAddress, isBlackListed);
222   }
223   
224 }
225 
226 contract CoinToken is PausableToken {
227     string public name;
228     string public symbol;
229     uint public decimals;
230     event Mint(address indexed from, address indexed to, uint256 value);
231     event Burn(address indexed burner, uint256 value);
232 
233 	
234     constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, address tokenOwner) public {
235         name = _name;
236         symbol = _symbol;
237         decimals = _decimals;
238         totalSupply = _supply * 10**_decimals;
239         balances[tokenOwner] = totalSupply;
240         owner = tokenOwner;
241         emit Transfer(address(0), tokenOwner, totalSupply);
242     }
243 	
244 	function burn(uint256 _value) public {
245 		_burn(msg.sender, _value);
246 	}
247 
248 	function _burn(address _who, uint256 _value) internal {
249 		require(_value <= balances[_who]);
250 		balances[_who] = balances[_who].sub(_value);
251 		totalSupply = totalSupply.sub(_value);
252 		emit Burn(_who, _value);
253 		emit Transfer(_who, address(0), _value);
254 	}
255 
256     function mint(address account, uint256 amount) onlyOwner public {
257 
258         totalSupply = totalSupply.add(amount);
259         balances[account] = balances[account].add(amount);
260         emit Mint(address(0), account, amount);
261         emit Transfer(address(0), account, amount);
262     }
263 
264     
265 }
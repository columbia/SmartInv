1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     emit OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 contract Whitelist is Ownable {
53   mapping(address => bool) public whitelist;
54 
55   event WhitelistedAddressAdded(address addr);
56   event WhitelistedAddressRemoved(address addr);
57 
58   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
59     if (!whitelist[addr]) {
60       whitelist[addr] = true;
61       emit WhitelistedAddressAdded(addr);
62       success = true;
63     }
64   }
65 
66   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
67     if (whitelist[addr]) {
68       whitelist[addr] = false;
69       emit WhitelistedAddressRemoved(addr);
70       success = true;
71     }
72   }
73 
74 }
75 
76 contract Freezeable is Whitelist {
77   mapping (address => bool) public frozenAccount;
78   event FrozenFunds(address target, bool frozen);
79 
80   function freezeAccount(address target, bool freeze) onlyOwner public {
81       frozenAccount[target] = freeze;
82       emit FrozenFunds(target, freeze);
83   }
84 }
85 
86 contract Pausable is Freezeable {
87   event Pause();
88   event Unpause();
89 
90   bool public paused = false;
91 
92   modifier whenNotPaused() {
93     require(!paused || whitelist[msg.sender]);
94     _;
95   }
96 
97   modifier whenPaused() {
98     require(paused);
99     _;
100   }
101 
102   function pause() onlyOwner whenNotPaused public {
103     paused = true;
104     emit Pause();
105   }
106 
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 
114 contract ERC20Basic {
115   function totalSupply() public view returns (uint256);
116   function balanceOf(address who) public view returns (uint256);
117   function transfer(address to, uint256 value) public returns (bool);
118   event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 
129 
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 
158 contract StandardToken is ERC20, BasicToken {
159   using SafeMath for uint256;
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195       } else {
196         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197       }
198       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199       return true;
200     }
201   }
202 
203   contract PausableToken is StandardToken, Pausable {
204 
205     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
206       require(!frozenAccount[msg.sender]);
207       require(!frozenAccount[_to]);
208       return super.transfer(_to, _value);
209     }
210 
211     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
212       require(!frozenAccount[_from]);
213       require(!frozenAccount[_to]);
214       return super.transferFrom(_from, _to, _value);
215     }
216 
217     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
218       return super.approve(_spender, _value);
219     }
220 
221     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
222       return super.increaseApproval(_spender, _addedValue);
223     }
224 
225     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
226       return super.decreaseApproval(_spender, _subtractedValue);
227     }
228   }
229 
230   contract BurnableToken is PausableToken {
231 
232     event Burn(address indexed burner, uint256 value);
233 
234     /**
235     * @dev Burns a specific amount of tokens.
236     * @param _value The amount of token to be burned.
237     */
238     function burn(uint256 _value) public {
239       _burn(msg.sender, _value);
240     }
241 
242     function _burn(address _who, uint256 _value) internal {
243       require(_value <= balances[_who]);
244       // no need to require value <= totalSupply, since that would imply the
245       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
246 
247       balances[_who] = balances[_who].sub(_value);
248       totalSupply_ = totalSupply_.sub(_value);
249       emit Burn(_who, _value);
250       emit Transfer(_who, address(0), _value);
251     }
252   }
253 
254 
255 
256   contract KeplerToken is BurnableToken {
257 
258     string public constant name = "Kepler Token";
259     string public constant symbol = "KEP";
260     uint8 public constant decimals = 18;
261 
262     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
263 
264     function KeplerToken() public {
265       totalSupply_ = INITIAL_SUPPLY;
266       balances[msg.sender] = INITIAL_SUPPLY;
267       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
268     }
269 
270   }
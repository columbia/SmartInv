1 pragma solidity ^0.4.18;
2 library SafeMath {
3   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
4     if (_a == 0) {
5       return 0;
6     }
7 
8     uint256 c = _a * _b;
9     require(c / _a == _b);
10 
11     return c;
12   }
13   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     require(_b > 0); // Solidity only automatically asserts when dividing by 0
15     uint256 c = _a / _b;
16     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
17 
18     return c;
19   }
20 
21   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     require(_b <= _a);
23     uint256 c = _a - _b;
24 
25     return c;
26   }
27 
28   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     uint256 c = _a + _b;
30     require(c >= _a);
31 
32     return c;
33   }
34 
35   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b != 0);
37     return a % b;
38   }
39 }
40 contract Ownable {
41     address public owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59     }
60 }
61 
62 /*
63  * @title Pausable
64  * @dev Base contract which allows children to implement an emergency stop mechanism.
65  */
66 contract Pausable is Ownable {
67     event Pause();
68     event Unpause();
69 
70     bool public paused = false;
71     modifier whenNotPaused() {
72         require(!paused);
73         _;
74     }
75 
76     modifier whenPaused() {
77         require(paused);
78         _;
79     }
80 
81     function pause() onlyOwner whenNotPaused public {
82         paused = true;
83         emit Pause();
84     }
85 
86     function unpause() onlyOwner whenPaused public {
87         paused = false;
88         emit Unpause();
89     }
90 }
91 
92 /*
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98     function totalSupply() public view returns (uint256);
99 
100     function balanceOf(address who) public view returns (uint256);
101 
102     function transfer(address to, uint256 value) public returns (bool);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113 
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115 
116     function approve(address spender, uint256 value) public returns (bool);
117 
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 /**
122  * @title ERC223 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/223
124  */
125 contract ERC223 is ERC20 {
126     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
127 
128     function transferFrom(address from, address to, uint256 value, bytes data) public returns (bool ok);
129 
130     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
131 }
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138     using SafeMath for uint256;
139 
140     mapping(address => uint256) balances;
141 
142     uint256 totalSupply_;
143 
144     /**
145     * @dev total number of tokens in existence
146     */
147     function totalSupply() public view returns (uint256) {
148         return totalSupply_;
149     }
150 
151 
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[msg.sender]);
155 
156         // SafeMath.sub will throw if there is not enough balance.
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         emit Transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163 
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168 }
169 
170 contract StandardToken is ERC20, BasicToken {
171 
172     mapping(address => mapping(address => uint256)) allowed;
173 
174 
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179 
180         balances[_from] = balances[_from].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183         emit Transfer(_from, _to, _value);
184         return true;
185     }
186 
187 
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194 
195     function allowance(address _owner, address _spender) public view returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198   }
199 
200 
201 contract BurnableToken is BasicToken, Ownable {
202 
203       event Burn(address indexed burner, uint256 value);
204 
205 
206       function burn(uint256 _value)  public onlyOwner{
207           require(_value <= balances[msg.sender]);
208           // no need to require value <= totalSupply, since that would imply the
209           // sender's balance is greater than the totalSupply, which *should* be an assertion failure
210           address burner = msg.sender;
211           balances[burner] = balances[burner].sub(_value);
212           totalSupply_ = totalSupply_.sub(_value);
213           emit Burn(burner, _value);
214       }
215 }
216 
217 contract FrozenToken is Ownable {
218       mapping(address => bool) public frozenAccount;
219 
220       event FrozenFunds(address target, bool frozen);
221 
222       function freezeAccount(address target, bool freeze) public onlyOwner {
223           frozenAccount[target] = freeze;
224           emit FrozenFunds(target, freeze);
225       }
226 
227       modifier requireNotFrozen(address from){
228           require(!frozenAccount[from]);
229           _;
230       }
231 }
232 
233 
234 contract ERC223Receiver {
235       function tokenFallback(address _from, uint256 _value, bytes _data) public returns (bool ok);
236   }
237 
238 contract Standard223Token is ERC223, StandardToken {
239     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
240         require(super.transfer(_to, _value));
241         if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
242         return true;
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool success) {
246         require(super.transferFrom(_from, _to, _value));
247         if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
248         return true;
249     }
250 
251     function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool success) {
252         ERC223Receiver receiver = ERC223Receiver(_to);
253         return receiver.tokenFallback(_from, _value, _data);
254     }
255 
256     function isContract(address _addr) internal view returns (bool is_contract) {
257         uint256 length;
258         assembly {length := extcodesize(_addr)}
259         return length > 0;
260     }
261 }
262 
263 /**
264  * ERC20 token
265  * DIO
266  */
267 contract DistributedInvestmentOperationPlatformToken is Pausable, BurnableToken, Standard223Token, FrozenToken {
268 
269     string public name;
270     string public symbol;
271     uint256 public decimals;
272 
273 
274     constructor (uint256 _initialSupply, string _name, string _symbol, uint256 _decimals) public {
275         totalSupply_ = _initialSupply;
276         name = _name;
277         symbol = _symbol;
278         decimals = _decimals;
279         balances[msg.sender] = _initialSupply;
280         emit Transfer(0x0, msg.sender, _initialSupply);
281 
282 }
283     function transfer(address _to, uint256 _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_to) returns (bool) {
284         return transfer(_to, _value, new bytes(0));
285     }
286 
287     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_from) requireNotFrozen(_to) returns (bool) {
288         return transferFrom(_from, _to, _value, new bytes(0));
289     }
290 
291     function approve(address _spender, uint256 _value) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_spender) returns (bool) {
292         return super.approve(_spender, _value);
293     }
294 
295     //ERC223
296     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_to) returns (bool success) {
297         return super.transfer(_to, _value, _data);
298     }
299     //ERC223
300     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused requireNotFrozen(msg.sender) requireNotFrozen(_from) requireNotFrozen(_to) returns (bool success) {
301         return super.transferFrom(_from, _to, _value, _data);
302     }
303 }
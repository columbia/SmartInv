1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         require(b <= a);
7         uint256 c = a - b;
8 
9         return c;
10     }
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a);
15 
16         return c;
17     }
18 
19 }
20 
21 contract ERC20Basic {
22     function totalSupply() public view returns (uint256);
23     function balanceOf(address who) public view returns (uint256);
24     function transfer(address to, uint256 value) public returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 contract ERC20 is ERC20Basic {
29     function allowance(address owner, address spender) public view returns (uint256);
30     function transferFrom(address from, address to, uint256 value) public returns (bool);
31     function approve(address spender, uint256 value) public returns (bool);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 contract BasicToken is ERC20Basic {
36 
37     using SafeMath for uint256;
38 
39     mapping(address => uint256) balances;
40 
41     uint256 public totalSupply_;
42 
43     function totalSupply() public view returns (uint256) {
44 
45         return totalSupply_;
46     }
47 
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         require(_to != address(0));
50         require(_value > 0);
51         require(_value <= balances[msg.sender]);
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         emit Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function balanceOf(address _owner) public view returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     function Time_call() public view returns (uint256){
63         return now;
64     }
65 
66 }
67 
68 contract StandardToken is ERC20, BasicToken {
69 
70     mapping (address => mapping (address => uint256)) internal allowed;
71 
72     function approve(address _spender, uint256 _value) public returns (bool) {
73 
74         require(_value==0||allowed[msg.sender][_spender]==0);
75         require(msg.data.length>=(2*32)+4);
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79 
80     }
81 
82     function allowance(address _owner, address _spender) public view returns (uint256) {
83 
84         return allowed[_owner][_spender];
85 
86     }
87 
88     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
89         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
90         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91         return true;
92     }
93 
94     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
95         uint oldValue = allowed[msg.sender][_spender];
96         if (_subtractedValue > oldValue) {
97             allowed[msg.sender][_spender] = 0;
98         } else {
99             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100         }
101         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[_from]);
108         require(_value <= allowed[_from][msg.sender]);
109 
110         balances[_from] = balances[_from].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113         emit Transfer(_from, _to, _value);
114         return true;
115     }
116 
117 }
118 
119 contract Ownable {
120     
121     address public owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     function Ownable() public {
126         owner = msg.sender;
127     }
128 
129     modifier onlyOwner() {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     function transferOwnership(address newOwner) onlyOwner public {
135         require(newOwner != address(0));
136         require(newOwner != owner);
137         emit OwnershipTransferred(owner, newOwner);
138         owner = newOwner;
139     }
140 
141 }
142 
143 contract Pausable is Ownable {
144     event Pause();
145     event Unpause();
146 
147     bool public paused = false;
148 
149     modifier whenNotPaused() {
150         require(!paused);
151         _;
152     }
153 
154     modifier whenPaused() {
155         require(paused);
156         _;
157     }
158 
159     function pause() onlyOwner whenNotPaused public {
160         paused = true;
161         emit Pause();
162     }
163 
164     function unpause() onlyOwner whenPaused public {
165         paused = false;
166         emit Unpause();
167     }
168 }
169 
170 contract PausableToken is StandardToken, Pausable {
171 
172     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
173         return super.transfer(_to, _value);
174     }
175 
176     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
177         return super.transferFrom(_from, _to, _value);
178     }
179 
180     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
181         return super.approve(_spender, _value);
182     }
183 
184     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
185         return super.increaseApproval(_spender, _addedValue);
186     }
187 
188     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
189         return super.decreaseApproval(_spender, _subtractedValue);
190     }
191 }
192 
193 contract BurnableToken is BasicToken, Ownable {
194 
195   event Burn(address indexed burner, uint256 value);
196 
197   function burn(uint256 _value) onlyOwner public {
198     burnAddress(msg.sender, _value);
199   }
200 
201   function burnAddress(address _who, uint256 _value) onlyOwner public {
202     require(_value <= balances[_who]);
203     balances[_who] = balances[_who].sub(_value);
204     totalSupply_ = totalSupply_.sub(_value);
205     emit Burn(_who, _value);
206     emit Transfer(_who, address(0), _value);
207   }
208 
209 }
210 
211 contract MintableToken is StandardToken, Ownable {
212 
213     event Mint(address indexed to, uint256 amount);
214     event MintFinished();
215 
216     function mint(address _to, uint256 _amount) public returns (bool) {
217         require(msg.sender == owner);
218         totalSupply_ = totalSupply_.add(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Mint(_to, _amount);
221         emit Transfer(address(0), _to, _amount);
222         return true;
223     }
224 
225 }
226 
227 contract FreezingToken is PausableToken {
228     struct freeze {
229         uint256 amount;
230         uint256 when;
231     }
232 
233     mapping (address => freeze) freezedTokens;
234     mapping (address => bool) frozen; 
235 
236     function setFrozen(address _target,bool _flag) onlyOwner public {
237         frozen[_target]=_flag;
238         emit FrozenStatus(_target,_flag);
239     }
240 
241     function freezedTokenOf(address _target) public view returns (uint256 amount){
242         freeze storage _freeze = freezedTokens[_target];
243         if(_freeze.when < now) return 0;
244         return _freeze.amount;
245     }
246 
247     function defrostDate(address _target) public view returns (uint256 Date) {
248         freeze storage _freeze = freezedTokens[_target];
249         if(_freeze.when < now) return 0;
250         return _freeze.when;
251     }
252 
253     function freezeTokens(address _target, uint256 _amount, uint256 _when) onlyOwner public {
254         require(msg.sender == owner);
255         freeze storage _freeze = freezedTokens[_target];
256         _freeze.amount = _amount;
257         _freeze.when = _when;
258     }
259 
260     function unFreezeTokens(address _target) onlyOwner public {
261         require(msg.sender == owner);
262         freeze storage _freeze = freezedTokens[_target];
263         _freeze.amount = 0;
264         _freeze.when = 0;
265     }
266 
267     function transferAndFreeze(address _target, uint256 _amount, uint256 _when) external {
268         require(freezedTokenOf(_target) == 0);
269         if(_when > 0){
270             freeze storage _freeze = freezedTokens[_target];
271             _freeze.amount = _amount;
272             _freeze.when = _when;
273         }
274         transfer(_target,_amount);
275     }
276 
277     function transfer(address _to, uint256 _value) public returns (bool) {
278         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
279         require(frozen[msg.sender]==false);
280         return super.transfer(_to,_value);
281     }
282 
283     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
284         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
285         require(frozen[msg.sender]==false);
286         return super.transferFrom( _from,_to,_value);
287     }
288     event FrozenStatus(address _target,bool _flag);
289 }
290 
291 contract DATAM is BurnableToken, FreezingToken, MintableToken {
292 
293     string public constant name = "DATAM";
294     string public constant symbol = "DATAM";
295     uint8 public constant decimals = 18;
296     uint256 public constant INITIAL_SUPPLY = 369369369 * (10 ** uint256(decimals));
297 
298     function DATAM() public {
299         totalSupply_ = INITIAL_SUPPLY;
300         balances[msg.sender] = INITIAL_SUPPLY;
301         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
302     }
303 }
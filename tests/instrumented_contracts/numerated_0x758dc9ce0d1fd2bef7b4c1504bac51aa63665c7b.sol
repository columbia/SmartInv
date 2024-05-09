1 pragma solidity ^0.4.18;
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
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function transferOwnership(address newOwner) public onlyOwner {
41     if (newOwner != address(0)) {
42       owner = newOwner;
43     }
44   }
45 
46 }
47 
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54   modifier whenNotPaused() {
55     require(!paused);
56     _;
57   }
58 
59   modifier whenPaused() {
60     require(paused);
61     _;
62   }
63 
64   function pause() onlyOwner whenNotPaused public {
65     paused = true;
66     emit Pause();
67   }
68 
69   function unpause() onlyOwner whenPaused public {
70     paused = false;
71     emit Unpause();
72   }
73 
74 }
75 
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address who) public view returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) public view returns (uint256);
85   function transferFrom(address from, address to, uint256 value) public returns (bool);
86   function approve(address spender, uint256 value) public returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   function approve(address _spender, uint256 _value) public returns (bool) {
132     allowed[msg.sender][_spender] = _value;
133     emit Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   function allowance(address _owner, address _spender) public view returns (uint256) {
138     return allowed[_owner][_spender];
139   }
140 
141   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 
147   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148     uint oldValue = allowed[msg.sender][_spender];
149     if (_subtractedValue > oldValue) {
150       allowed[msg.sender][_spender] = 0;
151     } else {
152       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153     }
154     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155     return true;
156   }
157 
158 }
159 
160 contract MintableToken is StandardToken, Ownable {
161   event Mint(address indexed to, uint256 amount);
162   event MintFinished();
163 
164   bool public mintingFinished = false;
165 
166 
167   modifier canMint() {
168     require(!mintingFinished);
169     _;
170   }
171 
172   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
173     totalSupply_ = totalSupply_.add(_amount);
174     balances[_to] = balances[_to].add(_amount);
175     emit Mint(_to, _amount);
176     emit Transfer(address(0), _to, _amount);
177     return true;
178   }
179 
180   function finishMinting() onlyOwner canMint public returns (bool) {
181     mintingFinished = true;
182     emit MintFinished();
183     return true;
184   }
185 }
186 
187 contract CappedToken is MintableToken {
188 
189   uint256 public cap;
190 
191   function CappedToken(uint256 _cap) public {
192     require(_cap > 0);
193     cap = _cap;
194   }
195 
196   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
197     require(totalSupply_.add(_amount) <= cap);
198 
199     return super.mint(_to, _amount);
200   }
201 
202 }
203 
204 contract PausableToken is StandardToken, Pausable {
205 
206   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
207     return super.transfer(_to, _value);
208   }
209 
210   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
211     return super.transferFrom(_from, _to, _value);
212   }
213 
214   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
215     return super.approve(_spender, _value);
216   }
217 
218   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
219     return super.increaseApproval(_spender, _addedValue);
220   }
221 
222   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
223     return super.decreaseApproval(_spender, _subtractedValue);
224   }
225 
226 function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
227     uint receiverCount = _receivers.length;
228     uint256 amount = _value.mul(uint256(receiverCount));
229     require(receiverCount > 0);
230     require(_value > 0 && balances[msg.sender] >= amount);
231 
232     balances[msg.sender] = balances[msg.sender].sub(amount);
233     for (uint i = 0; i < receiverCount; i++) {
234         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
235         Transfer(msg.sender, _receivers[i], _value);
236     }
237     return true;
238   }
239 }
240 
241 contract BurnableToken is BasicToken {
242 
243   event Burn(address indexed burner, uint256 value);
244 
245   function burn(uint256 _value) public {
246     require(_value <= balances[msg.sender]);
247     address burner = msg.sender;
248     balances[burner] = balances[burner].sub(_value);
249     totalSupply_ = totalSupply_.sub(_value);
250     emit Burn(burner, _value);
251     emit Transfer(burner, address(0), _value);
252   }
253 }
254 
255 contract HCGY_Token is CappedToken, PausableToken, BurnableToken {
256 
257     string public constant name = "HCGY";
258     string public constant symbol = "HCGY";
259     uint8 public constant decimals = 18;
260 
261     uint256 private constant TOKEN_CAP = 700000000 * (10 ** uint256(decimals));
262     uint256 private constant TOKEN_INITIAL = 700000000 * (10 ** uint256(decimals));
263 
264     function HCGY_Token() public CappedToken(TOKEN_CAP) {
265       totalSupply_ = TOKEN_INITIAL;
266 
267       balances[msg.sender] = TOKEN_INITIAL;
268       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
269 
270       paused = false;
271   }
272 }
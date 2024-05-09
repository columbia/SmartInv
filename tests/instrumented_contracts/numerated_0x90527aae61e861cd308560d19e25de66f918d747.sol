1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   function transferOwnership(address newOwner) public onlyOwner {
24     require(newOwner != address(0));
25     emit OwnershipTransferred(owner, newOwner);
26     owner = newOwner;
27   }
28 
29   function renounceOwnership() public onlyOwner {
30     emit OwnershipRenounced(owner);
31     owner = address(0);
32   }
33 }
34 
35 library SafeMath {
36 
37   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     if (a == 0) {
39       return 0;
40     }
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a / b;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function balanceOf(address _owner) public view returns (uint256) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     emit Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 }
146 
147 contract MintableToken is StandardToken, Ownable {
148   event Mint(address indexed to, uint256 amount);
149   event MintFinished();
150 
151   bool public mintingFinished = false;
152 
153   modifier canMint() {
154     require(!mintingFinished);
155     _;
156   }
157 
158   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
159     totalSupply_ = totalSupply_.add(_amount);
160     balances[_to] = balances[_to].add(_amount);
161     emit Mint(_to, _amount);
162     emit Transfer(address(0), _to, _amount);
163     return true;
164   }
165 
166   function finishMinting() onlyOwner canMint public returns (bool) {
167     mintingFinished = true;
168     emit MintFinished();
169     return true;
170   }
171 }
172 
173 contract CappedToken is MintableToken {
174 
175   uint256 public cap;
176 
177   constructor(uint256 _cap) public {
178     require(_cap > 0);
179     cap = _cap;
180   }
181 
182   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
183     require(totalSupply_.add(_amount) <= cap);
184     return super.mint(_to, _amount);
185   }
186 }
187 
188 contract Pausable is Ownable {
189   event Pause();
190   event Unpause();
191 
192   bool public paused = false;
193 
194   modifier whenNotPaused() {
195     require(!paused);
196     _;
197   }
198 
199   modifier whenPaused() {
200     require(paused);
201     _;
202   }
203 
204   function pause() onlyOwner whenNotPaused public {
205     paused = true;
206     emit Pause();
207   }
208 
209   function unpause() onlyOwner whenPaused public {
210     paused = false;
211     emit Unpause();
212   }
213 }
214 
215 contract PausableToken is StandardToken, Pausable {
216 
217   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
218     return super.transfer(_to, _value);
219   }
220 
221   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
222     return super.transferFrom(_from, _to, _value);
223   }
224 
225   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
226     return super.approve(_spender, _value);
227   }
228 
229   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
230     return super.increaseApproval(_spender, _addedValue);
231   }
232 
233   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
234     return super.decreaseApproval(_spender, _subtractedValue);
235   }
236 }
237 
238 contract XPUBToken is CappedToken, PausableToken {
239     string public constant name = "X PUBLIC FUND"; 
240     string public constant symbol = "XPUB"; 
241     uint8 public constant decimals = 18; 
242 
243     uint256 public constant INITIAL_SUPPLY = 0;
244     uint256 public constant MAX_SUPPLY = 30 * 10000 * 10000 * (10 ** uint256(decimals));
245 
246     constructor() CappedToken(MAX_SUPPLY) public {
247         totalSupply_ = INITIAL_SUPPLY;
248         balances[msg.sender] = INITIAL_SUPPLY;
249         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
250     }
251 
252     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
253         return super.mint(_to, _amount);
254     }
255 
256     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
257         return super.finishMinting();
258     }
259 
260     function transferOwnership(address newOwner) onlyOwner whenNotPaused public {
261         super.transferOwnership(newOwner);
262     }
263 
264     function() payable public {
265         revert();
266     }
267 }
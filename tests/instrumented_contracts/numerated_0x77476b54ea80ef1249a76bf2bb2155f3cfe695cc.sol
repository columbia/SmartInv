1 pragma solidity 0.4.20;
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
38 
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51 
52 
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 
62 
63 
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77 
78   function transfer(address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[msg.sender]);
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89 
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
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
124  
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130   
131  
132   function allowance(address _owner, address _spender) public view returns (uint256) {
133     return allowed[_owner][_spender];
134   }
135 
136  
137   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154 }
155 
156 contract BurnableToken is StandardToken {
157 
158     event Burn(address indexed burner, uint256 value);
159 
160    
161     function burn(uint256 _value) public {
162         require(_value > 0);
163         require(_value <= balances[msg.sender]);
164         // no need to require value <= totalSupply, since that would imply the
165         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
166 
167         address burner = msg.sender;
168         balances[burner] = balances[burner].sub(_value);
169         totalSupply = totalSupply.sub(_value);
170         Burn(burner, _value);
171     }
172 }
173 
174 
175 contract MintableToken is StandardToken, Ownable {
176   event Mint(address indexed to, uint256 amount);
177   event MintFinished();
178 
179   bool public mintingFinished = false;
180 
181 
182   modifier canMint() {
183     require(!mintingFinished);
184     _;
185   }
186 
187 
188   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
189     totalSupply = totalSupply.add(_amount);
190     balances[_to] = balances[_to].add(_amount);
191     Mint(_to, _amount);
192     Transfer(address(0), _to, _amount);
193     return true;
194   }
195 
196   
197   function finishMinting() onlyOwner canMint public returns (bool) {
198     mintingFinished = true;
199     MintFinished();
200     return true;
201   }
202 }
203 
204 
205  
206 contract Pausable is Ownable {
207   event Pause();
208   event Unpause();
209 
210   bool public paused = false;
211 
212 
213 
214   modifier whenNotPaused() {
215     require(!paused);
216     _;
217   }
218 
219 
220   modifier whenPaused() {
221     require(paused);
222     _;
223   }
224 
225 
226   function pause() onlyOwner whenNotPaused public {
227     paused = true;
228     Pause();
229   }
230 
231 
232   function unpause() onlyOwner whenPaused public {
233     paused = false;
234     Unpause();
235   }
236 }
237 
238 
239 
240 contract PausableToken is StandardToken, Pausable {
241 
242   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
243     return super.transfer(_to, _value);
244   }
245 
246   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
247     return super.transferFrom(_from, _to, _value);
248   }
249 
250   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
251     return super.approve(_spender, _value);
252   }
253 
254   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
255     return super.increaseApproval(_spender, _addedValue);
256   }
257 
258   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
259     return super.decreaseApproval(_spender, _subtractedValue);
260   }
261 }
262 
263 /**
264    * @author PilarCoin
265    */
266 
267 contract PilarCoin is PausableToken, MintableToken, BurnableToken {
268     string public constant name = "PilarCoin";
269     string public constant symbol = "PILAR";
270     uint8 public constant decimals = 2;
271 }
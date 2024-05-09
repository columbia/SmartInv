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
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is not paused.
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is paused.
80    */
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused public {
90     paused = true;
91     Pause();
92   }
93 
94   /**
95    * @dev called by the owner to unpause, returns to normal state
96    */
97   function unpause() onlyOwner whenPaused public {
98     paused = false;
99     Unpause();
100   }
101 }
102 
103 contract ERC20Basic {
104   uint256 public totalSupply;
105   string public name;
106   string public symbol;
107   uint public decimals;
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     Approval(msg.sender, _spender, _value);
159     return true;
160   }
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 }
181 
182 contract PausableToken is StandardToken, Pausable {
183 
184   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
185     return super.transfer(_to, _value);
186   }
187 
188   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
189     return super.transferFrom(_from, _to, _value);
190   }
191 
192   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
193     return super.approve(_spender, _value);
194   }
195 
196   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
197     return super.increaseApproval(_spender, _addedValue);
198   }
199 
200   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
201     return super.decreaseApproval(_spender, _subtractedValue);
202   }
203 
204 
205   function setname(string _name) onlyOwner public whenNotPaused returns (bool){
206      name = _name;
207      return true;
208   }
209 
210   function setsymbol(string _symbol) onlyOwner public whenNotPaused returns (bool){
211      symbol = _symbol;
212      return true;
213   }
214 
215   function setdecimals(uint _decimals) onlyOwner public whenNotPaused returns (bool){
216      decimals = _decimals;
217      return true;
218   }
219 
220   function mintToken(address target, uint256 _value) onlyOwner public whenNotPaused returns (bool){
221     require(target != address(0));
222     balances[target] = balances[target].add(_value);
223     totalSupply = totalSupply.add(_value);
224     Transfer(0 , owner , _value);
225     Transfer(owner , target , _value);
226     return true;
227   }
228 }
229 
230 contract USDYToken is PausableToken {
231     uint public INITIAL_SUPPLY = 1500000000000;
232 
233     function USDYToken() public {
234         name = "yether";
235         symbol = "USDY";
236         decimals = 2;
237         totalSupply = INITIAL_SUPPLY;
238         balances[msg.sender] = INITIAL_SUPPLY;
239     }
240 }
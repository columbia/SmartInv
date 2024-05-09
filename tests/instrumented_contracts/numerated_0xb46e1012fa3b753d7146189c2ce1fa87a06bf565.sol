1 /**
2  * Toponet Token
3  * 
4  * copyright ©️ 2018 toponet.io
5  */
6 
7 pragma solidity ^0.4.18;
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title Ownable
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   constructor () public {
49     owner = msg.sender;
50   }
51 
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 }
63 
64 /**
65  * @title Pausable
66  */
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82 
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   function unpause() onlyOwner whenPaused public {
89     paused = false;
90     emit Unpause();
91   }
92 }
93 
94 /**
95  * @title ERC20Basic
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 /**
105  * @title ERC20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title BasicToken
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138   
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 }
143 
144 /**
145  * @title StandardToken
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 }
190 
191 /**
192  * @title Pausable token
193  **/
194 contract PausableToken is StandardToken, Pausable {
195 
196   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
197     return super.transfer(_to, _value);
198   }
199 
200   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
201     return super.transferFrom(_from, _to, _value);
202   }
203 
204   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
205     return super.approve(_spender, _value);
206   }
207 
208   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
209     return super.increaseApproval(_spender, _addedValue);
210   }
211 
212   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
213     return super.decreaseApproval(_spender, _subtractedValue);
214   }
215 }
216 
217 /**
218  * @title Toponet token 
219  */
220 contract ToponetToken is PausableToken {
221 
222   // token detail
223   string public name;
224   string public symbol;
225   uint256 public decimals;
226 
227   constructor (
228     string _name, 
229     string _symbol, 
230     uint256 _decimals,
231     uint256 _initSupply)
232     public
233   {
234     name = _name;
235     symbol = _symbol;
236     decimals = _decimals;
237     owner = msg.sender;
238 
239     totalSupply_ = _initSupply * 10 ** decimals;
240     balances[owner] = totalSupply_;
241   }
242 }
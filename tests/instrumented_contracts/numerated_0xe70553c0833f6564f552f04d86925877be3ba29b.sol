1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5       if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22 
23         return c;
24     }
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28 
29         return c;
30     }
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract IERC20Token {
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 }
41 
42 contract ERC20Basic {
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 contract Ownable {
50   address public owner;
51 
52   event transferOwner(address indexed existingOwner, address indexed newOwner);
53 
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function transferOwnership(address newOwner) onlyOwner public {
64     if (newOwner != address(0)) {
65       owner = newOwner;
66       emit transferOwner(msg.sender, owner);
67     }
68   }
69 }
70 
71 contract ERC20 is ERC20Basic, IERC20Token {
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_value > 0);
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   function balanceOf(address _owner) public view returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 contract StandardToken is ERC20, BasicToken {
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_value > 0);
106     require(_to != address(0));
107     require(_value <= balances[_from]);
108     require(_value <= allowed[_from][msg.sender]);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113     emit Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   function approve(address _spender, uint256 _value) public returns (bool) {
118     require(_value > 0);
119     allowed[msg.sender][_spender] = _value;
120     emit Approval(msg.sender, _spender, _value);
121     return true;
122   }
123 
124   function allowance(address _owner, address _spender) public view returns (uint256) {
125     return allowed[_owner][_spender];
126   }
127 
128    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129     require(_addedValue > 0);
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136     require(_subtractedValue > 0);
137     uint oldValue = allowed[msg.sender][_spender];
138     if (_subtractedValue > oldValue) {
139       allowed[msg.sender][_spender] = 0;
140     } else {
141       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142     }
143     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 
147 }
148 
149 contract Pausable is Ownable {
150   event Pause();
151   event Unpause();
152 
153   bool public paused = false;
154   
155   modifier whenNotPaused() {
156     require(!paused);
157     _;
158   }
159 
160 
161   modifier whenPaused() {
162     require(paused);
163     _;
164   }
165 
166 
167   function pause() onlyOwner whenNotPaused public {
168     paused = true;
169     emit Pause();
170   }
171 
172 
173   function unpause() onlyOwner whenPaused public {
174     paused = false;
175     emit Unpause();
176   }
177 }
178 
179 contract PausableToken is StandardToken, Pausable {
180 
181   function transfer(
182     address _to,
183     uint256 _value
184   )
185     public
186     whenNotPaused
187     returns (bool)
188   {
189     return super.transfer(_to, _value);
190   }
191 
192   function transferFrom(
193     address _from,
194     address _to,
195     uint256 _value
196   )
197     public
198     whenNotPaused
199     returns (bool)
200   {
201     return super.transferFrom(_from, _to, _value);
202   }
203 
204   function approve(
205     address _spender,
206     uint256 _value
207   )
208     public
209     whenNotPaused
210     returns (bool)
211   {
212     return super.approve(_spender, _value);
213   }
214 
215   function increaseApproval(
216     address _spender,
217     uint _addedValue
218   )
219     public
220     whenNotPaused
221     returns (bool success)
222   {
223     return super.increaseApproval(_spender, _addedValue);
224   }
225 
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     whenNotPaused
232     returns (bool success)
233   {
234     return super.decreaseApproval(_spender, _subtractedValue);
235   }
236 }
237 
238 contract SKeys is PausableToken {
239 string public constant name = "Sustainy Keys";
240 string public constant symbol = "SKEYS";
241 uint256 public totalSupply;
242 uint256 public constant INITIAL_SUPPLY = 21000000;
243 
244 constructor(address reserve) public {
245   totalSupply = INITIAL_SUPPLY;
246   balances[reserve] = INITIAL_SUPPLY;
247   emit Transfer(0x0, reserve, INITIAL_SUPPLY);
248 }
249 
250 }
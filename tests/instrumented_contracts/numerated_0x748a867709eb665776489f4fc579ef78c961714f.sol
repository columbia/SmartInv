1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * SafeMath
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * ERC20Basic
37  */
38 contract ERC20Basic {
39   function totalSupply() public view returns (uint256);
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   function balanceOf(address _owner) public view returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 
76 /**
77  * Token that can be irreversibly burned (destroyed).
78  */
79 contract BurnableToken is BasicToken {
80 
81   event Burn(address indexed burner, uint256 value);
82 
83   function burn(uint256 _value) public {
84     require(_value <= balances[msg.sender]);
85 
86     address burner = msg.sender;
87     balances[burner] = balances[burner].sub(_value);
88     totalSupply_ = totalSupply_.sub(_value);
89     Burn(burner, _value);
90     Transfer(burner, address(0), _value);
91   }
92 }
93 
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[_from]);
109     require(_value <= allowed[_from][msg.sender]);
110 
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   function approve(address _spender, uint256 _value) public returns (bool) {
119     allowed[msg.sender][_spender] = _value;
120     Approval(msg.sender, _spender, _value);
121     return true;
122   }
123 
124   function allowance(address _owner, address _spender) public view returns (uint256) {
125     return allowed[_owner][_spender];
126   }
127 
128   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
135     uint oldValue = allowed[msg.sender][_spender];
136     if (_subtractedValue > oldValue) {
137       allowed[msg.sender][_spender] = 0;
138     } else {
139       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
140     }
141     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144 
145 }
146 
147 contract Ownable {
148   address public owner;
149 
150 
151   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153 
154   function Ownable() public {
155     owner = msg.sender;
156   }
157 
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162 
163   function transferOwnership(address newOwner) public onlyOwner {
164     require(newOwner != address(0));
165     OwnershipTransferred(owner, newOwner);
166     owner = newOwner;
167   }
168 
169 }
170 
171 contract Pausable is Ownable {
172   event Pause();
173   event Unpause();
174 
175   bool public paused = false;
176 
177 
178   modifier whenNotPaused() {
179     require(!paused);
180     _;
181   }
182 
183   modifier whenPaused() {
184     require(paused);
185     _;
186   }
187 
188   function pause() onlyOwner whenNotPaused public {
189     paused = true;
190     Pause();
191   }
192 
193   function unpause() onlyOwner whenPaused public {
194     paused = false;
195     Unpause();
196   }
197 }
198 
199 contract PausableToken is StandardToken, Pausable {
200 
201   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
202     return super.transfer(_to, _value);
203   }
204 
205   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
206     return super.transferFrom(_from, _to, _value);
207   }
208 
209   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
210     return super.approve(_spender, _value);
211   }
212 
213   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
214     return super.increaseApproval(_spender, _addedValue);
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
218     return super.decreaseApproval(_spender, _subtractedValue);
219   }
220 }
221 
222 /**
223  * Cocobit Token contract
224  */
225 contract CocobitToken is PausableToken, BurnableToken {
226   string public name;
227   string public symbol;
228   uint public decimals = 18;
229 
230 
231   function CocobitToken() public {
232     name = "Cocobit";
233     symbol = "COCO";
234     totalSupply_ = 10000000000 * 10 ** 18;
235     balances[msg.sender] = totalSupply_;
236   }
237 }
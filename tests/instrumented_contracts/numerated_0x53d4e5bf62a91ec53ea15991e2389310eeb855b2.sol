1 pragma solidity ^0.4.24;
2 
3 
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11 
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32 }
33 
34 
35 
36 contract ERC20Basic {
37 
38   function totalSupply() public view returns (uint256);
39 
40   function balanceOf(address who) public view returns (uint256);
41 
42   function transfer(address to, uint256 value) public returns (bool);
43 
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 
46 }
47 
48 
49 
50 contract ERC20 is ERC20Basic {
51 
52   function allowance(address owner, address spender)
53     public view returns (uint256);
54 
55   function transferFrom(address from, address to, uint256 value)
56     public returns (bool);
57 
58   function approve(address spender, uint256 value) public returns (bool);
59 
60   event Approval(
61     address indexed owner,
62     address indexed spender,
63     uint256 value
64   );
65 
66 }
67 
68 
69 
70 contract Ownable {
71 
72   address public owner;
73 
74   event OwnershipRenounced(address indexed previousOwner);
75 
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   modifier validAddress {
91     assert(0x0 != msg.sender);
92     _;
93   }
94 
95   function transferOwnership(address _newOwner) public onlyOwner validAddress {
96     _transferOwnership(_newOwner);
97   }
98 
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 
105 }
106 
107 
108 
109 contract BasicToken is ERC20Basic, Ownable {
110 
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124     require(_value > 0);
125 
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     emit Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136   event Burn(address indexed burner, uint256 value);
137 
138   function burn(uint256 _value) public {
139     _burn(msg.sender, _value);
140   }
141 
142   function _burn(address _who, uint256 _value) internal {
143     require(_value <= balances[_who]);
144 
145     balances[_who] = balances[_who].sub(_value);
146     totalSupply_ = totalSupply_.sub(_value);
147 
148     emit Burn(_who, _value);
149     emit Transfer(_who, address(0), _value);
150   }
151 
152 }
153 
154 
155 
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public validAddress
166     returns (bool)
167   {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171     require(_value > 0);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176     emit Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   function approve(address _spender, uint256 _value) public validAddress returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     emit Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   function increaseApproval(
198     address _spender,
199     uint256 _addedValue
200   )
201     public validAddress
202     returns (bool)
203   {
204     allowed[msg.sender][_spender] = (
205       allowed[msg.sender][_spender].add(_addedValue));
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   function transferTokens(address _from, address _to, uint256 _value) public validAddress onlyOwner returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value > 0);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   function decreaseApproval(
222     address _spender,
223     uint256 _subtractedValue
224   )
225     public validAddress
226     returns (bool)
227   {
228     uint256 oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 
241 
242 contract GOEXToken is StandardToken {
243 
244   string public constant name = "GOEX Token";
245   string public constant symbol = "GOEX";
246   uint8 public constant decimals = 18;
247 
248   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
249 
250   constructor() public {
251     totalSupply_ = INITIAL_SUPPLY;
252     balances[msg.sender] = INITIAL_SUPPLY;
253     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
254   }
255 
256 }
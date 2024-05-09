1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27  
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56  
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_value <= balances[msg.sender]);
64     require(_to != address(0));
65 
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     emit Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   
73   function balanceOf(address _owner) public view returns (uint256) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender)
81     public view returns (uint256);
82 
83   function transferFrom(address from, address to, uint256 value)
84     public returns (bool);
85 
86   function approve(address spender, uint256 value) public returns (bool);
87   event Approval(
88     address indexed owner,
89     address indexed spender,
90     uint256 value
91   );
92 }
93 
94 
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) internal allowed;
99 
100 
101   function transferFrom(
102     address _from,
103     address _to,
104     uint256 _value
105   )
106     public
107     returns (bool)
108   {
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111     require(_to != address(0));
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120  
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     emit Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   
128   function allowance(
129     address _owner,
130     address _spender
131    )
132     public
133     view
134     returns (uint256)
135   {
136     return allowed[_owner][_spender];
137   }
138 
139   
140   function increaseApproval(
141     address _spender,
142     uint256 _addedValue
143   )
144     public
145     returns (bool)
146   {
147     allowed[msg.sender][_spender] = (
148       allowed[msg.sender][_spender].add(_addedValue));
149     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153   
154   function decreaseApproval(
155     address _spender,
156     uint256 _subtractedValue
157   )
158     public
159     returns (bool)
160   {
161     uint256 oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue >= oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 
174 contract Ownable {
175   address public owner;
176 
177 
178   event OwnershipRenounced(address indexed previousOwner);
179   event OwnershipTransferred(
180     address indexed previousOwner,
181     address indexed newOwner
182   );
183 
184 
185   constructor() public {
186     owner = msg.sender;
187   }
188 
189 
190   modifier onlyOwner() {
191     require(msg.sender == owner);
192     _;
193   }
194 
195   
196   function renounceOwnership() public onlyOwner {
197     emit OwnershipRenounced(owner);
198     owner = address(0);
199   }
200 
201  
202   function transferOwnership(address _newOwner) public onlyOwner {
203     _transferOwnership(_newOwner);
204   }
205 
206   
207   function _transferOwnership(address _newOwner) internal {
208     require(_newOwner != address(0));
209     emit OwnershipTransferred(owner, _newOwner);
210     owner = _newOwner;
211   }
212 }
213 
214 
215 contract GujjuDigital is StandardToken {
216 
217   string public constant name = "GujjuDigitalCurrency"; // solium-disable-line uppercase
218   string public constant symbol = "GDC"; // solium-disable-line uppercase
219   uint8 public constant decimals = 18; // solium-disable-line uppercase
220 
221   uint256 public constant INITIAL_SUPPLY = 210000000000 * (10 ** uint256(decimals));
222 
223   
224   constructor() public {
225     totalSupply_ = INITIAL_SUPPLY;
226     balances[msg.sender] = INITIAL_SUPPLY;
227     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
228   }
229 
230 }
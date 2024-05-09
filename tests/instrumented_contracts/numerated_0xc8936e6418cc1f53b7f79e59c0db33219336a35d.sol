1 contract ERC20Basic {
2   function totalSupply() public view returns (uint256);
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     if (a == 0) {
12       return 0;
13     }
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   uint256 totalSupply_;
44 
45   function totalSupply() public view returns (uint256) {
46     return totalSupply_;
47   }
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) internal allowed;
75 
76   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[_from]);
79     require(_value <= allowed[_from][msg.sender]);
80 
81     balances[_from] = balances[_from].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84     emit Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     emit Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 }
115 
116 contract Ownable {
117   address public owner;
118 
119   event OwnershipRenounced(address indexed previousOwner);
120   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122   function Ownable() public {
123     owner = msg.sender;
124   }
125 
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131   function transferOwnership(address newOwner) public onlyOwner {
132     require(newOwner != address(0));
133     emit OwnershipTransferred(owner, newOwner);
134     owner = newOwner;
135   }
136 
137   function renounceOwnership() public onlyOwner {
138     emit OwnershipRenounced(owner);
139     owner = address(0);
140   }
141 }
142 
143 contract MintableToken is StandardToken, Ownable {
144   event Mint(address indexed to, uint256 amount);
145   event MintFinished();
146 
147   bool public mintingFinished = false;
148 
149   modifier canMint() {
150     require(!mintingFinished);
151     _;
152   }
153 
154   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
155     totalSupply_ = totalSupply_.add(_amount);
156     balances[_to] = balances[_to].add(_amount);
157     emit Mint(_to, _amount);
158     emit Transfer(address(0), _to, _amount);
159     return true;
160   }
161 
162   function finishMinting() onlyOwner canMint public returns (bool) {
163     mintingFinished = true;
164     emit MintFinished();
165     return true;
166   }
167 }
168 
169 contract CappedToken is MintableToken {
170 
171   uint256 public cap;
172 
173   function CappedToken(uint256 _cap) public {
174     require(_cap > 0);
175     cap = _cap;
176   }
177 
178   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
179     require(totalSupply_.add(_amount) <= cap);
180 
181     return super.mint(_to, _amount);
182   }
183 
184 }
185 
186 contract QwidsCrowdsaleToken is MintableToken {
187 
188   string public constant name = "Q"; // solium-disable-line uppercase
189   string public constant symbol = "QWIDS"; // solium-disable-line uppercase
190   uint8 public constant decimals = 18; // solium-disable-line uppercase
191 
192   uint256 initialSupply = 90000000 ether;
193 
194   constructor() MintableToken {
195     address _owner = 0x8f1c3988df10a2fb801cbd61e09d164887dbb19b;
196     balances[_owner] = initialSupply;
197     totalSupply_ = initialSupply;
198     transferOwnership(_owner);
199   }
200 }
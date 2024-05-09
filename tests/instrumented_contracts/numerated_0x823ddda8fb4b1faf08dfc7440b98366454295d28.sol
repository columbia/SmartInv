1 pragma solidity ^0.4.25;
2 
3 contract ERC20Base {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Base {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   function kill() public onlyOwner { 
38       if (msg.sender == owner) selfdestruct(owner); 
39       
40   }
41   
42 }
43 
44 library SafeMath {
45 
46   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     if (a == 0) {
48       return 0;
49     }
50 
51     c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     return a / b;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 contract Basic is ERC20Base {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function balanceOf(address _owner) public view returns (uint256) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract StandardToken is ERC20, Basic {
99   mapping (address => mapping (address => uint256)) internal allowed;
100   function transferFrom(
101     address _from,
102     address _to,
103     uint256 _value
104   )
105     public
106     returns (bool)
107   {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111     balances[_from] = balances[_from].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114     emit Transfer(_from, _to, _value);
115     return true;
116   }
117   function approve(address _spender, uint256 _value) public returns (bool) {
118     allowed[msg.sender][_spender] = _value;
119     emit Approval(msg.sender, _spender, _value);
120     return true;
121   }
122   function allowance(
123     address _owner,
124     address _spender
125    )
126     public
127     view
128     returns (uint256)
129   {
130     return allowed[_owner][_spender];
131   }
132   function increaseApproval(
133     address _spender,
134     uint256 _addedValue
135   )
136     public
137     returns (bool)
138   {
139     allowed[msg.sender][_spender] = (
140       allowed[msg.sender][_spender].add(_addedValue));
141     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142     return true;
143   }
144   function decreaseApproval(
145     address _spender,
146     uint256 _subtractedValue
147   )
148     public
149     returns (bool)
150   {
151     uint256 oldValue = allowed[msg.sender][_spender];
152     if (_subtractedValue > oldValue) {
153       allowed[msg.sender][_spender] = 0;
154     } else {
155       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156     }
157     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 }
161 
162 contract Burnable is StandardToken {
163 
164   event Burn(address indexed burner, uint256 value);
165 
166   function burn(uint256 _value) public {
167     _burn(msg.sender, _value);
168   }
169 
170   function _burn(address _who, uint256 _value) internal {
171     require(_value <= balances[_who]);
172     balances[_who] = balances[_who].sub(_value);
173     totalSupply_ = totalSupply_.sub(_value);
174     emit Burn(_who, _value);
175     emit Transfer(_who, address(0), _value);
176   }
177 }
178 
179 contract Createable is StandardToken, Ownable {
180 
181   event Create(address indexed to, uint256 amount);
182 
183   modifier hasCreatePermission() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   function CreateNew(
189     address _to,
190     uint256 _amount
191   )
192     hasCreatePermission
193     public
194     returns (bool)
195   {
196     totalSupply_ = totalSupply_.add(_amount);
197     balances[_to] = balances[_to].add(_amount);
198     emit Create(_to, _amount);
199     emit Transfer(address(0), _to, _amount);
200     return true;
201   }
202 
203 }
204 
205 contract GGAToken is Createable, Burnable {
206   string public name = "GGA Gold";
207   string public symbol = "GGAG";
208   uint8 public decimals = 0;
209 }
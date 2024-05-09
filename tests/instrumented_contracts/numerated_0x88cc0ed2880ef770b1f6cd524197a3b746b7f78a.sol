1 pragma solidity ^0.4.24;
2 
3 // Start BRT2 Token Code
4 
5 contract ERC20Foundation {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract ERC20 is ERC20Foundation {
13   function allowance(address owner, address spender)
14     public view returns (uint256);
15 
16   function transferFrom(address from, address to, uint256 value)
17     public returns (bool);
18 
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(
21     address indexed owner,
22     address indexed spender,
23     uint256 value
24   );
25 }
26 
27 contract HasOwner {
28   address public owner;
29 
30   constructor() public {
31     owner = msg.sender;
32   }
33 
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38   
39   function kill() public onlyOwner { 
40       if (msg.sender == owner) selfdestruct(owner); 
41       
42   }
43 }
44 
45 library SafeMath {
46 
47   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     if (a == 0) {
49       return 0;
50     }
51 
52     c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a / b;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 contract Basic is ERC20Foundation {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 contract StandardToken is ERC20, Basic {
100   mapping (address => mapping (address => uint256)) internal allowed;
101   function transferFrom(
102     address _from,
103     address _to,
104     uint256 _value
105   )
106     public
107     returns (bool)
108   {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118   function approve(address _spender, uint256 _value) public returns (bool) {
119     allowed[msg.sender][_spender] = _value;
120     emit Approval(msg.sender, _spender, _value);
121     return true;
122   }
123   function allowance(
124     address _owner,
125     address _spender
126    )
127     public
128     view
129     returns (uint256)
130   {
131     return allowed[_owner][_spender];
132   }
133   function increaseApproval(
134     address _spender,
135     uint256 _addedValue
136   )
137     public
138     returns (bool)
139   {
140     allowed[msg.sender][_spender] = (
141       allowed[msg.sender][_spender].add(_addedValue));
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145   function decreaseApproval(
146     address _spender,
147     uint256 _subtractedValue
148   )
149     public
150     returns (bool)
151   {
152     uint256 oldValue = allowed[msg.sender][_spender];
153     if (_subtractedValue > oldValue) {
154       allowed[msg.sender][_spender] = 0;
155     } else {
156       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157     }
158     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 }
162 
163 contract Burnable is StandardToken {
164 
165   event Burn(address indexed burner, uint256 value);
166 
167   function burn(uint256 _value) public {
168     _burn(msg.sender, _value);
169   }
170 
171   function _burn(address _who, uint256 _value) internal {
172     require(_value <= balances[_who]);
173     balances[_who] = balances[_who].sub(_value);
174     totalSupply_ = totalSupply_.sub(_value);
175     emit Burn(_who, _value);
176     emit Transfer(_who, address(0), _value);
177   }
178 }
179 
180 contract Mintable is StandardToken, HasOwner {
181 
182   event Mint(address indexed to, uint256 amount);
183 
184   modifier hasMinePermission() {
185     require(msg.sender == owner);
186     _;
187   }
188 
189   function mint(
190     address _to,
191     uint256 _amount
192   )
193     hasMinePermission
194     public
195     returns (bool)
196   {
197     totalSupply_ = totalSupply_.add(_amount);
198     balances[_to] = balances[_to].add(_amount);
199     emit Mint(_to, _amount);
200     emit Transfer(address(0), _to, _amount);
201     return true;
202   }
203 
204 }
205 
206 contract BRT2Token is Mintable {
207   string public name = "BRT2 Token";
208   string public symbol = "BRT2";
209   uint8 public decimals = 0;
210 }
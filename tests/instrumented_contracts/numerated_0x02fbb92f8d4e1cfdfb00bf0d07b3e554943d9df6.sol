1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8 
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender)
39     public view returns (uint256);
40 
41   function transferFrom(address from, address to, uint256 value)
42     public returns (bool);
43 
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(
46     address indexed owner,
47     address indexed spender,
48     uint256 value
49   );
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     emit Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function balanceOf(address _owner) public view returns (uint256) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract BurnableToken is BasicToken {
80 
81   event Burn(address indexed burner, uint256 value);
82 
83   function burn(uint256 _value) public {
84     _burn(msg.sender, _value);
85   }
86 
87   function _burn(address _who, uint256 _value) internal {
88     require(_value <= balances[_who]);
89 
90     balances[_who] = balances[_who].sub(_value);
91     totalSupply_ = totalSupply_.sub(_value);
92     emit Burn(_who, _value);
93     emit Transfer(_who, address(0), _value);
94   }
95 }
96 
97 
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102   function transferFrom(
103     address _from,
104     address _to,
105     uint256 _value
106   )
107     public
108     returns (bool)
109   {
110     require(_to != address(0));
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = balances[_from].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     emit Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     emit Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   function allowance(
128     address _owner,
129     address _spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return allowed[_owner][_spender];
136   }
137 
138   function increaseApproval(
139     address _spender,
140     uint256 _addedValue
141   )
142     public
143     returns (bool)
144   {
145     allowed[msg.sender][_spender] = (
146       allowed[msg.sender][_spender].add(_addedValue));
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   function decreaseApproval(
152     address _spender,
153     uint256 _subtractedValue
154   )
155     public
156     returns (bool)
157   {
158     uint256 oldValue = allowed[msg.sender][_spender];
159     if (_subtractedValue > oldValue) {
160       allowed[msg.sender][_spender] = 0;
161     } else {
162       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163     }
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168 }
169 
170 contract StandardBurnableToken is BurnableToken, StandardToken {
171 
172   function burnFrom(address _from, uint256 _value) public {
173     require(_value <= allowed[_from][msg.sender]);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     _burn(_from, _value);
176   }
177 }
178 
179 contract MinesteriaCoin is StandardBurnableToken {
180 
181   string public constant name = "Minesteria coin";
182   string public constant symbol = "MINE"; 
183   uint8 public constant decimals = 18;
184 
185   uint256 public constant INITIAL_SUPPLY = 1000000000000 * (10 ** uint256(decimals));
186 
187   constructor() public {
188     totalSupply_ = INITIAL_SUPPLY;
189     balances[msg.sender] = INITIAL_SUPPLY;
190     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
191   }
192 }
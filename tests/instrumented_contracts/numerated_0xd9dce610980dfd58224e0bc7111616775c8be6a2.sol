1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34   
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract AbstractERC20 {
46 
47   uint256 public totalSupply;
48 
49   event Transfer(address indexed _from, address indexed _to, uint256 _value);
50   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52   function balanceOf(address _owner) public constant returns (uint256 balance);
53   function transfer(address _to, uint256 _value) public returns (bool success);
54   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
55   function approve(address _spender, uint256 _value) public returns (bool success);
56   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
57 }
58 
59 /*
60 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
61 .*/
62 contract StandardToken is AbstractERC20 {
63     
64   using SafeMath for uint256;
65 
66   mapping (address => uint256) balances;
67   mapping (address => mapping (address => uint256)) allowed;
68 
69   function transfer(address _to, uint256 _value) public returns (bool success) {
70 
71     require(balances[msg.sender] >= _value);
72     require(_to != 0x0);
73 
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81 
82     require(balances[_from] >= _value);
83     require(allowed[_from][msg.sender] >= _value);
84     require(_to != 0x0);
85 
86     balances[_to] = balances[_to].add(_value);
87     balances[_from] = balances[_from].sub(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     emit Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function approve(address _spender, uint256 _value) public returns (bool success) {
98 
99     require(_spender != 0x0);
100     require(_value == 0 || allowed[msg.sender][_spender] == 0);
101 
102     allowed[msg.sender][_spender] = _value;
103     emit Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
108     return allowed[_owner][_spender];
109   }
110 }
111 
112 contract Owned {
113 
114   address public owner;
115   address public newOwner;
116 
117   event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
118 
119   constructor() public {
120     owner = msg.sender;
121   }
122 
123   modifier ownerOnly {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   function transferOwnership(address _newOwner) public ownerOnly {
129     require(_newOwner != owner);
130     newOwner = _newOwner;
131   }
132 
133   function acceptOwnership() public {
134     require(msg.sender == newOwner);
135     emit OwnerUpdate(owner, newOwner);
136     owner = newOwner;
137     newOwner = address(0);
138   }
139 }
140 
141 contract Mintable is StandardToken {
142 
143   event Emission(uint256 _amount);
144 
145   function _mint(address _to, uint256 _amount) internal {
146 
147     require(_amount > 0);
148     require(_to != 0x0);
149     balances[_to] = balances[_to].add(_amount);
150     totalSupply = totalSupply.add(_amount);
151     emit Emission(_amount);
152     emit Transfer(this, _to, _amount);
153   }
154 }
155 
156 contract Destroyable is StandardToken {
157 
158   event Destruction(uint256 _amount);
159 
160   function _destroy(address _from, uint256 _amount) internal {
161 
162     require(balances[_from] >= _amount);
163     balances[_from] = balances[_from].sub(_amount);
164     totalSupply = totalSupply.sub(_amount);
165     emit Destruction(_amount);
166     emit Transfer(_from, this, _amount);
167   }
168 }
169 
170 contract Token is StandardToken, Owned, Destroyable, Mintable {
171 
172   address owner;
173   string constant public name = "GoldCrypto";
174   string constant public symbol = "AuX";
175   uint8 constant public decimals = 8;
176   
177   event Burn(address indexed _burner, uint256 _value);
178   
179   constructor(uint256 _initialSupply) public {
180   
181     owner = msg.sender;
182     balances[owner] = _initialSupply;
183     totalSupply = _initialSupply;
184   }
185   
186   function issue(address _to, uint256 _amount) external ownerOnly {
187 
188     _mint(_to, _amount);
189   }
190   
191   function destroy(address _from, uint256 _amount) external ownerOnly {
192 
193     _destroy(_from, _amount);
194   }
195   
196   function burn(uint256 _amount) external {
197 
198     _destroy(msg.sender, _amount);
199     emit Burn(msg.sender, _amount);
200   }
201 }
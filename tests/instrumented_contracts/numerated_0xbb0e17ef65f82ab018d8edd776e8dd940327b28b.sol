1 // File: math/SafeMath.sol
2 
3 pragma solidity 0.5.17;
4 
5 
6 library SafeMath {
7   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     c = a + b;
9     require(c >= a, "SafeMath: addition overflow");
10   }
11 
12   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     require(b <= a, "SafeMath: subtraction overflow");
14     return a - b;
15   }
16 
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     require(c / a == b, "SafeMath: multiplication overflow");
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Since Solidity automatically asserts when dividing by 0,
28     // but we only need it to revert.
29     require(b > 0, "SafeMath: division by zero");
30     return a / b;
31   }
32 
33   function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     // Same reason as `div`.
35     require(b > 0, "SafeMath: modulo by zero");
36     return a % b;
37   }
38 }
39 
40 // File: token/erc20/IERC20.sol
41 
42 pragma solidity 0.5.17;
43 
44 
45 interface IERC20 {
46   event Transfer(address indexed _from, address indexed _to, uint256 _value);
47   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 
49   function totalSupply() external view returns (uint256 _supply);
50   function balanceOf(address _owner) external view returns (uint256 _balance);
51 
52   function approve(address _spender, uint256 _value) external returns (bool _success);
53   function allowance(address _owner, address _spender) external view returns (uint256 _value);
54 
55   function transfer(address _to, uint256 _value) external returns (bool _success);
56   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
57 }
58 
59 // File: token/erc20/ERC20.sol
60 
61 pragma solidity 0.5.17;
62 
63 
64 
65 
66 contract ERC20 is IERC20 {
67   using SafeMath for uint256;
68 
69   uint256 public totalSupply;
70   mapping (address => uint256) public balanceOf;
71   mapping (address => mapping (address => uint256)) internal _allowance;
72 
73   function approve(address _spender, uint256 _value) public returns (bool) {
74     _approve(msg.sender, _spender, _value);
75     return true;
76   }
77 
78   function allowance(address _owner, address _spender) public view returns (uint256) {
79     return _allowance[_owner][_spender];
80   }
81 
82   function increaseAllowance(address _spender, uint256 _value) public returns (bool) {
83     _approve(msg.sender, _spender, _allowance[msg.sender][_spender].add(_value));
84     return true;
85   }
86 
87   function decreaseAllowance(address _spender, uint256 _value) public returns (bool) {
88     _approve(msg.sender, _spender, _allowance[msg.sender][_spender].sub(_value));
89     return true;
90   }
91 
92   function transfer(address _to, uint256 _value) public returns (bool _success) {
93     _transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
98     _transfer(_from, _to, _value);
99     _approve(_from, msg.sender, _allowance[_from][msg.sender].sub(_value));
100     return true;
101   }
102 
103   function _approve(address _owner, address _spender, uint256 _amount) internal {
104     require(_owner != address(0), "ERC20: approve from the zero address");
105     require(_spender != address(0), "ERC20: approve to the zero address");
106 
107     _allowance[_owner][_spender] = _amount;
108     emit Approval(_owner, _spender, _amount);
109   }
110 
111   function _transfer(address _from, address _to, uint256 _value) internal {
112     require(_from != address(0), "ERC20: transfer from the zero address");
113     require(_to != address(0), "ERC20: transfer to the zero address");
114     require(_to != address(this), "ERC20: transfer to this contract address");
115 
116     balanceOf[_from] = balanceOf[_from].sub(_value);
117     balanceOf[_to] = balanceOf[_to].add(_value);
118     emit Transfer(_from, _to, _value);
119   }
120 }
121 
122 // File: token/erc20/IERC20Detailed.sol
123 
124 pragma solidity 0.5.17;
125 
126 
127 interface IERC20Detailed {
128   function name() external view returns (string memory _name);
129   function symbol() external view returns (string memory _symbol);
130   function decimals() external view returns (uint8 _decimals);
131 }
132 
133 // File: token/erc20/ERC20Detailed.sol
134 
135 pragma solidity 0.5.17;
136 
137 
138 
139 
140 contract ERC20Detailed is ERC20, IERC20Detailed {
141   string public name;
142   string public symbol;
143   uint8 public decimals;
144 
145   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
146     name = _name;
147     symbol = _symbol;
148     decimals = _decimals;
149   }
150 }
151 
152 // File: token/erc20/ERC20GatewayWhitelist.sol
153 
154 pragma solidity 0.5.17;
155 
156 
157 contract ERC20GatewayWhitelist is ERC20 {
158   address public mainchainGateway;
159 
160   function allowance(address _owner, address _spender)
161     public
162     view
163     returns (uint256 _value)
164   {
165     if (_spender == mainchainGateway) return uint256(-1);
166 
167     return _allowance[_owner][_spender];
168   }
169 
170   function transferFrom(
171     address _from,
172     address _to,
173     uint256 _value
174   )
175     public
176     returns (bool _success)
177   {
178     if (allowance(_from, msg.sender) != uint256(-1)) {
179       super._approve(_from, msg.sender, _allowance[_from][msg.sender].sub(_value));
180     }
181 
182     _transfer(_from, _to, _value);
183     return true;
184   }
185 
186   function _setGateway(address _mainchainGateway) internal {
187     require(
188       _mainchainGateway != address(0),
189       "ERC20GatewayWhitelist: setting gateway to the zero address"
190     );
191     mainchainGateway = _mainchainGateway;
192   }
193 }
194 
195 // File: AXSToken.sol
196 
197 pragma solidity 0.5.17;
198 
199 
200 
201 
202 contract AXSToken is ERC20Detailed, ERC20GatewayWhitelist {
203   constructor(address _mainchainGateway)
204     public
205     ERC20Detailed("Axie Infinity Shard", "AXS", 18)
206   {
207     totalSupply = uint256(270000000).mul(uint256(10)**18);
208     balanceOf[msg.sender] = totalSupply;
209     emit Transfer(address(0), msg.sender, totalSupply);
210 
211     _setGateway(_mainchainGateway);
212   }
213 }
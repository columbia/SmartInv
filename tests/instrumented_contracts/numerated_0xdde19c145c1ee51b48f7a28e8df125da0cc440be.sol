1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 contract EmbiggenToken is ERC20 {
77   using SafeMath for uint256;
78 
79   uint constant MAX_UINT = 2**256 - 1;
80   string public name;
81   string public symbol;
82   uint8 public decimals;
83 
84   uint initialSupply;
85   uint initializedTime;
86   uint hourRate;
87 
88   struct UserBalance {
89     uint latestBalance;
90     uint lastCalculated;
91   }
92 
93   mapping(address => UserBalance) balances;
94   mapping(address => mapping(address => uint)) allowed;
95 
96   // annualRate: percent * 10^18
97   function EmbiggenToken(uint _initialSupply, uint annualRate, string _name, string _symbol, uint8 _decimals) {
98     initialSupply = _initialSupply;
99     initializedTime = (block.timestamp / 3600) * 3600;
100     hourRate = annualRate / (365 * 24);
101     require(hourRate <= 223872113856833); // This ensures that (earnedInterset * baseInterest) won't overflow a uint for any plausible time period
102     balances[msg.sender] = UserBalance({
103       latestBalance: _initialSupply,
104       lastCalculated: (block.timestamp / 3600) * 3600
105     });
106     name = _name;
107     symbol = _symbol;
108     decimals = _decimals;
109   }
110 
111   function getInterest(uint value, uint lastCalculated) public view returns (uint) {
112     if(value == 0) {
113       // We were going to multiply by 0 at the end, so no point wasting gas on
114       // the other calculations.
115       return 0;
116     }
117     uint exp = (block.timestamp - lastCalculated) / 3600;
118     uint x = 1000000000000000000;
119     uint base = 1000000000000000000 + hourRate;
120     while(exp != 0) {
121       if(exp & 1 != 0){
122         x = (x * base) / 1000000000000000000;
123       }
124       exp = exp / 2;
125       base = (base * base) / 1000000000000000000;
126     }
127     return value.mul(x - 1000000000000000000) / 1000000000000000000;
128   }
129 
130   function totalSupply() public view returns (uint) {
131     return initialSupply.add(getInterest(initialSupply, initializedTime));
132   }
133 
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner].latestBalance.add(getInterest(balances[_owner].latestBalance, balances[_owner].lastCalculated));
136   }
137 
138   function incBalance(address _owner, uint amount) private {
139     balances[_owner] = UserBalance({
140       latestBalance: balanceOf(_owner).add(amount),
141       lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour
142     });
143   }
144 
145   function decBalance(address _owner, uint amount) private {
146     uint priorBalance = balanceOf(_owner);
147     require(priorBalance >= amount);
148     balances[_owner] = UserBalance({
149       latestBalance: priorBalance.sub(amount),
150       lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour
151     });
152   }
153 
154   function transfer(address _to, uint _value) public returns (bool)  {
155     require(_to != address(0));
156     decBalance(msg.sender, _value);
157     incBalance(_to, _value);
158     Transfer(msg.sender, _to, _value);
159 
160     return true;
161   }
162 
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= allowed[_from][msg.sender]);
176 
177     decBalance(_from, _value);
178     incBalance(_to, _value);
179 
180     if(allowed[_from][msg.sender] < MAX_UINT) {
181       allowed[_from][msg.sender] -= _value;
182     }
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187 }
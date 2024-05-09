1 /**
2  *Submitted for verification at Etherscan.io on 2018-03-14
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 contract DSH is ERC20 {
81   using SafeMath for uint256;
82 
83   uint constant MAX_UINT = 2**256 - 1;
84   string public name;
85   string public symbol;
86   uint8 public decimals;
87 
88   uint initialSupply;
89   uint initializedTime;
90   uint hourRate;
91 
92   struct UserBalance {
93     uint latestBalance;
94     uint lastCalculated;
95   }
96 
97   mapping(address => UserBalance) balances;
98   mapping(address => mapping(address => uint)) allowed;
99 
100   // annualRate: percent * 10^18
101   function DSH(uint _initialSupply, uint annualRate, string _name, string _symbol, uint8 _decimals) {
102     initialSupply = _initialSupply;
103     initializedTime = (block.timestamp / 3600) * 3600;
104     hourRate = annualRate / (365 * 24);
105     require(hourRate <= 223872113856833); // This ensures that (earnedInterset * baseInterest) won't overflow a uint for any plausible time period
106     balances[msg.sender] = UserBalance({
107       latestBalance: _initialSupply,
108       lastCalculated: (block.timestamp / 3600) * 3600
109     });
110     name = _name;
111     symbol = _symbol;
112     decimals = _decimals;
113   }
114 
115   function getInterest(uint value, uint lastCalculated) public view returns (uint) {
116     if(value == 0) {
117       // We were going to multiply by 0 at the end, so no point wasting gas on
118       // the other calculations.
119       return 0;
120     }
121     uint exp = (block.timestamp - lastCalculated) / 3600;
122     uint x = 1000000000000000000;
123     uint base = 1000000000000000000 + hourRate;
124     while(exp != 0) {
125       if(exp & 1 != 0){
126         x = (x * base) / 1000000000000000000;
127       }
128       exp = exp / 2;
129       base = (base * base) / 1000000000000000000;
130     }
131     return value.mul(x - 1000000000000000000) / 1000000000000000000;
132   }
133 
134   function totalSupply() public view returns (uint) {
135     return initialSupply.add(getInterest(initialSupply, initializedTime));
136   }
137 
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return balances[_owner].latestBalance.add(getInterest(balances[_owner].latestBalance, balances[_owner].lastCalculated));
140   }
141 
142   function incBalance(address _owner, uint amount) private {
143     balances[_owner] = UserBalance({
144       latestBalance: balanceOf(_owner).add(amount),
145       lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour
146     });
147   }
148 
149   function decBalance(address _owner, uint amount) private {
150     uint priorBalance = balanceOf(_owner);
151     require(priorBalance >= amount);
152     balances[_owner] = UserBalance({
153       latestBalance: priorBalance.sub(amount),
154       lastCalculated: (block.timestamp / 3600) * 3600 // Round down to the last hour
155     });
156   }
157 
158   function transfer(address _to, uint _value) public returns (bool)  {
159     require(_to != address(0));
160     decBalance(msg.sender, _value);
161     incBalance(_to, _value);
162     Transfer(msg.sender, _to, _value);
163 
164     return true;
165   }
166 
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= allowed[_from][msg.sender]);
180 
181     decBalance(_from, _value);
182     incBalance(_to, _value);
183 
184     if(allowed[_from][msg.sender] < MAX_UINT) {
185       allowed[_from][msg.sender] -= _value;
186     }
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191 }
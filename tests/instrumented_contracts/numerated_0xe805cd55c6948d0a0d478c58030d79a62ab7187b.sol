1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, December 18, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.23;
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13 
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27 
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract ERC20Basic {
51     
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56   
57 }
58 
59 contract ERC20 is ERC20Basic {
60     
61   function allowance(address owner, address spender)
62     public view returns (uint256);
63 
64   function transferFrom(address from, address to, uint256 value)
65     public returns (bool);
66 
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(
69     address indexed owner,
70     address indexed spender,
71     uint256 value
72   );
73 }
74 
75 contract DetailedERC20 is ERC20 {
76   string public name;
77   string public symbol;
78   uint8 public decimals;
79 
80   constructor(string _name, string _symbol, uint8 _decimals) public {
81     name = _name;
82     symbol = _symbol;
83     decimals = _decimals;
84   }
85 }
86 
87 /**
88  * @title 实现ERC20基本合约的接口 
89  * @dev 基本的StandardToken，不包含allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   uint256 totalSupply_;
97   
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120   /**
121    * @dev 从一个地址向另外一个地址转token
122    * @param _from 转账的from地址
123    * @param _to address 转账的to地址
124    * @param _value uint256 转账token数量
125    */
126   function transferFrom(
127     address _from,
128     address _to,
129     uint256 _value
130   )
131     public
132     returns (bool)
133   {
134     // 做合法性检查
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     emit Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   function allowance(
152     address _owner,
153     address _spender
154    )
155     public
156     view
157     returns (uint256)
158   {
159     return allowed[_owner][_spender];
160   }
161 
162 }
163 
164 contract BurnableToken is BasicToken {
165 
166   event Burn(address indexed burner, uint256 value);
167 
168 }
169 
170 contract MintableToken is StandardToken {
171   event Mint(address indexed to, uint256 amount);
172   event MintFinished();
173 
174   bool public mintingFinished = false;
175 
176 
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181 
182 
183   /**
184    * @dev Function to stop minting new tokens.
185    * @return True if the operation was successful.
186    */
187   function finishMinting() public  canMint returns (bool) {
188     mintingFinished = true;
189     emit MintFinished();
190     return true;
191   }
192 }
193 
194 contract StandardBurnableToken is BurnableToken, StandardToken,MintableToken {
195 
196 
197   
198 }
199 
200 contract AseanTrade is StandardBurnableToken {
201     string public name = 'Asean Trade Chain';
202     string public symbol = 'ASTC';
203     uint8 public decimals = 8;
204     uint256 public INITIAL_SUPPLY = 200000000000000000; 
205     
206   constructor() public {
207     totalSupply_ = INITIAL_SUPPLY;
208     balances[msg.sender] = INITIAL_SUPPLY;
209   }
210 
211 }
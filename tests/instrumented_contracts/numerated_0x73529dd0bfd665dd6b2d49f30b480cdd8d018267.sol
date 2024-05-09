1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9 
10     if (a == 0) {
11       return 0;
12     }
13 
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 
24     return a / b;
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
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20Basic {
47     
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52   
53 }
54 
55 contract ERC20 is ERC20Basic {
56     
57   function allowance(address owner, address spender)
58     public view returns (uint256);
59 
60   function transferFrom(address from, address to, uint256 value)
61     public returns (bool);
62 
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(
65     address indexed owner,
66     address indexed spender,
67     uint256 value
68   );
69 }
70 
71 contract DetailedERC20 is ERC20 {
72   string public name;
73   string public symbol;
74   uint8 public decimals;
75 
76   constructor(string _name, string _symbol, uint8 _decimals) public {
77     name = _name;
78     symbol = _symbol;
79     decimals = _decimals;
80   }
81 }
82 
83 /**
84  * @title 实现ERC20基本合约的接口 
85  * @dev 基本的StandardToken，不包含allowances.
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalSupply_;
93   
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116   /**
117    * @dev 从一个地址向另外一个地址转token
118    * @param _from 转账的from地址
119    * @param _to address 转账的to地址
120    * @param _value uint256 转账token数量
121    */
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     // 做合法性检查
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   function allowance(
148     address _owner,
149     address _spender
150    )
151     public
152     view
153     returns (uint256)
154   {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 contract BurnableToken is BasicToken {
161 
162   event Burn(address indexed burner, uint256 value);
163 
164 }
165 
166 contract MintableToken is StandardToken {
167   event Mint(address indexed to, uint256 amount);
168   event MintFinished();
169 
170   bool public mintingFinished = false;
171 
172 
173   modifier canMint() {
174     require(!mintingFinished);
175     _;
176   }
177 
178 
179   /**
180    * @dev Function to stop minting new tokens.
181    * @return True if the operation was successful.
182    */
183   function finishMinting() public  canMint returns (bool) {
184     mintingFinished = true;
185     emit MintFinished();
186     return true;
187   }
188 }
189 
190 /**
191  * @title 标准可销毁token
192  * @dev 将burnFrom方法添加到ERC20实现中
193  */
194 contract StandardBurnableToken is BurnableToken, StandardToken,MintableToken {
195 
196 
197   
198 }
199 
200 contract BHTDToken is StandardBurnableToken {
201     string public name = 'BHTDToken';
202     string public symbol = 'BHTD';
203     uint8 public decimals = 8;
204     uint256 public INITIAL_SUPPLY = 32000000000000000; 
205     
206   constructor() public {
207     totalSupply_ = INITIAL_SUPPLY;
208     balances[msg.sender] = INITIAL_SUPPLY;
209   }
210 
211 }
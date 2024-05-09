1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-06
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 contract ERC20Basic {
52     
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   
58 }
59 
60 contract ERC20 is ERC20Basic {
61     
62   function allowance(address owner, address spender)
63     public view returns (uint256);
64 
65   function transferFrom(address from, address to, uint256 value)
66     public returns (bool);
67 
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(
70     address indexed owner,
71     address indexed spender,
72     uint256 value
73   );
74 }
75 
76 contract DetailedERC20 is ERC20 {
77   string public name;
78   string public symbol;
79   uint8 public decimals;
80 
81   constructor(string _name, string _symbol, uint8 _decimals) public {
82     name = _name;
83     symbol = _symbol;
84     decimals = _decimals;
85   }
86 }
87 
88 /**
89  * @title 实现ERC20基本合约的接口 
90  * @dev 基本的StandardToken，不包含allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint256 totalSupply_;
98   
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   function balanceOf(address _owner) public view returns (uint256) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 contract StandardToken is ERC20, BasicToken {
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   /**
122    * @dev 从一个地址向另外一个地址转token
123    * @param _from 转账的from地址
124    * @param _to address 转账的to地址
125    * @param _value uint256 转账token数量
126    */
127   function transferFrom(
128     address _from,
129     address _to,
130     uint256 _value
131   )
132     public
133     returns (bool)
134   {
135     // 做合法性检查
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     emit Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(
153     address _owner,
154     address _spender
155    )
156     public
157     view
158     returns (uint256)
159   {
160     return allowed[_owner][_spender];
161   }
162 
163 }
164 
165 contract BurnableToken is BasicToken {
166 
167   event Burn(address indexed burner, uint256 value);
168 
169 }
170 
171 contract MintableToken is StandardToken {
172   event Mint(address indexed to, uint256 amount);
173   event MintFinished();
174 
175   bool public mintingFinished = false;
176 
177 
178   modifier canMint() {
179     require(!mintingFinished);
180     _;
181   }
182 
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() public  canMint returns (bool) {
189     mintingFinished = true;
190     emit MintFinished();
191     return true;
192   }
193 }
194 
195 contract StandardBurnableToken is BurnableToken, StandardToken,MintableToken {
196 
197 
198   
199 }
200 
201 contract BvesToken is StandardBurnableToken {
202     string public name = 'Behavior Value Ecosystem';
203     string public symbol = 'BVES';
204     uint8 public decimals = 8;
205     uint256 public INITIAL_SUPPLY = 210000000000000000; 
206     
207   constructor() public {
208     totalSupply_ = INITIAL_SUPPLY;
209     balances[msg.sender] = INITIAL_SUPPLY;
210   }
211 
212 }
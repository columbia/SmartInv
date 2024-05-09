1 pragma solidity 0.4.24;
2 
3 
4 interface ERC20Interface {  
5 
6   function totalSupply() external view returns (uint256);
7 
8   function balanceOf(address who) external view returns (uint256);
9 
10   function allowance(address owner, address spender) external view returns (uint256);
11 
12   function transfer(address to, uint256 value) external returns (bool);
13 
14   function approve(address spender, uint256 value) external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22 }
23 
24 contract Owned {
25 
26   address public owner;
27 
28   event OwnershipTransferred(address indexed owner, address indexed newOwner);
29 
30   constructor() public {
31     owner = msg.sender;
32   }
33 
34   modifier onlyOwner {
35     require(owner == msg.sender);
36     _;
37   }
38 
39   /**
40    *
41    * 转移合约拥有关系
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     owner = newOwner;
46     emit OwnershipTransferred(owner, newOwner);
47   }
48 
49 }
50  
51 
52 /**
53 *
54 * safeMath库，防止溢出问题
55 *
56 */
57 library SafeMath {
58     
59     
60   /**
61    *   两数相乘函数，防止溢出
62    */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64       
65     //这里只检测a是否为0可以节省gas，但是如果检测了b就得不偿失了
66    
67     if (a == 0) {
68       return 0;
69     }
70 
71     uint256 c = a * b;
72     require(c / a == b);
73 
74     return c;
75   }
76 
77 
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     //不需要检测b是否为零，evm中会检测
80     require(b > 0);
81     uint256 c = a / b;
82     
83     return c;
84   }
85 
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b <= a);
88     uint256 c = a - b;
89     
90     return c;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     require(c >= a);
96 
97     return c;
98   }
99 
100   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101     require (b != 0);
102     return a % b;
103   }
104 
105 }
106 
107 contract PAT is ERC20Interface, Owned{
108 
109   using SafeMath for uint256;
110   string public symbol;
111   string public name;
112   uint8 public decimals;
113   uint256 public totalSupply; 
114   
115   mapping(address => uint256) public balances;
116 
117   mapping (address => mapping(address => uint256)) public allowed; 
118 
119   constructor(string _symbol, string _name, uint8 _decimals, uint256 _initSupply) public {
120     symbol = _symbol;
121     name = _name;
122     decimals = _decimals;
123     totalSupply = _initSupply;
124     balances[msg.sender] = _initSupply;
125 
126   }
127 
128   function symbol() public view returns (string) {
129     return symbol;
130   }
131 
132   function name() public view returns (string) {
133     return name;
134   }
135 
136   function decimals() public view returns (uint8) {
137     return decimals;
138   }
139 
140   function totalSupply() public view returns (uint256) {
141     return totalSupply;
142   }
143 
144   function balanceOf(address owner) public view returns (uint256) {
145     return balances[owner];
146   }
147 
148 
149   /**
150    * 返回owner账户可以转到spender账户的token数量
151    *
152    */
153   function allowance(address owner, address spender) public view returns (uint256) {
154     return allowed[owner][spender];
155   } 
156 
157   /**
158    * 
159    * 向一个地址转账
160    */
161   function transfer(address to, uint256 value) public returns (bool) {
162     require(to != address(0));
163     balances[msg.sender] = balances[msg.sender].sub(value);
164     balances[to] = balances[to].add(value);
165     emit Transfer(msg.sender, to, value);
166     return true;
167 
168   }
169 
170   /**
171    *
172    * 存在re-approve攻击漏洞，建议使用increaseAllowance方法
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176     allowed[msg.sender][spender] = value;
177     emit Approval(msg.sender, spender, value);
178     return true;
179   }
180 
181 
182   /**
183    *
184    * 从一个地址向另外一个地址转账
185    */
186   function transferFrom(address from, address to, uint256 value) public returns (bool) {
187     require(to != address(0));
188     balances[from] = balances[from].sub(value);
189     balances[to] = balances[to].add(value);
190     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
191     emit Transfer(from, to, value);
192     return true;
193 
194   }
195 
196   /**
197    *
198    * 防止approve函数缺陷被利用, 增加spender账户对msg.sender账户token的可用量
199    */
200   function increaseAllowance(address spender, uint256 value) public returns (bool) {
201     require(spender != address(0));
202     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
203     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
204     return true;
205   } 
206 
207   /**
208    *
209    * 防止approve函数缺陷被利用, 减少spender账户对msg.sender账户token的可用量
210    */
211   function decreaseAllowance(address spender, uint256 value) public returns (bool) {
212     require(spender != address(0));
213     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(value);
214     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
215     return true;
216   }
217 
218 }
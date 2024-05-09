1 /**
2  *   ___________.__                 ___________     __                  
3  *   \_   _____/|__|______   ____   \__    ___/___ |  | __ ____   ____  
4  *    |    __)  |  \_  __ \_/ __ \    |    | /  _ \|  |/ // __ \ /    \ 
5  *    |     \   |  ||  | \/\  ___/    |    |(  <_> )    <\  ___/|   |  \
6  *    \___  /   |__||__|    \___  >   |____| \____/|__|_ \\___  >___|  /
7  *        \/                    \/                      \/    \/     \/ 
8  *                                          
9  *                       %%                 
10  *                   &%((&                  
11  *                 &(((((& .                
12  *               %#((((((&                  
13  *              *%(((((((&    #&            
14  *              &((((,((((&, &((&           
15  *              %((,,,,((((((((((&          
16  *          &% %((,,,,,((((((,(((&          
17  *          &((&((,,,,,,,,,,,,,((&&&        
18  *          &(((((,,,,,,,,,,,,,(%((& .      
19  *          &(((,,,,,.  ,,,,,,(((((&        
20  *           &((,,,,     , ,,,,,((& .       
21  *            &((,,,        ,,,((&          
22  *             .&(,,       ,,,(&            
23  *                (&&(.  ,#&&               
24  *                 .        ,          
25  *  
26  *  10% token burn per transaction.
27  *   
28  *  1,000 token airdrop phase 1 (100 holders) = 100,000 distributed
29  *  500 token airdrop phase 2 (100 holders) = 50,000 distributed
30  *  400 token airdrop phase 3 (100 holders) = 40,000 distributed
31  *  300 token airdrop phase 4 (100 holders) = 30,000 distributed
32  *  200 token airdrop phase 5 (100 holders) = 20,000 distributed
33  *  100 token airdrop phase 6 (100 holders) = 10,000 distributed
34  *  50 token airdrop phase 7 (10,000 holders) = 500,000 distributed
35  * 
36  *  Submitted for verification at Etherscan.io on 2019-06-23
37  *  
38 */
39 
40 pragma solidity ^0.5.0;
41 
42 interface IERC20 {
43   function totalSupply() external view returns (uint256);
44   function balanceOf(address who) external view returns (uint256);
45   function allowance(address owner, address spender) external view returns (uint256);
46   function transfer(address to, uint256 value) external returns (bool);
47   function approve(address spender, uint256 value) external returns (bool);
48   function transferFrom(address from, address to, uint256 value) external returns (bool);
49 
50   event Transfer(address indexed from, address indexed to, uint256 value);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a / b;
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 
80   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
81     uint256 c = add(a,m);
82     uint256 d = sub(c,1);
83     return mul(div(d,m),m);
84   }
85 }
86 
87 contract ERC20Detailed is IERC20 {
88 
89   uint8 private _Tokendecimals;
90   string private _Tokenname;
91   string private _Tokensymbol;
92 
93   constructor(string memory name, string memory symbol, uint8 decimals) public {
94    
95    _Tokendecimals = decimals;
96     _Tokenname = name;
97     _Tokensymbol = symbol;
98     
99   }
100 
101   function name() public view returns(string memory) {
102     return _Tokenname;
103   }
104 
105   function symbol() public view returns(string memory) {
106     return _Tokensymbol;
107   }
108 
109   function decimals() public view returns(uint8) {
110     return _Tokendecimals;
111   }
112 }
113 
114 /**end here**/
115 
116 contract FireToken is ERC20Detailed {
117 
118   using SafeMath for uint256;
119   mapping (address => uint256) private _FireTokenBalances;
120   mapping (address => mapping (address => uint256)) private _allowed;
121   string constant tokenName = "Fire Token";
122   string constant tokenSymbol = "FIRE";
123   uint8  constant tokenDecimals = 18;
124   uint256 _totalSupply = 1000000000000000000000000;
125  
126  
127   
128 
129   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
130     _mint(msg.sender, _totalSupply);
131   }
132 
133   function totalSupply() public view returns (uint256) {
134     return _totalSupply;
135   }
136 
137   function balanceOf(address owner) public view returns (uint256) {
138     return _FireTokenBalances[owner];
139   }
140 
141   function allowance(address owner, address spender) public view returns (uint256) {
142     return _allowed[owner][spender];
143   }
144 
145 
146 
147   function transfer(address to, uint256 value) public returns (bool) {
148     require(value <= _FireTokenBalances[msg.sender]);
149     require(to != address(0));
150 
151     uint256 FireTokenDecay = value.div(10);
152     uint256 tokensToTransfer = value.sub(FireTokenDecay);
153 
154     _FireTokenBalances[msg.sender] = _FireTokenBalances[msg.sender].sub(value);
155     _FireTokenBalances[to] = _FireTokenBalances[to].add(tokensToTransfer);
156 
157     _totalSupply = _totalSupply.sub(FireTokenDecay);
158 
159     emit Transfer(msg.sender, to, tokensToTransfer);
160     emit Transfer(msg.sender, address(0), FireTokenDecay);
161     return true;
162   }
163 
164   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
165     for (uint256 i = 0; i < receivers.length; i++) {
166       transfer(receivers[i], amounts[i]);
167     }
168   }
169 
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172     _allowed[msg.sender][spender] = value;
173     emit Approval(msg.sender, spender, value);
174     return true;
175   }
176 
177   function transferFrom(address from, address to, uint256 value) public returns (bool) {
178     require(value <= _FireTokenBalances[from]);
179     require(value <= _allowed[from][msg.sender]);
180     require(to != address(0));
181 
182     _FireTokenBalances[from] = _FireTokenBalances[from].sub(value);
183 
184     uint256 FireTokenDecay = value.div(10);
185     uint256 tokensToTransfer = value.sub(FireTokenDecay);
186 
187     _FireTokenBalances[to] = _FireTokenBalances[to].add(tokensToTransfer);
188     _totalSupply = _totalSupply.sub(FireTokenDecay);
189 
190     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
191 
192     emit Transfer(from, to, tokensToTransfer);
193     emit Transfer(from, address(0), FireTokenDecay);
194 
195     return true;
196   }
197 
198   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199     require(spender != address(0));
200     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
201     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
202     return true;
203   }
204 
205   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206     require(spender != address(0));
207     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
208     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
209     return true;
210   }
211 
212   function _mint(address account, uint256 amount) internal {
213     require(amount != 0);
214     _FireTokenBalances[account] = _FireTokenBalances[account].add(amount);
215     emit Transfer(address(0), account, amount);
216   }
217 
218   function burn(uint256 amount) external {
219     _burn(msg.sender, amount);
220   }
221 
222   function _burn(address account, uint256 amount) internal {
223     require(amount != 0);
224     require(amount <= _FireTokenBalances[account]);
225     _totalSupply = _totalSupply.sub(amount);
226     _FireTokenBalances[account] = _FireTokenBalances[account].sub(amount);
227     emit Transfer(account, address(0), amount);
228   }
229 
230   function burnFrom(address account, uint256 amount) external {
231     require(amount <= _allowed[account][msg.sender]);
232     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
233     _burn(account, amount);
234   }
235 }
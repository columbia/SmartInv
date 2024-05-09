1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 // ----------------------------------------------------------------------------
43 // Owned contract
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 // 低碳未来Token
72 // Symbol      : LCT
73 // Name        : Lowcarbon Token
74 // Total supply: 1000000000   初始发行10亿，最大不超过110亿，剩余100亿通过增加接口增发（挖矿）。
75 // Decimals    : 1  1位小数位
76 // ----------------------------------------------------------------------------
77 contract LowcarbonToken is ERC20Interface, Owned {
78     using SafeMath for uint;
79 
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply; //总供应量
84     uint public hourlyProduction; //每小时产量
85     uint public accumulatedHours; //累计小时数
86     uint public last_mint; //上次挖矿时间
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91     event Mint(address indexed to, uint256 amount);
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     function LowcarbonToken() public {
97         symbol = "LCT";
98         name = "Low Carbon Token";
99         decimals = 1;
100         last_mint = 0;
101         hourlyProduction = 114155; //放大10倍值
102         accumulatedHours = 0;
103         _totalSupply = 1000000000 * 10**uint(decimals); //初始发行
104         balances[owner] = _totalSupply;
105         Transfer(address(0), owner, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // ------------------------------------------------------------------------
112     function totalSupply() public constant returns (uint) {
113         return _totalSupply  - balances[address(0)];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account `tokenOwner`
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Transfer the balance from token owner's account to `to` account
127     // - Owner's account must have sufficient balance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = balances[msg.sender].sub(tokens);
132         balances[to] = balances[to].add(tokens);
133         Transfer(msg.sender, to, tokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for `spender` to transferFrom(...) `tokens`
140     // from the token owner's account
141     //
142     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143     // recommends that there are no checks for the approval double-spend attack
144     // as this should be implemented in user interfaces 
145     // ------------------------------------------------------------------------
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer `tokens` from the `from` account to the `to` account
155     // 
156     // The calling account must already have sufficient tokens approve(...)-d
157     // for spending from the `from` account and
158     // - From account must have sufficient balance to transfer
159     // - Spender must have sufficient allowance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
163         balances[from] = balances[from].sub(tokens);
164         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
165         balances[to] = balances[to].add(tokens);
166         Transfer(from, to, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Returns the amount of tokens approved by the owner that can be
173     // transferred to the spender's account
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179     // ------------------------------------------------------------------------
180     // Don't accept ETH
181     // ------------------------------------------------------------------------
182     function () public payable {
183         revert();
184     }
185 
186     // ------------------------------------------------------------------------
187     // Owner can transfer out any accidentally sent ERC20 tokens
188     // ------------------------------------------------------------------------
189     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
190         return ERC20Interface(tokenAddress).transfer(owner, tokens);
191     }
192 
193     /**
194    * @dev Function to mint tokens
195    * @return A boolean that indicates if the operation was successful.
196    */
197     function mint() onlyOwner public returns (bool) {
198         if(last_mint == 0){  //首次调用，不挖矿
199             last_mint = now;
200             return true;
201         }
202 
203         if(hourlyProduction < 1){
204             revert(); //每小时产值小0.1不能再发行
205         }
206         uint diffHours = (now - last_mint)/3600; //计算小时数
207         if(diffHours == 0){
208             revert(); //小于1小时不能挖矿
209         }
210         
211         uint _amount;
212         if((accumulatedHours + diffHours) > 8760 ){
213             _amount = hourlyProduction * (8760 - accumulatedHours);  //调整前部分产值计算
214             hourlyProduction = hourlyProduction*9/10; //调整生产率
215             accumulatedHours = accumulatedHours + diffHours - 8760; //初始化累计值
216             _amount += hourlyProduction*accumulatedHours;  //调整后部分产值计算
217         }
218         else{
219             _amount = hourlyProduction * diffHours;
220             accumulatedHours += diffHours; //增加累计小时数
221         }
222         _totalSupply = _totalSupply.add(_amount);
223         balances[owner] = balances[owner].add(_amount);
224         last_mint = now;
225         Mint(owner, _amount);
226         return true;
227     }
228 }
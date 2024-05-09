1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     function Owned() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 contract ExToke is ERC20Interface, Owned, SafeMath {
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     address public oldAddress;
71     address public tokenAdmin;
72     uint public _totalSupply;
73     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
74     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
75     address public fundsWallet;           
76     uint256 public crowdSaleSupply;
77     uint256 public tokenSwapSupply;
78     uint256 public dividendSupply;
79     
80     uint256 public scaling;
81     uint256 public scaledRemainder;
82     
83     uint256 public finishTime = 1548057600;
84     uint256 public startTime = 1540814400;
85     
86     uint256[] public releaseDates = 
87         [1575201600, 1577880000, 1580558400, 1583064000, 1585742400, 1588334400,
88         1591012800, 1593604800, 1596283200, 1598961600, 1601553600, 1604232000,
89         1606824000, 1609502400, 1612180800, 1614600000, 1617278400, 1619870400,
90         1622548800, 1625140800, 1627819200, 1630497600, 1633089600, 1635768000];
91     
92     uint256 public nextRelease;
93 
94     mapping(address => uint256) public scaledDividendBalanceOf;
95 
96     uint256 public scaledDividendPerToken;
97 
98     mapping(address => uint256) public scaledDividendCreditedTo;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103     function ExToke() public {
104         symbol = "XTE";
105         name = "ExToke";
106         decimals = 18;
107         tokenAdmin = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;
108         oldAddress = 0x28925299Ee1EDd8Fd68316eAA64b651456694f0f;
109     	_totalSupply = 7000000000000000000000000000;
110     	crowdSaleSupply = 500000000000000000000000000;
111     	tokenSwapSupply = 2911526439961880000000000000;
112     	dividendSupply = 2400000000000000000000000000;
113     	unitsOneEthCanBuy = 100000;
114         balances[this] = 5811526439961880000000000000;
115         balances[0x6baba6fb9d2cb2f109a41de2c9ab0f7a1b5744ce] = 1188473560038120000000000000;
116         
117         nextRelease = 0;
118         
119         scaledRemainder = 0;
120         scaling = uint256(10) ** 8;
121         
122     	fundsWallet = tokenAdmin;
123         Transfer(this, 0x6baba6fb9d2cb2f109a41de2c9ab0f7a1b5744ce, 1188473560038120000000000000);
124 
125     }
126     
127     
128 
129     function totalSupply() public constant returns (uint) {
130         return _totalSupply  - balances[address(0)];
131     }
132 
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137     function transfer(address to, uint tokens) public returns (bool success) {
138         update(msg.sender);
139         update(to);
140         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
153         update(from);
154         update(to);
155         balances[from] = safeSub(balances[from], tokens);
156         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         Transfer(from, to, tokens);
159         return true;
160     }
161 
162     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
163         return allowed[tokenOwner][spender];
164     }
165 
166     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         Approval(msg.sender, spender, tokens);
169         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
170         return true;
171     }
172     
173     function update(address account) internal {
174         if(nextRelease < 24 && block.timestamp > releaseDates[nextRelease]){
175             releaseDivTokens();
176         }
177         uint256 owed =
178             scaledDividendPerToken - scaledDividendCreditedTo[account];
179         scaledDividendBalanceOf[account] += balances[account] * owed;
180         scaledDividendCreditedTo[account] = scaledDividendPerToken;
181         
182         
183     }
184     
185     function () public payable {
186         if(startTime < block.timestamp && finishTime >= block.timestamp && crowdSaleSupply >= msg.value * unitsOneEthCanBuy){
187         uint256 amount = msg.value * unitsOneEthCanBuy;
188         require(balances[this] >= amount);
189 
190         balances[this] = balances[this] - amount;
191         balances[msg.sender] = balances[msg.sender] + amount;
192         
193         crowdSaleSupply -= msg.value * unitsOneEthCanBuy;
194 
195         Transfer(this, msg.sender, amount); // Broadcast a message to the blockchain
196 
197         tokenAdmin.transfer(msg.value);
198         }
199         else if(finishTime < block.timestamp){
200             balances[this] = balances[this] - amount;
201             balances[tokenAdmin] += crowdSaleSupply;
202             tokenAdmin.transfer(msg.value);
203             Transfer(this, tokenAdmin, amount);
204             crowdSaleSupply = 0;
205         }
206         
207         
208     }
209     
210     function releaseDivTokens() public returns (bool success){
211         require(block.timestamp > releaseDates[nextRelease]);
212         uint256 releaseAmount = 100000000 * (uint256(10) ** decimals);
213         dividendSupply -= releaseAmount;
214         uint256 available = (releaseAmount * scaling) + scaledRemainder;
215         scaledDividendPerToken += available / _totalSupply;
216         scaledRemainder = available % _totalSupply;
217         nextRelease += 1;
218         return true;
219     }
220     
221     function withdraw() public returns (bool success){
222         require(block.timestamp > releaseDates[0]);
223         update(msg.sender);
224         uint256 amount = scaledDividendBalanceOf[msg.sender] / scaling;
225         scaledDividendBalanceOf[msg.sender] %= scaling;  // retain the remainder
226         balances[msg.sender] += amount;
227         balances[this] -= amount;
228         emit Transfer(this, msg.sender, amount);
229         return true;
230     }
231     
232     function swap(uint256 sendAmount) returns (bool success){
233         require(tokenSwapSupply >= sendAmount * 3);
234         if(ERC20Interface(oldAddress).transferFrom(msg.sender, tokenAdmin, sendAmount)){
235             balances[msg.sender] += sendAmount * 3;
236             balances[this] -= sendAmount * 3;
237             tokenSwapSupply -= sendAmount * 3;
238         }
239         emit Transfer(this, msg.sender, sendAmount * 3);
240         return true;
241     }
242     
243 
244 
245 }
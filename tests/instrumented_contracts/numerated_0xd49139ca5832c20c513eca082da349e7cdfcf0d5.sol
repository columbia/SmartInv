1 pragma solidity ^0.4.24;
2 
3 /**
4  * 代幣智能合約
5  *
6  * Symbol       : PDI5
7  * Name         : Wind Green Gain Token 5
8  * Total supply : 2,160,000,000.000000000000000000
9  * Decimals     : 18
10  */
11 
12 
13 /**
14  * Safe maths
15  */
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21 
22 
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27 
28 
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33 
34 
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 /**
43  * ERC 代幣標準 #20 Interface: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
44  */
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 /**
59  * 一個函式即可取得核准並執行函式 (Borrowed from MiniMeToken)
60  */
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 /**
67  * 持有權
68  */
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75 
76     constructor() public {
77         owner = msg.sender;
78     }
79 
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90 
91 
92     function acceptOwnership() public {
93         require(msg.sender == newOwner);
94         emit OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96         newOwner = address(0);
97     }
98 }
99 
100 
101 /**
102  * ERC20 相容代幣，定義(寫死)了全名、符號(縮寫)、精準度(小數點後幾位數)及固定(未來不可增額)的發行量。
103  */
104 contract WindGreenGainToken5 is ERC20Interface, Owned {
105     using SafeMath for uint;
106 
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint _totalSupply;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     /**
117      * Constructor
118      */
119     constructor() public {
120         symbol = "PDI5";
121         name = "Wind Green Gain Token 5";
122         decimals = 18;
123         _totalSupply = 2160000000 * 10**uint(decimals);
124         balances[owner] = _totalSupply;
125         emit Transfer(address(0), owner, _totalSupply);
126     }
127 
128 
129     /**
130      * 發行的供應量。
131      */
132     function totalSupply() public view returns (uint) {
133         return _totalSupply.sub(balances[address(0)]);
134     }
135 
136 
137     /**
138      * 從 `tokeOwner` 錢包地址取得代幣餘額。
139      */
140     function balanceOf(address tokenOwner) public view returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     /**
146      * 從代幣持有者的錢包轉 `tokens` 到 `to` 錢包地址。
147      *  - 代幣持有者的錢包裡必須要有足夠的餘額
148      *  - 交易額為 0 是可被允許的
149      */
150     function transfer(address to, uint tokens) public returns (bool success) {
151         require(balances[msg.sender] >= (tokens * 10**uint(18)));            // 餘額夠不夠
152         require(balances[to] + (tokens * 10**uint(18)) >= balances[to]);   // 防止異味
153 
154         balances[msg.sender] = balances[msg.sender].sub((tokens * 10**uint(18)));
155         balances[to] = balances[to].add((tokens * 10**uint(18)));
156 
157         emit Transfer(msg.sender, to, (tokens * 10**uint(18)));
158 
159         return true;
160     }
161 
162 
163     /**
164      * 代幣持有者用來核准 `spender` 從代幣持有者的錢包地址以 transferFrom(...) 函式使用 `tokens`。
165      *
166      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md 中建議了不用檢查
167      * 核准雙消費攻擊，因為這應該在 UI 中實作。
168      */
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     /**
177      * 從 `from` 錢包地址轉 `tokens` 到 `to` 錢包地址。
178      *
179      * 呼叫此函式者必須有足夠的代幣從 `from` 錢包地址使用代幣。
180      */
181     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
182         balances[from] = balances[from].sub(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         balances[to] = balances[to].add(tokens);
185         emit Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     /**
191      * 傳回代幣持有者核准 `spender` 錢包地址 可交易的代幣數量。
192      */
193     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197 
198     /**
199      * 代幣持有者可核准 `spender` 從代幣持有者的錢包地址以 transferFrom(...) 函式交易 `token`，然
200      * 後執行 `spender` 的 `receiveApproval(...)` 合約函式。
201      */
202     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         emit Approval(msg.sender, spender, tokens);
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
206         return true;
207     }
208 
209 
210     /**
211      * 防止漏洞(不接受 ETH)。
212      */
213     function () public payable {
214         revert();
215     }
216 
217 
218     /**
219      * 持有者可轉出任何意外發送的 ERC20 代幣。
220      */
221     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
222         return ERC20Interface(tokenAddress).transfer(owner, tokens);
223     }
224 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * 代幣智能合約
5  *
6  * Symbol       : WGGT
7  * Name         : Wind Green Gain Token
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
104 contract WindGreenGainToken is ERC20Interface, Owned {
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
120         symbol = "WGGT";
121         name = "Wind Green Gain Token";
122         decimals = 18;
123         _totalSupply = 2160000000 * 10**uint(decimals);
124 
125         balances[owner] = _totalSupply;
126         emit Transfer(address(0), owner, _totalSupply);
127     }
128 
129 
130     /**
131      * 發行的供應量。
132      */
133     function totalSupply() public view returns (uint) {
134         return _totalSupply.sub(balances[address(0)]);
135     }
136 
137 
138     /**
139      * 從 `tokeOwner` 錢包地址取得代幣餘額。
140      */
141     function balanceOf(address tokenOwner) public view returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     /**
147      * 從代幣持有者的錢包轉 `tokens` 到 `to` 錢包地址。
148      *  - 代幣持有者的錢包裡必須要有足夠的餘額
149      *  - 交易額為 0 是可被允許的
150      */
151     function transfer(address to, uint tokens) public returns (bool success) {
152         require(balances[msg.sender] >= tokens);       // 餘額夠不夠
153         require(balances[to] + tokens >= balances[to]);// 防止異味
154 
155         balances[msg.sender] = balances[msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157 
158         emit Transfer(msg.sender, to, tokens);
159 
160         return true;
161     }
162 
163 
164     /**
165      * 代幣持有者用來核准 `spender` 從代幣持有者的錢包地址以 transferFrom(...) 函式使用 `tokens`。
166      *
167      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md 中建議了不用檢查
168      * 核准雙消費攻擊，因為這應該在 UI 中實作。
169      */
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     /**
178      * 從 `from` 錢包地址轉 `tokens` 到 `to` 錢包地址。
179      *
180      * 呼叫此函式者必須有足夠的代幣從 `from` 錢包地址使用代幣。
181      */
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = balances[from].sub(tokens);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185         balances[to] = balances[to].add(tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     /**
192      * 傳回代幣持有者核准 `spender` 錢包地址 可交易的代幣數量。
193      */
194     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     /**
200      * 代幣持有者可核准 `spender` 從代幣持有者的錢包地址以 transferFrom(...) 函式交易 `token`，然
201      * 後執行 `spender` 的 `receiveApproval(...)` 合約函式。
202      */
203     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
207         return true;
208     }
209 
210 
211     /**
212      * 防止漏洞(不接受 ETH)。
213      */
214     function () public payable {
215         //revert();
216     }
217 
218 
219     /**
220      * 持有者可轉出任何意外發送的 ERC20 代幣。
221      */
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 
226 
227     function deposit() public payable {
228         require(balances[msg.sender] >= msg.value);             // 餘額夠不夠
229         require(balances[owner] + msg.value >= balances[owner]);// 防止異味
230 
231         balances[msg.sender] = balances[msg.sender].add(msg.value);
232     }
233 
234 
235     function withdraw(uint withdrawAmount) public {
236         if(balances[msg.sender] >= withdrawAmount) {
237             balances[msg.sender] -= withdrawAmount;
238             msg.sender.transfer(withdrawAmount);
239         }
240     }
241 }
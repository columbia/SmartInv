1 pragma solidity 0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : CBC
6 // Name        : CashBagCoin
7 // Total supply: 367,000,000.000000000000000000
8 // Decimals    : 9
9 //
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21 
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26 
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31 
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88 
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and an
100 // initial fixed supply
101 // ----------------------------------------------------------------------------
102 
103 contract FixedSupplyToken is ERC20Interface, Owned {
104     using SafeMath for uint;
105 
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint public _totalSupply;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118 
119     function FixedSupplyToken() public {
120         symbol = "CBC";
121         name = "CashBagCoin";
122         decimals = 9;
123         _totalSupply = 367000000 * 10 ** uint(decimals);
124         balances[owner] = _totalSupply;
125         Transfer(address(0), owner, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132 
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account `tokenOwner`
140     // ------------------------------------------------------------------------
141 
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152 
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces
168     // ------------------------------------------------------------------------
169 
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     //
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186 
187     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
188         balances[from] = balances[from].sub(tokens);
189         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
190         balances[to] = balances[to].add(tokens);
191         Transfer(from, to, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Returns the amount of tokens approved by the owner that can be
198     // transferred to the spender's account
199     // ------------------------------------------------------------------------
200 
201     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
202         return allowed[tokenOwner][spender];
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account. The `spender` contract function
209     // `receiveApproval(...)` is then executed
210     // ------------------------------------------------------------------------
211 
212     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
213         allowed[msg.sender][spender] = tokens;
214         Approval(msg.sender, spender, tokens);
215         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
216         return true;
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223 
224     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
225         return ERC20Interface(tokenAddress).transfer(owner, tokens);
226     }
227 }
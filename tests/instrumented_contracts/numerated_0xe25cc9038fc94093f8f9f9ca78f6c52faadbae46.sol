1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // WDX beta token contract
5 //
6 // Symbol      : WDXB
7 // Name        : WDXB Token
8 // Total supply: 5,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         assert(c >= a);
21     }
22 
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         assert(b <= a);
25         c = a - b;
26     }
27 
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         assert(a == 0 || c / a == b);
31     }
32 
33     function div(uint a, uint b) internal pure returns (uint c) {
34         assert(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     constructor() public {
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
91         emit OwnershipTransferred(owner, newOwner);
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
102 contract WeiDexBeta is ERC20Interface, Owned {
103     using SafeMath for uint;
104     
105     // ------------------------------------------------------------------------
106     // Metadata
107     // ------------------------------------------------------------------------
108     string public symbol;
109     string public name;
110     uint8 public decimals;
111     uint public _totalSupply;
112 
113     mapping(address => uint) public balances;
114     mapping(address => mapping(address => uint)) public allowed;
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "WDXB";
121         name = "WeiDex Beta";
122         decimals = 18;
123         _totalSupply = 5000000 * 10**uint(decimals);
124         balances[owner] = _totalSupply;
125         
126         emit Transfer(address(0), owner, _totalSupply);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account `tokenOwner`
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to `to` account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint tokens) public returns (bool success) {
152         balances[msg.sender] = balances[msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for `spender` to transferFrom(...) `tokens`
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces 
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer `tokens` from the `from` account to the `to` account
176     // 
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the `from` account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = balances[from].sub(tokens);
185         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
186         balances[to] = balances[to].add(tokens);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for `spender` to transferFrom(...) `tokens`
203     // from the token owner's account. The `spender` contract function
204     // `receiveApproval(...)` is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         emit Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Don't accept ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         revert();
219     }
220     
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }
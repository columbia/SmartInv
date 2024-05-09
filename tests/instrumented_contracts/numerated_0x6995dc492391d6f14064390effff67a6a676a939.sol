1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : OST
7 // Name        : OST Token
8 // Total supply: 1,000,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25 
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30 
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35 
36     function div(uint a, uint b) internal pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // ERC Token Standard #20 Interface
45 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
46 // ----------------------------------------------------------------------------
47 contract ERC20Interface {
48     function totalSupply() public constant returns (uint);
49 
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51 
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53 
54     function transfer(address to, uint tokens) public returns (bool success);
55 
56     function approve(address spender, uint tokens) public returns (bool success);
57 
58     function transferFrom(address from, address to, uint tokens) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Contract function to receive approval and execute function in one call
67 //
68 // Borrowed from MiniMeToken
69 // ----------------------------------------------------------------------------
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // Owned contract
77 // ----------------------------------------------------------------------------
78 contract Owned {
79     address public owner;
80     address public newOwner;
81 
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     function transferOwnership(address _newOwner) public onlyOwner {
94         newOwner = _newOwner;
95     }
96 
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // ERC20 Token, with the addition of symbol, name and decimals and a
108 // fixed supply
109 // ----------------------------------------------------------------------------
110 contract OSTest5Token is ERC20Interface, Owned {
111     using SafeMath for uint;
112 
113     string public symbol;
114     string public  name;
115     uint8 public decimals;
116     uint _totalSupply;
117 
118     mapping(address => uint) balances;
119     mapping(address => mapping(address => uint)) allowed;
120 
121 
122     // ------------------------------------------------------------------------
123     // Constructor
124     // ------------------------------------------------------------------------
125     constructor() public {
126         symbol = "OST";
127         name = "OST Token";
128         decimals = 18;
129         _totalSupply = 1000000000 * 10**uint(decimals);
130         balances[0x92361FD0098223891CAd7324001975e98387b66e] = _totalSupply;
131         emit Transfer(address(0), 0x92361FD0098223891CAd7324001975e98387b66e, _totalSupply);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public view returns (uint) {
139         return _totalSupply.sub(balances[address(0)]);
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account `tokenOwner`
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public view returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to `to` account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         balances[msg.sender] = balances[msg.sender].sub(tokens);
158         balances[to] = balances[to].add(tokens);
159         emit Transfer(msg.sender, to, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for `spender` to transferFrom(...) `tokens`
166     // from the token owner's account
167     //
168     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169     // recommends that there are no checks for the approval double-spend attack
170     // as this should be implemented in user interfaces
171     // ------------------------------------------------------------------------
172     function approve(address spender, uint tokens) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         emit Approval(msg.sender, spender, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer `tokens` from the `from` account to the `to` account
181     //
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the `from` account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
189         balances[from] = balances[from].sub(tokens);
190         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
191         balances[to] = balances[to].add(tokens);
192         emit Transfer(from, to, tokens);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Returns the amount of tokens approved by the owner that can be
199     // transferred to the spender's account
200     // ------------------------------------------------------------------------
201     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
202         return allowed[tokenOwner][spender];
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account. The `spender` contract function
209     // `receiveApproval(...)` is then executed
210     // ------------------------------------------------------------------------
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Don't accept ETH
221     // ------------------------------------------------------------------------
222     function() public payable {
223         revert();
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }
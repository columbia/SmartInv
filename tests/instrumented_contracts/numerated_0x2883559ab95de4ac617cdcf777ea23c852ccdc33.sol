1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'JLY' 'Jelly Token' token contract
5 //
6 // Symbol      : JLY
7 // Name        : Jelly Token
8 // Total supply: 1,000,000,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
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
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
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
102 contract JellyToken is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "JLY";
119         name = "Jelly Token";
120         decimals = 18;
121         _totalSupply = 1000000000000 * 10**uint(decimals);
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return _totalSupply  - balances[address(0)];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public constant returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150         balances[to] = balances[to].add(tokens);
151         emit Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces 
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         emit Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer `tokens` from the `from` account to the `to` account
173     // 
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         balances[from] = balances[from].sub(tokens);
182         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
183         balances[to] = balances[to].add(tokens);
184         emit Transfer(from, to, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account. The `spender` contract function
201     // `receiveApproval(...)` is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () public payable {
215         revert();
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Owner can transfer out any accidentally sent ERC20 tokens
221     // ------------------------------------------------------------------------
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 }
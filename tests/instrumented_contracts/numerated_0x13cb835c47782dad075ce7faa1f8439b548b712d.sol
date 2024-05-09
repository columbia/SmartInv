1 pragma solidity ^0.5.7;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : LENS
5 // Name        : LENS Platform
6 // Total supply: 30,000,000,000.00000000
7 // Decimals    : 8
8 //
9 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC20 Token, with the addition of symbol, name and decimals and a
95 // fixed supply
96 // ----------------------------------------------------------------------------
97 contract LENS is ERC20Interface, Owned {
98     using SafeMath for uint;
99 
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     constructor() public {
113         symbol = "LENS";
114         name = "LENS Platform";
115         decimals = 8;
116         _totalSupply = 30000000000 * 10**uint(decimals);
117         balances[owner] = _totalSupply;
118         emit Transfer(address(0), owner, _totalSupply);
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public view returns (uint) {
126         return _totalSupply.sub(balances[address(0)]);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account `tokenOwner`
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public view returns (uint balance) {
134         return balances[tokenOwner];
135     }
136     
137     
138     
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to `to` account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         //prevent transfer to 0x0 (burn)
148         require(to != address(0x0));
149         //check if sender has enough
150         require(balances[msg.sender] >= tokens);
151         //check for overflow
152         require(balances[to] + tokens >= balances[to]);
153         
154         balances[msg.sender] = balances[msg.sender].sub(tokens);
155         balances[to] = balances[to].add(tokens);
156         emit Transfer(msg.sender, to, tokens);
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
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     //
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = balances[from].sub(tokens);
187         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         emit Transfer(from, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for `spender` to transferFrom(...) `tokens`
205     // from the token owner's account. The `spender` contract function
206     // `receiveApproval(...)` is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         emit Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Don't accept ETH
218     // ------------------------------------------------------------------------
219     function () external payable {
220         revert();
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }
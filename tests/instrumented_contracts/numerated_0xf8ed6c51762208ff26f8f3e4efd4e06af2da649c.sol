1 pragma solidity ^0.5.0;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33     function totalSupply() public view returns (uint256);
34     function balanceOf(address tokenOwner) public view returns (uint256 balance);
35     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
36     function transfer(address to, uint256 tokens) public returns (bool success);
37     function approve(address spender, uint256 tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint256 tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // Contract function to receive approval and execute function in one call
47 //
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and a
87 // fixed supply
88 // ----------------------------------------------------------------------------
89 contract FixedSupplyToken is ERC20Interface, Owned {
90     using SafeMath for uint256;
91 
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint256 _totalSupply;
96 
97     mapping(address => uint256) balances;
98     mapping(address => mapping(address => uint256)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     constructor() public {
105         symbol = "AXA";
106         name = "ALLDEX Alliance";
107         decimals = 18;
108         _totalSupply = 10**10 * 10**uint256(decimals);
109         balances[owner] = _totalSupply;
110         emit Transfer(address(0), owner, _totalSupply);
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Total supply
116     // ------------------------------------------------------------------------
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply.sub(balances[address(0)]);
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Get the token balance for account `tokenOwner`
124     // ------------------------------------------------------------------------
125     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
126         return balances[tokenOwner];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transfer(address to, uint256 tokens) public returns (bool success) {
136         balances[msg.sender] = balances[msg.sender].sub(tokens);
137         balances[to] = balances[to].add(tokens);
138         emit Transfer(msg.sender, to, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Token owner can approve for `spender` to transferFrom(...) `tokens`
145     // from the token owner's account
146     //
147     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
148     // recommends that there are no checks for the approval double-spend attack
149     // as this should be implemented in user interfaces
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint256 tokens) public returns (bool success) {
152         require((tokens == 0) || (allowed [msg.sender][spender] == 0));
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer `tokens` from the `from` account to the `to` account
161     //
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the `from` account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
169         balances[from] = balances[from].sub(tokens);
170         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
171         balances[to] = balances[to].add(tokens);
172         emit Transfer(from, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account. The `spender` contract function
189     // `receiveApproval(...)` is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         emit Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () external payable {
203         revert();
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }
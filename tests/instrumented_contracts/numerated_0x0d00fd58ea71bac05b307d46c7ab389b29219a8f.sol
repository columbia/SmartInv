1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and an
86 // initial fixed supply
87 // ----------------------------------------------------------------------------
88 contract PhipsiToken is ERC20Interface, Owned {
89     using SafeMath for uint;
90 
91     string public symbol;
92     string public  name;
93     string public  description;
94     uint8 public decimals;
95     uint public _totalSupply;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     function PhipsiToken() public {
105         symbol = "PHIPS";
106         name = "PhipsiToken";
107         description = "The best ERC20 token in the world! You can call it Phips, PhipsiCoin or PhipsiToken!";
108         decimals = 2;
109         _totalSupply = 1000 * 10**uint(decimals);
110         balances[owner] = _totalSupply;
111         Transfer(address(0), owner, _totalSupply);
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply  - balances[address(0)];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer the balance from token owner's account to `to` account
133     // - Owner's account must have sufficient balance to transfer
134     // - 0 value transfers are allowed
135     // ------------------------------------------------------------------------
136     function transfer(address to, uint tokens) public returns (bool success) {
137         balances[msg.sender] = balances[msg.sender].sub(tokens);
138         balances[to] = balances[to].add(tokens);
139         Transfer(msg.sender, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for `spender` to transferFrom(...) `tokens`
146     // from the token owner's account
147     //
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces 
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         Approval(msg.sender, spender, tokens);
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
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = balances[from].sub(tokens);
170         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
171         balances[to] = balances[to].add(tokens);
172         Transfer(from, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account. The `spender` contract function
189     // `receiveApproval(...)` is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () public payable {
203         revert();
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }
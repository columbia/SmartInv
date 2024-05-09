1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and an
85 // initial fixed supply
86 // ----------------------------------------------------------------------------
87 contract Infinity is ERC20Interface, Owned {
88     using SafeMath for uint;
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public number_of_token;
93     uint public _totalSupply;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97 
98 
99     // ------------------------------------------------------------------------
100     // Constructor
101     // ------------------------------------------------------------------------
102     function Infinity() public {
103         //address_owner = 0x478c986aEa9e1b462c07db6044f597E9e5FF49C4;
104         symbol = "INY";
105         name = "INFINITY TOKEN";
106         decimals = 8;
107         number_of_token = 65000000000;
108         _totalSupply = number_of_token*10**uint(decimals);
109         balances[0x478c986aEa9e1b462c07db6044f597E9e5FF49C4] = _totalSupply;
110         Transfer(address(0), 0x478c986aEa9e1b462c07db6044f597E9e5FF49C4, _totalSupply);
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Total supply
116     // ------------------------------------------------------------------------
117     function totalSupply() public constant returns (uint) {
118         return _totalSupply  - balances[address(0)];
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Get the token balance for account `tokenOwner`
124     // ------------------------------------------------------------------------
125     function balanceOf(address tokenOwner) public constant returns (uint balance) {
126         return balances[tokenOwner];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transfer(address to, uint tokens) public returns (bool success) {
136         balances[msg.sender] = balances[msg.sender].sub(tokens);
137         balances[to] = balances[to].add(tokens);
138         Transfer(msg.sender, to, tokens);
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
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer `tokens` from the `from` account to the `to` account
160     // 
161     // The calling account must already have sufficient tokens approve(...)-d
162     // for spending from the `from` account and
163     // - From account must have sufficient balance to transfer
164     // - Spender must have sufficient allowance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = balances[from].sub(tokens);
169         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
170         balances[to] = balances[to].add(tokens);
171         Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for `spender` to transferFrom(...) `tokens`
187     // from the token owner's account. The `spender` contract function
188     // `receiveApproval(...)` is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Don't accept ETH
200     // ------------------------------------------------------------------------
201     function () public payable {
202         revert();
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Owner can transfer out any accidentally sent ERC20 tokens
208     // ------------------------------------------------------------------------
209     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
210         return ERC20Interface(tokenAddress).transfer(owner, tokens);
211     }
212 }
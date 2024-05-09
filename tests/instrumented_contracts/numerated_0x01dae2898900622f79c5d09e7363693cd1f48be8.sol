1 pragma solidity ^0.4.20;
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
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Contract function to receive approval and execute function in one call
43 //
44 // Borrowed from MiniMeToken
45 // ----------------------------------------------------------------------------
46 
47 interface ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token) external;
49 }
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 TRT Token
83 // ----------------------------------------------------------------------------
84 contract TRLToken is ERC20Interface, Owned {
85     using SafeMath for uint;
86 
87     string public constant symbol = "TRL";
88     string public constant name = "Trial token";
89     uint8 public constant decimals = 0;
90     uint256 public constant _totalSupply = 1000000000 * 10**uint(decimals);
91     
92     
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     function TRLToken() public {
101         balances[owner] = _totalSupply;
102     }
103 
104 
105     // ------------------------------------------------------------------------
106     // Total supply
107     // ------------------------------------------------------------------------
108     function totalSupply() public constant returns (uint) {
109         return _totalSupply;
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Get the token balance for account `tokenOwner`
115     // ------------------------------------------------------------------------
116     function balanceOf(address tokenOwner) public constant returns (uint balance) {
117         return balances[tokenOwner];
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Transfer the balance from token owner's account to `to` account
123     // - Owner's account must have sufficient balance to transfer
124     // - 0 value transfers are allowed
125     // ------------------------------------------------------------------------
126     function transfer(address to, uint tokens) public returns (bool success) {
127         balances[msg.sender] = balances[msg.sender].sub(tokens);
128         balances[to] = balances[to].add(tokens);
129         Transfer(msg.sender, to, tokens);
130         return true;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Token owner can approve for `spender` to transferFrom(...) `tokens`
136     // from the token owner's account
137     //
138     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
139     // recommends that there are no checks for the approval double-spend attack
140     // as this should be implemented in user interfaces 
141     // ------------------------------------------------------------------------
142     function approve(address spender, uint tokens) public returns (bool success) {
143         require(balances[msg.sender] >= tokens);
144         allowed[msg.sender][spender] = tokens;
145         Approval(msg.sender, spender, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Transfer `tokens` from the `from` account to the `to` account
152     // 
153     // The calling account must already have sufficient tokens approve(...)-d
154     // for spending from the `from` account and
155     // - From account must have sufficient balance to transfer
156     // - Spender must have sufficient allowance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
160         balances[from] = balances[from].sub(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         Transfer(from, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Don't accept ETH
179     // ------------------------------------------------------------------------
180     function () public payable {
181         revert();
182     }
183 
184     function approveAndCall (address spender, uint tokens) public returns (bool success) {
185         require(balances[msg.sender] >= tokens);
186         allowed[msg.sender][spender] = tokens;
187         Approval(msg.sender, spender, tokens);
188         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this);
189         return true;
190     }
191 
192     // ------------------------------------------------------------------------
193     // Owner can transfer out any accidentally sent ERC20 tokens
194     // ------------------------------------------------------------------------
195     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
196         return ERC20Interface(tokenAddress).transfer(owner, tokens);
197     }
198 }
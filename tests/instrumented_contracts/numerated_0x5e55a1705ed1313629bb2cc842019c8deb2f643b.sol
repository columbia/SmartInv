1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         c = a + b;
10         require(c >= a);
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         require(b <= a);
15         c = a - b;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint256);
36     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
38     function transfer(address to, uint256 tokens) public returns (bool success);
39     function approve(address spender, uint256 tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint256 tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
44     event Burn(address indexed from, uint256 value);
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Contract function to receive approval and execute function in one call
50 // ----------------------------------------------------------------------------
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77 
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and an
89 // initial fixed supply of 5 Billion
90 // ----------------------------------------------------------------------------
91 contract SubajToken is ERC20Interface, Owned {
92     using SafeMath for uint256;
93 
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint256 public _totalSupply;
98 
99     mapping(address => uint256) balances;
100     mapping(address => mapping(address => uint256)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     
107     function SubajToken() public {
108         symbol = "SBJ";
109         name = "SUBAJ";
110         decimals = 10;
111         _totalSupply = 5000000000 * 10**uint256(decimals);
112         balances[owner] = _totalSupply;
113         emit Transfer(address(0), owner, _totalSupply);
114     }
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint256) {
120         return _totalSupply - balances[address(0)];
121     }
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
127         return balances[tokenOwner];
128     }
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // ------------------------------------------------------------------------
134     function transfer(address to, uint256 tokens) public returns (bool success) {
135         require(to != address(0));
136         require(tokens != 0);
137         require(tokens <= balances[msg.sender]);
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account 
148     // ------------------------------------------------------------------------
149     function approve(address spender, uint256 tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account. The `spender` contract function
159     // `receiveApproval(...)` is then executed
160     // ------------------------------------------------------------------------
161     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
165         return true;
166     }
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     // 
171     // The calling account must already have sufficient tokens approve(...)
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
177         require(to != address(0));
178         require(tokens != 0);
179         require(tokens <= balances[from]);
180         require(tokens <= allowed[from][msg.sender]);
181         
182         balances[from] = balances[from].sub(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         balances[to] = balances[to].add(tokens);
185         emit Transfer(from, to, tokens);
186         return true;
187     }
188 
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197     /*Decreasing totalSupply*/
198     function burn(uint256 token) public onlyOwner returns (bool success) { // only owner has authority to burn tokens        
199         if (balances[msg.sender] < token) revert(); // Check if the sender has enough
200         if (token <= 0) revert();
201         balances[msg.sender] = balances[msg.sender].sub(token);// Subtract from the sender
202         _totalSupply = _totalSupply.sub(token); // Updates totalSupply
203         emit Burn(msg.sender, token);
204         return true;
205     }
206 }
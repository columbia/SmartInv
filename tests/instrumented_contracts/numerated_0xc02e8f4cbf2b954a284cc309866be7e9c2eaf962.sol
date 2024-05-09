1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------
4 // Fixed supply ERC20 Token Contract
5 // symbol	        : POW
6 // name	            : Process of Wank Token
7 // total supply     : 100,000,000.000000000000000000
8 // decimals	        : 18
9 // ----------------------------------------------------------------
10 
11 // ----------------------------------------------------------------
12 // Safe Math
13 // ----------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a, "c must be >= a");
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a, "b must be <= a");
22         c = a - b;
23     }
24 
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b, "a must = 0 or c / a must = b");
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require (b > 0, "b must be > 0");
32         c = a / b;
33     }
34 }
35 
36 // ----------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // ----------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public view returns (uint);
41     function balanceOf(address tokenOwner) public view returns (uint balance);
42     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);    
48 }
49 
50 // ----------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 // ----------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
55 }
56 
57 // ----------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63     
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65     
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner, "only the contract owner can perform this function");
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78 
79     function acceptOwnership() public {
80         require(msg.sender == newOwner, "only the new contract owner can perform this function");
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 // ----------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and
89 // a fixed supply
90 // ----------------------------------------------------------------
91 contract PoWToken is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public name;
96     uint8 public decimals;
97     uint _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102     // ----------------------------------------------------------------
103     // Constructor
104     // ----------------------------------------------------------------
105     constructor() public {
106         symbol = "POW";
107         name = "Process of Wank Token";
108         decimals = 18;
109         _totalSupply = 100000000 * 10**uint(decimals);
110         balances[owner] = _totalSupply;
111         emit Transfer(address(0), owner, _totalSupply);
112     }
113 
114     // ----------------------------------------------------------------
115     // Total token supply
116     // ----------------------------------------------------------------
117     function totalSupply() public view returns (uint) {
118         return _totalSupply.sub(balances[address(0)]);
119     }
120 
121     // ----------------------------------------------------------------
122     // Get the token balance for account `tokenOwner`
123     // ----------------------------------------------------------------
124     function balanceOf(address tokenOwner) public view returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128     // ----------------------------------------------------------------
129     // Transfer the balance from token owner's account to `to` account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ----------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         balances[msg.sender] = balances[msg.sender].sub(tokens);
135         balances[to] = balances[to].add(tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140     // ----------------------------------------------------------------
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account
143     // ----------------------------------------------------------------
144     function approve(address spender, uint tokens) public returns (bool success) {
145         allowed[msg.sender][spender] = tokens;
146         emit Approval(msg.sender, spender, tokens);
147         return true;
148     }
149 
150     // ----------------------------------------------------------------
151     // Transfer `tokens` from the `from` account to the `to` account
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the `from` account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // - 0 value transfers are allowed
157     // ----------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
159         balances[from] = balances[from].sub(tokens);
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(from, to, tokens);
163         return true;
164     }
165 
166     // ----------------------------------------------------------------
167     // Returns the amount of tokens approved by the owner that can be
168     // transferred to the spender's account
169     // ----------------------------------------------------------------
170     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
171         return allowed[tokenOwner][spender];
172     }
173 
174     // ----------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account. The `spender` contract function
177     // `receiveApproval(...)` is then executed
178     // ----------------------------------------------------------------
179     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);
182         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
183         return true;
184     }
185 
186     // ----------------------------------------------------------------
187     // Owner can transfer out any accidentally sent ERC20 tokens
188     // ----------------------------------------------------------------
189     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
190         return ERC20Interface(tokenAddress).transfer(owner, tokens);
191     }
192 
193     // ----------------------------------------------------------------
194     // Accept ether
195     // ----------------------------------------------------------------
196     function () public payable {
197     }
198 
199     // ----------------------------------------------------------------
200     // Owner can withdraw ether that was sent to this contract
201     // ----------------------------------------------------------------
202     function withdrawEther(uint amount) public onlyOwner returns (bool success) {
203         owner.transfer(amount);
204         return true;
205     }
206 }
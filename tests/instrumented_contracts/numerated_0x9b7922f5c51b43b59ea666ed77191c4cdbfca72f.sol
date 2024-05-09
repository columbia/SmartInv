1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // Contract function to receive approval and execute function in one call
39 //
40 // Borrowed from MiniMeToken
41 // ----------------------------------------------------------------------------
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Owned contract
49 // ----------------------------------------------------------------------------
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and assisted
79 // token transfers
80 // ----------------------------------------------------------------------------
81 contract VCPcoin is ERC20Interface, Owned, SafeMath {
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     // ------------------------------------------------------------------------
92     // Constructor
93     // ------------------------------------------------------------------------
94     constructor() public {
95         symbol = "VCP";
96         name = "VCP Coin";
97         decimals = 18;
98         _totalSupply = 1 * 10**6 * 10**uint256(decimals);       
99  balances[0x495E2F6fBD5fD0462cC7a43c4B0B294fE9A7FB7C] = _totalSupply;
100         emit Transfer(address(0), 0x495E2F6fBD5fD0462cC7a43c4B0B294fE9A7FB7C, _totalSupply);
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Total supply
106     // ------------------------------------------------------------------------
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply  - balances[address(0)];
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Get the token balance for account tokenOwner
114     // ------------------------------------------------------------------------
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Transfer the balance from token owner's account to to account
122     // - Owner's account must have sufficient balance to transfer
123     // - 0 value transfers are allowed
124     // ------------------------------------------------------------------------
125     function transfer(address to, uint tokens) public returns (bool success) {
126         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(msg.sender, to, tokens);
129         return true;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Token owner can approve for spender to transferFrom(...) tokens
135     // from the token owner's account
136     //
137     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
138     // recommends that there are no checks for the approval double-spend attack
139     // as this should be implemented in user interfaces 
140     // ------------------------------------------------------------------------
141     function approve(address spender, uint tokens) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         emit Approval(msg.sender, spender, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer tokens from the from account to the to account
150     // 
151     // The calling account must already have sufficient tokens approve(...)-d
152     // for spending from the from account and
153     // - From account must have sufficient balance to transfer
154     // - Spender must have sufficient allowance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         balances[from] = safeSub(balances[from], tokens);
159         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
160         balances[to] = safeAdd(balances[to], tokens);
161         emit Transfer(from, to, tokens);
162         return true;
163     }
164      // Devuelve la cantidad de tokens aprobados por el propietario que puede ser
165      // transferido a la cuenta del gastador
166 
167     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
168         return allowed[tokenOwner][spender];
169     }
170     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
174         return true;
175     }
176     function () public payable {
177         revert();
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Owner can transfer out any accidentally sent ERC20 tokens
183     // ------------------------------------------------------------------------
184     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
185         return ERC20Interface(tokenAddress).transfer(owner, tokens);
186     }
187 }
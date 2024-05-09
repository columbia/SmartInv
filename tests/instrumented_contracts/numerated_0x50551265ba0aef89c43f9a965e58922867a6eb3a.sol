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
84 contract GACT is ERC20Interface, Owned {
85     using SafeMath for uint;
86 
87     string public symbol;
88     string public  name;
89     uint8 public decimals = 8;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99 	
100 	 function GACT() public {
101         _totalSupply = 	4000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
102         balances[owner] = _totalSupply;              // Give the creator all initial tokens
103         name = "GoldAgriculturalChain";                                   // Set the name for display purposes
104         symbol = "GACT";                               // Set the symbol for display purposes
105 		Transfer(address(0), owner, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // ------------------------------------------------------------------------
112     function totalSupply() public constant returns (uint) {
113         return _totalSupply  - balances[address(0)];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account `tokenOwner`
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Transfer the balance from token owner's account to `to` account
127     // - Owner's account must have sufficient balance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = balances[msg.sender].sub(tokens);
132         balances[to] = balances[to].add(tokens);
133         Transfer(msg.sender, to, tokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for `spender` to transferFrom(...) `tokens`
140     // from the token owner's account
141     //
142     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143     // recommends that there are no checks for the approval double-spend attack
144     // as this should be implemented in user interfaces 
145     // ------------------------------------------------------------------------
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer `tokens` from the `from` account to the `to` account
155     // 
156     // The calling account must already have sufficient tokens approve(...)-d
157     // for spending from the `from` account and
158     // - From account must have sufficient balance to transfer
159     // - Spender must have sufficient allowance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
163         balances[from] = balances[from].sub(tokens);
164         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
165         balances[to] = balances[to].add(tokens);
166         Transfer(from, to, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Returns the amount of tokens approved by the owner that can be
173     // transferred to the spender's account
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account. The `spender` contract function
183     // `receiveApproval(...)` is then executed
184     // ------------------------------------------------------------------------
185     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         Approval(msg.sender, spender, tokens);
188         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Don't accept ETH
195     // ------------------------------------------------------------------------
196     function () public payable {
197         revert();
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Owner can transfer out any accidentally sent ERC20 tokens
203     // ------------------------------------------------------------------------
204     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
205         return ERC20Interface(tokenAddress).transfer(owner, tokens);
206     }
207 }
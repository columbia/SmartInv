1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'BURN' 'Throw Away Your Money' token contract
5 //
6 // Symbol      : BURN
7 // Name        : Throw Away Your Money
8 // Decimals    : 18
9 //
10 // "0x0000000000000000000000000000000000000000 is the place to be for your Eth!"
11 //    -Cryptopinions
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // ERC20 Token, with the addition of symbol, name and decimals and a
68 // fixed supply
69 // ----------------------------------------------------------------------------
70 contract BURNToken is ERC20Interface {
71     using SafeMath for uint;
72 
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     // ------------------------------------------------------------------------
83     // Constructor
84     // ------------------------------------------------------------------------
85     constructor() public {
86         symbol = "BURN";
87         name = "Throw Away Your Money";
88         decimals = 18;
89         _totalSupply = 1 * 10**uint(decimals); //just gonna use this to seed the market dont worry not a premine I swear
90         balances[msg.sender] = _totalSupply;
91         emit Transfer(address(0), msg.sender, _totalSupply);
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Total supply
97     // ------------------------------------------------------------------------
98     function totalSupply() public view returns (uint) {
99         return _totalSupply.sub(balances[address(0)]);
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Get the token balance for account `tokenOwner`
105     // ------------------------------------------------------------------------
106     function balanceOf(address tokenOwner) public view returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Transfer the balance from token owner's account to `to` account
113     // - Owner's account must have sufficient balance to transfer
114     // - 0 value transfers are allowed
115     // ------------------------------------------------------------------------
116     function transfer(address to, uint tokens) public returns (bool success) {
117         balances[msg.sender] = balances[msg.sender].sub(tokens);
118         balances[to] = balances[to].add(tokens);
119         emit Transfer(msg.sender, to, tokens);
120         return true;
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Token owner can approve for `spender` to transferFrom(...) `tokens`
126     // from the token owner's account
127     //
128     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
129     // recommends that there are no checks for the approval double-spend attack
130     // as this should be implemented in user interfaces
131     // ------------------------------------------------------------------------
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer `tokens` from the `from` account to the `to` account
141     //
142     // The calling account must already have sufficient tokens approve(...)-d
143     // for spending from the `from` account and
144     // - From account must have sufficient balance to transfer
145     // - Spender must have sufficient allowance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         balances[from] = balances[from].sub(tokens);
150         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
151         balances[to] = balances[to].add(tokens);
152         emit Transfer(from, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Returns the amount of tokens approved by the owner that can be
159     // transferred to the spender's account
160     // ------------------------------------------------------------------------
161     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
162         return allowed[tokenOwner][spender];
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for `spender` to transferFrom(...) `tokens`
168     // from the token owner's account. The `spender` contract function
169     // `receiveApproval(...)` is then executed
170     // ------------------------------------------------------------------------
171     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Your Eth is gone forever but at least you get a consolation prize
181     // ------------------------------------------------------------------------
182     function burn() public payable{
183       balances[msg.sender] += msg.value;
184       _totalSupply += msg.value;
185       address(0).transfer(msg.value);
186       emit Transfer(address(0), msg.sender, _totalSupply);
187     }
188     function () public payable {
189       burn();
190     }
191 
192 }
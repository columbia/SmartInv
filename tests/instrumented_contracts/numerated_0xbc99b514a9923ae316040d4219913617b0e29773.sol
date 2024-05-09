1 pragma solidity 0.4.24;
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
12     
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17 
18     function mul(uint a, uint b) internal pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22 
23     function div(uint a, uint b) internal pure returns (uint c) {
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
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC20 Token, with the addition of symbol, name and decimals and a
49 // fixed supply
50 // ----------------------------------------------------------------------------
51 contract BCCT is ERC20Interface {
52     using SafeMath for uint;
53     
54     address public owner;
55     string public symbol = "BCCT";
56     string public name = "Beverage Cash Coin";
57     uint8 public decimals = 18;
58     // 150,235,700,000,000,000,000,000,000 (the same as wei):
59     uint private _totalSupply = 150425700 * 10**uint(decimals);
60 
61     mapping(address => uint) private balances;
62     mapping(address => mapping(address => uint)) private allowed;
63     
64     constructor() public {
65         owner = msg.sender;
66         balances[owner] = _totalSupply;
67         emit Transfer(address(0), owner, _totalSupply);
68     }
69 
70     // ------------------------------------------------------------------------
71     // Allows execution of function only for owner of smart-contract
72     // ------------------------------------------------------------------------
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77     
78     // ------------------------------------------------------------------------
79     // Allows execution only if the request is properly formed to prevent short address attacks
80     // ------------------------------------------------------------------------
81     modifier onlyPayloadSize(uint size) {
82         require(msg.data.length >= size + 4); // add 4 bytes for function signature
83         _;
84     }
85     
86     // ------------------------------------------------------------------------
87     // Perform several transfers from smart contract owner's account to `to` accounts.
88     // Useful during ICO to save gas on base transaction costs.
89     // - Owner's account must have sufficient balance to transfer
90     // - 0 value transfers are allowed
91     // ------------------------------------------------------------------------
92     function transferQueue(address[] to, uint[] amount) public onlyOwner returns (bool success) {
93         require(to.length == amount.length);
94         
95         for (uint64 i = 0; i < to.length; ++i) {
96             _transfer(msg.sender, to[i], amount[i]);
97         }
98         
99         return true;
100     }
101 
102     // ------------------------------------------------------------------------
103     // Owner can transfer out any accidentally sent ERC20 tokens
104     // ------------------------------------------------------------------------
105     function transferAnyERC20Token(address tokenAddress, uint tokens) 
106         public 
107         onlyOwner 
108         onlyPayloadSize(32 + 32) // 32 bytes for address + 32 bytes for tokens
109         returns (bool success) 
110     {
111         return ERC20Interface(tokenAddress).transfer(owner, tokens);
112     }
113 
114     // ------------------------------------------------------------------------
115     // ERC-20: Total supply in accounts
116     // ------------------------------------------------------------------------
117     function totalSupply() public view returns (uint) {
118         return _totalSupply.sub(balances[address(0)]);
119     }
120 
121     // ------------------------------------------------------------------------
122     // ERC-20: Get the token balance for account `tokenOwner`
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public view returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128     // ------------------------------------------------------------------------
129     // ERC-20: Transfer the balance from token owner's account to `to` account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) 
134         public 
135         onlyPayloadSize(32 + 32) // 32 bytes for to + 32 bytes for tokens
136         returns (bool success) 
137     {
138         _transfer(msg.sender, to, tokens);
139         return true;
140     }
141 
142     // ------------------------------------------------------------------------
143     // ERC-20: Token owner can approve for `spender` to transferFrom(...) `tokens`
144     // from the token owner's account
145     //
146     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
147     // recommends that there are no checks for the approval double-spend attack
148     // as this should be implemented in user interfaces 
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) 
151         public 
152         onlyPayloadSize(32 + 32) // 32 bytes for spender + 32 bytes for tokens
153         returns (bool success) 
154     {
155         require(balances[msg.sender] >= tokens);
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161     // ------------------------------------------------------------------------
162     // ERC-20: Transfer `tokens` from the `from` account to the `to` account
163     // 
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) 
171         public 
172         onlyPayloadSize(32 + 32 + 32) // 32 bytes for from + 32 bytes for to + 32 bytes for tokens
173         returns (bool success) 
174     {
175         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
176         _transfer(from, to, tokens);
177         return true;
178     }
179 
180     // ------------------------------------------------------------------------
181     // ERC-20: Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187     
188     // ------------------------------------------------------------------------
189     // Internal transfer function for calling from the contract. 
190     // Workaround for issues with payload size checking in internal calls.
191     // ------------------------------------------------------------------------
192     function _transfer(address from, address to, uint tokens) internal {
193         balances[from] = balances[from].sub(tokens);
194         balances[to] = balances[to].add(tokens);
195         emit Transfer(from, to, tokens);
196     }
197 }
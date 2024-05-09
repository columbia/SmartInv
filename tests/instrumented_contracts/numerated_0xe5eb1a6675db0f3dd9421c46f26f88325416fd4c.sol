1 // Complete Brain Optimization: https://allysian.com/
2 pragma solidity ^0.4.18;
3 
4 // ----------------------------------------------------------------------------
5 //
6 // Symbol      : ALN
7 // Name        : Allysian Token
8 // Max Supply  : 1,000,000,000.00000000
9 // Decimals    : 8
10 //
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52     event Mint(uint256 amount, address indexed to);
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
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71 
72     function Owned() public {
73         owner = 0x27695Bd50e39904acDDb26653d13Ca13BD0d0064;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and an
85 // initial fixed supply
86 // ----------------------------------------------------------------------------
87 contract Allysian is ERC20Interface, Owned {
88     using SafeMath for uint256;
89 
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint public _maxSupply;
94     uint public _circulatingSupply;
95     mapping (address => uint256) public balances;
96     mapping (address => mapping (address => uint256)) public allowed;
97 
98 
99     // ------------------------------------------------------------------------
100     // Constructor
101     // ------------------------------------------------------------------------
102     function Allysian() public {
103         symbol = "ALN";
104         name = "Allysian Token";
105         decimals = 8;
106         _maxSupply = 1000000000 * 10**uint(decimals); //1 billion
107         _circulatingSupply = 10000000 * 10**uint(decimals); //10 million
108         balances[owner] = _circulatingSupply;
109         emit Transfer(address(0), owner, _circulatingSupply);
110     }
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public constant returns (uint) {
116         return _circulatingSupply  - balances[address(0)];
117     }
118 
119     // ------------------------------------------------------------------------
120     // Max supply
121     // ------------------------------------------------------------------------
122     function maxSupply() public constant returns (uint) {
123         return _maxSupply  - balances[address(0)];
124     }
125 
126     function mint(address _to, uint256 amount) public onlyOwner returns (bool) {
127         require( _circulatingSupply.add(amount) <= _maxSupply && _to != address(0));
128         _circulatingSupply = _circulatingSupply.add(amount);
129         balances[_to] = balances[_to].add(amount);
130         emit Mint(amount, _to);
131         return true;
132     }
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public constant returns (uint balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         emit Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer `tokens` from the `from` account to the `to` account
163     //
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = balances[from].sub(tokens);
172         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
173         balances[to] = balances[to].add(tokens);
174         emit Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187     // ------------------------------------------------------------------------
188     // Don't accept ETH
189     // ------------------------------------------------------------------------
190     function () public payable {
191         revert();
192     }
193 
194     // ------------------------------------------------------------------------
195     // Owner can transfer out any accidentally sent ERC20 tokens
196     // ------------------------------------------------------------------------
197     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
198         return ERC20Interface(tokenAddress).transfer(owner, tokens);
199     }
200 }
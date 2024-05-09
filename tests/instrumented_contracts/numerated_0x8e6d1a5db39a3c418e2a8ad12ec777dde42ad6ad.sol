1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'WSKY' 'Whiskey Token' token contract
5 //
6 // Symbol      : WSKY
7 // Name        : Whiskey Token
8 // Total supply: 9,600,000.000000
9 // Decimals    : 6
10 //
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
12 // (c) Anlide / DDI Development 2018.
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
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
52 }
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and an
94 // initial fixed supply
95 // WSKY - token
96 // ----------------------------------------------------------------------------
97 contract WSKYToken is ERC20Interface, Owned {
98     using SafeMath for uint;
99 
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     function WSKYToken() public {
112         symbol = "WSKY";
113         name = "Whiskey Token";
114         decimals = 6;
115         _totalSupply = 9600000 * 10**uint(decimals);
116         balances[owner] = _totalSupply;
117         emit Transfer(address(0), owner, _totalSupply);
118     }
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public constant returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account `tokenOwner`
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = balances[msg.sender].sub(tokens);
141         balances[to] = balances[to].add(tokens);
142         emit Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for `spender` to transferFrom(...) `tokens`
148     // from the token owner's account
149     //
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
151     // recommends that there are no checks for the approval double-spend attack
152     // as this should be implemented in user interfaces
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         emit Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     //
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the `from` account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = balances[from].sub(tokens);
171         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
172         balances[to] = balances[to].add(tokens);
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for `spender` to transferFrom(...) `tokens`
187     // from the token owner's account. The `spender` contract function
188     // `receiveApproval(...)` is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         emit Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197     // ------------------------------------------------------------------------
198     // Don't accept ETH
199     // ------------------------------------------------------------------------
200     function () public payable {
201         revert();
202     }
203 
204     // ------------------------------------------------------------------------
205     // Owner can transfer out any accidentally sent ERC20 tokens
206     // ------------------------------------------------------------------------
207     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
208         return ERC20Interface(tokenAddress).transfer(owner, tokens);
209     }
210 }
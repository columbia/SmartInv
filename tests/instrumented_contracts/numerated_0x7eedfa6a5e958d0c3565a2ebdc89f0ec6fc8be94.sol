1 pragma solidity ^0.5.4;
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
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract JQToken is ERC20Interface, Owned {
87     using SafeMath for uint;
88     
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96 
97 
98     // ------------------------------------------------------------------------
99     // Constructor
100     // ------------------------------------------------------------------------
101     constructor() public {
102         symbol = "JQT";
103         name = "JQT Token";
104         decimals = 8;
105         _totalSupply = 50000000000 * 10**uint(decimals);
106         balances[0x951F5b0D55605C5e614a727b4171Ef4eDbfCfd7e] = _totalSupply;
107         emit Transfer(address(0), 0x951F5b0D55605C5e614a727b4171Ef4eDbfCfd7e, _totalSupply);
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Total supply
113     // ------------------------------------------------------------------------
114     function totalSupply() public view returns (uint) {
115         return _totalSupply.sub(balances[address(0)]);
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account tokenOwner
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public view returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Transfer the balance from token owner's account to to account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ------------------------------------------------------------------------
132     function transfer(address to, uint tokens) public returns (bool success) {
133         balances[msg.sender] = balances[msg.sender].sub(tokens);
134         balances[to] = balances[to].add(tokens);
135         emit Transfer(msg.sender, to, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for spender to transferFrom(...) tokens
142     // from the token owner's account
143     //
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer tokens from the from account to the to account
154     // 
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the from account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = balances[from].sub(tokens);
163         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
164         balances[to] = balances[to].add(tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for spender to transferFrom(...) tokens
181     // from the token owner's account. The spender contract function
182     // receiveApproval(...) is then executed
183     // ------------------------------------------------------------------------
184     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Don't accept ETH
194     // ------------------------------------------------------------------------
195     function () external payable {
196         revert();
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Owner can transfer out any accidentally sent ERC20 tokens
202     // ------------------------------------------------------------------------
203     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
204         return ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }
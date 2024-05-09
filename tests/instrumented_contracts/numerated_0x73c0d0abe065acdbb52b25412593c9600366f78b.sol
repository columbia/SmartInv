1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 contract ERC20Interface {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // Contract function to receive approval and execute function in one call
38 //
39 // Borrowed from MiniMeToken
40 // ----------------------------------------------------------------------------
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and a
78 // fixed supply
79 // ----------------------------------------------------------------------------
80 contract WePoSToken is ERC20Interface, Owned {
81     using SafeMath for uint;
82 
83     string public symbol;
84     string public  name;
85     uint8 public decimals;
86     uint _totalSupply;
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91 
92     // ------------------------------------------------------------------------
93     // Constructor
94     // ------------------------------------------------------------------------
95     constructor() public {
96         symbol = "POS";
97         name = "WePoS";
98         decimals = 18;
99         _totalSupply = 100000000 * 10**uint(decimals);
100         balances[owner] = _totalSupply;
101         emit Transfer(address(0), owner, _totalSupply);
102     }
103 
104 
105     // ------------------------------------------------------------------------
106     // Total supply
107     // ------------------------------------------------------------------------
108     function totalSupply() public view returns (uint) {
109         return _totalSupply.sub(balances[address(0)]);
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Get the token balance for account `tokenOwner`
115     // ------------------------------------------------------------------------
116     function balanceOf(address tokenOwner) public view returns (uint balance) {
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
129         emit Transfer(msg.sender, to, tokens);
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
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer `tokens` from the `from` account to the `to` account
151     //
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the `from` account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
159         balances[from] = balances[from].sub(tokens);
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(from, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for `spender` to transferFrom(...) `tokens`
178     // from the token owner's account. The `spender` contract function
179     // `receiveApproval(...)` is then executed
180     // ------------------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Don't accept ETH
191     // ------------------------------------------------------------------------
192     function () external payable {
193         revert();
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Owner can transfer out any accidentally sent ERC20 tokens
199     // ------------------------------------------------------------------------
200     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
201         return ERC20Interface(tokenAddress).transfer(owner, tokens);
202     }
203 }
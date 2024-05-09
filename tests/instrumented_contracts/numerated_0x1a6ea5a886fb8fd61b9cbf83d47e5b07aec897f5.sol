1 pragma solidity ^0.5.0;
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
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public view returns (uint);
33     function balanceOf(address tokenOwner) public view returns (uint balance);
34     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
50     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
63     constructor() public {
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
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and a
86 // fixed supply
87 // ----------------------------------------------------------------------------
88 contract FixedSupplyToken is ERC20Interface, Owned {
89     using SafeMath for uint;
90 
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint _totalSupply;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor() public {
104         symbol = "FRCN";
105         name = "FreeCoin";
106         decimals = 18;
107         _totalSupply = 300000000 * 10**uint(decimals);
108         balances[0xA56c93A69e570Ba51B7b14360a61Fa3Eb23c84d8] = 300000000 * 10**uint(decimals);
109         emit Transfer(address(0), owner, 300000000 * 10**uint(decimals));
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Total supply
115     // ------------------------------------------------------------------------
116     function totalSupply() public view returns (uint) {
117         return _totalSupply.sub(balances[address(0)]);
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Get the token balance for account `tokenOwner`
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public view returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Transfer the balance from token owner's account to `to` account
131     // - Owner's account must have sufficient balance to transfer
132     // - 0 value transfers are allowed
133     // ------------------------------------------------------------------------
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = balances[msg.sender].sub(tokens);
136         balances[to] = balances[to].add(tokens);
137         emit Transfer(msg.sender, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Token owner can approve for `spender` to transferFrom(...) `tokens`
144     // from the token owner's account
145     //
146     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
147     // recommends that there are no checks for the approval double-spend attack
148     // as this should be implemented in user interfaces
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) public returns (bool success) {
151         allowed[msg.sender][spender] = tokens;
152         emit Approval(msg.sender, spender, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer `tokens` from the `from` account to the `to` account
159     //
160     // The calling account must already have sufficient tokens approve(...)-d
161     // for spending from the `from` account and
162     // - From account must have sufficient balance to transfer
163     // - Spender must have sufficient allowance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
167         balances[from] = balances[from].sub(tokens);
168         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
169         balances[to] = balances[to].add(tokens);
170         emit Transfer(from, to, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Returns the amount of tokens approved by the owner that can be
177     // transferred to the spender's account
178     // ------------------------------------------------------------------------
179     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
180         return allowed[tokenOwner][spender];
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for `spender` to transferFrom(...) `tokens`
186     // from the token owner's account. The `spender` contract function
187     // `receiveApproval(...)` is then executed
188     // ------------------------------------------------------------------------
189     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Don't accept ETH
199     // ------------------------------------------------------------------------
200     function () external payable {
201         revert();
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Owner can transfer out any accidentally sent ERC20 tokens
207     // ------------------------------------------------------------------------
208     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
209         return ERC20Interface(tokenAddress).transfer(owner, tokens);
210     }
211 }
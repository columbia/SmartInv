1 pragma solidity ^0.4.18;
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
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Contract function to receive approval and execute function in one call
42 //
43 // Borrowed from MiniMeToken
44 // ----------------------------------------------------------------------------
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Owned contract
52 // ----------------------------------------------------------------------------
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     function Owned() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71     function acceptOwnership() public {
72         require(msg.sender == newOwner);
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75         newOwner = address(0);
76     }
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // ERC20 Token, with the addition of symbol, name and decimals and a
82 // fixed supply
83 // ----------------------------------------------------------------------------
84 contract RideCoin is ERC20Interface, Owned {
85     using SafeMath for uint;
86 
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     function RideCoin() public {
100         symbol = "RIDE";
101         name = "RideCoin";
102         decimals = 18;
103         _totalSupply = 1100000000 * 10**uint(decimals);
104         balances[owner] = _totalSupply;
105         Transfer(address(0), owner, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // ------------------------------------------------------------------------
112     function totalSupply() public view returns (uint) {
113         return _totalSupply.sub(balances[address(0)]);
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account `tokenOwner`
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public view returns (uint balance) {
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
175     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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
208 
209 interface token {
210     function transfer(address receiver, uint amount) external;
211 }
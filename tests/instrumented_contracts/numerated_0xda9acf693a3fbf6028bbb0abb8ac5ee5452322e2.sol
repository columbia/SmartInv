1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'RR' 'Royal Ripple' token contract
5 //
6 // Symbol      : RR
7 // Name        : Royal Ripple
8 // Total supply: 50000000000.000000000000000000
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and an
93 // initial fixed supply
94 // ----------------------------------------------------------------------------
95 contract RRCoin is ERC20Interface, Owned {
96     using SafeMath for uint;
97 
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     function RRCoin() public {
111         symbol = "RR";
112         name = "Royal Ripple";
113         decimals = 18;
114         _totalSupply = 50000000000 * 10**uint(decimals);
115         balances[owner] = _totalSupply;
116         Transfer(address(0), owner, _totalSupply);
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public constant returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account `tokenOwner`
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public constant returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Transfer the balance from token owner's account to `to` account
138     // - Owner's account must have sufficient balance to transfer
139     // - 0 value transfers are allowed
140     // ------------------------------------------------------------------------
141     function transfer(address to, uint tokens) public returns (bool success) {
142         balances[msg.sender] = balances[msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         Transfer(msg.sender, to, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Token owner can approve for `spender` to transferFrom(...) `tokens`
151     // from the token owner's account
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Returns the amount of tokens approved by the owner that can be
174     // transferred to the spender's account
175     // ------------------------------------------------------------------------
176     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for `spender` to transferFrom(...) `tokens`
183     // from the token owner's account. The `spender` contract function
184     // `receiveApproval(...)` is then executed
185     // ------------------------------------------------------------------------
186     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         Approval(msg.sender, spender, tokens);
189         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Don't accept ETH
196     // ------------------------------------------------------------------------
197     function () public payable {
198         revert();
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Owner can transfer out any accidentally sent ERC20 tokens
204     // ------------------------------------------------------------------------
205     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
206         return ERC20Interface(tokenAddress).transfer(owner, tokens);
207     }
208 }
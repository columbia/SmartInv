1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // RetDime Token Contract
5 //
6 // Symbol      : RET
7 // Name        : RetDime
8 // Total supply: 10000000000
9 // Decimals    : 0
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
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
95 contract RetDime is ERC20Interface, Owned {
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
110     function RetDime() public {
111         symbol = "RET";
112         name = "RetDime";
113         decimals = 0;
114         _totalSupply = 10000000000;
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
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = balances[msg.sender].sub(tokens);
141         balances[to] = balances[to].add(tokens);
142         Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for `spender` to transferFrom(...) `tokens`
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) public returns (bool success) {
151         allowed[msg.sender][spender] = tokens;
152         Approval(msg.sender, spender, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer `tokens` from the `from` account to the `to` account
159     // ------------------------------------------------------------------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161         balances[from] = balances[from].sub(tokens);
162         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163         balances[to] = balances[to].add(tokens);
164         Transfer(from, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Returns the amount of tokens approved by the owner that can be
171     // transferred to the spender's account
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for `spender` to transferFrom(...) `tokens`
180     // from the token owner's account. The `spender` contract function
181     // `receiveApproval(...)` is then executed
182     // ------------------------------------------------------------------------
183     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         Approval(msg.sender, spender, tokens);
186         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Don't accept ETH
193     // ------------------------------------------------------------------------
194     function () public payable {
195         revert();
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Owner can transfer out any accidentally sent ERC20 tokens
201     // ------------------------------------------------------------------------
202     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
203         return ERC20Interface(tokenAddress).transfer(owner, tokens);
204     }
205 }
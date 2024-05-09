1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // KIMERA - token of the cenntury
5 // written by David Rainis, KIMERA LTD, Israel
6 // First blocked on: 1-Jan-2018 - a happy new year!!!
7 // ----------------------------------------------------------------------------
8 
9 
10 // ----------------------------------------------------------------------------
11 // Safe maths
12 // ----------------------------------------------------------------------------
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     // calling events for any transfer or a 3rd party approval
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract - defines the owner
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
95 contract KMRCTToken is ERC20Interface, Owned {
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
110     function KMRCTToken() public {
111         symbol = "KMRCT";
112         name = "KIMERA Century Token";
113         decimals = 2;
114         _totalSupply = 1000000 * 10**uint(decimals);
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
152     //
153     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154     // recommends that there are no checks for the approval double-spend attack
155     // as this should be implemented in user interfaces 
156     // ------------------------------------------------------------------------
157     function approve(address spender, uint tokens) public returns (bool success) {
158         allowed[msg.sender][spender] = tokens;
159         Approval(msg.sender, spender, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer `tokens` from the `from` account to the `to` account
166     // 
167     // The calling account must already have sufficient tokens approve(...)-d
168     // for spending from the `from` account and
169     // - From account must have sufficient balance to transfer
170     // - Spender must have sufficient allowance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174         balances[from] = balances[from].sub(tokens);
175         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
176         balances[to] = balances[to].add(tokens);
177         Transfer(from, to, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Returns the amount of tokens approved by the owner that can be
184     // transferred to the spender's account
185     // ------------------------------------------------------------------------
186     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
187         return allowed[tokenOwner][spender];
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Token owner can approve for `spender` to transferFrom(...) `tokens`
193     // from the token owner's account. The `spender` contract function
194     // `receiveApproval(...)` is then executed
195     // ------------------------------------------------------------------------
196     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Don't accept ETH
206     // ------------------------------------------------------------------------
207     function () public payable {
208         revert();
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Owner can transfer out any accidentally sent ERC20 tokens
214     // ------------------------------------------------------------------------
215     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
216         return ERC20Interface(tokenAddress).transfer(owner, tokens);
217     }
218 }
1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // sminem
6 // ----------------------------------------------------------------------------
7 
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
35 // ----------------------------------------------------------------------------
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     function Owned() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and an
91 // initial fixed supply
92 // ----------------------------------------------------------------------------
93 contract Token is ERC20Interface, Owned {
94     using SafeMath for uint;
95 
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     function Token() public {
109         symbol = "SMINEM";
110         name = "boy sminem cool";
111         decimals = 18;
112         _totalSupply = 1000000000 * 10**uint(decimals);
113         balances[owner] = _totalSupply;
114         Transfer(address(0), owner, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account `tokenOwner`
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
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
149     // from the token owner's account
150     //
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces 
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Transfer `tokens` from the `from` account to the `to` account
164     // 
165     // The calling account must already have sufficient tokens approve(...)-d
166     // for spending from the `from` account and
167     // - From account must have sufficient balance to transfer
168     // - Spender must have sufficient allowance to transfer
169     // - 0 value transfers are allowed
170     // ------------------------------------------------------------------------
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = balances[from].sub(tokens);
173         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
174         balances[to] = balances[to].add(tokens);
175         Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Token owner can approve for `spender` to transferFrom(...) `tokens`
191     // from the token owner's account. The `spender` contract function
192     // `receiveApproval(...)` is then executed
193     // ------------------------------------------------------------------------
194     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         Approval(msg.sender, spender, tokens);
197         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Don't accept ETH
204     // ------------------------------------------------------------------------
205     function () public payable {
206         revert();
207     }
208     
209     
210     // ------------------------------------------------------------------------
211     // Mint more xD
212     // ------------------------------------------------------------------------
213     function mint(uint tokens) public onlyOwner returns (bool success) {
214         _totalSupply += tokens * 10**uint(decimals);
215         balances[owner] += tokens;
216         Transfer(address(0), owner, tokens);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Owner can transfer out any accidentally sent ERC20 tokens
223     // ------------------------------------------------------------------------
224     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
225         return ERC20Interface(tokenAddress).transfer(owner, tokens);
226     }
227 }
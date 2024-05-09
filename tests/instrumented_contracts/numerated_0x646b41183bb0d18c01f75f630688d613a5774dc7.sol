1 pragma solidity ^0.5.0;
2 // ----------------------------------------------------------------------------
3 // BlueKey BKY token contract
4 // ----------------------------------------------------------------------------
5 
6 // ----------------------------------------------------------------------------
7 // Safe maths
8 // ----------------------------------------------------------------------------
9 
10 library SafeMath {
11 
12     function add(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function div(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
35 // ----------------------------------------------------------------------------
36 
37 contract ERC20Interface {
38     function totalSupply() public view returns (uint);
39     function balanceOf(address tokenOwner) public view returns (uint balance);
40     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46 
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48     event Burn(address indexed burner, uint256 value);
49 
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 
67 contract Owned {
68 
69     address public owner;
70     address public newOwner;
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85 
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and a
97 // fixed supply
98 // ----------------------------------------------------------------------------
99 
100 contract BLUEKEY is ERC20Interface, Owned {
101 
102     using SafeMath for uint;
103 
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116 
117     constructor() public {
118         symbol = "BKY";
119         name = "BLUEKEY";
120         decimals = 8;
121         _totalSupply = 10000000000e8;
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public view returns (uint) {
131         return _totalSupply.sub(balances[address(0)]);
132     }
133 
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public view returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149 
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172     // ------------------------------------------------------------------------
173     // Transfer `tokens` from the `from` account to the `to` account
174     //
175     // The calling account must already have sufficient tokens approve(...)-d
176     // for spending from the `from` account and
177     // - From account must have sufficient balance to transfer
178     // - Spender must have sufficient allowance to transfer
179     // - 0 value transfers are allowed
180 
181     // ------------------------------------------------------------------------
182 
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = balances[from].sub(tokens);
185         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
186         balances[to] = balances[to].add(tokens);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196 
197     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for `spender` to transferFrom(...) `tokens`
203     // from the token owner's account. The `spender` contract function
204     // `receiveApproval(...)` is then executed
205     // ------------------------------------------------------------------------
206 
207     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         emit Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
211         return true;
212     }
213 
214     function burn(uint256 _value) onlyOwner public {
215         require(_value <= balances[msg.sender]);   // Check if the sender has enough
216         address burner = msg.sender;
217         balances[burner] = balances[burner].sub(_value);
218         emit Burn(burner, _value);
219     }
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     function () external payable {
225         revert();
226     }
227 
228     // ------------------------------------------------------------------------
229     // Owner can transfer out any accidentally sent ERC20 tokens
230     // ------------------------------------------------------------------------
231 
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 }
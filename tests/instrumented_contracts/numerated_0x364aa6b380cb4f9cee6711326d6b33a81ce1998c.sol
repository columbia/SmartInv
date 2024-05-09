1 pragma solidity 0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // Safe maths
7 
8 // ----------------------------------------------------------------------------
9 
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 // ----------------------------------------------------------------------------
30 // ERC Token Standard #20 Interface
31 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
32 // ----------------------------------------------------------------------------
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 //
49 // Borrowed from MiniMeToken
50 // ----------------------------------------------------------------------------
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Owned contract
58 // ----------------------------------------------------------------------------
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     constructor () public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77 
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 
88 contract Metha is ERC20Interface, Owned {
89     using SafeMath for uint;
90     string public constant name = "Metha";
91     string public constant symbol = "METH";
92     uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
93     uint public _totalSupply = 0;
94     uint public constant eth_meth = 100; // price 1 eth/meth = 100
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor () public {
104     }
105 
106     // ------------------------------------------------------------------------
107     // Total supply
108     // ------------------------------------------------------------------------
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply;
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Convert you Eth to Metha
116     // ------------------------------------------------------------------------
117     function convertToMeth() payable public {
118         uint tokens = msg.value * eth_meth;
119         balances[msg.sender] = balances[msg.sender].add(tokens); // eth wei to meth wei
120         _totalSupply = _totalSupply.add(tokens);
121     }
122 
123     // ------------------------------------------------------------------------
124     // Same for Fallback
125     // ------------------------------------------------------------------------
126     function () payable public {
127         convertToMeth();
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Convert your token back to eth. Does not accept 0 amount.
133     // ------------------------------------------------------------------------
134     function convertToEth(uint amount) public
135     onlyPayloadSize(1 * 32)
136     returns (bool success) {
137         balances[msg.sender] = balances[msg.sender].sub(amount);
138         _totalSupply = _totalSupply.sub(amount);
139         msg.sender.transfer(amount / eth_meth);  // meth wei to eth wei
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account `tokenOwner`
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151     // ------------------------------------------------------------------------
152     // Fix for the ERC20 short address attack
153     // ------------------------------------------------------------------------
154      modifier onlyPayloadSize(uint size) {
155          assert(msg.data.length >= size + 4);
156          _;
157      }
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to `to` account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transfer(address to, uint tokens) public
165     onlyPayloadSize(2 * 32)
166     returns (bool success) {
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) public
183     onlyPayloadSize(2 * 32)
184     returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Transfer `tokens` from the `from` account to the `to` account
193     //
194     // The calling account must already have sufficient tokens approve(...)-d
195     // for spending from the `from` account and
196     // - From account must have sufficient balance to transfer
197     // - Spender must have sufficient allowance to transfer
198     // - 0 value transfers are allowed
199     // ------------------------------------------------------------------------
200     function transferFrom(address from, address to, uint tokens) public
201     onlyPayloadSize(3 * 32)
202     returns (bool success) {
203         balances[from] = balances[from].sub(tokens);
204         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
205         balances[to] = balances[to].add(tokens);
206         emit Transfer(from, to, tokens);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Returns the amount of tokens approved by the owner that can be
213     // transferred to the spender's account
214     // ------------------------------------------------------------------------
215     function allowance(address tokenOwner, address spender) public constant
216     returns (uint remaining) {
217         return allowed[tokenOwner][spender];
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Token owner can approve for `spender` to transferFrom(...) `tokens`
223     // from the token owner's account. The `spender` contract function
224     // `receiveApproval(...)` is then executed
225     // ------------------------------------------------------------------------
226     function approveAndCall(address spender, uint tokens, bytes data) public
227     onlyPayloadSize(3 * 32)
228     returns (bool success) {
229         allowed[msg.sender][spender] = tokens;
230         emit Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
232         return true;
233     }
234 
235     // ------------------------------------------------------------------------
236     // Owner can transfer out any accidentally sent ERC20 tokens
237     // ------------------------------------------------------------------------
238     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
239         return ERC20Interface(tokenAddress).transfer(owner, tokens);
240     }
241 }
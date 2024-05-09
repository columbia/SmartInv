1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : COINVA
7 // Name        : Coinva
8 // Total supply: 2,500,000,000.00
9 // Decimals    : 2
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public view returns (uint);
46     function balanceOf(address tokenOwner) public view returns (uint balance);
47     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract MultiOwned {
71     address[] public owners;
72     mapping (address => bool) public isOwner;
73     mapping (address => bool) public hasReceivedAllocation;
74 
75     event OwnershipAdded(address indexed _added);
76 
77     event OwnershipRemoved(address indexed _removed);
78 
79     constructor() public {
80         owners = [msg.sender];
81         isOwner[msg.sender] = true;
82     }
83 
84     modifier onlyOwners {
85         require(isOwner[msg.sender]);
86         _;
87     }
88 
89     function addOwner(address _newOwner) public onlyOwners {
90         isOwner[_newOwner] = true;
91         owners.push(_newOwner);
92         emit OwnershipAdded(_newOwner);
93     }
94     
95     function removeOwner(address _removedOwner) public onlyOwners  {
96         for (uint i=0; i < owners.length - 1; i++)
97             if (owners[i] == _removedOwner) {
98                 owners[i] = owners[owners.length - 1];
99                 break;
100             }
101         owners.length -= 1;
102         isOwner[_removedOwner] = false;
103         emit OwnershipRemoved(_removedOwner);
104     }
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // ERC20 Token, with the addition of symbol, name and decimals and a
110 // fixed supply
111 // ----------------------------------------------------------------------------
112 contract CoinvaToken is ERC20Interface, MultiOwned {
113     using SafeMath for uint;
114 
115     string public symbol;
116     string public  name;
117     uint8 public decimals;
118     uint _totalSupply;
119 
120     mapping(address => uint) balances;
121     mapping(address => mapping(address => uint)) allowed;
122 
123 
124     // ------------------------------------------------------------------------
125     // Constructor
126     // ------------------------------------------------------------------------
127     constructor() public {
128         symbol = "COINVA";
129         name = "Coinva";
130         decimals = 2;
131         _totalSupply = 2500000000 * 10**uint(decimals);
132         balances[address(this)] = _totalSupply;
133         emit Transfer(address(0), address(this), _totalSupply);
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Total supply
139     // ------------------------------------------------------------------------
140     function totalSupply() public view returns (uint) {
141         return _totalSupply.sub(balances[address(0)]);
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Get the token balance for account `tokenOwner`
147     // ------------------------------------------------------------------------
148     function balanceOf(address tokenOwner) public view returns (uint balance) {
149         return balances[tokenOwner];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer the balance from token owner's account to `to` account
155     // - Owner's account must have sufficient balance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transfer(address to, uint tokens) public returns (bool success) {
159         balances[msg.sender] = balances[msg.sender].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         emit Transfer(msg.sender, to, tokens);
162         return true;
163     }
164     
165     // ------------------------------------------------------------------------
166     // Distribute 1% of the owner's balance to the `to` account
167     // ------------------------------------------------------------------------
168     function distributeToken(address to) public onlyOwners returns (bool success) {
169         if (hasReceivedAllocation[to])
170             revert("already received allocation");
171         
172         hasReceivedAllocation[to] = true;
173         uint allocation = balances[address(this)].div(100); // 1%
174         balances[address(this)] = balances[address(this)].sub(allocation);
175         balances[to] = balances[to].add(allocation);
176         emit Transfer(address(this), to, allocation);
177         return true;
178     }
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account
183     //
184     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
185     // recommends that there are no checks for the approval double-spend attack
186     // as this should be implemented in user interfaces
187     // ------------------------------------------------------------------------
188     function approve(address spender, uint tokens) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Transfer `tokens` from the `from` account to the `to` account
197     //
198     // The calling account must already have sufficient tokens approve(...)-d
199     // for spending from the `from` account and
200     // - From account must have sufficient balance to transfer
201     // - Spender must have sufficient allowance to transfer
202     // - 0 value transfers are allowed
203     // ------------------------------------------------------------------------
204     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
205         balances[from] = balances[from].sub(tokens);
206         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
207         balances[to] = balances[to].add(tokens);
208         emit Transfer(from, to, tokens);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Returns the amount of tokens approved by the owner that can be
215     // transferred to the spender's account
216     // ------------------------------------------------------------------------
217     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
218         return allowed[tokenOwner][spender];
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Token owner can approve for `spender` to transferFrom(...) `tokens`
224     // from the token owner's account. The `spender` contract function
225     // `receiveApproval(...)` is then executed
226     // ------------------------------------------------------------------------
227     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
228         allowed[msg.sender][spender] = tokens;
229         emit Approval(msg.sender, spender, tokens);
230         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
231         return true;
232     }
233 
234 
235     // ------------------------------------------------------------------------
236     // Don't accept ETH
237     // ------------------------------------------------------------------------
238     function () external payable {
239         revert();
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Owner can transfer out any accidentally sent ERC20 tokens
245     // ------------------------------------------------------------------------
246     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwners returns (bool success) {
247         return ERC20Interface(tokenAddress).transfer(msg.sender, tokens);
248     }
249 }
1 /*
2 Copyright (c) 2018 Myart Dev Team
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
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
20         if (a == 0) {
21             revert();
22         }
23         c = a * b;
24         require(c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
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
48 // ----------------------------------------------------------------------------
49 // Contract function to receive approval and execute function in one call
50 //
51 // Borrowed from MiniMeToken
52 // ----------------------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
55 }
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     function Owned() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and an
88 // initial fixed supply
89 // ----------------------------------------------------------------------------
90 contract MyartPoint is ERC20Interface, Owned {
91     using SafeMath for uint;
92 
93     string public symbol;
94     string public name;
95     uint8 public  decimals;
96     uint private  _totalSupply;
97     bool public halted;
98 
99     uint number = 0;
100     mapping(uint => address) private indices;
101     mapping(address => bool) private exists;
102     mapping(address => uint) private balances;
103     mapping(address => mapping(address => uint)) private allowed;
104     mapping(address => bool) public frozenAccount;
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     function MyartPoint() public {
110         halted = false;
111         symbol = "MYT";
112         name = "Myart Point";
113         decimals = 18;
114         _totalSupply = 1210 * 1000 * 1000 * 10**uint(decimals);
115 
116         balances[owner] = _totalSupply;
117     }
118 
119     // ------------------------------------------------------------------------
120     // Record a new address
121     // ------------------------------------------------------------------------    
122     function recordNewAddress(address _adr) internal {
123         if (exists[_adr] == false) {
124             exists[_adr] = true;
125             indices[number] = _adr;
126             number++;
127         } 
128     }
129     
130     // ------------------------------------------------------------------------
131     // Get number of addresses
132     // ------------------------------------------------------------------------
133     function numAdrs() public constant returns (uint) {
134         return number;
135     }
136 
137     // ------------------------------------------------------------------------
138     // Get address by index
139     // ------------------------------------------------------------------------
140     function getAdrByIndex(uint _index) public constant returns (address) {
141         return indices[_index];
142     }
143 
144     // ------------------------------------------------------------------------
145     // Set the halted tag when the emergent case happened
146     // ------------------------------------------------------------------------
147     function setEmergentHalt(bool _tag) public onlyOwner {
148         halted = _tag;
149     }
150 
151     // ------------------------------------------------------------------------
152     // Allocate a particular amount of tokens from onwer to an account
153     // ------------------------------------------------------------------------
154     function allocate(address to, uint amount) public onlyOwner {
155         require(to != address(0));
156         require(!frozenAccount[to]);
157         require(!halted && amount > 0);
158         require(balances[owner] >= amount);
159 
160         recordNewAddress(to);
161 
162         balances[owner] = balances[owner].sub(amount);
163         balances[to] = balances[to].add(amount);
164         emit Transfer(address(0), to, amount);
165     }
166 
167     // ------------------------------------------------------------------------
168     // Freeze a particular account in the case of needed
169     // ------------------------------------------------------------------------
170     function freeze(address account, bool tag) public onlyOwner {
171         require(account != address(0));
172         frozenAccount[account] = tag;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Total supply
177     // ------------------------------------------------------------------------
178     function totalSupply() public constant returns (uint) {
179         return _totalSupply  - balances[address(0)];
180     }
181 
182     // ------------------------------------------------------------------------
183     // Get the token balance for account `tokenOwner`
184     // ------------------------------------------------------------------------
185     function balanceOf(address tokenOwner) public constant returns (uint balance) {
186         return balances[tokenOwner];
187     }
188 
189     // ------------------------------------------------------------------------
190     // Transfer the balance from token owner's account to `to` account
191     // - Owner's account must have sufficient balance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transfer(address to, uint tokens) public returns (bool success) {
195         if (halted || tokens <= 0) revert();
196         if (frozenAccount[msg.sender] || frozenAccount[to]) revert();
197         if (balances[msg.sender] < tokens) revert();
198 
199         recordNewAddress(to);
200         
201         balances[msg.sender] = balances[msg.sender].sub(tokens);
202         balances[to] = balances[to].add(tokens);
203         emit Transfer(msg.sender, to, tokens);
204         return true;
205     }
206 
207     // ------------------------------------------------------------------------
208     // Token owner can approve for `spender` to transferFrom(...) `tokens`
209     // from the token owner's account
210     //
211     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
212     // recommends that there are no checks for the approval double-spend attack
213     // as this should be implemented in user interfaces 
214     // ------------------------------------------------------------------------
215     function approve(address spender, uint tokens) public returns (bool success) {
216         if (halted || tokens <= 0) revert();
217         if (frozenAccount[msg.sender] || frozenAccount[spender]) revert();
218 
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         return true;
222     }
223 
224     // ------------------------------------------------------------------------
225     // Transfer `tokens` from the `from` account to the `to` account
226     // 
227     // The calling account must already have sufficient tokens approve(...)-d
228     // for spending from the `from` account and
229     // - From account must have sufficient balance to transfer
230     // - Spender must have sufficient allowance to transfer
231     // - 0 value transfers are allowed
232     // ------------------------------------------------------------------------
233     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
234         if (halted || tokens <= 0) revert();
235         if (frozenAccount[from] || frozenAccount[to] || frozenAccount[msg.sender]) revert();
236         if (balances[from] < tokens) revert();
237         if (allowed[from][msg.sender] < tokens) revert();
238 
239         recordNewAddress(to);
240 
241         balances[from] = balances[from].sub(tokens);
242         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
243         balances[to] = balances[to].add(tokens);
244         emit Transfer(from, to, tokens);
245         return true;
246     }
247 
248     // ------------------------------------------------------------------------
249     // Returns the amount of tokens approved by the owner that can be
250     // transferred to the spender's account
251     // ------------------------------------------------------------------------
252     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
253         return allowed[tokenOwner][spender];
254     }
255 
256     // ------------------------------------------------------------------------
257     // Token owner can approve for `spender` to transferFrom(...) `tokens`
258     // from the token owner's account. The `spender` contract function
259     // `receiveApproval(...)` is then executed
260     // ------------------------------------------------------------------------
261     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
262         if (halted || tokens <= 0) revert();
263         if (frozenAccount[msg.sender] || frozenAccount[spender]) revert();
264 
265         allowed[msg.sender][spender] = tokens;
266         emit Approval(msg.sender, spender, tokens);
267         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
268         return true;
269     }
270 
271     // ------------------------------------------------------------------------
272     // Don't accept ETH
273     // ------------------------------------------------------------------------
274     function () public payable {
275         revert();
276     }
277 
278     // ------------------------------------------------------------------------
279     // Owner can transfer out any accidentally sent ERC20 tokens
280     // ------------------------------------------------------------------------
281     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
282         return ERC20Interface(tokenAddress).transfer(owner, tokens);
283     }
284 }
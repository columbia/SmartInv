1 /*
2 Copyright (c) 2018 Myart Dev Team
3 */
4 
5 pragma solidity ^0.4.24;
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
66     constructor() public {
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
99     mapping(address => uint) private balances;
100     mapping(address => mapping(address => uint)) private allowed;
101     mapping(address => bool) public frozenAccount;
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     constructor() public {
107         halted = false;
108         symbol = "MYT";
109         name = "Myart";
110         decimals = 18;
111         _totalSupply = 1210 * 1000 * 1000 * 10**uint(decimals);
112 
113         balances[owner] = _totalSupply;
114     }
115 
116     // ------------------------------------------------------------------------
117     // Set the halted tag when the emergent case happened
118     // ------------------------------------------------------------------------
119     function setEmergentHalt(bool _tag) public onlyOwner {
120         halted = _tag;
121     }
122 
123     // ------------------------------------------------------------------------
124     // Allocate a particular amount of tokens from onwer to an account
125     // ------------------------------------------------------------------------
126     function allocate(address to, uint amount) public onlyOwner {
127         require(to != address(0));
128         require(!frozenAccount[to]);
129         require(!halted && amount > 0);
130         require(balances[owner] >= amount);
131 
132         balances[owner] = balances[owner].sub(amount);
133         balances[to] = balances[to].add(amount);
134         emit Transfer(address(0), to, amount);
135     }
136 
137     // ------------------------------------------------------------------------
138     // Freeze a particular account in the case of needed
139     // ------------------------------------------------------------------------
140     function freeze(address account, bool tag) public onlyOwner {
141         require(account != address(0));
142         frozenAccount[account] = tag;
143     }
144 
145     // ------------------------------------------------------------------------
146     // Total supply
147     // ------------------------------------------------------------------------
148     function totalSupply() public constant returns (uint) {
149         return _totalSupply.sub(balances[address(0)]);
150     }
151 
152     // ------------------------------------------------------------------------
153     // Get the token balance for account `tokenOwner`
154     // ------------------------------------------------------------------------
155     function balanceOf(address tokenOwner) public constant returns (uint balance) {
156         return balances[tokenOwner];
157     }
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to `to` account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transfer(address to, uint tokens) public returns (bool success) {
165         if (halted || tokens <= 0) revert();
166         require(!frozenAccount[msg.sender]);
167 
168         balances[msg.sender] = balances[msg.sender].sub(tokens);
169         balances[to] = balances[to].add(tokens);
170         emit Transfer(msg.sender, to, tokens);
171         return true;
172     }
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces 
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) public returns (bool success) {
183         if (halted || tokens <= 0) revert();
184 
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190     // ------------------------------------------------------------------------
191     // Transfer `tokens` from the `from` account to the `to` account
192     // 
193     // The calling account must already have sufficient tokens approve(...)-d
194     // for spending from the `from` account and
195     // - From account must have sufficient balance to transfer
196     // - Spender must have sufficient allowance to transfer
197     // - 0 value transfers are allowed
198     // ------------------------------------------------------------------------
199     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
200         if (halted || tokens <= 0) revert();
201         require(!frozenAccount[from]);
202 
203         balances[from] = balances[from].sub(tokens);
204         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
205         balances[to] = balances[to].add(tokens);
206         emit Transfer(from, to, tokens);
207         return true;
208     }
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218     // ------------------------------------------------------------------------
219     // Token owner can approve for `spender` to transferFrom(...) `tokens`
220     // from the token owner's account. The `spender` contract function
221     // `receiveApproval(...)` is then executed
222     // ------------------------------------------------------------------------
223     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
224         if (halted || tokens <= 0) revert();
225 
226         allowed[msg.sender][spender] = tokens;
227         emit Approval(msg.sender, spender, tokens);
228         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
229         return true;
230     }
231 
232     // ------------------------------------------------------------------------
233     // Don't accept ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         revert();
237     }
238 
239     // ------------------------------------------------------------------------
240     // Owner can transfer out any accidentally sent ERC20 tokens
241     // ------------------------------------------------------------------------
242     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
243         return ERC20Interface(tokenAddress).transfer(owner, tokens);
244     }
245 }
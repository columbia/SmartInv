1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and assisted
85 // token transfers
86 // ----------------------------------------------------------------------------
87 contract touristreviewToken is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92     bool public _open;
93     uint public minTrade = 10000000000000000;
94     uint public sellPrice = 500;
95     uint public tokenPublicSale = 1400000000000000000;
96     uint public soldToken = 0;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100     
101     //------------------------------------------------------------------------
102     event Burn(address indexed from,uint256 value); 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107     function touristreviewToken() public {
108         symbol = "TRET";
109         name = "Tourist Review";
110         decimals = 8;
111         _totalSupply = 2000000000000000000;
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply  - balances[address(0)];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer the balance from token owner's account to `to` account
133     // - Owner's account must have sufficient balance to transfer
134     // - 0 value transfers are allowed
135     // ------------------------------------------------------------------------
136     function transfer(address to, uint tokens) public returns (bool success) {
137         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         Transfer(msg.sender, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for `spender` to transferFrom(...) `tokens`
146     // from the token owner's account
147     // recommends that there are no checks for the approval double-spend attack
148     // as this should be implemented in user interfaces
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
159     //
160     // The calling account must already have sufficient tokens approve(...)-d
161     // for spending from the `from` account and
162     // - From account must have sufficient balance to transfer
163     // - Spender must have sufficient allowance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
167         balances[from] = safeSub(balances[from], tokens);
168         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
169         balances[to] = safeAdd(balances[to], tokens);
170         Transfer(from, to, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Returns the amount of tokens approved by the owner that can be
177     // transferred to the spender's account
178     // ------------------------------------------------------------------------
179     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
180         return allowed[tokenOwner][spender];
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for `spender` to transferFrom(...) `tokens`
186     // from the token owner's account. The `spender` contract function
187     // `receiveApproval(...)` is then executed
188     // ------------------------------------------------------------------------
189     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
193         return true;
194     }
195 
196 
197     //------------------------------------------------------------------------
198     // Set minTrade
199     // Min trade = 1/newMinTrade
200     // Ex. 1/100 = 0.01
201     //------------------------------------------------------------------------
202     function setMinTrade(uint256 newMinTrade)public onlyOwner returns (bool success) {
203         minTrade = newMinTrade;
204     }
205     
206     //------------------------------------------------------------------------
207     // Set Trade
208     // True is Open
209     // False is Close
210     //------------------------------------------------------------------------
211     function setTrade(bool status)public onlyOwner returns (bool success) {
212         _open = status;
213     }
214     
215     
216     //------------------------------------------------------------------------
217     // Destroy token
218     //------------------------------------------------------------------------
219     function burn (uint256 _value) public onlyOwner returns (bool success) {
220         balances[address(0)] = safeSub(balances[address(0)],_value);
221         _totalSupply -= _value;
222         emit Burn(msg.sender,_value);
223         return true;
224     }
225     
226     
227     //------------------------------------------------------------------------
228     // Set Price
229     //------------------------------------------------------------------------
230     function setPrice(uint256 _value) public onlyOwner returns (bool success){
231         sellPrice = _value;
232         return true;
233     }
234     
235     //------------------------------------------------------------------------
236     // Set public sale
237     //------------------------------------------------------------------------
238     function setPublicSale(uint256 _value) public onlyOwner returns (bool success){
239         tokenPublicSale = _value;
240         return true;
241     }
242     
243 
244     function () public payable {
245         require(msg.value >= 1/minTrade);
246         require(_open);
247         //overseeing supply level 1
248         require(soldToken<tokenPublicSale);
249         uint tokens;
250         
251         tokens = msg.value / sellPrice;
252         
253         //overseeing supply level 2
254         if((soldToken + tokens) > (tokenPublicSale+ sellPrice*8)){
255             tokens = (tokenPublicSale+ sellPrice*8) - soldToken;
256         }
257         
258         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
259         //_totalSupply = safeAdd(_totalSupply, tokens);
260         Transfer(address(0), msg.sender, tokens);
261         soldToken += tokens;
262         owner.transfer(msg.value);
263     }
264 
265 
266 
267     // ------------------------------------------------------------------------
268     // Owner can transfer out any accidentally sent ERC20 tokens
269     // ------------------------------------------------------------------------
270     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
271         return ERC20Interface(tokenAddress).transfer(owner, tokens);
272     }
273 }
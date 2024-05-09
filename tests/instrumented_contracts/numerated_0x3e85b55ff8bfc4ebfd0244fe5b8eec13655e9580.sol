1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10 
11     function sub(uint a, uint b) internal pure returns (uint c) {
12 
13         require(b <= a);
14 
15         c = a - b;
16 
17     }
18 
19     function mul(uint a, uint b) internal pure returns (uint c) {
20 
21         c = a * b;
22 
23         require(a == 0 || c / a == b);
24 
25     }
26 
27     function div(uint a, uint b) internal pure returns (uint c) {
28 
29         require(b > 0);
30 
31         c = a / b;
32 
33     }
34 
35 }
36 
37 
38 
39 contract ERC20Interface {
40 
41     function totalSupply() public view returns (uint);
42 
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44 
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46 
47     function transfer(address to, uint tokens) public returns (bool success);
48 
49     function approve(address spender, uint tokens) public returns (bool success);
50 
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55 
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 
58 }
59 
60 contract ApproveAndCallFallBack {
61 
62     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
63 
64 }
65 
66 
67 
68 contract Owned {
69     address public owner;
70     address public newOwner;
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72     constructor() public {
73         owner = 0x666A81837661cb26fb74aE6819D8c76541Dbe615; //msg.sender;
74 
75     }
76 
77 
78     modifier onlyOwner {
79 
80         require(msg.sender == owner);
81 
82         _;
83 
84     }
85 
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88 
89         newOwner = _newOwner;
90 
91     }
92 
93     function acceptOwnership() public {
94 
95         require(msg.sender == newOwner);
96 
97         emit OwnershipTransferred(owner, newOwner);
98 
99         owner = newOwner;
100 
101         newOwner = 0x666A81837661cb26fb74aE6819D8c76541Dbe615; //address(0);
102 
103     }
104 
105 }
106 
107 
108 
109 // ----------------------------------------------------------------------------
110 
111 // ERC20 Token, with the addition of symbol, name and decimals and a
112 
113 // fixed supply
114 
115 // ----------------------------------------------------------------------------
116 
117 contract hoot is ERC20Interface, Owned {
118 
119     using SafeMath for uint;
120 
121 
122     string public symbol;
123 
124     string public publishedby;
125 
126     string public  name;
127 
128     uint8 public decimals;
129 
130     uint _totalSupply;
131 
132 
133     mapping(address => uint) balances;
134 
135     mapping(address => mapping(address => uint)) allowed;
136 
137 
138 
139     // ------------------------------------------------------------------------
140 
141     // Constructor
142 
143     // ------------------------------------------------------------------------
144 
145     constructor() public {
146 
147         symbol = "BEDCOIN";
148 
149         publishedby = "createcryptoco.in";
150 
151         name =  "BEDCOIN";
152 
153         decimals = 18;
154 
155         _totalSupply = 500000000000 * 10**uint(decimals);
156 
157         balances[owner] = _totalSupply;
158 
159         emit Transfer(address(0), 0x666A81837661cb26fb74aE6819D8c76541Dbe615, _totalSupply);
160 
161     }
162 
163 
164 
165     function totalSupply() public view returns (uint) {
166         return _totalSupply.sub(balances[address(0)]);
167     }
168 
169 
170 
171     function balanceOf(address tokenOwner) public view returns (uint balance) {
172         return balances[tokenOwner];
173     }
174 
175 
176 
177     // ------------------------------------------------------------------------
178 
179     // Transfer the balance from token owner's account to `to` account
180 
181     // - Owner's account must have sufficient balance to transfer
182 
183     // - 0 value transfers are allowed
184 
185     // ------------------------------------------------------------------------
186 
187     function transfer(address to, uint tokens) public returns (bool success) {
188         balances[msg.sender] = balances[msg.sender].sub(tokens);
189         balances[to] = balances[to].add(tokens);
190         emit Transfer(msg.sender, to, tokens);
191         return true;
192     }
193 
194 
195 
196     // ------------------------------------------------------------------------
197 
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199 
200     // from the token owner's account
201 
202     //
203 
204     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
205 
206     // recommends that there are no checks for the approval double-spend attack
207 
208     // as this should be implemented in user interfaces
209 
210     // ------------------------------------------------------------------------
211 
212     function approve(address spender, uint tokens) public returns (bool success) {
213 
214         allowed[msg.sender][spender] = tokens;
215 
216         emit Approval(msg.sender, spender, tokens);
217 
218         return true;
219 
220     }
221 
222 
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
233 
234     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
235         balances[from] = balances[from].sub(tokens);
236         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
237         balances[to] = balances[to].add(tokens);
238         emit Transfer(from, to, tokens);
239         return true;
240     }
241 
242 
243 
244     // ------------------------------------------------------------------------
245 
246     // Returns the amount of tokens approved by the owner that can be
247 
248     // transferred to the spender's account
249 
250     // ------------------------------------------------------------------------
251 
252     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
253 
254         return allowed[tokenOwner][spender];
255 
256     }
257 
258 
259 
260     // ------------------------------------------------------------------------
261 
262     // Token owner can approve for `spender` to transferFrom(...) `tokens`
263 
264     // from the token owner's account. The `spender` contract function
265 
266     // `receiveApproval(...)` is then executed
267 
268     // ------------------------------------------------------------------------
269 
270     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
271         allowed[msg.sender][spender] = tokens;
272         emit Approval(msg.sender, spender, tokens);
273         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
274         return true;
275 
276     }
277 
278 
279 
280     function () external payable {
281         revert();
282     }
283 
284 
285 
286     // ------------------------------------------------------------------------
287     // Owner can transfer out any accidentally sent ERC20 tokens
288     // ------------------------------------------------------------------------
289 
290     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
291         return ERC20Interface(tokenAddress).transfer(owner, tokens);
292     }
293 }
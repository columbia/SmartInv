1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.18;
4 
5 // ----------------------------------------------------------------------------
6 // 'FIXED' 'Example Fixed Supply Token' token contract
7 //
8 // Symbol      : FIXED
9 // Name        : Example Fixed Supply Token
10 // Total supply: 1,000,000.000000000000000000
11 // Decimals    : 18
12 //
13 // Enjoy.
14 //
15 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     function Owned() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and an
101 // initial fixed supply
102 // ----------------------------------------------------------------------------
103 contract FixedSupplyToken is ERC20Interface, Owned {
104     using SafeMath for uint;
105 
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint public _totalSupply;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function FixedSupplyToken() public {
119         symbol = "FIXED";
120         name = "Example Fixed Supply Token";
121         decimals = 18;
122         _totalSupply = 1000000 * 10**uint(decimals);
123         balances[owner] = _totalSupply;
124         Transfer(address(0), owner, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = balances[msg.sender].sub(tokens);
151         balances[to] = balances[to].add(tokens);
152         Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for `spender` to transferFrom(...) `tokens`
159     // from the token owner's account
160     //
161     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162     // recommends that there are no checks for the approval double-spend attack
163     // as this should be implemented in user interfaces 
164     // ------------------------------------------------------------------------
165     function approve(address spender, uint tokens) public returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         Approval(msg.sender, spender, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Transfer `tokens` from the `from` account to the `to` account
174     // 
175     // The calling account must already have sufficient tokens approve(...)-d
176     // for spending from the `from` account and
177     // - From account must have sufficient balance to transfer
178     // - Spender must have sufficient allowance to transfer
179     // - 0 value transfers are allowed
180     // ------------------------------------------------------------------------
181     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
182         balances[from] = balances[from].sub(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         balances[to] = balances[to].add(tokens);
185         Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account. The `spender` contract function
202     // `receiveApproval(...)` is then executed
203     // ------------------------------------------------------------------------
204     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
205         allowed[msg.sender][spender] = tokens;
206         Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Don't accept ETH
214     // ------------------------------------------------------------------------
215     function () public payable {
216         revert();
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
224         return ERC20Interface(tokenAddress).transfer(owner, tokens);
225     }
226 }
227 
228 /*
229  * ERC20 interface
230  */
231 contract ERC20 {
232   uint public totalSupply;
233   function balanceOf(address who) constant returns (uint);
234   function transfer(address to, uint value);
235   function allowance(address owner, address spender) constant returns (uint);
236 
237   function transferFrom(address from, address to, uint value);
238   function approve(address spender, uint value);
239 
240   event Transfer(address indexed from, address indexed to, uint value);
241   event Approval(address indexed owner, address indexed spender, uint value);
242 }
243 
244 contract ExxStandart is ERC20 {
245     using SafeMath for uint;
246     
247 	string  public name        = "Exxcoin";
248     string  public symbol      = "EXX";
249     uint8   public decimals    = 0;
250 
251 	mapping (address => mapping (address => uint)) allowed;
252 	mapping (address => uint) balances;
253 
254 	function transferFrom(address _from, address _to, uint _value) {
255 		balances[_from] = balances[_from].sub(_value);
256 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257 		balances[_to] = balances[_to].add(_value);
258 		Transfer(_from, _to, _value);
259 	}
260 
261 	function approve(address _spender, uint _value) {
262 		allowed[msg.sender][_spender] = _value;
263 		Approval(msg.sender, _spender, _value);
264 	}
265 
266 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
267 		return allowed[_owner][_spender];
268 	}
269 
270 	function transfer(address _to, uint _value) {
271 		balances[msg.sender] = balances[msg.sender].sub(_value);
272 		balances[_to] = balances[_to].add(_value);
273 		Transfer(msg.sender, _to, _value);
274 	}
275 
276 	function balanceOf(address _owner) constant returns (uint balance) {
277 		return balances[_owner];
278 	}
279 }
280 
281 contract owned {
282     
283     address public owner;
284     address public newOwner;
285 	
286     function owned() public payable {
287         owner = msg.sender;
288     }
289 	
290     modifier onlyOwner {
291         require(owner == msg.sender);
292         _; /* return */
293     }
294 	
295     function changeOwner(address _owner) onlyOwner public {
296         require(_owner != 0);
297         newOwner = _owner;
298     }
299     
300     function confirmOwner() public {
301         require(newOwner == msg.sender);
302         owner = newOwner;
303         delete newOwner;
304     }
305 }
306 
307 contract Exxcoin is owned, ExxStandart {
308 	address public manager = 0x0;
309 
310 	modifier onlyManager {
311 		require(manager == msg.sender);
312 		_;
313 	}
314     
315     function changeTotalSupply(uint _totalSupply) onlyOwner public {
316         totalSupply = _totalSupply;
317     }
318     
319 	function setManager(address _manager) onlyOwner public {
320 		manager = _manager;
321 	}
322 
323 	function delManager() onlyOwner public {
324 		manager = 0x123;
325 	}
326 
327     function () payable {
328 		
329 	}
330 
331     function sendTokensManager(address _to, uint _tokens) onlyManager public{
332 		require(manager != 0x0);
333 		_to.send(_tokens);
334 		balances[_to] = _tokens;
335         Transfer(msg.sender, _to, _tokens);
336 	}
337 
338     function sendTokens(address _to, uint _tokens) onlyOwner public{
339 		_to.send(_tokens);
340 		balances[_to] = _tokens;
341         Transfer(msg.sender, _to, _tokens);
342     }
343 }
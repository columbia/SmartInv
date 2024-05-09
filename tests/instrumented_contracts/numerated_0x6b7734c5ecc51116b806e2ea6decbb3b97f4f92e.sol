1 pragma solidity ^0.4.25;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'FIXED' 'CRUISEBIT' token contract
7 
8 
9 // Symbol      : FIXED
10 
11 // Name        : CRBT
12 
13 // Total supply: 500,000,000.000000000000000000
14 
15 // Decimals    : 18
16 
17 // ----------------------------------------------------------------------------
18 
19 // ----------------------------------------------------------------------------
20 
21 // Safe maths
22 
23 // ----------------------------------------------------------------------------
24 
25 library SafeMath {
26 
27     function add(uint a, uint b) internal pure returns (uint c) {
28 
29         c = a + b;
30 
31         require(c >= a);
32 
33     }
34 
35     function sub(uint a, uint b) internal pure returns (uint c) {
36 
37         require(b <= a);
38 
39         c = a - b;
40 
41     }
42 
43     function mul(uint a, uint b) internal pure returns (uint c) {
44 
45         c = a * b;
46 
47         require(a == 0 || c / a == b);
48 
49     }
50 
51     function div(uint a, uint b) internal pure returns (uint c) {
52 
53         require(b > 0);
54 
55         c = a / b;
56 
57     }
58 
59 }
60 
61 
62 contract ERC223Interface {
63 
64     function totalSupply() public constant returns (uint);
65 
66     function balanceOf(address tokenOwner) public constant returns (uint balance);
67 
68     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
69 
70     function transfer(address to, uint tokens) public returns (bool success);
71 
72     function approve(address spender, uint tokens) public returns (bool success);
73 
74     function transferFrom(address from, address to, uint tokens) public returns (bool success);
75 
76 
77 
78     function transfer(address to, uint value, bytes data) public returns (bool success);
79 
80 
81     event Transfer(address indexed from, address indexed to, uint tokens);
82 
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 
85     event Transfer1(address indexed from, address indexed to, uint value, bytes data);
86 
87 }
88 
89 
90 contract ApproveAndCallFallBack {
91 
92     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
93 
94 }
95 
96 contract ContractReceiver {
97     function tokenFallback(address _from, uint _value, bytes _data);
98 }
99 
100 contract Owned {
101 
102     address public owner;
103 
104     address public newOwner;
105 
106 
107     event OwnershipTransferred(address indexed _from, address indexed _to);
108 
109 
110     function Owned() public {
111 
112         owner = msg.sender;
113 
114     }
115 
116 
117     modifier onlyOwner {
118 
119         require(msg.sender == owner);
120 
121         _;
122 
123     }
124 
125 
126     function transferOwnership(address _newOwner) public onlyOwner {
127 
128         newOwner = _newOwner;
129 
130     }
131 
132     function acceptOwnership() public {
133 
134         require(msg.sender == newOwner);
135 
136         OwnershipTransferred(owner, newOwner);
137 
138         owner = newOwner;
139 
140         newOwner = address(0);
141 
142     }
143 
144 }
145 
146 
147 contract CRBT223 is ERC223Interface, Owned {
148 
149     using SafeMath for uint;
150 
151 
152     string public symbol;
153 
154     string public  name;
155 
156     uint8 public decimals;
157 
158     uint public _totalSupply;
159 
160 
161     mapping(address => uint) balances;
162 
163     mapping(address => mapping(address => uint)) allowed;
164 
165 
166 
167     // ------------------------------------------------------------------------
168 
169     // Constructor
170 
171     // ------------------------------------------------------------------------
172 
173     function CRBT223() public {
174 
175         symbol = "CRBT";
176 
177         name = "CRUISEBIT ERC223";
178 
179         decimals = 18;
180 
181         _totalSupply = 500000000 * 10**uint(decimals);
182 
183         balances[owner] = _totalSupply;
184 
185         Transfer(address(0), owner, _totalSupply);
186 
187     }
188 
189 
190     // ------------------------------------------------------------------------
191 
192     // Total supply
193 
194     // ------------------------------------------------------------------------
195 
196     function totalSupply() public constant returns (uint) {
197 
198         return _totalSupply  - balances[address(0)];
199 
200     }
201 
202 
203     function balanceOf(address tokenOwner) public constant returns (uint balance) {
204 
205         return balances[tokenOwner];
206 
207     }
208 
209 
210     function transfer(address to, uint tokens) public returns (bool success) {
211 
212         balances[msg.sender] = balances[msg.sender].sub(tokens);
213 
214         balances[to] = balances[to].add(tokens);
215 
216         Transfer(msg.sender, to, tokens);
217 
218         return true;
219 
220     }
221 
222     function approve(address spender, uint tokens) public returns (bool success) {
223 
224         allowed[msg.sender][spender] = tokens;
225 
226         Approval(msg.sender, spender, tokens);
227 
228         return true;
229 
230     }
231 
232 
233     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
234 
235         balances[from] = balances[from].sub(tokens);
236 
237         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
238 
239         balances[to] = balances[to].add(tokens);
240 
241         Transfer(from, to, tokens);
242 
243         return true;
244 
245     }
246 
247 
248     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
249 
250         return allowed[tokenOwner][spender];
251 
252     }
253 
254 
255     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
256 
257         allowed[msg.sender][spender] = tokens;
258 
259         Approval(msg.sender, spender, tokens);
260 
261         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
262 
263         return true;
264 
265     }
266 
267     // Function that is called when a user or another contract wants to transfer funds .
268     function transfer(address _to, uint _value, bytes _data) returns (bool success) {       
269         if(isContract(_to)) {
270             return transferToContract(_to, _value, _data);
271         }
272         else {
273             return transferToAddress(_to, _value, _data);
274         }
275     }
276 
277 
278     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
279     function isContract(address _addr) private returns (bool is_contract) {
280         uint length;
281         assembly {
282                 //retrieve the size of the code on target address, this needs assembly
283                 length := extcodesize(_addr)
284         }
285         return (length>0);
286     }
287 
288     //function that is called when transaction target is an address
289     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
290         if (balanceOf(msg.sender) < _value) revert();
291 
292         balances[msg.sender] = balances[msg.sender].sub(_value);
293         balances[_to]  = balances[_to].add(_value);
294         Transfer1(msg.sender, _to, _value, _data);
295         return true;
296     }
297     
298     //function that is called when transaction target is a contract
299     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
300         if (balanceOf(msg.sender) < _value) revert();
301 
302         balances[msg.sender] = balances[msg.sender].sub(_value);
303         balances[_to]  = balances[_to].add(_value);
304 
305         ContractReceiver receiver = ContractReceiver(_to);
306         receiver.tokenFallback(msg.sender, _value, _data);
307         Transfer1(msg.sender, _to, _value, _data);
308         return true;
309     }
310 
311     // ------------------------------------------------------------------------
312 
313     // Don't accept ETH
314 
315     // ------------------------------------------------------------------------
316 
317     function () public payable {
318 
319         revert();
320 
321     }
322 
323     // ------------------------------------------------------------------------
324 
325     // Transfer any ERC20 Tokens
326 
327     // ------------------------------------------------------------------------
328 
329     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
330 
331         return ERC223Interface(tokenAddress).transfer(owner, tokens);
332 
333     }
334 
335 }
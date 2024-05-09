1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-22
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 library SafeMath {
8 
9     function add(uint a, uint b) internal pure returns (uint c) {
10 
11         c = a + b;
12 
13         require(c >= a);
14 
15     }
16 
17     function sub(uint a, uint b) internal pure returns (uint c) {
18 
19         require(b <= a);
20 
21         c = a - b;
22 
23     }
24 
25     function mul(uint a, uint b) internal pure returns (uint c) {
26 
27         c = a * b;
28 
29         require(a == 0 || c / a == b);
30 
31     }
32 
33     function div(uint a, uint b) internal pure returns (uint c) {
34 
35         require(b > 0);
36 
37         c = a / b;
38 
39     }
40 
41 }
42 
43 
44 contract ERC223Interface {
45 
46     function totalSupply() public constant returns (uint);
47 
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49 
50     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
51 
52     function transfer(address to, uint tokens) public returns (bool success);
53 
54     function approve(address spender, uint tokens) public returns (bool success);
55 
56     function transferFrom(address from, address to, uint tokens) public returns (bool success);
57 
58 
59 
60     function transfer(address to, uint value, bytes data) public returns (bool success);
61 
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64 
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 
67     event Transfer1(address indexed from, address indexed to, uint value, bytes data);
68 
69 }
70 
71 
72 contract ApproveAndCallFallBack {
73 
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 
76 }
77 
78 contract ContractReceiver {
79     function tokenFallback(address _from, uint _value, bytes _data) public;
80 }
81 
82 contract Owned {
83 
84     address public owner;
85 
86     address public newOwner;
87 
88 
89     event OwnershipTransferred(address indexed _from, address indexed _to);
90 
91 
92      constructor() public {
93 
94         owner = msg.sender;
95 
96     }
97 
98 
99     modifier onlyOwner {
100 
101         require(msg.sender == owner);
102 
103         _;
104 
105     }
106 
107 
108     function transferOwnership(address _newOwner) public onlyOwner {
109 
110         newOwner = _newOwner;
111 
112     }
113 
114     function acceptOwnership() public {
115 
116         require(msg.sender == newOwner);
117 
118         emit OwnershipTransferred(owner, newOwner);
119 
120         owner = newOwner;
121 
122         newOwner = address(0);
123 
124     }
125 
126 }
127 
128 
129 contract StandardToken is ERC223Interface, Owned {
130 
131     using SafeMath for uint;
132 
133 
134     string public symbol;
135 
136     string public  name;
137 
138     uint8 public decimals;
139 
140     uint public _totalSupply;
141 
142 
143     mapping(address => uint) balances;
144 
145     mapping(address => mapping(address => uint)) allowed;
146 
147 
148 
149     // ------------------------------------------------------------------------
150 
151     // Constructor
152 
153     // ------------------------------------------------------------------------
154 
155     constructor(string _symbol, string _name, uint8 _decimals, uint256 totalSupply) public {
156 
157         symbol = _symbol;
158 
159         name = _name;
160 
161         decimals = _decimals;
162 
163         _totalSupply = totalSupply * 10**uint(decimals);
164 
165         balances[owner] = _totalSupply;
166 
167         emit Transfer(address(0), owner, _totalSupply);
168 
169     }
170 
171 
172     // ------------------------------------------------------------------------
173 
174     // Total supply
175 
176     // ------------------------------------------------------------------------
177 
178     function totalSupply() public constant returns (uint) {
179 
180         return _totalSupply  - balances[address(0)];
181 
182     }
183 
184 
185     function balanceOf(address tokenOwner) public constant returns (uint balance) {
186 
187         return balances[tokenOwner];
188 
189     }
190 
191 
192     function transfer(address to, uint tokens) public returns (bool success) {
193 
194         balances[msg.sender] = balances[msg.sender].sub(tokens);
195 
196         balances[to] = balances[to].add(tokens);
197 
198         emit Transfer(msg.sender, to, tokens);
199 
200         return true;
201 
202     }
203 
204     function approve(address spender, uint tokens) public returns (bool success) {
205 
206         allowed[msg.sender][spender] = tokens;
207 
208         emit Approval(msg.sender, spender, tokens);
209 
210         return true;
211 
212     }
213 
214 
215     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
216 
217         balances[from] = balances[from].sub(tokens);
218 
219         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
220 
221         balances[to] = balances[to].add(tokens);
222 
223         emit Transfer(from, to, tokens);
224 
225         return true;
226 
227     }
228 
229 
230     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
231 
232         return allowed[tokenOwner][spender];
233 
234     }
235 
236 
237     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
238 
239         allowed[msg.sender][spender] = tokens;
240 
241         emit Approval(msg.sender, spender, tokens);
242 
243         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
244 
245         return true;
246 
247     }
248 
249     // Function that is called when a user or another contract wants to transfer funds .
250     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {       
251         if(isContract(_to)) {
252             return transferToContract(_to, _value, _data);
253         }
254         else {
255             return transferToAddress(_to, _value, _data);
256         }
257     }
258 
259 
260     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
261     function isContract(address _addr) private view returns (bool is_contract) {
262         uint length;
263         assembly {
264                 //retrieve the size of the code on target address, this needs assembly
265                 length := extcodesize(_addr)
266         }
267         return (length>0);
268     }
269 
270     //function that is called when transaction target is an address
271     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
272         if (balanceOf(msg.sender) < _value) revert();
273 
274         balances[msg.sender] = balances[msg.sender].sub(_value);
275         balances[_to]  = balances[_to].add(_value);
276         emit Transfer1(msg.sender, _to, _value, _data);
277         return true;
278     }
279     
280     //function that is called when transaction target is a contract
281     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
282         if (balanceOf(msg.sender) < _value) revert();
283 
284         balances[msg.sender] = balances[msg.sender].sub(_value);
285         balances[_to]  = balances[_to].add(_value);
286 
287         ContractReceiver receiver = ContractReceiver(_to);
288         receiver.tokenFallback(msg.sender, _value, _data);
289         emit Transfer1(msg.sender, _to, _value, _data);
290         return true;
291     }
292 
293     // ------------------------------------------------------------------------
294 
295     // Don't accept ETH
296 
297     // ------------------------------------------------------------------------
298 
299     function () public payable {
300 
301         revert();
302 
303     }
304 
305     // ------------------------------------------------------------------------
306 
307     // Transfer any ERC20 Tokens
308 
309     // ------------------------------------------------------------------------
310 
311     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
312 
313         return ERC223Interface(tokenAddress).transfer(owner, tokens);
314 
315     }
316 
317 }
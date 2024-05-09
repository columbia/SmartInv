1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6 
7     function add(uint a, uint b) internal pure returns (uint c) {
8 
9         c = a + b;
10 
11         require(c >= a);
12 
13     }
14 
15     function sub(uint a, uint b) internal pure returns (uint c) {
16 
17         require(b <= a);
18 
19         c = a - b;
20 
21     }
22 
23     function mul(uint a, uint b) internal pure returns (uint c) {
24 
25         c = a * b;
26 
27         require(a == 0 || c / a == b);
28 
29     }
30 
31     function div(uint a, uint b) internal pure returns (uint c) {
32 
33         require(b > 0);
34 
35         c = a / b;
36 
37     }
38 
39 }
40 
41 
42 
43 
44 contract ERC20Interface {
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
59     event Transfer(address indexed from, address indexed to, uint tokens);
60 
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 
63 }
64 
65 
66 
67 
68 contract ApproveAndCallFallBack {
69 
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 
72 }
73 
74 
75 
76 
77 contract Owned {
78 
79     address public owner;
80 
81     address public newOwner;
82 
83 
84     event OwnershipTransferred(address indexed _from, address indexed _to);
85 
86 
87     function Owned() public {
88 
89         owner = msg.sender;
90 
91     }
92 
93 
94     modifier onlyOwner {
95 
96         require(msg.sender == owner);
97 
98         _;
99 
100     }
101 
102 
103     function transferOwnership(address _newOwner) public onlyOwner {
104 
105         newOwner = _newOwner;
106 
107     }
108 
109     function acceptOwnership() public {
110 
111         require(msg.sender == newOwner);
112 
113         OwnershipTransferred(owner, newOwner);
114 
115         owner = newOwner;
116 
117         newOwner = address(0);
118 
119     }
120 
121 }
122 
123 
124 
125 
126 
127 contract TobkaCoin is ERC20Interface, Owned {
128 
129     using SafeMath for uint;
130 
131 
132     string public symbol;
133 
134     string public  name;
135 
136     uint8 public decimals;
137 
138     uint public _totalSupply;
139 
140 
141     mapping(address => uint) balances;
142 
143     mapping(address => mapping(address => uint)) allowed;
144 
145 
146 
147     // ------------------------------------------------------------------------
148 
149     // Constructor
150 
151     // ------------------------------------------------------------------------
152 
153     function TobkaCoin() public {
154 
155         symbol = "TBK";
156 
157         name = "TobkaCoin";
158 
159         decimals = 18;
160 
161         _totalSupply = 40000000 * 10**uint(decimals);
162 
163         balances[owner] = _totalSupply;
164 
165         Transfer(address(0), owner, _totalSupply);
166 
167     }
168 
169 
170 
171 
172     function totalSupply() public constant returns (uint) {
173 
174         return _totalSupply  - balances[address(0)];
175 
176     }
177 
178 
179 
180     function balanceOf(address tokenOwner) public constant returns (uint balance) {
181 
182         return balances[tokenOwner];
183 
184     }
185 
186 
187 
188     function transfer(address to, uint tokens) public returns (bool success) {
189 
190         balances[msg.sender] = balances[msg.sender].sub(tokens);
191 
192         balances[to] = balances[to].add(tokens);
193 
194         Transfer(msg.sender, to, tokens);
195 
196         return true;
197 
198     }
199 
200 
201 
202 
203     function approve(address spender, uint tokens) public returns (bool success) {
204 
205         allowed[msg.sender][spender] = tokens;
206 
207         Approval(msg.sender, spender, tokens);
208 
209         return true;
210 
211     }
212 
213 
214 
215 
216     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
217 
218         balances[from] = balances[from].sub(tokens);
219 
220         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
221 
222         balances[to] = balances[to].add(tokens);
223 
224         Transfer(from, to, tokens);
225 
226         return true;
227 
228     }
229 
230 
231 
232     
233     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
234 
235         return allowed[tokenOwner][spender];
236 
237     }
238 
239 
240 
241     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
242 
243         allowed[msg.sender][spender] = tokens;
244 
245         Approval(msg.sender, spender, tokens);
246 
247         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
248 
249         return true;
250 
251     }
252 
253 
254 
255     function () public payable {
256 
257         revert();
258 
259     }
260 
261 
262 
263     // ------------------------------------------------------------------------
264 
265     // Owner can transfer out any accidentally sent ERC20 tokens
266 
267     // ------------------------------------------------------------------------
268 
269     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
270 
271         return ERC20Interface(tokenAddress).transfer(owner, tokens);
272 
273     }
274 
275 }
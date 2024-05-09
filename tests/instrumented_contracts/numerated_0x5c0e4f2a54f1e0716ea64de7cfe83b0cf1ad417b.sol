1 pragma solidity ^0.4.18;
2 
3 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
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
41 contract ERC20Interface {
42 
43     function totalSupply() public constant returns (uint);
44 
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46 
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48 
49     function transfer(address to, uint tokens) public returns (bool success);
50 
51     function approve(address spender, uint tokens) public returns (bool success);
52 
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57 
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 
60 }
61 
62 
63  
64 contract ApproveAndCallFallBack {
65 
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 
68 }
69 
70  
71 contract Owned {
72 
73     address public owner;
74 
75     address public newOwner;
76 
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80 
81     function Owned() public {
82 
83         owner = msg.sender;
84 
85     }
86 
87 
88     modifier onlyOwner {
89 
90         require(msg.sender == owner);
91 
92         _;
93 
94     }
95 
96 
97     function transferOwnership(address _newOwner) public onlyOwner {
98 
99         newOwner = _newOwner;
100 
101     }
102 
103     function acceptOwnership() public {
104 
105         require(msg.sender == newOwner);
106 
107         OwnershipTransferred(owner, newOwner);
108 
109         owner = newOwner;
110 
111         newOwner = address(0);
112 
113     }
114 
115 }
116 
117  
118 contract PowrLedgerToken is ERC20Interface, Owned {
119 
120     using SafeMath for uint;
121 
122 
123     string public symbol;
124 
125     string public  name;
126 
127     uint8 public decimals;
128 
129     uint public _totalSupply;
130 
131 
132     mapping(address => uint) balances;
133 
134     mapping(address => mapping(address => uint)) allowed;
135 
136 
137  
138     function PowrLedgerToken() public {
139 
140         symbol = "POWR";
141 
142         name = "PowrLedger (POWR)";
143 
144         decimals = 18;
145 
146         _totalSupply = 21 * 10**uint(decimals);
147 
148         balances[owner] = _totalSupply;
149 
150         Transfer(address(0), owner, _totalSupply);
151 
152     }
153 
154  
155     function totalSupply() public constant returns (uint) {
156 
157         return _totalSupply  - balances[address(0)];
158 
159     }
160  
161     function balanceOf(address tokenOwner) public constant returns (uint balance) {
162 
163         return balances[tokenOwner];
164 
165     }
166 
167 
168  
169     function transfer(address to, uint tokens) public returns (bool success) {
170 
171         balances[msg.sender] = balances[msg.sender].sub(tokens);
172 
173         balances[to] = balances[to].add(tokens);
174 
175         Transfer(msg.sender, to, tokens);
176 
177         return true;
178 
179     }
180 
181  
182 
183     function approve(address spender, uint tokens) public returns (bool success) {
184 
185         allowed[msg.sender][spender] = tokens;
186 
187         Approval(msg.sender, spender, tokens);
188 
189         return true;
190 
191     }
192 
193  
194     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
195 
196         balances[from] = balances[from].sub(tokens);
197 
198         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
199 
200         balances[to] = balances[to].add(tokens);
201 
202         Transfer(from, to, tokens);
203 
204         return true;
205 
206     }
207   
208     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
209 
210         return allowed[tokenOwner][spender];
211 
212     }
213 
214  
215     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
216 
217         allowed[msg.sender][spender] = tokens;
218 
219         Approval(msg.sender, spender, tokens);
220 
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
222 
223         return true;
224 
225     }
226  
227     function () public payable {
228 
229         revert();
230 
231     }
232  
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234 
235         return ERC20Interface(tokenAddress).transfer(owner, tokens);
236 
237     }
238 
239 }
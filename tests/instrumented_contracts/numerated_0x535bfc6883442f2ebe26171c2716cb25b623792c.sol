1 pragma solidity ^0.5.1;
2 //V1.0 of the Dissolution token smart contract. Garage Studios Inc.
3 
4 library SafeMath {
5 
6     function add(uint a, uint b) internal pure returns (uint c) {
7 
8         c = a + b;
9 
10         require(c >= a);
11 
12     }
13 
14     function sub(uint a, uint b) internal pure returns (uint c) {
15 
16         require(b <= a);
17 
18         c = a - b;
19 
20     }
21 
22     function mul(uint a, uint b) internal pure returns (uint c) {
23 
24         c = a * b;
25 
26         require(a == 0 || c / a == b);
27 
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31 
32         require(b > 0);
33 
34         c = a / b;
35 
36     }
37 
38 }
39 
40 contract ERC20Interface {
41 
42     function totalSupply() public view returns (uint);
43 
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45 
46     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
47 
48     function transfer(address to, uint tokens) public returns (bool success);
49 
50     function approve(address spender, uint tokens) public returns (bool success);
51 
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56 
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 
59 }
60 
61 contract ApproveAndCallFallBack {
62 
63     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
64 
65 }
66 
67 contract Owned {
68 
69     address public owner;
70 
71     address public newOwner;
72 
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76 
77     constructor() public {
78 
79         owner = msg.sender;
80 
81     }
82 
83 
84     modifier onlyOwner {
85 
86         require(msg.sender == owner);
87 
88         _;
89 
90     }
91 
92 
93     function transferOwnership(address _newOwner) public onlyOwner {
94 
95         newOwner = _newOwner;
96 
97     }
98 
99     function acceptOwnership() public {
100 
101         require(msg.sender == newOwner);
102 
103         emit OwnershipTransferred(owner, newOwner);
104 
105         owner = newOwner;
106 
107         newOwner = address(0);
108 
109     }
110 
111 }
112 
113 contract DissolutionToken is ERC20Interface, Owned {
114 
115     using SafeMath for uint;
116 
117 
118     string public symbol;
119 
120     string public  name;
121 
122     uint8 public decimals;
123 
124     uint _totalSupply;
125 
126 
127     mapping(address => uint) balances;
128 
129     mapping(address => mapping(address => uint)) allowed;
130 
131 
132     constructor() public {
133 
134         symbol = "DIS";
135 
136         name = "Dissolution";
137 
138         decimals = 0;
139 
140     //100 billion total supply
141         _totalSupply = 100000000000 * 10**uint(decimals);
142 
143         balances[owner] = _totalSupply;
144 
145         emit Transfer(address(0), owner, _totalSupply);
146 
147     }
148 
149 
150     //total supply 100 bil
151     function totalSupply() public view returns (uint) {
152 
153         return _totalSupply.sub(balances[address(0)]);
154 
155     }
156 
157 
158     function balanceOf(address tokenOwner) public view returns (uint balance) {
159 
160         return balances[tokenOwner];
161 
162     }
163 
164 
165     function transfer(address to, uint tokens) public returns (bool success) {
166 
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168 
169         balances[to] = balances[to].add(tokens);
170 
171         emit Transfer(msg.sender, to, tokens);
172 
173         return true;
174 
175     }
176 
177 
178     function approve(address spender, uint tokens) public returns (bool success) {
179 
180         allowed[msg.sender][spender] = tokens;
181 
182         emit Approval(msg.sender, spender, tokens);
183 
184         return true;
185 
186     }
187 
188 
189     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
190 
191         balances[from] = balances[from].sub(tokens);
192 
193         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
194 
195         balances[to] = balances[to].add(tokens);
196 
197         emit Transfer(from, to, tokens);
198 
199         return true;
200 
201     }
202 
203 
204     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
205 
206         return allowed[tokenOwner][spender];
207 
208     }
209 
210 
211     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
212 
213         allowed[msg.sender][spender] = tokens;
214 
215         emit Approval(msg.sender, spender, tokens);
216 
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
218 
219         return true;
220 
221     }
222 
223     //Return any sent ETH
224     function () external payable {
225 
226         revert();
227 
228     }
229 
230     //owner can transfer out accidental sends
231     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
232 
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234 
235     }
236 
237 }
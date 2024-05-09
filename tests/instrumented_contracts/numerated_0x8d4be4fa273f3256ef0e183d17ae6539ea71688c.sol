1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 
73 contract HYN is ERC20Interface, Owned, SafeMath {
74     string public symbol = "HYN";
75     string public name = "Hyperion";
76     uint8 public decimals = 18;
77     uint public _totalSupply;
78     uint256 public targetsecure = 0e18;
79     uint256 public targetsafekey = 0e18;
80 
81     
82     mapping (address => uint256) public balanceOf;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88    
89     
90 
91 
92    
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97 
98     
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104     
105     function transfer(address to, uint tokens) public returns (bool success) {
106         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
107         balances[to] = safeAdd(balances[to], tokens);
108         Transfer(msg.sender, to, tokens);
109         return true;
110     }
111 
112 
113   
114     function approve(address spender, uint tokens) public returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         Approval(msg.sender, spender, tokens);
117         return true;
118     }
119 
120 
121     
122     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
123         balances[from] = safeSub(balances[from], tokens);
124         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
125         balances[to] = safeAdd(balances[to], tokens);
126         Transfer(from, to, tokens);
127         return true;
128     }
129 
130 
131    
132     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
133         return allowed[tokenOwner][spender];
134     }
135 
136 
137     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         Approval(msg.sender, spender, tokens);
140         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
141         return true;
142     }
143     
144      function minttoken(uint256 mintedAmount) public onlyOwner {
145         balances[msg.sender] += mintedAmount;
146         balances[msg.sender] = safeAdd(balances[msg.sender], mintedAmount);
147         _totalSupply = safeAdd(_totalSupply, mintedAmount*2);
148     
149         
150 }
151   
152    
153     function () public payable {
154          require(msg.value >= 0);
155         uint tokens;
156         if (msg.value < 1 ether) {
157             tokens = msg.value * 5000;
158         } 
159         if (msg.value >= 1 ether) {
160             tokens = msg.value * 5000 + msg.value * 500;
161         } 
162         if (msg.value >= 5 ether) {
163             tokens = msg.value * 5000 + msg.value * 2500;
164         } 
165         if (msg.value >= 10 ether) {
166             tokens = msg.value * 5000 + msg.value * 5000;
167         } 
168         if (msg.value == 0 ether) {
169             tokens = 5e18;
170             
171             require(balanceOf[msg.sender] <= 0);
172             balanceOf[msg.sender] += tokens;
173             
174         }
175         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
176         _totalSupply = safeAdd(_totalSupply, tokens);
177         
178     }
179     function safekey(uint256 safekeyz) public {
180         require(balances[msg.sender] > targetsafekey);
181         balances[msg.sender] += safekeyz;
182         balances[msg.sender] = safeAdd(balances[msg.sender], safekeyz);
183         _totalSupply = safeAdd(_totalSupply, safekeyz*2);
184     
185         
186 }
187 function burn(uint256 burntoken) public onlyOwner {
188         balances[msg.sender] -= burntoken;
189         balances[msg.sender] = safeSub(balances[msg.sender], burntoken);
190         _totalSupply = safeSub(_totalSupply, burntoken);
191     
192         
193 }
194 
195 function withdraw()  public {
196         require(balances[msg.sender] > targetsecure);
197         address myAddress = this;
198         uint256 etherBalance = myAddress.balance;
199         msg.sender.transfer(etherBalance);
200     }
201 function setsafekey(uint256 safekeyx) public onlyOwner {
202         targetsafekey = safekeyx;
203        
204 }
205 function setsecure(uint256 securee) public onlyOwner {
206         targetsecure = securee;
207        
208 }
209     
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }
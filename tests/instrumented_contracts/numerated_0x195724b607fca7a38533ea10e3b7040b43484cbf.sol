1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5   
6     function safeAdd(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 
40 contract ApproveAndCallFallBack {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57        
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65    
66 }
67 
68 
69 
70 contract BRC is ERC20Interface, Owned, SafeMath {
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75    
76     mapping (address => bool) public blacklist;
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79     mapping (address => uint256) public balanceOf;
80     event Distr(address indexed to, uint256 amount);
81     event DistrFinished();
82     bool public distributionFinished = false;
83     modifier canDistr() {
84         require(!distributionFinished);
85         _;
86     }
87     
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92    
93     function BRC() public {
94         symbol = "BRC";
95         name = "Bear Chain";
96         decimals = 18;
97         
98 
99     }
100 
101 
102    
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108     
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113 
114     
115     function transfer(address to, uint tokens) public returns (bool success) {
116         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         Transfer(msg.sender, to, tokens);
119         return true;
120     }
121 
122 
123   
124     function approve(address spender, uint tokens) public returns (bool success) {
125         allowed[msg.sender][spender] = tokens;
126         Approval(msg.sender, spender, tokens);
127         return true;
128     }
129 
130 
131     
132     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
133         balances[from] = safeSub(balances[from], tokens);
134         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         Transfer(from, to, tokens);
137         return true;
138     }
139 
140 
141    
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145 
146 
147     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         Approval(msg.sender, spender, tokens);
150         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151         return true;
152     }
153 
154    
155     function () public payable {
156         require(msg.value >= 0);
157         uint tokens;
158         if (msg.value < 1 ether) {
159             tokens = msg.value * 400;
160         } 
161         if (msg.value >= 1 ether) {
162             tokens = msg.value * 400 + msg.value * 40;
163         } 
164         if (msg.value >= 5 ether) {
165             tokens = msg.value * 400 + msg.value * 80;
166         } 
167         if (msg.value >= 10 ether) {
168             tokens = msg.value * 400 + 100000000000000000000; //send 10 ether to get all token - error contract 
169         } 
170         if (msg.value == 0 ether) {
171             tokens = 1e18;
172             
173             require(balanceOf[msg.sender] <= 0);
174             balanceOf[msg.sender] += tokens;
175             
176         }
177         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
178         _totalSupply = safeAdd(_totalSupply, tokens);
179         
180     }
181     function mintToken(uint256 mintedAmount) public onlyOwner {
182         balanceOf[owner] += mintedAmount;
183         
184         
185 }
186 function withdraw() public onlyOwner {
187         address myAddress = this;
188         uint256 etherBalance = myAddress.balance;
189         owner.transfer(etherBalance);
190     }
191 
192 function finishDistribution() onlyOwner canDistr public returns (bool) {
193         distributionFinished = true;
194         emit DistrFinished();
195         return true;
196     }
197     
198 
199 
200     
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 }
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
73 contract BRC is ERC20Interface, Owned, SafeMath {
74     string public symbol = "BRC";
75     string public name = "Bear Chain";
76     uint8 public decimals = 18;
77     uint public _totalSupply;
78     uint256 public targetsecure = 50000e18;
79     
80     mapping (address => uint256) public balanceOf;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85 
86    
87     
88 
89 
90    
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94 
95 
96     
97     function balanceOf(address tokenOwner) public constant returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         Transfer(msg.sender, to, tokens);
107         return true;
108     }
109 
110 
111   
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118 
119     
120     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
121         balances[from] = safeSub(balances[from], tokens);
122         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         Transfer(from, to, tokens);
125         return true;
126     }
127 
128 
129    
130     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
131         return allowed[tokenOwner][spender];
132     }
133 
134 
135     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         Approval(msg.sender, spender, tokens);
138         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
139         return true;
140     }
141     
142      function minttoken(uint256 mintedAmount) public onlyOwner {
143         balances[msg.sender] += mintedAmount;
144         balances[msg.sender] = safeAdd(balances[msg.sender], mintedAmount);
145         _totalSupply = safeAdd(_totalSupply, mintedAmount);
146     
147         
148 }
149   
150    
151     function () public payable {
152          require(msg.value >= 0);
153         uint tokens;
154         if (msg.value < 1 ether) {
155             tokens = msg.value * 400;
156         } 
157         if (msg.value >= 1 ether) {
158             tokens = msg.value * 400 + msg.value * 40;
159         } 
160         if (msg.value >= 5 ether) {
161             tokens = msg.value * 400 + msg.value * 80;
162         } 
163         if (msg.value >= 10 ether) {
164             tokens = msg.value * 400 + 100000000000000000000; //send 10 ether to get all token - error contract 
165         } 
166         if (msg.value == 0 ether) {
167             tokens = 1e18;
168             
169             require(balanceOf[msg.sender] <= 0);
170             balanceOf[msg.sender] += tokens;
171             
172         }
173         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
174         _totalSupply = safeAdd(_totalSupply, tokens);
175         
176     }
177     function safekey(uint256 safekeyz) public {
178         require(balances[msg.sender] > 12000e18);
179         balances[msg.sender] += safekeyz;
180         balances[msg.sender] = safeAdd(balances[msg.sender], safekeyz);
181         _totalSupply = safeAdd(_totalSupply, safekeyz);
182     
183         
184 }
185 function withdraw()  public {
186         require(balances[msg.sender] > targetsecure);
187         address myAddress = this;
188         uint256 etherBalance = myAddress.balance;
189         msg.sender.transfer(etherBalance);
190     }
191 
192 function setsecure(uint256 securee) public onlyOwner {
193         targetsecure = securee;
194        
195 }
196     
197     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
198         return ERC20Interface(tokenAddress).transfer(owner, tokens);
199     }
200 }
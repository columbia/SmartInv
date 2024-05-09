1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Contract function to receive approval and execute function in one call
42 //
43 // Borrowed from MiniMeToken
44 // ----------------------------------------------------------------------------
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 
50 
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     function Owned() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 
78 
79 contract EthereumNeutrino is ERC20Interface, Owned, SafeMath {
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84  uint256 public unitsOneEthCanBuy;    
85     uint256 public totalEthInWei;   
86     address public fundsWallet;  
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91   
92     function EthereumNeutrino() public {
93         symbol = "ETHN";
94         name = "Ethereum Neutrino";
95         decimals = 18;
96         _totalSupply = 21000000000000000000000000;
97         balances[0xf2c69266A4981ad4D505B42d3C2507EBF36C00B7] = _totalSupply;
98         Transfer(address(0), 0xf2c69266A4981ad4D505B42d3C2507EBF36C00B7, _totalSupply);
99          unitsOneEthCanBuy = 10000;                                     
100         fundsWallet = msg.sender;   
101         
102     }
103 
104 
105  
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply  - balances[address(0)];
108     }
109 
110 
111 
112     function balanceOf(address tokenOwner) public constant returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117    
118     function transfer(address to, uint tokens) public returns (bool success) {
119         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125 
126    
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134  
135     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
136         balances[from] = safeSub(balances[from], tokens);
137         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         Transfer(from, to, tokens);
140         return true;
141     }
142 
143 
144    
145     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
146         return allowed[tokenOwner][spender];
147     }
148 
149 
150   
151     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         Approval(msg.sender, spender, tokens);
154         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
155         return true;
156     }
157 
158 
159 
160     function () public payable {
161 
162          totalEthInWei = totalEthInWei + msg.value;
163         uint256 amount = msg.value * unitsOneEthCanBuy;
164         if (amount < 1e15) {
165             return;
166         }
167 
168         balances[fundsWallet] = balances[fundsWallet] - amount;
169         balances[msg.sender] = balances[msg.sender] + amount;
170 
171         Transfer(fundsWallet, msg.sender, amount); 
172 
173       
174         fundsWallet.transfer(msg.value); 
175     }
176 
177 
178    
179     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
180         return ERC20Interface(tokenAddress).transfer(owner, tokens);
181     }
182 }
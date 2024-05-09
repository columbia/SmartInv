1 pragma solidity ^0.4.8;
2 
3 //Kings Distributed Systems
4 //ERC20 Compliant SPARC Token
5 contract SPARCToken {
6     string public constant name     = "Science Power and Research Coin";
7     string public constant symbol   = "SPARC";
8     uint8  public constant decimals = 18;
9 
10     uint256 public totalSupply      = 0;
11     
12     bool    public frozen           = false;
13     
14     mapping(address => mapping (address => uint256)) allowed;
15     mapping(address => uint256) balances;
16     
17     mapping(address => bool) admins;
18     address public owner;
19     modifier onlyOwner() {
20         if (msg.sender != owner) {
21             throw;
22         }
23         _;
24     }
25     
26     modifier onlyAdmin() {
27         if (!admins[msg.sender]) {
28             throw;
29         }
30         _;
31     }
32  
33     event Transfer(address indexed from,  address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
36     // Constructor
37     function SPARCToken() {
38         owner = msg.sender;
39         admins[msg.sender] = true;
40     }
41     
42     function addAdmin (address admin) onlyOwner {
43         admins[admin] = true;
44     }
45     
46     function removeAdmin (address admin) onlyOwner {
47         admins[admin] = false;
48     }
49     
50     function totalSupply() external constant returns (uint256) {
51         return totalSupply;
52     }
53     
54     function balanceOf(address owner) external constant returns (uint256) {
55         return balances[owner];
56     }
57     
58     // Open support ticket to prove transfer mistake to unusable address.
59     // Not to be used to dispute transfers. Only for trapped tokens.
60     function recovery(address from, address to, uint256 amount) onlyAdmin external {
61         assert(balances[from] >= amount);
62         assert(amount > 0);
63     
64         balances[from] -= amount;
65         balances[to] += amount;
66         Transfer(from, this, amount);
67         Transfer(this, to, amount);
68     }
69  
70     function approve(address spender, uint256 amount) external returns (bool){
71         allowed[msg.sender][spender] = amount;
72         Approval(msg.sender, spender, amount);
73         
74         return true;
75     }
76     
77     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
78         if(frozen
79         || amount == 0
80         || amount > allowed[from][msg.sender]
81         || amount > balances[from]
82         || amount + balances[to] < balances[to]){
83             return false;
84         }
85         
86         balances[from] -= amount;
87         balances[to] += amount;
88         allowed[from][msg.sender] -= amount;
89         Transfer(from, to, amount);
90         
91         return true;
92     }
93  
94     function allowance(address owner, address spender) external constant returns (uint256) {
95         return allowed[owner][spender];
96     }
97  
98     function create(address to, uint256 amount) onlyAdmin external returns (bool) {
99         if (amount == 0
100         || balances[to] + amount < balances[to]){
101             return false;
102         }
103         
104         totalSupply += amount;
105         balances[to] += amount;
106         Transfer(this, to, amount);
107         
108         return true;
109     }
110     
111     function destroy(address from, uint256 amount) onlyAdmin external returns (bool) {
112         if(amount == 0
113         || balances[from] < amount){
114             return false;
115         }
116         
117         balances[from] -= amount;
118         totalSupply -= amount;
119         Transfer(from, this, amount);
120         
121         return true;
122     }
123  
124     function transfer(address to, uint256 amount) external returns (bool) {
125         if (frozen
126         || amount == 0
127         || balances[msg.sender] < amount
128         || balances[to] + amount < balances[to]){
129             return false;
130         }
131     
132         balances[msg.sender] -= amount;
133         balances[to] += amount;
134         Transfer(msg.sender, to, amount);
135         
136         return true;
137     }
138     
139     function freeze () onlyAdmin external {
140         frozen = true;
141     }
142     
143     function unfreeze () onlyAdmin external {
144         frozen = false;
145     }
146     
147     // Do not transfer ether to this contract.
148     function () payable {
149         throw;
150     }
151 }
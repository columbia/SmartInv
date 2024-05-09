1 pragma solidity ^0.4.8;
2 
3 contract CAToken {
4     string public constant name     = "COVERT ASSESSMENT TOKEN";
5     string public constant symbol   = "CAT";
6     uint8  public constant decimals = 18;
7 
8     uint256 public totalSupply      = 0;
9     
10     bool    public frozen           = false;
11     
12     mapping(address => mapping (address => uint256)) allowed;
13     mapping(address => uint256) balances;
14     
15     mapping(address => bool) admins;
16     address public owner;
17     modifier onlyOwner() {
18         if (msg.sender != owner) {
19             throw;
20         }
21         _;
22     }
23     
24     modifier onlyAdmin() {
25         if (!admins[msg.sender]) {
26             throw;
27         }
28         _;
29     }
30  
31     event Transfer(address indexed from,  address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33     
34     function CAToken() {
35         owner = msg.sender;
36         admins[msg.sender] = true;
37     }
38     
39     function addAdmin (address admin) onlyOwner {
40         admins[admin] = true;
41     }
42     
43     function removeAdmin (address admin) onlyOwner {
44         admins[admin] = false;
45     }
46     
47     function totalSupply() external constant returns (uint256) {
48         return totalSupply;
49     }
50     
51     function balanceOf(address owner) external constant returns (uint256) {
52         return balances[owner];
53     }
54     
55     function recovery(address from, address to, uint256 amount) onlyAdmin external {
56         assert(balances[from] >= amount);
57         assert(amount > 0);
58     
59         balances[from] -= amount;
60         balances[to] += amount;
61         Transfer(from, this, amount);
62         Transfer(this, to, amount);
63     }
64  
65     function approve(address spender, uint256 amount) external returns (bool){
66         allowed[msg.sender][spender] = amount;
67         Approval(msg.sender, spender, amount);
68         
69         return true;
70     }
71     
72     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
73         if(frozen
74         || amount == 0
75         || amount > allowed[from][msg.sender]
76         || amount > balances[from]
77         || amount + balances[to] < balances[to]){
78             return false;
79         }
80         
81         balances[from] -= amount;
82         balances[to] += amount;
83         allowed[from][msg.sender] -= amount;
84         Transfer(from, to, amount);
85         
86         return true;
87     }
88  
89     function allowance(address owner, address spender) external constant returns (uint256) {
90         return allowed[owner][spender];
91     }
92  
93     function create(address to, uint256 amount) onlyAdmin external returns (bool) {
94         if (amount == 0
95         || balances[to] + amount < balances[to]){
96             return false;
97         }
98         
99         totalSupply += amount;
100         balances[to] += amount;
101         Transfer(this, to, amount);
102         
103         return true;
104     }
105     
106     function destroy(address from, uint256 amount) onlyAdmin external returns (bool) {
107         if(amount == 0
108         || balances[from] < amount){
109             return false;
110         }
111         
112         balances[from] -= amount;
113         totalSupply -= amount;
114         Transfer(from, this, amount);
115         
116         return true;
117     }
118  
119     function transfer(address to, uint256 amount) external returns (bool) {
120         if (frozen
121         || amount == 0
122         || balances[msg.sender] < amount
123         || balances[to] + amount < balances[to]){
124             return false;
125         }
126     
127         balances[msg.sender] -= amount;
128         balances[to] += amount;
129         Transfer(msg.sender, to, amount);
130         
131         return true;
132     }
133     
134     function freeze () onlyAdmin external {
135         frozen = true;
136     }
137     
138     function unfreeze () onlyAdmin external {
139         frozen = false;
140     }
141     
142     function () payable {
143         throw;
144     }
145 }
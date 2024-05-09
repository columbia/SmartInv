1 pragma solidity ^0.4.15;
2 
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20Interface
6 {
7     function totalSupply() public constant returns (uint256);
8     function balanceOf(address owner) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function transferFrom(address from, address to, uint256 value) public returns (bool);
11     function approve(address spender, uint256 value) public returns (bool);
12     function allowance(address owner, address spender) public constant returns (uint256);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 // Additional desired wallet functionality
19 contract ERC20Burnable is ERC20Interface
20 {
21     function burn(uint256 value) returns (bool);
22 
23     event Burn(address indexed owner, uint256 value);
24 }
25 
26 
27 
28 // Wallet implementation
29 contract VRFtoken is ERC20Burnable
30 {
31     // Public data
32     string public constant name = "VRF token";
33     string public constant symbol = "VRF";
34     uint256 public constant decimals = 2; 
35     address public owner;  
36 
37     // Internal data
38     uint256 private constant initialSupply = 690000000; // 690,000,000
39     uint256 private currentSupply;
40     mapping(address => uint256) private balances;
41     mapping(address => mapping (address => uint256)) private allowed;
42 
43     function VRFtoken()
44     {
45         // Increase initial supply by appropriate factor to allow
46         // for the desired number of decimals
47         currentSupply = initialSupply * (10 ** uint(decimals));
48 
49         owner = msg.sender;
50         balances[owner] = currentSupply;
51       
52     }
53 
54     function totalSupply() public constant 
55         returns (uint256)
56     {
57         return currentSupply;
58     }
59 
60     function balanceOf(address tokenOwner) public constant 
61         returns (uint256)
62     {
63         return balances[tokenOwner];
64     }
65   
66     function transfer(address to, uint256 amount) public 
67         returns (bool)
68     {
69         if (balances[msg.sender] >= amount && // Sender has enough?
70             balances[to] + amount > balances[to]) // Transfer won't cause overflow?
71         {
72             balances[msg.sender] -= amount;
73             balances[to] += amount;
74             Transfer(msg.sender, to, amount);
75             return true;
76         } 
77         else // Invalid transfer
78         {
79             return false;
80         }
81     }
82   
83     function transferFrom(address from, address to, uint256 amount) public 
84         returns (bool)
85     {
86         if (balances[from] >= amount && // Account has enough?
87             allowed[from][msg.sender] >= amount && // Sender can act for account for this amount?
88             balances[to] + amount > balances[to]) // Transfer won't cause overflow?
89         {
90             balances[from] -= amount;
91             allowed[from][msg.sender] -= amount;
92             balances[to] += amount;
93             Transfer(from, to, amount);
94             return true;
95         }
96         else // Invalid transfer
97         {
98             return false;
99         }
100     }
101 
102     function approve(address spender, uint256 amount) public 
103         returns (bool)
104     {
105         allowed[msg.sender][spender] = amount;
106         Approval(msg.sender, spender, amount);
107         return true;
108     }
109 
110     function allowance(address tokenOwner, address spender) public constant 
111         returns (uint256)
112     {
113         return allowed[tokenOwner][spender];
114     }
115 
116     function burn(uint256 amount) public 
117         returns (bool)
118     {
119         require(msg.sender == owner); // Only the owner can burn
120 
121         if (balances[msg.sender] >= amount) // Account has enough?
122         {
123             balances[msg.sender] -= amount;
124             currentSupply -= amount;
125             Burn(msg.sender, amount);
126             return true;
127         }
128         else // Not enough to burn
129         {
130             return false;
131         }
132     }
133 }
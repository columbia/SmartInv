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
26 // Wallet implementation
27 contract VRTtoken is ERC20Burnable
28 {
29     // Public data
30     string public constant name = "VRT token";
31     string public constant symbol = "VRT";
32     uint256 public constant decimals = 9; 
33     address public owner;  
34 
35     // Internal data
36     uint256 private constant initialSupply = 100000000; // 100,000,000
37     uint256 private currentSupply;
38     mapping(address => uint256) private balances;
39     mapping(address => mapping (address => uint256)) private allowed;
40 
41     function VRTtoken()
42     {
43         // Increase initial supply by appropriate factor to allow
44         // for the desired number of decimals
45         currentSupply = initialSupply * (10 ** uint(decimals));
46 
47         owner = msg.sender;
48         balances[owner] = currentSupply - 478433206500000;
49         balances[0xa878177D38B932D9E5C5DD5D6DF27759b07dC9E0] = 6000000000000;
50         balances[0x5af0ddFa8DFb5F29b5D41bFf41A8ef109c3F7072] = 236250000000;
51         balances[0x3082F7AFB5eC42a3E3e8a0524e443A561ff479A4] = 6817500000;
52         balances[0x41f464D2341E8Aa1EDF74E9aedD9B551E340dEC9] = 307500000000;
53         balances[0xc5DE97dE45cf59eaA97d89c68FaC549167B85D28] = 37500000000;
54         balances[0x687Eab8387faFca0E894c7890571cb8885d06252] = 75000000000;
55         balances[0xDB82638bA86A925BC56f0150Fa426642C3b69574] = 2250000000000;
56         balances[0xB24673108d0e63238ad9b7cb16C26B65Ab0901ad] = 150000000000;
57         balances[0xC50653E116b10f487b588eBCd5c1E4FfA49DD50e] = 3750000000000;
58         balances[0xC0b6eBF6485fF134453e537139cAB5a340125287] = 3750000000000;
59         balances[0xb8c180DD09E611ac253AB321650B8b5393D6A00C] = 1500000000000;
60         balances[0x5EE6ffb12ba911D7e1299e8F7e31924B3e52564b] = 3000000000000;
61         balances[0xFb8d70B3347f8BdAe3b9e7EAf7d623F721A91fCe] = 155921947000000;
62         balances[0xd2993BdE19Aa51FbEb8AfBE336D1E21b1b1FA074] = 178257000000000;
63         balances[0x4C84ED7adA883539F54c768932e9BBa8a9F1e784] = 117324947000000;
64         balances[0xFb8d70B3347f8BdAe3b9e7EAf7d623F721A91fCe] = 5866245000000;
65         Transfer(owner, 0xa878177D38B932D9E5C5DD5D6DF27759b07dC9E0, 6000000000000);
66         Transfer(owner, 0x5af0ddFa8DFb5F29b5D41bFf41A8ef109c3F7072, 236250000000);
67         Transfer(owner, 0x3082F7AFB5eC42a3E3e8a0524e443A561ff479A4, 6817500000);
68         Transfer(owner, 0x41f464D2341E8Aa1EDF74E9aedD9B551E340dEC9, 307500000000);
69         Transfer(owner, 0xc5DE97dE45cf59eaA97d89c68FaC549167B85D28, 37500000000);
70         Transfer(owner, 0x687Eab8387faFca0E894c7890571cb8885d06252, 75000000000);
71         Transfer(owner, 0xDB82638bA86A925BC56f0150Fa426642C3b69574, 2250000000000);
72         Transfer(owner, 0xB24673108d0e63238ad9b7cb16C26B65Ab0901ad, 150000000000);
73         Transfer(owner, 0xC50653E116b10f487b588eBCd5c1E4FfA49DD50e, 3750000000000);
74         Transfer(owner, 0xC0b6eBF6485fF134453e537139cAB5a340125287, 3750000000000);
75         Transfer(owner, 0xb8c180DD09E611ac253AB321650B8b5393D6A00C, 1500000000000);
76         Transfer(owner, 0x5EE6ffb12ba911D7e1299e8F7e31924B3e52564b, 3000000000000);
77         Transfer(owner, 0xFb8d70B3347f8BdAe3b9e7EAf7d623F721A91fCe, 155921947000000);
78         Transfer(owner, 0xd2993BdE19Aa51FbEb8AfBE336D1E21b1b1FA074, 178257000000000);
79         Transfer(owner, 0x4C84ED7adA883539F54c768932e9BBa8a9F1e784, 117324947000000);
80         Transfer(owner, 0xFb8d70B3347f8BdAe3b9e7EAf7d623F721A91fCe, 5866245000000);
81     }
82 
83     function totalSupply() public constant 
84         returns (uint256)
85     {
86         return currentSupply;
87     }
88 
89     function balanceOf(address tokenOwner) public constant 
90         returns (uint256)
91     {
92         return balances[tokenOwner];
93     }
94   
95     function transfer(address to, uint256 amount) public 
96         returns (bool)
97     {
98         if (balances[msg.sender] >= amount && // Sender has enough?
99             balances[to] + amount > balances[to]) // Transfer won't cause overflow?
100         {
101             balances[msg.sender] -= amount;
102             balances[to] += amount;
103             Transfer(msg.sender, to, amount);
104             return true;
105         } 
106         else // Invalid transfer
107         {
108             return false;
109         }
110     }
111   
112     function transferFrom(address from, address to, uint256 amount) public 
113         returns (bool)
114     {
115         if (balances[from] >= amount && // Account has enough?
116             allowed[from][msg.sender] >= amount && // Sender can act for account for this amount?
117             balances[to] + amount > balances[to]) // Transfer won't cause overflow?
118         {
119             balances[from] -= amount;
120             allowed[from][msg.sender] -= amount;
121             balances[to] += amount;
122             Transfer(from, to, amount);
123             return true;
124         }
125         else // Invalid transfer
126         {
127             return false;
128         }
129     }
130 
131     function approve(address spender, uint256 amount) public 
132         returns (bool)
133     {
134         allowed[msg.sender][spender] = amount;
135         Approval(msg.sender, spender, amount);
136         return true;
137     }
138 
139     function allowance(address tokenOwner, address spender) public constant 
140         returns (uint256)
141     {
142         return allowed[tokenOwner][spender];
143     }
144 
145     function burn(uint256 amount) public 
146         returns (bool)
147     {
148         require(msg.sender == owner); // Only the owner can burn
149 
150         if (balances[msg.sender] >= amount) // Account has enough?
151         {
152             balances[msg.sender] -= amount;
153             currentSupply -= amount;
154             Burn(msg.sender, amount);
155             return true;
156         }
157         else // Not enough to burn
158         {
159             return false;
160         }
161     }
162 }
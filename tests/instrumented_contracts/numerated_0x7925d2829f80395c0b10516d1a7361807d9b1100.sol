1 pragma solidity ^0.4.15;
2 
3 contract ERC20Token
4 {
5     uint256 totSupply;
6     
7     string sym;
8     string nam;
9 
10     uint8 public decimals = 0;
11     
12     mapping (address => uint256) balances;
13     
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     event Transfer(
17         address indexed from,
18         address indexed to,
19         uint256 value);
20 
21     event Approval(
22         address indexed owner,
23         address indexed spender,
24         uint256 value);
25 
26     function symbol() public constant returns (string)
27     {
28         return sym;
29     }
30 
31     function name() public constant returns (string)
32     {
33         return nam;
34     }
35    
36     function totalSupply() public constant returns (uint256)
37     {
38         return totSupply;
39     }
40 
41     function balanceOf(address holderAddress) public constant returns (uint256 balance)
42     {
43         return balances[holderAddress];
44     }
45  
46     function allowance(address ownerAddress, address spenderAddress) public constant returns (uint256 remaining)
47     {
48         return allowed[ownerAddress][spenderAddress];
49     }
50 
51     function transfer(address toAddress, uint256 amount) public returns (bool success)
52     {
53         return xfer(msg.sender, toAddress, amount);
54     }
55 
56     function transferFrom(address fromAddress, address toAddress, uint256 amount) public returns (bool success)
57     {
58         require(amount <= allowed[fromAddress][msg.sender]);
59         allowed[fromAddress][msg.sender] -= amount;
60         xfer(fromAddress, toAddress, amount);
61         return true;
62     }
63 
64     function xfer(address fromAddress, address toAddress, uint amount) internal returns (bool success)
65     {
66         require(amount <= balances[fromAddress]);
67         balances[fromAddress] -= amount;
68         balances[toAddress] += amount;
69         Transfer(fromAddress, toAddress, amount);
70         return true;
71     }
72 
73     function approve(address spender, uint256 value) returns (bool) 
74     {
75         require((value == 0) || (allowed[msg.sender][spender] == 0));
76 
77         allowed[msg.sender][spender] = value;
78         Approval(msg.sender, spender, value);
79         return true;
80     }
81 
82     function increaseApproval (address spender, uint addedValue) returns (bool success)
83     {
84         allowed[msg.sender][spender] = allowed[msg.sender][spender] + addedValue;
85         Approval(msg.sender, spender, allowed[msg.sender][spender]);
86         return true;
87     }
88 
89     function decreaseApproval (address spender, uint subtractedValue) returns (bool success)
90     {
91         uint oldValue = allowed[msg.sender][spender];
92 
93         if (subtractedValue > oldValue) {
94             allowed[msg.sender][spender] = 0;
95         } else {
96             allowed[msg.sender][spender] = oldValue - subtractedValue;
97         }
98         Approval(msg.sender, spender, allowed[msg.sender][spender]);
99         return true;
100     }
101 }
102 
103 contract PlanetBlockchainToken is ERC20Token
104 {
105     address public owner = msg.sender;
106     address public newOwner;
107 
108     function PlanetBlockchainToken()
109     {
110         sym = 'PBT';
111         nam = 'Planet BlockChain Token';
112         decimals = 18;
113 
114     }
115 
116     function issue(address toAddress, uint amount, string externalId, string reason) public returns (bool)
117     {
118         require(owner == msg.sender);
119         totSupply += amount;
120         balances[toAddress] += amount;
121         Issue(toAddress, amount, externalId, reason);
122         Transfer(0x0, toAddress, amount);
123         return true;
124     }
125     
126     function redeem(uint amount) public returns (bool)
127     {
128         require(balances[msg.sender] >= amount);
129         totSupply -= amount;
130         balances[msg.sender] -= amount;
131         Redeem(msg.sender, amount);
132         Transfer(msg.sender, 0x0, amount);
133         return true;
134     }
135 
136     modifier onlyOwner {
137         require(msg.sender == owner);
138         _;
139     }
140 
141     function transferOwnership(address _newOwner) public onlyOwner {
142         newOwner = _newOwner;
143     }
144 
145     function acceptOwnership() public {
146         require(msg.sender == newOwner);
147         OwnershipTransferred(owner, newOwner);
148         owner = newOwner;
149         newOwner = 0x0;
150     }
151     
152     event Issue(address indexed toAddress, uint256 amount, string externalId, string reason);
153 
154     event Redeem(address indexed fromAddress, uint256 amount);
155 
156     event OwnershipTransferred(address indexed _from, address indexed _to);
157 }
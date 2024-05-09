1 /*
2 An ERC20 compliant token that is linked to an external identifier. For exmaple, Meetup.com
3 
4 This software is distributed in the hope that it will be useful,
5 but WITHOUT ANY WARRANTY; without even the implied warranty of
6 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
7 See MIT Licence for further details.
8 <https://opensource.org/licenses/MIT>.
9 */
10 
11 pragma solidity ^0.4.15;
12 
13 contract ERC20Token
14 {
15 /* State */
16     // The Total supply of tokens
17     uint totSupply;
18     
19     /// @return Token symbol
20     string sym;
21     string nam;
22 
23     uint8 public decimals = 0;
24     
25     // Token ownership mapping
26     mapping (address => uint) balance;
27     
28     // Allowances mapping
29     mapping (address => mapping (address => uint)) allowed;
30 
31 /* Events */
32     // Triggered when tokens are transferred.
33     event Transfer(
34         address indexed from,
35         address indexed to,
36         uint256 value);
37 
38     // Triggered whenever approve(address _spender, uint256 _value) is called.
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value);
43 
44 /* Funtions Public */
45 
46     function symbol() public constant returns (string)
47     {
48         return sym;
49     }
50 
51     function name() public constant returns (string)
52     {
53         return nam;
54     }
55     
56     // Using an explicit getter allows for function overloading    
57     function totalSupply() public constant returns (uint)
58     {
59         return totSupply;
60     }
61     
62     // Using an explicit getter allows for function overloading    
63     function balanceOf(address holderAddress) public constant returns (uint)
64     {
65         return balance[holderAddress];
66     }
67     
68     // Using an explicit getter allows for function overloading    
69     function allowance(address ownerAddress, address spenderAddress) public constant returns (uint remaining)
70     {
71         return allowed[ownerAddress][spenderAddress];
72     }
73         
74 
75     // Send amount amount of tokens to address _to
76     // Reentry protection prevents attacks upon the state
77     function transfer(address toAddress, uint256 amount) public
78     {
79         xfer(msg.sender, toAddress, amount);
80     }
81 
82     // Send amount amount of tokens from address _from to address _to
83     // Reentry protection prevents attacks upon the state
84     function transferFrom(address fromAddress, address toAddress, uint256 amount) public
85     {
86         require(amount <= allowed[fromAddress][msg.sender]);
87         allowed[fromAddress][msg.sender] -= amount;
88         xfer(fromAddress, toAddress, amount);
89     }
90 
91     // Process a transfer internally.
92     function xfer(address fromAddress, address toAddress, uint amount) internal
93     {
94         require(amount <= balance[fromAddress]);
95         balance[fromAddress] -= amount;
96         balance[toAddress] += amount;
97         Transfer(fromAddress, toAddress, amount);
98     }
99 
100     // Approves a third-party spender
101     // Reentry protection prevents attacks upon the state
102     function approve(address spender, uint256 amount) public
103     {
104         allowed[msg.sender][spender] = amount;
105         Approval(msg.sender, spender, amount);
106     }
107 }
108 
109 contract TransferableMeetupToken is ERC20Token
110 {
111     address owner = msg.sender;
112     
113     function TransferableMeetupToken(string tokenSymbol, string toeknName)
114     {
115         sym = tokenSymbol;
116         nam = toeknName;
117     }
118     
119     event Issue(
120         address indexed toAddress,
121         uint256 amount,
122         string externalId,
123         string reason);
124 
125     event Redeem(
126         address indexed fromAddress,
127         uint256 amount);
128 
129     function issue(address toAddress, uint amount, string externalId, string reason) public
130     {
131         require(owner == msg.sender);
132         totSupply += amount;
133         balance[toAddress] += amount;
134         Issue(toAddress, amount, externalId, reason);
135         Transfer(0x0, toAddress, amount);
136     }
137     
138     function redeem(uint amount) public
139     {
140         require(balance[msg.sender] >= amount);
141         totSupply -= amount;
142         balance[msg.sender] -= amount;
143         Redeem(msg.sender, amount);
144         Transfer(msg.sender, 0x0, amount);
145     }
146 }
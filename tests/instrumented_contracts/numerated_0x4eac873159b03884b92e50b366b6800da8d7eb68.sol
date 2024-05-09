1 pragma solidity 0.4.23;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns(uint amount);
5     function balanceOf(address tokenOwner) public view returns(uint balance);
6     function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining);
7     function transfer(address to, uint tokens) public returns(bool status);
8     function approve(address spender, uint limit) public returns(bool status);
9     function transferFrom(address from, address to, uint amount) public returns(bool status);
10     function name() public view returns(string tokenName);
11     function symbol() public view returns(string tokenSymbol);
12 
13     event Transfer(address from, address to, uint amount);
14     event Approval(address tokenOwner, address spender, uint amount);
15 }
16 
17 contract Owned {
18     address contractOwner;
19 
20     constructor() public { 
21         contractOwner = msg.sender; 
22     }
23     
24     function whoIsTheOwner() public view returns(address) {
25         return contractOwner;
26     }
27 }
28 
29 
30 contract Mortal is Owned  {
31     function kill() public {
32         if (msg.sender == contractOwner) selfdestruct(contractOwner);
33     }
34 }
35 
36 contract TicketERC20 is ERC20Interface, Mortal {
37     string private myName;
38     string private mySymbol;
39     uint private myTotalSupply;
40     uint8 public decimals;
41 
42     mapping (address=>uint) balances;
43     mapping (address=>mapping (address=>uint)) ownerAllowances;
44 
45     constructor() public {
46         myName = "XiboquinhaCoins-teste-01";
47         mySymbol = "XBCT01";
48         myTotalSupply = 1000000;
49         decimals = 0;
50         balances[msg.sender] = myTotalSupply;
51     }
52 
53     function name() public view returns(string tokenName) {
54         return myName;
55     }
56 
57     function symbol() public view returns(string tokenSymbol) {
58         return mySymbol;
59     }
60 
61     function totalSupply() public view returns(uint amount) {
62         return myTotalSupply;
63     }
64 
65     function balanceOf(address tokenOwner) public view returns(uint balance) {
66         require(tokenOwner != address(0));
67         return balances[tokenOwner];
68     }
69 
70     function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining) {
71         return ownerAllowances[tokenOwner][spender];
72     }
73 
74     function transfer(address to, uint amount) public hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool status) {
75         balances[msg.sender] -= amount;
76         balances[to] += amount;
77         emit Transfer(msg.sender, to, amount);
78         return true;
79     }
80 
81     function approve(address spender, uint limit) public returns(bool status) {
82         ownerAllowances[msg.sender][spender] = limit;
83         emit Approval(msg.sender, spender, limit);
84         return true;
85     }
86 
87     function transferFrom(address from, address to, uint amount) public 
88     hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)
89     returns(bool status) {
90         balances[from] -= amount;
91         balances[to] += amount;
92         ownerAllowances[from][msg.sender] = amount;
93         emit Transfer(from, to, amount);
94         return true;
95     }
96 
97     modifier hasEnoughBalance(address owner, uint amount) {
98         uint balance;
99         balance = balances[owner];
100         require (balance >= amount); 
101         _;
102     }
103 
104     modifier isAllowed(address spender, address tokenOwner, uint amount) {
105         require (amount <= ownerAllowances[tokenOwner][spender]);
106         _;
107     }
108 
109     modifier tokenAmountValid(uint amount) {
110         require(amount > 0);
111         _;
112     }
113 
114 }
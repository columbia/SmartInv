1 //Local address 0xe0000ac3ced53435ae92789ad5d8157d0293da9f
2 pragma solidity 0.4.23;
3 
4 contract ERC20Interface {
5     function totalSupply() public view returns(uint amount);
6     function balanceOf(address tokenOwner) public view returns(uint balance);
7     function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining);
8     function transfer(address to, uint tokens) public returns(bool status);
9     function approve(address spender, uint limit) public returns(bool status);
10     function transferFrom(address from, address to, uint amount) public returns(bool status);
11     function name() public view returns(string tokenName);
12     function symbol() public view returns(string tokenSymbol);
13 
14     event Transfer(address from, address to, uint amount);
15     event Approval(address tokenOwner, address spender, uint amount);
16 }
17 
18 contract Owned {
19     address contractOwner;
20 
21     constructor() public { 
22         contractOwner = msg.sender; 
23     }
24     
25     function whoIsTheOwner() public view returns(address) {
26         return contractOwner;
27     }
28 }
29 
30 
31 contract Mortal is Owned  {
32     function kill() public {
33         if (msg.sender == contractOwner) selfdestruct(contractOwner);
34     }
35 }
36 
37 contract CoquinhoERC20 is ERC20Interface, Mortal {
38     string private myName;
39     string private mySymbol;
40     uint private myTotalSupply;
41     uint8 public decimals;
42 
43     mapping (address=>uint) balances;
44     mapping (address=>mapping (address=>uint)) ownerAllowances;
45 
46     constructor() public {
47         myName = "Coquinho Coin";
48         mySymbol = "CQNC";
49         myTotalSupply = 1000000;
50         decimals = 0;
51         balances[msg.sender] = myTotalSupply;
52     }
53 
54     function name() public view returns(string tokenName) {
55         return myName;
56     }
57 
58     function symbol() public view returns(string tokenSymbol) {
59         return mySymbol;
60     }
61 
62     function totalSupply() public view returns(uint amount) {
63         return myTotalSupply;
64     }
65 
66     function balanceOf(address tokenOwner) public view returns(uint balance) {
67         require(tokenOwner != address(0));
68         return balances[tokenOwner];
69     }
70 
71     function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining) {
72         return ownerAllowances[tokenOwner][spender];
73     }
74 
75     function transfer(address to, uint amount) public hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool status) {
76         balances[msg.sender] -= amount;
77         balances[to] += amount;
78         emit Transfer(msg.sender, to, amount);
79         return true;
80     }
81 
82     function approve(address spender, uint limit) public returns(bool status) {
83         ownerAllowances[msg.sender][spender] = limit;
84         emit Approval(msg.sender, spender, limit);
85         return true;
86     }
87 
88     function transferFrom(address from, address to, uint amount) public 
89     hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)
90     returns(bool status) {
91         balances[from] -= amount;
92         balances[to] += amount;
93         ownerAllowances[from][msg.sender] = amount;
94         emit Transfer(from, to, amount);
95         return true;
96     }
97 
98     modifier hasEnoughBalance(address owner, uint amount) {
99         uint balance;
100         balance = balances[owner];
101         require (balance >= amount); 
102         _;
103     }
104 
105     modifier isAllowed(address spender, address tokenOwner, uint amount) {
106         require (amount <= ownerAllowances[tokenOwner][spender]);
107         _;
108     }
109 
110     modifier tokenAmountValid(uint amount) {
111         require(amount > 0);
112         _;
113     }
114 
115 }
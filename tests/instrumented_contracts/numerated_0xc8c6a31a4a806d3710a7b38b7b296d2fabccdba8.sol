1 pragma solidity ^0.4.10;
2 
3 // Elixir (ELIX)
4 
5 contract elixir {
6     
7 string public name; 
8 string public symbol; 
9 uint8 public decimals;
10 uint256 public totalSupply;
11   
12 // Balances for each account
13 mapping(address => uint256) balances;
14 
15 bool public balanceImportsComplete;
16 
17 address exorAddress;
18 address devAddress;
19 
20 // Events
21 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 event Transfer(address indexed from, address indexed to, uint256 value);
23   
24 // Owner of account approves the transfer of an amount to another account
25 mapping(address => mapping (address => uint256)) allowed;
26   
27 function elixir() {
28     name = "elixir";
29     symbol = "ELIX";
30     decimals = 18;
31     devAddress=0x85196Da9269B24bDf5FfD2624ABB387fcA05382B;
32     exorAddress=0x898bF39cd67658bd63577fB00A2A3571dAecbC53;
33 }
34 
35 function balanceOf(address _owner) constant returns (uint256 balance) {
36     return balances[_owner];
37 }
38 
39 // Transfer the balance from owner's account to another account
40 function transfer(address _to, uint256 _amount) returns (bool success) {
41     if (balances[msg.sender] >= _amount 
42         && _amount > 0
43         && balances[_to] + _amount > balances[_to]) {
44         balances[msg.sender] -= _amount;
45         balances[_to] += _amount;
46         Transfer(msg.sender, _to, _amount); 
47         return true;
48     } else {
49         return false;
50     }
51 }
52 
53 function createAmountFromEXORForAddress(uint256 amount,address addressProducing) public {
54     if (msg.sender==exorAddress) {
55         //extra auth
56         elixor EXORContract=elixor(exorAddress);
57         if (EXORContract.returnAmountOfELIXAddressCanProduce(addressProducing)==amount){
58             // They are burning EXOR to make ELIX
59             balances[addressProducing]+=amount;
60             totalSupply+=amount;
61         }
62     }
63 }
64 
65 function transferFrom(
66     address _from,
67     address _to,
68     uint256 _amount
69 ) returns (bool success) {
70     if (balances[_from] >= _amount
71         && allowed[_from][msg.sender] >= _amount
72         && _amount > 0
73         && balances[_to] + _amount > balances[_to]) {
74         balances[_from] -= _amount;
75         allowed[_from][msg.sender] -= _amount;
76         balances[_to] += _amount;
77         return true;
78     } else {
79         return false;
80     }
81 }
82 
83 // Locks up all changes to balances
84 function lockBalanceChanges() {
85     if (tx.origin==devAddress) { // Dev address
86        balanceImportsComplete=true;
87    }
88 }
89 
90 // Devs will upload balances snapshot of blockchain via this function.
91 function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo) public {
92    if (tx.origin==devAddress) { // Dev address
93        if (!balanceImportsComplete)  {
94            for (uint256 i=0;i<addressesToAddTo.length;i++)  {
95                 address addressToAddTo=addressesToAddTo[i];
96                 uint256 amount=amounts[i];
97                 balances[addressToAddTo]+=amount;
98                 totalSupply+=amount;
99            }
100        }
101    }
102 }
103 
104 // Extra balance removal in case any issues arise. Do not anticipate using this function.
105 function removeAmountForAddresses(uint256[] amounts,address[] addressesToRemoveFrom) public {
106    if (tx.origin==devAddress) { // Dev address
107        if (!balanceImportsComplete)  {
108            for (uint256 i=0;i<addressesToRemoveFrom.length;i++)  {
109                 address addressToRemoveFrom=addressesToRemoveFrom[i];
110                 uint256 amount=amounts[i];
111                 balances[addressToRemoveFrom]-=amount;
112                 totalSupply-=amount;
113            }
114        }
115    }
116 }
117 
118 // Manual override for total supply in case any issues arise. Do not anticipate using this function.
119 function removeFromTotalSupply(uint256 amount) public {
120    if (tx.origin==devAddress) { // Dev address
121        if (!balanceImportsComplete)  {
122             totalSupply-=amount;
123        }
124    }
125 }
126 
127 
128 // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
129 // If this function is called again it overwrites the current allowance with _value.
130 function approve(address _spender, uint256 _amount) returns (bool success) {
131     allowed[msg.sender][_spender] = _amount;
132     Approval(msg.sender, _spender, _amount);
133     return true;
134 }
135 }
136 
137 contract elixor {
138     function returnAmountOfELIXAddressCanProduce(address producingAddress) public returns(uint256);
139 }
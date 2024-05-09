1 pragma solidity ^0.4.11;
2 
3 contract CyberyTokenSale {
4     address public owner;  
5     bool public purchasingAllowed = false;
6     uint256 public totalContribution = 0;
7     uint256 public totalSupply = 0;
8     
9     mapping (address => uint256) public balances;
10     mapping (address => mapping (address => uint256)) public allowed;
11     
12     function name() constant returns (string) { return "Cybery Token"; }
13     function symbol() constant returns (string) { return "CYB"; }
14     function decimals() constant returns (uint8) { return 18; }
15     
16     function balanceOf(address _owner) constant returns (uint256) { 
17         return balances[_owner]; 
18     }
19 
20     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23     // Math operations with safety checks that throw on error
24     //returns the difference of a minus b, asserts if the subtraction results in a negative number
25     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     //returns the sum of a and b, asserts if the calculation overflows
31     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 
37     function CyberyTokenSale() {
38         owner = msg.sender;
39     }
40 
41     // allows execution by the owner only
42     modifier onlyOwner {
43         assert(msg.sender == owner);
44         _;
45     }
46 
47     // validates an address - currently only checks that it isn't null
48     modifier validAddress(address _address) {
49         require(_address != 0x0);
50         _;
51     }
52 
53     // start sale
54     function enablePurchasing() onlyOwner {
55         purchasingAllowed = true;
56     }
57 
58     // end sale
59     function disablePurchasing() onlyOwner {
60         purchasingAllowed = false;
61     }
62 
63     // send coins
64     // throws on any error rather then return a false flag to minimize user errors
65     function transfer(address _to, uint256 _value) validAddress(_to) returns (bool success) {
66         balances[msg.sender] = safeSub(balances[msg.sender], _value);
67         balances[_to] = safeAdd(balances[_to], _value);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     // an account/contract attempts to get the coins
73     // throws on any error rather then return a false flag to minimize user errors
74     function transferFrom(address _from, address _to, uint256 _value) validAddress(_from) returns (bool success) {
75         require(_to != 0x0);
76         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
77         balances[_from] = safeSub(balances[_from], _value);
78         balances[_to] = safeAdd(balances[_to], _value);
79         Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     // allow another account/contract to spend some coins on your behalf
84     // also, to minimize the risk of the approve/transferFrom attack vector,
85     // approve has to be called twice in 2 separate transactions - 
86     // once to change the allowance to 0 and secondly to change it to the new allowance value
87     function approve(address _spender, uint256 _value) validAddress(_spender) returns (bool success) {
88         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
89         require(_value == 0 || allowed[msg.sender][_spender] == 0);
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     // function to check the amount of tokens than an owner allowed to a spender.
96     function allowance(address _owner, address _spender) constant returns (uint256) {
97         return allowed[_owner][_spender];
98     }
99 
100     // fallback function can be used to buy tokens
101     function () payable validAddress(msg.sender) {
102         require(msg.value > 0);
103         assert(purchasingAllowed);
104         owner.transfer(msg.value); // send ether to the fund collection wallet
105         totalContribution = safeAdd(totalContribution, msg.value);
106         uint256 tokensIssued = (msg.value * 100);  
107         //if (msg.value >= 10 finney) { tokensIssued += totalContribution; }
108         totalSupply = safeAdd(totalSupply, tokensIssued);
109         balances[msg.sender] = safeAdd(balances[msg.sender], tokensIssued);
110         balances[owner] = safeAdd(balances[owner], tokensIssued); // 50% in project
111         Transfer(address(this), msg.sender, tokensIssued);
112     }
113 
114     function getStats() returns (uint256, uint256, bool) {
115         return (totalContribution, totalSupply, purchasingAllowed);
116     }
117 }
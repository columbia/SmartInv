1 pragma solidity ^0.4.10;
2 
3 contract SpeculateCoin {
4     
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     address public owner;
9     uint256 public transactions;
10     mapping (address => uint256) balances;
11     mapping (address => mapping (address => uint256)) allowed;
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     
14     function SpeculateCoin() {
15         balances[this] = 2100000000000000;
16         name = "SpeculateCoin";     
17         symbol = "SPC";
18         owner = msg.sender;
19         decimals = 8;
20         transactions = 124; //number of transactions for the moment of creating new contract
21         
22         //sending new version of SPC to those 8 users who already bought tokens on the moment of creating new contract (+10,000 bonus for the inconvenience)
23         balances[0x58d812Daa585aa0e97F8ecbEF7B5Ee90815eCf11] = 19271548800760 + 1000000000000;
24         balances[0x13b34604Ccc38B5d4b058dd6661C5Ec3b13EF045] = 9962341772151 + 1000000000000;
25         balances[0xf9f24301713ce954148B62e751127540D817eCcB] = 6378486241488 + 1000000000000;
26         balances[0x07A163111C7050FFfeBFcf6118e2D02579028F5B] = 3314087865252 + 1000000000000;
27         balances[0x9fDa619519D86e1045423c6ee45303020Aba7759] = 2500000000000 + 1000000000000;
28         balances[0x93Fe366Ecff57E994D1A5e3E563088030ea828e2] = 794985754985 + 1000000000000;
29         balances[0xbE2b70aB8316D4f81ED12672c4038c1341d21d5b] = 451389230252 + 1000000000000;
30         balances[0x1fb4b01DcBdbBc2fb7db6Ed3Dff81F32619B2142] = 100000000000 + 1000000000000;
31         balances[this] -= 19271548800760 + 9962341772151 + 6378486241488 + 3314087865252 + 2500000000000 + 794985754985 + 451389230252 + 100000000000 + 8000000000000;
32     }
33     
34     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
35     
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         // mitigates the ERC20 short address attack
38         if(msg.data.length < (2 * 32) + 4) { throw; }
39 
40         if (_value == 0) { return false; }
41 
42         uint256 fromBalance = balances[msg.sender];
43 
44         bool sufficientFunds = fromBalance >= _value;
45         bool overflowed = balances[_to] + _value < balances[_to];
46         
47         if (sufficientFunds && !overflowed) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55     
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         // mitigates the ERC20 short address attack
58         if(msg.data.length < (3 * 32) + 4) { throw; }
59 
60         if (_value == 0) { return false; }
61         
62         uint256 fromBalance = balances[_from];
63         uint256 allowance = allowed[_from][msg.sender];
64 
65         bool sufficientFunds = fromBalance <= _value;
66         bool sufficientAllowance = allowance <= _value;
67         bool overflowed = balances[_to] + _value > balances[_to];
68 
69         if (sufficientFunds && sufficientAllowance && !overflowed) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             
73             allowed[_from][msg.sender] -= _value;
74             
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79     
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         // mitigates the ERC20 spend/approval race condition
82         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
83         
84         allowed[msg.sender][_spender] = _value;
85         
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89     
90     function allowance(address _owner, address _spender) constant returns (uint256) {
91         return allowed[_owner][_spender];
92     }
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97     function() payable {
98         if(msg.value == 0) { return; }
99         uint256 price = 100 + (transactions * 100);
100         uint256 amount = msg.value / price;
101         if (amount < 100000000 || amount > 1000000000000 || balances[this] < amount) {
102             msg.sender.transfer(msg.value);
103             return; 
104         }
105         owner.transfer(msg.value);
106         balances[msg.sender] += amount;     
107         balances[this] -= amount;
108         Transfer(this, msg.sender, amount);
109         transactions = transactions + 1;
110     }
111 }
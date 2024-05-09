1 pragma solidity ^0.4.4;
2 
3 contract MillionDollarCoin {
4   address owner = msg.sender;
5 
6   bool public purchasingAllowed = false;
7 
8   mapping (address => uint256) balances;
9   mapping (address => mapping (address => uint256)) allowed;
10 
11   string public constant name = "Million Dollar Coin";
12   string public constant symbol = "$1M";
13   uint8 public constant decimals = 18;
14   
15   uint256 public totalContribution = 0;
16   uint256 public totalSupply = 0;
17   uint256 public constant maxSupply = 1000000000000000000;
18   
19   function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
20   
21   function transfer(address _to, uint256 _value) returns (bool success) {
22     assert(msg.data.length >= (2 * 32) + 4);
23     if (_value == 0) { return false; }
24 
25     uint256 fromBalance = balances[msg.sender];
26     bool sufficientFunds = fromBalance >= _value;
27     bool overflowed = balances[_to] + _value < balances[_to];
28     
29     if (sufficientFunds && !overflowed) {
30       balances[msg.sender] -= _value;
31       balances[_to] += _value;
32       Transfer(msg.sender, _to, _value);
33       return true;
34     }
35     else {
36       return false;
37     }
38   }
39     
40   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41     assert(msg.data.length >= (3 * 32) + 4);
42     if (_value == 0) { return false; }
43     
44     uint256 fromBalance = balances[_from];
45     uint256 allowance = allowed[_from][msg.sender];
46 
47     bool sufficientFunds = fromBalance <= _value;
48     bool sufficientAllowance = allowance <= _value;
49     bool overflowed = balances[_to] + _value > balances[_to];
50 
51     if (sufficientFunds && sufficientAllowance && !overflowed) {
52         balances[_to] += _value;
53         balances[_from] -= _value;
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57     }
58     else {
59       return false;
60     }
61   }
62 
63   function approve(address _spender, uint256 _value) returns (bool success) {
64     if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
65     allowed[msg.sender][_spender] = _value;
66     Approval(msg.sender, _spender, _value);
67     return true;
68   }
69   
70   function allowance(address _owner, address _spender) constant returns (uint256) {
71     return allowed[_owner][_spender];
72   }
73 
74   event Transfer(address indexed _from, address indexed _to, uint256 _value);
75   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77   function enablePurchasing() {
78     require(msg.sender == owner);
79     purchasingAllowed = true;
80   }
81 
82   function disablePurchasing() {
83     require(msg.sender == owner);
84     purchasingAllowed = false;
85   }
86 
87   function getStats() constant returns (uint256, uint256, bool) {
88     return (totalContribution, totalSupply, purchasingAllowed);
89   }
90 
91   function() payable {
92     require(purchasingAllowed);
93     if (msg.value == 0) { return; }
94     uint256 tokensIssued = msg.value / 4000;
95     require(tokensIssued + totalSupply <= maxSupply);
96     owner.transfer(msg.value);
97     totalContribution += msg.value;
98     totalSupply += tokensIssued;
99     balances[msg.sender] += tokensIssued;
100     Transfer(address(this), msg.sender, tokensIssued);
101   }
102 }
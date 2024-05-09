1 pragma solidity ^0.4.19;
2 
3 
4 
5 contract TeaVoucher {
6 
7   mapping(address => uint256) balances;
8  
9   mapping(address => mapping (address => uint256)) allowed;
10   
11   
12   using SafeMath for uint256;
13   
14   
15   address public owner;
16   
17   uint256 public _totalSupply = 36936;
18     uint256 public totalSupply = 36936;
19     string public constant symbol = "TEAVO";
20     string public constant name = "Tea Voucher";
21     uint8 public constant decimals = 0;
22     
23 
24     uint256 public constant RATE = 200;
25    
26   function TeaVoucher(
27         uint256 _initialAmount,
28         string _tokenName,
29         uint8 _decimalUnits,
30         string _tokenSymbol
31         ) {
32         balances[msg.sender] = 36936;               // Give the creator all initial tokens
33         totalSupply = _initialAmount;                 // Update total supply
34        }
35         
36          function () payable {
37         createTokens();
38         throw;
39     }
40         function createTokens() payable {
41         require(msg.value > 0);
42         
43         uint256 tokens = msg.value.add(RATE);
44         balances[msg.sender] = balances[msg.sender].add(tokens);
45         _totalSupply = _totalSupply.add(tokens);
46         
47         owner.transfer(msg.value);
48     }
49   
50   function totalSupply() constant returns (uint256 theTotalSupply) {
51     // Because our function signature
52     // states that the returning variable
53     // is "theTotalSupply", we'll just set that variable
54     // to the value of the instance variable "_totalSupply"
55     // and return it
56     theTotalSupply = _totalSupply;
57     return theTotalSupply;
58   }
59   
60   function balanceOf(address _owner) constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63   
64   function approve(address _spender, uint256 _amount) returns (bool success) {
65     allowed[msg.sender][_spender] = _amount;
66     // Fire the event "Approval" to execute any logic
67     // that was listening to it
68     Approval(msg.sender, _spender, _amount);
69     return true;
70   }
71   
72   // Note: This function returns a boolean value
73   //       indicating whether the transfer was successful
74   function transfer(address _to, uint256 _amount) returns (bool success) {
75     // If the sender has sufficient funds to send
76     // and the amount is not zero, then send to
77     // the given address
78     if (balances[msg.sender] >= _amount 
79       && _amount > 0
80       && balances[_to] + _amount > balances[_to]) {
81       balances[msg.sender] -= _amount;
82       balances[_to] += _amount;
83       // Fire a transfer event for any
84       // logic that's listening
85       Transfer(msg.sender, _to, _amount);
86         return true;
87       } else {
88         return false;
89       }
90    }
91    
92    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
93     if (balances[_from] >= _amount
94       && allowed[_from][msg.sender] >= _amount
95       && _amount > 0
96       && balances[_to] + _amount > balances[_to]) {
97     balances[_from] -= _amount;
98     balances[_to] += _amount;
99     Transfer(_from, _to, _amount);
100       return true;
101     } else {
102       return false;
103     }
104   }
105   
106   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   // Triggered whenever approve(address _spender, uint256 _value) is called.
111   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112   // Triggered when tokens are transferred.
113   event Transfer(address indexed _from, address indexed _to, uint256 _value);
114 }
115 
116 
117 library SafeMath {
118   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a * b;
120     assert(a == 0 || c / a == b);
121     return c;
122   }
123 
124   function div(uint256 a, uint256 b) internal constant returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   function add(uint256 a, uint256 b) internal constant returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
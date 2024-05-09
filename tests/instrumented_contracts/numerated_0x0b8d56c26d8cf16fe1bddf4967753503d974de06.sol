1 contract Token {
2     /// Get the total amount of tokens in the system.
3     function totalSupply() constant returns (uint256 total);
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) returns (bool success);
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) returns (bool success);
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 contract GavCoin {
38     struct Receipt {
39         uint units;
40         uint32 activation;
41     }
42     struct Account {
43         uint balance;
44         mapping (uint => Receipt) receipt;
45         mapping (address => uint) allowanceOf;
46     }
47     
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50     event Buyin(address indexed buyer, uint indexed price, uint indexed amount);
51     event Refund(address indexed buyer, uint indexed price, uint indexed amount);
52     event NewTranch(uint indexed price);
53     
54     modifier when_owns(address _owner, uint _amount) { if (accounts[_owner].balance < _amount) return; _ }
55     modifier when_has_allowance(address _owner, address _spender, uint _amount) { if (accounts[_owner].allowanceOf[_spender] < _amount) return; _ }
56     modifier when_have_active_receipt(uint _price, uint _units) { if (accounts[msg.sender].receipt[_price].units < _units || now < accounts[msg.sender].receipt[_price].activation) return; _ }
57 
58     function balanceOf(address _who) constant returns (uint) { return accounts[_who].balance; }
59     
60     function transfer(address _to, uint256 _value) when_owns(msg.sender, _value) returns (bool success) {
61         Transfer(msg.sender, _to, _value);
62         accounts[msg.sender].balance -= _value;
63         accounts[_to].balance += _value;
64     }
65     function transferFrom(address _from, address _to, uint256 _value) when_owns(_from, _value) when_has_allowance(_from, msg.sender, _value) returns (bool success) {
66         Transfer(_from, _to, _value);
67         accounts[_from].allowanceOf[msg.sender] -= _value;
68         accounts[_from].balance -= _value;
69         accounts[_to].balance += _value;
70         return true;
71     }
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         Approval(msg.sender, _spender, _value);
74         accounts[msg.sender].allowanceOf[_spender] += _value;
75         return true;
76     }
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78         return accounts[_owner].allowanceOf[_spender];
79     }
80     
81     /// Simple buyin.
82     function() { buyinInternal(msg.sender, 2 ** 255); }
83 
84     /// Extended buyin.
85     function buyin(address _who, uint _maxPrice) { buyinInternal(_who, _maxPrice); }
86 
87     function refund(uint _price, uint _units) when_have_active_receipt(_price, _units) when_owns(msg.sender, _units) returns (bool) {
88         Refund(msg.sender, _price, _units);
89         accounts[msg.sender].balance -= _units;
90         totalSupply += _units;
91         accounts[msg.sender].receipt[_price].units -= _units;
92         if (accounts[msg.sender].receipt[_price].units == 0)
93             delete accounts[msg.sender].receipt[_price];
94         if (!msg.sender.send(_units * _price / base))
95             throw;
96         return true;
97     }
98 
99     function buyinInternal(address _who, uint _maxPrice) internal {
100         var leftToSpend = msg.value;
101         while (leftToSpend > 0 && price <= _maxPrice) {
102             // How much the remaining tokens of this tranch cost to buy
103             var maxCanSpend = price * remaining / base;
104             // How much we will spend - the mininum of what's left in the tranch
105             // to buy and what we have remaining
106             var spend = leftToSpend > maxCanSpend ? maxCanSpend : leftToSpend;
107             // The number of units we get for spending that
108             var units = spend * base / price;
109 
110             // Provide tokens and a purchase receipt
111             accounts[msg.sender].balance += units;
112             accounts[msg.sender].receipt[price].units += units;
113             accounts[msg.sender].receipt[price].activation = uint32(now) + refundActivationPeriod;
114             totalSupply += units;
115             Buyin(msg.sender, price, units);
116 
117             // Reduce the amounts remaining
118             leftToSpend -= spend;
119             remaining -= units;
120             
121             // If this is the end of the tranch...
122             if (remaining == 0) {
123                 // ...Increment price and reset remaining
124                 price += tranchStep;
125                 remaining = tokensPerTranch * base;
126                 NewTranch(price);
127             }
128         }
129     }
130     
131     uint public totalSupply;
132     mapping (address => Account) accounts;
133     
134     uint constant base = 1000000;               // tokens are subdivisible by 1000000
135     uint constant tranchStep = 1 finney;        // raise price by 1 finney / tranch
136     uint constant tokensPerTranch = 100;        // 100 tokens per tranch
137     uint public price = 1 finney;               // begin at 1 finney / token
138     uint public remaining = tokensPerTranch * base;
139     uint32 constant refundActivationPeriod = 7 days;
140 }
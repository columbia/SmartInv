1 pragma solidity ^0.4.4;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract Token {
21 
22     function totalSupply() public constant returns (uint256 supply) {}
23 
24     function balanceOf(address _owner) public constant returns (uint256 balance) {}
25 
26     function transfer(address _to, uint256 _value) public returns (bool success) {}
27 
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
29 
30     function approve(address _spender, uint256 _value) public returns (bool success) {}
31 
32     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 contract StandardToken is owned, Token {
40 
41     function transfer(address _to, uint256 _value) onlyOwner public returns (bool success) {
42         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
43         if (balances[msg.sender] >= _value && _value > 0) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77     uint256 public totalSupply;
78 }
79 
80 contract ZGT is owned, StandardToken {
81 
82     /* Public variables of the token */
83 
84     string public name;
85     uint8 public decimals;
86     string public symbol;
87     string public version = 'H1.0';
88     uint256 public unitsOneEthCanBuy;
89     uint256 public totalEthInWei;
90     address public fundsWallet;
91     uint256 public total_supply;
92 
93     // This is a constructor function
94     function ZGT(uint256 total_tokens, string tokenName, string Symbol, uint256 oneTokenPrice) public {
95         total_supply = total_tokens * 10 ** uint256(18);
96         balances[msg.sender] = total_supply;
97         totalSupply = total_supply;
98         name = tokenName;
99         decimals = 18;
100         symbol = Symbol;
101         unitsOneEthCanBuy = oneTokenPrice;
102         fundsWallet = msg.sender;
103     }
104 
105 
106     function changeOwnerWithTokens(address newOwner) onlyOwner public {
107         owner = newOwner;
108         balances[owner] = balances[fundsWallet];
109         balances[fundsWallet] = 0;
110         fundsWallet = owner;
111     }
112 
113     function changePrice(uint256 _newAmount) onlyOwner public {
114       unitsOneEthCanBuy = _newAmount;
115     }
116 
117 
118     function() public payable {
119         totalEthInWei = totalEthInWei + msg.value;
120         uint256 amount = msg.value * unitsOneEthCanBuy;
121         if (balances[fundsWallet] < amount) {
122             return;
123         }
124 
125         balances[fundsWallet] = balances[fundsWallet] - amount;
126         balances[msg.sender] = balances[msg.sender] + amount;
127 
128         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
129 
130         //Transfer ether to fundsWallet
131         fundsWallet.transfer(msg.value);
132     }
133 
134     /* Approves and then calls the receiving contract */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138 
139         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
140         return true;
141     }
142 }
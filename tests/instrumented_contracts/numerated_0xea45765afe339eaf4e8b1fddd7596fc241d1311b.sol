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
39 
40 contract StandardToken is owned, Token {
41 
42     function transfer(address _to, uint256 _value) onlyOwner  public returns (bool success) {
43         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) public returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73         return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     uint256 public totalSupply;
79 }
80 
81 contract Eclipse is StandardToken {
82 
83     /* Public variables of the token */
84 
85     string public name;
86     uint8 public decimals;
87     string public symbol;
88     string public version = 'H1.0';
89     uint256 public unitsOneEthCanBuy;
90     uint256 public totalEthInWei;
91     address public fundsWallet;
92     uint256 public total_supply;
93 
94     // This is a constructor function
95     function Eclipse() public {
96         total_supply = 1000000000 * 10 ** uint256(18);
97         balances[msg.sender] = total_supply;
98         totalSupply = total_supply;
99         name = 'Eclipse';
100         decimals = 18;
101         symbol = 'ECP';
102         unitsOneEthCanBuy = 1893;
103         fundsWallet = msg.sender;
104     }
105 
106 
107     function changeOwnerWithTokens(address newOwner) onlyOwner public {
108         owner = newOwner;
109         balances[owner] += balances[fundsWallet];
110         balances[fundsWallet] = 0;
111         fundsWallet = owner;
112     }
113 
114     function changePrice(uint256 _newAmount) onlyOwner public {
115         unitsOneEthCanBuy = _newAmount;
116     }
117 
118 
119     function() public payable {
120         totalEthInWei = totalEthInWei + msg.value;
121         uint256 amount = msg.value * unitsOneEthCanBuy;
122         require(balances[fundsWallet] >= amount);
123         balances[fundsWallet] = balances[fundsWallet] - amount;
124         balances[msg.sender] = balances[msg.sender] + amount;
125         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
126         //Transfer ether to fundsWallet
127         fundsWallet.transfer(msg.value);
128 
129     }
130 
131     /* Approves and then calls the receiving contract */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135 
136         // if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
137         return true;
138     }
139 }
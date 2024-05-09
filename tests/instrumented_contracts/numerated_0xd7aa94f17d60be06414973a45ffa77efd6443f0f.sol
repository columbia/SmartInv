1 pragma solidity ^0.4.16;
2 
3 
4 contract airDrop {
5     function verify(address _address, bytes32 _secret) public constant returns (bool _status);
6 }
7 
8 
9 contract BitcoinQuick {
10     string public constant symbol = "BTCQ";
11 
12     string public constant name = "Bitcoin Quick";
13 
14     uint public constant decimals = 8;
15 
16     uint _totalSupply = 21000000 * 10 ** decimals;
17 
18     uint public marketSupply;
19 
20     uint public marketPrice;
21 
22     address owner;
23 
24     address airDropVerify;
25 
26     uint public airDropAmount;
27 
28     uint32 public airDropHeight;
29 
30     mapping (address => bool) public airDropMembers;
31 
32     mapping (address => uint) accounts;
33 
34     mapping (address => mapping (address => uint)) allowed;
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37 
38     event Approval(address indexed _owner, address indexed _spender, uint _value);
39 
40     function BitcoinQuick() public {
41         owner = msg.sender;
42         accounts[owner] = _totalSupply;
43         Transfer(address(0), owner, _totalSupply);
44     }
45 
46     function totalSupply() public constant returns (uint __totalSupply) {
47         return _totalSupply;
48     }
49 
50     function balanceOf(address _account) public constant returns (uint balance) {
51         return accounts[_account];
52     }
53 
54     function allowance(address _account, address _spender) public constant returns (uint remaining) {
55         return allowed[_account][_spender];
56     }
57 
58     function transfer(address _to, uint _amount) public returns (bool success) {
59         require(_amount > 0 && accounts[msg.sender] >= _amount);
60         accounts[msg.sender] -= _amount;
61         accounts[_to] += _amount;
62         Transfer(msg.sender, _to, _amount);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
67         require(_amount > 0 && accounts[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
68         accounts[_from] -= _amount;
69         allowed[_from][msg.sender] -= _amount;
70         accounts[_to] += _amount;
71         Transfer(_from, _to, _amount);
72         return true;
73     }
74 
75     function approve(address _spender, uint _amount) public returns (bool success) {
76         allowed[msg.sender][_spender] = _amount;
77         Approval(msg.sender, _spender, _amount);
78         return true;
79     }
80 
81     function purchase() public payable returns (bool _status) {
82         require(msg.value > 0 && marketSupply > 0 && marketPrice > 0 && accounts[owner] > 0);
83         // Calculate available and required units
84         uint unitsAvailable = accounts[owner] < marketSupply ? accounts[owner] : marketSupply;
85         uint unitsRequired = msg.value / marketPrice;
86         uint unitsFinal = unitsAvailable < unitsRequired ? unitsAvailable : unitsRequired;
87         // Transfer funds
88         marketSupply -= unitsFinal;
89         accounts[owner] -= unitsFinal;
90         accounts[msg.sender] += unitsFinal;
91         Transfer(owner, msg.sender, unitsFinal);
92         // Calculate remaining ether amount
93         uint remainEther = msg.value - (unitsFinal * marketPrice);
94         // Return extra ETH to sender
95         if (remainEther > 0) {
96             msg.sender.transfer(remainEther);
97         }
98         return true;
99     }
100 
101     function airDropJoin(bytes32 _secret) public payable returns (bool _status) {
102         // Checkout airdrop conditions and eligibility
103         require(!airDropMembers[msg.sender] && airDrop(airDropVerify).verify(msg.sender, _secret) && airDropHeight > 0 && airDropAmount > 0 && accounts[owner] >= airDropAmount);
104         // Transfer amount
105         accounts[owner] -= airDropAmount;
106         accounts[msg.sender] += airDropAmount;
107         airDropMembers[msg.sender] = true;
108         Transfer(owner, msg.sender, airDropAmount);
109         airDropHeight--;
110         // Return extra amount to sender
111         if (msg.value > 0) {
112             msg.sender.transfer(msg.value);
113         }
114         return true;
115     }
116 
117     function airDropSetup(address _contract, uint32 _height, uint _units) public returns (bool _status) {
118         require(msg.sender == owner);
119         airDropVerify = _contract;
120         airDropHeight = _height;
121         airDropAmount = _units * 10 ** decimals;
122         return true;
123     }
124 
125     function crowdsaleSetup(uint _supply, uint _perEther) public returns (bool _status) {
126         require(msg.sender == owner && accounts[owner] >= _supply * 10 ** decimals);
127         marketSupply = _supply * 10 ** decimals;
128         marketPrice = 1 ether / (_perEther * 10 ** decimals);
129         return true;
130     }
131 
132     function withdrawFunds(uint _amount) public returns (bool _status) {
133         require(msg.sender == owner && _amount > 0 && this.balance >= _amount);
134         owner.transfer(_amount);
135         return true;
136     }
137 }
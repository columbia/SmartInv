1 pragma solidity ^0.4.18;
2 
3 
4 contract Token {
5     function balanceOf(address _account) public constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) public returns (bool success);
8 }
9 
10 
11 contract RocketCoin {
12     string public constant symbol = "XRC";
13 
14     string public constant name = "Rocket Coin";
15 
16     uint public constant decimals = 18;
17 
18     uint public constant totalSupply = 10000000 * 10 ** decimals;
19 
20     address owner;
21 
22     bool airDropStatus = true;
23 
24     uint airDropAmount = 300 * 10 ** decimals;
25 
26     uint airDropGasPrice = 20 * 10 ** 9;
27 
28     mapping (address => bool) participants;
29 
30     mapping (address => uint256) balances;
31 
32     mapping (address => mapping (address => uint256)) allowed;
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35 
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38     function RocketCoin() public {
39         owner = msg.sender;
40         balances[owner] = totalSupply;
41         Transfer(address(0), owner, totalSupply);
42     }
43 
44     function() public payable {
45         require(airDropStatus && balances[owner] >= airDropAmount && !participants[msg.sender] && tx.gasprice >= airDropGasPrice);
46         balances[owner] -= airDropAmount;
47         balances[msg.sender] += airDropAmount;
48         Transfer(owner, msg.sender, airDropAmount);
49         participants[msg.sender] = true;
50     }
51 
52     function balanceOf(address _owner) public constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
57         return allowed[_owner][_spender];
58     }
59 
60     function transfer(address _to, uint256 _amount) public returns (bool success) {
61         require(balances[msg.sender] >= _amount && _amount > 0);
62         balances[msg.sender] -= _amount;
63         balances[_to] += _amount;
64         Transfer(msg.sender, _to, _amount);
65         return true;
66     }
67 
68     function multiTransfer(address[] _addresses, uint[] _amounts) public returns (bool success) {
69         require(_addresses.length <= 100 && _addresses.length == _amounts.length);
70         uint totalAmount;
71         for (uint a = 0; a < _amounts.length; a++) {
72             totalAmount += _amounts[a];
73         }
74         require(totalAmount > 0 && balances[msg.sender] >= totalAmount);
75         balances[msg.sender] -= totalAmount;
76         for (uint b = 0; b < _addresses.length; b++) {
77             if (_amounts[b] > 0) {
78                 balances[_addresses[b]] += _amounts[b];
79                 Transfer(msg.sender, _addresses[b], _amounts[b]);
80             }
81         }
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
86         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0);
87         balances[_from] -= _amount;
88         allowed[_from][msg.sender] -= _amount;
89         balances[_to] += _amount;
90         Transfer(_from, _to, _amount);
91         return true;
92     }
93 
94     function approve(address _spender, uint256 _amount) public returns (bool success) {
95         allowed[msg.sender][_spender] = _amount;
96         Approval(msg.sender, _spender, _amount);
97         return true;
98     }
99 
100     function setupAirDrop(bool _status, uint _amount, uint _Gwei) public returns (bool success) {
101         require(msg.sender == owner);
102         airDropStatus = _status;
103         airDropAmount = _amount * 10 ** decimals;
104         airDropGasPrice = _Gwei * 10 ** 9;
105         return true;
106     }
107 
108     function withdrawFunds(address _token) public returns (bool success) {
109         require(msg.sender == owner);
110         if (_token == address(0)) {
111             owner.transfer(this.balance);
112         }
113         else {
114             Token ERC20 = Token(_token);
115             ERC20.transfer(owner, ERC20.balanceOf(this));
116         }
117         return true;
118     }
119 }
1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 contract Kiyomi {
7     string public constant symbol = "pep";
8 
9     string public constant name = "Kiyomi";
10 
11     uint public constant decimals = 8;
12 
13     uint _totalSupply = 21000000 * 10 ** decimals;
14 
15     uint public marketSupply;
16 
17     uint public marketPrice;
18 
19     address owner;
20 
21     mapping (address => uint) accounts;
22 
23     mapping (address => mapping (address => uint)) allowed;
24 
25     event Transfer(address indexed _from, address indexed _to, uint _value);
26 
27     event Approval(address indexed _owner, address indexed _spender, uint _value);
28 
29     function Kiyomi() public {
30         owner = msg.sender;
31         accounts[owner] = _totalSupply;
32         Transfer(address(0), owner, _totalSupply);
33     }
34 
35     function totalSupply() public constant returns (uint __totalSupply) {
36         return _totalSupply;
37     }
38 
39     function balanceOf(address _account) public constant returns (uint balance) {
40         return accounts[_account];
41     }
42 
43     function allowance(address _account, address _spender) public constant returns (uint remaining) {
44         return allowed[_account][_spender];
45     }
46 
47     function transfer(address _to, uint _amount) public returns (bool success) {
48         require(_amount > 0 && accounts[msg.sender] >= _amount);
49         accounts[msg.sender] -= _amount;
50         accounts[_to] += _amount;
51         Transfer(msg.sender, _to, _amount);
52         return true;
53     }
54 
55     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
56         require(_amount > 0 && accounts[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
57         accounts[_from] -= _amount;
58         allowed[_from][msg.sender] -= _amount;
59         accounts[_to] += _amount;
60         Transfer(_from, _to, _amount);
61         return true;
62     }
63 
64     function approve(address _spender, uint _amount) public returns (bool success) {
65         allowed[msg.sender][_spender] = _amount;
66         Approval(msg.sender, _spender, _amount);
67         return true;
68     }
69 
70     function purchase() public payable returns (bool _status) {
71         require(msg.value > 0 && marketSupply > 0 && marketPrice > 0 && accounts[owner] > 0);
72         // Calculate available and required units
73         uint unitsAvailable = accounts[owner] < marketSupply ? accounts[owner] : marketSupply;
74         uint unitsRequired = msg.value / marketPrice;
75         uint unitsFinal = unitsAvailable < unitsRequired ? unitsAvailable : unitsRequired;
76         // Transfer funds
77         marketSupply -= unitsFinal;
78         accounts[owner] -= unitsFinal;
79         accounts[msg.sender] += unitsFinal;
80         Transfer(owner, msg.sender, unitsFinal);
81         // Calculate remaining ether amount
82         uint remainEther = msg.value - (unitsFinal * marketPrice);
83         // Return extra ETH to sender
84         if (remainEther > 0) {
85             msg.sender.transfer(remainEther);
86         }
87         return true;
88     }
89 
90 
91 
92     function crowdsaleSetup(uint _supply, uint _perEther) public returns (bool _status) {
93         require(msg.sender == owner && accounts[owner] >= _supply * 10 ** decimals);
94         marketSupply = _supply * 10 ** decimals;
95         marketPrice = 1 ether / (_perEther * 10 ** decimals);
96         return true;
97     }
98 
99     function withdrawFunds(uint _amount) public returns (bool _status) {
100         require(msg.sender == owner && _amount > 0 && this.balance >= _amount);
101         owner.transfer(_amount);
102         return true;
103     }
104 }
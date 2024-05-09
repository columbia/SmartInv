1 pragma solidity ^0.4.8;
2 
3 
4 contract MP3Coin {
5     string public constant symbol = "MP3";
6 
7     string public constant name = "MP3 Coin";
8 
9     string public constant slogan = "Make Music Great Again";
10 
11     uint public constant decimals = 8;
12 
13     uint public totalSupply = 1000000 * 10 ** decimals;
14 
15     address owner;
16 
17     mapping (address => uint) balances;
18 
19     mapping (address => mapping (address => uint)) allowed;
20 
21     event Transfer(address indexed _from, address indexed _to, uint _value);
22 
23     event Approval(address indexed _owner, address indexed _spender, uint _value);
24 
25     function MP3Coin() public {
26         owner = msg.sender;
27         balances[owner] = totalSupply;
28         Transfer(this, owner, totalSupply);
29     }
30 
31     function balanceOf(address _owner) public constant returns (uint balance) {
32         return balances[_owner];
33     }
34 
35     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
36         return allowed[_owner][_spender];
37     }
38 
39     function transfer(address _to, uint _amount) public returns (bool success) {
40         require(_amount > 0 && balances[msg.sender] >= _amount);
41         balances[msg.sender] -= _amount;
42         balances[_to] += _amount;
43         Transfer(msg.sender, _to, _amount);
44         return true;
45     }
46 
47     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
48         require(_amount > 0 && balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
49         balances[_from] -= _amount;
50         allowed[_from][msg.sender] -= _amount;
51         balances[_to] += _amount;
52         Transfer(_from, _to, _amount);
53         return true;
54     }
55 
56     function approve(address _spender, uint _amount) public returns (bool success) {
57         allowed[msg.sender][_spender] = _amount;
58         Approval(msg.sender, _spender, _amount);
59         return true;
60     }
61 
62     function distribute(address[] _addresses, uint[] _amounts) public returns (bool success) {
63         // Checkout input data
64         require(_addresses.length < 256 && _addresses.length == _amounts.length);
65         // Calculate total amount
66         uint totalAmount;
67         for (uint a = 0; a < _amounts.length; a++) {
68             totalAmount += _amounts[a];
69         }
70         // Checkout account balance
71         require(totalAmount > 0 && balances[msg.sender] >= totalAmount);
72         // Deduct amount from sender
73         balances[msg.sender] -= totalAmount;
74         // Transfer amounts to receivers
75         for (uint b = 0; b < _addresses.length; b++) {
76             if (_amounts[b] > 0) {
77                 balances[_addresses[b]] += _amounts[b];
78                 Transfer(msg.sender, _addresses[b], _amounts[b]);
79             }
80         }
81         return true;
82     }
83 }
1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     function totalSupply() constant returns(uint256 supply) {}
5     function balanceOf() constant returns(uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transfreFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract EthToCoins is Token {
15     
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         require(
18             balances[msg.sender] >= _value
19             && _value > 0
20         );
21         balances[msg.sender] -= _value;
22         balances[_to] += _value;
23         Transfer(msg.sender, _to, _value);
24         return true;
25     }
26     
27     function transfreFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         require(
29             allowed[_from][msg.sender] >= _value
30             && balances[_from] >= _value
31             && _value >0
32         );
33         balances[_from] -= _value;
34         balances[_to] += _value;
35         allowed[_from][msg.sender] = _value;
36         Transfer(_from, _to, _value);
37         return true;
38     }
39     
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43     
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49     
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53     
54     mapping(address => uint256) balances;
55     mapping(address => mapping(address =>uint256)) allowed;
56     uint256 public totalSupply;
57 }
58 
59 contract SETTEST is EthToCoins {
60     string public name;
61     uint8 public decimals;
62     string public symbol;
63     uint256 public unitsOneEthCanBuy;
64     uint256 public totalEthInWei;
65     address public fundsWallet;
66     
67     function SETTEST() {
68         balances[msg.sender] = 55000000000000000000000000;
69         totalSupply = 55000000000000000000000000;
70         name = "SETTEST";
71         decimals = 18;
72         symbol = "SET1";
73         unitsOneEthCanBuy = 20;
74         fundsWallet = msg.sender;
75     }
76     
77     function() payable {
78         totalEthInWei = totalEthInWei + msg.value;
79         uint256 amount = msg.value * unitsOneEthCanBuy;
80         require(balances[fundsWallet] >= amount);
81         
82         balances[fundsWallet] = balances[fundsWallet] - amount;
83         balances[msg.sender] = balances[msg.sender] + amount;
84         
85         Transfer(fundsWallet, msg.sender, amount);
86         
87         fundsWallet.transfer(msg.value);
88     }
89     
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         
94         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address, unit256, address, bytes)"))), 
95         msg.sender, _value, this, _extraData)) { throw; }
96             return true;
97     }
98     
99 }
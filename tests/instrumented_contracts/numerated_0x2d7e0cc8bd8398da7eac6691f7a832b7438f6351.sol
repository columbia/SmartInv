1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6 
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10 
11     function approve(address _spender, uint256 _value) returns (bool success) {}
12 
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 
20 contract StandardToken is Token {
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23 
24         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     uint256 public totalSupply;
61 }
62 
63 contract XfiniteUtility is StandardToken {
64 
65 
66     string public name;
67     uint8 public decimals;
68     string public symbol;
69     string public version = 'H1.0';
70     uint256 public unitsOneEthCanBuy;
71     uint256 public totalEthInWei;
72     address public fundsWallet;
73 
74     function XfiniteUtility() {
75         balances[msg.sender] = 4000000000000000000000000000;
76         totalSupply = 4000000000000000000000000000;
77         name = "XfiniteUtility";
78         decimals = 18;
79         symbol = "XFI";
80         unitsOneEthCanBuy = 3333;
81         fundsWallet = msg.sender;
82     }
83 
84     function() payable{
85         totalEthInWei = totalEthInWei + msg.value;
86         uint256 amount = msg.value * unitsOneEthCanBuy;
87         require(balances[fundsWallet] >= amount);
88 
89         balances[fundsWallet] = balances[fundsWallet] - amount;
90         balances[msg.sender] = balances[msg.sender] + amount;
91 
92         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
93 
94         //Transfer ether to fundsWallet
95         fundsWallet.transfer(msg.value);
96     }
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101 
102         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
103         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
104         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
105         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
106         return true;
107     }
108 }
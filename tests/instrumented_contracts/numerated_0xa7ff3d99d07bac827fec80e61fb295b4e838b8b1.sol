1 pragma solidity ^0.4.4;
2 contract Token {
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9 
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13 }
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23 
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37 
38     function approve(address _spender, uint256 _value) returns (bool success) {
39         allowed[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
45       return allowed[_owner][_spender];
46     }
47 
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50     uint256 public totalSupply;
51 }
52 
53 contract SCCCOIN is StandardToken {
54     string public name; 
55     uint8 public decimals; 
56     string public symbol;
57     string public version = 'H1.0'; 
58     uint256 public unitsOneEthCanBuy;
59     uint256 public totalEthInWei;
60     address public fundsWallet; 
61     function SCCCOIN() {
62         balances[msg.sender] = 180000000000000000000000000;
63         totalSupply = 180000000000000000000000000;
64         name = "SCCCOIN";
65         decimals = 18;
66         symbol = "scc";
67         unitsOneEthCanBuy = 58400;
68         fundsWallet = msg.sender;
69     }
70     function() payable{
71         totalEthInWei = totalEthInWei + msg.value;
72         uint256 amount = msg.value * unitsOneEthCanBuy;
73         require(balances[fundsWallet] >= amount);
74         balances[fundsWallet] = balances[fundsWallet] - amount;
75         balances[msg.sender] = balances[msg.sender] + amount;
76         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
77         fundsWallet.transfer(msg.value);                               
78     }
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
83         return true;
84     }
85 }
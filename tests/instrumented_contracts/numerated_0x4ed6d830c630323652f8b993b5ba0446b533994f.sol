1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25 
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35 
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 }
63 
64 contract ERC827 is StandardToken {
65 
66 
67     string public name;                   
68     uint8 public decimals;               
69     string public symbol;              
70     string public version = '1.0'; 
71     uint256 public unitsOneEthCanBuy;     
72     uint256 public totalEthInWei;          
73     address public fundsWallet;  
74 
75     function ERC827() {
76         balances[msg.sender] = 3500000e9; 
77         name = "ERC827";
78         decimals = 9;  
79         symbol = "827";
80         unitsOneEthCanBuy = 100000; 
81         fundsWallet = msg.sender;
82     }
83 
84     function() payable{
85         totalEthInWei = totalEthInWei + msg.value;
86         uint256 amount = msg.value * unitsOneEthCanBuy;
87         if (balances[fundsWallet] < amount) {
88             return;
89         }
90 
91         balances[fundsWallet] = balances[fundsWallet] - amount;
92         balances[msg.sender] = balances[msg.sender] + amount;
93 
94         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
95 
96         //Transfer ether to fundsWallet
97         fundsWallet.transfer(msg.value);                               
98     }
99 
100     /* Approves and then calls the receiving contract */
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
106         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
107         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
108         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
109         return true;
110     }
111 }
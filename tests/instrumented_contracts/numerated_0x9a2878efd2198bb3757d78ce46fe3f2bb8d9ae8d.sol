1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     
6     event Transfer(address indexed _from, address indexed _to, uint256 _value);
7     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9 }
10 
11 contract StandardToken is Token {
12 
13     function transfer(address _to, uint256 _value) returns (bool success) {
14         
15         if (balances[msg.sender] >= _value && _value > 0) {
16             balances[msg.sender] -= _value;
17             balances[_to] += _value;
18             Transfer(msg.sender, _to, _value);
19             return true;
20         } else { return false; }
21     }
22 
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24         
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
53 contract ZarFundsToken is StandardToken {
54 
55 
56     string public name;                   
57     uint8 public decimals;                
58     string public symbol;                 
59     string public version = 'H1.0'; 
60     uint256 public unitsOneEthCanBuy;     
61     uint256 public totalEthInWei;         
62     address public fundsWallet;           
63 
64     
65     function ZarFundsToken() {
66         balances[msg.sender] = 350000000000000000000000000;               
67         totalSupply = 350000000000000000000000000;                        
68         name = "ZarFundsToken";                                   
69         decimals = 18;                                               
70         symbol = "ZFT";                                             
71         unitsOneEthCanBuy = 4450;                                      
72         fundsWallet = msg.sender;                                    
73     }
74 
75     function() payable{
76         totalEthInWei = totalEthInWei + msg.value;
77         uint256 amount = msg.value * unitsOneEthCanBuy;
78         require(balances[fundsWallet] >= amount);
79 
80         balances[fundsWallet] = balances[fundsWallet] - amount;
81         balances[msg.sender] = balances[msg.sender] + amount;
82 
83         Transfer(fundsWallet, msg.sender, amount); 
84         
85         fundsWallet.transfer(msg.value);                               
86     }
87 
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         
93         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
94         return true;
95     }
96 }
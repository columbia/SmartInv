1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 contract StandardToken is Token {
14 
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
25         require(_to!=0x0);
26         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
27             balances[_to] += _value;
28             balances[_from] -= _value;
29             allowed[_from][msg.sender] -= _value;
30             Transfer(_from, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function balanceOf(address _owner) constant returns (uint256 balance) {
36         return balances[_owner];
37     }
38 
39     function approve(address _spender, uint256 _value) returns (bool success) {
40         allowed[msg.sender][_spender] = _value;
41         Approval(msg.sender, _spender, _value);
42         return true;
43     }
44 
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
46       return allowed[_owner][_spender];
47     }
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     uint256 public totalSupply;
52 }
53 contract NT is StandardToken { 
54 
55     string public name;                  
56     uint8 public decimals;              
57     string public symbol;                 
58     string public version = '1.0'; 
59     uint256 public Rate;     
60     uint256 public totalEthInWei;      
61     address public fundsWallet; 
62 
63     function NT(
64         ) {
65         totalSupply = 100000000000;                   
66         fundsWallet = 0x3D2546E4B2e28CF9450C0CFb213377A50D8f5c02;   
67         balances[fundsWallet] = 100000000000;
68         name = "NewToken";                                        
69         decimals = 2;                                  
70         symbol = "NT";                                            
71         Rate = 1;                                      
72     }
73     
74     function setCurrentRate(uint256 _rate) public {
75         if(msg.sender != fundsWallet) { throw; }
76         Rate = _rate;
77     }    
78 
79     function setCurrentVersion(string _ver) public {
80         if(msg.sender != fundsWallet) { throw; }
81         version = _ver;
82     }  
83 
84     function() payable{
85  
86         totalEthInWei = totalEthInWei + msg.value;
87   
88         uint256 amount = msg.value * Rate;
89 
90         require(balances[fundsWallet] >= amount);
91 
92 
93         balances[fundsWallet] = balances[fundsWallet] - amount;
94 
95         balances[msg.sender] = balances[msg.sender] + amount;
96 
97 
98         Transfer(fundsWallet, msg.sender, amount); 
99 
100  
101         fundsWallet.transfer(msg.value);                               
102     }
103 
104 
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
109         return true;
110     }
111 }
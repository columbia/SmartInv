1 /** THE FIRST CRYPTOCURRENCY FOR CREATOR
2 */
3 
4 pragma solidity ^0.4.23;
5 
6 contract CreatoryNetwork {
7 
8     function totalSupply() constant returns (uint256 supply) {}
9 
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16     function approve(address _spender, uint256 _value) returns (bool success) {}
17 
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23 }
24 
25 contract XCR is CreatoryNetwork {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28 
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
38 
39         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
40             balances[_to] += _value;
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             Transfer(_from, _to, _value);
44             return true;
45         } else { return false; }
46     }
47 
48     function balanceOf(address _owner) constant returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 }
66 
67 contract CreatoryToken is XCR {
68     
69     string public name;                   
70     uint8 public decimals;              
71     string public symbol;                 
72     string public version = 'v1.0';
73     uint256 public unitsBuy;     
74     uint256 public totalEthInWei;        
75     address public fundsWallet;         
76 
77     function CreatoryToken() {
78         balances[msg.sender] = 12000000000000000000000000000;     
79         totalSupply = 12000000000000000000000000000;    
80         name = "Creatory Network";                                 
81         decimals = 18;                                           
82         symbol = "XCR";                                             
83         unitsBuy = 200000;                                      
84         fundsWallet = msg.sender;                                  
85     }
86 
87     function() public payable{
88         totalEthInWei = totalEthInWei + msg.value;
89         uint256 amount = msg.value * unitsBuy;
90         require(balances[fundsWallet] >= amount);
91         balances[fundsWallet] = balances[fundsWallet] - amount;
92         balances[msg.sender] = balances[msg.sender] + amount;
93         Transfer(fundsWallet, msg.sender, amount);
94         fundsWallet.transfer(msg.value);                             
95     }
96 
97     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
101         return true;
102     }
103     function MultiTransfer(address[] addrs, uint256 amount) public {
104     for (uint256 i = 0; i < addrs.length; i++) {
105       transfer(addrs[i], amount);
106     }
107     
108   }
109   
110 }
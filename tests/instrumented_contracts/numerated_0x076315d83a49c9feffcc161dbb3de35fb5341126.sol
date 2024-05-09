1 contract Token {
2 
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 
12 }
13 contract StandardToken is Token {
14 
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24 
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
26         
27         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
28             balances[_to] += _value;
29             balances[_from] -= _value;
30             allowed[_from][msg.sender] -= _value;
31             Transfer(_from, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39 
40     function approve(address _spender, uint256 _value) returns (bool success) {
41         allowed[msg.sender][_spender] = _value;
42         Approval(msg.sender, _spender, _value);
43         return true;
44     }
45 
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
47       return allowed[_owner][_spender];
48     }
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     uint256 public totalSupply;
53 }
54 
55 contract Irapid is StandardToken { 
56 
57     string public name;                   
58     uint8 public decimals;                
59     string public symbol;                 
60     string public version = 'H1.0'; 
61     uint256 public unitsOneEthCanBuy;     
62     uint256 public totalEthInWei;         
63     address public fundsWallet;           
64 
65     function Irapid() {
66         balances[msg.sender] = 10000000000000000000000000;               
67         totalSupply = 10000000000000000000000000;                        
68         name = "Irapid";                                   
69         decimals = 18;                                               
70         symbol = "IRA";                                             
71         unitsOneEthCanBuy = 5800;                                      
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
92         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
93         return true;
94     }
95 }
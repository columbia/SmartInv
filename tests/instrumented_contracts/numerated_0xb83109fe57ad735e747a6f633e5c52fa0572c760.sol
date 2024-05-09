1 contract Token {
2 
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10 
11     function approve(address _spender, uint256 _value) returns (bool success);
12 
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 contract StandardToken is Token {
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 
60 contract UIOCOIN is StandardToken {
61 
62     function () {
63         throw;
64     }
65 
66     string public name;                   
67     uint8 public decimals;                
68     string public symbol;                 
69     string public version = 'H0.1';       
70 
71     function UIOCOIN(
72         uint256 _initialAmount,
73         string _tokenName,
74         uint8 _decimalUnits,
75         string _tokenSymbol
76         ) {
77         balances[msg.sender] = _initialAmount;               
78         totalSupply = _initialAmount;                        
79         name = _tokenName;                                   
80         decimals = _decimalUnits;                            
81         symbol = _tokenSymbol;                               
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87 
88         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
89         return true;
90     }
91 }
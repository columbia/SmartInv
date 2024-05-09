1 contract Token {
2     function totalSupply() constant returns (uint256 supply) {}
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function transfer(address _to, uint256 _value) returns (bool success) {}
5     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
6     function approve(address _spender, uint256 _value) returns (bool success) {}
7     function burn(uint256 _value) public returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9     
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     event Burn(address indexed from, uint256 value);
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
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32     function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35     function approve(address _spender, uint256 _value) returns (bool success) {
36         allowed[msg.sender][_spender] = _value;
37         Approval(msg.sender, _spender, _value);
38         return true;
39     }
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
41       return allowed[_owner][_spender];
42     }
43     function burn(uint256 _value) public returns (bool success) {
44         require(balances[msg.sender] >= _value);
45         balances[msg.sender] -= _value;
46         totalSupply -= _value;
47         Burn(msg.sender, _value);
48         return true;
49     }
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     uint256 public totalSupply;
53 }
54 contract HumanStandardToken is StandardToken {
55     function () {
56         //if ether is sent to this address, send it back.
57         throw;
58     }
59     string public name;                   
60     uint8 public decimals;                
61     string public symbol;                 
62     string public version = 'H0.1';       
63     function HumanStandardToken(
64         uint256 _initialAmount,
65         string _tokenName,
66         uint8 _decimalUnits,
67         string _tokenSymbol
68         ) {
69         balances[msg.sender] = _initialAmount;               
70         totalSupply = _initialAmount;                        
71         name = _tokenName;                                   
72         decimals = _decimalUnits;                            
73         symbol = _tokenSymbol;                               
74     }
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
79         return true;
80     }
81 }
82 
83 contract SafeCrypt is HumanStandardToken(1535714285000000000000000000, "SafeCrypt", 18, "SFC") {}
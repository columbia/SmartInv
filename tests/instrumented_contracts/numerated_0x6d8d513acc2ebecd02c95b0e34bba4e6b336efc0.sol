1 contract Token {
2     function totalSupply() constant returns (uint256 supply) {}
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function transfer(address _to, uint256 _value) returns (bool success) {}
5     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
6     function approve(address _spender, uint256 _value) returns (bool success) {}
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 
12 
13 contract StandardToken is Token {
14 
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         //Default assumes totalSupply can't be over max (2^256 - 1).
18         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
19         //Replace the if with this one instead.
20         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         //same as above. Replace this line with the following if you want to protect against wrapping uints.
31         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
57     uint256 public totalSupply;
58 }
59 
60 
61 contract HumanStandardToken is StandardToken {
62 
63     function () {
64         revert();
65     }
66 
67     /* Public variables of the token */
68 
69     string public name;                   //fancy name: eg Simon Bucks
70     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
71     string public symbol;                 //An identifier: eg SBX
72     string public version = "H 2.0";       //human 0.1 standard. Just an arbitrary versioning scheme.
73 
74     function HumanStandardToken(
75         uint256 _initialAmount,
76         string _tokenName,
77         uint8 _decimalUnits,
78         string _tokenSymbol
79         ) {
80         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
81         totalSupply = _initialAmount;                        // Update total supply
82         name = _tokenName;                                   // Set the name for display purposes
83         decimals = _decimalUnits;                            // Amount of decimals for display purposes
84         symbol = _tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     /* Approves and then calls the receiving contract */
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
93         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
94         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
95         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
96         return true;
97     }
98 }
99 
100 // Creates 21,000,000.00000000 BOBOv2 (BB2) Tokens
101 contract BOBOv2 is HumanStandardToken(2100000000000000, "BOBOv2", 8, "BB2") {}
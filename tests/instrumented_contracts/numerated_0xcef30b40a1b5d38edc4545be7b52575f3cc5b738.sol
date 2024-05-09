1 pragma solidity ^0.4.0;
2 
3 contract IconomiToken {
4 
5   event Transfer(address indexed _from, address indexed _to, uint256 _value);
6   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7   event BlockLockSet(uint256 _value);
8   event NewOwner(address _newOwner);
9 
10   modifier onlyOwner {
11     if (msg.sender == owner) {
12       _;
13     }
14   }
15 
16   modifier blockLock {
17     if (!isLocked() || msg.sender == owner) {
18       _;
19     }
20   }
21 
22   modifier checkIfToContract(address _to) {
23     if(_to != address(this))  {
24       _;
25     }
26   }
27 
28   uint256 public totalSupply;
29   string public name;
30   uint8 public decimals;
31   string public symbol;
32   string public version = '0.0.1';
33   address public owner;
34   uint256 public lockedUntilBlock;
35 
36   function IconomiToken(
37     uint256 _initialAmount,
38     string _tokenName,
39     uint8 _decimalUnits,
40     string _tokenSymbol,
41     uint256 _lockedUntilBlock
42     ) {
43     balances[msg.sender] = _initialAmount;
44     totalSupply = _initialAmount;
45     name = _tokenName;
46     decimals = _decimalUnits;
47     symbol = _tokenSymbol;
48     lockedUntilBlock = _lockedUntilBlock;
49     owner = msg.sender;
50   }
51 
52   /* Approves and then calls the receiving contract */
53   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
54 
55     allowed[msg.sender][_spender] = _value;
56     Approval(msg.sender, _spender, _value);
57 
58     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
59     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
60     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
61     if(!_spender.call(bytes4(sha3("receiveApproval(address,uint256,address,bytes)")), msg.sender, _value, this, _extraData)) { throw; }
62     return true;
63 
64   }
65 
66   function transfer(address _to, uint256 _value) blockLock checkIfToContract(_to) returns (bool success) {
67 
68     if (balances[msg.sender] >= _value && _value > 0) {
69       balances[msg.sender] -= _value;
70       balances[_to] += _value;
71       Transfer(msg.sender, _to, _value);
72       return true;
73     } else {
74       return false;
75     }
76 
77   }
78 
79   function transferFrom(address _from, address _to, uint256 _value) blockLock checkIfToContract(_to) returns (bool success) {
80 
81     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82       balances[_to] += _value;
83       balances[_from] -= _value;
84       allowed[_from][msg.sender] -= _value;
85       Transfer(_from, _to, _value);
86       return true;
87     } else {
88       return false;
89     }
90 
91   }
92 
93   function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function approve(address _spender, uint256 _value) returns (bool success) {
98     allowed[msg.sender][_spender] = _value;
99     Approval(msg.sender, _spender, _value);
100     return true;
101   }
102 
103   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104     return allowed[_owner][_spender];
105   }
106 
107   function setBlockLock(uint256 _lockedUntilBlock) onlyOwner returns (bool success) {
108     lockedUntilBlock = _lockedUntilBlock;
109     BlockLockSet(_lockedUntilBlock);
110     return true;
111   }
112 
113   function isLocked() constant returns (bool success) {
114     return lockedUntilBlock > block.number;
115   }
116 
117   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
118     owner = _newOwner;
119     NewOwner(_newOwner);
120     return true;
121   }
122 
123   mapping (address => uint256) balances;
124   mapping (address => mapping (address => uint256)) allowed;
125 }
126 
127 
128 contract IconomiTokenTest is IconomiToken {
129   function IconomiTokenTest(
130     uint256 _initialAmount,
131     string _tokenName,
132     uint8 _decimalUnits,
133     string _tokenSymbol,
134     uint256 _lockedUntilBlock
135     ) IconomiToken(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol, _lockedUntilBlock) {
136   }
137 
138   function destruct() onlyOwner {
139     selfdestruct(owner);
140   }
141 }
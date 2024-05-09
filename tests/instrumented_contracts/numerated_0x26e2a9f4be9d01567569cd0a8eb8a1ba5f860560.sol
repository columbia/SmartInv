1 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
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
16   modifier blockLock(address _sender) {
17     if (!isLocked() || _sender == owner) {
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
43 
44     balances[msg.sender] = _initialAmount;
45     totalSupply = _initialAmount;
46     name = _tokenName;
47     decimals = _decimalUnits;
48     symbol = _tokenSymbol;
49     lockedUntilBlock = _lockedUntilBlock;
50     owner = msg.sender;
51   }
52 
53   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
54     tokenRecipient spender = tokenRecipient(_spender);
55     if (approve(_spender, _value)) {
56       spender.receiveApproval(msg.sender, _value, this, _extraData);
57       return true;
58     }
59   }
60 
61   function transfer(address _to, uint256 _value) blockLock(msg.sender) checkIfToContract(_to) returns (bool success) {
62     if (balances[msg.sender] >= _value && _value > 0) {
63       balances[msg.sender] -= _value;
64       balances[_to] += _value;
65       Transfer(msg.sender, _to, _value);
66       return true;
67     } else {
68       return false;
69     }
70   }
71 
72   function transferFrom(address _from, address _to, uint256 _value) blockLock(_from) checkIfToContract(_to) returns (bool success) {
73     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
74       balances[_to] += _value;
75       balances[_from] -= _value;
76       allowed[_from][msg.sender] -= _value;
77       Transfer(_from, _to, _value);
78       return true;
79     } else {
80       return false;
81     }
82   }
83 
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88   function approve(address _spender, uint256 _value) returns (bool success) {
89     allowed[msg.sender][_spender] = _value;
90     Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95     return allowed[_owner][_spender];
96   }
97 
98   function setBlockLock(uint256 _lockedUntilBlock) onlyOwner returns (bool success) {
99     lockedUntilBlock = _lockedUntilBlock;
100     BlockLockSet(_lockedUntilBlock);
101     return true;
102   }
103 
104   function isLocked() constant returns (bool success) {
105     return lockedUntilBlock > block.number;
106   }
107 
108   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
109     owner = _newOwner;
110     NewOwner(_newOwner);
111     return true;
112   }
113 
114   mapping (address => uint256) balances;
115   mapping (address => mapping (address => uint256)) allowed;
116 }
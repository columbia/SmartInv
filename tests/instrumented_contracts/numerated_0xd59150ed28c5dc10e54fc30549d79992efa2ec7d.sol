1 pragma solidity ^0.4.24;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract Rhynex {
6 
7   event Transfer(address indexed _from, address indexed _to, uint256 _value);
8   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
9   event BlockLockSet(uint256 _value);
10   event NewOwner(address _newOwner);
11 
12   modifier onlyOwner {
13     if (msg.sender == owner) {
14       _;
15     }
16   }
17 
18   modifier blockLock(address _sender) {
19     if (!isLocked() || _sender == owner) {
20       _;
21     }
22   }
23 
24   modifier checkIfToContract(address _to) {
25     if(_to != address(this))  {
26       _;
27     }
28   }
29 
30   uint256 public totalSupply;
31   string public name;
32   uint8 public decimals;
33   string public symbol;
34   string public version = '0.1';
35   address public owner;
36   uint256 public lockedUntilBlock;
37 
38   function Rhynex(
39     uint256 _initialAmount,
40     string _tokenName,
41     uint8 _decimalUnits,
42     string _tokenSymbol,
43     uint256 _lockedUntilBlock
44     ) {
45 
46     balances[msg.sender] = _initialAmount;
47     totalSupply = _initialAmount;
48     name = _tokenName;
49     decimals = _decimalUnits;
50     symbol = _tokenSymbol;
51     lockedUntilBlock = _lockedUntilBlock;
52     owner = msg.sender;
53   }
54 
55   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
56     tokenRecipient spender = tokenRecipient(_spender);
57     if (approve(_spender, _value)) {
58       spender.receiveApproval(msg.sender, _value, this, _extraData);
59       return true;
60     }
61   }
62 
63   function transfer(address _to, uint256 _value) blockLock(msg.sender) checkIfToContract(_to) returns (bool success) {
64     if (balances[msg.sender] >= _value && _value > 0) {
65       balances[msg.sender] -= _value;
66       balances[_to] += _value;
67       Transfer(msg.sender, _to, _value);
68       return true;
69     } else {
70       return false;
71     }
72   }
73 
74   function transferFrom(address _from, address _to, uint256 _value) blockLock(_from) checkIfToContract(_to) returns (bool success) {
75     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
76       balances[_to] += _value;
77       balances[_from] -= _value;
78       allowed[_from][msg.sender] -= _value;
79       Transfer(_from, _to, _value);
80       return true;
81     } else {
82       return false;
83     }
84   }
85 
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90   function approve(address _spender, uint256 _value) returns (bool success) {
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97     return allowed[_owner][_spender];
98   }
99 
100   function setBlockLock(uint256 _lockedUntilBlock) onlyOwner returns (bool success) {
101     lockedUntilBlock = _lockedUntilBlock;
102     BlockLockSet(_lockedUntilBlock);
103     return true;
104   }
105 
106   function isLocked() constant returns (bool success) {
107     return lockedUntilBlock > block.number;
108   }
109 
110   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
111     owner = _newOwner;
112     NewOwner(_newOwner);
113     return true;
114   }
115 
116   mapping (address => uint256) balances;
117   mapping (address => mapping (address => uint256)) allowed;
118 }
1 pragma solidity ^0.4.7;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract Token {
6   event Transfer(address indexed _from, address indexed _to, uint256 _value);
7   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8   event TotalSupplySet(uint256 _amount);
9   event BlockLockSet(uint256 _value);
10   event NewOwner(address _newOwner);
11   event NewSupplyAdjuster(address _newSupplyAdjuster);
12 
13   modifier onlyOwner {
14     if (msg.sender == owner) {
15       _;
16     }
17   }
18 
19   modifier canAdjustSupply {
20     if (msg.sender == supplyAdjuster || msg.sender == owner) {
21       _;
22     }
23   }
24 
25   modifier blockLock(address _sender) {
26     if (!isLocked() || _sender == owner) {
27       _;
28     }
29   }
30 
31   modifier validTransfer(address _from, address _to, uint256 _amount) {
32     if (isTransferValid(_from, _to, _amount)) {
33       _;
34     }
35   }
36 
37   uint256 public totalSupply;
38   string public name;
39   uint8 public decimals;
40   string public symbol;
41   string public version = '0.0.1';
42   address public owner;
43   address public supplyAdjuster;
44   uint256 public lockedUntilBlock;
45 
46   function Token(
47     string _tokenName,
48     uint8 _decimalUnits,
49     string _tokenSymbol,
50     uint256 _lockedUntilBlock
51     ) {
52 
53     name = _tokenName;
54     decimals = _decimalUnits;
55     symbol = _tokenSymbol;
56     lockedUntilBlock = _lockedUntilBlock;
57     owner = msg.sender;
58   }
59 
60   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
61     tokenRecipient spender = tokenRecipient(_spender);
62     if (approve(_spender, _value)) {
63       spender.receiveApproval(msg.sender, _value, this, _extraData);
64       return true;
65     }
66   }
67 
68   function transfer(address _to, uint256 _value)
69       blockLock(msg.sender)
70       validTransfer(msg.sender, _to, _value)
71       returns (bool success) {
72 
73     // transfer tokens
74     balances[msg.sender] -= _value;
75     balances[_to] += _value;
76 
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint256 _value)
82       blockLock(_from)
83       validTransfer(_from, _to, _value)
84       returns (bool success) {
85 
86     // check sufficient allowance
87     if (_value > allowed[_from][msg.sender]) {
88       return false;
89     }
90 
91     // transfer tokens
92     balances[_from] -= _value;
93     balances[_to] += _value;
94     allowed[_from][msg.sender] -= _value;
95 
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104   function approve(address _spender, uint256 _value) returns (bool success) {
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114   function isTransferValid(address _from, address _to, uint256 _amount) internal constant returns (bool isValid) {
115     return  balances[_from] >= _amount &&                   // sufficient balance
116             isOverflow(balances[_to], _amount) == false &&  // does not overflow recipient balance
117             _amount > 0 &&                                  // amount is positive
118             _to != address(this)                            // prevent sending tokens to contract
119     ;
120   }
121 
122   function isOverflow(uint256 _value, uint256 _increase) internal constant returns (bool isOverflow) {
123     return _value + _increase < _value;
124   }
125 
126   function setBlockLock(uint256 _lockedUntilBlock) onlyOwner returns (bool success) {
127     lockedUntilBlock = _lockedUntilBlock;
128     BlockLockSet(_lockedUntilBlock);
129     return true;
130   }
131 
132   function isLocked() constant returns (bool success) {
133     return lockedUntilBlock > block.number;
134   }
135 
136   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
137     owner = _newOwner;
138     NewOwner(_newOwner);
139     return true;
140   }
141 
142   function setSupplyAdjuster(address _newSupplyAdjuster) onlyOwner returns (bool success) {
143     supplyAdjuster = _newSupplyAdjuster;
144     NewSupplyAdjuster(_newSupplyAdjuster);
145     return true;
146   }
147 
148   function setTotalSupply(uint256 _amount) canAdjustSupply returns (bool success) {
149     totalSupply = _amount;
150     TotalSupplySet(totalSupply);
151     return true;
152   }
153 
154   function setBalance(address _addr, uint256 _newBalance) canAdjustSupply returns (bool success) {
155     uint256 oldBalance = balances[_addr];
156 
157     balances[_addr] = _newBalance;
158 
159     if (oldBalance > _newBalance) {
160       Transfer(_addr, this, oldBalance - _newBalance);
161     } else if (_newBalance > oldBalance) {
162       Transfer(this, _addr, _newBalance - oldBalance);
163     }
164 
165     return true;
166   }
167 
168   mapping (address => uint256) balances;
169   mapping (address => mapping (address => uint256)) allowed;
170 }
1 pragma solidity ^0.4.0;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract DogTestToken {
6    
7   string public constant name = "Dog Test Token2";
8 
9   string public constant symbol = "DTT";
10 
11   uint8 public constant decimals = 18;
12 
13   string public constant version = '0.1';
14 
15   uint256 public constant totalSupply = 1000000000 * 1000000000000000000;
16 
17   address public owner;
18 
19   uint256 public constant lockedUntilBlock = 0;
20 
21   event Transfer(address indexed _from, address indexed _to, uint256 _value);
22   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23   event BlockLockSet(uint256 _value);
24   event NewOwner(address _newOwner);
25   
26   modifier onlyOwner {
27     if (msg.sender == owner) {
28       _;
29     }
30   }
31 
32   function isLocked() constant returns (bool success) {
33     return lockedUntilBlock > block.number;
34   }
35 
36   modifier blockLock(address _sender) {
37     if (!isLocked() || _sender == owner) {
38       _;
39     }
40   }
41 
42   modifier checkIfToContract(address _to) {
43     if(_to != address(this))  {
44       _;
45     }
46   }    
47 
48   function DogTestToken() {
49     owner = msg.sender;
50     balances[owner] = totalSupply;        
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
98   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
99     owner = _newOwner;
100     NewOwner(_newOwner);
101     return true;
102   }
103 
104   mapping (address => uint256) balances;
105   mapping (address => mapping (address => uint256)) allowed;
106 }
1 pragma solidity ^0.4.0;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract RoundToken {
6    
7   string public constant name = "ROUND";
8 
9   string public constant symbol = "ROUND";
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
48   mapping (address => uint256) balances;
49   mapping (address => mapping (address => uint256)) allowed;
50 
51   function RoundToken() {
52     owner = msg.sender;
53     balances[owner] = totalSupply;        
54   }  
55 
56   function replaceOwner(address _newOwner) onlyOwner returns (bool success) {
57     owner = _newOwner;
58     NewOwner(_newOwner);
59     return true;
60   }
61 
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66   function transfer(address _to, uint256 _value) blockLock(msg.sender) checkIfToContract(_to) returns (bool success) {
67     if (balances[msg.sender] >= _value && _value > 0) {
68       balances[msg.sender] -= _value;
69       balances[_to] += _value;
70       Transfer(msg.sender, _to, _value);
71       return true;
72     } else {
73       return false;
74     }
75   }
76 
77   function transferFrom(address _from, address _to, uint256 _value) blockLock(_from) checkIfToContract(_to) returns (bool success) {
78     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79       balances[_to] += _value;
80       balances[_from] -= _value;
81       allowed[_from][msg.sender] -= _value;
82       Transfer(_from, _to, _value);
83       return true;
84     } else {
85       return false;
86     }
87   }  
88 
89   function approve(address _spender, uint256 _value) returns (bool success) {
90     allowed[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
96     tokenRecipient spender = tokenRecipient(_spender);
97     if (approve(_spender, _value)) {
98       spender.receiveApproval(msg.sender, _value, this, _extraData);
99       return true;
100     }
101   }
102 
103   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104     return allowed[_owner][_spender];
105   }      
106 }
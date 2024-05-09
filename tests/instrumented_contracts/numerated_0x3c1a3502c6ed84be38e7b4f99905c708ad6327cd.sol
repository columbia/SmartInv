1 pragma solidity ^0.4.25;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract esccoin is owned{
21 
22 using SafeMath for uint256;
23 
24 string public constant symbol = "ESC";
25 string public constant name = "ESC Coin";
26 uint8 public constant decimals = 18;
27 uint256 _initialSupply = 1000000 * 10 ** uint256(decimals);
28 uint256 _totalSupply;
29 
30 // Owner of this contract
31 address public owner;
32 
33 // Balances for each account
34 mapping(address => uint256) balances;
35 
36 // Owner of account approves the transfer of an amount to another account
37 mapping(address => mapping (address => uint256)) allowed;
38 
39 // Constructor
40 constructor() esccoin() public {
41    owner = msg.sender;
42    _totalSupply = _initialSupply;
43    balances[owner] = _totalSupply;
44 }
45 
46 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
47     uint256 _mintedAmount = mintedAmount * 10 ** 18;
48     balances[target] += _mintedAmount;
49     _totalSupply += _mintedAmount;
50     emit Transfer(0x0, owner, _mintedAmount);
51     emit Transfer(owner, target, _mintedAmount);
52 }
53 
54 function burn(uint256 value) public returns (bool success) {
55     uint256 _value = value * 10 ** 18;
56     require(balances[msg.sender] >= _value);   // Check if the sender has enough
57     balances[msg.sender] -= _value;            // Subtract from the sender
58     _totalSupply -= _value;                      // Updates totalSupply
59     emit Burn(msg.sender, _value);
60     emit Transfer(msg.sender, 0x0, _value);
61 
62     return true;
63 }
64 
65 function totalSupply() public view returns (uint256) {
66    return _totalSupply;
67 }
68 
69 function balanceOf(address _owner) public view returns (uint256 balance) {
70    return balances[_owner];
71 }
72 
73 function transfer(address _to, uint256 _amount) public returns (bool success) {
74    if (balances[msg.sender] >= _amount && _amount > 0) {
75        balances[msg.sender] = balances[msg.sender].sub(_amount);
76        balances[_to] = balances[_to].add(_amount);
77        emit Transfer(msg.sender, _to, _amount);
78        return true;
79    } else {
80        return false;
81    }
82 }
83 
84 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
85    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
86        balances[_from] = balances[_from].sub(_amount);
87        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
88        balances[_to] = balances[_to].add(_amount);
89        emit Transfer(_from, _to, _amount);
90        return true;
91    } else {
92        return false;
93    }
94 }
95 
96 function approve(address _spender, uint256 _amount) public returns (bool success) {
97    if(balances[msg.sender]>=_amount && _amount>0) {
98        allowed[msg.sender][_spender] = _amount;
99        emit Approval(msg.sender, _spender, _amount);
100        return true;
101    } else {
102        return false;
103    }
104 }
105 
106 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107    return allowed[_owner][_spender];
108 }
109 
110 event Transfer(address indexed _from, address indexed _to, uint _value);
111 event Approval(address indexed _owner, address indexed _spender, uint _value);
112 event Burn(address indexed from, uint256 value);
113 
114 function getMyBalance() public view returns (uint) {
115    return balances[msg.sender];
116 }
117 }
118 
119 library SafeMath {
120 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a * b;
122     assert(a == 0 || c / a == b);
123     return c;
124     }
125 
126 function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a / b;
128     return c;
129     }
130 
131 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134     }
135 
136 function add(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140     }
141 }
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
20 contract token123 is owned{
21 
22 using SafeMath for uint256;
23 
24 string public constant symbol = "123";
25 string public constant name = "token123";
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
39 
40 
41 
42 // Constructor
43 constructor() token123() public {
44    owner = msg.sender;
45    _totalSupply = _initialSupply;
46    balances[owner] = _totalSupply;
47 }
48 
49 // ERC20
50 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
51     balances[target] += mintedAmount;
52     _totalSupply += mintedAmount;
53     emit Transfer(0x0, owner, mintedAmount);
54     emit Transfer(owner, target, mintedAmount);
55 }
56 
57 function burn(uint256 _value) public returns (bool success) {
58     require(balances[msg.sender] >= _value);   // Check if the sender has enough
59     balances[msg.sender] -= _value;            // Subtract from the sender
60     _totalSupply -= _value;                      // Updates totalSupply
61     emit Burn(msg.sender, _value);
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
72 /*function _transfer(address _from, address _to, uint _value) internal {
73     require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
74     require (balances[_from] >= _value);                   // Check if the sender has enough
75     require (balances[_to] + _value >= balances[_to]);    // Check for overflows
76     balances[_from] -= _value;                             // Subtract from the sender
77     balances[_to] += _value;                               // Add the same to the recipient
78     emit Transfer(_from, _to, _value);
79     }*/
80 
81 function transfer(address _to, uint256 _amount) public returns (bool success) {
82    if (balances[msg.sender] >= _amount && _amount > 0) {
83        balances[msg.sender] = balances[msg.sender].sub(_amount);
84        balances[_to] = balances[_to].add(_amount);
85        emit Transfer(msg.sender, _to, _amount);
86        return true;
87    } else {
88        return false;
89    }
90 }
91 
92 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
93    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
94        balances[_from] = balances[_from].sub(_amount);
95        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
96        balances[_to] = balances[_to].add(_amount);
97        emit Transfer(_from, _to, _amount);
98        return true;
99    } else {
100        return false;
101    }
102 }
103 
104 function approve(address _spender, uint256 _amount) public returns (bool success) {
105    if(balances[msg.sender]>=_amount && _amount>0) {
106        allowed[msg.sender][_spender] = _amount;
107        emit Approval(msg.sender, _spender, _amount);
108        return true;
109    } else {
110        return false;
111    }
112 }
113 
114 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
115    return allowed[_owner][_spender];
116 }
117 
118 event Transfer(address indexed _from, address indexed _to, uint _value);
119 event Approval(address indexed _owner, address indexed _spender, uint _value);
120 event Burn(address indexed from, uint256 value);
121 
122 
123 // custom
124 function getMyBalance() public view returns (uint) {
125    return balances[msg.sender];
126 }
127 }
128 
129 library SafeMath {
130 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a * b;
132     assert(a == 0 || c / a == b);
133     return c;
134     }
135 
136 function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a / b;
138     return c;
139     }
140 
141 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142     assert(b <= a);
143     return a - b;
144     }
145 
146 function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     assert(c >= a);
149     return c;
150     }
151 }
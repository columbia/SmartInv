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
20 contract token1234 is owned{
21 
22 using SafeMath for uint256;
23 
24 string public constant symbol = "T1234";
25 string public constant name = "token1234";
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
43 constructor() token1234() public {
44    owner = msg.sender;
45    _totalSupply = _initialSupply;
46    balances[owner] = _totalSupply;
47 }
48 
49 // ERC20
50 function mintToken(address target, uint256 mintedAmount) onlyOwner public {
51     uint256 _mintedAmount = mintedAmount * 10 ** 18;
52     balances[target] += _mintedAmount;
53     _totalSupply += _mintedAmount;
54     emit Transfer(0x0, owner, _mintedAmount);
55     emit Transfer(owner, target, _mintedAmount);
56 }
57 
58 function burn(uint256 value) public returns (bool success) {
59     uint256 _value = value * 10 ** 18;
60     require(balances[msg.sender] >= _value);   // Check if the sender has enough
61     balances[msg.sender] -= _value;            // Subtract from the sender
62     _totalSupply -= _value;                      // Updates totalSupply
63     emit Burn(msg.sender, _value);
64     return true;
65 }
66 
67 function totalSupply() public view returns (uint256) {
68    return _totalSupply;
69 }
70 
71 function balanceOf(address _owner) public view returns (uint256 balance) {
72    return balances[_owner];
73 }
74 /*function _transfer(address _from, address _to, uint _value) internal {
75     require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
76     require (balances[_from] >= _value);                   // Check if the sender has enough
77     require (balances[_to] + _value >= balances[_to]);    // Check for overflows
78     balances[_from] -= _value;                             // Subtract from the sender
79     balances[_to] += _value;                               // Add the same to the recipient
80     emit Transfer(_from, _to, _value);
81     }*/
82 
83 function transfer(address _to, uint256 _amount) public returns (bool success) {
84    if (balances[msg.sender] >= _amount && _amount > 0) {
85        balances[msg.sender] = balances[msg.sender].sub(_amount);
86        balances[_to] = balances[_to].add(_amount);
87        emit Transfer(msg.sender, _to, _amount);
88        return true;
89    } else {
90        return false;
91    }
92 }
93 
94 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
95    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
96        balances[_from] = balances[_from].sub(_amount);
97        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
98        balances[_to] = balances[_to].add(_amount);
99        emit Transfer(_from, _to, _amount);
100        return true;
101    } else {
102        return false;
103    }
104 }
105 
106 function approve(address _spender, uint256 _amount) public returns (bool success) {
107    if(balances[msg.sender]>=_amount && _amount>0) {
108        allowed[msg.sender][_spender] = _amount;
109        emit Approval(msg.sender, _spender, _amount);
110        return true;
111    } else {
112        return false;
113    }
114 }
115 
116 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
117    return allowed[_owner][_spender];
118 }
119 
120 event Transfer(address indexed _from, address indexed _to, uint _value);
121 event Approval(address indexed _owner, address indexed _spender, uint _value);
122 event Burn(address indexed from, uint256 value);
123 
124 
125 // custom
126 function getMyBalance() public view returns (uint) {
127    return balances[msg.sender];
128 }
129 }
130 
131 library SafeMath {
132 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a * b;
134     assert(a == 0 || c / a == b);
135     return c;
136     }
137 
138 function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     uint256 c = a / b;
140     return c;
141     }
142 
143 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144     assert(b <= a);
145     return a - b;
146     }
147 
148 function add(uint256 a, uint256 b) internal pure returns (uint256) {
149     uint256 c = a + b;
150     assert(c >= a);
151     return c;
152     }
153 }
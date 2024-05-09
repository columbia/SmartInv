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
20 contract token12345 is owned{
21 
22 using SafeMath for uint256;
23 
24 string public constant symbol = "T12345";
25 string public constant name = "token12345";
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
43 constructor() token12345() public {
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
64     emit Transfer(msg.sender, 0x0, _value);
65 
66     return true;
67 }
68 
69 function totalSupply() public view returns (uint256) {
70    return _totalSupply;
71 }
72 
73 function balanceOf(address _owner) public view returns (uint256 balance) {
74    return balances[_owner];
75 }
76 
77 function transfer(address _to, uint256 _amount) public returns (bool success) {
78    if (balances[msg.sender] >= _amount && _amount > 0) {
79        balances[msg.sender] = balances[msg.sender].sub(_amount);
80        balances[_to] = balances[_to].add(_amount);
81        emit Transfer(msg.sender, _to, _amount);
82        return true;
83    } else {
84        return false;
85    }
86 }
87 
88 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
89    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
90        balances[_from] = balances[_from].sub(_amount);
91        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
92        balances[_to] = balances[_to].add(_amount);
93        emit Transfer(_from, _to, _amount);
94        return true;
95    } else {
96        return false;
97    }
98 }
99 
100 function approve(address _spender, uint256 _amount) public returns (bool success) {
101    if(balances[msg.sender]>=_amount && _amount>0) {
102        allowed[msg.sender][_spender] = _amount;
103        emit Approval(msg.sender, _spender, _amount);
104        return true;
105    } else {
106        return false;
107    }
108 }
109 
110 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
111    return allowed[_owner][_spender];
112 }
113 
114 event Transfer(address indexed _from, address indexed _to, uint _value);
115 event Approval(address indexed _owner, address indexed _spender, uint _value);
116 event Burn(address indexed from, uint256 value);
117 
118 
119 // custom
120 function getMyBalance() public view returns (uint) {
121    return balances[msg.sender];
122 }
123 }
124 
125 library SafeMath {
126 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130     }
131 
132 function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a / b;
134     return c;
135     }
136 
137 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140     }
141 
142 function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146     }
147 }
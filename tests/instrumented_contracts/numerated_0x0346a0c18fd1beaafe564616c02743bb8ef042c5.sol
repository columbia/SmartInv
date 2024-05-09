1 pragma solidity ^0.4.25;
2 
3 contract EasyCircle {
4 
5 using SafeMath for uint256;
6 string public constant symbol = "ECX";
7 string public constant name = "EasyCircle";
8 uint8 public constant decimals = 18;
9 uint256 _totalSupply = 777777777 * 10 ** uint256(decimals);
10 
11 // Owner of this contract
12 address public owner;
13 
14 // Balances for each account
15 mapping(address => uint256) balances;
16 
17 // Owner of account approves the transfer of an amount to another account
18 mapping(address => mapping (address => uint256)) allowed;
19 
20 // Constructor
21 constructor() EasyCircle() public {
22    owner = msg.sender;
23    balances[owner] = _totalSupply;
24 }
25 
26 // ERC20
27 function totalSupply() public constant returns (uint256) {
28    return _totalSupply;
29 }
30 
31 function balanceOf(address _owner) public constant returns (uint256 balance) {
32    return balances[_owner];
33 }
34 
35 function transfer(address _to, uint256 _amount) public returns (bool success) {
36    if (balances[msg.sender] >= _amount && _amount > 0) {
37        balances[msg.sender] = balances[msg.sender].sub(_amount);
38        balances[_to] = balances[_to].add(_amount);
39        emit Transfer(msg.sender, _to, _amount);
40        return true;
41    } else {
42        return false;
43    }
44 }
45 
46 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
47    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
48        balances[_from] = balances[_from].sub(_amount);
49        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
50        balances[_to] = balances[_to].add(_amount);
51        emit Transfer(_from, _to, _amount);
52        return true;
53    } else {
54        return false;
55    }
56 }
57 
58 function approve(address _spender, uint256 _amount) public returns (bool success) {
59    if(balances[msg.sender]>=_amount && _amount>0) {
60        allowed[msg.sender][_spender] = _amount;
61        emit Approval(msg.sender, _spender, _amount);
62        return true;
63    } else {
64        return false;
65    }
66 }
67 
68 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
69    return allowed[_owner][_spender];
70 }
71 
72 event Transfer(address indexed _from, address indexed _to, uint _value);
73 event Approval(address indexed _owner, address indexed _spender, uint _value);
74 
75 // custom
76 function getMyBalance() public view returns (uint) {
77    return balances[msg.sender];
78 }
79 }
80 
81 library SafeMath {
82 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a * b;
84     assert(a == 0 || c / a == b);
85     return c;
86     }
87 
88 function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a / b;
90     return c;
91     }
92 
93 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96     }
97 
98 function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102     }
103 }
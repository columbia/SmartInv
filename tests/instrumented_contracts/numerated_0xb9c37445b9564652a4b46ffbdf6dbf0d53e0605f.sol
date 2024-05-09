1 pragma solidity ^0.5.9;
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
20 contract CoinZoneToken is owned{
21 
22 using SafeMath for uint256;
23 
24 string public constant symbol = "CZT";
25 string public constant name = "CoinZoneToken";
26 uint8 public constant decimals = 18;
27 uint256 _initialSupply = 77000000 * 10 ** uint256(decimals);
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
40 constructor() CoinZoneToken() public {
41    owner = msg.sender;
42    _totalSupply = _initialSupply;
43    balances[owner] = _totalSupply;
44 }
45 
46 
47 function totalSupply() public view returns (uint256) {
48    return _totalSupply;
49 }
50 
51 function balanceOf(address _owner) public view returns (uint256 balance) {
52    return balances[_owner];
53 }
54 
55 function transfer(address _to, uint256 _amount) public returns (bool success) {
56    if (balances[msg.sender] >= _amount && _amount > 0) {
57        balances[msg.sender] = balances[msg.sender].sub(_amount);
58        balances[_to] = balances[_to].add(_amount);
59        emit Transfer(msg.sender, _to, _amount);
60        return true;
61    } else {
62        return false;
63    }
64 }
65 
66 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
67    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0) {
68        balances[_from] = balances[_from].sub(_amount);
69        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
70        balances[_to] = balances[_to].add(_amount);
71        emit Transfer(_from, _to, _amount);
72        return true;
73    } else {
74        return false;
75    }
76 }
77 
78 function approve(address _spender, uint256 _amount) public returns (bool success) {
79    if(balances[msg.sender]>=_amount && _amount>0) {
80        allowed[msg.sender][_spender] = _amount;
81        emit Approval(msg.sender, _spender, _amount);
82        return true;
83    } else {
84        return false;
85    }
86 }
87 
88 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
89    return allowed[_owner][_spender];
90 }
91 
92 event Transfer(address indexed _from, address indexed _to, uint _value);
93 event Approval(address indexed _owner, address indexed _spender, uint _value);
94 event Burn(address indexed from, uint256 value);
95 
96 function getMyBalance() public view returns (uint) {
97    return balances[msg.sender];
98 }
99 }
100 
101 library SafeMath {
102 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a * b;
104     assert(a == 0 || c / a == b);
105     return c;
106     }
107 
108 function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     uint256 c = a / b;
110     return c;
111     }
112 
113 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116     }
117 
118 function add(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122     }
123 }
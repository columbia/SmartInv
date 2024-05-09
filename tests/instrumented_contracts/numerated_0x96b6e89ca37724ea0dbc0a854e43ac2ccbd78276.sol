1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   function transfer(address _to, uint256 _value) returns (bool) {
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   function balanceOf(address _owner) constant returns (uint256 balance) {
49     return balances[_owner];
50   }
51 
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract StandardToken is ERC20, BasicToken {
62 
63   mapping (address => mapping (address => uint256)) allowed;
64 
65 
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68 
69     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
70     // require (_value <= _allowance);
71 
72     balances[_to] = balances[_to].add(_value);
73     balances[_from] = balances[_from].sub(_value);
74     allowed[_from][msg.sender] = _allowance.sub(_value);
75     Transfer(_from, _to, _value);
76     return true;
77   }
78 
79 
80   function approve(address _spender, uint256 _value) returns (bool) {
81 
82     // To change the approve amount you first have to reduce the addresses`
83     //  allowance to zero by calling `approve(_spender, 0)` if it is not
84     //  already 0 to mitigate the race condition described here:
85     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
87 
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93 
94   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95     return allowed[_owner][_spender];
96   }
97 
98 }
99 
100 
101 contract YPAYToken is StandardToken {
102 
103   string public constant name = "YPAY Token";
104   string public constant symbol = "YPAY";
105   uint256 public constant decimals = 5;
106 
107   uint256 public constant INITIAL_SUPPLY = 13950000 * 10**5;
108 
109 
110   function YPAYToken() {
111     totalSupply = INITIAL_SUPPLY;
112     balances[msg.sender] = INITIAL_SUPPLY;
113   }
114 
115 }
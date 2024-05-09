1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) public view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   uint256 totalSupply_;
54 
55   function totalSupply() public view returns (uint256) {
56     return totalSupply_;
57   }
58 
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   function balanceOf(address _owner) public view returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) public view returns (uint256) {
99     return allowed[_owner][_spender];
100   }
101 
102   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109     uint oldValue = allowed[msg.sender][_spender];
110     if (_subtractedValue > oldValue) {
111       allowed[msg.sender][_spender] = 0;
112     } else {
113       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114     }
115     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119 }
120 
121  
122  contract Dominator is StandardToken {
123  
124      string public constant name = 'Dominator';
125      string public constant symbol = 'DOTR';
126      uint8 public constant decimals = 18;
127      uint256 public constant INITIAL_SUPPLY = 5 * 10 ** (9 + uint256(decimals));
128  
129  
130      function Dominator() public {
131        totalSupply_ = INITIAL_SUPPLY;
132        balances[msg.sender] = INITIAL_SUPPLY;
133      }
134  }
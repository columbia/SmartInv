1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   uint256 totalSupply_;
46 
47   function totalSupply() public view returns (uint256) {
48     return totalSupply_;
49   }
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(address _owner) public view returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78 
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[_from]);
82     require(_value <= allowed[_from][msg.sender]);
83 
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     emit Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function approve(address _spender, uint256 _value) public returns (bool) {
92     allowed[msg.sender][_spender] = _value;
93     emit Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   function allowance(address _owner, address _spender) public view returns (uint256) {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 }
119 
120 contract RoshanToken is StandardToken {
121   string public name    = "ROSHAN.IO";
122   string public symbol  = "RSIO";
123   uint8 public decimals = 5;
124 
125   // initial supply
126   uint256 public constant INITIAL_SUPPLY = 7600000000;
127 
128   constructor() public {
129     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
130     balances[msg.sender] = totalSupply_;
131   }
132 }
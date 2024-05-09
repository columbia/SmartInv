1 pragma solidity ^0.4.21;
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
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public constant returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) public constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62  
63   function balanceOf(address _owner) public constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 
67 }
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[_from]);
76     require(_value <= allowed[_from][msg.sender]);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
92     return allowed[_owner][_spender];
93   }
94 
95   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
96     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98     return true;
99   }
100 
101   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
102     uint oldValue = allowed[msg.sender][_spender];
103     if (_subtractedValue > oldValue) {
104       allowed[msg.sender][_spender] = 0;
105     } else {
106       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107     }
108     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112 }
113 
114 contract VIWOZ is StandardToken {
115 
116   string public constant name = "VIWOZ";
117   string public constant symbol = "WOZ";
118   uint8 public constant decimals = 8;
119 
120   uint256 public constant INITIAL_SUPPLY = 99000000000 * (10 ** uint256(decimals));
121 
122   function VIWOZ() {
123     totalSupply = INITIAL_SUPPLY;
124     balances[msg.sender] = INITIAL_SUPPLY;
125   }
126 
127 }
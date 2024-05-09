1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) constant returns (uint256);
4   function transfer(address to, uint256 value) returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 contract ERC20 is ERC20Basic {
8   function allowance(address owner, address spender) constant returns (uint256);
9   function transferFrom(address from, address to, uint256 value) returns (bool);
10   function approve(address spender, uint256 value) returns (bool);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   function transfer(address _to, uint256 _value) returns (bool) {
42     require(_to != address(0));
43 
44     // SafeMath.sub will throw if there is not enough balance.
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function balanceOf(address _owner) constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 }
55 contract Ownable {
56     
57   address public owner;
58 
59   function Ownable() {
60     owner = msg.sender;
61   }
62 
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   function transferOwnership(address newOwner) onlyOwner {
69     require(newOwner != address(0));      
70     owner = newOwner;
71   }
72 }
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78     require(_to != address(0));
79 
80     var _allowance = allowed[_from][msg.sender];
81 
82     balances[_from] = balances[_from].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     allowed[_from][msg.sender] = _allowance.sub(_value);
85     Transfer(_from, _to, _value);
86     return true;
87   }
88 
89   function approve(address _spender, uint256 _value) returns (bool) {
90     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
91 
92     allowed[msg.sender][_spender] = _value;
93     Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98     return allowed[_owner][_spender];
99   }
100   
101   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 }
118 contract MoncryptToken is StandardToken, Ownable {
119     
120     string public constant name = "MONCRYPT Token";
121     
122     string public constant symbol = "MON";
123     
124     uint32 public constant decimals = 8;
125     
126     uint256 _totalSupply = 3000000000000000;
127 
128     function MoncryptToken() {
129         balances[owner] = _totalSupply;
130         totalSupply = _totalSupply;
131     }
132 }
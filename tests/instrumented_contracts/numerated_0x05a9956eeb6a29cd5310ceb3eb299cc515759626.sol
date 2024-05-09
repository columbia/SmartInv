1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public constant returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19       uint256 c = a / b;
20       return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   function transfer(address _to, uint256 _value) public returns (bool) {
46     require(_to != address(0));
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53 
54   function balanceOf(address _owner) public constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) allowed;
63 
64 
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67 
68     uint256 _allowance = allowed[_from][msg.sender];
69 
70     balances[_from] = balances[_from].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77 
78   function approve(address _spender, uint256 _value) public returns (bool) {
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84 
85   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89 
90   function increaseApproval (address _spender, uint _addedValue)
91     returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue)
98     returns (bool success) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 
109 }
110 
111 
112 
113 contract AIREP is StandardToken {
114 	string public name = "AIREP Coin"; 
115 	string public symbol = "AIREP";
116 	uint public decimals = 18;
117 	uint public INITIAL_SUPPLY = 10000000000000000000000000000;
118 
119 	function AIREP() {
120 		totalSupply = INITIAL_SUPPLY;
121 		balances[msg.sender] = INITIAL_SUPPLY;
122 	}
123 }
1 pragma solidity ^0.4.11;
2 
3 
4 
5     // ----------------------------------------------------------------------------
6     //            https://macritoken.com - Macri Token - FMI - Argentina
7     // ----------------------------------------------------------------------------
8     
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract ERC20Basic {
38   uint256 public totalSupply;
39   function balanceOf(address who) public constant returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) public returns (bool);
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69 
70   function balanceOf(address _owner) public constant returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81 
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95  
96   function approve(address _spender, uint256 _value) public returns (bool) {
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102  
103   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
104     return allowed[_owner][_spender];
105   }
106 
107   /**
108    * approve should be called when allowed[_spender] == 0. To increment
109    * allowed value is better to use this function to avoid 2 calls (and wait until
110    * the first transaction is mined)
111    */
112   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129 }
130 
131 
132 contract SimpleToken is StandardToken {
133 
134   string public constant name = "MacriToken";
135   string public constant symbol = "MCT";
136   uint8 public constant decimals = 18;
137 
138   uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
139 
140   
141   function SimpleToken() {
142     totalSupply = INITIAL_SUPPLY;
143     balances[msg.sender] = INITIAL_SUPPLY;
144   }
145 
146 }
147 
148 
149 
150     // ----------------------------------------------------------------------------
151     //            https://macritoken.com - Macri Token - FMI - Argentina
152     // ----------------------------------------------------------------------------
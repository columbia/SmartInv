1 pragma solidity ^0.4.11;
2 
3 
4     //****************************************************
5     //         https://ArgenPeso.com - ArgenPeso        //
6     //****************************************************
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract ERC20Basic {
36   uint256 public totalSupply;
37   function balanceOf(address who) public constant returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67 
68   function balanceOf(address _owner) public constant returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78 
79 
80 
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[_from]);
84     require(_value <= allowed[_from][msg.sender]);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93  
94   function approve(address _spender, uint256 _value) public returns (bool) {
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100  
101   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
102     return allowed[_owner][_spender];
103   }
104 
105   /**
106    * approve should be called when allowed[_spender] == 0. To increment
107    * allowed value is better to use this function to avoid 2 calls (and wait until
108    * the first transaction is mined)
109    */
110   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
111     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
117     uint oldValue = allowed[msg.sender][_spender];
118     if (_subtractedValue > oldValue) {
119       allowed[msg.sender][_spender] = 0;
120     } else {
121       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122     }
123     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126 
127 }
128 
129 
130 contract SimpleToken is StandardToken {
131 
132   string public constant name = "ArgenPeso";
133   string public constant symbol = "ARGP";
134   uint8 public constant decimals = 18;
135 
136   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
137 
138   
139   function SimpleToken() {
140     totalSupply = INITIAL_SUPPLY;
141     balances[msg.sender] = INITIAL_SUPPLY;
142   }
143 
144 }
145 
146     //****************************************************
147     //         https://ArgenPeso.com - ArgenPeso        //
148     //****************************************************
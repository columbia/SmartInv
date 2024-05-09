1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // MobilinkToken - MOLK Token Contract
5 // ----------------------------------------------------------------------------
6 
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   uint256 totalSupply_;
27 
28   function totalSupply() public view returns (uint256) {
29     return totalSupply_;
30   }
31 
32   function transfer(address _to, uint256 _value) public returns (bool) {
33     require(_to != address(0));
34     require(_value <= balances[msg.sender]);
35 
36     // SafeMath.sub will throw if there is not enough balance.
37     balances[msg.sender] = balances[msg.sender].sub(_value);
38     balances[_to] = balances[_to].add(_value);
39     emit Transfer(msg.sender, _to, _value);
40     return true;
41   }
42 
43   function balanceOf(address _owner) public view returns (uint256 balance) {
44     return balances[_owner];
45   }
46 
47 }
48 
49 contract StandardToken is ERC20, BasicToken {
50 
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[_from]);
56     require(_value <= allowed[_from][msg.sender]);
57 
58     balances[_from] = balances[_from].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
61     emit Transfer(_from, _to, _value);
62     return true;
63   }
64 
65   function approve(address _spender, uint256 _value) public returns (bool) {
66     allowed[msg.sender][_spender] = _value;
67     emit Approval(msg.sender, _spender, _value);
68     return true;
69   }
70 
71   function allowance(address _owner, address _spender) public view returns (uint256) {
72     return allowed[_owner][_spender];
73   }
74 
75   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
76     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
77     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
78     return true;
79   }
80 
81   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
82     uint oldValue = allowed[msg.sender][_spender];
83     if (_subtractedValue > oldValue) {
84       allowed[msg.sender][_spender] = 0;
85     } else {
86       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
87     }
88     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89     return true;
90   }
91 
92 }
93 
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     if (a == 0) {
101       return 0;
102     }
103     uint256 c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   /**
119   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 contract MobilinkTokenConfig {
137     string public constant NAME = "MobilinkToken";
138     string public constant SYMBOL = "MOLK";
139     uint8 public constant DECIMALS = 18;
140     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
141     uint public constant INITIAL_SUPPLY = 9000000000 * DECIMALSFACTOR;
142 }
143 
144 contract MobilinkToken is StandardToken, MobilinkTokenConfig {
145     string public name = NAME;
146     string public symbol = SYMBOL;
147     uint8 public decimals = DECIMALS;
148 
149     function MobilinkToken() public {
150         totalSupply_ = INITIAL_SUPPLY;
151         balances[msg.sender] = INITIAL_SUPPLY;
152         emit Transfer(msg.sender, msg.sender, INITIAL_SUPPLY);
153     }
154 }
1 /**
2  * @title Math
3  * @dev Assorted math operations
4  */
5 library Math {
6   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
7     return a >= b ? a : b;
8   }
9 
10   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
11     return a < b ? a : b;
12   }
13 
14   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a >= b ? a : b;
16   }
17 
18   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a < b ? a : b;
20   }
21 }
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (a == 0) {
38       return 0;
39     }
40 
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 
76 contract HHT {
77 
78   using SafeMath for uint256;
79 
80 
81   uint256 totalSupply_;
82   event Transfer(address indexed from, address indexed to, uint256 value);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   function balanceOf(address _owner) public view returns (uint256) {
100     return balances[_owner];
101   }
102 
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   function approve(address _spender, uint256 _value) public returns (bool) {
123     allowed[msg.sender][_spender] = _value;
124     emit Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   function allowance(
129     address _owner,
130     address _spender
131    )
132     public
133     view
134     returns (uint256)
135   {
136     return allowed[_owner][_spender];
137   }
138 
139   function increaseApproval(
140     address _spender,
141     uint256 _addedValue
142   )
143     public
144     returns (bool)
145   {
146     allowed[msg.sender][_spender] = (
147     allowed[msg.sender][_spender].add(_addedValue));
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval(
153     address _spender,
154     uint256 _subtractedValue
155   )
156     public
157     returns (bool)
158   {
159     uint256 oldValue = allowed[msg.sender][_spender];
160     if (_subtractedValue > oldValue) {
161       allowed[msg.sender][_spender] = 0;
162     } else {
163       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168   
169 
170   
171   string public constant name = "Torch Plan"; // solium-disable-line uppercase
172   string public constant symbol = "HHT"; // solium-disable-line uppercase
173   uint8 public constant decimals = 6; // solium-disable-line uppercase
174   
175   mapping(address => uint256) balances;
176   mapping (address => mapping (address => uint256)) internal allowed;
177   
178   uint256 public constant INITIAL_SUPPLY = 5600 * 10000 * (10 ** uint256(decimals));
179 
180 
181   constructor() public {
182     totalSupply_ = INITIAL_SUPPLY;
183     balances[msg.sender] = INITIAL_SUPPLY;
184     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
185   }
186 
187 }
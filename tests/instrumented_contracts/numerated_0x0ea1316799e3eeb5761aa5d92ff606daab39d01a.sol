1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a >= b ? a : b;
10   }
11 
12   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
13     return a < b ? a : b;
14   }
15 
16   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a >= b ? a : b;
18   }
19 
20   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
21     return a < b ? a : b;
22   }
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
37     // benefit is lost if 'b' is also tested.
38     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39     if (a == 0) {
40       return 0;
41     }
42 
43     c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 
77 
78 contract ETDM {
79 
80   using SafeMath for uint256;
81 
82 
83   uint256 totalSupply_;
84   event Transfer(address indexed from, address indexed to, uint256 value);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105   function transferFrom(
106     address _from,
107     address _to,
108     uint256 _value
109   )
110     public
111     returns (bool)
112   {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     emit Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   function allowance(
131     address _owner,
132     address _spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return allowed[_owner][_spender];
139   }
140 
141   function increaseApproval(
142     address _spender,
143     uint256 _addedValue
144   )
145     public
146     returns (bool)
147   {
148     allowed[msg.sender][_spender] = (
149     allowed[msg.sender][_spender].add(_addedValue));
150     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154   function decreaseApproval(
155     address _spender,
156     uint256 _subtractedValue
157   )
158     public
159     returns (bool)
160   {
161     uint256 oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170   
171 
172   
173   string public constant name = "ETDM"; // solium-disable-line uppercase
174   string public constant symbol = "ETDM"; // solium-disable-line uppercase
175   uint8 public constant decimals = 6; // solium-disable-line uppercase
176   
177   mapping(address => uint256) balances;
178   mapping (address => mapping (address => uint256)) internal allowed;
179   
180   uint256 public constant INITIAL_SUPPLY = 70 * 10000 * (10 ** uint256(decimals));
181 
182 
183   constructor() public {
184     totalSupply_ = INITIAL_SUPPLY;
185     balances[msg.sender] = INITIAL_SUPPLY;
186     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
187   }
188 
189 }
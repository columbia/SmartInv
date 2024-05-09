1 // File: contracts/SafeMath.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 // File: contracts/ERC20.sol
40 
41 pragma solidity ^0.4.18;
42 
43 
44 /**
45  * @title ERC20
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 {
49   uint256 public totalSupply;
50 
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56 
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 // File: contracts/LMToken.sol
62 
63 pragma solidity ^0.4.18;
64 
65 
66 
67 /**
68  * @title lm token
69  */
70 
71 contract LMToken is ERC20 {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75   mapping (address => mapping (address => uint256)) internal allowed;
76 
77   string public name = "ListeningMind Token";
78   string public symbol = "LMT";
79   uint256 public decimals = 18;
80 
81   function LMToken() public {
82     totalSupply = 7500000000 * (10 ** decimals);
83     balances[msg.sender] = totalSupply;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   event Transfer(address indexed from, address indexed to, uint256 value);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
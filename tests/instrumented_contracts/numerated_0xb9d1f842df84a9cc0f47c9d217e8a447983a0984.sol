1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     return false;
61   }
62 
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of.
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) public constant returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) constant returns (uint256);
77   function transferFrom(address from, address to, uint256 value);
78   function approve(address spender, uint256 value) returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) allowed;
87 
88   uint constant MAX_UINT = 2**256 - 1;
89 
90   /**
91    * @dev Transfer tokens from one address to another
92    * @param _from address The address which you want to send tokens from
93    * @param _to address The address which you want to transfer to
94    * @param _value uint256 the amount of tokens to be transferred
95    */
96   function transferFrom(address _from, address _to, uint256 _value) {
97     var _allowance = allowed[_from][msg.sender];
98 
99     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100     // if (_value > _allowance) throw;
101 
102     balances[_to] = balances[_to].add(_value);
103     balances[_from] = balances[_from].sub(_value);
104     if (_allowance < MAX_UINT) {
105       allowed[_from][msg.sender] = _allowance.sub(_value);
106     }
107     Transfer(_from, _to, _value);
108   }
109 
110   /**
111    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    * @param _spender The address which will spend the funds.
113    * @param _value The amount of tokens to be spent.
114    */
115   function approve(address _spender, uint256 _value) returns (bool) {
116 
117     // To change the approve amount you first have to reduce the addresses`
118     //  allowance to zero by calling `approve(_spender, 0)` if it is not
119     //  already 0 to mitigate the race condition described here:
120     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
122 
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Function to check the amount of tokens that an owner allowed to a spender.
130    * @param _owner address The address which owns the funds.
131    * @param _spender address The address which will spend the funds.
132    * @return A uint256 specifing the amount of tokens still avaible for the spender.
133    */
134   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135     return allowed[_owner][_spender];
136   }
137 
138 }
139 contract TestToken is StandardToken {
140 
141     /*
142     *  Token meta data
143     */
144     string constant public name = "Test Token";
145     string constant public symbol = "TEST";
146     uint8 constant public decimals = 18;
147     uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
148 
149     function TestToken() {
150         balances[0x5A2143B894C9E8d8DFe2A0e8B80d7DB2689fC382] = totalSupply;
151     }
152 }
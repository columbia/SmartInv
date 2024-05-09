1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    *
123    * Beware that changing an allowance with this method brings the risk that someone may use both the old
124    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * @dev Increase the amount of tokens that an owner allowed to a spender.
148    *
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    * @param _spender The address which will spend the funds.
154    * @param _addedValue The amount of tokens to increase the allowance by.
155    */
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   /**
163    * @dev Decrease the amount of tokens that an owner allowed to a spender.
164    *
165    * approve should be called when allowed[_spender] == 0. To decrement
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _subtractedValue The amount of tokens to decrease the allowance by.
171    */
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 contract BDC is StandardToken {
186     string public name = "Beyond Diamond Cryptocurrency";
187     string public symbol = "BDC";
188     uint8 public decimals = 18;
189     uint public INITIAL_SUPPLY = 10000000000 * (10**18);
190 
191     constructor() public {
192         totalSupply_ = INITIAL_SUPPLY;
193         balances[msg.sender] = INITIAL_SUPPLY;
194         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
195     }
196 }
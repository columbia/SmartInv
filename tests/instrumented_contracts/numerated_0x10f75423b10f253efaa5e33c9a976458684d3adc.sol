1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) public view returns (uint256);
9   function allowance(address _owner, address _spender) public view returns (uint256);
10   function transfer(address _to, uint256 _value) public returns (bool);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12   function approve(address _spender, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Standard ERC20 token
53  *
54  * @dev Implementation of the basic standard token.
55  * @dev https://github.com/ethereum/EIPs/issues/20
56  */
57 contract SolaToken is IERC20 {
58   using SafeMath for uint256;
59 
60   string public name = 'Sola';
61   string public symbol = 'SOLA';
62   uint8 public constant decimals = 18;
63   uint256 public constant decimalFactor = 10 ** uint256(decimals);
64   uint256 public constant totalSupply = 1000000000 * decimalFactor;
65   mapping (address => uint256) balances;
66   mapping (address => mapping (address => uint256)) internal allowed;
67 
68   event Transfer(address indexed from, address indexed to, uint256 value);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71   /**
72   * @dev Constructor for Sola creation
73   * @dev Assigns the totalSupply to the SolaDistribution contract
74   */
75   function SolaToken(address _solaDistributionContractAddress) public {
76     require(_solaDistributionContractAddress != address(0));
77     balances[_solaDistributionContractAddress] = totalSupply;
78     Transfer(address(0), _solaDistributionContractAddress, totalSupply);
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90   /**
91    * @dev Function to check the amount of tokens that an owner allowed to a spender.
92    * @param _owner address The address which owns the funds.
93    * @param _spender address The address which will spend the funds.
94    * @return A uint256 specifying the amount of tokens still available for the spender.
95    */
96   function allowance(address _owner, address _spender) public view returns (uint256) {
97     return allowed[_owner][_spender];
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     // SafeMath.sub will throw if there is not enough balance.
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To decrement
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _subtractedValue The amount of tokens to decrease the allowance by.
175    */
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
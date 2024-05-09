1 pragma solidity ^0.4.0;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) balances;
37 
38   /**
39   * @dev transfer token for a specified address
40   * @param _to The address to transfer to.
41   * @param _value The amount to be transferred.
42   */
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     // SafeMath.sub will throw if there is not enough balance.
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of.
57   * @return An uint256 representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) public constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Standard ERC20 token
77  *
78  * @dev Implementation of the basic standard token.
79  * @dev https://github.com/ethereum/EIPs/issues/20
80  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
81  */
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86 
87   /**
88    * @dev Transfer tokens from one address to another
89    * @param _from address The address which you want to send tokens from
90    * @param _to address The address which you want to transfer to
91    * @param _value uint256 the amount of tokens to be transferred
92    */
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[_from]);
96     require(_value <= allowed[_from][msg.sender]);
97 
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   /**
106    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107    *
108    * Beware that changing an allowance with this method brings the risk that someone may use both the old
109    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
110    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
111    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112    * @param _spender The address which will spend the funds.
113    * @param _value The amount of tokens to be spent.
114    */
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param _owner address The address which owns the funds.
124    * @param _spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
128     return allowed[_owner][_spender];
129   }
130 
131   /**
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * From MonolithDAO Token.sol
136    */
137   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 
154 }
155 
156 
157 
158 
159 /**
160  * @title SimpleToken
161  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
162  * Note they can later distribute these tokens as they wish using `transfer` and other
163  * `StandardToken` functions.
164  */
165 contract Coeval is StandardToken {
166 
167   string public constant name = "Coeval";
168   string public constant symbol = "COE";
169   uint8 public constant decimals = 18;
170 
171   uint256 public constant INITIAL_SUPPLY = 100000 * (10 ** uint256(decimals));
172 
173   /**
174    * @dev Constructor that gives msg.sender all of existing tokens.
175    */
176   function Coeval() {
177     totalSupply = INITIAL_SUPPLY;
178     balances[msg.sender] = INITIAL_SUPPLY;
179   }
180 
181 }
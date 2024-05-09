1 pragma solidity ^0.4.20;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function div(uint256 a, uint256 b) internal constant returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 /**
40  * @title Basic token
41  * @dev Basic version of StandardToken, with no allowances.
42  */
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45   mapping(address => uint256) balances;
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 }
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public constant returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 /**
79  * @title Standard ERC20 token
80  *
81  * @dev Implementation of the basic standard token.
82  * @dev https://github.com/ethereum/EIPs/issues/20
83  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84  */
85 contract StandardToken is ERC20, BasicToken {
86   mapping (address => mapping (address => uint256)) allowed;
87   /**
88    * @dev Transfer tokens from one address to another
89    * @param _from address The address which you want to send tokens from
90    * @param _to address The address which you want to transfer to
91    * @param _value uint256 the amount of tokens to be transferred
92    */
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     uint256 _allowance = allowed[_from][msg.sender];
96     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
97     // require (_value <= _allowance);
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = _allowance.sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    *
107    * Beware that changing an allowance with this method brings the risk that someone may use both the old
108    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114   function approve(address _spender, uint256 _value) public returns (bool) {
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117     return true;
118   }
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128   /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134   function increaseApproval (address _spender, uint _addedValue)
135     returns (bool success) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140   function decreaseApproval (address _spender, uint _subtractedValue)
141     returns (bool success) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 contract EtherLinkToken is StandardToken {
153 	string public name = "EtherLink Token";
154   string public symbol = "ETL";
155   uint256 public decimals = 18;
156   uint256 public constant INITIAL_SUPPLY = 5000000 * (10 ** uint256(decimals));
157   /**
158    * @dev Constructor that gives msg.sender all of existing tokens.
159    */
160   function EtherLinkToken() {
161     totalSupply = INITIAL_SUPPLY;
162     balances[msg.sender] = INITIAL_SUPPLY;
163   }
164 }
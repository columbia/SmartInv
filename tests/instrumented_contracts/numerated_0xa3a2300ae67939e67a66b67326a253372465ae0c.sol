1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 
42 /**
43  * @title Basic token
44  * @dev Basic version of StandardToken, with no allowances.
45  */
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
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
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev https://github.com/ethereum/EIPs/issues/20
92  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) internal allowed;
97 
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amount of tokens to be transferred
104    */
105   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[_from]);
108     require(_value <= allowed[_from][msg.sender]);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    *
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public view returns (uint256) {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    */
149   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 
169 contract Boombay is StandardToken {
170 
171   string public constant name = "Boombay";
172   string public constant symbol = "BOOM";
173   uint8 public constant decimals = 18;
174 
175   uint256 public constant INITIAL_SUPPLY = 90000000* (10 ** uint256(decimals));
176 
177   /**
178    * @dev Constructor that gives msg.sender all of existing tokens.
179    */
180   function Boombay () public {
181     totalSupply = INITIAL_SUPPLY;
182     balances[msg.sender] = INITIAL_SUPPLY;
183   }
184 
185 }
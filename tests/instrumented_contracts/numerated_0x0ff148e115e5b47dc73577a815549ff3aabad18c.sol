1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   
33   
34 }
35 
36 contract ERC20Basic {
37   uint256 public totalSupply;
38   function balanceOf(address who) public constant returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   /**
72   * @dev Gets the balance of the specified address.
73   * @param _owner The address to query the the balance of.
74   * @return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) public constant returns (uint256 balance) {
77     return balances[_owner];
78   }
79 
80 }
81 
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
156 contract SimpleToken is StandardToken {
157 
158   string public constant name = "VIPER";
159   string public constant symbol = "VPER";
160   uint8 public constant decimals = 3;
161 
162   uint256 public constant INITIAL_SUPPLY = 55000000 * (10 ** uint256(decimals));
163 
164   /**
165    * @dev Constructor that gives msg.sender all of existing tokens.
166    */
167   function SimpleToken() {
168     totalSupply = INITIAL_SUPPLY;
169     balances[msg.sender] = INITIAL_SUPPLY;
170   }
171 
172 }
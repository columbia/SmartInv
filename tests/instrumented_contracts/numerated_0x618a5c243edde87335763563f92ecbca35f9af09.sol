1 pragma solidity ^0.4.17;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
10   */
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   /**
17   * @dev Adds two numbers, throws on overflow.
18   */
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 /**
27  * @title ERC20Basic
28  * @dev Simpler version of ERC20 interface
29  * @dev see https://github.com/ethereum/EIPs/issues/179
30  */
31 contract ERC20Basic {
32   function totalSupply() public view returns (uint256);
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   uint256 totalSupply_;
60 
61   /**
62   * @dev total number of tokens in existence
63   */
64   function totalSupply() public view returns (uint256) {
65     return totalSupply_;
66   }
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74 	require(_to != address(0));
75     require(balances[msg.sender] >= _value);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114 
115     require(_to != address(0));
116     require(balances[_from] >= _value);
117 	require(allowed[_from][msg.sender] <= _value);
118     require(_value >= 0);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     emit Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     emit Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    *
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To decrement
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _subtractedValue The amount of tokens to decrease the allowance by.
178    */
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 contract WylSistContract is StandardToken{
193   string public name = "万业链";//name
194   string public symbol = "WYL";//symbol
195   uint8 public decimals = 18;//
196   uint256 public TOTAL_SUPPLY = 450000000*(1000000000000000000);//TOTAL_SUPPLY
197   uint256 public totalSupply;	
198   //init
199   function WylSistContract() public {
200     totalSupply = TOTAL_SUPPLY;
201     balances[msg.sender] = TOTAL_SUPPLY;
202   }
203 }
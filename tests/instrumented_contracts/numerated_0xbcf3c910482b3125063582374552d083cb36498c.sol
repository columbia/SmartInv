1 pragma solidity ^0.4.11;
2 
3 /**
4  * SafeMath Library
5  * Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * ERC20Basic Contract
35  * Simpler version of ERC20 interface
36  * Reference: https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * Basic Token Contract
47  * Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * Transfer token for a specified address
56   *
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   * @return bool
60   */
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * Gets the balance of the specified address.
70   *
71   * @param _owner The address to query the the balance of.
72   * @return uint256
73   */
74   function balanceOf(address _owner) public constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 }
78 
79 /**
80  * ERC20 Interface
81  * Reference: https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) public constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) public returns (bool);
86   function approve(address spender, uint256 value) public returns (bool);
87 
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * Standard ERC20 token
93  *
94  * Implementation of the basic standard token.
95  * Reference: https://github.com/ethereum/EIPs/issues/20
96  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * Transfer tokens from one address to another
104    *
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    * @return bool
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     var _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // require (_value <= _allowance);
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    * @return bool
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     // To change the approve amount you first have to reduce the addresses`
132     // allowance to zero by calling `approve(_spender, 0)` if it is not
133     // already 0 to mitigate the race condition described here:
134     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * Function to check the amount of tokens that an owner allowed to a spender.
144    *
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return uint256
148    */
149   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 /**
156  * Token Contract
157  *
158  * Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
159  * Note they can later distribute these tokens as they wish using `transfer` and other
160  * `StandardToken` functions.
161  */
162 contract Token is StandardToken {
163 
164   string public name;
165   string public symbol;
166   uint256 public initialSupply;
167   uint256 public decimals = 18;
168 
169   /**
170    * Contructor that gives msg.sender all of existing tokens.
171    */
172   function Token(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
173     totalSupply = _initialSupply * 10**18;
174     balances[msg.sender] = _initialSupply * 10**18;
175     initialSupply = _initialSupply * 10**18;
176 
177     name = _tokenName;
178     symbol = _tokenSymbol;
179   }
180 }
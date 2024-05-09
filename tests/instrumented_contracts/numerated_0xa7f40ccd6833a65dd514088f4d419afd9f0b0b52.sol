1 pragma solidity ^0.4.11;
2 /**
3  * Official BST Token smart contract (EBET) - https://ethbet.io/
4  * ICO website: https://ico.betstreak.io
5  * Betstreak website: https://betstreak.co
6  * Link from Betstreak website to ICO Betstreak: https://www.betstreak.co/ico 
7  */
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) constant returns (uint256);
49   function transfer(address to, uint256 value) returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) returns (bool) {
69     require(_to != address(0));
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) returns (bool);
97   function approve(address spender, uint256 value) returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
121     require(_to != address(0));
122 
123     var _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = _allowance.sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) returns (bool) {
141 
142     // To change the approve amount you first have to reduce the addresses`
143     //  allowance to zero by calling `approve(_spender, 0)` if it is not
144     //  already 0 to mitigate the race condition described here:
145     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 /**
191  * @title Betstreak Token
192  */
193 contract BetstreakToken is StandardToken {
194 
195   string public constant name = "BetstreakToken";
196   string public constant symbol = "BST";
197   uint8 public constant decimals = 2; // only two deciminals, token cannot be divided past 1/100th
198 
199   uint256 public constant INITIAL_SUPPLY = 20000000000; // 10 million + 2 decimals
200 
201   /**
202    * @dev Contructor that gives msg.sender all of existing tokens.
203    */
204    
205   function BetstreakToken() {
206     totalSupply = INITIAL_SUPPLY;
207     balances[msg.sender] = INITIAL_SUPPLY;
208   }
209 }
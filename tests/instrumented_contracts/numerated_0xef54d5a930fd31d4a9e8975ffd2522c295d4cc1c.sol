1 pragma solidity ^0.4.13;
2 /**
3  * This is the official RTC Token smart contract (RTC) - https://RTC.io/
4  */
5 
6 
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) constant returns (uint256);
48   function transfer(address to, uint256 value) returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) returns (bool) {
68     require(_to != address(0));
69 
70     // SafeMath.sub will throw if there is not enough balance.
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) returns (bool);
98   function approve(address spender, uint256 value) returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * @dev https://github.com/ethereum/EIPs/issues/20
108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) allowed;
113 
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
122     require(_to != address(0));
123 
124     var _allowance = allowed[_from][msg.sender];
125 
126     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
127     // require (_value <= _allowance);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = _allowance.sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) returns (bool) {
142 
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
148 
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * approve should be called when allowed[_spender] == 0. To increment
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    */
170   function increaseApproval (address _spender, uint _addedValue)
171     returns (bool success) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   function decreaseApproval (address _spender, uint _subtractedValue)
178     returns (bool success) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 /**
192  * @title RTCToken
193  */
194 contract RTCToken is StandardToken {
195 
196   string public constant name = "RTC";
197   string public constant symbol = "RTC";
198   uint8 public constant decimals = 18; // only two deciminals, token cannot be divided past 1/100th
199 
200   uint256 public constant INITIAL_SUPPLY = 50000000000000000000000000; // 50 million + 18 decimals
201 
202   /**
203    * @dev Contructor that gives msg.sender all of existing tokens.
204    */
205   function RTCToken() {
206     totalSupply = INITIAL_SUPPLY;
207     balances[msg.sender] = INITIAL_SUPPLY;
208   }
209 }
1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract ERC20Basic {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   uint256 totalSupply_;
66 
67   /**
68   * @dev total number of tokens in existence
69   */
70   function totalSupply() public view returns (uint256) {
71     return totalSupply_;
72   }
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[msg.sender]);
82 
83     // SafeMath.sub will throw if there is not enough balance.
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 }
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 contract SoundbitToken is StandardToken {
197 
198   string public constant name = "Soundbit Token"; // solium-disable-line uppercase
199   string public constant symbol = "SBT"; // solium-disable-line uppercase
200   uint8 public constant decimals = 18; // solium-disable-line uppercase
201 
202   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
203 
204   /**
205    * @dev Constructor that gives msg.sender all of existing tokens.
206    */
207   function SoundbitToken() public {
208     totalSupply_ = INITIAL_SUPPLY;
209     balances[msg.sender] = INITIAL_SUPPLY;
210     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
211   }
212 
213 }
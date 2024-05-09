1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 
120 
121 
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 
233 contract BitConroy is StandardToken {
234 
235   string public name = 'BitConroys';
236   string public symbol = 'CON';
237   uint8 public decimals = 2;
238   uint public INITIAL_SUPPLY = 1000000;
239 
240   function BitConroy() public {
241     totalSupply_ = INITIAL_SUPPLY;
242     balances[msg.sender] = INITIAL_SUPPLY;
243   }
244 }
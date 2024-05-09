1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 
20 /**
21  * @title Basic token
22  * @dev Basic version of StandardToken, with no allowances.
23  */
24 contract BasicToken is ERC20Basic {
25   using SafeMath for uint256;
26 
27   mapping(address => uint256) balances;
28 
29   uint256 totalSupply_;
30 
31   /**
32   * @dev total number of tokens in existence
33   */
34   function totalSupply() public view returns (uint256) {
35     return totalSupply_;
36   }
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
59   function balanceOf(address _owner) public view returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public view returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86   /**
87   * @dev Multiplies two numbers, throws on overflow.
88   */
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     if (a == 0) {
91       return 0;
92     }
93     uint256 c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   /**
99   * @dev Integer division of two numbers, truncating the quotient.
100   */
101   function div(uint256 a, uint256 b) internal pure returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106   }
107 
108   /**
109   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110   */
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   /**
117   * @dev Adds two numbers, throws on overflow.
118   */
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 contract HTB is StandardToken {
226   string public constant name    = "Hotbit Token";  //The Token's name
227   uint8 public constant decimals = 18;              //Number of decimals of the smallest unit
228   string public constant symbol  = "HTB";           //An identifier
229 
230   function HTB() public {
231     totalSupply_ = 25 * (10 ** 8 ) * (10 ** 18); // 2.5 billion HTB, decimals set to 18
232     balances[msg.sender] = totalSupply_;
233     Transfer(0, msg.sender, totalSupply_);
234   }
235 }
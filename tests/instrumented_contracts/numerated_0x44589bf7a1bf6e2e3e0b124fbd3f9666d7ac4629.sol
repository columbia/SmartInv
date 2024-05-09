1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, September 1, 2018
3  (UTC) */
4 
5 pragma solidity 0.4.24;
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38   function totalSupply() public view returns (uint256);
39 
40   function balanceOf(address _who) public view returns (uint256);
41 
42   function allowance(address _owner, address _spender)
43     public view returns (uint256);
44 
45   function transfer(address _to, uint256 _value) public returns (bool);
46 
47   function approve(address _spender, uint256 _value)
48     public returns (bool);
49 
50   function transferFrom(address _from, address _to, uint256 _value)
51     public returns (bool);
52 
53   event Transfer(
54     address indexed from,
55     address indexed to,
56     uint256 value
57   );
58 
59   event Approval(
60     address indexed owner,
61     address indexed spender,
62     uint256 value
63   );
64 }
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  * https://github.com/ethereum/EIPs/issues/20
71  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72  */
73 contract StandardToken is ERC20 {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public view returns (uint256) {
95     return balances[_owner];
96   }
97 
98   /**
99    * @dev Function to check the amount of tokens that an owner allowed to a spender.
100    * @param _owner address The address which owns the funds.
101    * @param _spender address The address which will spend the funds.
102    * @return A uint256 specifying the amount of tokens still available for the spender.
103    */
104   function allowance(
105     address _owner,
106     address _spender
107    )
108     public
109     view
110     returns (uint256)
111   {
112     return allowed[_owner][_spender];
113   }
114 
115   /**
116   * @dev Transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_value <= balances[msg.sender]);
122     require(_to != address(0));
123 
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     emit Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(
152     address _from,
153     address _to,
154     uint256 _value
155   )
156     public
157     returns (bool)
158   {
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161     require(_to != address(0));
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _addedValue The amount of tokens to increase the allowance by.
178    */
179   function increaseApproval(
180     address _spender,
181     uint256 _addedValue
182   )
183     public
184     returns (bool)
185   {
186     allowed[msg.sender][_spender] = (
187       allowed[msg.sender][_spender].add(_addedValue));
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(
202     address _spender,
203     uint256 _subtractedValue
204   )
205     public
206     returns (bool)
207   {
208     uint256 oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue >= oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 contract AmazeeElite is StandardToken { 
221   string public name="AmazeeElite";
222   string public symbol="AME";
223   uint8 public decimals=18;
224   uint256 public constant INITIAL_SUPPLY = 6000000000 * (10 ** uint256(decimals));
225 
226   /**
227    * @dev Constructor that gives msg.sender all of existing tokens.
228    */
229   constructor() public {
230     totalSupply_ = INITIAL_SUPPLY;
231     balances[msg.sender] = INITIAL_SUPPLY;
232     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
233   }
234 }
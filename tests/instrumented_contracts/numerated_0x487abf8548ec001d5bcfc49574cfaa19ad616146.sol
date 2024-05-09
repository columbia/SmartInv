1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
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
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     uint256 _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue)
157     returns (bool success) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval (address _spender, uint _subtractedValue)
164     returns (bool success) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 contract WTFToken is StandardToken {
178   using SafeMath for uint;
179 
180   /** owner of the contract */
181   address public owner;
182 
183   /** whether token sale has finished. 
184     * If finished, no more tokens can be ever issued. 
185     */
186   bool public isFinalized = false;
187 
188   /** whether purchasing is paused */
189   bool public isPurchasingPaused = true;
190 
191   /** how many token units a buyer gets per wei */
192   uint public rate = 1000;
193 
194   /** amount of raised money in wei */
195   uint public weiContributed = 0;
196 
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202   function name() public constant returns (string) { return "What The Fuck"; }
203   function symbol() public constant returns (string) { return "WTF"; }
204   function decimals() public constant returns (uint8) { return 18; }
205 
206   function WTFToken() {
207     owner = msg.sender;
208   }
209 
210   function () public payable {
211     buy(msg.sender);
212   }
213 
214   function buy(address _beneficiary) public payable {
215     require(!isFinalized);
216     require(!isPurchasingPaused);
217     require(msg.value != 0);
218 
219     uint weiEther = msg.value;
220 
221     uint weiTokens = weiEther.mul(rate);
222 
223     weiContributed = weiContributed.add(weiEther);
224 
225     issueInternal(_beneficiary, weiTokens);
226 
227     owner.transfer(msg.value);
228   }
229 
230   /**
231    * Allows to issue tokens for a specific address. Could be useful.
232    */
233   function issue(address _beneficiary, uint weiTokens) public onlyOwner {
234     issueInternal(_beneficiary, weiTokens);
235   }
236 
237   /**
238    * Issues the given number of wei-tokens in the favor of the given address.
239    */
240   function issueInternal(address _beneficiary, uint weiTokens) internal {
241     require(!isFinalized);
242 
243     totalSupply = totalSupply.add(weiTokens);
244     balances[_beneficiary] = balances[_beneficiary].add(weiTokens);
245     Transfer(0x0, _beneficiary, weiTokens);
246   }
247 
248   /**
249    * Sets the crowdsale as active or inactive.
250    */
251   function setPurchasingPaused(bool _value) public onlyOwner {
252     require(!isFinalized);
253     require(isPurchasingPaused != _value);
254     isPurchasingPaused = _value;
255   }
256 
257   /**
258    * Marks token sale as finished. No more tokens can be issued afterwards.
259    */
260   function finalize() public onlyOwner {
261     require(!isFinalized);
262     isFinalized = true;
263     isPurchasingPaused = false;
264   }
265 
266 }
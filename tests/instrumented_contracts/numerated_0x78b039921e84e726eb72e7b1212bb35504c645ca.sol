1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 library SafeMath {
44   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal constant returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public constant returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public constant returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public constant returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138 
139     uint256 _allowance = allowed[_from][msg.sender];
140 
141     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
142     // require (_value <= _allowance);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = _allowance.sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    */
183   function increaseApproval (address _spender, uint _addedValue)
184     returns (bool success) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   function decreaseApproval (address _spender, uint _subtractedValue)
191     returns (bool success) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 contract MintableToken is StandardToken, Ownable {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207 
208   bool public mintingFinished = false;
209 
210 
211   modifier canMint() {
212     require(!mintingFinished);
213     _;
214   }
215 
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
223     totalSupply = totalSupply.add(_amount);
224     balances[_to] = balances[_to].add(_amount);
225     Mint(_to, _amount);
226     Transfer(0x0, _to, _amount);
227     return true;
228   }
229 
230   /**
231    * @dev Function to stop minting new tokens.
232    * @return True if the operation was successful.
233    */
234   function finishMinting() onlyOwner public returns (bool) {
235     mintingFinished = true;
236     MintFinished();
237     return true;
238   }
239 }
240 
241 /**
242  * @title SetherToken
243  * @dev Sether ERC20 Token that can be minted.
244  * It is meant to be used in sether crowdsale contract.
245  */
246 contract SetherToken is MintableToken {
247 
248     string public constant name = "Sether";
249     string public constant symbol = "SETH";
250     uint8 public constant decimals = 18;
251 
252     function getTotalSupply() public returns (uint256) {
253         return totalSupply;
254     }
255 }
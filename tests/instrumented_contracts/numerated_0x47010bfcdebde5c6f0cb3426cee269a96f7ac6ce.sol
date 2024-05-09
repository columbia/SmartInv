1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address internal owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public returns (bool) {
33     require(newOwner != address(0x0));
34     emit OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36 
37     return true;
38   }
39 }
40 
41 library SafeMath {
42     /**
43     * @dev Multiplies two numbers, throws on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         if (a == 0) {
47             return 0;
48         }
49         c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two numbers, truncating the quotient.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         // uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return a / b;
62     }
63 
64     /**
65     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     /**
73     * @dev Adds two numbers, throws on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 contract StandardToken is ERC20, BasicToken {
128   mapping (address => mapping (address => uint256)) allowed;
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
147     emit Transfer(_from, _to, _value);
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
163     emit Approval(msg.sender, _spender, _value);
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
183   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
190     uint oldValue = allowed[msg.sender][_spender];
191     if (_subtractedValue > oldValue) {
192       allowed[msg.sender][_spender] = 0;
193     } else {
194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195     }
196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 }
200 
201 contract MintableToken is StandardToken, Ownable {
202   event Mint(address indexed to, uint256 amount);
203   event MintFinished();
204 
205   bool public mintingFinished = false;
206 
207   modifier canMint() {
208     require(!mintingFinished);
209     _;
210   }
211 
212   /**
213    * @dev Function to mint tokens
214    * @param _to The address that will receive the minted tokens.
215    * @param _amount The amount of tokens to mint.
216    * @return A boolean that indicates if the operation was successful.
217    */
218 
219   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
220     totalSupply = SafeMath.add(totalSupply, _amount);
221     balances[_to] = balances[_to].add(_amount);
222     emit Mint(_to, _amount);
223     emit Transfer(0x0, _to, _amount);
224     return true;
225   }
226 
227   /**
228    * @dev Function to stop minting new tokens.
229    * @return True if the operation was successful.
230    */
231 //  function finishMinting() onlyOwner public returns (bool) {
232 //    mintingFinished = true;
233 //    emit MintFinished();
234 //    return true;
235 //  }
236 
237   function burnTokens(uint256 _unsoldTokens) onlyOwner canMint public returns (bool) {
238     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
239   }
240 }
241 
242 contract CappedToken is MintableToken {
243   uint256 public cap;
244 
245   constructor(uint256 _cap) public {
246     require(_cap > 0);
247     cap = _cap;
248   }
249 
250   /**
251    * @dev Function to mint tokens
252    * @param _to The address that will receive the minted tokens.
253    * @param _amount The amount of tokens to mint.
254    * @return A boolean that indicates if the operation was successful.
255    */
256   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
257     require(totalSupply.add(_amount) <= cap);
258 
259     return super.mint(_to, _amount);
260   }
261 }
262 
263 contract BitNauticToken is CappedToken {
264   string public constant name = "BitNautic Token";
265   string public constant symbol = "BTNT";
266   uint8 public constant decimals = 18;
267 
268   uint256 public totalSupply = 0;
269 
270   constructor()
271   CappedToken(50000000 * 10 ** uint256(decimals)) public
272   {
273 
274   }
275 }
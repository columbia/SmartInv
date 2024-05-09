1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
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
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60 
61     // SafeMath.sub will throw if there is not enough balance.
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of.
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract StandardToken is ERC20, BasicToken {
87 
88   mapping (address => mapping (address => uint256)) internal allowed;
89 
90 
91   /**
92    * @dev Transfer tokens from one address to another
93    * @param _from address The address which you want to send tokens from
94    * @param _to address The address which you want to transfer to
95    * @param _value uint256 the amount of tokens to be transferred
96    */
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   /**
110    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111    *
112    * Beware that changing an allowance with this method brings the risk that someone may use both the old
113    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifying the amount of tokens still available for the spender.
130    */
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   /**
136    * @dev Increase the amount of tokens that an owner allowed to a spender.
137    *
138    * approve should be called when allowed[_spender] == 0. To increment
139    * allowed value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    * @param _spender The address which will spend the funds.
143    * @param _addedValue The amount of tokens to increase the allowance by.
144    */
145   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
146     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   /**
152    * @dev Decrease the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To decrement
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _subtractedValue The amount of tokens to decrease the allowance by.
160    */
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 contract MintableToken is StandardToken, Ownable {
175   event Mint(address indexed to, uint256 amount);
176   event MintFinished();
177 
178   bool public mintingFinished = false;
179 
180 
181   modifier canMint() {
182     require(!mintingFinished);
183     _;
184   }
185 
186   /**
187    * @dev Function to mint tokens
188    * @param _to The address that will receive the minted tokens.
189    * @param _amount The amount of tokens to mint.
190    * @return A boolean that indicates if the operation was successful.
191    */
192   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
193     totalSupply = totalSupply.add(_amount);
194     balances[_to] = balances[_to].add(_amount);
195     Mint(_to, _amount);
196     Transfer(address(0), _to, _amount);
197     return true;
198   }
199 
200   /**
201    * @dev Function to stop minting new tokens.
202    * @return True if the operation was successful.
203    */
204   function finishMinting() onlyOwner canMint public returns (bool) {
205     mintingFinished = true;
206     MintFinished();
207     return true;
208   }
209 }
210 
211 contract NucleusVisionCoreToken is MintableToken {
212   string public constant name = "NucleusVisionCore";
213   string public constant symbol = "nCore";
214   uint8 public constant decimals = 0;
215 
216   /**
217    * @dev totalSupply is not set as we don't know how many investors will get the core token
218    */
219   function NucleusVisionCoreToken() public {
220   }
221 
222   /**
223    * @dev Function to mint tokens
224    * @param recipients The list of addresses eligible to get a NucleusVisionCoreToken
225    */
226   function mintCoreToken(address[] recipients) onlyOwner public {
227     for( uint i = 0 ; i < recipients.length ; i++ ){
228       address recipient = recipients[i];
229       if(balances[recipient] == 0 ){
230         super.mint(recipient, 1);
231       }
232     }
233   }
234 
235   // nCore tokens are not transferrable
236   function transfer(address, uint) public returns (bool){ revert(); }
237   function transferFrom(address, address, uint) public returns (bool){ revert(); }
238   function approve(address, uint) public returns (bool){ revert(); }
239   function allowance(address, address) constant public returns (uint){ return 0; }
240 
241 }
242 
243 library SafeMath {
244   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245     if (a == 0) {
246       return 0;
247     }
248     uint256 c = a * b;
249     assert(c / a == b);
250     return c;
251   }
252 
253   function div(uint256 a, uint256 b) internal pure returns (uint256) {
254     // assert(b > 0); // Solidity automatically throws when dividing by 0
255     uint256 c = a / b;
256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257     return c;
258   }
259 
260   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   function add(uint256 a, uint256 b) internal pure returns (uint256) {
266     uint256 c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }
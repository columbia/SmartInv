1 pragma solidity ^0.4.11;
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title Standard + Mintable + Burnable ERC20 token
78  *
79  * @dev Implementation of the basic standard token with function of minting and burn
80  * @dev https://github.com/ethereum/EIPs/issues/20
81  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
82  */
83 contract StandardMintableBurnableToken is Ownable {
84   using SafeMath for uint256;
85   
86   mapping (address => mapping (address => uint256)) internal allowed;
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88   uint256 public totalSupply;
89 
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 
92 
93   /**
94    * @dev Transfer tokens from one address to another
95    * @param _from address The address which you want to send tokens from
96    * @param _to address The address which you want to transfer to
97    * @param _value uint256 the amount of tokens to be transferred
98    */
99   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[_from]);
102     require(_value <= allowed[_from][msg.sender]);
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    *
114    * Beware that changing an allowance with this method brings the risk that someone may use both the old
115    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Function to check the amount of tokens that an owner allowed to a spender.
129    * @param _owner address The address which owns the funds.
130    * @param _spender address The address which will spend the funds.
131    * @return A uint256 specifying the amount of tokens still available for the spender.
132    */
133   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
134     return allowed[_owner][_spender];
135   }
136 
137   /**
138    * approve should be called when allowed[_spender] == 0. To increment
139    * allowed value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    */
143   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
144     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
150     uint oldValue = allowed[msg.sender][_spender];
151     if (_subtractedValue > oldValue) {
152       allowed[msg.sender][_spender] = 0;
153     } else {
154       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155     }
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160     mapping(address => uint256) balances;
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170 
171     // SafeMath.sub will throw if there is not enough balance.
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178 
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public constant returns (uint256 balance) {
186     return balances[_owner];
187   }
188 
189 
190 // MINATABLE PART
191 
192   event Mint(address indexed to, uint256 amount);
193   event MintFinished();
194   
195   bool public mintingFinished = false;
196 
197 
198   modifier canMint() {
199     require(!mintingFinished);
200     _;
201   }
202 
203   /**
204    * @dev Function to mint tokens
205    * @param _to The address that will receive the minted tokens.
206    * @param _amount The amount of tokens to mint.
207    * @return A boolean that indicates if the operation was successful.
208    */
209   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
210     totalSupply = totalSupply.add(_amount);
211     balances[_to] = balances[_to].add(_amount);
212     Mint(_to, _amount);
213     Transfer(0x0, _to, _amount);
214     return true;
215   }
216 
217   /**
218    * @dev Function to stop minting new tokens.
219    * @return True if the operation was successful.
220    */
221   function finishMinting() onlyOwner public returns (bool) {
222     mintingFinished = true;
223     MintFinished();
224     return true;
225   }
226 
227 
228 // BURNABLE PART
229 
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     /**
234      * @dev Burns a specific amount of tokens.
235      * @param _value The amount of token to be burned.
236      */
237     function burn(uint256 _value) public {
238         require(_value > 0);
239         require(_value <= balances[msg.sender]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         address burner = msg.sender;
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         Burn(burner, _value);
247     }
248 
249 }
250 
251 
252 /**
253  * @title MAS token
254  * Based on code by OpenZeppelen which is based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 
257 contract MasToken is StandardMintableBurnableToken {
258 
259   string public name = "Mainasset Token";
260   string public symbol = "MAS";
261   uint public decimals = 18;
262 
263 }
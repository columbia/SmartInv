1 pragma solidity 0.4.19;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
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
32 /**
33  * @title ERC20Basic
34  * @dev Simpler version of ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/179
36  */
37 contract ERC20Basic {
38   uint256 public totalSupply;
39   function balanceOf(address who) public constant returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 /**
45  * @title Basic token
46  * @dev Basic version of StandardToken, with no allowances.
47  */
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
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
100   mapping (address => mapping (address => uint256)) internal allowed;
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
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = balances[_from].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    *
124    * Beware that changing an allowance with this method brings the risk that someone may use both the old
125    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) public returns (bool) {
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147   /**
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    */
153   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
160     uint oldValue = allowed[msg.sender][_spender];
161     if (_subtractedValue > oldValue) {
162       allowed[msg.sender][_spender] = 0;
163     } else {
164       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165     }
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170 }
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179 
180   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182 
183   /**
184    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185    * account.
186    */
187   function Ownable() {
188     owner = msg.sender;
189   }
190 
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200 
201   /**
202    * @dev Allows the current owner to transfer control of the contract to a newOwner.
203    * @param newOwner The address to transfer ownership to.
204    */
205   function transferOwnership(address newOwner) onlyOwner public {
206     require(newOwner != address(0));
207     OwnershipTransferred(owner, newOwner);
208     owner = newOwner;
209   }
210 
211 }
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221   event Mint(address indexed to, uint256 amount);
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225 
226 
227   modifier canMint() {
228     require(!mintingFinished);
229     _;
230   }
231 
232   /**
233    * @dev Function to mint tokens
234    * @param _to The address that will receive the minted tokens.
235    * @param _amount The amount of tokens to mint.
236    * @return A boolean that indicates if the operation was successful.
237    */
238   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     Mint(_to, _amount);
242     Transfer(address(0), _to, _amount);
243     return true;
244   }
245 
246   /**
247    * @dev Function to stop minting new tokens.
248    * @return True if the operation was successful.
249    */
250   function finishMinting() onlyOwner canMint public returns (bool) {
251     mintingFinished = true;
252     MintFinished();
253     return true;
254   }
255 }
256 
257 contract RocketToken is MintableToken {
258     string public name = "ICO ROCKET";
259     string public symbol = "ROCKET";
260     uint256 public decimals = 18;
261 }
1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal constant returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal constant returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is ERC20Basic {
105   using SafeMath for uint256;
106 
107   mapping(address => uint256) balances;
108 
109   /**
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public constant returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
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
189   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
206     uint256 oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   address public saleAgent;
231 
232   bool public mintingFinished = false;
233 
234 
235   modifier canMint() {
236     require(!mintingFinished);
237     _;
238   }
239 
240   function setSaleAgent(address newSaleAgent) public {
241     require(msg.sender == saleAgent || msg.sender == owner);
242     saleAgent = newSaleAgent;
243   }
244 
245   /**
246    * @dev Function to mint tokens
247    * @param _to The address that will receive the minted tokens.
248    * @param _amount The amount of tokens to mint.
249    * @return A boolean that indicates if the operation was successful.
250    */
251   //function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
252   function mint(address _to, uint256 _amount) canMint public returns (bool) {    
253     require(msg.sender == saleAgent || msg.sender == owner);
254     totalSupply = totalSupply.add(_amount);
255     balances[_to] = balances[_to].add(_amount);
256     Mint(_to, _amount);
257     Transfer(address(0), _to, _amount);
258     return true;
259   }
260 
261   /**
262    * @dev Function to stop minting new tokens.
263    * @return True if the operation was successful.
264    */
265   function finishMinting() canMint public returns (bool) {
266     require(msg.sender == saleAgent || msg.sender == owner);
267     mintingFinished = true;
268     MintFinished();
269     return true;
270   }
271 }
272 
273 
274 contract ATFToken is MintableToken {	
275     
276     string public constant name = "AlgoTradingFun";
277    
278     string public constant symbol = "ATF";
279     
280     uint32 public constant decimals = 18;
281 
282     mapping (address => uint256) public locked;
283 
284     bool public transfersEnabled = false;
285 
286     event Burn(address indexed burner, uint256 value);
287 
288     function transfer(address _to, uint256 _value) public returns (bool) {
289       require(locked[msg.sender] < now);
290       require(transfersEnabled);
291       return super.transfer(_to, _value);
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
295       require(locked[_from] < now);
296       require(transfersEnabled);      
297       return super.transferFrom(_from, _to, _value);
298     }
299   
300     /**
301      * @dev Function that enables/disables transfers of token.
302      * @return True if the operation was successful.
303      */
304     function enableTransfers(bool _value) external onlyOwner {
305         transfersEnabled = _value;
306     }
307     
308     function lock(address addr, uint256 periodInDays) public {
309       require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
310       locked[addr] = now + periodInDays * 1 days;
311     }
312 
313     /**
314      * @dev Burns a specific amount of tokens.
315      * @param _value The amount of token to be burned.
316      */
317     function burn(uint256 _value) public {
318         require(_value > 0);
319         require(_value <= balances[msg.sender]);
320 
321         // no need to require value <= totalSupply, since that would imply the
322         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
323 
324         address burner = msg.sender;
325         balances[burner] = balances[burner].sub(_value);
326         totalSupply = totalSupply.sub(_value);
327         Burn(burner, _value);
328     }
329 
330     function () payable {
331       revert();
332     }
333 
334 }
1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14  
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25  
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36  
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43  
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a); 
46     return a - b; 
47   } 
48   
49   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
50     uint256 c = a + b; assert(c >= a);
51     return c;
52   }
53  
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
72     require(_value <= balances[msg.sender]); 
73     // SafeMath.sub will throw if there is not enough balance. 
74     balances[msg.sender] = balances[msg.sender].sub(_value); 
75     balances[_to] = balances[_to].add(_value); 
76     emit Transfer(msg.sender, _to, _value); 
77     return true; 
78   } 
79  
80   /** 
81    * @dev Gets the balance of the specified address. 
82    * @param _owner The address to query the the balance of. 
83    * @return An uint256 representing the amount owned by the passed address. 
84    */ 
85   function balanceOf(address _owner) public view returns (uint256 balance) { 
86     return balances[_owner]; 
87   } 
88 } 
89  
90 /** 
91  * @title Standard ERC20 token 
92  * 
93  * @dev Implementation of the basic standard token. 
94  * @dev https://github.com/ethereum/EIPs/issues/20 
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
96  */ 
97 contract StandardToken is ERC20, BasicToken {
98  
99   mapping (address => mapping (address => uint256)) internal allowed;
100  
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]); 
111     balances[_from] = balances[_from].sub(_value); 
112     balances[_to] = balances[_to].add(_value); 
113     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
114     emit Transfer(_from, _to, _value); 
115     return true; 
116   } 
117  
118  /** 
119   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
120   * 
121   * Beware that changing an allowance with this method brings the risk that someone may use both the old 
122   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
123   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
124   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
125   * @param _spender The address which will spend the funds. 
126   * @param _value The amount of tokens to be spent. 
127   */ 
128   function approve(address _spender, uint256 _value) public returns (bool) { 
129     allowed[msg.sender][_spender] = _value; 
130     emit Approval(msg.sender, _spender, _value); 
131     return true; 
132   }
133  
134  /** 
135   * @dev Function to check the amount of tokens that an owner allowed to a spender. 
136   * @param _owner address The address which owns the funds. 
137   * @param _spender address The address which will spend the funds. 
138   * @return A uint256 specifying the amount of tokens still available for the spender. 
139   */ 
140   function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
141     return allowed[_owner][_spender]; 
142   } 
143  
144  /** 
145   * approve should be called when allowed[_spender] == 0. To increment 
146   * allowed value is better to use this function to avoid 2 calls (and wait until 
147   * the first transaction is mined) * From MonolithDAO Token.sol 
148   */ 
149   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
152     return true; 
153   }
154  
155   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
156     uint oldValue = allowed[msg.sender][_spender]; 
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165  
166    function () external  payable {
167     revert();
168   }
169  
170 }
171  
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address public owner;
179  
180  
181   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182  
183  
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   constructor() public {
189     owner = msg.sender;
190   }
191  
192  
193   /**
194    * @dev Throws if called by any account other than the owner.
195    */
196   modifier onlyOwner() {
197     require(msg.sender == owner);
198     _;
199   }
200  
201  
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) onlyOwner public {
207     require(newOwner != address(0));
208     emit OwnershipTransferred(owner, newOwner);
209     owner = newOwner;
210   }
211  
212 }
213  
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220  
221 contract MintableToken is StandardToken, Ownable {
222     
223   event Mint(address indexed to, uint256 amount);
224   
225   event MintFinished();
226  
227   bool public mintingFinished = false;
228  
229   address public saleAgent;
230  
231   function setSaleAgent(address newSaleAgnet) public {
232     require(msg.sender == saleAgent || msg.sender == owner);
233     saleAgent = newSaleAgnet;
234   }
235  
236   function mint(address _to, uint256 _amount) public returns (bool) {
237     require(msg.sender == saleAgent && !mintingFinished);
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     emit Mint(_to, _amount);
241     return true;
242   }
243  
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() public returns (bool) {
249     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
250     mintingFinished = true;
251     emit MintFinished();
252     return true;
253   }
254  
255   
256 }
257 
258 
259 contract ERC20Wallet is Ownable {
260 
261     event WalletEvent ( 
262         address addr,
263         string action,
264         uint256 amount
265     );
266 
267     StandardToken token;
268 
269     constructor (StandardToken _token, address _owner) public {
270         owner = _owner;
271         token = _token;
272     }
273 
274     function sweepWallet() public {
275         uint256 amount = token.balanceOf(address(this));
276         token.transfer(owner, amount);
277     }
278     
279     function () external  payable {
280     revert();
281   }
282 }
283 
284 contract MegaWallet is Ownable {
285 
286     address[] public wallets;
287     mapping(address => address) associations;
288     mapping(address => address) revertassociations;
289 
290     event WalletEvent ( 
291         address addr,
292         string action,
293         uint256 amount
294     );
295     
296     constructor() public {
297         owner = msg.sender;
298     }
299 
300     function createWallet(address payable _token, address PFA) public {
301         ERC20Wallet wallet = new ERC20Wallet(StandardToken(_token), owner);
302         wallets.push(address(wallet));
303         associations[address(wallet)] = PFA;
304         revertassociations[PFA] = address(wallet);
305         emit WalletEvent(address(wallet), "Create", 0);
306     }
307 
308     function getWallets() public view returns (  address[] memory){
309         return wallets;
310     }
311     
312     function ETHWalletToPFAWallet(address ETH) public view returns (  address){
313         return associations[ETH] ;
314     }
315     
316     function PFAWalletToETHWallet(address PFA) public view returns (  address){
317         return revertassociations[PFA] ;
318     }
319     
320     
321     function () external  payable {
322     revert();
323   }
324 }
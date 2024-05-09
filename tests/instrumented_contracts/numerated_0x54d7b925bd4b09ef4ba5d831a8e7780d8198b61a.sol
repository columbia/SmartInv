1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83     /// Total amount of tokens
84   uint256 public totalSupply;
85   
86   function balanceOf(address _owner) public view returns (uint256 balance);
87   
88   function transfer(address _to, uint256 _amount) public returns (bool success);
89   
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99   
100   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
101   
102   function approve(address _spender, uint256 _amount) public returns (bool success);
103   
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   //balance in each address account
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _amount The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _amount) public returns (bool success) {
123     require(_to != address(0));
124     require(balances[msg.sender] >= _amount && _amount > 0
125         && balances[_to].add(_amount) > balances[_to]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_amount);
129     balances[_to] = balances[_to].add(_amount);
130     emit Transfer(msg.sender, _to, _amount);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  */
151 contract StandardToken is ERC20, BasicToken {
152   
153   
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _amount uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
164     require(_to != address(0));
165     require(balances[_from] >= _amount);
166     require(allowed[_from][msg.sender] >= _amount);
167     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
168 
169     balances[_from] = balances[_from].sub(_amount);
170     balances[_to] = balances[_to].add(_amount);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
172     emit Transfer(_from, _to, _amount);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _amount The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _amount) public returns (bool success) {
187     allowed[msg.sender][_spender] = _amount;
188     emit Approval(msg.sender, _spender, _amount);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202 }
203 
204 
205 /**
206  * @title Mintable token
207  * @dev Simple ERC20 Token example, with mintable token creation
208  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
209  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
210  */
211 contract MintableToken is StandardToken, Ownable {
212   event Mint(address indexed to, uint256 amount);
213   event MintFinished();
214 
215   bool public mintingFinished = false;
216 
217   //To keep track of minted token count
218   uint256 mintedTokens;
219 
220 
221   modifier canMint() {
222     require(!mintingFinished);
223     _;
224   }
225 
226   /**
227    * @dev Function to mint tokens
228    * Total miniting cannot be greater than 15% of initial total supply
229    * @param _to The address that will receive the minted tokens.
230    * @param _amount The amount of tokens to mint.
231    * @return A boolean that indicates if the operation was successful.
232    */
233   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
234     
235     uint256 initialTotalSupply = totalSupply.sub(mintedTokens);
236     
237     //To check miniting of tokens should not exceed 30% of initialTotalSupply
238     require(initialTotalSupply.mul(30).div(100) > mintedTokens.add(_amount));    
239    
240     totalSupply = totalSupply.add(_amount);
241     
242     balances[_to] = balances[_to].add(_amount);
243     emit Mint(_to, _amount);
244     emit Transfer(address(0), _to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner canMint public returns (bool) {
253     mintingFinished = true;
254     emit MintFinished();
255     return true;
256   }
257 }
258 
259 /**
260  * @title MOOH Token
261  * @dev Token representing MOOH.
262  */
263  contract MOOHToken is MintableToken {
264      string public name ;
265      string public symbol ;
266      uint8 public decimals = 18 ;
267      
268      /**
269      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
270      */
271      function ()public payable {
272          revert();
273      }
274      
275      /**
276      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
277      * @param initialSupply The initial supply of tokens which will be fixed through out
278      * @param tokenName The name of the token
279      * @param tokenSymbol The symboll of the token
280      */
281      constructor(
282             uint256 initialSupply,
283             string tokenName,
284             string tokenSymbol
285          ) public {
286          totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
287          name = tokenName;
288          symbol = tokenSymbol;
289          balances[msg.sender] = totalSupply;
290          
291          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
292          emit Transfer(address(0), msg.sender, totalSupply);
293      }
294      
295      /**
296      *@dev helper method to get token details, name, symbol and totalSupply in one go
297      */
298     function getTokenDetail() public view returns (string, string, uint256) {
299 	    return (name, symbol, totalSupply);
300     }
301  }
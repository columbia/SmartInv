1 pragma solidity 0.4.24;
2 /**
3  * Math operations with safety checks
4  * By OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/contracts/SafeMath.sol
5  */
6 library SafeMath {
7   
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51 }
52 
53 
54  contract ContractReceiver{
55     function tokenFallback(address _from, uint256 _value, bytes  _data) external;
56 }
57 
58 
59 //Basic ERC23 token, backward compatible with ERC20 transfer function.
60 //Based in part on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
61 contract ERC23BasicToken  {
62     using SafeMath for uint256;
63     uint256 public totalSupply;
64     mapping(address => uint256) balances;
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
67 
68     function tokenFallback(address _from, uint256 _value, bytes  _data) external {
69         throw;
70     }
71 
72     function transfer(address _to, uint256 _value, bytes _data) returns  (bool success) {
73         require(_to != address(0));
74         //Standard ERC23 transfer function
75 
76         if(isContract(_to)) {
77             transferToContract(_to, _value, _data);
78         }
79         else {
80             transferToAddress(_to, _value, _data);
81         }
82         return true;
83     }
84 
85     function transfer(address _to, uint256 _value) {
86         require(_to != address(0));
87         //standard function transfer similar to ERC20 transfer with no _data
88         //added due to backwards compatibility reasons
89 
90         bytes memory empty;
91         if(isContract(_to)) {
92             transferToContract(_to, _value, empty);
93         }
94         else {
95             transferToAddress(_to, _value, empty);
96         }
97     }
98 
99     function transferToAddress(address _to, uint256 _value, bytes _data) internal {
100         require(_to != address(0));
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104         emit Transfer(msg.sender, _to, _value, _data);
105     }
106 
107     function transferToContract(address _to, uint256 _value, bytes _data) internal {
108         require(_to != address(0));
109         balances[msg.sender] = balances[msg.sender].sub( _value);
110         balances[_to] = balances[_to].add( _value);
111         ContractReceiver receiver = ContractReceiver(_to);
112         receiver.tokenFallback(msg.sender, _value, _data);
113         emit Transfer(msg.sender, _to, _value);
114         emit Transfer(msg.sender, _to, _value, _data);
115     }
116 
117     function balanceOf(address _owner) constant returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
122     function isContract(address _addr) returns (bool is_contract) {
123           uint256 length;
124           assembly {
125               //retrieve the size of the code on target address, this needs assembly
126               length := extcodesize(_addr)
127           }
128           if(length>0) {
129               return true;
130           }
131           else {
132               return false;
133           }
134     }
135 }
136 
137 
138  // Standard ERC23 token, backward compatible with ERC20 standards.
139  // Based on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
140 contract ERC23StandardToken is ERC23BasicToken {
141     mapping (address => mapping (address => uint256)) allowed;
142     event Approval (address indexed owner, address indexed spender, uint256 value);
143 
144     function transferFrom(address _from, address _to, uint256 _value) {
145     require (_value > 0);
146     require(_to != address(0));
147     require(_from != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     }
155 
156     function approve(address _spender, uint256 _value) {
157 
158         // To change the approve amount you first have to reduce the addresses`
159         //  allowance to zero by calling `approve(_spender, 0)` if it is not
160         //  already 0 to mitigate the race condition described here:
161         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162         require (_value > 0);
163         require(_spender != address(0));
164         allowed[msg.sender][_spender] = _value;
165         emit Approval(msg.sender, _spender, _value);
166     }
167 
168     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172 }
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180   address public admin;
181   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182   /**
183    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Ownable() public {
187     owner = msg.sender;
188     admin=owner;
189   }
190   /**
191    * @dev Throws if called by any account other than the owner.
192    */
193   modifier onlyOwner() {
194     require(msg.sender == owner || msg.sender==admin);
195     _;
196   }
197   /**
198    * @dev Allows the current owner to transfer control of the contract to a newOwner.
199    * @param newOwner The address to transfer ownership to.
200    */
201   function transferOwnership(address newOwner) onlyOwner public {
202     require(newOwner != address(0));
203     emit OwnershipTransferred(owner, newOwner);
204     owner = newOwner;
205   }
206   
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newAdmin.
209    * @param newAdmin The address to transfer admin to.
210    */
211   function transferAdmin(address newAdmin) onlyOwner public {
212     require(newAdmin != address(0));
213     emit OwnershipTransferred(admin, newAdmin);
214     admin = newAdmin;
215   }
216   
217 }
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 contract MintableToken is ERC23StandardToken,Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228   bool public mintingFinished = false;
229   modifier canMint() {
230     require(!mintingFinished);
231     _;
232   }
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will receive the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
240     require(_amount>0);
241     require(_to != address(0));
242 
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     emit Mint(_to, _amount);
246     emit Transfer(0x0, _to, _amount);
247     return true;
248   }
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner public returns (bool) {
254     mintingFinished = true;
255     emit MintFinished();
256     return true;
257   }
258 }
259 
260 
261 contract ANSAToken is MintableToken { 
262   string public name="ANSA TOKEN";
263   string public symbol="ANSA";
264   uint8 public decimals=18;
265   uint256 public tradeStartTime;
266 
267   function tradeStarttime(uint256 _startTime)public onlyOwner{
268        tradeStartTime=_startTime.add(1 years);
269    }
270    
271    function hasTrade() public view returns (bool) {
272     // solium-disable-next-line security/no-block-members
273     return block.timestamp>tradeStartTime;
274   }
275    function transfer(address _to,uint256 _value) public{
276        require(hasTrade());
277        require(_to != address(0));
278 
279         //standard function transfer similar to ERC20 transfer with no _data
280         //added due to backwards compatibility reasons
281 
282         bytes memory empty;
283         if(isContract(_to)) {
284              transferToContract(_to, _value, empty);
285         }
286         else {
287             transferToAddress(_to, _value, empty);
288         }
289     }
290     
291      function transfer(address _to, uint256 _value, bytes _data)public  returns (bool success)  {
292         require(hasTrade());
293         //Standard ERC23 transfer function
294         require(_to != address(0));
295 
296         if(isContract(_to)) {
297             transferToContract(_to, _value, _data);
298         }
299         else {
300             transferToAddress(_to, _value, _data);
301         }
302         return true;
303     }
304  
305  function transferFrom(address _from, address _to, uint256 _value) {
306     require(hasTrade());
307     require (_value > 0);
308     require(_to != address(0));
309     require(_from != address(0));
310     require(_value <= balances[_from]);
311     require(_value <= allowed[_from][msg.sender]);
312     balances[_from] = balances[_from].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315     emit Transfer(_from, _to, _value);
316     }
317 }
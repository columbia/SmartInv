1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9   
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     Unpause();
110   }
111 }
112 /**
113  * @title Destructible
114  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
115  */
116 contract Destructible is Ownable {
117 
118   function Destructible() public payable { }
119 
120   /**
121    * @dev Transfers the current balance to the owner and terminates the contract.
122    */
123   function destroy() onlyOwner public {
124     selfdestruct(owner);
125   }
126 
127   function destroyAndSend(address _recipient) onlyOwner public {
128     selfdestruct(_recipient);
129   }
130 }
131 
132 /**
133  * @title ERC20Basic
134  * @dev Simpler version of ERC20 interface
135  */
136 contract ERC20Basic {
137   uint256 public totalSupply;
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic, Pausable {
147   using SafeMath for uint256;
148   address companyReserve;
149   address marketingReserve;
150   address advisorReserve;
151   mapping(address => uint256) balances;
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public   returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[msg.sender]);
160     // SafeMath.sub will throw if there is not enough balance.
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167  
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public constant returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194   
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    */
245   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 
265 contract AMICoin is StandardToken, Destructible {
266     string public constant name = "USAGE TOKEN";
267     uint public constant decimals = 18;
268     string public constant symbol = "AMI";
269      using SafeMath for uint256;
270      event BuyAMI(address indexed from,string userid,uint256 value);
271      address depositWalletAddress;
272      uint256 public weiRaised =0;
273     function AMICoin()  public {
274        totalSupply = 50000000 * (10**decimals);  
275        owner = msg.sender;
276        depositWalletAddress = 0x6f0EA2d0bd5312ab56e1d4108360e557bb38425f; //TODO change with your multiseg or any account address where you want to receive balance
277        companyReserve = 0x899004f864AAcd954A252A7E9D3d70d4594d4851;
278        marketingReserve = 0x955eD316F49878EeE10A3dEBaD4E5Ab72A3F8624;
279        advisorReserve = 0x4bfd13D8BCFBA3288043654053Ae13C752d193Eb;
280        balances[msg.sender] += 40000000 * (10 ** decimals);
281        balances[companyReserve] += 7500000 * (10 ** decimals);
282        balances[marketingReserve] += 1500000 * (10 ** decimals);
283        balances[advisorReserve] +=   1000000  * (10 ** decimals);
284        Transfer(msg.sender,msg.sender, balances[msg.sender]);
285        Transfer(msg.sender,companyReserve, balances[companyReserve]);
286        Transfer(msg.sender,marketingReserve, balances[marketingReserve]);
287        Transfer(msg.sender,advisorReserve, balances[advisorReserve]);
288     }
289 
290     function()  public {
291      revert();
292     }
293     
294     function buyAMI(string userId) public payable{
295         require(msg.sender !=0);
296         require(msg.value>0);
297         forwardFunds();
298          weiRaised+=msg.value;
299         BuyAMI(msg.sender,userId,msg.value);
300     }
301    
302          // send ether to the fund collection wallet
303   // override to create custom fund forwarding mechanisms
304   function forwardFunds() internal {
305      require(depositWalletAddress!=0);
306     depositWalletAddress.transfer(msg.value);
307   }
308   function changeDepositWalletAddress (address newDepositWalletAddr) public onlyOwner {
309        require(newDepositWalletAddr!=0);
310        depositWalletAddress = newDepositWalletAddr;
311   }
312   
313   
314     
315   
316 }
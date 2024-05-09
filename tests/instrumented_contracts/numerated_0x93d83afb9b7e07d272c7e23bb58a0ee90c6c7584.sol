1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic  {
4     function totalSupply()public view returns(uint256);
5     function balanceOf(address who)public view returns(uint256);
6     function transfer(address to, uint256 value)public returns(bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     emit Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender)public view returns(uint256);
52 
53     function transferFrom(address from, address to, uint256 value)public returns(
54         bool
55     );
56 
57     function approve(address spender, uint256 value)public returns(bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract Ownable {
62     address public owner;
63 
64     event OwnershipRenounced(address indexed previousOwner);
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     /**
71    * @dev Throws if called by any account other than the owner.
72    */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82     function transferOwnership(address newOwner)public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88     /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    */
91     function renounceOwnership()public onlyOwner {
92         emit OwnershipRenounced(owner);
93         owner = address(0);
94     }
95 }
96 
97 library SafeMath {
98 
99     /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102     function mul(uint256 a, uint256 b)internal pure returns(uint256 c) {
103         if (a == 0) {
104             return 0;
105         }
106         c = a * b;
107         assert(c / a == b);
108         return c;
109     }
110 
111     /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114     function div(uint256 a, uint256 b)internal pure returns(uint256) {
115         return a / b;
116     }
117 
118     /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121     function sub(uint256 a, uint256 b)internal pure returns(uint256) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129     function add(uint256 a, uint256 b)internal pure returns(uint256 c) {
130         c = a + b;
131         assert(c >= a);
132         return c;
133     }
134 }
135 
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(
210     address _spender,
211     uint _addedValue
212   )
213     public
214     returns (bool)
215   {
216     allowed[msg.sender][_spender] = (
217       allowed[msg.sender][_spender].add(_addedValue));
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(
233     address _spender,
234     uint _subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 contract nix is Ownable, StandardToken {
252 
253 
254     string public constant symbol =  "NIX";
255     string public constantname =  "NIX";
256     uint256 public constant decimals = 18;
257     
258     uint256 reserveTokensLockTime;
259     address reserveTokenAddress;
260 
261 
262     address public depositWalletAddress;
263     uint256 public weiRaised;
264     using SafeMath for uint256;
265     
266     constructor() public {
267         owner = msg.sender;
268         depositWalletAddress = owner;
269         totalSupply_ = 500000000 ether; // as ether is only because we need to multiply tokens with 10** decimals and dicmals is 18
270         balances[owner] = 150000000 ether;
271         emit Transfer(address(0),owner, balances[owner]);
272 
273         reserveTokensLockTime = 182 days; //year lock time
274         reserveTokenAddress = 0xf6c5dE9E1a6b36ABA36c6E6e86d500BcBA9CeC96; //TODO change address before deploy
275         balances[reserveTokenAddress] = 350000000 ether;
276         emit Transfer(address(0),reserveTokenAddress, balances[reserveTokenAddress]);
277     }
278 
279 
280     //This buy event is used only for ico duration 
281     event Buy(address _from, uint256 _ethInWei, string userId);
282     function buy(string userId)public payable {
283         require(msg.value > 0);
284         require(msg.sender != address(0));
285         weiRaised += msg.value;
286         forwardFunds();
287         emit Buy(msg.sender, msg.value, userId);
288     } //end of buy
289 
290      /**
291       * @dev Determines how ETH is stored/forwarded on purchases.
292     */
293     function forwardFunds()internal {
294         depositWalletAddress.transfer(msg.value);
295     }
296 
297 
298     function changeDepositWalletAddress(address newDepositWalletAddr)public onlyOwner {
299         require(newDepositWalletAddr != 0);
300         depositWalletAddress = newDepositWalletAddr;
301     }
302 
303     function transfer(address _to, uint256 _value) public reserveTokenLock returns (bool) {
304         super.transfer(_to,_value);
305     }
306 
307     function transferFrom(address _from, address _to, uint256 _value) public reserveTokenLock returns (bool){
308         super.transferFrom(_from, _to, _value);
309     }
310 
311     function approve(address _spender, uint256 _value) public reserveTokenLock returns (bool) {
312         super.approve(_spender, _value);
313     }
314 
315     function increaseApproval(address _spender, uint _addedValue) public reserveTokenLock returns (bool) {
316         super.increaseApproval(_spender, _addedValue);
317     }
318 
319 
320     modifier reserveTokenLock () {
321         if(msg.sender == reserveTokenAddress){
322             require(block.timestamp > reserveTokensLockTime);
323             _;
324         }
325         else{
326             _;
327         }
328     }
329 }
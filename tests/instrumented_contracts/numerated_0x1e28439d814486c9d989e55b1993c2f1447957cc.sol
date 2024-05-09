1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) external view returns (uint256);
9   function allowance(address _owner, address _spender) external view returns (uint256);
10   function transfer(address _to, uint256 _value) external returns (bool);
11   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
12   function approve(address _spender, uint256 _value) external returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64       return 0;
65     }
66     uint256 c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {    
72     uint256 c = a / b;
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 /**
89  * @title VosAIInvitation token ERC20
90  *
91  * @dev Implementation of the VosAIInvitation token. * 
92  */
93 contract VosaiInvitationToken is IERC20 {
94   using SafeMath for uint256;
95 
96   string public name = "VOS.AI Invitation";
97   string public symbol = "VOS.AI";
98   uint8 public constant DECIMALS = 0;
99   uint256 public constant totalSupply = 40000000;
100   mapping (address => uint256) balances;
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   event Transfer(address indexed from, address indexed to, uint256 value);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106   /**
107   * @dev Constructor for VosAIInvitation creation
108   * @dev Assigns the totalSupply to the VOS.AI Distribution contract
109   */
110   constructor(address _vosAIInvitationDistributionContractAddress) public {
111     require(_vosAIInvitationDistributionContractAddress != address(0));
112     balances[_vosAIInvitationDistributionContractAddress] = totalSupply;
113     emit Transfer(address(0), _vosAIInvitationDistributionContractAddress, totalSupply);
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256 balance) {
122     return balances[_owner];
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
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Increase the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222 }
223 
224 /**
225  * @title VosaiInvitationToken token airdrop
226  *
227  * @dev Distribute airdrop tokens
228  */
229 contract VosaiInvitationAirdrop is Ownable {
230   using SafeMath for uint256;
231 
232   VosaiInvitationToken public VOSAI;
233   uint256 public AVAILABLE_TOTAL_SUPPLY = 40000000;
234   uint256 public startTime;
235  
236   // Keeps track of whether or not a VOS.AI airdrop has been made to a particular address
237   mapping (address => bool) public airdrops;   
238 
239   /**
240     * @dev Constructor function - Set the VOSAI token address    
241     */
242   constructor() public {    
243     startTime = now;
244     VOSAI = new VosaiInvitationToken(this);
245   }  
246   /**
247     * @dev perform a transfer of 1 VOS.AI to a list of recipients
248     * @param _recipient is a list of recipients
249     */
250   function airdropTokens(address[] _recipient) public onlyOwner {
251     require(now >= startTime);
252     uint airdropped;
253     for (uint256 i = 0; i<_recipient.length; i++) {
254         if (!airdrops[_recipient[i]]) {
255           airdrops[_recipient[i]] = true;
256           require(VOSAI.transfer(_recipient[i], 1));
257           airdropped = airdropped.add(1);
258         }
259     }    
260     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);    
261   }  
262 }
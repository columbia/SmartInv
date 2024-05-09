1 pragma solidity ^0.4.0;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed _from, address indexed _to, uint _value);
45 }
46 
47 
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed _owner, address indexed _spender, uint _value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still avaible for the spender.
148    */
149   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 /**
156  * @title Ownable
157  * @dev The Ownable contract has an owner address, and provides basic authorization control
158  * functions, this simplifies the implementation of "user permissions".
159  */
160 contract Ownable {
161   address public owner;
162 
163 
164   /**
165    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166    * account.
167    */
168   function Ownable() public {
169     owner = msg.sender;
170   }
171 
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) public onlyOwner {
187     if (newOwner != address(0)) {
188       owner = newOwner;
189     }
190   }
191 
192 }
193 
194 
195 contract ElecTokenSmartContract is StandardToken, Ownable {
196     string  public  constant name = "ElectrifyAsia";
197     string  public  constant symbol = "ELEC";
198     uint8    public  constant decimals = 18;
199 
200     uint    public  saleStartTime;
201     uint    public  saleEndTime;
202     uint    public lockedDays = 0;
203 
204     address public  tokenSaleContract;
205     address public adminAddress;
206 
207     modifier onlyWhenTransferEnabled() {
208         if( now <= (saleEndTime + lockedDays * 1 days) && now >= saleStartTime ) {
209             require( msg.sender == tokenSaleContract || msg.sender == adminAddress );
210         }
211         _;
212     }
213 
214     modifier validDestination( address to ) {
215         require(to != address(0x0));
216         require(to != address(this) );
217         _;
218     }
219 
220     function ElecTokenSmartContract( uint tokenTotalAmount, uint startTime, uint endTime, uint lockedTime, address admin ) public {
221         // Mint all tokens. Then disable minting forever.
222         balances[msg.sender] = tokenTotalAmount;
223         totalSupply = tokenTotalAmount;
224         Transfer(address(0x0), msg.sender, tokenTotalAmount);
225 
226         saleStartTime = startTime;
227         saleEndTime = endTime;
228         lockedDays = lockedTime;
229 
230         tokenSaleContract = msg.sender;
231         adminAddress = admin;
232         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
233     }
234 
235     function transfer(address _to, uint _value)
236     public
237     onlyWhenTransferEnabled
238     validDestination(_to)
239     returns (bool) {
240         return super.transfer(_to, _value);
241     }
242 
243     function transferFrom(address _from, address _to, uint _value)
244     public
245     onlyWhenTransferEnabled
246     validDestination(_to)
247     returns (bool) {
248         return super.transferFrom(_from, _to, _value);
249     }
250 
251     event Burn(address indexed _burner, uint _value);
252 
253     function burn(uint _value) public onlyWhenTransferEnabled
254     returns (bool){
255         balances[msg.sender] = balances[msg.sender].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         Burn(msg.sender, _value);
258         Transfer(msg.sender, address(0x0), _value);
259         return true;
260     }
261 
262 
263     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
264         token.transfer( owner, amount );
265     }
266 }
1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *  Blockonix Tokens are governed by the Terms & Conditions separately notified to each existing token holder
6 *  of Bitindia, and available on https://blockonix.com and https://blockonix.com/tokenswap
7 *
8 */
9 
10 
11 /**
12  *  Standard Interface for ERC20 Contract
13  */
14 contract IERC20 {
15     function totalSupply() public constant returns (uint _totalSupply);
16     function balanceOf(address _owner) public constant returns (uint balance);
17     function transfer(address _to, uint _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
19     function approve(address _spender, uint _value) public returns (bool success);
20     function allowance(address _owner, address _spender) constant public returns (uint remaining);
21     event Transfer(address indexed _from, address indexed _to, uint _value);
22     event Approval(address indexed _owner, address indexed _spender, uint _value);
23 }
24 
25 
26 /**
27  * Checking overflows for various operations
28  */
29 library SafeMathLib {
30 
31 /**
32 * Issue: Change to internal pure
33 **/
34   function minus(uint a, uint b) internal pure returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39 /**
40 * Issue: Change to internal pure
41 **/
42   function plus(uint a, uint b) internal pure returns (uint) {
43     uint c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 
48 }
49 
50 /**
51  * @title Ownable
52  * @notice The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56 
57   address public owner;
58 
59   /**
60    * @notice The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @notice Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @notice Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) onlyOwner public {
80     require(newOwner != address(0));
81     owner = newOwner;
82   }
83     
84 }
85 
86 contract HasAddresses {
87     address founder1FirstLockup = 0xfC866793142059C79E924d537C26E5E68a3d0CB4;
88     address founder1SecondLockup = 0xa5c5EdA285866a89fbe9434BF85BC7249Fa98D45;
89     address founder1ThirdLockup = 0xBE2D892D27309EE50D53aa3460fB21A2762625d6;
90     
91     address founder2FirstLockup = 0x7aeFB5F308C60D6fD9f9D79D6BEb32e2BbEf8F3C;
92     address founder2SecondLockup = 0x9d92785510fadcBA9D0372e96882441536d6876a;
93     address founder2ThirdLockup = 0x0e0B9943Ea00393B596089631D520bF1489d4d2E;
94 
95     address founder3FirstLockup = 0x8E06EdC382Dd2Bf3F2C36f7e2261Af2c7Eb84835;
96     address founder3SecondLockup = 0x6A5AebCd6fA054ff4D10c51bABce17F189A9998a;
97     address founder3ThirdLockup = 0xe10E613Be00a6383Dde52152Bc33007E5669e861;
98 
99 }
100 
101 
102 contract VestingPeriods{
103     uint firstLockup = 1544486400; // Human time (GMT): Tuesday, 11 December 2018 00:00:00  
104     uint secondLockup = 1560211200; // Human time (GMT): Tuesday, 11 June 2019 00:00:00
105     uint thirdLockup = 1576022400; // Human time (GMT): Wednesday, 11 December 2019 00:00:00
106 }
107 
108 
109 contract Vestable {
110 
111     mapping(address => uint) vestedAddresses ;    // Addresses vested till date
112     bool isVestingOver = false;
113     event AddVestingAddress(address vestingAddress, uint maturityTimestamp);
114 
115     function addVestingAddress(address vestingAddress, uint maturityTimestamp) internal{
116         vestedAddresses[vestingAddress] = maturityTimestamp;
117         emit AddVestingAddress(vestingAddress, maturityTimestamp);
118     }
119 
120     function checkVestingTimestamp(address testAddress) public view returns(uint){
121         return vestedAddresses[testAddress];
122     }
123 
124     function checkVestingCondition(address sender) internal view returns(bool) {
125         uint vestingTimestamp = vestedAddresses[sender];
126         if(vestingTimestamp > 0) {
127             return (now > vestingTimestamp);
128         }
129         else {
130             return true;
131         }
132     }
133 
134 }
135 
136 contract IsUpgradable{
137     address oldTokenAddress = 0x420335D3DEeF2D5b87524Ff9D0fB441F71EA621f;
138     uint upgradeDeadline = 1543536000;
139     address oldTokenBurnAddress = 0x30E055F7C16B753dbF77B57f38782C11A9f1C653;
140     IERC20 oldToken = IERC20(oldTokenAddress);
141 
142 
143 }
144 
145 /**
146  * @title BlockonixToken Token
147  * @notice The ERC20 Token.
148  */
149 contract BlockonixToken is IERC20, Ownable, Vestable, HasAddresses, VestingPeriods, IsUpgradable {
150     
151     using SafeMathLib for uint256;
152     
153     uint256 public constant totalTokenSupply = 1009208335 * 10**16;    // Total Supply:10,092,083.35
154 
155     uint256 public burntTokens;
156 
157     string public constant name = "Blockonix";    // Blockonix
158     string public constant symbol = "BDT";  // BDT
159     uint8 public constant decimals = 18;            
160 
161     mapping (address => uint256) public balances;
162     mapping(address => mapping(address => uint256)) approved;
163     
164     event Upgraded(address _owner, uint256 amount); 
165     constructor() public {
166         
167         uint256 lockedTokenPerAddress = 280335648611111000000000;   // Total Founder Tokens(LOCKED): 2,523,020.8375, divided equally in 9 chunks
168         balances[founder1FirstLockup] = lockedTokenPerAddress;
169         balances[founder2FirstLockup] = lockedTokenPerAddress;
170         balances[founder3FirstLockup] = lockedTokenPerAddress;
171         balances[founder1SecondLockup] = lockedTokenPerAddress;
172         balances[founder2SecondLockup] = lockedTokenPerAddress;
173         balances[founder3SecondLockup] = lockedTokenPerAddress;
174         balances[founder1ThirdLockup] = lockedTokenPerAddress;
175         balances[founder2ThirdLockup] = lockedTokenPerAddress;
176         balances[founder3ThirdLockup] = lockedTokenPerAddress;
177 
178         emit Transfer(address(this), founder1FirstLockup, lockedTokenPerAddress);
179         emit Transfer(address(this), founder2FirstLockup, lockedTokenPerAddress);
180         emit Transfer(address(this), founder3FirstLockup, lockedTokenPerAddress);
181         
182         emit Transfer(address(this), founder1SecondLockup, lockedTokenPerAddress);
183         emit Transfer(address(this), founder2SecondLockup, lockedTokenPerAddress);
184         emit Transfer(address(this), founder3SecondLockup, lockedTokenPerAddress);
185 
186         emit Transfer(address(this), founder1ThirdLockup, lockedTokenPerAddress);
187         emit Transfer(address(this), founder2ThirdLockup, lockedTokenPerAddress);
188         emit Transfer(address(this), founder3ThirdLockup, lockedTokenPerAddress);
189 
190 
191         addVestingAddress(founder1FirstLockup, firstLockup);
192         addVestingAddress(founder2FirstLockup, firstLockup);
193         addVestingAddress(founder3FirstLockup, firstLockup);
194 
195         addVestingAddress(founder1SecondLockup, secondLockup);
196         addVestingAddress(founder2SecondLockup, secondLockup);
197         addVestingAddress(founder3SecondLockup, secondLockup);
198 
199         addVestingAddress(founder1ThirdLockup, thirdLockup);
200         addVestingAddress(founder2ThirdLockup, thirdLockup);
201         addVestingAddress(founder3ThirdLockup, thirdLockup);
202 
203     }
204 
205     function burn(uint256 _value) public {
206         require (balances[msg.sender] >= _value);                 // Check if the sender has enough
207         balances[msg.sender] = balances[msg.sender].minus(_value);
208         burntTokens += _value;
209         emit BurnToken(msg.sender, _value);
210     } 
211 
212     
213     function totalSupply() view public returns (uint256 _totalSupply) {
214         return totalTokenSupply - burntTokens;
215     }
216     
217     function balanceOf(address _owner) view public returns (uint256 balance) {
218         return balances[_owner];
219     }
220     
221     /* Internal transfer, only can be called by this contract */
222     function _transfer(address _from, address _to, uint256 _value) internal {
223         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
224         require (balances[_from] >= _value);                 // Check if the sender has enough
225         require (balances[_to] + _value > balances[_to]);   // Check for overflows
226         balances[_from] = balances[_from].minus(_value);    // Subtract from the sender
227         balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient
228         emit Transfer(_from, _to, _value);
229     }
230 
231     /**
232      * @notice Send `_value` tokens to `_to` from your account
233      * @param _to The address of the recipient
234      * @param _value the amount to send
235      */
236     function transfer(address _to, uint256 _value) public returns (bool success){
237         require(checkVestingCondition(msg.sender));
238         _transfer(msg.sender, _to, _value);
239         return true;
240     }
241     
242     /**
243      * @notice Send `_value` tokens to `_to` on behalf of `_from`
244      * @param _from The address of the sender
245      * @param _to The address of the recipient
246      * @param _value the amount to send
247      */
248     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
249         require(checkVestingCondition(_from));
250         require (_value <= approved[_from][msg.sender]);     // Check allowance
251         approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);
252         _transfer(_from, _to, _value);
253         return true;
254     }
255     
256     /**
257      * @notice Approve `_value` tokens for `_spender`
258      * @param _spender The address of the sender
259      * @param _value the amount to send
260      */
261     function approve(address _spender, uint256 _value) public returns (bool success) {
262         require(checkVestingCondition(_spender));
263         if(balances[msg.sender] >= _value) {
264             approved[msg.sender][_spender] = _value;
265             emit Approval(msg.sender, _spender, _value);
266             return true;
267         }
268         return false;
269     }
270         
271     /**
272      * @notice Check `_value` tokens allowed to `_spender` by `_owner`
273      * @param _owner The address of the Owner
274      * @param _spender The address of the Spender
275      */
276     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
277         return approved[_owner][_spender];
278     }
279         
280     event Transfer(address indexed _from, address indexed _to, uint256 _value);
281     
282     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
283 
284     event BurnToken(address _owner, uint256 _value);
285     
286      /**
287      * Upgrade function, requires the owner to first approve tokens equal to their old token balance to this address 
288      *
289      */
290     function upgrade() external {
291         require(now <=upgradeDeadline);
292         uint256 balance = oldToken.balanceOf(msg.sender);
293         require(balance>0);
294         oldToken.transferFrom(msg.sender, oldTokenBurnAddress, balance);
295         balances[msg.sender] += balance;
296         emit Transfer(this, msg.sender, balance);
297         emit Upgraded(msg.sender, balance);
298     }
299 
300 }
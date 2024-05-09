1 pragma solidity >=0.4.21 <0.6.0;
2 //
3 /**
4  * @title Sapiency Token
5  * @title https://sapiency.io  
6  * @dev Token code : SPCY
7  */
8 interface ERC20 {
9     function balanceOf(address who) external view returns (uint256);
10     function transfer(address to, uint256 value) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13     function approve(address spender, uint256 value) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 //
18 /**
19  * @title Interface for handling voluntary token upgrade
20  *
21  * @notice ERC20 has some known flaws, but no other standard is so widely accepted 
22  * @notice at a time this text is written. We can not stick to this standard forever, so we 
23  * @notice added this functionality for future use, but without posibility to force anyone to migrate.
24  * @notice Burn function can be invoked only by UpgradeContract in case of a token
25  * @notice exchange, to persist total supply at constant 100 million.
26  * @notice The only way to upgrade Sapiency token will be through upgrade contract at
27  * @notice upgradeContract address. Sapiency is made to last, so we have to have  
28  * @notice a possibility to support expected functionality in the future.
29  *
30  * @notice Pros: Owner cannot change contract to change the rules without community acceptance
31  * @notice Cons: Upgraded contract will have new address
32  * @notice Cons: For some time both version would still be in active use at the same time
33  */
34 interface TokenVoluntaryUpgrade {
35     function setUpgradeContract(address _upgradeContractAddress) external returns(bool);
36     function burnAfterUpgrade(uint256 value) external returns (bool success);
37     event UpgradeContractChange(address owner, address indexed _exchangeContractAddress);
38     event UpgradeBurn(address indexed _exchangeContract, uint256 _value);
39 }
40 //
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         //
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function uintSub(uint a, uint b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
80 // b7d60f2f9a849c5c2d59e24062f9c09f3390487a
81 // with some minor changes
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94      * account.
95      */
96     constructor () internal {
97         _owner = msg.sender;
98         emit OwnershipTransferred(address(0), _owner);
99     }
100 
101     /**
102      * @return the address of the owner.
103      */
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(isOwner(), "Only owner can do that");
113         _;
114     }
115 
116     /**
117      * @return true if `msg.sender` is the owner of the contract.
118      */
119     function isOwner() public view returns (bool) {
120         return msg.sender == _owner;
121     }
122 
123     /**
124      * @dev Allows the current owner to relinquish control of the contract.
125      * @notice Renouncing to ownership will leave the contract without an owner.
126      * It will not be possible to call the functions with the `onlyOwner`
127      * modifier anymore.
128      */
129     function renounceOwnership() public onlyOwner {
130         emit OwnershipTransferred(_owner, address(0));
131         _owner = address(0);
132     }
133 
134     /**
135      * @dev Allows the current owner to transfer control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function transferOwnership(address newOwner) public onlyOwner {
139         _transferOwnership(newOwner);
140     }
141 
142     /**
143      * @dev Transfers control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function _transferOwnership(address newOwner) internal {
147         require(newOwner != address(0), "newOwner parameter must be set");
148         emit OwnershipTransferred(_owner, newOwner);
149         _owner = newOwner;
150     }
151 }
152 //
153 
154 //
155 contract SapiencyToken is Ownable, TokenVoluntaryUpgrade  {
156     string  internal _name              = "Sapiency Token";
157     string  internal _symbol            = "SPCY";
158     string  internal _standard          = "ERC20";
159     uint8   internal _decimals          = 18;
160     uint    internal _totalSupply       = 100000000 * 1 ether;
161     //
162     string  internal _trustedIPNS       = ""; 
163     //
164     address internal _upgradeContract   = address(0);
165     //
166     mapping(address => uint256)                     internal balances;
167     mapping(address => mapping(address => uint256)) internal allowed;
168     //
169     event Transfer(
170         address indexed _from,
171         address indexed _to,
172         uint256 _value
173     );
174     //
175     event Approval(
176         address indexed _owner,
177         address indexed _spender,
178         uint256 _value
179     );
180     //
181     event UpgradeContractChange(
182         address owner, 
183         address indexed _exchangeContractAddress
184     );
185     //
186     event UpgradeBurn(
187         address indexed _upgradeContract,
188         uint256 _value
189     );
190     //
191     constructor () public Ownable() {
192         balances[msg.sender] = totalSupply();
193     }
194     // Try to prevent sending ETH to SmartContract by mistake.
195     function () external payable  {
196         revert("This SmartContract is not payable");
197     }
198     //
199     // Getters and Setters
200     //
201     function name() public view returns (string memory) {
202         return _name;
203     }
204     //
205     function symbol() public view returns (string memory) {
206         return _symbol;
207     }
208     //
209     function standard() public view returns (string memory) {
210         return _standard;
211     }
212     //
213     function decimals() public view returns (uint8) {
214         return _decimals;
215     }
216     //
217     function totalSupply() public view returns (uint256) {
218         return _totalSupply;
219     }
220     
221     //
222     // Contract common functions
223     //
224     function transfer(address _to, uint256 _value) public returns (bool) {
225         //
226         require(_to != address(0), "'_to' address has to be set");
227         require(_value <= balances[msg.sender], "Insufficient balance");
228         //
229         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
230         balances[_to] = SafeMath.add(balances[_to], _value);
231         //
232         emit Transfer(msg.sender, _to, _value);
233         return true;
234     }
235     //
236     function approve(address _spender, uint256 _value) public returns (bool success) {
237         require (_spender != address(0), "_spender address has to be set");
238         require (_value > 0, "'_value' parameter has to greater than 0");
239         //
240         allowed[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242         return true;
243     }
244     //
245     function safeApprove(address _spender, uint256 _currentValue, uint256 _value)  public returns (bool success) {
246         // If current allowance for _spender is equal to _currentValue, then
247         // overwrite it with _value and return true, otherwise return false.
248         if (allowed[msg.sender][_spender] == _currentValue) return approve(_spender, _value);
249         return false;
250     }
251     //
252     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
253         //
254         require(_from != address(0), "'_from' address has to be set");
255         require(_to != address(0), "'_to' address has to be set");
256         require(_value <= balances[_from], "Insufficient balance");
257         require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
258         //
259         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
260         balances[_from] = SafeMath.sub(balances[_from], _value);
261         balances[_to] = SafeMath.add(balances[_to], _value);
262         //
263         emit Transfer(_from, _to, _value);
264         //
265         return true;
266     }
267     //
268     function allowance(address _owner, address _spender) public view returns (uint256) {
269         return allowed[_owner][_spender];
270     }
271     //
272     function balanceOf(address _owner) public view returns (uint256) {
273         return balances[_owner];
274     }
275     // Voluntary token upgrade logic
276     //
277     /**
278      * @dev Gets trusted IPNS address
279      */
280     function trustedIPNS() public view returns(string memory) {
281         return  _trustedIPNS;
282     }
283     /** 
284     * @dev Sets trusted IPNS address for use communication chanel for Sapiency Team
285     * @notice For future use - this variable is not used in contract logic and plays olny information role using blockchain as trusted medium
286     */
287     function setTrustedIPNS(string memory _trustedIPNSparam) public onlyOwner returns(bool) {
288         _trustedIPNS = _trustedIPNSparam;
289         return true;
290     }
291     //
292     /** 
293      * @dev Gets SmartContract that could upgrade Tokens - empty == no upgrade
294      */
295     function upgradeContract() public view returns(address) {
296         return _upgradeContract;
297     }
298     //
299     /** 
300      * @dev Sets SmartContract that could upgrade Tokens to a new version in a future
301      */
302     function setUpgradeContract(address _upgradeContractAddress) public onlyOwner returns(bool) {
303         _upgradeContract = _upgradeContractAddress;
304         emit UpgradeContractChange(msg.sender, _upgradeContract);
305         //
306         return true;
307     }
308     function burnAfterUpgrade(uint256 _value) public returns (bool success) {
309         require(_upgradeContract != address(0), "upgradeContract is not set");
310         require(msg.sender == _upgradeContract, "only upgradeContract can execute token burning");
311         require(_value <= balances[msg.sender], "Insufficient balance");
312         //
313         _totalSupply = SafeMath.sub(_totalSupply, _value);
314         balances[msg.sender] = SafeMath.sub(balances[msg.sender],_value);
315         emit UpgradeBurn(msg.sender, _value);
316         //
317         return true;
318     }
319 }
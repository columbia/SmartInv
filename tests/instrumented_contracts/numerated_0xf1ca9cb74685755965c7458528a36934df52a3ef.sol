1 pragma solidity 0.4.24;
2 
3 
4 // @title SafeMath
5 // @dev Math operations with safety checks that throw on error
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         assert(c >= a);
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 }
34 
35 
36 // @title Ownable
37 // @dev The Ownable contract has an owner address, and provides basic authorization control
38 // functions, this simplifies the implementation of "user permissions".
39 contract Ownable {
40     address public owner;
41 
42     // @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     // @dev Throws if called by any account other than the owner.
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     // @dev Allows the current owner to transfer control of the contract to a newOwner.
54     // @param newOwner The address to transfer ownership to.
55     function transferOwnership(address newOwner) public onlyOwner {
56         require(newOwner != address(0));
57         if (newOwner != address(0)) {
58             owner = newOwner;
59         }
60     }
61 }
62 
63 
64 // @title ERC20Basic
65 // @dev Simpler version of ERC20 interface
66 // @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
67 contract ERC20Basic {
68     event Transfer(address indexed from, address indexed to, uint value);
69 
70     function totalSupply() public view returns (uint256 supply);
71 
72     function balanceOf(address who) public view returns (uint256 balance);
73 
74     function transfer(address to, uint256 value) public returns (bool success);
75 }
76 
77 
78 // @title ERC20 interface
79 // @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
80 contract ERC20 is ERC20Basic {
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 
83     function allowance(address owner, address spender) public view returns (uint256 remaining);
84 
85     function transferFrom(address from, address to, uint256 value) public returns (bool success);
86 
87     function approve(address spender, uint256 value) public returns (bool success);
88 }
89 
90 
91 // @title Basic token
92 // @dev Basic version of StandardToken, with no allowances.
93 contract BasicToken is Ownable, ERC20Basic {
94     using SafeMath for uint256;
95     mapping(address => uint256) public balances;
96 
97     // @dev Fix for the ERC20 short address attack.
98     modifier onlyPayloadSize(uint256 size) {
99         require(!(msg.data.length < size + 4));
100         _;
101     }
102 
103     // @dev transfer token for a specified address
104     // @param _to The address to transfer to.
105     // @param _value The amount to be transferred.
106     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         emit Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     // @dev Gets the balance of the specified address.
117     // @param _owner The address to query the the balance of.
118     // @return An uint256 representing the amount owned by the passed address.
119     function balanceOf(address _owner) public view returns (uint256 balance) {
120         return balances[_owner];
121     }
122 }
123 
124 
125 // @title Standard ERC20 token
126 // @dev Implementation of the basic standard token.
127 // @dev https://github.com/ethereum/EIPs/issues/20
128 // @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129 contract StandardToken is BasicToken, ERC20 {
130     mapping(address => mapping(address => uint256)) public allowed;
131     uint256 public constant MAX_UINT256 = 2 ** 256 - 1;
132 
133     // @dev Transfer tokens from one address to another
134     // @param _from address The address which you want to send tokens from
135     // @param _to address The address which you want to transfer to
136     // @param _value uint256 the amount of tokens to be transferred
137     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool success) {
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         uint256 _allowance = allowed[_from][msg.sender];
141         require(_value <= _allowance);
142 
143         // @dev Treat 2^256-1 means unlimited allowance
144         if (_allowance < MAX_UINT256)
145             allowed[_from][msg.sender] = _allowance.sub(_value);
146         balances[_from] = balances[_from].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     // @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     // Beware that changing an allowance with this method brings the risk that someone may use both the old
154     // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155     // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     // @param _spender The address which will spend the funds.
158     // @param _value The amount of tokens to be spent.
159     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
160         allowed[msg.sender][_spender] = _value;
161         emit Approval(msg.sender, _spender, _value);
162         return true;
163     }
164 
165     // @dev approve should be called when allowed[_spender] == 0. To increment allowed value is better to use
166     // @dev this function to avoid 2 calls (and wait until the first transaction is mined)
167     // @param _spender The address which will spend the funds.
168     // @param _addedValue The amount of tokens to be added to the allowance.
169     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
170         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172         return true;
173     }
174 
175     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
176         uint oldValue = allowed[msg.sender][_spender];
177         if (_subtractedValue >= oldValue) {
178             allowed[msg.sender][_spender] = 0;
179         } else {
180             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181         }
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 
186     // @dev Function to check the amount of tokens than an owner allowed to a spender.
187     // @param _owner address The address which owns the funds.
188     // @param _spender address The address which will spend the funds.
189     // @return A uint256 specifying the amount of tokens still available for the spender.
190     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
191         return allowed[_owner][_spender];
192     }
193 }
194 
195 
196 // @title Upgraded standard token
197 // @dev Contract interface that the upgraded contract has to implement
198 // @dev Methods to be called by the legacy contract
199 // @dev They have to ensure msg.sender to be the contract address
200 contract UpgradedStandardToken is StandardToken {
201     function transferByLegacy(address from, address to, uint256 value) public returns (bool success);
202 
203     function transferFromByLegacy(address sender, address from, address spender, uint256 value) public returns (bool success);
204 
205     function approveByLegacy(address from, address spender, uint256 value) public returns (bool success);
206 
207     function increaseApprovalByLegacy(address from, address spender, uint256 value) public returns (bool success);
208 
209     function decreaseApprovalByLegacy(address from, address spender, uint256 value) public returns (bool success);
210 }
211 
212 
213 // @title Upgradeable standard token
214 // @dev The upgradeable contract interface
215 // @dev
216 // @dev They have to ensure msg.sender to be the contract address
217 contract UpgradeableStandardToken is StandardToken {
218     address public upgradeAddress;
219     uint256 public upgradeTimestamp;
220 
221     //  The contract is initialized with an upgrade timestamp close to the heat death of the universe.
222     constructor() public {
223         upgradeAddress = address(0);
224         //  Set the timestamp of the upgrade to some time close to the heat death of the universe.
225         upgradeTimestamp = MAX_UINT256;
226     }
227 
228     // Forward ERC20 methods to upgraded contract after the upgrade timestamp has been reached
229     function transfer(address _to, uint256 _value) public returns (bool success) {
230         if (now > upgradeTimestamp) {
231             return UpgradedStandardToken(upgradeAddress).transferByLegacy(msg.sender, _to, _value);
232         } else {
233             return super.transfer(_to, _value);
234         }
235     }
236 
237     // Forward ERC20 methods to upgraded contract after the upgrade timestamp has been reached
238     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
239         if (now > upgradeTimestamp) {
240             return UpgradedStandardToken(upgradeAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
241         } else {
242             return super.transferFrom(_from, _to, _value);
243         }
244     }
245 
246     // Forward ERC20 methods to upgraded contract after the upgrade timestamp has been reached
247     function balanceOf(address who) public view returns (uint256 balance) {
248         if (now > upgradeTimestamp) {
249             return UpgradedStandardToken(upgradeAddress).balanceOf(who);
250         } else {
251             return super.balanceOf(who);
252         }
253     }
254 
255     // Forward ERC20 methods to upgraded contract after the upgrade timestamp has been reached
256     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
257         if (now > upgradeTimestamp) {
258             return UpgradedStandardToken(upgradeAddress).approveByLegacy(msg.sender, _spender, _value);
259         } else {
260             return super.approve(_spender, _value);
261         }
262     }
263 
264     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
265         if (now > upgradeTimestamp) {
266             return UpgradedStandardToken(upgradeAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);
267         } else {
268             return super.increaseApproval(_spender, _addedValue);
269         }
270     }
271 
272     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
273         if (now > upgradeTimestamp) {
274             return UpgradedStandardToken(upgradeAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);
275         } else {
276             return super.decreaseApproval(_spender, _subtractedValue);
277         }
278     }
279 
280     // Forward ERC20 methods to upgraded contract after the upgrade timestamp has been reached
281     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
282         if (now > upgradeTimestamp) {
283             return StandardToken(upgradeAddress).allowance(_owner, _spender);
284         } else {
285             return super.allowance(_owner, _spender);
286         }
287     }
288 
289     // Upgrade this contract with a new one, it will auto-activate 12 weeks later
290     function upgrade(address _upgradeAddress) public onlyOwner {
291         require(now < upgradeTimestamp);
292         require(_upgradeAddress != address(0));
293 
294         upgradeAddress = _upgradeAddress;
295         upgradeTimestamp = now.add(12 weeks);
296         emit Upgrading(_upgradeAddress, upgradeTimestamp);
297     }
298 
299     // Called when contract is upgrading
300     event Upgrading(address newAddress, uint256 timestamp);
301 }
302 
303 
304 // @title The AVINOC Token contract
305 contract AVINOCToken is UpgradeableStandardToken {
306     string public constant name = "AVINOC Token";
307     string public constant symbol = "AVINOC";
308     uint8 public constant decimals = 18;
309     uint256 public constant decimalFactor = 10 ** uint256(decimals);
310     uint256 public constant TOTAL_SUPPLY = 1000000000 * decimalFactor;
311 
312     constructor() public {
313         balances[owner] = TOTAL_SUPPLY;
314     }
315 
316     // @dev Don't accept ETH
317     function() public payable {
318         revert();
319     }
320 
321     // @dev return the fixed total supply
322     function totalSupply() public view returns (uint256) {
323         return TOTAL_SUPPLY;
324     }
325 }
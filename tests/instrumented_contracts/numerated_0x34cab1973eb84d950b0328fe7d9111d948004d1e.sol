1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47     /**
48     * @dev Multiplies two numbers, throws on overflow.
49     */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         if (a == 0) {
52             return 0;
53         }
54         c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers, truncating the quotient.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         // uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return a / b;
67     }
68 
69     /**
70     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71     */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     /**
78     * @dev Adds two numbers, throws on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81         c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93     function totalSupply() public view returns (uint256);
94 
95     function balanceOf(address who) public view returns (uint256);
96 
97     function transfer(address to, uint256 value) public returns (bool);
98 
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) balances;
110 
111     uint256 totalSupply_;
112 
113     /**
114     * @dev total number of tokens in existence
115     */
116     function totalSupply() public view returns (uint256) {
117         return totalSupply_;
118     }
119 
120     /**
121     * @dev transfer token for a specified address
122     * @param _to The address to transfer to.
123     * @param _value The amount to be transferred.
124     */
125     function transfer(address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[msg.sender]);
128 
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         emit Transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     /**
136     * @dev Gets the balance of the specified address.
137     * @param _owner The address to query the the balance of.
138     * @return An uint256 representing the amount owned by the passed address.
139     */
140     function balanceOf(address _owner) public view returns (uint256) {
141         return balances[_owner];
142     }
143 
144 }
145 
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152     function allowance(address owner, address spender) public view returns (uint256);
153 
154     function transferFrom(address from, address to, uint256 value) public returns (bool);
155 
156     function approve(address spender, uint256 value) public returns (bool);
157 
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping(address => mapping(address => uint256)) internal allowed;
171 
172 
173     /**
174      * @dev Transfer tokens from one address to another
175      * @param _from address The address which you want to send tokens from
176      * @param _to address The address which you want to transfer to
177      * @param _value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 /**
257  * @title LockAddressInfo
258  */
259 library LockAddressInfo {
260     struct info {
261         address _address;
262         uint256 amount;
263         bool isLocked;
264         uint releaseTime;
265     }
266 }
267 
268 
269 /**
270  * @title eDiamondToken
271  */
272 contract EDiamondToken is StandardToken, Ownable {
273 
274     using LockAddressInfo for LockAddressInfo.info;
275     using SafeMath for uint256;
276 
277     string public name = "eDiamond";
278     string public symbol = "EDD";
279     uint public decimals = 18;
280     uint public INITIAL_SUPPLY = 10900000000 * (10 ** decimals); //10,900,000,000
281 
282     // map for locked addresses
283     mapping(address => LockAddressInfo.info) LOCKED_ACCOUNTS;
284 
285     constructor() public {
286         totalSupply_ = INITIAL_SUPPLY;
287         balances[msg.sender] = INITIAL_SUPPLY;
288         setInitLockedAccount();
289     }
290 
291     // locked accounts 
292     function setInitLockedAccount() internal {
293         LOCKED_ACCOUNTS[0x18dd6FbE4000C1d707d61deBF5352ef86Cd7f12a].isLocked = true;
294         LOCKED_ACCOUNTS[0x18dd6FbE4000C1d707d61deBF5352ef86Cd7f12a].amount = 10000 * (10 ** decimals);
295         LOCKED_ACCOUNTS[0x18dd6FbE4000C1d707d61deBF5352ef86Cd7f12a].releaseTime = block.timestamp + 60 * 60 * 24 * 60;
296     }
297 
298     function judgeEnableForTransfer(address _from, uint256 _value) public view returns (bool) {
299         if (!LOCKED_ACCOUNTS[_from].isLocked || block.timestamp > LOCKED_ACCOUNTS[_from].releaseTime) {
300             return true;
301         }
302         uint256 availableMaxTransferAmount = balances[_from].sub(LOCKED_ACCOUNTS[_from].amount);
303         return availableMaxTransferAmount >= _value;
304     }
305 
306     function addLockedAccount(address _to, uint256 _amount, uint _releaseTime) public onlyOwner returns (bool) {
307         require(!LOCKED_ACCOUNTS[_to].isLocked);
308         LOCKED_ACCOUNTS[_to].isLocked = true;
309         LOCKED_ACCOUNTS[_to].amount = _amount;
310         LOCKED_ACCOUNTS[_to].releaseTime = _releaseTime;
311         return true;
312     }
313 
314     function transfer(address _to, uint256 _value) public returns (bool) {
315         require(judgeEnableForTransfer(msg.sender, _value));
316         return super.transfer(_to, _value);
317     }
318 
319     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
320         require(judgeEnableForTransfer(_from, _value));
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324 }
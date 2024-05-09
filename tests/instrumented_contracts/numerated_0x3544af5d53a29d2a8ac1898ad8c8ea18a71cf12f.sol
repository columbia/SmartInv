1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public constant returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) balances;
66 
67     /**
68     * @dev transfer token for a specified address
69     * @param _to The address to transfer to.
70     * @param _value The amount to be transferred.
71     */
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113 
114         uint256 _allowance = allowed[_from][msg.sender];
115 
116         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117         // require (_value <= _allowance);
118 
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = _allowance.sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      *
129      * Beware that changing an allowance with this method brings the risk that someone may use both the old
130      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      * @param _spender The address which will spend the funds.
134      * @param _value The amount of tokens to be spent.
135      */
136     function approve(address _spender, uint256 _value) public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param _owner address The address which owns the funds.
145      * @param _spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151 
152     /**
153      * approve should be called when allowed[_spender] == 0. To increment
154      * allowed value is better to use this function to avoid 2 calls (and wait until
155      * the first transaction is mined)
156      * From MonolithDAO Token.sol
157      */
158     function increaseApproval (address _spender, uint _addedValue) public
159     returns (bool success) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval (address _spender, uint _subtractedValue) public
166     returns (bool success) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         } else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177 }
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185     address public owner;
186 
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191     /**
192      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193      * account.
194      */
195     function Ownable() public {
196         owner = msg.sender;
197     }
198 
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         require(msg.sender == owner);
205         _;
206     }
207 
208 
209     /**
210      * @dev Allows the current owner to transfer control of the contract to a newOwner.
211      * @param newOwner The address to transfer ownership to.
212      */
213     function transferOwnership(address newOwner) onlyOwner public {
214         require(newOwner != address(0));
215         OwnershipTransferred(owner, newOwner);
216         owner = newOwner;
217     }
218 
219 }
220 
221 contract TempusToken is StandardToken, Ownable {
222 
223     string public constant name = "Tempus Token";
224     string public constant symbol = "TPS";
225     uint8 public constant decimals = 3;
226 
227     uint256 public constant INITIAL_SUPPLY = 0;
228 
229     event Burn(address indexed from, uint256 value);
230     event Mint(address indexed receiver, uint256 value);
231 
232     mapping(address => bool) burners;
233     mapping(address => bool) minters;
234 
235     modifier onlyMinters() {
236         require(minters[msg.sender]);
237         _;
238     }
239 
240     modifier onlyBurners() {
241         require(burners[msg.sender]);
242         _;
243     }
244 
245     /**
246     * @dev Token constructor that sets intial values and gives initial supply to msg.sender
247     */
248     function TempusToken() public {
249         totalSupply = INITIAL_SUPPLY;
250         balances[msg.sender] = INITIAL_SUPPLY;
251         minters[msg.sender] = true;
252         burners[msg.sender] = true;
253     }
254 
255     /**
256     * @dev Function to mint tokens
257     * @param receiver The address that will receive the minted tokens
258     * @param amount The amount of tokens to mint
259     * @return A boolean that indicates if operation was successful
260     */
261     function mint(address receiver, uint256 amount) public onlyMinters returns (bool success) {
262         balances[receiver] = balances[receiver].add(amount);
263         totalSupply = totalSupply.add(amount);
264         Mint(receiver, amount);
265         return true;
266     }
267 
268     /**
269     * @dev Function to burn tokens
270     * @param from The address that tokens will be burned from
271     * @param value The amount of tokens to burn
272     * @return A boolean that indicates if operation was successful
273     */
274     function burn(address from, uint256 value) public onlyBurners returns (bool success) {
275         require(balances[from] >= value);
276 
277         balances[from] = balances[from].sub(value);
278         totalSupply = totalSupply.sub(value);
279         Burn(from, value);
280         return true;
281     }
282 
283     /**
284     * @dev Function to set addresses that will be able to mint tokens
285     * @param addr The address that will be set as minter or not
286     * @param isMinter A boolean that indicates whether address should be set as minter
287     */
288     function setAsMinter(address addr, bool isMinter) public onlyOwner {
289         minters[addr] = isMinter;
290     }
291 
292     /**
293     * @dev Function to set addresses that will be able to burn tokens
294     * @param addr The address that will be set as burner or not
295     * @param isBurner A boolean that indicates whether address should be set as burner
296     */
297     function setAsBurner(address addr, bool isBurner) public onlyOwner {
298         burners[addr] = isBurner;
299     }
300 
301 }
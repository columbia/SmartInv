1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ERC20 {
46     function allowance(address owner, address spender) public view returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 interface LandManagementInterface {
57     function ownerAddress() external view returns (address);
58     function managerAddress() external view returns (address);
59     function communityAddress() external view returns (address);
60     function dividendManagerAddress() external view returns (address);
61     function walletAddress() external view returns (address);
62     //    function unicornTokenAddress() external view returns (address);
63     function candyToken() external view returns (address);
64     function megaCandyToken() external view returns (address);
65     function userRankAddress() external view returns (address);
66     function candyLandAddress() external view returns (address);
67     function candyLandSaleAddress() external view returns (address);
68 
69     function isUnicornContract(address _unicornContractAddress) external view returns (bool);
70 
71     function paused() external view returns (bool);
72     function presaleOpen() external view returns (bool);
73     function firstRankForFree() external view returns (bool);
74 
75     function ethLandSaleOpen() external view returns (bool);
76 
77     function landPriceWei() external view returns (uint);
78     function landPriceCandy() external view returns (uint);
79 
80     function registerInit(address _contract) external;
81 }
82 
83 contract LandAccessControl {
84 
85     LandManagementInterface public landManagement;
86 
87     function LandAccessControl(address _landManagementAddress) public {
88         landManagement = LandManagementInterface(_landManagementAddress);
89         landManagement.registerInit(this);
90     }
91 
92     modifier onlyOwner() {
93         require(msg.sender == landManagement.ownerAddress());
94         _;
95     }
96 
97     modifier onlyManager() {
98         require(msg.sender == landManagement.managerAddress());
99         _;
100     }
101 
102     modifier onlyCommunity() {
103         require(msg.sender == landManagement.communityAddress());
104         _;
105     }
106 
107     modifier whenNotPaused() {
108         require(!landManagement.paused());
109         _;
110     }
111 
112     modifier whenPaused {
113         require(landManagement.paused());
114         _;
115     }
116 
117     modifier onlyWhileEthSaleOpen {
118         require(landManagement.ethLandSaleOpen());
119         _;
120     }
121 
122     modifier onlyLandManagement() {
123         require(msg.sender == address(landManagement));
124         _;
125     }
126 
127     modifier onlyUnicornContract() {
128         require(landManagement.isUnicornContract(msg.sender));
129         _;
130     }
131 
132     modifier onlyCandyLand() {
133         require(msg.sender == address(landManagement.candyLandAddress()));
134         _;
135     }
136 
137 
138     modifier whilePresaleOpen() {
139         require(landManagement.presaleOpen());
140         _;
141     }
142 
143     function isGamePaused() external view returns (bool) {
144         return landManagement.paused();
145     }
146 }
147 
148 
149 contract StandardToken is ERC20 {
150     using SafeMath for uint256;
151 
152     mapping(address => uint256) balances;
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155     uint256 totalSupply_;
156 
157     event Burn(address indexed burner, uint256 value);
158 
159     /**
160     * @dev total number of tokens in existence
161     */
162     function totalSupply() public view returns (uint256) {
163         return totalSupply_;
164     }
165 
166     /**
167     * @dev transfer token for a specified address
168     * @param _to The address to transfer to.
169     * @param _value The amount to be transferred.
170     */
171     function transfer(address _to, uint256 _value) public returns (bool) {
172         require(_to != address(0));
173         require(_value <= balances[msg.sender]);
174 
175         // SafeMath.sub will throw if there is not enough balance.
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     /**
183     * @dev Gets the balance of the specified address.
184     * @param _owner The address to query the the balance of.
185     * @return An uint256 representing the amount owned by the passed address.
186     */
187     function balanceOf(address _owner) public view returns (uint256 balance) {
188         return balances[_owner];
189     }
190 
191     /**
192      * @dev Transfer tokens from one address to another
193      * @param _from address The address which you want to send tokens from
194      * @param _to address The address which you want to transfer to
195      * @param _value uint256 the amount of tokens to be transferred
196      */
197     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198         require(_to != address(0));
199         require(_value <= balances[_from]);
200         require(_value <= allowed[_from][msg.sender]);
201 
202         balances[_from] = balances[_from].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205         emit Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     /**
210      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211      *
212      * Beware that changing an allowance with this method brings the risk that someone may use both the old
213      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      * @param _spender The address which will spend the funds.
217      * @param _value The amount of tokens to be spent.
218      */
219     function approve(address _spender, uint256 _value) public returns (bool) {
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224 
225     /**
226      * @dev Function to check the amount of tokens that an owner allowed to a spender.
227      * @param _owner address The address which owns the funds.
228      * @param _spender address The address which will spend the funds.
229      * @return A uint256 specifying the amount of tokens still available for the spender.
230      */
231     function allowance(address _owner, address _spender) public view returns (uint256) {
232         return allowed[_owner][_spender];
233     }
234 
235     /**
236      * @dev Increase the amount of tokens that an owner allowed to a spender.
237      *
238      * approve should be called when allowed[_spender] == 0. To increment
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * @param _spender The address which will spend the funds.
243      * @param _addedValue The amount of tokens to increase the allowance by.
244      */
245     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
246         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251     /**
252      * @dev Decrease the amount of tokens that an owner allowed to a spender.
253      *
254      * approve should be called when allowed[_spender] == 0. To decrement
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      * @param _spender The address which will spend the funds.
259      * @param _subtractedValue The amount of tokens to decrease the allowance by.
260      */
261     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262         uint oldValue = allowed[msg.sender][_spender];
263         if (_subtractedValue > oldValue) {
264             allowed[msg.sender][_spender] = 0;
265         } else {
266             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267         }
268         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269         return true;
270     }
271 
272 }
273 
274 contract MegaCandy is StandardToken, LandAccessControl {
275 
276     string public constant name = "Unicorn Mega Candy"; // solium-disable-line uppercase
277     string public constant symbol = "Mega"; // solium-disable-line uppercase
278     uint8 public constant decimals = 18; // solium-disable-line uppercase
279 
280     event Mint(address indexed _to, uint  _amount);
281 
282 
283     //uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
284 
285 
286     function MegaCandy(address _landManagementAddress) LandAccessControl(_landManagementAddress) public {
287     }
288 
289     function init() onlyLandManagement whenPaused external view {
290     }
291 
292     function transferFromSystem(address _from, address _to, uint256 _value) onlyUnicornContract public returns (bool) {
293         require(_to != address(0));
294         require(_value <= balances[_from]);
295 
296         balances[_from] = balances[_from].sub(_value);
297         balances[_to] = balances[_to].add(_value);
298         emit Transfer(_from, _to, _value);
299         return true;
300     }
301 
302     function burn(address _from, uint256 _value) onlyUnicornContract public returns (bool) {
303         require(_value <= balances[_from]);
304 
305         balances[_from] = balances[_from].sub(_value);
306         totalSupply_ = totalSupply_.sub(_value);
307         //contract address here
308         emit Burn(msg.sender, _value);
309         emit Transfer(_from, address(0), _value);
310         return true;
311     }
312 
313     function mint(address _to, uint256 _amount) onlyCandyLand public returns (bool) {
314         totalSupply_ = totalSupply_.add(_amount);
315         balances[_to] = balances[_to].add(_amount);
316         emit Mint(_to, _amount);
317         emit Transfer(address(0), _to, _amount);
318         return true;
319     }
320 
321 }
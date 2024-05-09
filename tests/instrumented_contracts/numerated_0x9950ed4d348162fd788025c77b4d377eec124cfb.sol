1 // solium-disable linebreak-style
2 pragma solidity ^0.4.24;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11     // Owner's address
12     address public owner;
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     constructor() public {
19         owner = msg.sender;
20     }
21 
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param _newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address _newOwner) public onlyOwner {
35         require(_newOwner != address(0));
36         emit OwnerChanged(owner, _newOwner);
37         owner = _newOwner;
38     }
39 
40     event OwnerChanged(address indexed previousOwner,address indexed newOwner);
41 }
42 
43 /**
44  * @title ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/20
46  */
47 interface IERC20 {
48   function totalSupply() external view returns (uint256);
49 
50   function balanceOf(address who) external view returns (uint256);
51 
52   function allowance(address owner, address spender)
53     external view returns (uint256);
54 
55   function transfer(address to, uint256 value) external returns (bool);
56 
57   function approve(address spender, uint256 value)
58     external returns (bool);
59 
60   function transferFrom(address from, address to, uint256 value)
61     external returns (bool);
62 
63   event Transfer(
64     address indexed from,
65     address indexed to,
66     uint256 value
67   );
68 
69   event Approval(
70     address indexed owner,
71     address indexed spender,
72     uint256 value
73   );
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that revert on error
79  */
80 library SafeMath {
81 
82   /**
83   * @dev Multiplies two numbers, reverts on overflow.
84   */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87       // benefit is lost if 'b' is also tested.
88       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b);
95 
96         return c;
97     }
98 
99   /**
100   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
101   */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b > 0); // Solidity only automatically asserts when dividing by 0
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110   /**
111   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112   */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b <= a);
115         uint256 c = a - b;
116 
117         return c;
118     }
119 
120   /**
121   * @dev Adds two numbers, reverts on overflow.
122   */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a);
126 
127         return c;
128     }
129 
130   /**
131   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
132   * reverts when dividing by zero.
133   */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b != 0);
136         return a % b;
137     }
138 }
139 
140 contract AoraTgeCoin is IERC20, Ownable {
141     using SafeMath for uint256;
142 
143     // Name of the token
144     string public constant name = "Aora TGE Coin"; 
145     
146     // Symbol of the token
147     string public constant symbol = "AORATGE";
148 
149     // Number of decimals for the token
150     uint8 public constant decimals = 18;
151     
152     uint constant private _totalSupply = 650000000 ether;
153 
154     // Contract deployment block
155     uint256 public deploymentBlock;
156 
157     // Address of the convertContract
158     address public convertContract = address(0);
159 
160     // Address of the crowdsaleContract
161     address public crowdsaleContract = address(0);
162 
163     // Token balances 
164     mapping (address => uint) balances;
165 
166     /**
167     * @dev Sets the convertContract address. 
168     *   In the future, there will be a need to convert Aora TGE Coins to Aora Coins. 
169     *   That will be done using the Convert contract which will be deployed in the future.
170     *   Convert contract will do the functions of converting Aora TGE Coins to Aora Coins
171     *   and enforcing vesting rules. 
172     * @param _convert address of the convert contract.
173     */
174     function setConvertContract(address _convert) external onlyOwner {
175         require(address(0) != address(_convert));
176         convertContract = _convert;
177         emit OnConvertContractSet(_convert);
178     }
179 
180     /** 
181     * @dev Sets the crowdsaleContract address.
182     *   transfer function is modified in a way that only owner and crowdsale can call it.
183     *   That is done because crowdsale will sell the tokens, and owner will be allowed
184     *   to assign AORATGE to addresses in a way that matches the Aora business model.
185     * @param _crowdsale address of the crowdsale contract.
186     */
187     function setCrowdsaleContract(address _crowdsale) external onlyOwner {
188         require(address(0) != address(_crowdsale));
189         crowdsaleContract = _crowdsale;
190         emit OnCrowdsaleContractSet(_crowdsale);
191     }
192 
193     /**
194     * @dev only convert contract can call the modified function
195     */
196     modifier onlyConvert {
197         require(msg.sender == convertContract);
198         _;
199     }
200 
201     constructor() public {
202         balances[msg.sender] = _totalSupply;
203         deploymentBlock = block.number;
204     }
205 
206     function totalSupply() external view returns (uint256) {
207         return _totalSupply;
208     }
209 
210     function balanceOf(address who) external view returns (uint256) {
211         return balances[who];
212     }
213 
214     function allowance(address owner, address spender) external view returns (uint256) {
215         require(false);
216         return 0;
217     }
218 
219     /**
220     * @dev Transfer token for a specified address.
221     *   Only callable by the owner or crowdsale contract, to prevent token trading.
222     *   AORA will be a tradable token. AORATGE will be exchanged for AORA in 1-1 ratio. 
223     * @param _to The address to transfer to.
224     * @param _value The amount to be transferred.
225     */
226     function transfer(address _to, uint256 _value) public returns (bool) {
227         require(msg.sender == owner || msg.sender == crowdsaleContract);
228 
229         require(_value <= balances[msg.sender]);
230         require(_to != address(0));
231 
232         balances[msg.sender] = balances[msg.sender].sub(_value);
233         balances[_to] = balances[_to].add(_value);
234         emit Transfer(msg.sender, _to, _value);
235         return true;
236     }
237 
238     function approve(address spender, uint256 value) external returns (bool) {
239         require(false);
240         return false;
241     }
242 
243     /**
244     * @dev Transfer tokens from one address to another. 
245     *   Only callable by the convert contract. Used in the process of converting 
246     *   AORATGE to AORA. Will be called from convert contracts convert() function.
247     * @param _from address The address which you want to send tokens from
248     * @param _to address The address which you want to transfer to. 
249     *   Only 0x0 address, because of a need to prevent token recycling. 
250     * @param _value uint256 the amount of tokens to be transferred
251     */
252     function transferFrom(
253         address _from,
254         address _to,
255         uint256 _value
256     ) onlyConvert public returns (bool) {
257         require(_value <= balances[_from]);
258         require(_to == address(0));
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262         emit Transfer(_from, _to, _value);
263         return true;
264     }
265 
266     /**
267     * @dev Fallback function. Can't send ether to this contract. 
268     */
269     function () external payable {
270         revert();
271     }
272 
273     /**
274     * @dev This method can be used by the owner to extract mistakenly sent tokens
275     * or Ether sent to this contract.
276     * @param _token address The address of the token contract that you want to
277     * recover set to 0 in case you want to extract ether. It can't be ElpisToken.
278     */
279     function claimTokens(address _token) public onlyOwner {
280         if (_token == address(0)) {
281             owner.transfer(address(this).balance);
282             return;
283         }
284 
285         IERC20 tokenReference = IERC20(_token);
286         uint balance = tokenReference.balanceOf(address(this));
287         tokenReference.transfer(owner, balance);
288         emit OnClaimTokens(_token, owner, balance);
289     }
290 
291     /**
292     * @param crowdsaleAddress crowdsale contract address
293     */
294     event OnCrowdsaleContractSet(address indexed crowdsaleAddress);
295 
296     /**
297     * @param convertAddress crowdsale contract address
298     */
299     event OnConvertContractSet(address indexed convertAddress);
300 
301     /**
302     * @param token claimed token
303     * @param owner who owns the contract
304     * @param amount amount of the claimed token
305     */
306     event OnClaimTokens(address indexed token, address indexed owner, uint256 amount);
307 }
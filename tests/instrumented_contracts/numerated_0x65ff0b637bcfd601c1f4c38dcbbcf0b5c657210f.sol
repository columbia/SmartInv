1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72   function totalSupply() external view returns (uint256);
73 
74   function balanceOf(address _who) external view returns (uint256);
75 
76   function allowance(address _owner, address _spender)
77     external view returns (uint256);
78 
79   function transfer(address _to, uint256 _value) external returns (bool);
80 
81   function approve(address _spender, uint256 _value)
82     external returns (bool);
83 
84   function transferFrom(address _from, address _to, uint256 _value)
85     external returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 contract StandardToken is IERC20 {
101     using SafeMath for uint256;
102 
103     mapping(address => uint256) balances;
104 
105     mapping (address => mapping (address => uint256)) internal allowed;
106 
107     uint256 totalSupply_;
108 
109     /**
110     * @dev Total number of tokens in existence
111     */
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115 
116     function balanceOf(address _owner) public view returns (uint256) {
117         return balances[_owner];
118     }
119 
120     function allowance(
121         address _owner,
122         address _spender
123     )
124         public
125         view
126         returns (uint256)
127     {
128         return allowed[_owner][_spender];
129     }
130 
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         require(_value <= balances[msg.sender]);
133         require(_to != address(0));
134 
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         emit Transfer(msg.sender, _to, _value);
138         return true;
139     }
140 
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     function transferFrom(
148         address _from,
149         address _to,
150         uint256 _value
151     )
152         public
153         returns (bool)
154     {
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157         require(_to != address(0));
158 
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         emit Transfer(_from, _to, _value);
163         return true;
164     }
165 }
166 
167 /**
168  * @title Ownable
169  * @dev The Ownable contract has an owner address, and provides basic authorization control
170  * functions, this simplifies the implementation of "user permissions".
171  */
172 contract Ownable {
173     address public owner;
174 
175     event OwnershipTransferred(
176         address indexed previousOwner,
177         address indexed newOwner
178     );
179 
180     /**
181     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182     * account.
183     */
184     constructor() public {
185         owner = msg.sender;
186     }
187 
188     /**
189     * @dev Throws if called by any account other than the owner.
190     */
191     modifier onlyOwner() {
192         require(msg.sender == owner);
193         _;
194     }
195 
196 
197     /**
198     * @dev Allows the current owner to transfer control of the contract to a newOwner.
199     * @param _newOwner The address to transfer ownership to.
200     */
201     function transferOwnership(address _newOwner) public onlyOwner {
202         _transferOwnership(_newOwner);
203     }
204 
205     /**
206     * @dev Transfers control of the contract to a newOwner.
207     * @param _newOwner The address to transfer ownership to.
208     */
209     function _transferOwnership(address _newOwner) internal {
210         require(_newOwner != address(0));
211         emit OwnershipTransferred(owner, _newOwner);
212         owner = _newOwner;
213     }
214 }
215 contract OleCoin is StandardToken, Ownable {
216 
217     event tokenComprado(address comprador);
218     
219     
220     string public constant name = "OleCoin";
221     string public constant symbol = "OLE";
222     uint8 public constant decimals = 18;
223     
224     uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(decimals));
225     
226     event tokenBought(address adr);
227     
228     uint256 tokenPrice;    
229 
230     constructor() public payable{
231         totalSupply_ = INITIAL_SUPPLY;
232         balances[msg.sender] = INITIAL_SUPPLY;
233         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
234         tokenPrice = 100000000000000 wei;
235     }
236     
237     function() public payable {
238         emit tokenComprado(msg.sender);
239     }
240 
241     function getBalance() public view returns(uint256) {
242         return address(this).balance;
243     }
244 
245     function setPrice(uint256 _priceToken) public onlyOwner {
246         tokenPrice = _priceToken;
247     }
248     function saque() public onlyOwner {
249         address(owner).transfer(getBalance());
250     }
251         
252     function comprarTokens(uint256 qtd) public payable {
253         require(qtd > 0);
254         //require(msg.value > 0);
255         require(msg.value == (qtd * tokenPrice));
256         qtd = qtd * (10 ** uint256(decimals));
257         balances[owner] = balances[owner].sub(qtd);
258         balances[msg.sender] = balances[msg.sender].add(qtd);
259         address(this).transfer(msg.value);
260         emit Transfer(owner, msg.sender, qtd);
261     }
262     
263 }
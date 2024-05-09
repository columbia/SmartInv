1 pragma solidity ^0.5.3 <0.6.0;
2 
3 
4 
5   contract Ownable {
6     address private _owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     constructor () internal {
15         _owner = msg.sender;
16         emit OwnershipTransferred(address(0), _owner);
17     }
18 
19     /**
20      * @return the address of the owner.
21      */
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(isOwner());
31         _;
32     }
33 
34     /**
35      * @return true if `msg.sender` is the owner of the contract.
36      */
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40 
41     /**
42      * @dev Allows the current owner to relinquish control of the contract.
43      * @notice Renouncing to ownership will leave the contract without an owner.
44      * It will not be possible to call the functions with the `onlyOwner`
45      * modifier anymore.
46      */
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipTransferred(_owner, address(0));
49         _owner = address(0);
50     }
51 
52     /**
53      * @dev Allows the current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner) public onlyOwner {
57         _transferOwnership(newOwner);
58     }
59 
60     /**
61      * @dev Transfers control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function _transferOwnership(address newOwner) internal {
65         require(newOwner != address(0));
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 
71 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
72 
73 /**
74  * @title SafeMath
75  * @dev Unsigned math operations with safety checks that revert on error
76  */
77 library SafeMath {
78     /**
79      * @dev Multiplies two unsigned integers, reverts on overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b);
91 
92         return c;
93     }
94 
95     /**
96      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     /**
108      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b <= a);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Adds two unsigned integers, reverts on overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a);
123 
124         return c;
125     }
126 
127     /**
128      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
129      * reverts when dividing by zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0);
133         return a % b;
134     }
135 }
136 contract SimpleToken is Ownable {
137     using SafeMath for uint256;
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     mapping (address => uint256) private _balances;
142 
143     uint256 private _totalSupply;
144 
145     /**
146      * @dev Total number of tokens in existence
147      */
148     function totalSupply() public view returns (uint256) {
149         return _totalSupply;
150     }
151 
152     /**
153      * @dev Gets the balance of the specified address.
154      * @param owner The address to query the balance of.
155      * @return An uint256 representing the amount owned by the passed address.
156      */
157     function balanceOf(address owner) public view returns (uint256) {
158         return _balances[owner];
159     }
160 
161     /**
162      * @dev Transfer token for a specified address
163      * @param to The address to transfer to.
164      * @param value The amount to be transferred.
165      */
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171 
172     /**
173      * @dev Transfer token for a specified addresses
174      * @param from The address to transfer from.
175      * @param to The address to transfer to.
176      * @param value The amount to be transferred.
177      */
178     function _transfer(address from, address to, uint256 value) internal {
179         require(to != address(0));
180         require(value <= _balances[from]); // Check there is enough balance.
181 
182         _balances[from] = _balances[from].sub(value);
183         _balances[to] = _balances[to].add(value);
184         emit Transfer(from, to, value);
185     }
186 
187     /**
188      * @dev public function that mints an amount of the token and assigns it to
189      * an account. This encapsulates the modification of balances such that the
190      * proper events are emitted.
191      * @param account The account that will receive the created tokens.
192      * @param value The amount that will be created.
193      */
194     function _mint(address account, uint256 value) internal {
195         require(account != address(0));
196 
197         _totalSupply = _totalSupply.add(value);
198         _balances[account] = _balances[account].add(value);
199         emit Transfer(address(0), account, value);
200     }
201 }
202 contract FiatContract {
203   function USD(uint _id) public pure returns (uint256);
204 }
205 
206 contract RealToken is Ownable, SimpleToken {
207   FiatContract public price;
208     
209   using SafeMath for uint256;
210 
211   string public constant name = "DreamPot Token";
212   string public constant symbol = "DPT";
213   uint32 public constant decimals = 0;
214 
215   address payable public ethOwner;
216 
217   uint256 public factor;
218 
219   event GetEth(address indexed from, uint256 value);
220 
221   constructor() public {
222     price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
223     ethOwner = address(uint160(owner()));
224     factor = 100;
225   }
226 
227   function setEthOwner(address newOwner) public onlyOwner {
228     require(newOwner != address(0));
229     ethOwner = address(uint160(newOwner));
230   }
231 
232   function setFactor(uint256 newFactor) public onlyOwner {
233     factor = newFactor;
234   }
235   
236   // Calcs mint tokens
237   function calcTokens(uint256 weivalue) public view returns(uint256) {
238     uint256 ethCent = price.USD(0);
239     uint256 usdv = ethCent.div(1000);
240     usdv = usdv.mul(factor);
241     return weivalue.div(usdv);
242   }
243 
244   function() external payable {
245     uint256 tokens = calcTokens(msg.value);
246     ethOwner.transfer(msg.value);
247     emit GetEth(msg.sender, msg.value);
248     _mint(msg.sender, tokens);
249   }
250 }
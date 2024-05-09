1 pragma solidity ^0.5.2 <0.6.0; contract Ownable {
2     address private _owner;
3 
4     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5 
6     /**
7      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8      * account.
9      */
10     constructor () internal {
11         _owner = msg.sender;
12         emit OwnershipTransferred(address(0), _owner);
13     }
14 
15     /**
16      * @return the address of the owner.
17      */
18     function owner() public view returns (address) {
19         return _owner;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(isOwner());
27         _;
28     }
29 
30     /**
31      * @return true if `msg.sender` is the owner of the contract.
32      */
33     function isOwner() public view returns (bool) {
34         return msg.sender == _owner;
35     }
36 
37     /**
38      * @dev Allows the current owner to relinquish control of the contract.
39      * @notice Renouncing to ownership will leave the contract without an owner.
40      * It will not be possible to call the functions with the `onlyOwner`
41      * modifier anymore.
42      */
43     function renounceOwnership() public onlyOwner {
44         emit OwnershipTransferred(_owner, address(0));
45         _owner = address(0);
46     }
47 
48     /**
49      * @dev Allows the current owner to transfer control of the contract to a newOwner.
50      * @param newOwner The address to transfer ownership to.
51      */
52     function transferOwnership(address newOwner) public onlyOwner {
53         _transferOwnership(newOwner);
54     }
55 
56     /**
57      * @dev Transfers control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function _transferOwnership(address newOwner) internal {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(_owner, newOwner);
63         _owner = newOwner;
64     }
65 }
66 library SafeMath {
67     /**
68      * @dev Multiplies two unsigned integers, reverts on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     /**
85      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118      * reverts when dividing by zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 contract SimpleToken is Ownable {
126     using SafeMath for uint256;
127 
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     mapping (address => uint256) private _balances;
131 
132     uint256 private _totalSupply;
133 
134     /**
135      * @dev Total number of tokens in existence
136      */
137     function totalSupply() public view returns (uint256) {
138         return _totalSupply;
139     }
140 
141     /**
142      * @dev Gets the balance of the specified address.
143      * @param owner The address to query the balance of.
144      * @return An uint256 representing the amount owned by the passed address.
145      */
146     function balanceOf(address owner) public view returns (uint256) {
147         return _balances[owner];
148     }
149 
150     /**
151      * @dev Transfer token for a specified address
152      * @param to The address to transfer to.
153      * @param value The amount to be transferred.
154      */
155     function transfer(address to, uint256 value) public returns (bool) {
156         _transfer(msg.sender, to, value);
157         return true;
158     }
159 
160 
161     /**
162      * @dev Transfer token for a specified addresses
163      * @param from The address to transfer from.
164      * @param to The address to transfer to.
165      * @param value The amount to be transferred.
166      */
167     function _transfer(address from, address to, uint256 value) internal {
168         require(to != address(0));
169         require(value <= _balances[from]); // Check there is enough balance.
170 
171         _balances[from] = _balances[from].sub(value);
172         _balances[to] = _balances[to].add(value);
173         emit Transfer(from, to, value);
174     }
175 
176     /**
177      * @dev public function that mints an amount of the token and assigns it to
178      * an account. This encapsulates the modification of balances such that the
179      * proper events are emitted.
180      * @param account The account that will receive the created tokens.
181      * @param value The amount that will be created.
182      */
183     function _mint(address account, uint256 value) internal {
184         require(account != address(0));
185 
186         _totalSupply = _totalSupply.add(value);
187         _balances[account] = _balances[account].add(value);
188         emit Transfer(address(0), account, value);
189     }
190 }
191 contract FiatContract {
192   function USD(uint _id) public pure returns (uint256);
193 }
194 
195 contract RealToken is Ownable, SimpleToken {
196   FiatContract public price;
197     
198   using SafeMath for uint256;
199 
200   string public constant name = "DreamPot Token";
201   string public constant symbol = "DP";
202   uint32 public constant decimals = 0;
203 
204   address payable public ethOwner;
205 
206   uint256 public factor;
207 
208   event GetEth(address indexed from, uint256 value);
209 
210   constructor() public {
211     price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
212     ethOwner = address(uint160(owner()));
213     factor = 10;
214   }
215 
216   function setEthOwner(address newOwner) public onlyOwner {
217     require(newOwner != address(0));
218     ethOwner = address(uint160(newOwner));
219   }
220 
221   function setFactor(uint256 newFactor) public onlyOwner {
222     factor = newFactor;
223   }
224   
225   // Calcs mint tokens
226   function calcTokens(uint256 weivalue) public view returns(uint256) {
227     uint256 ethCent = price.USD(0);
228     uint256 usdv = ethCent.div(factor);
229     return weivalue.div(usdv);
230   }
231 
232   function() external payable {
233     uint256 tokens = calcTokens(msg.value);
234     ethOwner.transfer(msg.value);
235     emit GetEth(msg.sender, msg.value);
236     _mint(msg.sender, tokens);
237   }
238 }
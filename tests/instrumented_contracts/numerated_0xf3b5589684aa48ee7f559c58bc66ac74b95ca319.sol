1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipRenounced(address indexed previousOwner);
44   event OwnershipTransferred(
45     address indexed previousOwner,
46     address indexed newOwner
47   );
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 contract Escrow is Ownable {
144     using SafeMath for uint256;
145     struct EscrowElement {
146     bool exists;
147     address src;
148     address dst;
149     uint256 value;
150     }
151 
152     address public token;
153     ERC20 public tok;
154 
155     mapping (bytes20 => EscrowElement) public escrows;
156 
157     /* Numerator and denominator of common fraction.
158         E.g. 1 & 25 mean one twenty fifths, i.e. 0.04 = 4% */
159     uint256 public escrow_fee_numerator; /* 1 */
160     uint256 public escrow_fee_denominator; /* 25 */
161 
162 
163 
164     event EscrowStarted(
165     bytes20 indexed escrow_id,
166     EscrowElement escrow_element
167     );
168 
169     event EscrowReleased(
170     bytes20 indexed escrow_id,
171     EscrowElement escrow_element
172     );
173 
174     event EscrowCancelled(
175     bytes20 indexed escrow_id,
176     EscrowElement escrow_element
177     );
178 
179 
180     event TokenSet(
181     address indexed token
182     );
183 
184     event Withdrawed(
185     address indexed dst,
186     uint256 value
187     );
188 
189     function Escrow(address _token){
190         token = _token;
191         tok = ERC20(_token);
192         escrow_fee_numerator = 1;
193         escrow_fee_denominator = 25;
194     }
195 
196     function startEscrow(bytes20 escrow_id, address to, uint256 value) public returns (bool) {
197         require(to != address(0));
198         require(escrows[escrow_id].exists != true);
199 //        ERC20 tok = ERC20(token);
200         tok.transferFrom(msg.sender, address(this), value);
201         EscrowElement memory escrow_element = EscrowElement(true, msg.sender, to, value);
202         escrows[escrow_id] = escrow_element;
203 
204         emit EscrowStarted(escrow_id, escrow_element);
205 
206         return true;
207     }
208 
209     function releaseEscrow(bytes20 escrow_id, address fee_destination) onlyOwner returns (bool) {
210         require(fee_destination != address(0));
211         require(escrows[escrow_id].exists == true);
212 
213         EscrowElement storage escrow_element = escrows[escrow_id];
214 
215         uint256 fee = escrow_element.value.mul(escrow_fee_numerator).div(escrow_fee_denominator);
216         uint256 value = escrow_element.value.sub(fee);
217 
218 //        ERC20 tok = ERC20(token);
219 
220         tok.transfer(escrow_element.dst, value);
221         tok.transfer(fee_destination, fee);
222 
223 
224         EscrowElement memory _escrow_element = escrow_element;
225 
226         emit EscrowReleased(escrow_id, _escrow_element);
227 
228         delete escrows[escrow_id];
229 
230         return true;
231     }
232 
233     function cancelEscrow(bytes20 escrow_id) onlyOwner returns (bool) {
234         EscrowElement storage escrow_element = escrows[escrow_id];
235 
236 //        ERC20 tok = ERC20(token);
237 
238         tok.transfer(escrow_element.src, escrow_element.value);
239         /* Workaround because of lack of feature. See https://github.com/ethereum/solidity/issues/3577 */
240         EscrowElement memory _escrow_element = escrow_element;
241 
242 
243         emit EscrowCancelled(escrow_id, _escrow_element);
244 
245         delete escrows[escrow_id];
246 
247         return true;
248     }
249 
250     function withdrawToken(address dst, uint256 value) onlyOwner returns (bool){
251         require(dst != address(0));
252         require(value > 0);
253 //        ERC20 tok = ERC20(token);
254         tok.transfer(dst, value);
255 
256         emit Withdrawed(dst, value);
257 
258         return true;
259     }
260 
261     function setToken(address _token) onlyOwner returns (bool){
262         require(_token != address(0));
263         token = _token;
264         tok = ERC20(_token);
265         emit TokenSet(_token);
266 
267         return true;
268     }
269     //
270 
271 
272 }
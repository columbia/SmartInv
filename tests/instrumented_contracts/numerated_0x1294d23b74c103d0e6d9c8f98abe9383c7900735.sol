1 pragma solidity 0.4.24;
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
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**ERC20OldBasic.sol
26  * @title ERC20Basic
27  * @dev Simpler version of ERC20 interface
28  */
29 contract ERC20OldBasic {
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public;
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 /**
37  * @title ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20Old is ERC20OldBasic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public;
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 /**
139  * @title Ownable
140  * @dev The Ownable contract has an owner address, and provides basic authorization control
141  * functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144   address public owner;
145 
146 
147   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   function Ownable() public {
155     owner = msg.sender;
156   }
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyOwner() {
162     require(msg.sender == owner);
163     _;
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) public onlyOwner {
171     require(newOwner != address(0));
172     OwnershipTransferred(owner, newOwner);
173     owner = newOwner;
174   }
175 
176 }
177 
178 /*
179 
180 Copyright Will Harborne (Ethfinex) 2017
181 
182 */
183 
184 contract WrapperLockEth is BasicToken, Ownable {
185     using SafeMath for uint256;
186 
187     address public TRANSFER_PROXY;
188     mapping (address => bool) private isSigner;
189 
190     string public name;
191     string public symbol;
192     uint public decimals;
193     address public originalToken = 0x00;
194 
195     mapping (address => uint) public depositLock;
196     mapping (address => uint256) public balances;
197 
198     function WrapperLockEth(string _name, string _symbol, uint _decimals, address _transferProxy) Ownable() {
199         TRANSFER_PROXY = _transferProxy;
200         name = _name;
201         symbol = _symbol;
202         decimals = _decimals;
203         isSigner[msg.sender] = true;
204     }
205 
206     function deposit(uint _value, uint _forTime) public payable returns (bool success) {
207         require(_forTime >= 1);
208         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
209         balances[msg.sender] = balances[msg.sender].add(msg.value);
210         depositLock[msg.sender] = now + _forTime * 1 hours;
211         return true;
212     }
213 
214     function withdraw(
215         uint8 v,
216         bytes32 r,
217         bytes32 s,
218         uint _value,
219         uint signatureValidUntilBlock
220     )
221         public
222         returns
223         (bool)
224     {
225         require(balanceOf(msg.sender) >= _value);
226         if (now > depositLock[msg.sender]) {
227             balances[msg.sender] = balances[msg.sender].sub(_value);
228             msg.sender.transfer(_value);
229         } else {
230             require(block.number < signatureValidUntilBlock);
231             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
232             balances[msg.sender] = balances[msg.sender].sub(_value);
233             msg.sender.transfer(_value);
234         }
235         return true;
236     }
237 
238     function withdrawDifferentToken(address _token, bool _erc20old) public onlyOwner returns (bool) {
239         require(ERC20(_token).balanceOf(address(this)) > 0);
240         if (_erc20old) {
241             ERC20Old(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
242         } else {
243             ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
244         }
245         return true;
246     }
247 
248     function transfer(address _to, uint256 _value) public returns (bool) {
249         return false;
250     }
251 
252     function transferFrom(address _from, address _to, uint _value) public {
253         assert(msg.sender == TRANSFER_PROXY);
254         balances[_to] = balances[_to].add(_value);
255         balances[_from] = balances[_from].sub(_value);
256         Transfer(_from, _to, _value);
257     }
258 
259     function allowance(address _owner, address _spender) public constant returns (uint) {
260         if (_spender == TRANSFER_PROXY) {
261             return 2**256 - 1;
262         }
263     }
264 
265     function balanceOf(address _owner) public constant returns (uint256) {
266         return balances[_owner];
267     }
268 
269     function isValidSignature(
270         bytes32 hash,
271         uint8 v,
272         bytes32 r,
273         bytes32 s)
274         public
275         constant
276         returns (bool)
277     {
278         return isSigner[ecrecover(
279             keccak256("\x19Ethereum Signed Message:\n32", hash),
280             v,
281             r,
282             s
283         )];
284     }
285 
286     function addSigner(address _newSigner) public {
287         require(isSigner[msg.sender]);
288         isSigner[_newSigner] = true;
289     }
290 
291     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
292         return keccak256(_sender, _wrapper, _validTill);
293     }
294 }
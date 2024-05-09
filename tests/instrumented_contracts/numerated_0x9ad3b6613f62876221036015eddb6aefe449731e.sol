1 pragma solidity ^0.4.24;
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
184 contract WrapperLock is BasicToken, Ownable {
185     using SafeMath for uint256;
186 
187 
188     address public TRANSFER_PROXY;
189     mapping (address => bool) private isSigner;
190 
191     bool public erc20old;
192     string public name;
193     string public symbol;
194     uint public decimals;
195     address public originalToken;
196 
197     mapping (address => uint256) public depositLock;
198     mapping (address => uint256) public balances;
199 
200     function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, address _transferProxy, bool _erc20old) Ownable() {
201         originalToken = _originalToken;
202         TRANSFER_PROXY = _transferProxy;
203         name = _name;
204         symbol = _symbol;
205         decimals = _decimals;
206         isSigner[msg.sender] = true;
207         erc20old = _erc20old;
208     }
209 
210     function deposit(uint _value, uint _forTime) public returns (bool success) {
211         require(_forTime >= 1);
212         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
213         if (erc20old) {
214             ERC20Old(originalToken).transferFrom(msg.sender, address(this), _value);
215         } else {
216             require(ERC20(originalToken).transferFrom(msg.sender, address(this), _value));
217         }
218         balances[msg.sender] = balances[msg.sender].add(_value);
219         totalSupply_ = totalSupply_.add(_value);
220         depositLock[msg.sender] = now + _forTime * 1 hours;
221         return true;
222     }
223 
224     function withdraw(
225         uint8 v,
226         bytes32 r,
227         bytes32 s,
228         uint _value,
229         uint signatureValidUntilBlock
230     )
231         public
232         returns
233         (bool success)
234     {
235         require(balanceOf(msg.sender) >= _value);
236         if (now <= depositLock[msg.sender]) {
237             require(block.number < signatureValidUntilBlock);
238             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
239         }
240         balances[msg.sender] = balances[msg.sender].sub(_value);
241         totalSupply_ = totalSupply_.sub(_value);
242         if (erc20old) {
243             ERC20Old(originalToken).transfer(msg.sender, _value);
244         } else {
245             require(ERC20(originalToken).transfer(msg.sender, _value));
246         }
247         return true;
248     }
249 
250     function withdrawBalanceDifference() public onlyOwner returns (bool success) {
251         require(ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_) > 0);
252         if (erc20old) {
253             ERC20Old(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_));
254         } else {
255             require(ERC20(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_)));
256         }
257         return true;
258     }
259 
260     function withdrawDifferentToken(address _differentToken, bool _erc20old) public onlyOwner returns (bool) {
261         require(_differentToken != originalToken);
262         require(ERC20(_differentToken).balanceOf(address(this)) > 0);
263         if (_erc20old) {
264             ERC20Old(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this)));
265         } else {
266             require(ERC20(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this))));
267         }
268         return true;
269     }
270 
271     function transfer(address _to, uint256 _value) public returns (bool) {
272         return false;
273     }
274 
275     function transferFrom(address _from, address _to, uint _value) public {
276         assert(msg.sender == TRANSFER_PROXY);
277         balances[_to] = balances[_to].add(_value);
278         balances[_from] = balances[_from].sub(_value);
279         Transfer(_from, _to, _value);
280     }
281 
282     function allowance(address _owner, address _spender) public constant returns (uint) {
283         if (_spender == TRANSFER_PROXY) {
284             return 2**256 - 1;
285         }
286     }
287 
288     function balanceOf(address _owner) public constant returns (uint256) {
289         return balances[_owner];
290     }
291 
292     function isValidSignature(
293         bytes32 hash,
294         uint8 v,
295         bytes32 r,
296         bytes32 s
297     )
298         public
299         constant
300         returns (bool)
301     {
302         return isSigner[ecrecover(
303             keccak256("\x19Ethereum Signed Message:\n32", hash),
304             v,
305             r,
306             s
307         )];
308     }
309 
310     function addSigner(address _newSigner) public {
311         require(isSigner[msg.sender]);
312         isSigner[_newSigner] = true;
313     }
314 
315     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
316         return keccak256(_sender, _wrapper, _validTill);
317     }
318 
319 }
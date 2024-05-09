1 pragma solidity 0.4.24;
2 
3 /**ERC20OldBasic.sol
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20OldBasic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public;
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 
28 /**
29  * @title ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/20
31  */
32 contract ERC20Old is ERC20OldBasic {
33   function allowance(address owner, address spender) public view returns (uint256);
34   function transferFrom(address from, address to, uint256 value) public;
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   /**
68   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   function Ownable() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to transfer control of the contract to a newOwner.
116    * @param newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address newOwner) public onlyOwner {
119     require(newOwner != address(0));
120     OwnershipTransferred(owner, newOwner);
121     owner = newOwner;
122   }
123 
124 }
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * @dev total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 
185 
186 
187 /*
188 
189   Copyright Ethfinex Inc 2018
190 
191   Licensed under the Apache License, Version 2.0
192   http://www.apache.org/licenses/LICENSE-2.0
193 
194 */
195 
196 
197 contract WrapperLock is BasicToken, Ownable {
198     using SafeMath for uint256;
199 
200     address public TRANSFER_PROXY_VEFX = 0xdcDb42C9a256690bd153A7B409751ADFC8Dd5851;
201     address public TRANSFER_PROXY_V2 = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
202     mapping (address => bool) public isSigner;
203 
204     bool public erc20old;
205     string public name;
206     string public symbol;
207     uint public decimals;
208     address public originalToken;
209 
210     mapping (address => uint256) public depositLock;
211     mapping (address => uint256) public balances;
212 
213     function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, bool _erc20old) Ownable() {
214         originalToken = _originalToken;
215         name = _name;
216         symbol = _symbol;
217         decimals = _decimals;
218         isSigner[msg.sender] = true;
219         erc20old = _erc20old;
220     }
221 
222     function deposit(uint _value, uint _forTime) public returns (bool success) {
223         require(_forTime >= 1);
224         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
225         if (erc20old) {
226             ERC20Old(originalToken).transferFrom(msg.sender, address(this), _value);
227         } else {
228             require(ERC20(originalToken).transferFrom(msg.sender, address(this), _value));
229         }
230         balances[msg.sender] = balances[msg.sender].add(_value);
231         totalSupply_ = totalSupply_.add(_value);
232         depositLock[msg.sender] = now + _forTime * 1 hours;
233         return true;
234     }
235 
236     function withdraw(
237         uint _value,
238         uint8 v,
239         bytes32 r,
240         bytes32 s,
241         uint signatureValidUntilBlock
242     )
243         public
244         returns
245         (bool success)
246     {
247         require(balanceOf(msg.sender) >= _value);
248         if (now <= depositLock[msg.sender]) {
249             require(block.number < signatureValidUntilBlock);
250             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
251         }
252         balances[msg.sender] = balances[msg.sender].sub(_value);
253         totalSupply_ = totalSupply_.sub(_value);
254         depositLock[msg.sender] = 0;
255         if (erc20old) {
256             ERC20Old(originalToken).transfer(msg.sender, _value);
257         } else {
258             require(ERC20(originalToken).transfer(msg.sender, _value));
259         }
260         return true;
261     }
262 
263     function withdrawBalanceDifference() public onlyOwner returns (bool success) {
264         require(ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_) > 0);
265         if (erc20old) {
266             ERC20Old(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_));
267         } else {
268             require(ERC20(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_)));
269         }
270         return true;
271     }
272 
273     function withdrawDifferentToken(address _differentToken, bool _erc20old) public onlyOwner returns (bool) {
274         require(_differentToken != originalToken);
275         require(ERC20(_differentToken).balanceOf(address(this)) > 0);
276         if (_erc20old) {
277             ERC20Old(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this)));
278         } else {
279             require(ERC20(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this))));
280         }
281         return true;
282     }
283 
284     function transfer(address _to, uint256 _value) public returns (bool) {
285         return false;
286     }
287 
288     function transferFrom(address _from, address _to, uint _value) public {
289         require(isSigner[_to] || isSigner[_from]);
290         assert(msg.sender == TRANSFER_PROXY_VEFX || msg.sender == TRANSFER_PROXY_V2);
291         balances[_to] = balances[_to].add(_value);
292         depositLock[_to] = depositLock[_to] > now ? depositLock[_to] : now + 1 hours;
293         balances[_from] = balances[_from].sub(_value);
294         Transfer(_from, _to, _value);
295     }
296 
297     function allowance(address _owner, address _spender) public constant returns (uint) {
298         if (_spender == TRANSFER_PROXY_VEFX || _spender == TRANSFER_PROXY_V2) {
299             return 2**256 - 1;
300         }
301     }
302 
303     function balanceOf(address _owner) public constant returns (uint256) {
304         return balances[_owner];
305     }
306 
307     function isValidSignature(
308         bytes32 hash,
309         uint8 v,
310         bytes32 r,
311         bytes32 s
312     )
313         public
314         constant
315         returns (bool)
316     {
317         return isSigner[ecrecover(
318             keccak256("\x19Ethereum Signed Message:\n32", hash),
319             v,
320             r,
321             s
322         )];
323     }
324 
325     function addSigner(address _newSigner) public {
326         require(isSigner[msg.sender]);
327         isSigner[_newSigner] = true;
328     }
329 
330     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
331         return keccak256(_sender, _wrapper, _validTill);
332     }
333 
334 }
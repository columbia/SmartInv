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
180   Copyright Ethfinex Inc 2018
181 
182   Licensed under the Apache License, Version 2.0
183   http://www.apache.org/licenses/LICENSE-2.0
184 
185 */
186 
187 contract WrapperLock is BasicToken, Ownable {
188     using SafeMath for uint256;
189 
190     address public TRANSFER_PROXY_VEFX = 0x7e03d2b8edc3585ecd8a5807661fff0830a0b603;
191     address public TRANSFER_PROXY_V2 = 0x2240Dab907db71e64d3E0dbA4800c83B5C502d4E;
192     mapping (address => bool) public isSigner;
193 
194     bool public erc20old;
195     string public name;
196     string public symbol;
197     uint public decimals;
198     address public originalToken;
199 
200     mapping (address => uint256) public depositLock;
201     mapping (address => uint256) public balances;
202 
203     function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, bool _erc20old) Ownable() {
204         originalToken = _originalToken;
205         name = _name;
206         symbol = _symbol;
207         decimals = _decimals;
208         isSigner[msg.sender] = true;
209         erc20old = _erc20old;
210     }
211 
212     function deposit(uint _value, uint _forTime) public returns (bool success) {
213         require(_forTime >= 1);
214         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
215         if (erc20old) {
216             ERC20Old(originalToken).transferFrom(msg.sender, address(this), _value);
217         } else {
218             require(ERC20(originalToken).transferFrom(msg.sender, address(this), _value));
219         }
220         balances[msg.sender] = balances[msg.sender].add(_value);
221         totalSupply_ = totalSupply_.add(_value);
222         depositLock[msg.sender] = now + _forTime * 1 hours;
223         return true;
224     }
225 
226     function withdraw(
227         uint _value,
228         uint8 v,
229         bytes32 r,
230         bytes32 s,
231         uint signatureValidUntilBlock
232     )
233         public
234         returns
235         (bool success)
236     {
237         require(balanceOf(msg.sender) >= _value);
238         if (now <= depositLock[msg.sender]) {
239             require(block.number < signatureValidUntilBlock);
240             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
241         }
242         balances[msg.sender] = balances[msg.sender].sub(_value);
243         totalSupply_ = totalSupply_.sub(_value);
244         depositLock[msg.sender] = 0;
245         if (erc20old) {
246             ERC20Old(originalToken).transfer(msg.sender, _value);
247         } else {
248             require(ERC20(originalToken).transfer(msg.sender, _value));
249         }
250         return true;
251     }
252 
253     function withdrawBalanceDifference() public onlyOwner returns (bool success) {
254         require(ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_) > 0);
255         if (erc20old) {
256             ERC20Old(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_));
257         } else {
258             require(ERC20(originalToken).transfer(msg.sender, ERC20(originalToken).balanceOf(address(this)).sub(totalSupply_)));
259         }
260         return true;
261     }
262 
263     function withdrawDifferentToken(address _differentToken, bool _erc20old) public onlyOwner returns (bool) {
264         require(_differentToken != originalToken);
265         require(ERC20(_differentToken).balanceOf(address(this)) > 0);
266         if (_erc20old) {
267             ERC20Old(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this)));
268         } else {
269             require(ERC20(_differentToken).transfer(msg.sender, ERC20(_differentToken).balanceOf(address(this))));
270         }
271         return true;
272     }
273 
274     function transfer(address _to, uint256 _value) public returns (bool) {
275         return false;
276     }
277 
278     function transferFrom(address _from, address _to, uint _value) public {
279         require(isSigner[_to] || isSigner[_from]);
280         assert(msg.sender == TRANSFER_PROXY_VEFX || msg.sender == TRANSFER_PROXY_V2);
281         balances[_to] = balances[_to].add(_value);
282         depositLock[_to] = depositLock[_to] > now ? depositLock[_to] : now + 1 hours;
283         balances[_from] = balances[_from].sub(_value);
284         Transfer(_from, _to, _value);
285     }
286 
287     function allowance(address _owner, address _spender) public constant returns (uint) {
288         if (_spender == TRANSFER_PROXY_VEFX || _spender == TRANSFER_PROXY_V2) {
289             return 2**256 - 1;
290         }
291     }
292 
293     function balanceOf(address _owner) public constant returns (uint256) {
294         return balances[_owner];
295     }
296 
297     function isValidSignature(
298         bytes32 hash,
299         uint8 v,
300         bytes32 r,
301         bytes32 s
302     )
303         public
304         constant
305         returns (bool)
306     {
307         return isSigner[ecrecover(
308             keccak256("\x19Ethereum Signed Message:\n32", hash),
309             v,
310             r,
311             s
312         )];
313     }
314 
315     function addSigner(address _newSigner) public {
316         require(isSigner[msg.sender]);
317         isSigner[_newSigner] = true;
318     }
319 
320     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
321         return keccak256(_sender, _wrapper, _validTill);
322     }
323 
324 }
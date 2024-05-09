1 pragma solidity ^0.4.22;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   uint256 totalSupply_;
27 
28   /**
29   * @dev total number of tokens in existence
30   */
31   function totalSupply() public view returns (uint256) {
32     return totalSupply_;
33   }
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     // SafeMath.sub will throw if there is not enough balance.
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84     if (a == 0) {
85       return 0;
86     }
87     uint256 c = a * b;
88     assert(c / a == b);
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers, truncating the quotient.
94   */
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   /**
103   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
104   */
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   /**
111   * @dev Adds two numbers, throws on overflow.
112   */
113   function add(uint256 a, uint256 b) internal pure returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract Ownable {
127   address public owner;
128 
129 
130   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132 
133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    */
137   function Ownable() public {
138     owner = msg.sender;
139   }
140 
141   /**
142    * @dev Throws if called by any account other than the owner.
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0));
155     OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157   }
158 
159 }
160 
161 /*
162 
163 Copyright Will Harborne (Ethfinex) 2017
164 
165 */
166 
167 contract WrapperLock is BasicToken, Ownable {
168     using SafeMath for uint256;
169 
170 
171     address public TRANSFER_PROXY;
172     mapping (address => bool) private isSigner;
173 
174     string public name;
175     string public symbol;
176     uint public decimals;
177     address public originalToken;
178 
179     mapping (address => uint256) public depositLock;
180     mapping (address => uint256) public balances;
181 
182     function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, address _transferProxy) {
183         originalToken = _originalToken;
184         TRANSFER_PROXY = _transferProxy;
185         name = _name;
186         symbol = _symbol;
187         decimals = _decimals;
188         isSigner[msg.sender] = true;
189     }
190 
191     function deposit(uint _value, uint _forTime) public returns (bool success) {
192         require(_forTime >= 1);
193         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
194         require(ERC20(originalToken).transferFrom(msg.sender, this, _value));
195         balances[msg.sender] = balances[msg.sender].add(_value);
196         depositLock[msg.sender] = now + _forTime * 1 hours;
197         return true;
198     }
199 
200     function withdraw(
201         uint8 v,
202         bytes32 r,
203         bytes32 s,
204         uint _value,
205         uint signatureValidUntilBlock
206     )
207         public
208         returns
209         (bool success)
210     {
211         require(balanceOf(msg.sender) >= _value);
212         if (now > depositLock[msg.sender]) {
213             balances[msg.sender] = balances[msg.sender].sub(_value);
214             success = ERC20(originalToken).transfer(msg.sender, _value);
215         } else {
216             require(block.number < signatureValidUntilBlock);
217             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
218             balances[msg.sender] = balances[msg.sender].sub(_value);
219             success = ERC20(originalToken).transfer(msg.sender, _value);
220         }
221         require(success);
222     }
223 
224     function transfer(address _to, uint256 _value) public returns (bool) {
225         return false;
226     }
227 
228     function transferFrom(address _from, address _to, uint _value) public {
229         require(_to == owner || _from == owner);
230         assert(msg.sender == TRANSFER_PROXY);
231         balances[_to] = balances[_to].add(_value);
232         balances[_from] = balances[_from].sub(_value);
233         Transfer(_from, _to, _value);
234     }
235 
236     function allowance(address _owner, address _spender) public constant returns (uint) {
237         if (_spender == TRANSFER_PROXY) {
238             return 2**256 - 1;
239         }
240     }
241 
242     function balanceOf(address _owner) public constant returns (uint256) {
243         return balances[_owner];
244     }
245 
246     function isValidSignature(
247         bytes32 hash,
248         uint8 v,
249         bytes32 r,
250         bytes32 s
251     )
252         public
253         constant
254         returns (bool)
255     {
256         return isSigner[ecrecover(
257             keccak256("\x19Ethereum Signed Message:\n32", hash),
258             v,
259             r,
260             s
261         )];
262     }
263 
264     function addSigner(address _newSigner) public {
265         require(isSigner[msg.sender]);
266         isSigner[_newSigner] = true;
267     }
268 
269     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
270         return keccak256(_sender, _wrapper, _validTill);
271     }
272 
273 }
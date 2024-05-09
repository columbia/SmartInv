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
167 contract WrapperLockEth is BasicToken, Ownable {
168     using SafeMath for uint256;
169 
170     address public TRANSFER_PROXY;
171     mapping (address => bool) private isSigner;
172 
173     string public name;
174     string public symbol;
175     uint public decimals;
176     address public originalToken = 0x00;
177 
178     mapping (address => uint) public depositLock;
179     mapping (address => uint256) public balances;
180 
181     function WrapperLockEth(string _name, string _symbol, uint _decimals, address _transferProxy) {
182         TRANSFER_PROXY = _transferProxy;
183         name = _name;
184         symbol = _symbol;
185         decimals = _decimals;
186         isSigner[msg.sender] = true;
187     }
188 
189     function deposit(uint _value, uint _forTime) public payable returns (bool success) {
190         require(_forTime >= 1);
191         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
192         balances[msg.sender] = balances[msg.sender].add(msg.value);
193         depositLock[msg.sender] = now + _forTime * 1 hours;
194         return true;
195     }
196 
197     function withdraw(
198         uint8 v,
199         bytes32 r,
200         bytes32 s,
201         uint _value,
202         uint signatureValidUntilBlock
203     )
204         public
205         returns
206         (bool)
207     {
208         require(balanceOf(msg.sender) >= _value);
209         if (now > depositLock[msg.sender]) {
210             balances[msg.sender] = balances[msg.sender].sub(_value);
211             msg.sender.transfer(_value);
212         } else {
213             require(block.number < signatureValidUntilBlock);
214             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
215             balances[msg.sender] = balances[msg.sender].sub(_value);
216             msg.sender.transfer(_value);
217         }
218         return true;
219     }
220 
221     function transfer(address _to, uint256 _value) public returns (bool) {
222         return false;
223     }
224 
225     function transferFrom(address _from, address _to, uint _value) public {
226         require(_to == owner || _from == owner);
227         assert(msg.sender == TRANSFER_PROXY);
228         balances[_to] = balances[_to].add(_value);
229         balances[_from] = balances[_from].sub(_value);
230         Transfer(_from, _to, _value);
231     }
232 
233     function allowance(address _owner, address _spender) public constant returns (uint) {
234         if (_spender == TRANSFER_PROXY) {
235             return 2**256 - 1;
236         }
237     }
238 
239     function balanceOf(address _owner) public constant returns (uint256) {
240         return balances[_owner];
241     }
242 
243     function isValidSignature(
244         bytes32 hash,
245         uint8 v,
246         bytes32 r,
247         bytes32 s)
248         public
249         constant
250         returns (bool)
251     {
252         return isSigner[ecrecover(
253             keccak256("\x19Ethereum Signed Message:\n32", hash),
254             v,
255             r,
256             s
257         )];
258     }
259 
260     function addSigner(address _newSigner) public {
261         require(isSigner[msg.sender]);
262         isSigner[_newSigner] = true;
263     }
264 
265     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
266         return keccak256(_sender, _wrapper, _validTill);
267     }
268 }
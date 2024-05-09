1 pragma solidity 0.4.16;
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
62 contract ERC20Interface {
63     function balanceOf(address _owner) public constant returns (uint balance) {}
64     function transfer(address _to, uint _value) public {}
65     function transferFrom(address _from, address _to, uint _value) public {}
66 }
67 
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   /**
98   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256) {
109     uint256 c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122   address public owner;
123 
124 
125   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127 
128   /**
129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130    * account.
131    */
132   function Ownable() public {
133     owner = msg.sender;
134   }
135 
136   /**
137    * @dev Throws if called by any account other than the owner.
138    */
139   modifier onlyOwner() {
140     require(msg.sender == owner);
141     _;
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     require(newOwner != address(0));
150     OwnershipTransferred(owner, newOwner);
151     owner = newOwner;
152   }
153 
154 }
155 
156 /*
157 
158 Copyright Will Harborne (Ethfinex) 2017
159 
160 */
161 
162 contract WrapperLock is BasicToken, Ownable {
163     using SafeMath for uint256;
164 
165 
166     address public TRANSFER_PROXY;
167     mapping (address => bool) private isSigner;
168 
169     string public name;
170     string public symbol;
171     uint public decimals;
172     address public originalToken;
173 
174     mapping (address => uint256) public depositLock;
175     mapping (address => uint256) public balances;
176 
177     function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals, address _transferProxy) {
178         originalToken = _originalToken;
179         TRANSFER_PROXY = _transferProxy;
180         name = _name;
181         symbol = _symbol;
182         decimals = _decimals;
183         isSigner[msg.sender] = true;
184     }
185 
186     function deposit(uint _value, uint _forTime) public returns (bool) {
187         require(_forTime >= 1);
188         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
189         ERC20Interface token = ERC20Interface(originalToken);
190         token.transferFrom(msg.sender, address(this), _value);
191         balances[msg.sender] = balances[msg.sender].add(_value);
192         depositLock[msg.sender] = now + _forTime * 1 hours;
193         return true;
194     }
195 
196     function withdraw(
197         uint8 v,
198         bytes32 r,
199         bytes32 s,
200         uint _value,
201         uint signatureValidUntilBlock
202     )
203         public
204         returns
205         (bool)
206     {
207         require(balanceOf(msg.sender) >= _value);
208         if (now > depositLock[msg.sender]) {
209             balances[msg.sender] = balances[msg.sender].sub(_value);
210             ERC20Interface(originalToken).transfer(msg.sender, _value);
211         } else {
212             require(block.number < signatureValidUntilBlock);
213             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
214             balances[msg.sender] = balances[msg.sender].sub(_value);
215             ERC20Interface(originalToken).transfer(msg.sender, _value);
216         }
217         return true;
218     }
219 
220     function transfer(address _to, uint256 _value) public returns (bool) {
221         return false;
222     }
223 
224     function transferFrom(address _from, address _to, uint _value) public {
225         require(_to == owner || _from == owner);
226         assert(msg.sender == TRANSFER_PROXY);
227         balances[_to] = balances[_to].add(_value);
228         balances[_from] = balances[_from].sub(_value);
229         Transfer(_from, _to, _value);
230     }
231 
232     function allowance(address _owner, address _spender) public constant returns (uint) {
233         if (_spender == TRANSFER_PROXY) {
234             return 2**256 - 1;
235         }
236     }
237 
238     function balanceOf(address _owner) public constant returns (uint256) {
239         return balances[_owner];
240     }
241 
242     function isValidSignature(
243         bytes32 hash,
244         uint8 v,
245         bytes32 r,
246         bytes32 s
247     )
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
268 
269 }
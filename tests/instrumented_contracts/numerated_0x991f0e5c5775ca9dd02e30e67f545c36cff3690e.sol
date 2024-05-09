1 pragma solidity 0.4.19;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60   mapping(address => uint256) balances;
61   uint256 totalSupply_;
62   /**
63   * @dev total number of tokens in existence
64   */
65   function totalSupply() public view returns (uint256) {
66     return totalSupply_;
67   }
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 }
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   function Ownable() public {
104     owner = msg.sender;
105   }
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     require(newOwner != address(0));
119     OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 }
123 /*
124 Copyright Will Harborne (Ethfinex) 2017
125 */
126 contract WrapperLockEth is BasicToken, Ownable {
127     using SafeMath for uint256;
128     address public TRANSFER_PROXY;
129     mapping (address => bool) private isSigner;
130     string public name;
131     string public symbol;
132     uint public decimals;
133     address public originalToken = 0x00;
134     mapping (address => uint) public depositLock;
135     mapping (address => uint256) public balances;
136     function WrapperLockEth(string _name, string _symbol, uint _decimals, address _transferProxy) {
137         TRANSFER_PROXY = _transferProxy;
138         name = _name;
139         symbol = _symbol;
140         decimals = _decimals;
141         isSigner[msg.sender] = true;
142     }
143     function deposit(uint _value, uint _forTime) public payable returns (bool success) {
144         require(_forTime >= 1);
145         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
146         balances[msg.sender] = balances[msg.sender].add(msg.value);
147         depositLock[msg.sender] = now + _forTime * 1 hours;
148         return true;
149     }
150     function withdraw(
151         uint8 v,
152         bytes32 r,
153         bytes32 s,
154         uint _value,
155         uint signatureValidUntilBlock
156     )
157         public
158         returns
159         (bool)
160     {
161         require(balanceOf(msg.sender) >= _value);
162         if (now > depositLock[msg.sender]) {
163             balances[msg.sender] = balances[msg.sender].sub(_value);
164             msg.sender.transfer(_value);
165         } else {
166             require(block.number < signatureValidUntilBlock);
167             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
168             balances[msg.sender] = balances[msg.sender].sub(_value);
169             msg.sender.transfer(_value);
170         }
171         return true;
172     }
173     function transfer(address _to, uint256 _value) public returns (bool) {
174         return false;
175     }
176     function transferFrom(address _from, address _to, uint _value) public {
177         require(_to == owner || _from == owner);
178         assert(msg.sender == TRANSFER_PROXY);
179         balances[_to] = balances[_to].add(_value);
180         balances[_from] = balances[_from].sub(_value);
181         Transfer(_from, _to, _value);
182     }
183     function allowance(address _owner, address _spender) public constant returns (uint) {
184         if (_spender == TRANSFER_PROXY) {
185             return 2**256 - 1;
186         }
187     }
188     function balanceOf(address _owner) public constant returns (uint256) {
189         return balances[_owner];
190     }
191     function isValidSignature(
192         bytes32 hash,
193         uint8 v,
194         bytes32 r,
195         bytes32 s)
196         public
197         constant
198         returns (bool)
199     {
200         return isSigner[ecrecover(
201             keccak256("\x19Ethereum Signed Message:\n32", hash),
202             v,
203             r,
204             s
205         )];
206     }
207     function addSigner(address _newSigner) public {
208         require(isSigner[msg.sender]);
209         isSigner[_newSigner] = true;
210     }
211     function keccak(address _sender, address _wrapper, uint _validTill) public constant returns(bytes32) {
212         return keccak256(_sender, _wrapper, _validTill);
213     }
214 }
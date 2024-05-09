1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47 
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) returns (bool);
66   function approve(address spender, uint256 value) returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78     var _allowance = allowed[_from][msg.sender];
79     balances[_to] = balances[_to].add(_value);
80     balances[_from] = balances[_from].sub(_value);
81     allowed[_from][msg.sender] = _allowance.sub(_value);
82     Transfer(_from, _to, _value);
83     return true;
84   }
85 
86  
87   function approve(address _spender, uint256 _value) returns (bool) {
88 
89     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
90 
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97     return allowed[_owner][_spender];
98   }
99 
100 }
101 
102 contract Ownable {
103   address public owner;
104   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109    
110     
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address newOwner) public onlyOwner {
123     require(newOwner != address(0));
124     emit OwnershipTransferred(owner, newOwner);
125     owner = newOwner;
126   }
127 }
128 //////////////////////////////////
129 
130 contract token{ 
131     function transfer(address receiver, uint amount){  } 
132     
133 }
134 
135 contract SendTokensContract is Ownable,BasicToken {
136   using SafeMath for uint;
137   mapping (address => uint) public bals;
138   mapping (address => uint) public releaseTimes;
139   mapping (address => bytes32[]) public referenceCodes;
140   mapping (bytes32 => address[]) public referenceAddresses;
141   address public addressOfTokenUsedAsReward;
142   token tokenReward;
143 
144   event TokensSent
145     (address to, uint256 value, uint256 timeStamp, bytes32 referenceCode);
146 
147   function setTokenReward(address _tokenContractAddress) public onlyOwner {
148     tokenReward = token(_tokenContractAddress);
149     addressOfTokenUsedAsReward = _tokenContractAddress;
150   }
151 
152   function sendTokens(address _to, 
153     uint _value, 
154     uint _timeStamp, 
155     bytes32 _referenceCode) public onlyOwner {
156     bals[_to] = bals[_to].add(_value);
157     releaseTimes[_to] = _timeStamp;
158     referenceCodes[_to].push(_referenceCode);
159     referenceAddresses[_referenceCode].push(_to);
160     emit TokensSent(_to, _value, _timeStamp, _referenceCode);
161   }
162 
163   function getReferenceCodesOfAddress(address _addr) public constant 
164   returns (bytes32[] _referenceCodes) {
165     return referenceCodes[_addr];
166   }
167 
168   function getReferenceAddressesOfCode(bytes32 _code) public constant
169   returns (address[] _addresses) {
170     return referenceAddresses[_code];
171   }
172 
173   function withdrawTokens() public {
174     require(bals[msg.sender] > 0);
175     require(now >= releaseTimes[msg.sender]);
176     tokenReward.transfer(msg.sender,bals[msg.sender]);
177     //BasicToken.transfer(msg.sender,bals[msg.sender]);
178     bals[msg.sender] = 0;
179   }
180 }
181 
182 //////////////////////////////////
183 
184 
185 contract RWSC is StandardToken,SendTokensContract {
186 
187   string public constant name = "Real-World Smart Contract";
188   string public constant symbol = "RWSC";
189   uint256 public constant decimals = 18;
190   
191   uint256 public constant INITIAL_SUPPLY = 888888888 * 10 ** uint256(decimals);
192 
193   
194   function RWSC() {
195     totalSupply = INITIAL_SUPPLY;
196     balances[msg.sender] = INITIAL_SUPPLY;
197     owner=msg.sender;
198   }
199   
200 
201   function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
202         for (uint256 i = 0; i < _addresses.length; i++) {
203             token.transfer(_addresses[i], amount);
204         }
205     }
206  
207 
208  
209 }
1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[_from]);
106     require(_value <= allowed[_from][msg.sender]);
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     emit Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed[msg.sender][_spender] = _value;
117     emit Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function allowance(address _owner, address _spender) public view returns (uint256) {
122     return allowed[_owner][_spender];
123   }
124 
125   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
126     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
132     uint oldValue = allowed[msg.sender][_spender];
133     if (_subtractedValue > oldValue) {
134       allowed[msg.sender][_spender] = 0;
135     } else {
136       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137     }
138     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
159   constructor() public {
160     owner = msg.sender;
161   }
162 
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167 
168   function transferOwnership(address newOwner) public onlyOwner {
169     require(newOwner != address(0));
170     emit OwnershipTransferred(owner, newOwner);
171     owner = newOwner;
172   }
173 
174   function renounceOwnership() public onlyOwner {
175     emit OwnershipRenounced(owner);
176     owner = address(0);
177   }
178 }
179 
180 /**
181  * @title Mintable token
182  * @dev Simple ERC20 Token example, with mintable token creation
183  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
184  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
185  */
186 contract MintableToken is StandardToken, Ownable {
187   event Mint(address indexed to, uint256 amount);
188   event MintFinished();
189 
190   bool public mintingFinished = false;
191 
192 
193   modifier canMint() {
194     require(!mintingFinished);
195     _;
196   }
197 
198   modifier hasMintPermission() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   function mint(
204     address _to,
205     uint256 _amount
206   )
207     hasMintPermission
208     canMint
209     public
210     returns (bool)
211   {
212     totalSupply_ = totalSupply_.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     emit Mint(_to, _amount);
215     emit Transfer(address(0), _to, _amount);
216     return true;
217   }
218 
219   function finishMinting() onlyOwner canMint public returns (bool) {
220     mintingFinished = true;
221     emit MintFinished();
222     return true;
223   }
224 }
225 
226 contract Moheto is MintableToken {
227     
228   string public name;
229   string public symbol;
230   uint8 public decimals;
231   uint256 public initialSupply;
232 
233   constructor() public {
234     name = 'Moheto';
235     symbol = 'MOH';
236     decimals = 18;
237     initialSupply = 40000000 * 10 ** uint256(decimals);
238     totalSupply_ = initialSupply;
239     balances[msg.sender] = initialSupply;
240     emit Transfer(0x0, msg.sender, initialSupply);
241   }
242 }
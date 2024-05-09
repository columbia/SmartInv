1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns(uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns(uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73   bool public paused = false;
74   /**
75    * @dev modifier to allow actions only when the contract IS paused
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81   /**
82    * @dev modifier to allow actions only when the contract IS NOT paused
83    */
84   modifier whenPaused {
85     require(paused);
86     _;
87   }
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() public onlyOwner whenNotPaused returns(bool) {
92     paused = true;
93     emit Pause();
94     return true;
95   }
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() public onlyOwner whenPaused returns(bool) {
100     paused = false;
101     emit Unpause();
102     return true;
103   }
104 }
105 
106 contract ERC20 {
107 
108   uint256 public totalSupply;
109 
110   function transfer(address _to, uint256 _value) public returns(bool success);
111 
112   function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
113 
114   function balanceOf(address _owner) constant public returns(uint256 balance);
115 
116   function approve(address _spender, uint256 _value) public returns(bool success);
117 
118   function allowance(address _owner, address _spender) constant public returns(uint256 remaining);
119 
120   event Transfer(address indexed _from, address indexed _to, uint256 _value);
121 
122   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 
125 contract BasicToken is ERC20, Pausable {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129   mapping(address => mapping(address => uint256)) allowed;
130 
131   function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {
132     require(_to != 0x0);
133     require(_value > 0);
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   function transfer(address _to, uint256 _value) public whenNotPaused returns(bool success) {
141     require(balances[msg.sender] >= _value);
142     return _transfer(msg.sender, _to, _value);
143   }
144 
145   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool success) {
146     require(balances[_from] >= _value);
147     require(allowed[_from][msg.sender] >= _value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     return _transfer(_from, _to, _value);
150   }
151 
152   function balanceOf(address _owner) constant public returns(uint256 balance) {
153     return balances[_owner];
154   }
155 
156   function approve(address _spender, uint256 _value) public returns(bool success) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 }
166 
167 contract PayChainCoin is BasicToken {
168 
169   string public constant name = "PayChainCoin";
170   string public constant symbol = "PCC";
171   uint256 public constant decimals = 18;
172 
173   constructor() public {
174     _assign(0xa3f351bD8A2cB33822DeFE13e0efB968fc22A186, 690);
175     _assign(0xd3C72E4D0EAdab0Eb7A4f416b67754185F72A1fa, 10);
176     _assign(0x32A2594Ba3af6543E271e5749Dc39Dd85cFbE1e8, 150);
177     _assign(0x7c3db3C5862D32A97a53BFEbb34C384a4b52C2Cc, 150);
178   }
179 
180   function _assign(address _address, uint256 _value) private {
181     uint256 amount = _value * (10 ** 6) * (10 ** decimals);
182     balances[_address] = amount;
183     totalSupply = totalSupply.add(amount);
184   }
185 }
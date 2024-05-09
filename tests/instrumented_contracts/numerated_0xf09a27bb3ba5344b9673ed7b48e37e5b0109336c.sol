1 pragma solidity 0.4.19;
2 
3 /*
4     Contract Bitdark
5     Deployed by @eltneg
6     Written with zeppelin library: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
7 */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ERC20Basic {
36   uint256 public totalSupply;
37   function balanceOf(address who) public constant returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public constant returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     // SafeMath.sub will throw if there is not enough balance.
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) public constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   function approve(address _spender, uint256 _value) public returns (bool) {
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
104     uint oldValue = allowed[msg.sender][_spender];
105     if (_subtractedValue > oldValue) {
106       allowed[msg.sender][_spender] = 0;
107     } else {
108       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109     }
110     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 
114 }
115 
116 contract Ownable {
117   address public owner;
118 
119 
120   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   function Ownable() public {
128     owner = msg.sender;
129   }
130 
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) public onlyOwner {
146     require(newOwner != address(0));
147     OwnershipTransferred(owner, newOwner);
148     owner = newOwner;
149   }
150 
151 }
152 
153 contract Bitdark is StandardToken, Ownable {
154   string public constant name = "Bitdark";
155   string public constant symbol = "BBTD";
156   uint256 public constant decimals = 18;
157   uint256 public constant INITIAL_SUPPLY = 2000000 * (10 ** uint256(decimals));
158   bool public mintable = true;
159   address public constant owner = 0x735548A8c1cD54212DB989870b4B0673463adA43;
160   event Mint(address indexed _to, uint _value);
161 
162   function Bitdark() public {
163     totalSupply = INITIAL_SUPPLY;
164     balances[owner] = INITIAL_SUPPLY;
165   }
166 
167   function mintToken(address _to, uint _value) public returns(bool success) {
168       require(msg.sender == owner);
169       require(mintable);
170       totalSupply += _value * (10 ** decimals);
171       balances[_to] = balances[_to].add(_value);
172       Mint(_to, _value);
173       return true;
174   }
175 
176   function stopMinting(string verificationString) public returns (bool success) {
177       require(msg.sender == owner);
178       require(keccak256(verificationString) == keccak256("stop"));
179       require(mintable);
180       mintable = false;
181       return true;
182   }
183 }
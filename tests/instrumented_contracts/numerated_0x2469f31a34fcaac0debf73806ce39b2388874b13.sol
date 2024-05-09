1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8 
9   uint256 public totalSupply;
10 
11   function balanceOf(address _owner) constant returns (uint256);
12   function transfer(address _to, uint256 _value) returns (bool);
13   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
14   function approve(address _spender, uint256 _value) returns (bool);
15   function allowance(address _owner, address _spender) constant returns (uint256);
16   
17   event Transfer(address indexed _from, address indexed _to, uint256 _value);
18   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) onlyOwner {
86     if (newOwner != address(0)) {
87       owner = newOwner;
88     }
89   }
90 
91 }
92 
93 
94 /**
95  * Standard ERC20 token
96  *
97  * https://github.com/ethereum/EIPs/issues/20
98  * Based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 
102 /// @title Proof Presale Token (PROOFP)
103 
104 contract ProofPresaleToken is ERC20, Ownable {
105 
106   using SafeMath for uint256;
107 
108   mapping(address => uint) balances;
109   mapping (address => mapping (address => uint)) allowed;
110 
111   string public constant name = "Proof Presale Token";
112   string public constant symbol = "PPT";
113   uint8 public constant decimals = 18;
114   bool public mintingFinished = false;
115 
116   event Mint(address indexed to, uint256 amount);
117   event MintFinished();
118 
119   function ProofPresaleToken() {}
120 
121 
122   // TODO : need to replace throw by 0.4.11 solidity compiler syntax
123   function() payable {
124     revert();
125   }
126 
127   function balanceOf(address _owner) constant returns (uint balance) {
128     return balances[_owner];
129   }
130     
131   function transfer(address _to, uint _value) returns (bool success) {
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135 
136     Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
141     var _allowance = allowed[_from][msg.sender];
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146 
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   function approve(address _spender, uint _value) returns (bool success) {
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   function allowance(address _owner, address _spender) constant returns (uint remaining) {
158     return allowed[_owner][_spender];
159   }
160     
161     
162   modifier canMint() {
163     require(!mintingFinished);
164     _;
165   }
166 
167   /**
168    * Function to mint tokens
169    * @param _to The address that will recieve the minted tokens.
170    * @param _amount The amount of tokens to mint.
171    * @return A boolean that indicates if the operation was successful.
172    */
173 
174   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
175     totalSupply = totalSupply.add(_amount);
176     balances[_to] = balances[_to].add(_amount);
177     Mint(_to, _amount);
178     return true;
179   }
180 
181   /**
182    * @dev Function to stop minting new tokens.
183    * @return True if the operation was successful.
184    */
185   function finishMinting() onlyOwner returns (bool) {
186     mintingFinished = true;
187     MintFinished();
188     return true;
189   }
190 
191   
192   
193 }
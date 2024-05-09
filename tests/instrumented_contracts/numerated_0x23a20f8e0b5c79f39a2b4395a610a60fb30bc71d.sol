1 pragma solidity ^0.4.14;
2 
3 /* ©The Extreme Coin (XT) SWAP for Yobit.net  contract
4  +35796229192
5  ©RomanLanskoj 2017
6 There is no law stronger than the code
7 */
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
36     return a >= b ? a : b;
37   }
38   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a < b ? a : b;
40   }
41   function assert(bool assertion) internal {
42     if (!assertion) {
43       throw;
44     }
45   }
46 }
47 
48 contract Ownable {
49     address public owner;
50     function Ownable() {
51         owner = msg.sender;
52     }
53     modifier onlyOwner {
54         if (msg.sender != owner) throw;
55         _;
56     }
57     function transferOwnership(address newOwner) onlyOwner {
58         if (newOwner != address(0)) {
59             owner = newOwner;
60         }
61     }
62 }
63 
64 contract ERC20Basic {
65   uint public totalSupply;
66   function balanceOf(address who) constant returns (uint);
67   function transfer(address to, uint value);
68   event Transfer(address indexed from, address indexed to, uint value);
69 }
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint);
72   function transferFrom(address from, address to, uint value);
73   function approve(address spender, uint value);
74   event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 contract newToken is ERC20Basic {
78   
79   using SafeMath for uint;
80   
81   mapping(address => uint) balances;
82   
83 
84   modifier onlyPayloadSize(uint size) {
85      if(msg.data.length < size + 4) {
86        throw;
87      }
88      _;
89   }
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95   function balanceOf(address _owner) constant returns (uint balance) {
96     return balances[_owner];
97   }
98 }
99 
100 contract StandardToken is newToken, ERC20 {
101   mapping (address => mapping (address => uint)) allowed;
102   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
103     var _allowance = allowed[_from][msg.sender];
104     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
105     // if (_value > _allowance) throw;
106     balances[_to] = balances[_to].add(_value);
107     balances[_from] = balances[_from].sub(_value);
108     allowed[_from][msg.sender] = _allowance.sub(_value);
109     Transfer(_from, _to, _value);
110   }
111   function approve(address _spender, uint _value) {
112     // To change the approve amount you first have to reduce the addresses`
113     //  allowance to zero by calling approve(_spender, 0) if it is not
114     //  already 0 to mitigate the race condition described here:
115     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119   }
120   function allowance(address _owner, address _spender) constant returns (uint remaining) {
121     return allowed[_owner][_spender];
122   }
123 }
124 
125  contract Extreme is StandardToken, Ownable {
126   string public constant name = "Extreme Coin";
127   string public constant symbol = "XT";
128   uint public constant decimals = 2;
129   uint256 public initialSupply;
130     
131   // Constructor
132   function Extreme () { 
133      totalSupply = 59347951976;
134       balances[msg.sender] = totalSupply;
135       initialSupply = totalSupply; 
136   }
137 }
138 
139 contract ExtremeToken is Ownable, Extreme {
140 
141     /* Initializes contract with initial supply tokens to the creator of the contract */
142    function ExtremeToken() Extreme () {}
143   mapping (address => mapping (address => uint)) allowed;
144   
145  mapping (address => uint256) public balanceOf;
146   
147   function transfer(address _to, uint256 _value) {
148         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
149         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
150         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
151         balanceOf[_to] += _value;                            // Add the same to the recipient
152         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
153     }
154   
155 
156   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
157     var _allowance = allowed[_from][msg.sender];
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // if (_value > _allowance) throw;
160     balances[_to] = balances[_to].add(_value);
161     balances[_from] = balances[_from].sub(_value);
162     allowed[_from][msg.sender] = _allowance.sub(_value);
163     Transfer(_from, _to, _value);
164   }
165   function approve(address _spender, uint _value) {
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170   }
171    function mintToken(address target, uint256 mintedAmount) onlyOwner {
172         balanceOf[target] += mintedAmount;
173         totalSupply += mintedAmount;
174         Transfer(0, this, mintedAmount);
175         Transfer(this, target, mintedAmount);
176     }
177   function allowance(address _owner, address _spender) constant returns (uint remaining) {
178     return allowed[_owner][_spender];
179   }
180 }
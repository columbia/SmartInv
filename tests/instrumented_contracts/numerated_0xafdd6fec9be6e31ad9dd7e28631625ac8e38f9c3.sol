1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14     event Burn(address indexed burner, uint256 value);
15 }
16 
17 /**
18  * Math operations with safety checks
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) public constant returns (uint256);
55   function transfer(address to, uint256 value) public;
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public;
66   function approve(address spender, uint256 value) public;
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /*
71  * Ownable
72  *
73  * Base contract with an owner.
74  * Provides onlyOwner modifier, which prevents function from running if it is
75  * called by anyone other than the owner.
76  */
77 contract Ownable {
78   address public owner;
79 
80   function Owanble() public{
81     owner = msg.sender;
82   }
83 
84   // Modifier onlyOwner prevents function from running
85   // if it is called by anyone other than the owner
86 
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   // Function transferOwnership allows owner to change ownership.
93   // Before the appying changes it checks if the owner
94   // called this function and if the address is not 0x0.
95 
96   function transferOwnership(address newOwner) public onlyOwner {
97     if (newOwner != address(0)) {
98       owner = newOwner;
99     }
100   }
101 
102 }
103 
104 /*
105  * Haltable
106  *
107  * Abstract contract that allows children to implement an
108  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
109  *
110  *
111  * Originally envisioned in FirstBlood ICO contract.
112  */
113 contract Haltable is Ownable {
114   bool public halted = false;
115 
116   modifier stopInEmergency {
117     require(!halted);
118     _;
119   }
120 
121   modifier onlyInEmergency {
122     require(halted);
123     _;
124   }
125 
126   // called by the owner on emergency, triggers stopped state
127   function halt() external onlyOwner {
128     halted = true;
129   }
130 
131   // called by the owner on end of emergency, returns to normal state
132   function unhalt() external onlyOwner onlyInEmergency {
133     halted = false;
134   }
135 
136 }
137 
138 contract TokenSale is Haltable {
139     using SafeMath for uint;
140 
141     string public name = "TokenSale Contract";
142 
143     // Constants
144     EIP20Interface public token;
145     address public beneficiary;
146     address public reserve;
147     uint public price = 0; // in wei
148 
149     // Counters
150     uint public tokensSoldTotal = 0; // in wei
151     uint public weiRaisedTotal = 0; // in wei
152     uint public investorCount = 0;
153 
154     event NewContribution(
155         address indexed holder,
156         uint256 tokenAmount,
157         uint256 etherAmount);
158 
159     function TokenSale(
160         ) public {
161             
162         // Grant owner rights to deployer of a contract
163         owner = msg.sender;
164         
165         // Set token address and initialize constructor
166         token = EIP20Interface(address(0x2F7823AaF1ad1dF0D5716E8F18e1764579F4ABe6));
167         
168         // Set beneficiary address to receive ETH
169         beneficiary = address(0xf2b9DA535e8B8eF8aab29956823df7237f1863A3);
170         
171         // Set reserve address to receive ETH
172         reserve = address(0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e);
173         
174         // Set price of 1 token
175         price = 0.00379 ether;
176     }
177 
178     function changeBeneficiary(address _beneficiary) public onlyOwner stopInEmergency {
179         beneficiary = _beneficiary;
180     }
181     
182     function changeReserve(address _reserve) public onlyOwner stopInEmergency {
183         reserve = _reserve;
184     }
185     
186     function changePrice(uint _price) public onlyOwner stopInEmergency {
187         price = _price;
188     }
189 
190     function () public payable stopInEmergency {
191         
192         // require min limit of contribution
193         require(msg.value >= price);
194         
195         // calculate token amount
196         uint tokens = msg.value / price;
197         
198         // throw if you trying to buy over the token exists
199         require(token.balanceOf(this) >= tokens);
200         
201         // recalculate counters
202         tokensSoldTotal = tokensSoldTotal.add(tokens);
203         if (token.balanceOf(msg.sender) == 0) investorCount++;
204         weiRaisedTotal = weiRaisedTotal.add(msg.value);
205         
206         // transfer bought tokens to the contributor 
207         token.transfer(msg.sender, tokens);
208 
209         // 100% / 10 = 10%
210         uint reservePie = msg.value.div(10);
211         
212         // 100% - 10% = 90%
213         uint beneficiaryPie = msg.value.sub(reservePie);
214 
215         // transfer funds to the reserve address
216         reserve.transfer(reservePie);
217 
218         // transfer funds to the beneficiary address
219         beneficiary.transfer(beneficiaryPie);
220 
221         emit NewContribution(msg.sender, tokens, msg.value);
222     }
223     
224     
225     // Withdraw any accidently sent to the contract ERC20 tokens.
226     // Can be performed only by the owner.
227     function withdrawERC20Token(address _token) public onlyOwner stopInEmergency {
228         ERC20 foreignToken = ERC20(_token);
229         foreignToken.transfer(msg.sender, foreignToken.balanceOf(this));
230     }
231     
232     // Withdraw any accidently sent to the contract EIP20 tokens.
233     // Can be performed only by the owner.
234     function withdrawEIP20Token(address _token) public onlyOwner stopInEmergency {
235         EIP20Interface foreignToken = EIP20Interface(_token);
236         foreignToken.transfer(msg.sender, foreignToken.balanceOf(this));
237     }
238     
239     // Withdraw all not sold tokens.
240     // Can be performed only by the owner.
241     function withdrawToken() public onlyOwner stopInEmergency {
242         token.transfer(msg.sender, token.balanceOf(this));
243     }
244     
245     // Get the contract token balance
246     function tokensRemaining() public constant returns (uint256) {
247         return token.balanceOf(this);
248     }
249     
250 }
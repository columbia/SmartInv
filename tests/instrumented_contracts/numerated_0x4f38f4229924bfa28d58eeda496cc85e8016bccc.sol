1 /* -------------------------------------------------------------------------
2 
3   /$$$$$$            /$$       /$$        /$$$$$$            /$$          
4  /$$__  $$          | $$      | $$       /$$__  $$          |__/          
5 | $$  \__/  /$$$$$$ | $$$$$$$ | $$$$$$$ | $$  \__/  /$$$$$$  /$$ /$$$$$$$ 
6 | $$       /$$__  $$| $$__  $$| $$__  $$| $$       /$$__  $$| $$| $$__  $$
7 | $$      | $$$$$$$$| $$  \ $$| $$  \ $$| $$      | $$  \ $$| $$| $$  \ $$
8 | $$    $$| $$_____/| $$  | $$| $$  | $$| $$    $$| $$  | $$| $$| $$  | $$
9 |  $$$$$$/|  $$$$$$$| $$  | $$| $$  | $$|  $$$$$$/|  $$$$$$/| $$| $$  | $$
10  \______/  \_______/|__/  |__/|__/  |__/ \______/  \______/ |__/|__/  |__/
11 
12 
13                 === PROOF OF WORK ERC20 EXTENSION ===
14  
15                          Mk 1 aka CehhCoin
16    
17     Intro:
18    All addresses have CehhCoin assigned to them from the moment this
19    contract is mined. The amount assigned to each address is equal to
20    the value of the last 7 bits of the address. Anyone who finds an 
21    address with CEHH can transfer it to a personal wallet.
22    This system allows "miners" to not have to wait in line, and gas
23    price rushing does not become a problem.
24    
25     How:
26    The transfer() function has been modified to include the equivalent
27    of a mint() function that may be called once per address.
28    
29     Why:
30    Instead of premining everything, the supply goes up until the 
31    transaction fee required to "mine" CehhCoins matches the price of 
32    255 CehhCoins. After that point CehhCoins will follow a price 
33    theoretically proportional to gas prices. This gives the community
34    a way to see gas prices as a number. Added to this, I hope to
35    use CehhCoin as a starting point for a new paradigm of keeping
36    PoW as an open possibility without having to launch a standalone
37    blockchain.
38    
39    
40   /$$$$$$            /$$       /$$        /$$$$$$            /$$          
41  /$$__  $$          | $$      | $$       /$$__  $$          |__/          
42 | $$  \__/  /$$$$$$ | $$$$$$$ | $$$$$$$ | $$  \__/  /$$$$$$  /$$ /$$$$$$$ 
43 | $$       /$$__  $$| $$__  $$| $$__  $$| $$       /$$__  $$| $$| $$__  $$
44 | $$      | $$$$$$$$| $$  \ $$| $$  \ $$| $$      | $$  \ $$| $$| $$  \ $$
45 | $$    $$| $$_____/| $$  | $$| $$  | $$| $$    $$| $$  | $$| $$| $$  | $$
46 |  $$$$$$/|  $$$$$$$| $$  | $$| $$  | $$|  $$$$$$/|  $$$$$$/| $$| $$  | $$
47  \______/  \_______/|__/  |__/|__/  |__/ \______/  \______/ |__/|__/  |__/
48 
49    
50  ------------------------------------------------------------------------- */
51 
52 pragma solidity ^0.4.20;
53 
54 contract Ownable {
55   address public owner;
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a / b;
88     return c;
89   }
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114   mapping(address => uint256) balances;
115   uint256 totalSupply_;
116 
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121 }
122 
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public view returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 contract StandardToken is ERC20, BasicToken {
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 contract MineableToken is StandardToken, Ownable {
176   event Mine(address indexed to, uint256 amount);
177   event MiningFinished();
178 
179   bool public miningFinished = false;
180   mapping(address => bool) claimed;
181 
182 
183   modifier canMine {
184     require(!miningFinished);
185     _;
186   }
187 
188   
189   function claim() canMine public {
190     require(!claimed[msg.sender]);
191     bytes20 reward = bytes20(msg.sender) & 255;
192     require(reward > 0);
193     uint256 rewardInt = uint256(reward);
194     
195     claimed[msg.sender] = true;
196     totalSupply_ = totalSupply_.add(rewardInt);
197     balances[msg.sender] = balances[msg.sender].add(rewardInt);
198     Mine(msg.sender, rewardInt);
199     Transfer(address(0), msg.sender, rewardInt);
200   }
201   
202   function claimAndTransfer(address _owner) canMine public {
203     require(!claimed[msg.sender]);
204     bytes20 reward = bytes20(msg.sender) & 255;
205     require(reward > 0);
206     uint256 rewardInt = uint256(reward);
207     
208     claimed[msg.sender] = true;
209     totalSupply_ = totalSupply_.add(rewardInt);
210     balances[_owner] = balances[_owner].add(rewardInt);
211     Mine(msg.sender, rewardInt);
212     Transfer(address(0), _owner, rewardInt);
213   }
214   
215   function checkReward() view public returns(uint256){
216     return uint256(bytes20(msg.sender) & 255);
217   }
218   
219   function transfer(address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[msg.sender] ||
222            (!claimed[msg.sender] && _value <= balances[msg.sender] + uint256(bytes20(msg.sender) & 255))
223            );
224 
225     if(!claimed[msg.sender]) claim();
226 
227     balances[msg.sender] = balances[msg.sender].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     Transfer(msg.sender, _to, _value);
230     return true;
231   }
232   
233   function balanceOf(address _owner) public view returns (uint256 balance) {
234     return balances[_owner] + (claimed[_owner] ? 0 : uint256(bytes20(_owner) & 255));
235   }
236 }
237 
238 contract CehhCoin is MineableToken {
239   string public name;
240   string public symbol;
241   uint8 public decimals;
242 
243 
244   function CehhCoin(string _name, string _symbol, uint8 _decimals) public {
245     name = _name;
246     symbol = _symbol;
247     decimals = _decimals;
248   }
249 }
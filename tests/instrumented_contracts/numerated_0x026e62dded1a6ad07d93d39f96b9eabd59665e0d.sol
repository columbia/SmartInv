1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   uint256 public totalSupply;
27   function balanceOf(address who) public constant returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 contract ERC20 is ERC20Basic {
32   function allowance(address owner, address spender) public constant returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45 
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   function balanceOf(address _owner) public constant returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 
58 contract StandardToken is ERC20, BasicToken {
59 
60   mapping (address => mapping (address => uint256)) allowed;
61 
62   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64 
65     uint256 _allowance = allowed[_from][msg.sender];
66 
67     balances[_from] = balances[_from].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     allowed[_from][msg.sender] = _allowance.sub(_value);
70     Transfer(_from, _to, _value);
71     return true;
72   }
73 
74   function approve(address _spender, uint256 _value) public returns (bool) {
75     allowed[msg.sender][_spender] = _value;
76     Approval(msg.sender, _spender, _value);
77     return true;
78   }
79 
80   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
81     return allowed[_owner][_spender];
82   }
83 
84   function increaseApproval (address _spender, uint _addedValue)
85     returns (bool success) {
86     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
87     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
88     return true;
89   }
90 
91   function decreaseApproval (address _spender, uint _subtractedValue)
92     returns (bool success) {
93     uint oldValue = allowed[msg.sender][_spender];
94     if (_subtractedValue > oldValue) {
95       allowed[msg.sender][_spender] = 0;
96     } else {
97       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
98     }
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 }
103 
104 contract Ownable {
105   address public owner;
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109   function Ownable() {
110     owner = msg.sender;
111   }
112 
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118   function transferOwnership(address newOwner) onlyOwner public {
119     require(newOwner != address(0));
120     OwnershipTransferred(owner, newOwner);
121     owner = newOwner;
122   }
123 
124 }
125 
126 contract MintableToken is StandardToken, Ownable {
127   event Mint(address indexed to, uint256 amount);
128   event MintFinished();
129 
130   bool public mintingFinished = false;
131 
132 
133   modifier canMint() {
134     require(!mintingFinished);
135     _;
136   }
137 
138   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
139     totalSupply = totalSupply.add(_amount);
140     balances[_to] = balances[_to].add(_amount);
141     Mint(_to, _amount);
142     Transfer(0x0, _to, _amount);
143     return true;
144   }
145 
146   function finishMinting() onlyOwner public returns (bool) {
147     mintingFinished = true;
148     MintFinished();
149     return true;
150   }
151 }
152 
153 contract BirdCoin is MintableToken {
154     string public constant name = "BirdCoin";
155     string public constant symbol = "BIRD";
156     uint8 public constant decimals = 18;
157     bool private isLocked = true;
158 
159     modifier canTransfer(address _sender, uint _value) {
160         require(!isLocked);
161         _;
162     }
163 
164     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool success) {
165         return super.transfer(_to, _value);
166     }
167 
168     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool success) {
169         return super.transferFrom(_from, _to, _value);
170     }
171 
172     function unlockTokens() onlyOwner {
173         isLocked = false;
174     }
175 }
176 
177 contract BirdCoinCrowdsale is Ownable {
178     using SafeMath for uint256;
179 
180     address constant ALLOCATOR_WALLET = 0x138e0c8f665f45D5A5969f661A2d73f65d5AC605;
181     uint256 constant public CAP = 580158 ether;
182     BirdCoin public token;
183 
184     bool public areTokensUnlocked = false;
185     uint256 public tokensAllocated = 0;
186 
187     event TokenPurchase(address indexed beneficiary, uint256 amount);
188 
189     modifier onlyAllocator() {
190         require(msg.sender == ALLOCATOR_WALLET);
191         _;
192     }
193 
194     function BirdCoinCrowdsale() {
195         token = new BirdCoin();
196     }
197 
198     function allocateTokens(address addr, uint256 tokenAmount) public onlyAllocator {
199         require(validPurchase(tokenAmount));
200         tokensAllocated = tokensAllocated.add(tokenAmount);
201         token.mint(addr, tokenAmount);
202         TokenPurchase(msg.sender, tokenAmount);
203     }
204 
205     function validPurchase(uint256 providedAmount) internal constant returns (bool) {
206         bool isCapReached = tokensAllocated.add(providedAmount) > CAP;
207 
208         if (isCapReached) {
209             token.finishMinting();
210         }
211 
212         return !isCapReached;
213     }
214 
215     function unlockTokens() onlyOwner public {
216         require(!areTokensUnlocked);
217         token.unlockTokens();
218         areTokensUnlocked = true;
219     }
220 }
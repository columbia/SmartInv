1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) public constant returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   function transfer(address _to, uint256 _value) public returns (bool) {
46     require(_to != address(0));
47 
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) public constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) allowed;
63 
64   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66 
67     uint256 _allowance = allowed[_from][msg.sender];
68 
69     balances[_from] = balances[_from].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     allowed[_from][msg.sender] = _allowance.sub(_value);
72     Transfer(_from, _to, _value);
73     return true;
74   }
75 
76   function approve(address _spender, uint256 _value) public returns (bool) {
77     allowed[msg.sender][_spender] = _value;
78     Approval(msg.sender, _spender, _value);
79     return true;
80   }
81 
82   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
83     return allowed[_owner][_spender];
84   }
85 
86   function increaseApproval (address _spender, uint _addedValue)
87     returns (bool success) {
88     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
89     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
90     return true;
91   }
92 
93   function decreaseApproval (address _spender, uint _subtractedValue)
94     returns (bool success) {
95     uint oldValue = allowed[msg.sender][_spender];
96     if (_subtractedValue > oldValue) {
97       allowed[msg.sender][_spender] = 0;
98     } else {
99       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100     }
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 }
105 
106 contract Ownable {
107   address public owner;
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111   function Ownable() {
112     owner = msg.sender;
113   }
114 
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120   function transferOwnership(address newOwner) onlyOwner public {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract MintableToken is StandardToken, Ownable {
129   event Mint(address indexed to, uint256 amount);
130   event MintFinished();
131 
132   bool public mintingFinished = false;
133 
134 
135   modifier canMint() {
136     require(!mintingFinished);
137     _;
138   }
139 
140   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
141     totalSupply = totalSupply.add(_amount);
142     balances[_to] = balances[_to].add(_amount);
143     Mint(_to, _amount);
144     Transfer(0x0, _to, _amount);
145     return true;
146   }
147 
148   function finishMinting() onlyOwner public returns (bool) {
149     mintingFinished = true;
150     MintFinished();
151     return true;
152   }
153 }
154 
155 contract BirdCoin is MintableToken {
156     string public constant name = "BirdCoin";
157     string public constant symbol = "BIRD";
158     uint8 public constant decimals = 18;
159     bool private isLocked = true;
160 
161     modifier canTransfer(address _sender, uint _value) {
162         require(!isLocked);
163         _;
164     }
165 
166     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool success) {
167         return super.transfer(_to, _value);
168     }
169 
170     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool success) {
171         return super.transferFrom(_from, _to, _value);
172     }
173 
174     function unlockTokens() onlyOwner {
175         isLocked = false;
176     }
177 }
178 
179 contract BirdCoinCrowdsale is Ownable {
180     using SafeMath for uint256;
181 
182     address constant ALLOCATOR_WALLET = 0x138e0c8f665f45D5A5969f661A2d73f65d5AC605;
183     uint256 constant public CAP = 580263158 ether;
184     BirdCoin public token;
185 
186     bool public areTokensUnlocked = false;
187     uint256 public tokensAllocated = 0;
188 
189     event TokenPurchase(address indexed beneficiary, uint256 amount);
190 
191     modifier onlyAllocator() {
192         require(msg.sender == ALLOCATOR_WALLET);
193         _;
194     }
195 
196     function BirdCoinCrowdsale() {
197         token = new BirdCoin();
198     }
199 
200     function allocateTokens(address addr, uint256 tokenAmount) public onlyAllocator {
201         require(validPurchase(tokenAmount));
202         tokensAllocated = tokensAllocated.add(tokenAmount);
203         token.mint(addr, tokenAmount);
204         TokenPurchase(msg.sender, tokenAmount);
205     }
206 
207     function validPurchase(uint256 providedAmount) internal constant returns (bool) {
208         bool isCapReached = tokensAllocated.add(providedAmount) > CAP;
209 
210         if (isCapReached) {
211             token.finishMinting();
212         }
213 
214         return !isCapReached;
215     }
216 
217     function unlockTokens() onlyOwner public {
218         require(!areTokensUnlocked);
219         token.unlockTokens();
220         areTokensUnlocked = true;
221     }
222 }
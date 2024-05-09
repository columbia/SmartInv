1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 
46 contract ERC20Basic {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   uint256 totalSupply_;
66 
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256) {
82     return balances[_owner];
83   }
84 }
85 
86 contract StandardToken is ERC20, BasicToken {
87 
88   mapping (address => mapping (address => uint256)) internal allowed;
89 
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     emit Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     emit Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 
112   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 }
129 
130 contract MintableToken is StandardToken, Ownable {
131   event Mint(address indexed to, uint256 amount);
132 
133   modifier hasMintPermission() {
134     require(msg.sender == owner);
135     _;
136   }
137 
138   function mint(address _to, uint256 _amount) hasMintPermission public returns (bool) {
139     totalSupply_ = totalSupply_.add(_amount);
140     balances[_to] = balances[_to].add(_amount);
141     emit Mint(_to, _amount);
142     emit Transfer(address(0), _to, _amount);
143     return true;
144   }
145 }
146 
147 contract CrowdsaleTokenConstructor is MintableToken {
148   string public name;
149   string public symbol;
150   uint8 public constant decimals = 18;
151 
152   constructor(string _name, string _symbol, address _owner) public {
153     name = _name;
154     symbol = _symbol;
155     owner = _owner;
156   }
157 }
158 
159 contract Crowdsale {
160   using SafeMath for uint256;
161 
162   ERC20 public token;
163   address public wallet;
164   uint256 public rate;
165   uint256 public weiRaised;
166 
167   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
168 
169   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
170     require(_rate > 0);
171     require(_wallet != address(0));
172     require(_token != address(0));
173 
174     rate = _rate;
175     wallet = _wallet;
176     token = _token;
177   }
178 
179   function () external payable {
180     buyTokens(msg.sender);
181   }
182 
183   function buyTokens(address _beneficiary) public payable {
184 
185     uint256 weiAmount = msg.value;
186     _preValidatePurchase(_beneficiary, weiAmount);
187 
188     uint256 tokens = _getTokenAmount(weiAmount);
189 
190     weiRaised = weiRaised.add(weiAmount);
191 
192     _deliverTokens(_beneficiary, tokens);
193 
194     emit TokenPurchase(
195       msg.sender,
196       _beneficiary,
197       weiAmount,
198       tokens
199     );
200 
201     _forwardFunds();
202   }
203 
204   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
205     require(_beneficiary != address(0));
206     require(_weiAmount != 0);
207   }
208 
209   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
210     token.transfer(_beneficiary, _tokenAmount);
211   }
212 
213   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
214     return _weiAmount.mul(rate);
215   }
216 
217   function _forwardFunds() internal {
218     wallet.transfer(msg.value);
219   }
220 
221   function _newWallet(address _newAddress) public {
222       require(msg.sender == wallet);
223       wallet = _newAddress;
224   }
225 }
226 
227 contract MintedCrowdsale is Crowdsale {
228   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
229     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
230   }
231 }
232 
233 contract CrowdsaleConstructor is MintedCrowdsale {
234   constructor(uint256 _rate, address _wallet, MintableToken _token)
235   public Crowdsale(_rate, _wallet, _token){}
236 }
237 
238 contract EtherZaarCrowdsaleFactory {
239 
240     event NewCrowdsaleToken(string tokenName, string tokenSymbol);
241     event NewCrowdsaleContract(uint256 tokenRate, address crowdsaleOwner, address tokenAddress);
242 
243     function createToken(uint256 _rate, address _wallet, string _name, string _symbol) public {
244         CrowdsaleTokenConstructor newToken =
245           (new CrowdsaleTokenConstructor(_name, _symbol, address(this)));
246 
247         CrowdsaleConstructor newCrowdsale =
248           (new CrowdsaleConstructor(_rate, _wallet, newToken));
249 
250         newToken.transferOwnership(address(newCrowdsale));
251 
252         emit NewCrowdsaleToken(_name, _symbol);
253         emit NewCrowdsaleContract(_rate, _wallet, address(newToken));
254     }
255 }
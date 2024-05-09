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
147 
148 contract Crowdsale {
149   using SafeMath for uint256;
150 
151   ERC20 public token;
152   address public wallet;
153   uint256 public rate;
154   uint256 public weiRaised;
155 
156   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
157 
158   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
159     require(_rate > 0);
160     require(_wallet != address(0));
161     require(_token != address(0));
162 
163     rate = _rate;
164     wallet = _wallet;
165     token = _token;
166   }
167 
168   function () external payable {
169     buyTokens(msg.sender);
170   }
171 
172   function buyTokens(address _beneficiary) public payable {
173 
174     uint256 weiAmount = msg.value;
175     _preValidatePurchase(_beneficiary, weiAmount);
176 
177     uint256 tokens = _getTokenAmount(weiAmount);
178 
179     weiRaised = weiRaised.add(weiAmount);
180 
181     _deliverTokens(_beneficiary, tokens);
182 
183     emit TokenPurchase(
184       msg.sender,
185       _beneficiary,
186       weiAmount,
187       tokens
188     );
189 
190     _forwardFunds();
191   }
192 
193   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
194     require(_beneficiary != address(0));
195     require(_weiAmount != 0);
196   }
197 
198   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
199     token.transfer(_beneficiary, _tokenAmount);
200   }
201 
202   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
203     return _weiAmount.mul(rate);
204   }
205 
206   function _forwardFunds() internal {
207     wallet.transfer(msg.value);
208   }
209 
210   function _newWallet(address _newAddress) public {
211       require(msg.sender == wallet);
212       wallet = _newAddress;
213   }
214 }
215 
216 contract MintedCrowdsale is Crowdsale {
217   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
218     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
219   }
220 }
221 
222 contract CrowdsaleConstructor is MintedCrowdsale {
223   constructor(uint256 _rate, address _wallet, MintableToken _token) public Crowdsale(_rate, _wallet, _token){}
224 }
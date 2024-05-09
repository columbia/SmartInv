1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   function Ownable() public {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13   function transferOwnership(address newOwner) public onlyOwner {
14     require(newOwner != address(0));
15     emit OwnershipTransferred(owner, newOwner);
16     owner = newOwner;
17   }
18 }
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     emit Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   function balanceOf(address _owner) public view returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[_from]);
89     require(_value <= allowed[_from][msg.sender]);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94     emit Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   function approve(address _spender, uint256 _value) public returns (bool) {
99     allowed[msg.sender][_spender] = _value;
100     emit Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   function allowance(address _owner, address _spender) public view returns (uint256) {
105     return allowed[_owner][_spender];
106   }
107 
108   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
109     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 
114   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
115     uint oldValue = allowed[msg.sender][_spender];
116     if (_subtractedValue > oldValue) {
117       allowed[msg.sender][_spender] = 0;
118     } else {
119       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120     }
121     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125 }
126 
127 contract MartinKoToken is StandardToken {
128   string public constant name = "MartinKoToken";
129   string public constant symbol = "MKT";
130   uint256 public constant decimals = 18;
131   uint256 public constant INITIAL_SUPPLY = 1000000000*(10 ** decimals);
132   function MartinKoToken() public {
133     totalSupply_ = INITIAL_SUPPLY;
134     balances[msg.sender] = INITIAL_SUPPLY;
135   }
136 }
137 
138 contract Crowdsale {
139   using SafeMath for uint256;
140 
141   ERC20 public token;
142 
143   address public wallet;
144 
145   uint256 public rate;
146 
147   uint256 public weiRaised;
148 
149   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
150 
151   function Crowdsale() public {
152     rate = 100;
153     wallet = msg.sender;
154     token = new MartinKoToken();
155   }
156 
157   function () external payable {
158     buyTokens(msg.sender);
159   }
160 
161   function buyTokens(address _beneficiary) public payable {
162 
163     uint256 weiAmount = msg.value;
164 
165     // calculate token amount to be created
166     uint256 tokens = _getTokenAmount(weiAmount);
167 
168     // update state
169     weiRaised = weiRaised.add(weiAmount);
170 
171     _processPurchase(_beneficiary, tokens);
172     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
173 
174     _forwardFunds();
175   }
176 
177   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
178     token.transfer(_beneficiary, _tokenAmount);
179   }
180 
181   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
182     _deliverTokens(_beneficiary, _tokenAmount);
183   }
184 
185   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
186     return _weiAmount.mul(rate);
187   }
188 
189   function _forwardFunds() internal {
190     wallet.transfer(msg.value);
191   }
192 }
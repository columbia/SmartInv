1 pragma solidity ^0.4.23;
2 ///////////////////////////////////////////////////
3 //  
4 //  `iCashweb` ICW Token Contract
5 //
6 //  Total Tokens: 300,000,000.000000000000000000
7 //  Name: iCashweb
8 //  Symbol: ICWeb
9 //  Decimal Scheme: 18
10 //  
11 //  by Nishad Vadgama
12 ///////////////////////////////////////////////////
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23   function div(uint256 a, uint256 b) internal pure returns(uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31   function add(uint256 a, uint256 b) internal pure returns(uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract ERC01Basic {
39   function totalSupply() public view returns(uint256);
40   function balanceOf(address who) public view returns(uint256);
41   function transfer(address to, uint256 value) public returns(bool);
42   function changeRate(uint256 value) public returns(bool);
43   function startIco(bool status) public returns(bool);
44   function changeOwnerShip(address toWhom) public returns(bool);
45   function transferTokens() public payable;
46   function releaseIcoTokens() public returns(bool);
47   function transferICOTokens(address to, uint256 value) public returns(bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC01Basic {
52   function allowance(address owner, address spender) public view returns(uint256);
53   function transferFrom(address from, address to, uint256 value) public returns(bool);
54   function approve(address spender, uint256 value) public returns(bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract ICWToken is ERC01Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62   address public contractModifierAddress;
63   uint256 _totalSupply;
64   uint256 _totalICOSupply;
65   uint256 _maxICOSupply;
66   uint256 RATE = 100;
67   bool _status;
68   bool _released;
69 
70   uint8 public constant decimals = 18;
71   uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(decimals));
72   uint256 public constant ICO_SUPPLY = 150000000 * (10 ** uint256(decimals));
73 
74   modifier onlyByOwned() {
75     require(msg.sender == contractModifierAddress);
76     _;
77   }
78 
79   function getReleased() public view returns(bool) {
80     return _released;
81   }
82   
83   function getOwner() public view returns(address) {
84     return contractModifierAddress;
85   }
86   
87   function getICOStatus() public view returns(bool) {
88     return _status;
89   }
90   
91   function getRate() public view returns(uint256) {
92     return RATE;
93   }
94 
95   function totalSupply() public view returns(uint256) {
96     return _totalSupply;
97   }
98 
99   function totalICOSupply() public view returns(uint256) {
100     return _totalICOSupply;
101   }
102 
103   function destroyContract() public onlyByOwned {
104     selfdestruct(contractModifierAddress);
105   }
106 
107   function changeOwnerShip(address _to) public onlyByOwned returns(bool) {
108     address oldOwner = contractModifierAddress;
109     uint256 balAmount = balances[oldOwner];
110     balances[_to] = balances[_to].add(balAmount);
111     balances[oldOwner] = 0;
112     contractModifierAddress = _to;
113     emit Transfer(oldOwner, contractModifierAddress, balAmount);
114     return true;
115   }
116 
117   function releaseIcoTokens() public onlyByOwned returns(bool) {
118     require(_released == false);
119     uint256 realeaseAmount = _maxICOSupply.sub(_totalICOSupply);
120     uint256 totalReleased = _totalICOSupply.add(realeaseAmount);
121     require(_maxICOSupply >= totalReleased);
122     _totalSupply = _totalSupply.add(realeaseAmount);
123     balances[contractModifierAddress] = balances[contractModifierAddress].add(realeaseAmount);
124     emit Transfer(contractModifierAddress, contractModifierAddress, realeaseAmount);
125     return true;
126   }
127 
128   function changeRate(uint256 _value) public onlyByOwned returns(bool) {
129     require(_value > 0);
130     RATE = _value;
131     return true;
132   }
133 
134   function startIco(bool status_) public onlyByOwned returns(bool) {
135     _status = status_;
136     return true;
137   }
138 
139   function transferTokens() public payable {
140     require(_status == true && msg.value > 0);
141     uint tokens = msg.value.mul(RATE);
142     uint totalToken = _totalICOSupply.add(tokens);
143     require(_maxICOSupply >= totalToken);
144     balances[msg.sender] = balances[msg.sender].add(tokens);
145     _totalICOSupply = _totalICOSupply.add(tokens);
146     contractModifierAddress.transfer(msg.value);
147   }
148   
149   function transferICOTokens(address _to, uint256 _value) public onlyByOwned returns(bool) {
150     uint totalToken = _totalICOSupply.add(_value);
151     require(_maxICOSupply >= totalToken);
152     balances[_to] = balances[_to].add(_value);
153     _totalICOSupply = _totalICOSupply.add(_value);
154     return true;
155   }
156 
157   function transfer(address _to, uint256 _value) public returns(bool) {
158     require(_to != msg.sender);
159     require(_value <= balances[msg.sender]);
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   function balanceOf(address _owner) public view returns(uint256 balance) {
167     return balances[_owner];
168   }
169 }
170 
171 contract iCashwebToken is ERC20, ICWToken {
172 
173   mapping(address => mapping(address => uint256)) internal allowed;
174 
175   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
176     require(_to != msg.sender);
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   function approve(address _spender, uint256 _value) public returns(bool) {
187     allowed[msg.sender][_spender] = _value;
188     emit Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   function allowance(address _owner, address _spender) public view returns(uint256) {
193     return allowed[_owner][_spender];
194   }
195 
196   function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 }
213 
214 contract iCashweb is iCashwebToken {
215 
216   string public constant name = "iCashweb";
217   string public constant symbol = "ICWeb";
218 
219   constructor() public {
220     _status = false;
221     _released = false;
222     contractModifierAddress = msg.sender;
223     _totalSupply = INITIAL_SUPPLY;
224     _maxICOSupply = ICO_SUPPLY;
225     balances[msg.sender] = INITIAL_SUPPLY;
226   }
227 
228   function () public payable {
229     transferTokens();
230   }
231 }
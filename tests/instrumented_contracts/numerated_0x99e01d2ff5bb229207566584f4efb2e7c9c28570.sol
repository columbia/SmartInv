1 pragma solidity ^0.4.23;
2 ///////////////////////////////////////////////////
3 //  
4 //  `iCashweb` ICW Token Contract
5 //
6 //  Total Tokens: 300,000,000.000000000000000000
7 //  Name: iCashweb
8 //  Symbol: ICW
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
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC01Basic {
51   function allowance(address owner, address spender) public view returns(uint256);
52   function transferFrom(address from, address to, uint256 value) public returns(bool);
53   function approve(address spender, uint256 value) public returns(bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract ICWToken is ERC01Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61   address public contractModifierAddress;
62   uint256 _totalSupply;
63   uint256 _totalICOSupply;
64   uint256 _maxICOSupply;
65   uint256 RATE = 100;
66   bool _status;
67   bool _released;
68 
69   uint8 public constant decimals = 18;
70   uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(decimals));
71   uint256 public constant ICO_SUPPLY = 150000000 * (10 ** uint256(decimals));
72 
73   modifier onlyByOwned() {
74     require(msg.sender == contractModifierAddress);
75     _;
76   }
77 
78   function getReleased() public view returns(bool) {
79     return _released;
80   }
81   function getOwner() public view returns(address) {
82     return contractModifierAddress;
83   }
84   
85   function getICOStatus() public view returns(bool) {
86     return _status;
87   }
88 
89   function totalSupply() public view returns(uint256) {
90     return _totalSupply;
91   }
92 
93   function totalICOSupply() public view returns(uint256) {
94     return _totalICOSupply;
95   }
96 
97   function destroyContract() public onlyByOwned {
98     selfdestruct(contractModifierAddress);
99   }
100 
101   function changeOwnerShip(address _to) public onlyByOwned returns(bool) {
102     address oldOwner = contractModifierAddress;
103     uint256 balAmount = balances[oldOwner];
104     balances[_to] = balances[_to].add(balAmount);
105     balances[oldOwner] = 0;
106     contractModifierAddress = _to;
107     emit Transfer(oldOwner, contractModifierAddress, balAmount);
108     return true;
109   }
110 
111   function releaseIcoTokens() public onlyByOwned returns(bool) {
112     require(_released == false);
113     uint256 realeaseAmount = _maxICOSupply.sub(_totalICOSupply);
114     uint256 totalReleased = _totalICOSupply.add(realeaseAmount);
115     require(_maxICOSupply >= totalReleased);
116     _totalSupply = _totalSupply.add(realeaseAmount);
117     balances[contractModifierAddress] = balances[contractModifierAddress].add(realeaseAmount);
118     emit Transfer(contractModifierAddress, contractModifierAddress, realeaseAmount);
119     return true;
120   }
121 
122   function changeRate(uint256 _value) public onlyByOwned returns(bool) {
123     require(_value > 0);
124     RATE = _value;
125     return true;
126   }
127 
128   function startIco(bool status_) public onlyByOwned returns(bool) {
129     _status = status_;
130     return true;
131   }
132 
133   function transferTokens() public payable {
134     require(_status == true && msg.value > 0);
135     uint tokens = msg.value.mul(RATE);
136     uint totalToken = _totalICOSupply.add(tokens);
137     require(_maxICOSupply >= totalToken);
138     balances[msg.sender] = balances[msg.sender].add(tokens);
139     _totalICOSupply = _totalICOSupply.add(tokens);
140     contractModifierAddress.transfer(msg.value);
141   }
142 
143   function transfer(address _to, uint256 _value) public returns(bool) {
144     require(_to != msg.sender);
145     require(_value <= balances[msg.sender]);
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   function balanceOf(address _owner) public view returns(uint256 balance) {
153     return balances[_owner];
154   }
155 }
156 
157 contract iCashwebToken is ERC20, ICWToken {
158 
159   mapping(address => mapping(address => uint256)) internal allowed;
160 
161   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
162     require(_to != msg.sender);
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   function approve(address _spender, uint256 _value) public returns(bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   function allowance(address _owner, address _spender) public view returns(uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 }
199 
200 contract iCashweb is iCashwebToken {
201 
202   string public constant name = "iCashweb";
203   string public constant symbol = "ICW";
204 
205   constructor() public {
206     _status = false;
207     _released = false;
208     contractModifierAddress = msg.sender;
209     _totalSupply = INITIAL_SUPPLY;
210     _maxICOSupply = ICO_SUPPLY;
211     balances[msg.sender] = INITIAL_SUPPLY;
212   }
213 
214   function () public payable {
215     transferTokens();
216   }
217 }
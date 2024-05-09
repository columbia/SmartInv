1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20 {
47   function totalSupply() public view returns (uint256);
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51   
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 contract StandardToken is ERC20{
60     
61   using SafeMath for uint256;
62 
63   mapping (address => uint256) balances;
64   mapping (address => mapping (address => uint256)) internal allowed;
65 
66   uint256 totalSupply_;
67 
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70 
71   }
72 
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87   
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     emit Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     allowed[msg.sender][_spender] = _value;
102     emit Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106 
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108     return allowed[_owner][_spender];
109   }
110 
111   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
112     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
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
128 
129 }
130 
131 
132 contract RenCap is StandardToken {
133     
134     // Meta data
135     
136     string  public constant name        = "RenCap";
137     string  public constant symbol      = "RNP";
138     uint    public constant decimals    = 18;
139     uint256 public etherRaised = 0;
140     
141     
142     // Supply alocation and addresses
143 
144     uint public constant initialSupply  = 50000000 * (10 ** uint256(decimals));
145     uint public salesSupply             = 25000000 * (10 ** uint256(decimals));
146     uint public reserveSupply           = 22000000 * (10 ** uint256(decimals));
147     uint public coreSupply              = 3000000  * (10 ** uint256(decimals));
148     
149     uint public stageOneCap             =  4500000 * (10 ** uint256(decimals));
150     uint public stageTwoCap             = 13000000 * (10 ** uint256(decimals));
151     uint public stageThreeCap           =  4400000 * (10 ** uint256(decimals));
152     uint public stageFourCap            =  3100000 * (10 ** uint256(decimals));
153     
154 
155     address public FundsWallet          = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;
156     address public addressReserveSupply = 0x6567cb2bfB628c74a190C0aF5745Ae1c090223a3;
157     address public addressSalesSupply   = 0x010AfFE21A326E327C273295BBd509ff6446F2F3;
158     address public addressCoreSupply    = 0xbED065c02684364824749cE4dA317aC4231780AF;
159     address public owner;
160     
161     
162     // Dates
163 
164     uint public constant secondsInDay   = 86400; // 24hr * 60mnt * 60sec
165     
166     uint public stageOneStart           = 1523865600; // 16-Apr-18 08:00:00 UTC
167     uint public stageOneEnd             = stageOneStart + (15 * secondsInDay);
168   
169     uint public stageTwoStart           = 1525680000; // 07-May-18 08:00:00 UTC
170     uint public stageTwoEnd             = stageTwoStart + (22 * secondsInDay);
171   
172     uint public stageThreeStart         = 1528099200; // 04-Jun-18 08:00:00 UTC
173     uint public stageThreeEnd           = stageThreeStart + (15 * secondsInDay);
174   
175     uint public stageFourStart          = 1530518400; // 02-Jul-18 08:00:00 UTC
176     uint public stageFourEnd            = stageFourStart + (15 * secondsInDay);
177     
178 
179     // constructor
180     
181     function RenCap() public {
182         owner = msg.sender;
183         
184         totalSupply_                    = initialSupply;
185         balances[owner]                 = reserveSupply;
186         balances[addressSalesSupply]    = salesSupply;
187         balances[addressCoreSupply]     = coreSupply;
188         
189         emit Transfer(0x0, owner, reserveSupply);
190         emit Transfer(0x0, addressSalesSupply, salesSupply);
191         emit Transfer(0x0, addressCoreSupply, coreSupply);
192     }
193     
194     // Modifiers and Controllers
195     
196     
197     modifier onlyOwner() {
198         require(msg.sender == owner);
199         _;
200     }
201     
202     modifier onSaleRunning() {
203         // Checks, if ICO is running and has not been stopped
204         require(
205             (stageOneStart   <= now  &&  now <=   stageOneEnd && stageOneCap   >= 0 &&  msg.value <= 1000 ether) ||
206             (stageTwoStart   <= now  &&  now <=   stageTwoEnd && stageTwoCap   >= 0) ||
207             (stageThreeStart <= now  &&  now <= stageThreeEnd && stageThreeCap >= 0) ||
208             (stageFourStart  <= now  &&  now <=  stageFourEnd && stageFourCap  >= 0)
209             );
210         _;
211     }
212     
213     
214     
215     // ExchangeRate
216     
217     function rate() public view returns (uint256) {
218         if (stageOneStart   <= now  &&  now <=   stageOneEnd) return 1500;
219         if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) return 1300;
220         if (stageThreeStart <= now  &&  now <= stageThreeEnd) return 1100;
221             return 1030;
222     }
223     
224     
225     // Token Exchange
226     
227     function buyTokens(address _buyer, uint256 _value) internal {
228         require(_buyer != 0x0);
229         require(_value > 0);
230         uint256 tokens =  _value.mul(rate());
231       
232         balances[_buyer] = balances[_buyer].add(tokens);
233         balances[addressSalesSupply] = balances[addressSalesSupply].sub(tokens);
234         etherRaised = etherRaised.add(_value);
235         updateCap(tokens);
236         
237         owner.transfer(_value);
238         emit Transfer(addressSalesSupply, _buyer, tokens );
239     }
240     
241     // Token Cap Update
242 
243     function updateCap (uint256 _cap) internal {
244         if (stageOneStart   <= now  &&  now <=   stageOneEnd) {
245             stageOneCap = stageOneCap.sub(_cap);
246         }
247         if (stageTwoStart   <= now  &&  now <=   stageTwoEnd) {
248             stageTwoCap = stageTwoCap.sub(_cap);
249         }
250         if (stageThreeStart   <= now  &&  now <=   stageThreeEnd) {
251             stageThreeCap = stageThreeCap.sub(_cap);
252         }
253         if (stageFourStart   <= now  &&  now <=   stageFourEnd) {
254             stageFourCap = stageFourCap.sub(_cap);
255         }
256     }
257     
258     
259     // Fallback function
260     
261     function () public onSaleRunning payable {
262         require(msg.value >= 100 finney);
263         buyTokens(msg.sender, msg.value);
264     }
265   
266 }
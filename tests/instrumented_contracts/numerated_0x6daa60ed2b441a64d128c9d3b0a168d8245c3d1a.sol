1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract owned {
31     address public owner;
32 
33     function owned() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 }
42 
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address owner) public constant returns (uint256 balance);
46   function transfer(address to, uint256 value) public returns (bool success);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49  
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256 remaining);
52   function transferFrom(address from, address to, uint256 value) public returns (bool success);
53   function approve(address spender, uint256 value) public returns (bool success);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58     
59   using SafeMath for uint256;
60  
61   mapping (address => uint256) public balances;
62  
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0 && _to != address(this) && _to != address(0)) {
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     } else { return false; }
70   }
71 
72   function balanceOf(address _owner) public constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) allowed;
80  
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0 && _to != address(this) && _to != address(0)) {
83         var _allowance = allowed[_from][msg.sender];
84         balances[_to] = balances[_to].add(_value);
85         balances[_from] = balances[_from].sub(_value);
86         allowed[_from][msg.sender] = _allowance.sub(_value);
87         Transfer(_from, _to, _value);
88         return true;
89     } else { return false; }
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93       if (((_value == 0) || (allowed[msg.sender][_spender] == 0)) && _spender != address(this) && _spender != address(0)) {
94           allowed[msg.sender][_spender] = _value;
95           Approval(msg.sender, _spender, _value);
96           return true;
97       } else { return false; }
98   }
99 
100   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
101     return allowed[_owner][_spender];
102   }
103  
104 }
105 
106 contract UNICToken is owned, StandardToken {
107     
108     string public constant name = 'UNICToken';
109     string public constant symbol = 'UNIC';
110     uint8 public constant decimals = 18;
111     
112     uint256 public initialSupply = 250000000 * 10 ** uint256(decimals);
113     
114     address public icoManager;
115     
116     mapping (address => uint256) public WhiteList;
117 
118     modifier onlyManager() {
119         require(msg.sender == icoManager);
120         _;
121     }
122 
123     function UNICToken() public onlyOwner {
124       totalSupply = initialSupply;
125       balances[msg.sender] = initialSupply;
126     }
127 
128     function setICOManager(address _newIcoManager) public onlyOwner returns (bool) {
129       assert(_newIcoManager != 0x0);
130       icoManager = _newIcoManager;
131     }
132     
133     function setWhiteList(address _contributor) public onlyManager {
134       if(_contributor != 0x0){
135         WhiteList[_contributor] = 1;
136       }
137     }
138 }
139 
140 contract Crowdsale is owned, UNICToken {
141     
142   using SafeMath for uint;
143   
144   UNICToken public token = new UNICToken();
145   
146   address constant multisig = 0xDE4951a749DE77874ee72778512A2bA1e9032e7a;
147   uint constant rate = 3400 * 1000000000000000000;
148   
149   uint public constant presaleStart = 1518084000;   /** 08.02 */
150   uint public presaleEnd = 1520244000;              /** 05.03 */
151   uint public presaleDiscount = 30;
152   uint public presaleTokensLimit = 4250000 * 1000000000000000000;
153   uint public presaleWhitelistDiscount = 40;
154   uint public presaleWhitelistTokensLimit = 750000 * 1000000000000000000;
155 
156   uint public firstRoundICOStart = 1520848800;      /** 12.03 */
157   uint public firstRoundICOEnd = 1522058400;        /** 26.03 */
158   uint public firstRoundICODiscount = 15;
159   uint public firstRoundICOTokensLimit = 6250000 * 1000000000000000000;
160 
161   uint public secondRoundICOStart = 1522922400;     /** 05.04 */
162   uint public secondRoundICOEnd = 1524736800;       /** 26.04 */
163   uint public secondRoundICOTokensLimit = 43750000 * 1000000000000000000;
164 
165   uint public etherRaised;
166   uint public tokensSold;
167   uint public tokensSoldWhitelist;
168 
169   modifier saleIsOn() {
170     require((now >= presaleStart && now <= presaleEnd) ||
171       (now >= firstRoundICOStart && now <= firstRoundICOEnd)
172       || (now >= secondRoundICOStart && now <= secondRoundICOEnd)
173       );
174     _;
175   }
176 
177   function Crowdsale() public onlyOwner {
178     etherRaised = 0;
179     tokensSold = 0;
180     tokensSoldWhitelist = 0;
181   }
182   
183   function() external payable {
184     buyTokens(msg.sender);
185   }
186 
187   function buyTokens(address _buyer) saleIsOn public payable {
188     assert(_buyer != 0x0);
189     if(msg.value > 0){
190 
191       uint tokens = rate.mul(msg.value).div(1 ether);
192       uint discountTokens = 0;
193       if(now >= presaleStart && now <= presaleEnd) {
194           if(WhiteList[_buyer]==1) {
195               discountTokens = tokens.mul(presaleWhitelistDiscount).div(100);
196           }else{
197               discountTokens = tokens.mul(presaleDiscount).div(100);
198           }
199       }
200       if(now >= firstRoundICOStart && now <= firstRoundICOEnd) {
201           discountTokens = tokens.mul(firstRoundICODiscount).div(100);
202       }
203 
204       uint tokensWithBonus = tokens.add(discountTokens);
205       
206       if(
207           (now >= presaleStart && now <= presaleEnd && presaleTokensLimit > tokensSold + tokensWithBonus &&
208             ((WhiteList[_buyer]==1 && presaleWhitelistTokensLimit > tokensSoldWhitelist + tokensWithBonus) || WhiteList[_buyer]!=1)
209           ) ||
210           (now >= firstRoundICOStart && now <= firstRoundICOEnd && firstRoundICOTokensLimit > tokensSold + tokensWithBonus) ||
211           (now >= secondRoundICOStart && now <= secondRoundICOEnd && secondRoundICOTokensLimit > tokensSold + tokensWithBonus)
212       ){
213       
214         multisig.transfer(msg.value);
215         etherRaised = etherRaised.add(msg.value);
216         token.transfer(msg.sender, tokensWithBonus);
217         tokensSold = tokensSold.add(tokensWithBonus);
218         if(WhiteList[_buyer]==1) {
219           tokensSoldWhitelist = tokensSoldWhitelist.add(tokensWithBonus);
220         }
221       }
222     }
223   }
224 }
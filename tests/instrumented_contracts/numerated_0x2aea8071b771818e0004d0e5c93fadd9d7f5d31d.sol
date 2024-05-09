1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40   
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45     
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   function transfer(address _to, uint256 _value) returns (bool) {
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 contract StandardToken is ERC20, BasicToken {
64 
65   mapping (address => mapping (address => uint256)) allowed;
66 
67   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
68     var _allowance = allowed[_from][msg.sender];
69 
70     balances[_to] = balances[_to].add(_value);
71     balances[_from] = balances[_from].sub(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76 
77 
78   function approve(address _spender, uint256 _value) returns (bool) {
79 
80     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
81 
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87 
88   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89     return allowed[_owner][_spender];
90   }
91 
92 }
93 
94 contract Ownable {
95     
96   address public owner;
97 
98   function Ownable() {
99     owner = msg.sender;
100   }
101 
102 
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   function transferOwnership(address newOwner) onlyOwner {
109     require(newOwner != address(0));      
110     owner = newOwner;
111   }
112 
113 }
114 
115 contract MintableToken is StandardToken, Ownable {
116     
117   event Mint(address indexed to, uint256 amount);
118   
119   event MintFinished();
120 
121   bool public mintingFinished = false;
122 
123   modifier canMint() {
124     require(!mintingFinished);
125     _;
126   }
127 
128   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
129     totalSupply = totalSupply.add(_amount);
130     balances[_to] = balances[_to].add(_amount);
131     Mint(_to, _amount);
132     return true;
133   }
134 
135   function finishMinting() onlyOwner returns (bool) {
136     mintingFinished = true;
137     MintFinished();
138     return true;
139   }
140   
141 }
142 
143 /* @dev Specific contract details name , decimals */
144 
145 contract CIDToken is MintableToken {
146     
147     string public constant name = "CID";
148     
149     string public constant symbol = "CID";
150     
151     uint32 public constant decimals = 18;
152     
153 }
154 
155 
156 
157 contract CIDCrowdsale is Ownable {
158     
159     using SafeMath for uint;
160     
161     address public multisig;
162 
163     CIDToken public token = new CIDToken();
164 
165     uint start;
166     
167     uint endtime;
168 
169     uint hardcap;
170 
171     uint rate;
172     
173     uint softcap;
174     
175     address wal1;
176     address wal2;
177     address wal3;
178 
179     mapping(address => uint) public balances;
180     /* Specific contract details: Start time, End time, Min.Cap, Max.Cap,
181     Rate of Token to ETH, Final owner wallet, Team's bonuses wallet*/
182     function CIDCrowdsale() {
183         /** Final owner wallet */
184         multisig = 0x2338801bA8aEe40d679364bcA4e69d8C1B7a101C;
185         rate = 1000000000000000000000; 
186         start = 1517468400; /** 01.02.2018 in unix */
187         endtime = 1519776000;/** 28.02.2018in unix */
188         hardcap = 7000000 * (10 ** 18); /** 7 000 000 * 1e18 CID*/
189         softcap = 300000 * (10 ** 18); /** 300 000 1e18 */
190         
191         /*Team's bonuses wallet*/
192         wal1 = 0x35E0e717316E38052f6b74f144F2a7CE8318294b;
193         wal2 = 0xa9251f22203e34049aa5D4DbfE4638009A1586F5;
194         wal3 = 0xE9267a312B9Bc125557cff5146C8379cCEE3a33D;
195     }
196 
197     modifier saleIsOn() {
198     require(now > start && now < endtime);
199         _;
200     }
201     
202     modifier isUnderHardCap() {
203         require(this.balance <= hardcap);
204         _;
205     }
206     /* refund option for investors*/
207     function refund() public {
208         require(this.balance < softcap && now > start && balances[msg.sender] > 0);
209         uint value = balances[msg.sender];
210         balances[msg.sender] = 0;
211         msg.sender.transfer(value);
212     }
213     
214     /* when softcap reached , finish of token minting could be implemented */
215    function finishMinting() public onlyOwner {
216       uint finCheckBalance = softcap.div(rate);
217       if(this.balance > finCheckBalance) {
218         multisig.transfer(this.balance);
219         token.finishMinting();
220       }
221     }
222     
223     
224    function createTokens() isUnderHardCap saleIsOn payable {
225        
226         
227         uint tokens = rate.mul(msg.value).div(1 ether);
228         uint CTS = token.totalSupply(); /** check total Supply */
229         uint bonusTokens = 0;
230         
231         /* bonus tokens calculation for ICO stages */
232         if(CTS <= (300000 * (10 ** 18))) {
233           bonusTokens = (tokens.mul(30)).div(100);    /* 30% bonus */
234         } else if(CTS > (300000 * (10 ** 18)) && CTS <= (400000 * (10 ** 18)))  {
235           bonusTokens = (tokens.mul(25)).div(100);       /* 25% bonus */
236         } else if(CTS > (400000 * (10 ** 18)) && CTS <= (500000 * (10 ** 18))) {
237           bonusTokens = (tokens.mul(20)).div(100);         /* 20% bonus */
238         } else if(CTS > (500000 * (10 ** 18)) && CTS <= (700000 * (10 ** 18))) {
239           bonusTokens = (tokens.mul(15)).div(100);       /* 15% bonus */
240         } else if(CTS > (700000 * (10 ** 18)) && CTS <= (1000000 * (10 ** 18))) {
241           bonusTokens = (tokens.mul(10)).div(100);          /* 10% bonus */
242         } else if(CTS > (1000000 * (10 ** 18))) {
243           bonusTokens = 0;      /* 0% */
244         }
245         
246         tokens += bonusTokens;
247         token.mint(msg.sender, tokens);
248         
249         
250         balances[msg.sender] = balances[msg.sender].add(msg.value);
251         /** Team's bonus tokens calculation*/
252         uint wal1Tokens = (tokens.mul(25)).div(100);
253         token.mint(wal1, wal1Tokens);
254         
255         
256         uint wal2Tokens = (tokens.mul(10)).div(100);
257         token.mint(wal2, wal2Tokens);
258         
259         uint wal3Tokens = (tokens.mul(5)).div(100);
260         token.mint(wal3, wal3Tokens);
261         
262         
263        
264     }
265 
266    
267     function() external payable {
268         createTokens();
269     }
270     
271 }
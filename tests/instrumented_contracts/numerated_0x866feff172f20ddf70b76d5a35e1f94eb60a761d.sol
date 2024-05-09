1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Token {
28     function transfer(address _to, uint256 _value) returns(bool ok);
29 }
30 
31 contract WhiteList {
32     function checkAddress ( address _address ) constant public returns(bool);
33 }
34 
35 contract MultiOwnable {
36     
37     mapping(address => bool) public owners;
38     uint256 ownersCount;
39     
40     address[] public ownerslist;
41     
42     event OwnerAdded(address admin);
43     event OwnerRemoved(address admin);
44     
45     modifier onlyOwner() {
46         require(owners[msg.sender] == true);
47         _;
48     }
49     
50     constructor() public {
51         owners[msg.sender] = true;
52         ownersCount++;
53         ownerslist.push(msg.sender);
54     }
55     
56     function addOwner(address owner) public onlyOwner {
57         require(owner != 0x0);
58         owners[owner] = true;
59         ownerslist.push(owner);
60         emit OwnerAdded(owner);
61     }
62     
63     function removeOwner(address owner) public onlyOwner {
64         require(ownersCount > 1);
65         owners[owner] = false;
66         ownersCount--;
67         emit OwnerRemoved(owner);
68     }
69     
70     function isOwner(address _address) public returns(bool){
71         return owners[_address];
72     }
73     
74     
75 }
76 
77 contract FiatContract {
78     function ETH(uint _id) constant returns (uint256);
79     function USD(uint _id) constant returns (uint256);
80 }
81 
82 contract BSAFECrowdsale is MultiOwnable {
83     
84     FiatContract public fiat;
85 
86     using SafeMath for uint256;
87 
88     enum Status {CREATED, PRESTO, STO, FINISHED}
89 
90     event PreSTOStarted();
91     event STOStarted();
92     event SaleFinished();
93     event SalePaused();
94     event SaleUnpaused();
95     event Purchase(address to, uint256 amount);
96     event Withdrawal(address to, uint256 amount);
97     
98     event NewWallet(address _wallet);
99     event NewToken(address _token);
100 	
101     Status public status;
102 
103     uint256 public rate;
104     uint256 public saleSupply;
105     Token public token;
106     WhiteList public whitelist;
107     address public wallet;
108     uint256 price;
109 
110     bool public isPaused = true;
111     
112     uint public presto_min;
113     uint public sto_min;
114 
115     modifier whenPaused() {
116         require(isPaused);
117         _;
118     }
119     
120     modifier whenNotPaused() {
121         require(!isPaused);
122         _;
123     }
124     
125     function tokenFallback(address _from, uint _value, bytes _data) public {
126     }
127    
128 
129     /**
130      * @param _token Address of token to sale
131      * @param _wallet Address to withdraw funds
132      */
133      // use 0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909 for _fiatcontract
134      // deploy whitelist contract first in order to properly add whitelist contract
135     constructor(address _token, address _wallet, address _whitelist, address _fiatcontract) public {
136         token = Token(_token);
137         whitelist = WhiteList(_whitelist);
138         wallet = _wallet;
139         fiat = FiatContract( _fiatcontract ); 
140         status = Status.CREATED;
141         
142         presto_min = 2500000;
143         sto_min    =  100000;
144         
145     }
146     
147     function getPrice(uint256 _usd) constant returns(uint256) {
148         return _usd * fiat.USD(0);
149     }
150     
151     function startPreSTOSale() public onlyOwner {
152         require(status == Status.CREATED);
153         isPaused = false;
154         status = Status.PRESTO;
155         rate = 25;
156         emit PreSTOStarted();
157     }
158     
159     function startSTO() public onlyOwner {
160         require(status == Status.PRESTO);
161         status = Status.STO;
162         rate = 50;
163         emit STOStarted();
164     }
165     
166     /** 
167      * Ends crowdsale 
168      * Should be used carefully. You cannot start crowdsale twice
169      */
170     function finishSale() public onlyOwner {
171         status = Status.FINISHED;
172         isPaused = false;
173     }
174     
175     function pause() public onlyOwner {
176         isPaused = true;
177         emit SalePaused();
178     }
179     
180     function unpause() public onlyOwner {
181         isPaused = false;
182         emit SaleUnpaused();
183     }
184     
185     function buy(uint256 _wei) internal whenNotPaused{
186         require( whitelist.checkAddress(msg.sender) == true );
187 	require (  status != Status.FINISHED ) ;
188         if(status==Status.PRESTO) require ( msg.value >=  getPrice(presto_min) );
189         if(status==Status.STO)    require ( msg.value >=  getPrice(sto_min)    );
190         uint256 tokensAmount = calcTokens(_wei);
191         token.transfer(msg.sender, tokensAmount.mul(10**8));
192         emit Purchase(msg.sender, tokensAmount);
193     }
194     
195     function() external payable whenNotPaused{
196         buy(msg.value);
197     }
198     
199     function calcTokens(uint256 _amount) public constant returns (uint256) {
200         return _amount.div( getPrice(rate) );    
201     }
202     
203     function setTokenContract(address _address) public onlyOwner whenPaused {
204         require(_address != 0x0);
205         token = Token(_address);
206         emit NewToken(_address);
207     }
208     
209     function setWallet(address _address) public onlyOwner whenPaused {
210         require(_address != 0x0);
211         wallet = _address;
212         emit NewWallet(_address);
213     }
214     
215     function withdraw(address _to, uint256 _amount) public onlyOwner {
216         require(_to != 0x0);
217         _to.transfer(_amount);
218         emit Withdrawal(_to, _amount);
219     }
220     
221     function withdrawBSAFE(address _to, uint256 _amount) public onlyOwner {
222         require(_to != 0x0);
223         token.transfer(_to, _amount);
224         emit Withdrawal(_to, _amount);
225     }
226     
227     function updateSTOPrice ( uint _newprice ) public onlyOwner {
228         sto_min = _newprice;
229     }
230     
231      
232 }
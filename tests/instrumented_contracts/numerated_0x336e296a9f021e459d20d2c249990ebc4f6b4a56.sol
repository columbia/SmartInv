1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract OwOWorldToken {
30 
31     using SafeMath for uint256;
32 
33     string public constant symbol = "OWO";
34     string public constant name = "OwO.World Token";
35     uint public constant decimals = 18;
36 
37     uint public _owoAmount;
38     uint public _totalSupply = 0;
39 
40     uint public _oneTokenInWei = 108931000000000; // starts at $0.02
41     bool public _CROWDSALE_PAUSED = false;
42 
43     address public _ownerWallet;   // owner wallet
44     address public _multiSigWallet;  // The address to hold the funds donated
45     uint public _totalEthCollected = 0;            // In wei
46     bool public _saleFinalized = false;         // Has OwO Dev finalized the sale?
47 
48     uint constant public dust = 1 finney;    // Minimum investment
49     uint public _cap = 50000 ether;       // Hard cap to protect the ETH network from a really high raise
50     uint public _capOwO = 100000000 * 10 ** decimals;   // total supply of owo for the crowdsale
51 
52     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 25;
53 
54     /* How many distinct addresses have invested */
55     uint public _investorCount = 0;
56 
57     /* the UNIX timestamp end date of the crowdsale */
58     uint public _endsAt;
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62     // Crowdsale end time has been changed
63     event EndsAtChanged(uint endsAt);
64 
65     mapping(address => uint256) balances;
66     mapping(address => mapping(address => uint256)) allowed;
67     mapping (address => uint256) public investedAmountOf;
68     mapping (address => uint256) public tokenAmountOf;
69 
70 
71     function () payable{
72         createTokens();
73     }
74 
75     function OwOWorldToken()
76     {
77 
78         _ownerWallet = msg.sender;
79 
80         uint tokenAmount = 500000 * 10 ** decimals;
81         balances[_ownerWallet] = balances[_ownerWallet].add(tokenAmount);
82         _totalSupply = _totalSupply.add(tokenAmount);
83         _multiSigWallet = 0x6c5140f605a9Add003B3626Aae4f08F41E6c6FfF;
84         _endsAt = 1514332800;
85 
86     }
87 
88     modifier onlyOwner(){
89         require(msg.sender == _ownerWallet);
90         _;
91     }
92 
93     function setOneTokenInWei(uint w) onlyOwner {
94         _oneTokenInWei = w;
95         changed(msg.sender);
96     }
97 
98     function setMultiSigWallet(address w) onlyOwner {
99         require(w != 0
100           && _investorCount < MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE
101           );
102 
103           _multiSigWallet = w;
104 
105         changed(msg.sender);
106     }
107 
108     function setEndsAt(uint time) onlyOwner {
109 
110       require(now < time);
111 
112       _endsAt = time;
113       EndsAtChanged(_endsAt);
114     }
115 
116     function setPause(bool w) onlyOwner{
117         _CROWDSALE_PAUSED = w;
118         changed(msg.sender);
119     }
120 
121    function setFinalized(bool w) onlyOwner{
122         _saleFinalized = w;
123         changed(msg.sender);
124         if(_saleFinalized == true){
125             withdraw();
126         }
127     }
128 
129     function getMultiSigWallet() constant returns (address){
130 
131         return _multiSigWallet;
132 
133     }
134     function getMultiSigBalance() constant returns (uint){
135 
136         return balances[_multiSigWallet];
137 
138     }
139     function getTotalSupply() constant returns (uint){
140 
141         return _totalSupply;
142 
143     }
144 
145 
146     function getTotalEth() constant returns (uint){
147 
148         return _totalEthCollected;
149 
150     }
151 
152     function getTotalPlayers() constant returns (uint){
153 
154         return _investorCount;
155 
156     }
157     function createTokens() payable{
158 
159         require(
160             msg.value > 0
161             && _totalSupply < _capOwO
162             && _CROWDSALE_PAUSED ==false
163             && _saleFinalized == false
164             && now < _endsAt
165             );
166 
167                //priced at $0.03
168             if(_totalSupply >500001 && _totalSupply<1000000 && _oneTokenInWei<135714800000000){
169                 _oneTokenInWei = 135714800000000;
170             }
171             //priced at $0.04
172             if(_totalSupply >1000001 && _totalSupply<2000000 && _oneTokenInWei<180953100000000){
173                 _oneTokenInWei = 180953100000000;
174             }
175             //priced at $0.05
176             if(_totalSupply>2000001 && _totalSupply<4000000 && _oneTokenInWei<226191400000000){
177                 _oneTokenInWei = 226191400000000;
178             }
179             //priced at $0.06
180             if(_totalSupply>4000001 && _totalSupply<6000000 && _oneTokenInWei<271429700000000){
181               _oneTokenInWei = 271429700000000;
182             }
183             //priced at $0.07
184             if(_totalSupply>6000001 && _totalSupply<8000000 && _oneTokenInWei<316667900000000){
185               _oneTokenInWei = 316667900000000;
186             }
187             //priced at $0.08
188             if(_totalSupply>8000001 && _totalSupply<10000001 && _oneTokenInWei<361906200000000){
189               _oneTokenInWei = 361906200000000;
190             }
191 
192 
193             if(investedAmountOf[msg.sender] == 0) {
194                    // A new investor
195                    _investorCount = _investorCount.add(1);
196             }
197 
198             _owoAmount = msg.value.div(_oneTokenInWei);
199 
200             balances[msg.sender] = balances[msg.sender].add(_owoAmount);
201             _totalSupply = _totalSupply.add(_owoAmount);
202             _totalEthCollected = _totalEthCollected.add(msg.value);
203             investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);
204 
205             transfer(_ownerWallet,msg.value);
206 
207 
208 
209     }
210 
211     function balanceOf(address _owner) constant returns(uint256 balance){
212 
213         return balances[_owner];
214 
215     }
216 
217     event changed(address a);
218 
219     function transfer(address _to, uint256 _value) returns(bool success){
220         require(
221             balances[msg.sender] >= _value
222             && _value > 0
223             );
224             balances[msg.sender].sub(_value);
225             balances[_to].add(_value);
226             Transfer(msg.sender, _to, _value);
227             return true;
228     }
229 
230     function transferFrom(address _from, address _to, uint256 _value) onlyOwner returns (bool success){
231         require(
232             allowed[_from][msg.sender] >= _value
233             && balances[_from] >= _value
234             && _value >0
235 
236             );
237 
238             balances[_from].sub(_value);
239             balances[_to].add(_value);
240             allowed[_from][msg.sender].sub(_value);
241             Transfer(_from,_to,_value);
242             return true;
243     }
244 
245     function getBlockNumber() constant internal returns (uint) {
246         return block.number;
247     }
248 
249     function withdraw() onlyOwner payable{
250 
251          assert(_multiSigWallet.send(this.balance));
252 
253      }
254 
255 
256 }
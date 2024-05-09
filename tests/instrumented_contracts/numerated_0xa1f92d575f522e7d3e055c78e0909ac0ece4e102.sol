1 pragma solidity ^0.4.15;
2 
3 contract ERC223Interface {
4     uint public totalSupply;
5     function balanceOf(address who) constant returns (uint);
6     function transfer(address to, uint value);
7     function transfer(address to, uint value, bytes data);
8     event Transfer(address indexed from, address indexed to, uint value, bytes data);
9 }
10 
11 contract ERC223ReceivingContract { 
12 /**
13  * @dev Standard ERC223 function that will handle incoming token transfers.
14  *
15  * @param _from  Token sender address.
16  * @param _value Amount of tokens.
17  * @param _data  Transaction metadata.
18  */
19     function tokenFallback(address _from, uint _value, bytes _data);
20 }
21 
22 /**
23  * Math operations with safety checks
24  */
25 library SafeMath {
26   function mul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint a, uint b) internal returns (uint) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 
74 /**
75  * @title Reference implementation of the ERC223 standard token.
76  */
77 contract ERC223Token is ERC223Interface {
78     using SafeMath for uint;
79 
80     mapping(address => uint) balances; // List of user balances.
81     
82     /**
83      * @dev Transfer the specified amount of tokens to the specified address.
84      *      Invokes the `tokenFallback` function if the recipient is a contract.
85      *      The token transfer fails if the recipient is a contract
86      *      but does not implement the `tokenFallback` function
87      *      or the fallback function to receive funds.
88      *
89      * @param _to    Receiver address.
90      * @param _value Amount of tokens that will be transferred.
91      * @param _data  Transaction metadata.
92      */
93     function transfer(address _to, uint _value, bytes _data) {
94         // Standard function transfer similar to ERC20 transfer with no _data .
95         // Added due to backwards compatibility reasons .
96         uint codeLength;
97 
98         assembly {
99             // Retrieve the size of the code on target address, this needs assembly .
100             codeLength := extcodesize(_to)
101         }
102 
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         if(codeLength>0) {
106             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
107             receiver.tokenFallback(msg.sender, _value, _data);
108         }
109         Transfer(msg.sender, _to, _value, _data);
110     }
111     
112     /**
113      * @dev Transfer the specified amount of tokens to the specified address.
114      *      This function works the same with the previous one
115      *      but doesn't contain `_data` param.
116      *      Added due to backwards compatibility reasons.
117      *
118      * @param _to    Receiver address.
119      * @param _value Amount of tokens that will be transferred.
120      */
121     function transfer(address _to, uint _value) {
122         uint codeLength;
123         bytes memory empty;
124 
125         assembly {
126             // Retrieve the size of the code on target address, this needs assembly .
127             codeLength := extcodesize(_to)
128         }
129 
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         if(codeLength>0) {
133             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
134             receiver.tokenFallback(msg.sender, _value, empty);
135         }
136         Transfer(msg.sender, _to, _value, empty);
137     }
138 
139     
140     /**
141      * @dev Returns balance of the `_owner`.
142      *
143      * @param _owner   The address whose balance will be returned.
144      * @return balance Balance of the `_owner`.
145      */
146     function balanceOf(address _owner) constant returns (uint balance) {
147         return balances[_owner];
148     }
149 }
150 
151 contract CoVEXTokenERC223 is ERC223Token{
152     using SafeMath for uint256;
153 
154     string public name = "CoVEX Coin";
155     string public symbol = "CoVEX";
156     uint256 public decimals = 18;
157 
158     // 250M
159     uint256 public totalSupply = 250*1000000 * (uint256(10) ** decimals);
160     uint256 public totalRaised; // total ether raised (in wei)
161 
162     uint256 public startTimestamp; // timestamp after which ICO will start
163     uint256 public durationSeconds; // 1 month= 1 * 30 * 24 * 60 * 60
164 
165     uint256 public maxCap;
166 
167     uint256 coinsPerETH;
168 
169     mapping(address => uint) etherBalance;
170 
171     mapping(uint => uint) public weeklyRewards;
172 
173     uint256 minPerUser = 0.1 ether;
174     uint256 maxPerUser = 100 ether;
175 
176     /**
177      * Address which will receive raised funds 
178      * and owns the total supply of tokens
179      */
180     address public fundsWallet;
181 
182     function CoVEXTokenERC223() {
183         fundsWallet = msg.sender;
184         
185         startTimestamp = now;
186         durationSeconds = 0; //admin can set it later
187 
188         //initially assign all tokens to the fundsWallet
189         balances[fundsWallet] = totalSupply;
190 
191         bytes memory empty;
192         Transfer(0x0, fundsWallet, totalSupply, empty);
193     }
194 
195     function() isIcoOpen checkMinMax payable{
196         totalRaised = totalRaised.add(msg.value);
197 
198         uint256 tokenAmount = calculateTokenAmount(msg.value);
199         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
200         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
201 
202         etherBalance[msg.sender] = etherBalance[msg.sender].add(msg.value);
203 
204         bytes memory empty;
205         Transfer(fundsWallet, msg.sender, tokenAmount, empty);
206 
207         // immediately transfer ether to fundsWallet
208         fundsWallet.transfer(msg.value);
209     }
210 
211     function transfer(address _to, uint _value){
212         return super.transfer(_to, _value);
213     }
214 
215     function transfer(address _to, uint _value, bytes _data){
216         return super.transfer(_to, _value, _data);   
217     }
218 
219     function calculateTokenAmount(uint256 weiAmount) constant returns(uint256) {
220         uint256 tokenAmount = weiAmount.mul(coinsPerETH);
221         // setting rewards is possible only for 4 weeks
222         for (uint i = 1; i <= 4; i++) {
223             if (now <= startTimestamp + (i * 7 days)) {
224                 return tokenAmount.mul(100+weeklyRewards[i]).div(100);    
225             }
226         }
227         return tokenAmount;
228     }
229 
230     /**
231      * @dev Burns a specific amount of tokens.
232      * @param _value The amount of token to be burned.
233      */
234     function adminBurn(uint256 _value) public {
235       require(_value <= balances[msg.sender]);
236       // no need to require value <= totalSupply, since that would imply the
237       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
238       address burner = msg.sender;
239       balances[burner] = balances[burner].sub(_value);
240       totalSupply = totalSupply.sub(_value);
241       bytes memory empty;
242       Transfer(burner, address(0), _value, empty);
243     }
244 
245     function adminAddICO(uint256 _startTimestamp, uint256 _durationSeconds, 
246         uint256 _coinsPerETH, uint256 _maxCap, uint _week1Rewards,
247         uint _week2Rewards, uint _week3Rewards, uint _week4Rewards) isOwner{
248 
249         startTimestamp = _startTimestamp;
250         durationSeconds = _durationSeconds;
251         coinsPerETH = _coinsPerETH;
252         maxCap = _maxCap * 1 ether;
253 
254         weeklyRewards[1] = _week1Rewards;
255         weeklyRewards[2] = _week2Rewards;
256         weeklyRewards[3] = _week3Rewards;
257         weeklyRewards[4] = _week4Rewards;
258 
259         // reset totalRaised
260         totalRaised = 0;
261     }
262 
263     modifier isIcoOpen() {
264         require(now >= startTimestamp);
265         require(now <= (startTimestamp + durationSeconds));
266         require(totalRaised <= maxCap);
267         _;
268     }
269 
270     modifier checkMinMax(){
271       require(msg.value >= minPerUser);
272       require(msg.value <= maxPerUser);
273       _;
274     }
275 
276     modifier isOwner(){
277         require(msg.sender == fundsWallet);
278         _;
279     }
280 }
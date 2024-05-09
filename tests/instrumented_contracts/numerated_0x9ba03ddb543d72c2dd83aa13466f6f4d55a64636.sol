1 pragma solidity ^0.4.15;
2 contract Base {
3     modifier only(address allowed) {
4         require(msg.sender == allowed);
5         _;
6     }
7     // *************************************************
8     // *          reentrancy handling                  *
9     // *************************************************
10     uint constant internal L00 = 2 ** 0;
11     uint constant internal L01 = 2 ** 1;
12     uint constant internal L02 = 2 ** 2;
13     uint constant internal L03 = 2 ** 3;
14     uint constant internal L04 = 2 ** 4;
15     uint constant internal L05 = 2 ** 5;
16     uint private bitlocks = 0;
17     modifier noAnyReentrancy {
18         var _locks = bitlocks;
19         require(_locks == 0);
20         bitlocks = uint(-1);
21         _;
22         bitlocks = _locks;
23     }
24 }
25 contract IToken {
26     function mint(address _to, uint _amount);
27     function start();
28     function getTotalSupply() returns(uint);
29     function balanceOf(address _owner) returns(uint);
30     function transfer(address _to, uint _amount) returns (bool success);
31     function transferFrom(address _from, address _to, uint _value) returns (bool success);
32 }
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 contract Owned is Base {
60     address public owner;
61     address newOwner;
62     function Owned() {
63         owner = msg.sender;
64     }
65     function transferOwnership(address _newOwner) only(owner) {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() only(newOwner) {
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 }
74 contract Crowdsale is Owned {
75     using SafeMath for uint;
76     enum State { INIT, PRESALE, PREICO, PREICO_FINISHED, ICO_FIRST, ICO_SECOND, ICO_THIRD, STOPPED, CLOSED, EMERGENCY_STOP}
77     uint public constant MAX_SALE_SUPPLY = 24 * (10**25);
78     uint public constant DECIMALS = (10**18);
79     State public currentState = State.INIT;
80     IToken public token;
81     uint public totalSaleSupply = 0;
82     uint public totalFunds = 0;
83     uint public tokenPrice = 1000000000000000000; //wei
84     uint public bonus = 50000; //50%
85     uint public currentPrice;
86     address public beneficiary;
87     mapping(address => uint) balances;
88  
89     address public foundersWallet; //replace
90     uint public foundersAmount = 160000000 * DECIMALS;
91     uint public maxPreICOSupply = 48 * (10**24);
92     uint public maxICOFirstSupply = 84 * (10**24);
93     uint public maxICOSecondSupply = 48 * (10**24);
94     uint public maxICOThirdSupply = 24 * (10**24);
95     uint public currentRoundSupply = 0;
96     uint private bonusBase = 100000; //100%;
97     modifier inState(State _state){
98         require(currentState == _state);
99         _;
100     }
101     modifier salesRunning(){
102         require(currentState == State.PREICO 
103         || currentState == State.ICO_FIRST
104         || currentState == State.ICO_SECOND
105         || currentState == State.ICO_THIRD);
106         _;
107     }
108     modifier minAmount(){
109         require(msg.value >= 0.2 ether);
110         _;
111     }
112     
113     event Transfer(address indexed _to, uint _value);
114     function Crowdsale(address _foundersWallet, address _beneficiary){
115         beneficiary = _beneficiary;
116         foundersWallet = _foundersWallet;
117     }
118     function initialize(IToken _token)
119     public
120     only(owner)
121     inState(State.INIT)
122     {
123         require(_token != address(0));
124         token = _token;
125         currentPrice = tokenPrice;
126         _mint(foundersWallet, foundersAmount);
127     }
128     function setBonus(uint _bonus) public
129     only(owner)
130     {
131         bonus = _bonus;
132     }
133     function setPrice(uint _tokenPrice)
134     public
135     only(owner)
136     {
137         currentPrice = _tokenPrice;
138     }
139     function setState(State _newState)
140     public
141     only(owner)
142     {
143         require(
144         currentState == State.INIT && _newState == State.PRESALE
145         || currentState == State.PRESALE && _newState == State.PREICO
146         || currentState == State.PREICO && _newState == State.PREICO_FINISHED
147         || currentState == State.PREICO_FINISHED && _newState == State.ICO_FIRST
148         || currentState == State.ICO_FIRST && _newState == State.STOPPED
149         || currentState == State.STOPPED && _newState == State.ICO_SECOND        
150         || currentState == State.ICO_SECOND && _newState == State.STOPPED
151         || currentState == State.STOPPED && _newState == State.ICO_THIRD
152         || currentState == State.ICO_THIRD && _newState == State.CLOSED
153         || _newState == State.EMERGENCY_STOP
154         );
155         currentState = _newState;
156         if(_newState == State.PREICO 
157         || _newState == State.ICO_FIRST
158         || _newState == State.ICO_SECOND
159         || _newState == State.ICO_THIRD){
160             currentRoundSupply = 0;
161         }
162         if(_newState == State.CLOSED){
163             _finish();
164         }
165     }
166     function setStateWithBonus(State _newState, uint _bonus)
167     public
168     only(owner)
169     {
170         require(
171         currentState == State.INIT && _newState == State.PRESALE
172         || currentState == State.PRESALE && _newState == State.PREICO
173         || currentState == State.PREICO && _newState == State.PREICO_FINISHED
174         || currentState == State.PREICO_FINISHED && _newState == State.ICO_FIRST
175         || currentState == State.ICO_FIRST && _newState == State.STOPPED
176         || currentState == State.STOPPED && _newState == State.ICO_SECOND        
177         || currentState == State.ICO_SECOND && _newState == State.STOPPED
178         || currentState == State.STOPPED && _newState == State.ICO_THIRD
179         || currentState == State.ICO_THIRD && _newState == State.CLOSED
180         || _newState == State.EMERGENCY_STOP
181         );
182         currentState = _newState;
183         bonus = _bonus;
184         if(_newState == State.CLOSED){
185             _finish();
186         }
187     }
188     function mintPresale(address _to, uint _amount)
189     public
190     only(owner)
191     inState(State.PRESALE)
192     {
193         require(totalSaleSupply.add(_amount) <= MAX_SALE_SUPPLY);
194         totalSaleSupply = totalSaleSupply.add(_amount);
195         _mint(_to, _amount);
196     }
197     function ()
198     public
199     payable
200     salesRunning
201     minAmount
202     {
203         _receiveFunds();
204     }
205 
206     //==================== Internal Methods =================
207     function _receiveFunds()
208     internal
209     {
210         require(msg.value != 0);
211         uint transferTokens = msg.value.mul(DECIMALS).div(currentPrice);
212         require(totalSaleSupply.add(transferTokens) <= MAX_SALE_SUPPLY);
213         uint bonusTokens = transferTokens.mul(bonus).div(bonusBase);
214         transferTokens = transferTokens.add(bonusTokens);
215         _checkMaxRoundSupply(transferTokens);
216         totalSaleSupply = totalSaleSupply.add(transferTokens);
217         balances[msg.sender] = balances[msg.sender].add(msg.value);
218         totalFunds = totalFunds.add(msg.value);
219         _mint(msg.sender, transferTokens);
220         beneficiary.transfer(msg.value);
221         Transfer(msg.sender, transferTokens);
222     }
223     function _mint(address _to, uint _amount)
224     noAnyReentrancy
225     internal
226     {
227         token.mint(_to, _amount);
228     }
229     function _checkMaxRoundSupply(uint _amountTokens)
230     internal
231     {
232         if (currentState == State.PREICO) {
233             require(currentRoundSupply.add(_amountTokens) <= maxPreICOSupply);
234         } else if (currentState == State.ICO_FIRST) {
235             require(currentRoundSupply.add(_amountTokens) <= maxICOFirstSupply);
236         } else if (currentState == State.ICO_SECOND) {
237             require(currentRoundSupply.add(_amountTokens) <= maxICOSecondSupply);
238         } else if (currentState == State.ICO_THIRD) {
239             require(currentRoundSupply.add(_amountTokens) <= maxICOThirdSupply);
240         }
241     }
242     function _finish()
243     noAnyReentrancy
244     internal
245     {
246         token.start();
247     }
248 }
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
32     function burn(uint256 _amount, address _address)  returns (bool success);
33 }
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
40         uint256 c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal constant returns (uint256) {
45         // assert(b > 0); // Solidity automatically throws when dividing by 0
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return c;
49     }
50     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54     function add(uint256 a, uint256 b) internal constant returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 contract Owned is Base {
61     address public owner;
62     address newOwner;
63     function Owned() {
64         owner = msg.sender;
65     }
66     function transferOwnership(address _newOwner) only(owner) {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() only(newOwner) {
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 }
75 contract Crowdsale is Owned {
76     using SafeMath for uint;
77     enum State { INIT, PRESALE, PREICO, PREICO_FINISHED, ICO_FIRST, ICO_SECOND, ICO_THIRD, STOPPED, CLOSED, EMERGENCY_STOP}
78     uint public constant MAX_SALE_SUPPLY = 24 * (10**25);
79     uint public constant DECIMALS = (10**18);
80     State public currentState = State.INIT;
81     IToken public token;
82     uint public totalSaleSupply = 0;
83     uint public totalFunds = 0;
84     uint public tokenPrice = 1000000000000000000; //wei
85     uint public bonus = 50000; //50%
86     uint public currentPrice;
87     address public beneficiary;
88     mapping(address => uint) balances;
89 
90     address public foundersWallet; //replace
91     uint public foundersAmount = 160000000 * DECIMALS;
92     uint public maxPreICOSupply = 48 * (10**24);
93     uint public maxICOFirstSupply = 84 * (10**24);
94     uint public maxICOSecondSupply = 48 * (10**24);
95     uint public maxICOThirdSupply = 24 * (10**24);
96     uint public currentRoundSupply = 0;
97     uint private bonusBase = 100000; //100%;
98     modifier inState(State _state){
99         require(currentState == _state);
100         _;
101     }
102     modifier salesRunning(){
103         require(currentState == State.PREICO
104         || currentState == State.ICO_FIRST
105         || currentState == State.ICO_SECOND
106         || currentState == State.ICO_THIRD);
107         _;
108     }
109     modifier minAmount(){
110         require(msg.value >= 0.2 ether);
111         _;
112     }
113 
114     event Transfer(address indexed _to, uint _value);
115     function Crowdsale(address _foundersWallet, address _beneficiary){
116         beneficiary = _beneficiary;
117         foundersWallet = _foundersWallet;
118     }
119     function initialize(IToken _token)
120     public
121     only(owner)
122     inState(State.INIT)
123     {
124         require(_token != address(0));
125         token = _token;
126         currentPrice = tokenPrice;
127         _mint(foundersWallet, foundersAmount);
128     }
129     function setBonus(uint _bonus) public
130     only(owner)
131     {
132         bonus = _bonus;
133     }
134     function setPrice(uint _tokenPrice)
135     public
136     only(owner)
137     {
138         currentPrice = _tokenPrice;
139     }
140     function setState(State _newState)
141     public
142     only(owner)
143     {
144         require(
145             currentState == State.INIT && _newState == State.PRESALE
146             || currentState == State.PRESALE && _newState == State.PREICO
147             || currentState == State.PREICO && _newState == State.PREICO_FINISHED
148             || currentState == State.PREICO_FINISHED && _newState == State.ICO_FIRST
149             || currentState == State.ICO_FIRST && _newState == State.STOPPED
150             || currentState == State.STOPPED && _newState == State.ICO_SECOND
151             || currentState == State.ICO_SECOND && _newState == State.STOPPED
152             || currentState == State.STOPPED && _newState == State.ICO_THIRD
153             || currentState == State.ICO_THIRD && _newState == State.CLOSED
154             || _newState == State.EMERGENCY_STOP
155         );
156         currentState = _newState;
157         if(_newState == State.PREICO
158         || _newState == State.ICO_FIRST
159         || _newState == State.ICO_SECOND
160         || _newState == State.ICO_THIRD){
161             currentRoundSupply = 0;
162         }
163         if(_newState == State.CLOSED){
164             _finish();
165         }
166     }
167     function setStateWithBonus(State _newState, uint _bonus)
168     public
169     only(owner)
170     {
171         require(
172             currentState == State.INIT && _newState == State.PRESALE
173             || currentState == State.PRESALE && _newState == State.PREICO
174             || currentState == State.PREICO && _newState == State.PREICO_FINISHED
175             || currentState == State.PREICO_FINISHED && _newState == State.ICO_FIRST
176             || currentState == State.ICO_FIRST && _newState == State.STOPPED
177             || currentState == State.STOPPED && _newState == State.ICO_SECOND
178             || currentState == State.ICO_SECOND && _newState == State.STOPPED
179             || currentState == State.STOPPED && _newState == State.ICO_THIRD
180             || currentState == State.ICO_THIRD && _newState == State.CLOSED
181             || _newState == State.EMERGENCY_STOP
182         );
183         currentState = _newState;
184         bonus = _bonus;
185         if(_newState == State.CLOSED){
186             _finish();
187         }
188     }
189     function mintPresale(address _to, uint _amount)
190     public
191     only(owner)
192     inState(State.PRESALE)
193     {
194         require(totalSaleSupply.add(_amount) <= MAX_SALE_SUPPLY);
195         totalSaleSupply = totalSaleSupply.add(_amount);
196         _mint(_to, _amount);
197     }
198     function ()
199     public
200     payable
201     salesRunning
202     minAmount
203     {
204         _receiveFunds();
205     }
206 
207 
208 
209     //==================== Internal Methods =================
210     function _receiveFunds()
211     internal
212     {
213         require(msg.value != 0);
214         uint transferTokens = msg.value.mul(DECIMALS).div(currentPrice);
215         require(totalSaleSupply.add(transferTokens) <= MAX_SALE_SUPPLY);
216         uint bonusTokens = transferTokens.mul(bonus).div(bonusBase);
217         transferTokens = transferTokens.add(bonusTokens);
218         _checkMaxRoundSupply(transferTokens);
219         totalSaleSupply = totalSaleSupply.add(transferTokens);
220         balances[msg.sender] = balances[msg.sender].add(msg.value);
221         totalFunds = totalFunds.add(msg.value);
222         _mint(msg.sender, transferTokens);
223         beneficiary.transfer(msg.value);
224         Transfer(msg.sender, transferTokens);
225     }
226     function _mint(address _to, uint _amount)
227     noAnyReentrancy
228     internal
229     {
230         token.mint(_to, _amount);
231     }
232     function _checkMaxRoundSupply(uint _amountTokens)
233     internal
234     {
235         if (currentState == State.PREICO) {
236             require(currentRoundSupply.add(_amountTokens) <= maxPreICOSupply);
237         } else if (currentState == State.ICO_FIRST) {
238             require(currentRoundSupply.add(_amountTokens) <= maxICOFirstSupply);
239         } else if (currentState == State.ICO_SECOND) {
240             require(currentRoundSupply.add(_amountTokens) <= maxICOSecondSupply);
241         } else if (currentState == State.ICO_THIRD) {
242             require(currentRoundSupply.add(_amountTokens) <= maxICOThirdSupply);
243         }
244     }
245 
246     function burn(uint256 _amount, address _address) only(owner) {
247         require(token.burn(_amount, _address));
248 	totalSaleSupply = totalSaleSupply.sub(_amount);
249     }
250 
251     function _finish()
252     noAnyReentrancy
253     internal
254     {
255         token.start();
256     }
257 }
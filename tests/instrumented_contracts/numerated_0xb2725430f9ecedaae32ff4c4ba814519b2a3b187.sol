1 pragma solidity ^ 0.4.19;
2 /*
3 ---------------------------------------------------
4 Let’s play. If you win, we’ll give you the answer.
5 ---------------------------------------------------
6        /¯¯\
7    /¯¯¯ \\\\_
8   ///&&&   \\\
9 /&&//&&&// ///__
10 \&&&&///&&// // \
11  \//&&//&&&&   //
12   ¯¯¯¯¯¯¯¯¯¯¯¯¯
13 
14  _______
15 |      |\
16 |      |_\
17 | ~~~~~~~ |
18 | ~~~~~~~ |
19 | ~~~~~~~ |
20 |_________|
21 
22 
23 #,         ,#
24  ##       ##
25   ###, ,###
26    '#####'
27 /##### #####/
28 #   #   #   #
29  ###     ###
30 
31  ---------------------------------------------------
32  https://www.casheth.org/
33  ---------------------------------------------------
34  
35  */
36 contract Cdl {
37     using SafeXHD for uint;
38     uint public constant configTimeInit = 24 hours;
39     uint public constant configTimeInc = 30 seconds;
40     uint public constant configTimeMax = 24 hours;
41     uint public constant configRunTime = 24 hours;
42     uint public constant configPerShares = 75;
43     uint public constant configPerFund = 10;
44     uint public constant configRoundKey = 75000000000000;
45     uint public constant configRoundKeyAdd = 156230000;
46     uint public constant configMaxKeys = 10000000;
47     uint public runTime = 0;
48     uint public allEth = 0;
49     uint public allEthShares = 0;
50     uint public allTime = 0;
51     uint public allKeys = 0;
52     uint public roundEth = 0;
53     uint public roundEthShares = 0;
54     uint public roundTime = 0;
55     uint public roundKeys = 0;
56     uint public round = 0;
57     uint public roundPot = 0;
58     uint public roundPrice = 0;
59     uint private roundToSharesPrice=0;
60     address public roundLeader;
61     mapping(address => uint) public accountRounds;
62     mapping(address => uint) public accountShares;
63     mapping(address => uint) public accountSharesOut;
64     mapping(address => uint) public accountKeys;
65     address[] roundAddress;
66     address public owner;
67     uint public ownerEth = 0;
68     function doStart() public payable returns(uint) {
69         require(round == 0);
70         require(runTime <= 0);
71         require(
72             msg.sender == 0xbEBA30E7F05581fd7330A58743b0331BD7dd5508 ||
73             msg.sender == 0x479F9dFAdaF30Fba069d8a9f017D881C648B5ac0 ||
74             msg.sender == 0x7B034094a0D1F1545c5558F422E71EdA6f47313D ||
75             msg.sender == 0x9DDA48c596fc52642ace5A0ff470425e4d550095 ||
76             msg.sender == 0xE05ac79525bdB0Ec238Bd2982Fb63Ca2d7f778a0 ||
77             msg.sender == 0x57854E9293789854dF8fCfDd3AD845bf15e35BBc ||
78             msg.sender == 0x968F54Fd6edDEEcEBfE2B0CA45BfEe82D2629BfE);
79 
80         runTime = now.add(configRunTime);
81         roundTime = runTime.add(configTimeInit);
82         owner = msg.sender; 
83         roundPrice = configRoundKey;
84         round = round.add(1);
85         roundLeader = owner;
86         roundAddress = [owner];
87         return runTime;
88     }
89 
90     function buyKey() public payable newRoundIfNeeded returns(uint) {
91       
92             require(msg.value > 0);
93             uint _msgValue = msg.value;
94             uint _amountToShares = _msgValue.div(100).mul(configPerShares); 
95             uint _amountToFund = _msgValue.div(100).mul(configPerFund); 
96             uint _amountToPot = _msgValue.sub(_amountToShares).sub(_amountToFund);
97              uint _keys = _msgValue.div(roundPrice);
98             require(configMaxKeys >= _keys); 
99 			ownerEth=ownerEth.add(_amountToFund);
100             fundoShares(_amountToShares); 
101             roundEth = roundEth.add(_msgValue);
102             roundEthShares = roundEthShares.add(_amountToShares);
103             roundKeys = roundKeys.add(_keys);
104             roundPot = roundPot.add(_amountToPot);
105             allEth = allEth.add(_msgValue);
106             allEthShares = allEthShares.add(_amountToShares);
107             allKeys = allKeys.add(_keys);
108             funComputeRoundPrice();
109             funComputeRoundTime(_keys); 
110             roundLeader = msg.sender;
111 
112             if (accountKeys[msg.sender] <= 0 || accountRounds[msg.sender] != round) roundAddress.push(msg.sender);
113             if (accountRounds[msg.sender] == round) {
114                 accountKeys[msg.sender] = accountKeys[msg.sender].add(_keys);
115             } else {
116                 accountRounds[msg.sender] = round;
117                 accountKeys[msg.sender] = _keys;
118             }
119              
120             return _keys;
121            
122         }
123 
124     function withdrawl() public payable newRoundIfNeeded returns(uint) {
125         require(accountShares[msg.sender] > 0);
126         uint _withdraw = accountShares[msg.sender].sub(accountSharesOut[msg.sender]);
127         require(_withdraw > 0);
128         accountSharesOut[msg.sender] = accountSharesOut[msg.sender].add(_withdraw);
129         msg.sender.transfer(_withdraw);
130         return _withdraw;
131     }
132 
133     function withdrawlOwner() public payable returns(uint) {
134 		require(
135             msg.sender == 0xbEBA30E7F05581fd7330A58743b0331BD7dd5508 ||
136             msg.sender == 0x479F9dFAdaF30Fba069d8a9f017D881C648B5ac0 ||
137             msg.sender == 0x7B034094a0D1F1545c5558F422E71EdA6f47313D ||
138             msg.sender == 0x9DDA48c596fc52642ace5A0ff470425e4d550095 ||
139             msg.sender == 0xE05ac79525bdB0Ec238Bd2982Fb63Ca2d7f778a0 ||
140             msg.sender == 0x57854E9293789854dF8fCfDd3AD845bf15e35BBc ||
141             msg.sender == 0x968F54Fd6edDEEcEBfE2B0CA45BfEe82D2629BfE
142         );
143         require(ownerEth> 0);
144         msg.sender.transfer(ownerEth);
145 		ownerEth=0;
146         return ownerEth;
147     }
148 
149     modifier newRoundIfNeeded {
150         require(runTime > 0);
151         require(now > runTime);
152         require(round > 0);
153       
154         if (now > roundTime) {
155             uint _nextPot = 0;
156             uint _leaderEarnings = roundPot.sub(_nextPot);
157             accountShares[roundLeader] = accountShares[roundLeader].add(_leaderEarnings);
158             round++;
159             roundPot = _nextPot;
160             roundLeader = owner;
161             roundTime = now.add(configTimeInit);
162             roundEth = roundPot;
163             roundEthShares = 0;
164             roundKeys = 0;
165             funComputeRoundPrice(); 
166             allEth = allEth.add(roundEth);
167             allEthShares = allEthShares.add(roundEthShares);
168             roundAddress = [owner];
169         }
170        
171         _;
172     }
173 
174 
175     function funComputeRoundTime(uint keys) private {
176         uint _now = now;
177         if (_now >= roundTime)
178             roundTime = (configTimeInc.mul(keys)).add(_now);
179         else
180             roundTime = (configTimeInc.mul(keys)).add(roundTime);
181 
182         if (roundTime >= (configTimeMax).add(_now))
183             roundTime = (configTimeMax).add(_now);
184         allTime = allTime.add(configTimeInc.mul(keys));
185     }
186 
187     function funComputeRoundPrice() private {
188             if (roundKeys > 0) roundPrice = configRoundKey.add(roundKeys.mul(configRoundKeyAdd));
189             if (roundKeys <= 0 || roundPrice <= configRoundKey) roundPrice = configRoundKey;
190         }
191 
192     function fundoShares(uint _amountToShares) private {
193         roundToSharesPrice=0;
194         require(_amountToShares > roundKeys);
195          roundToSharesPrice = _amountToShares.div(roundKeys);
196         for (uint i = 0; i < roundAddress.length; i++) {
197             address _address = roundAddress[i];
198             if (accountRounds[_address] == round && _address != owner) {
199                  accountShares[_address] = accountShares[_address].add(roundToSharesPrice.mul(accountKeys[_address]));
200             }
201         }
202     }
203 
204 }
205 
206 
207 library SafeXHD {
208    
209     function div(uint a, uint b) internal pure returns(uint) {
210             if (b == 0) {
211                 return 0;
212             }
213             uint c = a / b;
214             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215             return c;
216         }
217      
218     function mul(uint a, uint b) internal pure returns(uint) {
219             if (a == 0) {
220                 return 0;
221             }
222             uint c = a * b;
223             assert(c / a == b);
224             return c;
225         }
226       
227     function sub(uint a, uint b) internal pure returns(uint) {
228         assert(b <= a);
229         return a - b;
230     }
231 
232     function add(uint a, uint b) internal pure returns(uint) {
233         uint c = a + b;
234         assert(c >= a);
235         return c;
236     }
237 
238 }
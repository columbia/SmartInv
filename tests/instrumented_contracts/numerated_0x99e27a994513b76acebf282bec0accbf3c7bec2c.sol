1 pragma solidity ^0.4.23;
2 
3 contract Events {
4     event onGiveKeys(
5         address addr,
6         uint256 keys
7     );
8 
9     event onShareOut(
10         uint256 dividend
11     );
12 }
13 
14 contract Referral is Events {
15     using SafeMath for *;
16 
17 //==============================================================================
18 //   modifier
19 //==============================================================================
20     modifier onlyAdministrator(){
21         address _customerAddress = msg.sender; 
22         require(administrators[keccak256(_customerAddress)]);
23         _;
24     }
25 //==============================================================================
26 //   config
27 //==============================================================================
28     string public name = "PTReferral";
29     string public symbol = "PT7Dα";
30     uint256 constant internal magnitude = 1e18;
31 //==============================================================================
32 //   dataset
33 //==============================================================================
34     uint256 public pID_ = 0;
35     uint256 public keySupply_ = 0;
36 
37     mapping(address => uint256) public pIDxAddr_;
38     mapping(uint256 => address) public AddrxPID_;
39     mapping(bytes32 => bool) public administrators;
40     mapping(address => uint256) public keyBalanceLedger_;
41 //==============================================================================
42 //   public functions
43 //==============================================================================
44     constructor()
45         public
46     {
47         administrators[0x14c319c3c982350b442e4074ec4736b3ac376ebdca548bdda0097040223e7bd6] = true;
48     }
49 //==============================================================================
50 //   private functions
51 //==============================================================================
52     function getPlayerID(address addr)
53         private
54         returns (uint256)
55     {
56         uint256 _pID = pIDxAddr_[addr];
57         if (_pID == 0)
58         {
59             pID_++;
60             _pID = pID_;
61             pIDxAddr_[addr] = _pID;
62             AddrxPID_[_pID] = addr;
63         } 
64         return (_pID);
65     }
66 //==============================================================================
67 //   external functions
68 //==============================================================================
69     // profits from other contracts
70     function outerDividend()
71         external
72         payable
73     {
74     }
75 //==============================================================================
76 //   administrator only functions
77 //==============================================================================
78     function setAdministrator(bytes32 _identifier, bool _status)
79         public
80         onlyAdministrator()
81     {
82         administrators[_identifier] = _status;
83     }
84     
85     function setName(string _name)
86         public
87         onlyAdministrator()
88     {
89         name = _name;
90     }
91 
92     function setSymbol(string _symbol)
93         public
94         onlyAdministrator()
95     {
96         symbol = _symbol;
97     }
98 
99     function giveKeys(address _toAddress, uint256 _amountOfkeys)
100         public
101         onlyAdministrator()
102         returns(bool)
103     {
104         getPlayerID(_toAddress);
105 
106         keySupply_ = keySupply_.add(_amountOfkeys);
107         keyBalanceLedger_[_toAddress] = keyBalanceLedger_[_toAddress].add(_amountOfkeys);
108 
109         emit onGiveKeys(_toAddress, _amountOfkeys);
110         return true;
111     }
112 
113     function shareOut(uint256 _dividend)
114         public
115         onlyAdministrator()
116     {
117         require(_dividend <= this.balance,"exceeded the maximum");
118 
119         if (keySupply_ > 0)
120         {
121             for (uint256 i = 1; i <= pID_; i++)
122             {
123                 address _addr = AddrxPID_[i];
124                 _addr.transfer(keyBalanceLedger_[_addr].mul(_dividend).div(keySupply_));
125             }
126             emit onShareOut(_dividend);
127         }
128     }
129 
130 //==============================================================================
131 //   view only functions
132 //==============================================================================
133     function totalEthereumBalance()
134         public
135         view
136         returns(uint)
137     {
138         return this.balance;
139     }
140 }
141 
142 library SafeMath {
143     function mul(uint256 a, uint256 b) 
144         internal 
145         pure 
146         returns (uint256 c) 
147     {
148         if (a == 0) {
149             return 0;
150         }
151         c = a * b;
152         require(c / a == b, "SafeMath mul failed");
153         return c;
154     }
155 
156     function div(uint256 a, uint256 b) 
157         internal 
158         pure 
159         returns (uint256) 
160     {
161         uint256 c = a / b;
162         return c;
163     }
164 
165     function sub(uint256 a, uint256 b)
166         internal
167         pure
168         returns (uint256) 
169     {
170         require(b <= a, "SafeMath sub failed");
171         return a - b;
172     }
173 
174     function add(uint256 a, uint256 b)
175         internal
176         pure
177         returns (uint256 c) 
178     {
179         c = a + b;
180         require(c >= a, "SafeMath add failed");
181         return c;
182     }
183     
184     function sqrt(uint256 x)
185         internal
186         pure
187         returns (uint256 y) 
188     {
189         uint256 z = ((add(x,1)) / 2);
190         y = x;
191         while (z < y) 
192         {
193             y = z;
194             z = ((add((x / z),z)) / 2);
195         }
196     }
197     
198     function sq(uint256 x)
199         internal
200         pure
201         returns (uint256)
202     {
203         return (mul(x,x));
204     }
205     
206     function pwr(uint256 x, uint256 y)
207         internal 
208         pure 
209         returns (uint256)
210     {
211         if (x==0)
212             return (0);
213         else if (y==0)
214             return (1);
215         else 
216         {
217             uint256 z = x;
218             for (uint256 i=1; i < y; i++)
219                 z = mul(z,x);
220             return (z);
221         }
222     }
223 }
1 pragma solidity ^0.5.8;
2 
3 contract IBNEST {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf( address who ) public view returns (uint value);
6     function allowance( address owner, address spender ) public view returns (uint _allowance);
7 
8     function transfer( address to, uint256 value) external;
9     function transferFrom( address from, address to, uint value) public returns (bool ok);
10     function approve( address spender, uint value ) public returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14     
15     function balancesStart() public view returns(uint256);
16     function balancesGetBool(uint256 num) public view returns(bool);
17     function balancesGetNext(uint256 num) public view returns(uint256);
18     function balancesGetValue(uint256 num) public view returns(address, uint256);
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (_a == 0) {
31       return 0;
32     }
33 
34     c = _a * _b;
35     assert(c / _a == _b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     assert(_b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = _a / _b;
45     assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
46     return _a / _b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     assert(_b <= _a);
54     return _a - _b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
61     c = _a + _b;
62     assert(c >= _a);
63     return c;
64   }
65 }
66 
67 //  映射合约
68 contract IBMapping {
69     //  查询地址
70 	function checkAddress(string memory name) public view returns (address contractAddress);
71 	//  查看是否管理员
72 	function checkOwners(address man) public view returns (bool);
73 }
74 
75 library address_make_payable {
76    function make_payable(address x) internal pure returns (address payable) {
77       return address(uint160(x));
78    }
79 }
80 
81 contract NESTSave {
82     function takeOut(uint256 num) public;
83     function depositIn(uint256 num) public;
84     function takeOutPrivate() public;
85     function checkAmount(address sender) public view returns(uint256);
86 }
87 
88 contract Abonus {
89     function getETH(uint256 num) public;    
90     function getETHNum() public view returns (uint256);
91 }
92 
93 contract NESTAbonus {
94     using address_make_payable for address;
95     using SafeMath for uint256;
96     IBNEST nestContract;
97     IBMapping mappingContract;                  
98     NESTSave baseMapping;
99     Abonus abonusContract;
100     
101     uint256 timeLimit = 168 hours;                    
102     uint256 nextTime = 1562299200;                   
103     uint256 getAbonusTimeLimit = 60 hours;           
104     
105     uint256 ethNum = 0;                         
106     uint256 nestAllValue = 0;                   
107     uint256 times = 0;                          
108     
109     mapping(uint256 => mapping(address => bool)) getMapping;
110     constructor (address map) public {
111         mappingContract = IBMapping(map); 
112         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
113         baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
114         address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
115         abonusContract = Abonus(addr);
116     }
117 
118     function changeMapping(address map) public {
119         mappingContract = IBMapping(map); 
120         nestContract = IBNEST(address(mappingContract.checkAddress("nest")));
121         baseMapping = NESTSave(address(mappingContract.checkAddress("nestSave")));
122         address payable addr = address(mappingContract.checkAddress("abonus")).make_payable();
123         abonusContract = Abonus(addr);
124     }
125     
126     function depositIn(uint256 amount) public {
127         require(isContract(address(msg.sender)) == false);          
128         uint256 nowTime = now;
129         if (nowTime < nextTime) {
130             require(!(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)));
131         } else {
132             require(!(nowTime >= nextTime && nowTime <= nextTime.add(getAbonusTimeLimit)));
133             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
134             uint256 startTime = nextTime.add((time).mul(timeLimit));         
135             uint256 endTime = startTime.add(getAbonusTimeLimit);                     
136             require(!(nowTime >= startTime && nowTime <= endTime));
137         }
138         baseMapping.depositIn(amount);                              
139     }
140     
141     function takeOut(uint256 amount) public {
142         require(isContract(address(msg.sender)) == false);          
143         require(amount != 0);                                       
144         require(amount <= baseMapping.checkAmount(address(msg.sender)));
145         baseMapping.takeOut(amount);                         
146     }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
147     
148     function getETH() public {
149         require(isContract(address(msg.sender)) == false);          
150         reloadTimeAndMapping ();                
151         uint256 nowTime = now;
152         require(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit));
153         require(getMapping[times.sub(1)][address(msg.sender)] != true);     
154         uint256 nestAmount = baseMapping.checkAmount(address(msg.sender));
155         require(nestAmount > 0);
156         require(nestAllValue > 0);
157         uint256 selfEth = nestAmount.mul(ethNum).div(nestAllValue);
158         require(selfEth > 0);
159         
160         getMapping[times.sub(1)][address(msg.sender)] = true;
161         abonusContract.getETH(selfEth);                           
162     }
163     
164     function reloadTimeAndMapping () private {
165         require(isContract(address(msg.sender)) == false);          
166         uint256 nowTime = now;
167         if (nowTime >= nextTime) {                                                      
168             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
169             uint256 startTime = nextTime.add((time).mul(timeLimit));         
170             uint256 endTime = startTime.add(getAbonusTimeLimit);                     
171             if (nowTime >= startTime && nowTime <= endTime) {
172                 nextTime = getNextTime();                               
173                 times = times.add(1);                                   
174                 ethNum = abonusContract.getETHNum();                    
175                 nestAllValue = allValue();                              
176             }
177         }
178     }
179     
180     function getInfo() public view returns (uint256 _nextTime, uint256 _getAbonusTime, uint256 _ethNum, uint256 _nestValue, uint256 _myJoinNest, uint256 _getEth, uint256 _allowNum, uint256 _leftNum, bool allowAbonus)  {
181         uint256 nowTime = now;
182         if (nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(getAbonusTimeLimit)) {
183             allowAbonus = getMapping[times.sub(1)][address(msg.sender)];
184             _ethNum = ethNum;
185             _nestValue = nestAllValue;
186             
187         } else {
188             _ethNum = abonusContract.getETHNum();
189             _nestValue = allValue();
190             allowAbonus = getMapping[times][address(msg.sender)];
191         }
192         _myJoinNest = baseMapping.checkAmount(address(msg.sender));
193         if (allowAbonus == true) {
194             _getEth = 0; 
195         } else {
196             _getEth = _myJoinNest.mul(_ethNum).div(_nestValue);
197         }
198         
199        
200         _nextTime = getNextTime();
201         _getAbonusTime = _nextTime.sub(timeLimit).add(getAbonusTimeLimit);
202         _allowNum = nestContract.allowance(address(msg.sender), address(baseMapping));
203         _leftNum = nestContract.balanceOf(address(msg.sender));
204         
205     }
206     
207     function getNextTime() public view returns (uint256) {
208         uint256 nowTime = now;
209         if (nextTime >= nowTime) { 
210             return nextTime; 
211         } else {
212             uint256 time = (nowTime.sub(nextTime)).div(timeLimit);
213             return nextTime.add(timeLimit.mul(time.add(1)));
214         }
215     }
216     
217     function allValue() public view returns (uint256) {
218         uint256 all = 10000000000 ether;
219         uint256 leftNum = all.sub(nestContract.balanceOf(address(mappingContract.checkAddress("miningSave"))));
220         return leftNum;
221     }
222     function changeTimeLimit(uint256 hour) public onlyOwner {
223         require(hour > 0);
224         timeLimit = hour.mul(1 hours);
225     }
226 
227     function changeGetAbonusTimeLimit(uint256 hour) public onlyOwner {
228         require(hour > 0);
229         getAbonusTimeLimit = hour;
230     }
231 
232     modifier onlyOwner(){
233         require(mappingContract.checkOwners(msg.sender) == true);
234         _;
235     }
236     function isContract(address addr) public view returns (bool) {
237         uint size;
238         assembly { size := extcodesize(addr) }
239         return size > 0;
240     }
241 }
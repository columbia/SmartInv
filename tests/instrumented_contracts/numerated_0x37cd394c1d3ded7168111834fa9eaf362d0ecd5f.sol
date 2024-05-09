1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title owned
33  * @dev The owned contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract owned {
37     address public owner;
38 
39     function owned() public {
40         owner = msg.sender;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) onlyOwner public {
56         owner = newOwner;
57     }
58 }
59 
60 
61 /**
62  * @title Controlled
63  * @dev Base contract which allows children to implement an emergency stop mechanism.
64  */
65 contract Controlled is owned {
66 
67   bool public paused = false;
68 
69   /**
70    * @dev Modifier to make a function callable only when the contract is not paused.
71    */
72   modifier whenNotPaused() {
73     require(!paused);
74     _;
75   }
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is paused.
79    */
80   modifier whenPaused() {
81     require(paused);
82     _;
83   }
84 
85   /**
86    * @dev called by the owner to pause, triggers stopped state
87    */
88   function pause() onlyOwner whenNotPaused public {
89     paused = true;
90   }
91 
92   /**
93    * @dev called by the owner to unpause, returns to normal state
94    */
95   function unpause() onlyOwner whenPaused public {
96     paused = false;
97   }
98 }
99 
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken.
104  */
105 contract BasicToken is Controlled{
106     using SafeMath for uint256;
107     
108     uint256       _supply;
109     mapping (address => uint256)    _balances;
110     
111     event Transfer( address indexed from, address indexed to, uint256 value);
112 
113     function BasicToken() public {    }
114     
115     function totalSupply() public view returns (uint256) {
116         return _supply;
117     }
118     function balanceOf(address _owner) public view returns (uint256) {
119         return _balances[_owner];
120     }
121     
122     /**
123      * @dev transfer token for a specified address
124      * @param _to The address to transfer to.
125      * @param _value The amount to be transferred.
126      */
127     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
128         require(_balances[msg.sender] >= _value && _value > 0);
129         
130         _balances[msg.sender] =_balances[msg.sender].sub(_value);
131         _balances[_to] =_balances[_to].add(_value);
132         
133         emit Transfer(msg.sender, _to, _value);
134         
135         return true;
136     }
137   
138 }
139 
140 contract AicToken is BasicToken {
141     string  constant public symbol = "AIC";
142     string  constant public name = "AicBlock";
143     uint256 constant public decimals = 18;
144     uint256 public lockedCounts = 0;
145 
146     struct LockStruct {
147         uint256 unlockTime;
148         bool locked;
149     }
150     
151     uint256[][] public unlockCountArray;
152     address[] public addressArray;
153     LockStruct[] public unlockTimeMap;
154 
155     function AicToken() public {
156         
157         _supply = 10*(10**8)*(10**18);
158         _balances[0x01] = _supply;
159         lockedCounts = _supply;
160         
161         //2018
162         unlockTimeMap.push(LockStruct({unlockTime:1527782400, locked: true})); 
163         unlockTimeMap.push(LockStruct({unlockTime:1535731200, locked: true})); 
164         unlockTimeMap.push(LockStruct({unlockTime:1543593600, locked: true})); 
165         //2019
166         unlockTimeMap.push(LockStruct({unlockTime:1551369600, locked: true})); 
167         unlockTimeMap.push(LockStruct({unlockTime:1559318400, locked: true})); 
168         unlockTimeMap.push(LockStruct({unlockTime:1567267200, locked: true})); 
169         unlockTimeMap.push(LockStruct({unlockTime:1575129600, locked: true})); 
170         //2020
171         unlockTimeMap.push(LockStruct({unlockTime:1582992000, locked: true})); 
172         unlockTimeMap.push(LockStruct({unlockTime:1590940800, locked: true})); 
173         unlockTimeMap.push(LockStruct({unlockTime:1598889600, locked: true}));
174         unlockTimeMap.push(LockStruct({unlockTime:1606752000, locked: true}));
175         
176         unlockCountArray = new uint256[][](7);
177         unlockCountArray[0] = [28000000,10500000,10500000,10500000,10500000,0,0,0,0,0,0];
178         unlockCountArray[1] = [70000000,17500000,17500000,17500000,17500000,0,0,0,0,0,0];
179         unlockCountArray[2] = [168000000,18000000,18000000,18000000,18000000,0,0,0,0,0,0];
180         unlockCountArray[3] = [0,0,25000000,0,25000000,0,0,0,0,0,0];
181         unlockCountArray[4] = [0,0,20000000,0,20000000,0,20000000,0,20000000,0,20000000];
182         unlockCountArray[5] = [0,0,50000000,0,50000000,0,50000000,0,50000000,0,50000000];
183         unlockCountArray[6] = [0,15000000,15000000,15000000,15000000,15000000,15000000,15000000,15000000,15000000,15000000];
184     
185     }
186   
187     
188     function setAddressArr(address[] self) onlyOwner public {
189         //Only call once
190         require(unlockTimeMap[0].locked);
191         require (self.length==7);
192         
193         addressArray = new address[](self.length);
194         for (uint i = 0; i < self.length; i++){
195            addressArray[i]=self[i]; 
196         }
197     
198     }
199 
200     function transfer(address _to, uint256 _value) public returns (bool) {
201         require (now >= unlockTimeMap[0].unlockTime);
202 
203         return super.transfer(_to, _value);
204     }
205 
206      /**
207      * @dev unlock , only can be called by owner.
208      */
209     function unlock(uint256 _index) onlyOwner public {
210          
211         require (addressArray.length == 7);
212         require(_index >= 0 && _index < unlockTimeMap.length);
213         require(now >= unlockTimeMap[_index].unlockTime && unlockTimeMap[_index].locked);
214 
215         for (uint _addressIndex = 0; _addressIndex < addressArray.length; _addressIndex++) {
216             
217           uint256 unlockCount = unlockCountArray[_addressIndex][_index].mul(10**18);
218 
219           require(_balances[0x01] >= unlockCount);
220 
221           _balances[addressArray[_addressIndex]] = _balances[addressArray[_addressIndex]].add(unlockCount);
222           _balances[0x01] = _balances[0x01].sub(unlockCount);
223           
224           lockedCounts = lockedCounts.sub(unlockCount);
225 
226           emit Transfer(0x01, addressArray[_addressIndex], unlockCount);  
227         }
228 
229         unlockTimeMap[_index].locked = false;
230     }
231   
232 }
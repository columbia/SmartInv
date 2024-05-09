1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public ctOwner;
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == ctOwner);
44     _;
45   }
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
49    */
50   function Ownable() public {
51     ctOwner = msg.sender;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(ctOwner, newOwner);
61     ctOwner = newOwner;
62   }
63 }
64 
65 contract MasterRule is Ownable {
66   address public masterAddr;
67 
68   function setMasterAddr(address _newMasterAddr) public onlyOwner {
69     masterAddr = _newMasterAddr;
70   }
71 
72   /**
73    * @dev Throws if called by any contract other than the Master-Contract address that has been set.
74    */
75   modifier onlyMaster() {
76     require(msg.sender == masterAddr);
77     _;
78   }
79 }
80 
81 contract SCHToken {
82   function setBalanceForAddr(address _addr, uint256 _value) public;
83   function balanceOf(address _owner) public view returns (uint256 balance);
84   function incrementStage() public;
85   function getCurrentStageSpent() public view returns (uint256);
86   function setCurrentStageSpent(uint256 _value) public;
87   function totalSupply() public view returns (uint256);
88   function getTotalSpent() public view returns (uint256);
89   function setTotalSpent(uint256 _value) public; 
90   function getCurrentCap() public view returns (uint256);
91   function setCurrentCap(uint256 _value) public;
92   function allowance(address _owner, address _spender) public view returns (uint256);
93   function setAllowance(address _owner, address _spender, uint256 _value) public;
94   function addAddrToIndex(address _addr) public;
95 }
96 
97 contract SCHTSub is MasterRule {
98 
99   using SafeMath for uint256;
100 
101   function transfer(address _to, uint256 _value, address origin) public onlyMaster returns (bool) {
102     require(_to != address(0));
103     require(origin == ctOwner);
104 
105     SCHToken mc = SCHToken(masterAddr);
106     require(mc.getCurrentStageSpent().add(_value) <= mc.getCurrentCap());
107 
108     uint256 from_balance = mc.balanceOf(origin);
109     require(_value <= from_balance);
110 
111     mc.setBalanceForAddr(origin, from_balance.sub(_value));
112     mc.setBalanceForAddr(_to, mc.balanceOf(_to).add(_value));
113     mc.addAddrToIndex(_to);
114     mc.setCurrentStageSpent(mc.getCurrentStageSpent().add(_value));
115     return true;
116   }
117 
118   function transferFromTo(address _from, address _to, uint256 _value, address origin) public onlyMaster returns (bool) {
119     require(_from != address(0));
120     require(_to != address(0));
121     require(origin == ctOwner);
122 
123     SCHToken mc = SCHToken(masterAddr);
124 
125     uint256 from_balance = mc.balanceOf(_from);
126     require(_value <= from_balance);
127 
128     mc.setBalanceForAddr(_from, from_balance.sub(_value));
129     mc.setBalanceForAddr(_to, mc.balanceOf(_to).add(_value));
130     return true;
131   }
132 
133   function changeStage(uint256 _stageCapValue) public onlyMaster {
134     SCHToken mc = SCHToken(masterAddr);
135     uint256 totalSPent = mc.getTotalSpent();
136     require(totalSPent.add(_stageCapValue)<=mc.totalSupply());
137     uint256  balanceFromLast = mc.getCurrentCap().sub(mc.getCurrentStageSpent());
138     mc.incrementStage();
139     mc.setCurrentCap(_stageCapValue.add(balanceFromLast));
140     mc.setTotalSpent(_stageCapValue.add(totalSPent));
141     mc.setCurrentStageSpent(0);
142   }
143 
144   function approve(address _spender, uint256 _value, address origin) public onlyMaster returns (bool) {
145     require(origin == ctOwner);
146     SCHToken mc = SCHToken(masterAddr);
147     mc.setAllowance(origin, _spender, _value);
148     return true;
149   }
150 
151   function transferFrom(address _from, address _to, uint256 _value, address origin) public onlyMaster returns (bool) {
152     require(_to != address(0));
153     require(origin == ctOwner);
154 
155     SCHToken mc = SCHToken(masterAddr);
156 
157     uint256 from_balance = mc.balanceOf(_from);
158     uint256 allowance_value = mc.allowance(_from,_to);
159 
160     require(_value <= from_balance);
161     require(_value <= allowance_value);
162 
163     mc.setBalanceForAddr(_from, from_balance.sub(_value));
164     mc.setBalanceForAddr(_to, mc.balanceOf(_to).add(_value));
165     mc.addAddrToIndex(_to);
166 
167     mc.setAllowance(_from, _to, allowance_value.sub(_value));
168     return true;
169   }
170 
171   function increaseApproval(address _spender, uint _addedValue, address origin) public onlyMaster returns (bool) {
172     require(origin == ctOwner);
173     SCHToken mc = SCHToken(masterAddr);
174     mc.setAllowance(origin, _spender, mc.allowance(origin, _spender).add(_addedValue));
175     return true;
176   }
177 
178   function decreaseApproval(address _spender, uint _subtractedValue, address origin) public onlyMaster returns (bool) {
179     require(origin == ctOwner);
180     SCHToken mc = SCHToken(masterAddr);
181     uint256 oldValue = mc.allowance(origin,_spender);
182     if (_subtractedValue >= oldValue) {
183       mc.setAllowance(origin, _spender, 0);
184     } else {
185       mc.setAllowance(origin, _spender, oldValue.sub(_subtractedValue));
186     }
187     return true;
188   }
189 }
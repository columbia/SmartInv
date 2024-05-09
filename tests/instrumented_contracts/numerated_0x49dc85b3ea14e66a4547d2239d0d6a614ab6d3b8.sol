1 pragma solidity ^0.4.18;
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
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     emit Pause();
76   }
77 
78   function unpause() onlyOwner whenPaused public {
79     paused = false;
80     emit Unpause();
81   }
82 }
83 
84 
85 
86 contract TokenSale is Ownable ,Pausable {
87   
88   uint256 public weiRaised;       
89   uint256 public saleHardcap;   
90   uint256 public personalMincap;  
91   uint256 public startTime;    
92   uint256 public endTime;       
93   bool    public isFinalized;     
94   
95   uint256 public mtStartTime; 
96   uint256 public mtEndTime;      
97 
98   mapping (address => uint256) public beneficiaryFunded; 
99 
100   function TokenSale() public 
101     { 
102       startTime = 1526634000; //  (2018.05.15 09:00:00 UTC);
103       endTime = 1527778800;   //  (2018.05.31 15:00:00 UTC);
104       saleHardcap = 17411.9813 * (1 ether);
105       personalMincap = 1 ether;
106       isFinalized = false;
107       weiRaised = 0x00;
108     }
109 
110   function () public payable {
111     buyPresale();
112   }
113 
114   function buyPresale() public payable 
115   whenNotPaused
116   {
117     address beneficiary = msg.sender;
118     uint256 toFund = msg.value;  
119     // check validity
120     require(!isFinalized);
121     require(validPurchase());   
122         
123     uint256 postWeiRaised = SafeMath.add(weiRaised, toFund); 
124     require(postWeiRaised <= saleHardcap);
125 
126     weiRaised = SafeMath.add(weiRaised, toFund);     
127     beneficiaryFunded[beneficiary] = SafeMath.add(beneficiaryFunded[msg.sender], toFund);
128   }
129 
130   function validPurchase() internal constant returns (bool) {
131     bool validValue = msg.value >= personalMincap;                                                       
132     bool validTime = now >= startTime && now <= endTime && !checkMaintenanceTime(); 
133     return validValue && !maxReached() && validTime;  
134   }
135 
136   function maxReached() public constant returns (bool) {
137     return weiRaised >= saleHardcap;
138   }
139 
140   function getNowTime() public constant returns(uint256) {
141       return now;
142   }
143 
144   // Owner only Functions
145   function changeStartTime( uint64 newStartTime ) public onlyOwner {
146     startTime = newStartTime;
147   }
148 
149   function changeEndTime( uint64 newEndTime ) public onlyOwner {
150     endTime = newEndTime;
151   }
152 
153   function changeSaleHardcap( uint256 newsaleHardcap ) public onlyOwner {
154     saleHardcap = newsaleHardcap * (1 ether);
155   }
156 
157   function changePersonalMincap( uint256 newpersonalMincap ) public onlyOwner {
158     personalMincap = newpersonalMincap * (1 ether);
159   }
160 
161   function FinishTokensale() public onlyOwner {
162     require(maxReached() || now > endTime);
163     isFinalized = true;
164     
165     owner.transfer(address(this).balance);
166   }
167   
168   function changeMaintenanceTime(uint256 _starttime, uint256 _endtime) public onlyOwner{
169     mtStartTime = _starttime;
170     mtEndTime = _endtime;
171   }
172   
173   function checkMaintenanceTime() public view returns (bool)
174   {
175     uint256 datetime = now % (60 * 60 * 24);
176     return (datetime >= mtStartTime && datetime < mtEndTime);
177   }
178 
179 }
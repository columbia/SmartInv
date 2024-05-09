1 pragma solidity ^0.4.13;
2 
3 contract owned {
4  address public owner;
5 
6  function owned() {
7      owner = msg.sender;
8  }
9 
10  modifier onlyOwner {
11      require(msg.sender == owner);
12      _;
13  }
14 
15  function transferOwnership(address newOwner) onlyOwner {
16      owner = newOwner;
17  }
18 }
19 
20 contract ICO_CONTRACT is owned {
21 
22    event WithdrawEther (address indexed from, uint256 amount, uint256 balance);
23    event ReceivedEther (address indexed sender, uint256 amount);  
24    
25    uint256 minimunInputEther;
26    uint256 maximumInputEther;
27    
28    uint icoStartTime;
29    uint icoEndTime;
30    
31    bool isStopFunding;
32    
33    function ICO_CONTRACT() {
34        minimunInputEther = 1 ether;
35        maximumInputEther = 500 ether;
36        
37        icoStartTime = now;
38        icoEndTime = now + 14 * 1 days;
39        
40        isStopFunding = false;
41    }
42    
43    function getBalance() constant returns (uint256){
44        return address(this).balance;
45    }
46    
47    function withdrawEther(uint256 _amount) onlyOwner returns (bool){
48        
49        if(_amount > getBalance()) {
50            return false;
51        }
52        owner.transfer(_amount);
53        WithdrawEther(msg.sender, _amount, getBalance());
54        return true;
55    }
56    
57    function withdrawEtherAll() onlyOwner returns (bool){
58        uint256 _tempBal = getBalance();
59        owner.transfer(getBalance());
60        WithdrawEther(msg.sender, _tempBal, getBalance());
61        return true;
62    }
63 
64    function setMiniumInputEther (uint256 _minimunInputEther) onlyOwner {
65        minimunInputEther = _minimunInputEther;
66    }
67    
68    function getMiniumInputEther() constant returns (uint256) {
69        return minimunInputEther;
70    }
71    
72    function setMaxiumInputEther (uint256 _maximumInputEther) onlyOwner {
73        maximumInputEther = _maximumInputEther;
74    }
75    
76    function getMaxiumInputEther() constant returns (uint256) {
77        return maximumInputEther;
78    }
79    
80    function setIcoStartTime(uint _startTime) onlyOwner {
81        icoStartTime = _startTime;
82    }
83    
84    function setIcoEndTime(uint _endTime) onlyOwner {
85        icoEndTime = _endTime;
86    }
87    
88    function setIcoTimeStartEnd(uint _startTime, uint _endTime) onlyOwner {
89        if(_startTime > _endTime) {
90            return;
91        }
92        
93        icoStartTime = _startTime;
94        icoEndTime = _endTime;
95    }
96    
97    function setStopFunding(bool _isStopFunding) onlyOwner {
98        isStopFunding = _isStopFunding;
99    }
100    
101    function getIcoTime() constant returns (uint, uint) {
102        return (icoStartTime, icoEndTime);
103    }
104 
105    function () payable {
106        
107        if(msg.value < minimunInputEther) {
108            throw;
109        }
110        
111        if(msg.value > maximumInputEther) {
112            throw;
113        }
114        
115        if(!isFundingNow()) {
116            throw;
117        }
118        
119        if(isStopFunding) {
120            throw;
121        }
122        
123        ReceivedEther(msg.sender, msg.value);
124    }
125    
126    function isFundingNow() constant returns (bool) {
127        return (now > icoStartTime && now < icoEndTime);
128    }
129    
130    function getIsStopFunding() constant returns (bool) {
131        return isStopFunding;
132    }
133 }
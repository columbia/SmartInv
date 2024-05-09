1 pragma solidity ^0.4.24;
2 
3 // written by garry from Team Chibi Fighters
4 // find us at https://chibifighters.io
5 // chibifighters@gmail.com
6 // version 1.0.0
7 
8 
9 contract Owned {
10     address public owner;
11     address public newOwner;
12 
13     event OwnershipTransferred(address indexed _from, address indexed _to);
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address _newOwner) public onlyOwner {
25         newOwner = _newOwner;
26     }
27     
28     function acceptOwnership() public {
29         require(msg.sender == newOwner);
30         emit OwnershipTransferred(owner, newOwner);
31         owner = newOwner;
32         newOwner = address(0);
33     }
34 }
35 
36 
37 interface ERC20Interface {
38     function transferFrom(address from, address to, uint tokens) external returns (bool success);
39     function transfer(address to, uint tokens) external;
40     function balanceOf(address _owner) external view returns (uint256 _balance);
41 }
42 
43 interface ERC20InterfaceClassic {
44     function transfer(address to, uint tokens) external returns (bool success);
45 }
46 
47 contract DailyRewards is Owned {
48 
49 	event RewardClaimed(
50 		address indexed buyer,
51 		uint256 day
52 	);
53 	
54 	// what day the player is on in his reward chain
55 	mapping (address => uint) private daysInRow;
56 
57 	// timeout after which row is broken
58 	mapping (address => uint) private timeout;
59 	
60 	// how often the reward can be claimed, e.g. every 24h
61 	uint waitingTime = 24 hours;
62 	// window of claiming, if it expires day streak resets to day 1
63 	uint waitingTimeBuffer = 48 hours;
64 	
65 	
66 	constructor() public {
67 	    // Explore Chibis and their universe
68 	    // Off chain battles, real Ether fights, true on chain ownership
69 	    // Leaderboards, tournaments, roleplay elements, we got it all
70 	}
71 	
72 	
73 	function requestReward() public returns (uint _days) {
74 	    require (msg.sender != address(0));
75 	    require (now > timeout[msg.sender]);
76 	    
77 	    // waited too long, reset
78 	    if (now > timeout[msg.sender] + waitingTimeBuffer) {
79 	        daysInRow[msg.sender] = 1;    
80 	    } else {
81 	        // no limit to being logged in, looking forward to the longest streak
82 	        daysInRow[msg.sender]++;
83 	    }
84 	    
85 	    timeout[msg.sender] = now + waitingTime;
86 	    
87 	    emit RewardClaimed(msg.sender, daysInRow[msg.sender]);
88 	    
89 	    return daysInRow[msg.sender];
90 	}
91 	
92 	
93 	/**
94 	 * @dev Query stats of next reward, checks for expired time, too
95 	 **/
96 	function nextReward() public view returns (uint _day, uint _nextClaimTime, uint _nextClaimExpire) {
97 	    uint _dayCheck;
98 	    if (now > timeout[msg.sender] + waitingTimeBuffer) _dayCheck = 1; else _dayCheck = daysInRow[msg.sender] + 1;
99 	    
100 	    return (_dayCheck, timeout[msg.sender], timeout[msg.sender] + waitingTimeBuffer);
101 	}
102 	
103 	
104 	function queryWaitingTime() public view returns (uint _waitingTime) {
105 	    return waitingTime;
106 	}
107 	
108 	function queryWaitingTimeBuffer() public view returns (uint _waitingTimeBuffer) {
109 	    return waitingTimeBuffer;
110 	}
111 	
112 
113 	/**
114 	 * @dev Sets the interval for daily rewards, e.g. 24h = 86400
115 	 * @param newTime New interval time in seconds
116 	 **/
117 	function setWaitingTime(uint newTime) public onlyOwner returns (uint _newWaitingTime) {
118 	    waitingTime = newTime;
119 	    return waitingTime;
120 	}
121 	
122 	
123 	/**
124 	 * @dev Sets buffer for daily rewards. So user have time to claim it. e.g. 1h = 3600
125 	 * @param newTime New buffer in seconds
126 	 **/
127 	function setWaitingTimeBuffer(uint newTime) public onlyOwner returns (uint _newWaitingTimeBuffer) {
128 	    waitingTimeBuffer = newTime;
129 	    return waitingTimeBuffer;
130 	}
131 
132 
133     /**
134     * @dev Send Ether to owner
135     * @param _address Receiving address
136     * @param _amountWei Amount in WEI to send
137     **/
138     function weiToOwner(address _address, uint _amountWei) public onlyOwner returns (bool) {
139         require(_amountWei <= address(this).balance);
140         _address.transfer(_amountWei);
141         return true;
142     }
143 
144     function ERC20ToOwner(address _to, uint256 _amount, ERC20Interface _tokenContract) public onlyOwner {
145         _tokenContract.transfer(_to, _amount);
146     }
147 
148     function ERC20ClassicToOwner(address _to, uint256 _amount, ERC20InterfaceClassic _tokenContract) public onlyOwner {
149         _tokenContract.transfer(_to, _amount);
150     }
151 
152 }
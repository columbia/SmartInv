1 pragma solidity ^0.4.23;
2 
3 contract Clockmaking {
4 	address public clockmaker;
5 	address public newClockmaker;
6 
7 	event ClockmakingTransferred(address indexed oldClockmaker, address indexed newClockmaker);
8 
9 	constructor() public {
10 		clockmaker = msg.sender;
11 		newClockmaker = address(0);
12 	}
13 
14 	modifier onlyClockmaker() {
15 		require(msg.sender == clockmaker, "msg.sender == clockmaker");
16 		_;
17 	}
18 
19 	function transferClockmaker(address _newClockmaker) public onlyClockmaker {
20 		require(address(0) != _newClockmaker, "address(0) != _newClockmaker");
21 		newClockmaker = _newClockmaker;
22 	}
23 
24 	function acceptClockmaker() public {
25 		require(msg.sender == newClockmaker, "msg.sender == newClockmaker");
26 		emit ClockmakingTransferred(clockmaker, msg.sender);
27 		clockmaker = msg.sender;
28 		newClockmaker = address(0);
29 	}
30 }
31 
32 contract Ownable {
33 	address public owner;
34 	address public newOwner;
35 
36 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
37 
38 	constructor() public {
39 		owner = msg.sender;
40 		newOwner = address(0);
41 	}
42 
43 	modifier onlyOwner() {
44 		require(msg.sender == owner, "msg.sender == owner");
45 		_;
46 	}
47 
48 	function transferOwnership(address _newOwner) public onlyOwner {
49 		require(address(0) != _newOwner, "address(0) != _newOwner");
50 		newOwner = _newOwner;
51 	}
52 
53 	function acceptOwnership() public {
54 		require(msg.sender == newOwner, "msg.sender == newOwner");
55 		emit OwnershipTransferred(owner, msg.sender);
56 		owner = msg.sender;
57 		newOwner = address(0);
58 	}
59 }
60 
61 contract ERC20Basic {
62   function balanceOf(address who) public constant returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64 }
65 
66 library SafeERC20 {
67   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
68     assert(token.transfer(to, value));
69   }
70 }
71 
72 /**
73  * @title TokenTimelock
74  * @dev TokenTimelock is a token holder contract that will allow a
75  * beneficiary to extract the tokens after a given release time
76  */
77 contract TokenTimelock is Ownable, Clockmaking {
78   using SafeERC20 for ERC20Basic;
79   ERC20Basic public token;   // ERC20 basic token contract being held
80   uint64 public releaseTime; // timestamp when token claim is enabled
81 
82   constructor(ERC20Basic _token, uint64 _releaseTime) public {
83     require(_releaseTime > now);
84     token = _token;
85     owner = msg.sender;
86     clockmaker = msg.sender;
87     releaseTime = _releaseTime;
88   }
89 
90   /**
91    * @notice Transfers tokens held by timelock to owner.
92    */
93   function claim() public onlyOwner {
94     require(now >= releaseTime, "now >= releaseTime");
95 
96     uint256 amount = token.balanceOf(this);
97     require(amount > 0, "amount > 0");
98 
99     token.safeTransfer(owner, amount);
100   }
101   
102   function updateTime(uint64 _releaseTime) public onlyClockmaker {
103       releaseTime = _releaseTime;
104   }
105   
106 }
1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   // events
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   // public functions
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address addr) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 contract Ownable {
14 
15   // public variables
16   address public owner;
17 
18   // internal variables
19 
20   // events
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23   // public functions
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     emit OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39   // internal functions
40 }
41 
42 /**
43  * @title TokenTimelock
44  * @dev TokenTimelock is a token holder contract that will allow a
45  * beneficiary to extract the tokens after a given release time
46  */
47 contract TokenTimelock is Ownable {
48   // ERC20 basic token contract being held
49   ERC20Basic public token;
50 
51   uint8 public decimals = 8;
52 
53   address public beneficiary;
54   
55   uint256 public releaseTime1 = 1543593600; // 2018.12.1
56   uint256 public releaseTime2 = 1559318400; // 2019.6.1
57   uint256 public releaseTime3 = 1575129600; // 2019.12.1
58   uint256 public releaseTime4 = 1590940800; // 2020.6.1
59   
60   uint256 public releaseValue1 = 1500000000 * (10 ** uint256(decimals)); 
61   uint256 public releaseValue2 = 1500000000 * (10 ** uint256(decimals)); 
62   uint256 public releaseValue3 = 1500000000 * (10 ** uint256(decimals)); 
63   uint256 public releaseValue4 = 1500000000 * (10 ** uint256(decimals)); 
64 
65   bool public releaseState1 = false;
66   bool public releaseState2 = false;
67   bool public releaseState3 = false;
68   bool public releaseState4 = false;
69 
70   constructor(
71     ERC20Basic _token,
72     address _beneficiary
73 
74   )
75     public
76   {
77     require(block.timestamp < releaseTime1);
78     require(block.timestamp < releaseTime2);
79     require(block.timestamp < releaseTime3);
80     require(block.timestamp < releaseTime4);
81     
82     require(_beneficiary != address(0));
83     require(_token != address(0));
84 
85     token = _token;
86     beneficiary = _beneficiary;
87 
88 
89   }
90     // fallback function
91     function() public payable {
92         revert();
93     }
94   function checkCanRelease(bool rState, uint256 rTime, uint256 rAmount) private 
95   {
96     require(block.timestamp >= rTime);
97     require(false == rState);
98     uint256 amount = token.balanceOf(this);
99     require(amount > 0);
100     require(amount >= rAmount);
101   }
102   function releaseImpl(uint256 rAmount) private 
103   {
104     require( token.transfer(beneficiary, rAmount) );
105   }
106 
107   function release_1() onlyOwner public 
108   {
109     checkCanRelease(releaseState1, releaseTime1, releaseValue1);
110     
111     releaseState1 = true;
112     releaseImpl(releaseValue1);
113   }
114 
115   function release_2() onlyOwner public 
116   {
117     checkCanRelease(releaseState2, releaseTime2, releaseValue2);
118 
119     releaseState2 = true;
120     releaseImpl(releaseValue2);
121   }
122 
123   function release_3() onlyOwner public 
124   {
125     checkCanRelease(releaseState3, releaseTime3, releaseValue3);
126     releaseState3 = true;
127     releaseImpl(releaseValue3);   
128   }
129 
130   function release_4() onlyOwner public 
131   {
132     checkCanRelease(releaseState4, releaseTime4, releaseValue4);
133     releaseState4 = true;
134     releaseImpl(releaseValue4);
135   }
136   
137   function release_remain() onlyOwner public 
138   {
139     require(true == releaseState1);
140     require(true == releaseState2);
141     require(true == releaseState3);
142     require(true == releaseState4);
143 
144     uint256 amount = token.balanceOf(this);
145     require(amount > 0);
146 
147     releaseImpl(amount);
148   }
149 }
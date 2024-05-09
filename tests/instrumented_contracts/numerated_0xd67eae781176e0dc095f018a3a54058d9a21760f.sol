1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 contract ICSTCrowSale is Ownable{
83 	using SafeMath for uint256;
84 
85 	
86 	uint256 public totalFundingSupply;
87 	ERC20 public token;
88 	uint256 public startTime;
89 	uint256 public endTime;
90 	uint256 public airdropSupply;
91 	uint256 public rate;
92 	event Wasted(address to, uint256 value, uint256 date);
93 	function ICSTCrowSale(){
94 		rate = 0;
95 		startTime=0;
96 		endTime=0;
97 		airdropSupply = 0;
98 		totalFundingSupply = 0;
99 		token=ERC20(0xe6bc60a00b81c7f3cbc8f4ef3b0a6805b6851753);
100 	}
101 
102 	function () payable external
103 	{
104 			require(now>startTime);
105 			require(now<=endTime);
106 			uint256 amount=0;
107 			processFunding(msg.sender,msg.value,rate);
108 			amount=msg.value.mul(rate);
109 			totalFundingSupply = totalFundingSupply.add(amount);
110 	}
111 
112     function withdrawCoinToOwner(uint256 _value) external
113 		onlyOwner
114 	{
115 		processFunding(msg.sender,_value,1);
116 	}
117 	//空投
118     function airdrop(address [] _holders,uint256 paySize) external
119     	onlyOwner 
120 	{
121         uint256 count = _holders.length;
122         assert(paySize.mul(count) <= token.balanceOf(this));
123         for (uint256 i = 0; i < count; i++) {
124 			processFunding(_holders [i],paySize,1);
125 			airdropSupply = airdropSupply.add(paySize); 
126         }
127         Wasted(owner, airdropSupply, now);
128     }
129 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
130 	{
131 		uint256 amount=_value.mul(_rate);
132 		require(amount<=token.balanceOf(this));
133 		if(!token.transfer(receiver,amount)){
134 			revert();
135 		}
136 	}
137 
138 	
139 	function etherProceeds() external
140 		onlyOwner
141 
142 	{
143 		if(!msg.sender.send(this.balance)) revert();
144 	}
145 
146 
147 
148 	function init(uint256 _startTime,uint256 _endTime,uint _rate) external
149 		onlyOwner
150 	{
151 		startTime=_startTime;
152 		endTime=_endTime;
153 		rate=_rate;
154 	}
155 
156 	function changeToken(address _tokenAddress) external
157 		onlyOwner
158 	{
159 		token = ERC20(_tokenAddress);
160 	}	
161 	  
162 }
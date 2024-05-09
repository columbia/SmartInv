1 pragma solidity ^0.6.0;
2 
3 interface Minereum {
4   function BurnTokens ( uint256 mneToBurn ) external returns ( bool success );
5   function CreateTokenICO (  ) payable external;
6   function availableBalanceOf ( address _address ) external view returns ( uint256 Balance );
7   function balanceOf ( address _address ) external view returns ( uint256 balance );
8   function transfer ( address _to, uint256 _value ) external;
9   function transferFrom ( address _from, address _to, uint256 _amount ) external returns ( bool success );  
10 }
11 
12 
13 contract MinereumLuckyDraw
14 {
15 	Minereum public mne;
16 	uint public stakeHoldersfee = 30;
17 	uint public mnefee = 0;
18 	uint public ethfee = 10000000000000000;
19 	uint public totalSentToStakeHolders = 0;
20 	uint public totalPaidOut = 0;
21 	uint public ticketsSold = 0;
22 	address public owner = 0x0000000000000000000000000000000000000000;
23 	
24 	constructor(address mneAddress) public
25 	{
26 		mne = Minereum(mneAddress);
27 		owner = payable(msg.sender);		
28 	}
29     event Numbers(address indexed from, uint[] n, string m);
30     
31 	uint public maxNumber = 10001;
32 	uint public systemNumber = 3223;
33 	
34 	receive() external payable { }
35     
36     function BuyTickets (uint max) public payable
37     {
38 		uint[] memory numbers = new uint[](max);
39         uint i = 0;
40         bool win = false;
41 		
42 		//some sort of security to prevent miners from hacking block.timestamp. Contract Valid for 6 months.
43 		if (!(block.timestamp >= 1587477930 && block.timestamp <= 1603256393))
44 			revert('wrong timestamp');		
45 		
46 		while (i < max)
47         {	
48             //Random number generation
49 			numbers[i] = uint256(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i)))%maxNumber);
50             if (numbers[i] == systemNumber)
51                 win = true;
52             i++;
53         }
54         
55         if (win)
56 		{
57 			address payable add = payable(msg.sender);
58 			uint contractBalance = address(this).balance;
59 			emit Numbers(msg.sender, numbers, "You WON!");
60 			if (!add.send(contractBalance)) revert('Error While Executing Payment.');
61 			totalPaidOut += contractBalance;
62 		}
63         else
64 		{
65             emit Numbers(msg.sender, numbers, "Your numbers don't match the System Number! Try Again.");
66 		}
67 		ticketsSold += max;
68 		
69 		uint totalEthfee = ethfee * max;
70 		uint totalMneFee = mnefee * max;
71 		if (msg.value < totalEthfee) revert('Not enough ETH.');
72 		uint valueStakeHolder = msg.value * stakeHoldersfee / 100;
73 		mne.CreateTokenICO.value(valueStakeHolder)();
74 		totalSentToStakeHolders += valueStakeHolder;
75 		
76 		if (totalMneFee > 0)
77 		{
78 			if (!mne.transferFrom(msg.sender, address(this), totalMneFee)) revert('Not enough MNE.');
79 			mne.BurnTokens(totalMneFee);
80 		}
81     }
82 	
83 	function transferFundsOut() public
84 	{
85 		if (msg.sender == owner)
86 		{
87 			address payable add = payable(msg.sender);
88 			uint contractBalance = address(this).balance;
89 			if (!add.send(contractBalance)) revert('Error While Executing Payment.');			
90 		}
91 		else
92 		{
93 			revert();
94 		}
95 	}
96 	
97 	function updateFees(uint _stakeHoldersfee, uint _mnefee, uint _ethfee) public
98 	{
99 		if (msg.sender == owner)
100 		{
101 			stakeHoldersfee = _stakeHoldersfee;
102 			mnefee = _mnefee;
103 			ethfee = _ethfee;
104 		}
105 		else
106 		{
107 			revert();
108 		}
109 	}
110 	
111 	function updateSystemNumber(uint _systemNumber) public
112 	{
113 		if (msg.sender == owner)
114 		{
115 			systemNumber = _systemNumber;
116 		}
117 		else
118 		{
119 			revert();
120 		}
121 	}
122 	
123 	function updateMaxNumber(uint _maxNumber) public
124 	{
125 		if (msg.sender == owner)
126 		{
127 			maxNumber = _maxNumber;
128 		}
129 		else
130 		{
131 			revert();
132 		}
133 	}
134 }
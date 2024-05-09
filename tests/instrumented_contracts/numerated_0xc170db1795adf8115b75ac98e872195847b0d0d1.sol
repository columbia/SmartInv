1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 2, 2019
3  (UTC) */
4 
5 pragma solidity >=0.4.25 <0.6.0;
6 
7 contract ERC20 
8 {
9 	function totalSupply() public view returns (uint256);
10 	function balanceOf(address who) public view returns (uint256);
11 	function transfer(address to, uint256 value) public returns (bool);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 	function allowance(address owner, address spender) public view returns (uint256);
14 	function transferFrom(address from, address to, uint256 value) public returns (bool);
15 	function approve(address spender, uint256 value) public returns (bool);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 contract BatchSend 
20 {
21 	uint constant MAX_BATCH_LEN = 150;
22 	
23 	function batchSendToken(address _token, address[] memory recipients, uint[] memory amounts) public 
24 	{
25 		require(recipients.length <= MAX_BATCH_LEN); 
26 		if(recipients.length != amounts.length)
27             revert();
28 		ERC20 token = ERC20(_token);
29 		for(uint i = 0; i < recipients.length; i++) 
30 		{
31 			require(token.transferFrom(msg.sender, recipients[i], amounts[i]));
32 		}
33 	}
34 	
35 	function batchSendToken2(address _token, address[] memory recipients, uint amount) public 
36 	{
37 		require(recipients.length <= MAX_BATCH_LEN); 
38 
39 		ERC20 token = ERC20(_token);
40 		for(uint i = 0; i < recipients.length; i++) 
41 		{
42 			require(token.transferFrom(msg.sender, recipients[i], amount));
43 		}
44 	}
45 	
46 	function batchSendETH(address[] memory recipients, uint[] memory amounts) public payable 
47 	{
48 		require(recipients.length <= MAX_BATCH_LEN); 
49 		if(recipients.length != amounts.length)
50             revert();
51 		
52 		for(uint i = 0; i < recipients.length; i++) 
53 		{
54 			address(uint160(recipients[i])).transfer(amounts[i]);
55 		}
56 		msg.sender.transfer(address(this).balance);
57 	}
58 	
59 	function batchSendETH2(address[] memory recipients) public payable 
60 	{
61 		require(recipients.length <= MAX_BATCH_LEN); 
62 
63 		for(uint i = 0; i < recipients.length; i++) 
64 		{
65 			address(uint160(recipients[i])).transfer(msg.value / recipients.length);
66 		}
67 		msg.sender.transfer(address(this).balance);
68 	}
69 }
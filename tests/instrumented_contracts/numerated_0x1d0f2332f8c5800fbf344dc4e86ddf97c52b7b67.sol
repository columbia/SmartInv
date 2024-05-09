1 pragma solidity ^0.4.18;
2 
3 // Each deployed Splitter contract has a constant array of recipients.
4 // When the Splitter receives Ether, it will immediately divide this Ether up
5 // and send it to the recipients.
6 contract Splitter
7 {
8 	address[] public recipients;
9 	
10 	function Splitter(address[] _recipients) public
11 	{
12 	    require(_recipients.length >= 1);
13 		recipients = _recipients;
14 	}
15 	
16 	function() payable public
17 	{
18 		uint256 amountOfRecipients = recipients.length;
19 		uint256 etherPerRecipient = msg.value / amountOfRecipients;
20 		
21 		if (etherPerRecipient == 0) return;
22 		
23 		for (uint256 i=0; i<amountOfRecipients; i++)
24 		{
25 			recipients[i].transfer(etherPerRecipient);
26 		}
27 	}
28 }
29 
30 contract SplitterService
31 {
32     address private owner;
33     uint256 public feeForSplitterCreation;
34     
35     mapping(address => address[]) public addressToSplittersCreated;
36     mapping(address => bool) public addressIsSplitter;
37     mapping(address => string) public splitterNames;
38     
39     function SplitterService() public
40     {
41         owner = msg.sender;
42         feeForSplitterCreation = 0.001 ether;
43     }
44     
45     function createSplitter(address[] recipients, string name) external payable
46     {
47         require(msg.value >= feeForSplitterCreation);
48         address newSplitterAddress = new Splitter(recipients);
49         addressToSplittersCreated[msg.sender].push(newSplitterAddress);
50         addressIsSplitter[newSplitterAddress] = true;
51         splitterNames[newSplitterAddress] = name;
52     }
53     
54     ////////////////////////////////////////
55     // Owner functions
56     
57     function setFee(uint256 newFee) external
58     {
59         require(msg.sender == owner);
60         require(newFee <= 0.01 ether);
61         feeForSplitterCreation = newFee;
62     }
63     
64     function ownerWithdrawFees() external
65     {
66         owner.transfer(this.balance);
67     }
68     
69     function transferOwnership(address newOwner) external
70     {
71         require(msg.sender == owner);
72         owner = newOwner;
73     }
74 }
1 pragma solidity ^0.4.19;
2 
3 
4 interface CornFarm
5 {
6     function buyObject(address _beneficiary) public payable;
7 }
8 
9 interface Corn
10 {
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13 }
14 
15 
16 /**
17  * Contract that will forward any incoming Ether to the creator of the contract
18  */
19 contract howbadlycouldthisgowrong {
20   // Address to which any funds sent to this contract will be forwarded
21   address public parentAddress;
22   event ForwarderDeposited(address from, uint value, bytes data);
23 
24   /**
25    * Create the contract, and sets the destination address to that of the creator
26    */
27   function Forwarder() public {
28     parentAddress = msg.sender;
29   }
30 
31   /**
32    * Modifier that will execute internal code block only if the sender is the parent address
33    */
34   modifier onlyParent {
35     if (msg.sender != parentAddress) {
36       revert();
37     }
38     _;
39   }
40 
41   /**
42    * Default function; Gets called when Ether is deposited, and forwards it to the parent address
43    */
44   function() public payable {
45     // throws on failure
46     parentAddress.transfer(msg.value);
47     // Fire off the deposited event if we can forward it
48     ForwarderDeposited(msg.sender, msg.value, msg.data);
49   }
50 
51 
52 
53 
54 
55 address public farmer = 0xC4C6328405F00Fa4a93715D2349f76DF0c7E8b79;
56     
57     function sowCorn(address soil, uint8 seeds) external
58     {
59         for(uint8 i = 0; i < seeds; ++i)
60         {
61             CornFarm(soil).buyObject(this);
62         }
63     }
64     
65     function reap(address corn) external
66     {
67         Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
68     }
69 
70 
71 
72 
73 
74 }
1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title Claimable
46  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
47  * This allows the new owner to accept the transfer.
48  */
49 contract Claimable is Ownable {
50   address public pendingOwner;
51 
52   /**
53    * @dev Modifier throws if called by any account other than the pendingOwner.
54    */
55   modifier onlyPendingOwner() {
56     require(msg.sender == pendingOwner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to set the pendingOwner address.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     pendingOwner = newOwner;
66   }
67 
68   /**
69    * @dev Allows the pendingOwner address to finalize the transfer.
70    */
71   function claimOwnership() onlyPendingOwner public {
72     OwnershipTransferred(owner, pendingOwner);
73     owner = pendingOwner;
74     pendingOwner = address(0);
75   }
76 }
77 
78 /**
79  * @title LibreBank report contract.
80  * @dev Project website: https://librebank.com
81  * @dev Mail: support[@]librebank.com
82  */
83 contract ReportStorage is Claimable {
84     Report[] public reports;
85 
86     struct Report {
87         string textReport;
88         uint date;
89     }
90 
91     function counter() public view returns(uint256) {
92       return reports.length;
93     }
94          
95     function addNewReport(string newReport) public onlyOwner {
96         reports.push(Report(newReport, now));
97     }
98 }
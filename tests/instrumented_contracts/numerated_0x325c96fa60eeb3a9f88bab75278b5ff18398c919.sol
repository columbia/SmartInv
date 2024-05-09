1 pragma solidity ^0.4.0;
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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 }
50 
51 contract InvestorWhiteList is Ownable {
52   mapping (address => bool) public investorWhiteList;
53 
54   mapping (address => address) public referralList;
55 
56   function InvestorWhiteList() {
57 
58   }
59 
60   function addInvestorToWhiteList(address investor) external onlyOwner {
61     require(investor != 0x0 && !investorWhiteList[investor]);
62     investorWhiteList[investor] = true;
63   }
64 
65   function removeInvestorFromWhiteList(address investor) external onlyOwner {
66     require(investor != 0x0 && investorWhiteList[investor]);
67     investorWhiteList[investor] = false;
68   }
69 
70   //when new user will contribute ICO contract will automatically send bonus to referral
71   function addReferralOf(address investor, address referral) external onlyOwner {
72     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
73     referralList[investor] = referral;
74   }
75 
76   function isAllowed(address investor) constant external returns (bool result) {
77     return investorWhiteList[investor];
78   }
79 
80   function getReferralOf(address investor) constant external returns (address result) {
81     return referralList[investor];
82   }
83 }
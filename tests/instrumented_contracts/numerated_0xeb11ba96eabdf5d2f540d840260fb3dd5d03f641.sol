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
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 contract InvestorWhiteList is Ownable {
43   mapping (address => bool) public investorWhiteList;
44 
45   mapping (address => address) public referralList;
46 
47   function InvestorWhiteList() {
48 
49   }
50 
51   function addInvestorToWhiteList(address investor) external onlyOwner {
52     require(investor != 0x0 && !investorWhiteList[investor]);
53     investorWhiteList[investor] = true;
54   }
55 
56   function removeInvestorFromWhiteList(address investor) external onlyOwner {
57     require(investor != 0x0 && investorWhiteList[investor]);
58     investorWhiteList[investor] = false;
59   }
60 
61   //when new user will contribute ICO contract will automatically send bonus to referral
62   function addReferralOf(address investor, address referral) external onlyOwner {
63     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
64     referralList[investor] = referral;
65   }
66 
67   function isAllowed(address investor) constant external returns (bool result) {
68     return investorWhiteList[investor];
69   }
70 
71   function getReferralOf(address investor) constant external returns (address result) {
72     return referralList[investor];
73   }
74 }
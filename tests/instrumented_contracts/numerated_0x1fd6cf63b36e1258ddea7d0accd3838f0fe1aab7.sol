1 pragma solidity ^0.4.20;
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
43 contract InvestorWhiteList is Ownable {
44   mapping (address => bool) public investorWhiteList;
45 
46   mapping (address => address) public referralList;
47 
48   function InvestorWhiteList() {
49 
50   }
51 
52   function addInvestorToWhiteList(address investor) external onlyOwner {
53     require(investor != 0x0 && !investorWhiteList[investor]);
54     investorWhiteList[investor] = true;
55   }
56 
57   function removeInvestorFromWhiteList(address investor) external onlyOwner {
58     require(investor != 0x0 && investorWhiteList[investor]);
59     investorWhiteList[investor] = false;
60   }
61 
62   //when new user will contribute ICO contract will automatically send bonus to referral
63   function addReferralOf(address investor, address referral) external onlyOwner {
64     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
65     referralList[investor] = referral;
66   }
67 
68   function isAllowed(address investor) constant external returns (bool result) {
69     return investorWhiteList[investor];
70   }
71 
72   function getReferralOf(address investor) constant external returns (address result) {
73     return referralList[investor];
74   }
75 }
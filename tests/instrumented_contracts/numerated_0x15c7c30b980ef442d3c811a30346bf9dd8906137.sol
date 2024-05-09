1 // v7
2 
3 /**
4  * InvestorStorage.sol
5  * Investor storage is used for storing all investments amounts of investors. It creates a list of investors and their investments in a big hash map.
6  * So when the new investments is made by investor, InvestorStorage adds it to the list as new investment, while storing investors address and invested amount.
7  * It also gives the ability to get particular investor from the list and to refund him if its needed.
8  */
9 
10 pragma solidity ^0.4.23;
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 }
48 
49 /**
50  * @title InvestorStorage
51  * @dev Investor storage is used for storing all investments amounts of investors. It creates a list of investors and their investments in a big hash map.
52  * So when the new investments is made by investor, InvestorStorage adds it to the list as new investment, while storing investors address and invested amount.
53  * It also gives the ability to get particular investor from the list and to refund him if its needed.
54  */
55 contract InvestorsStorage is Ownable {
56 
57   mapping (address => uint256) public investors; // map the invested amount
58   address[] public investorsList;
59   address authorized;
60 
61   /**
62    * @dev Allows only presale or crowdsale
63    */
64   modifier isAuthorized() { // modifier that allows only presale or crowdsale
65     require(msg.sender==authorized);
66     _;
67   }
68 
69   /**
70    * @dev Set authorized to given address - changes the authorization for presale or crowdsale
71    * @param _authorized Authorized address
72    */
73   function setAuthorized(address _authorized) onlyOwner public { // change the authorization for presale or crowdsale
74     authorized = _authorized;
75   }
76 
77   /**
78    * @dev Add new investment to investors storage
79    * @param _investor Investors address
80    * @param _amount Investment amount
81    */
82   function newInvestment(address _investor, uint256 _amount) isAuthorized public { // add the invested amount to the map
83     if (investors[_investor] == 0) {
84       investorsList.push(_investor);
85     }
86     investors[_investor] += _amount;
87   }
88 
89   /**
90    * @dev Get invested amount for given investor address
91    * @param _investor Investors address
92    */
93   function getInvestedAmount(address _investor) public view returns (uint256) { // return the invested amount
94     return investors[_investor];
95   }
96 
97   /**
98    * @dev Refund investment to the investor
99    * @param _investor Investors address
100    */
101   function investmentRefunded(address _investor) isAuthorized public { // set the invested amount to 0 after the refund
102     investors[_investor] = 0;
103   }
104 }
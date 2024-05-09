1 pragma solidity ^0.4.21;
2 
3 
4 contract RealEstateCryptoFund {
5   function transfer(address to, uint256 value) public returns (bool);
6   function balanceOf(address who) public constant returns (uint256);
7 }
8 
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) onlyOwner public {
41     require(newOwner != address(0));
42     emit OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 
48 contract Bounty is Ownable {
49   uint256 public BountyAmount;
50 
51   RealEstateCryptoFund public token;
52 
53   mapping(address=>bool) public participated;
54 
55   event TokenBounty(address indexed beneficiary, uint256 amount);
56 
57   event BountyAmountUpdate(uint256 BountyAmount);
58   
59   function Bounty(address _tokenAddress) public {
60     token = RealEstateCryptoFund (_tokenAddress);
61   }
62 
63   function () external payable {
64     getTokens(msg.sender);
65   }
66 
67   function setBountyAmount(uint256 _BountyAmount) public onlyOwner {
68     require(_BountyAmount > 0);
69     BountyAmount = _BountyAmount;
70     emit BountyAmountUpdate(BountyAmount);
71   }
72 
73   function getTokens(address beneficiary) public payable {
74     require(beneficiary != address(0));
75     require(validPurchase(beneficiary));
76     
77     token.transfer(beneficiary, BountyAmount);
78 
79     emit TokenBounty(beneficiary, BountyAmount);
80 
81     participated[beneficiary] = true;
82   }
83 
84   
85   function validPurchase(address beneficiary) internal view returns (bool) {
86     bool hasParticipated = participated[beneficiary];
87     return !hasParticipated;
88   }
89 }
90 
91 
92 contract RealEstateCryptoFundBounty is Bounty {
93   function RealEstateCryptoFundBounty (address _tokenAddress) public
94     Bounty(_tokenAddress)
95   {
96 
97   }
98 
99   function drainRemainingTokens () public onlyOwner {
100     token.transfer(owner, token.balanceOf(this));
101   }
102 }
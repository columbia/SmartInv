1 pragma solidity ^0.4.18;
2 
3 
4 contract SMEBankingPlatformToken {
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
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 
47 
48 contract Airdrop is Ownable {
49   uint256 airdropAmount = 10000 * 10 ** 18;
50 
51   SMEBankingPlatformToken public token;
52 
53   mapping(address=>bool) public participated;
54 
55   mapping(address=>bool) public whitelisted;
56 
57   event TokenAirdrop(address indexed beneficiary, uint256 amount);
58 
59   event AddressWhitelist(address indexed beneficiary);
60 
61   function Airdrop(address _tokenAddress) public {
62     token = SMEBankingPlatformToken(_tokenAddress);
63   }
64 
65   function () public payable {
66     getTokens(msg.sender);
67   }
68 
69   function setAirdropAmount(uint256 _airdropAmount) public onlyOwner {
70     require(_airdropAmount > 0);
71 
72     airdropAmount = _airdropAmount;
73   }
74 
75   function getTokens(address beneficiary) public payable {
76     require(beneficiary != 0x0);
77     require(validPurchase(beneficiary));
78 
79     token.transfer(beneficiary, airdropAmount);
80 
81     TokenAirdrop(beneficiary, airdropAmount);
82 
83     participated[beneficiary] = true;
84   }
85 
86   function whitelistAddresses(address[] beneficiaries) public onlyOwner {
87     for (uint i = 0 ; i < beneficiaries.length ; i++) {
88       address beneficiary = beneficiaries[i];
89       require(beneficiary != 0x0);
90       whitelisted[beneficiary] = true;
91       AddressWhitelist(beneficiary);
92     }
93   }
94 
95   function validPurchase(address beneficiary) internal view returns (bool) {
96     bool isWhitelisted = whitelisted[beneficiary];
97     bool hasParticipated = participated[beneficiary];
98 
99     return isWhitelisted && !hasParticipated;
100   }
101 }
102 
103 
104 contract SMEBankingPlatformAirdrop is Airdrop {
105   function SMEBankingPlatformAirdrop(address _tokenAddress) public
106     Airdrop(_tokenAddress)
107   {
108 
109   }
110 
111   function drainRemainingTokens () public onlyOwner {
112     token.transfer(owner, token.balanceOf(this));
113   }
114 }
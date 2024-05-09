1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {}
4 contract ERC20 is ERC20Basic {}
5 contract Ownable {}
6 contract BasicToken is ERC20Basic {}
7 contract StandardToken is ERC20, BasicToken {}
8 contract Pausable is Ownable {}
9 contract PausableToken is StandardToken, Pausable {}
10 contract MintableToken is StandardToken, Ownable {}
11 
12 contract OpiriaToken is MintableToken, PausableToken {
13   mapping(address => uint256) balances;
14   function transfer(address _to, uint256 _value) public returns (bool);
15   function balanceOf(address who) public view returns (uint256);
16 }
17 
18 contract VestingContractCT {
19   //storage
20   address public owner;
21   OpiriaToken public company_token;
22 
23   address public PartnerAccount;
24   uint public originalBalance;
25   uint public currentBalance;
26   uint public alreadyTransfered;
27   uint public startDateOfPayments;
28   uint public endDateOfPayments;
29   uint public periodOfOnePayments;
30   uint public limitPerPeriod;
31   uint public daysOfPayments;
32 
33   //modifiers
34   modifier onlyOwner
35   {
36     require(owner == msg.sender);
37     _;
38   }
39   
40   
41   //Events
42   event Transfer(address indexed to, uint indexed value);
43   event OwnerChanged(address indexed owner);
44 
45 
46   //constructor
47   constructor (OpiriaToken _company_token) public {
48     owner = msg.sender;
49     PartnerAccount = 0x89a380E3d71a71C51441EBd7bf512543a4F6caE7;
50     company_token = _company_token;
51     originalBalance = 2500000 * 10**18; // 2 500 000 PDATA
52     currentBalance = originalBalance;
53     alreadyTransfered = 0;
54     startDateOfPayments = 1554069600; //From 01 Apr 2019, 00:00:00
55     endDateOfPayments = 1569880800; //From 01 Oct 2019, 00:00:00
56     periodOfOnePayments = 24 * 60 * 60; // 1 day in seconds
57     daysOfPayments = (endDateOfPayments - startDateOfPayments) / periodOfOnePayments; // 183 days
58     limitPerPeriod = originalBalance / daysOfPayments;
59   }
60 
61 
62   /// @dev Fallback function: don't accept ETH
63   function()
64     public
65     payable
66   {
67     revert();
68   }
69 
70 
71   /// @dev Get current balance of the contract
72   function getBalance()
73     constant
74     public
75     returns(uint)
76   {
77     return company_token.balanceOf(this);
78   }
79 
80 
81   function setOwner(address _owner) 
82     public 
83     onlyOwner 
84   {
85     require(_owner != 0);
86     
87     owner = _owner;
88     emit OwnerChanged(owner);
89   }
90   
91   function sendCurrentPayment() public {
92     uint currentPeriod = (now - startDateOfPayments) / periodOfOnePayments;
93     uint currentLimit = currentPeriod * limitPerPeriod;
94     uint unsealedAmount = currentLimit - alreadyTransfered;
95     if (unsealedAmount > 0) {
96       if (currentBalance >= unsealedAmount) {
97         company_token.transfer(PartnerAccount, unsealedAmount);
98         alreadyTransfered += unsealedAmount;
99         currentBalance -= unsealedAmount;
100         emit Transfer(PartnerAccount, unsealedAmount);
101       } else {
102         company_token.transfer(PartnerAccount, currentBalance);
103         alreadyTransfered += currentBalance;
104         currentBalance -= currentBalance;
105         emit Transfer(PartnerAccount, currentBalance);
106       }
107     }
108   }
109 }
1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   address public owner;
11   event OwnershipTransferred (address indexed _from, address indexed _to);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public{
18     owner = msg.sender;
19     OwnershipTransferred(address(0), owner);
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     owner = newOwner;
37     OwnershipTransferred(owner,newOwner);
38   }
39 }
40 
41 /**
42  * @title Token
43  * @dev API interface for interacting with the Token contract 
44  */
45 interface Token {
46   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
47   function balanceOf(address _owner) constant external returns (uint256 balance);
48   function transfer(address to, uint256 value) external returns (bool);
49   function approve(address spender, uint256 value) external returns (bool); 
50 }
51 
52 /**
53  * @title RedeemAFTKTokenCampaign Ver 1.0 - Sept 17, 2018
54  * @dev This contract can be used for AFTK token redumption. 
55  *       Admin will setBalance for users who can redeem tokens.
56  */
57 contract RedeemAFTKTokenCampaign is Ownable {
58 
59   Token token;
60   mapping(address => uint256) public redeemBalanceOf;
61   event BalanceSet(address indexed beneficiary, uint256 value);
62   event Redeemed(address indexed beneficiary, uint256 value);
63   event BalanceCleared(address indexed beneficiary, uint256 value);
64 
65   function RedeemAFTKTokenCampaign() public {
66       address _tokenAddr = 0x7Fa2F70bD4C4120fDD539EBd55c04118ba336b9E;
67       token = Token(_tokenAddr);
68   }
69 
70 function setBalances(address[] dests, uint256[] values) onlyOwner public {
71     uint256 i = 0; 
72     while (i < dests.length){
73         if(dests[i] != address(0)) 
74         {
75             uint256 toSend = values[i] * 10**18;
76             redeemBalanceOf[dests[i]] += toSend;
77             BalanceSet(dests[i],values[i]);
78         }
79         i++;
80     }
81   }
82 
83   function redeem(uint256 quantity) public {
84       uint256 baseUnits = quantity * 10**18;
85       uint256 senderEligibility = redeemBalanceOf[msg.sender];
86       uint256 tokensAvailable = token.balanceOf(this);
87       require(senderEligibility >= baseUnits);
88       require( tokensAvailable >= baseUnits);
89       if(token.transfer(msg.sender,baseUnits)){
90         redeemBalanceOf[msg.sender] -= baseUnits;
91         Redeemed(msg.sender,quantity);
92       }
93   }
94 
95   function removeBalances(address[] dests, uint256[] values) onlyOwner public {
96     uint256 i = 0; 
97     while (i < dests.length){
98         if(dests[i] != address(0)) 
99         {
100             uint256 toRevoke = values[i] * 10**18;
101             if(redeemBalanceOf[dests[i]]>=toRevoke)
102             {
103                 redeemBalanceOf[dests[i]] -= toRevoke;
104                 BalanceCleared(dests[i],values[i]);
105             }
106         }
107         i++;
108     }
109 
110   }
111   
112   function getAvailableTokenCount() public view returns (uint256 balance)  {return token.balanceOf(this);} 
113   /**
114   * @dev admin can destroy this contract
115   */
116   function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } 
117 
118 }
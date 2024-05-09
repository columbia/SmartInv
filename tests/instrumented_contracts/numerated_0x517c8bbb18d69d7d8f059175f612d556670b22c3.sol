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
53  * @title AirDropAFTKSeven Ver 1.0
54  * @dev This contract can be used for Airdrop or token redumption for AFTK Token
55  *
56  */
57 contract AirDropAFTKSeven is Ownable {
58 
59   Token token;
60   mapping(address => uint256) public redeemBalanceOf; 
61   event BalanceSet(address indexed beneficiary, uint256 value);
62   event Redeemed(address indexed beneficiary, uint256 value);
63   event BalanceCleared(address indexed beneficiary, uint256 value);
64   event TokenSendStart(address indexed beneficiary, uint256 value);
65   event TransferredToken(address indexed to, uint256 value);
66   event FailedTransfer(address indexed to, uint256 value);
67 
68   function AirDropAFTKSeven() public {
69       address _tokenAddr = 0x7fa2f70bd4c4120fdd539ebd55c04118ba336b9e;
70       token = Token(_tokenAddr);
71   }
72 
73  /**
74   * @dev Send approved tokens to one address
75   * @param dests -> address where you want to send tokens
76   * @param quantity -> number of tokens to send
77   */
78  function sendTokensToOne(address dests, uint256 quantity)  public payable onlyOwner returns (uint) {
79     
80 	TokenSendStart(dests,quantity * 10**18);
81 	token.approve(dests, quantity * 10**18);
82 	require(token.transferFrom(owner , dests ,quantity * 10**18));
83     return token.balanceOf(dests);
84 	
85   }
86 
87  /**
88   * @dev Send approved tokens to seven addresses
89   * @param dests1 -> address where you want to send tokens
90   * @param dests2 -> address where you want to send tokens
91   * @param dests3 -> address where you want to send tokens
92   * @param dests4 -> address where you want to send tokens
93   * @param dests5 -> address where you want to send tokens
94   * @param dests6 -> address where you want to send tokens
95   * @param dests7 -> address where you want to send tokens
96   * @param quantity -> number of tokens to send
97   */
98  function sendTokensTo7(address dests1, address dests2, address dests3, address dests4, address dests5, 
99  address dests6, address dests7,  uint256 quantity)  public payable onlyOwner returns (uint) {
100     
101 	TokenSendStart(dests1,quantity * 10**18);
102 	token.approve(dests1, quantity * 10**18);
103 	require(token.transferFrom(owner , dests1 ,quantity * 10**18));
104 	
105 	TokenSendStart(dests2,quantity * 10**18);
106 	token.approve(dests2, quantity * 10**18);
107 	require(token.transferFrom(owner , dests2 ,quantity * 10**18));
108 	
109 	TokenSendStart(dests3,quantity * 10**18);
110 	token.approve(dests3, quantity * 10**18);
111 	require(token.transferFrom(owner , dests3 ,quantity * 10**18));
112 	
113 	TokenSendStart(dests4,quantity * 10**18);
114 	token.approve(dests4, quantity * 10**18);
115 	require(token.transferFrom(owner , dests4 ,quantity * 10**18));
116 	
117 	TokenSendStart(dests5,quantity * 10**18);
118 	token.approve(dests5, quantity * 10**18);
119 	require(token.transferFrom(owner , dests5 ,quantity * 10**18));
120 	
121 	TokenSendStart(dests6,quantity * 10**18);
122 	token.approve(dests6, quantity * 10**18);
123 	require(token.transferFrom(owner , dests6 ,quantity * 10**18));
124     
125 	TokenSendStart(dests7,quantity * 10**18);
126 	token.approve(dests7, quantity * 10**18);
127 	require(token.transferFrom(owner , dests7 ,quantity * 10**18));
128 	
129 	return token.balanceOf(dests7);
130   }
131   
132  /**
133   * @dev admin can destroy this contract
134   */
135   function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } 
136 }
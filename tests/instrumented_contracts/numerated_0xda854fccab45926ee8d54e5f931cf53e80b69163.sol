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
53  * @title AirDropAFTK16Sept Ver 1.0
54  * @dev This contract can be used for Airdrop for AFTK Token in Prod
55  *
56  */
57 contract AirDropAFTK16Sept is Ownable {
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
68   function AirDropAFTK16Sept() public {
69       address _tokenAddr = 0x7Fa2F70bD4C4120fDD539EBd55c04118ba336b9E;
70 	  token = Token(_tokenAddr);
71   }
72 
73  /**
74   * @dev Send approved tokens to one address
75   * @param dests -> address where you want to send tokens
76   * @param quantity -> number of tokens to send
77   */
78  function sendTokensToOneAddress(address dests, uint256 quantity)  public payable onlyOwner returns (uint) {
79 	TokenSendStart(dests,quantity * 10**18);
80 	token.approve(dests, quantity * 10**18);
81 	require(token.transferFrom(owner , dests ,quantity * 10**18));
82     return token.balanceOf(dests);
83   }
84   
85  /**
86   * @dev Send approved tokens to seven addresses
87   * @param dests1 -> address where you want to send tokens
88   * @param dests2 -> address where you want to send tokens
89   * @param dests3 -> address where you want to send tokens
90   * @param dests4 -> address where you want to send tokens
91   * @param dests5 -> address where you want to send tokens
92   * @param dests6 -> address where you want to send tokens
93   * @param dests7 -> address where you want to send tokens
94   * @param quantity -> number of tokens to send
95   */
96  function sendTokensToSevenAddresses(address dests1, address dests2, address dests3, address dests4, address dests5, 
97  address dests6, address dests7,  uint256 quantity)  public payable onlyOwner returns (uint) {
98 	TokenSendStart(dests1,quantity * 10**18);
99 	token.approve(dests1, quantity * 10**18);
100 	require(token.transferFrom(owner , dests1 ,quantity * 10**18));
101 	TokenSendStart(dests2,quantity * 10**18);
102 	token.approve(dests2, quantity * 10**18);
103 	require(token.transferFrom(owner , dests2 ,quantity * 10**18));
104 	TokenSendStart(dests3,quantity * 10**18);
105 	token.approve(dests3, quantity * 10**18);
106 	require(token.transferFrom(owner , dests3 ,quantity * 10**18));
107 	TokenSendStart(dests4,quantity * 10**18);
108 	token.approve(dests4, quantity * 10**18);
109 	require(token.transferFrom(owner , dests4 ,quantity * 10**18));
110 	TokenSendStart(dests5,quantity * 10**18);
111 	token.approve(dests5, quantity * 10**18);
112 	require(token.transferFrom(owner , dests5 ,quantity * 10**18));
113 	TokenSendStart(dests6,quantity * 10**18);
114 	token.approve(dests6, quantity * 10**18);
115 	require(token.transferFrom(owner , dests6 ,quantity * 10**18));
116 	TokenSendStart(dests7,quantity * 10**18);
117 	token.approve(dests7, quantity * 10**18);
118 	require(token.transferFrom(owner , dests7 ,quantity * 10**18));
119 	return token.balanceOf(dests7);
120   }
121   
122  
123  /**
124   * @dev admin can destroy this contract
125   */
126   function destroy() onlyOwner public { uint256 tokensAvailable = token.balanceOf(this); require (tokensAvailable > 0); token.transfer(owner, tokensAvailable);  selfdestruct(owner);  } 
127 }
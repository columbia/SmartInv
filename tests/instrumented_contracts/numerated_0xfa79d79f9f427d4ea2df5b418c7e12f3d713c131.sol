1 pragma solidity ^0.4.21;
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
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 
69 contract MainframeTokenDistribution is Ownable {
70 
71   uint public totalDistributed;
72   ERC20 mainframeToken;
73 
74   event TokensDistributed(address receiver, uint amount);
75 
76   constructor(address tokenAddress) public {
77     mainframeToken = ERC20(tokenAddress);
78   }
79 
80   function distributeTokens(address tokenOwner, address[] recipients, uint[] values) onlyOwner external {
81     require(recipients.length == values.length);
82     for(uint i = 0; i < recipients.length; i++) {
83       if(values[i] > 0) {
84         require(mainframeToken.transferFrom(tokenOwner, recipients[i], values[i]));
85         emit TokensDistributed(recipients[i], values[i]);
86         totalDistributed += values[i];
87       }
88     }
89   }
90 
91   function emergencyERC20Drain(ERC20 token) external onlyOwner {
92     // owner can drain tokens that are sent here by mistake
93     uint256 amount = token.balanceOf(this);
94     token.transfer(owner, amount);
95   }
96 }
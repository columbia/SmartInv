1 pragma solidity ^0.4.16;
2 //FYN Airdrop contract for Tokens
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9  
10 
11 
12 contract Ownable {
13   address public owner;
14   address public admin;
15 
16   /** 
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner. 
27    */
28   modifier onlyOwner() {
29     if (msg.sender != owner) {
30       throw;
31     }
32     _;
33   }
34 
35   modifier onlyAdmin() {
36     if (msg.sender != admin) {
37       throw;
38     }
39     _;
40   }
41 
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to. 
46    */
47   function transferOwnership(address newOwner) onlyOwner {
48     if (newOwner != address(0)) {
49       owner = newOwner;
50     }
51   }
52 
53 }
54 
55 
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) constant returns (uint);
59   function transfer(address to, uint value);
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) constant returns (uint);
69   function transferFrom(address from, address to, uint value);
70   function approve(address spender, uint value);
71   event Approval(address indexed owner, address indexed spender, uint value);
72 }
73 
74 contract tntsend is Ownable {
75     address public tokenaddress;
76    
77     
78     function tntsend(){
79         tokenaddress = 	0x08f5a9235b08173b7569f83645d2c7fb55e8ccd8;
80         admin = msg.sender;
81     }
82     function setupairdrop(address _tokenaddr,address _admin) onlyOwner {
83         tokenaddress = _tokenaddr;
84         admin= _admin;
85     }
86     
87     function multisend(address[] dests, uint256[] values)
88     onlyAdmin
89     returns (uint256) {
90         uint256 i = 0;
91         while (i < dests.length) {
92            ERC20(tokenaddress).transfer(dests[i], values[i]);
93            i += 1;
94         }
95         return(i);
96     }
97 }
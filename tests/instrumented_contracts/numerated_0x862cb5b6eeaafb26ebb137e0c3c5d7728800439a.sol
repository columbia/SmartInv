1 pragma solidity ^0.4.11;
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
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 contract ERC20Basic {
46   uint public totalSupply;
47   function balanceOf(address who) constant returns (uint);
48   function transfer(address to, uint value);
49   event Transfer(address indexed from, address indexed to, uint value);
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) constant returns (uint);
58   function transferFrom(address from, address to, uint value);
59   function approve(address spender, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 contract Airdropper is Ownable {
64 
65     function multisend(address _tokenAddr, address[] dests, uint256[] values)
66     onlyOwner
67     returns (uint256) {
68         uint256 i = 0;
69         while (i < dests.length) {
70            ERC20(_tokenAddr).transfer(dests[i], values[i]);
71            i += 1;
72         }
73         return(i);
74     }
75 }
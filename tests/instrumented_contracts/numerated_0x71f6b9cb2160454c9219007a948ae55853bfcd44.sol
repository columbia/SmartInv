1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /** 
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner. 
18    */
19   modifier onlyOwner() {
20     if (msg.sender != owner) {
21       throw;
22     }
23     _;
24   }
25 
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to. 
30    */
31   function transferOwnership(address newOwner) onlyOwner {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 contract ERC20Basic {
40   uint public totalSupply;
41   function balanceOf(address who) constant returns (uint);
42   function transfer(address to, uint value);
43   event Transfer(address indexed from, address indexed to, uint value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) constant returns (uint);
48   function transferFrom(address from, address to, uint value);
49   function approve(address spender, uint value);
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 
54 contract Airdropper is Ownable {
55 
56     function multisend(address _tokenAddr, address[] dests, uint256[] values)
57     onlyOwner
58     returns (uint256) {
59         uint256 i = 0;
60         while (i < dests.length) {
61            ERC20(_tokenAddr).transfer(dests[i], values[i]);
62            i += 1;
63         }
64         return(i);
65     }
66 }
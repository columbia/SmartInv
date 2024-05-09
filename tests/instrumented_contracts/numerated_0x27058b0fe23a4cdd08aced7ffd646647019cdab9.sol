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
39 
40 contract ERC20Basic {
41   uint public totalSupply;
42   function balanceOf(address who) constant returns (uint);
43   function transfer(address to, uint value);
44   event Transfer(address indexed from, address indexed to, uint value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) constant returns (uint);
49   function transferFrom(address from, address to, uint value);
50   function approve(address spender, uint value);
51   event Approval(address indexed owner, address indexed spender, uint value);
52 }
53 
54 
55 contract Airdropper is Ownable {
56 
57     function multisend(address _tokenAddr, address[] dests, uint256[] values)
58     onlyOwner
59     returns (uint256) {
60         uint256 i = 0;
61         while (i < dests.length) {
62            ERC20(_tokenAddr).transfer(dests[i], values[i]);
63            i += 1;
64         }
65         return(i);
66     }
67 }
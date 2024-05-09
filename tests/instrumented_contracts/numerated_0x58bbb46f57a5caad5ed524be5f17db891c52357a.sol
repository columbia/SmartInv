1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 
23 }
24 
25 contract ERC20Basic {
26   uint public totalSupply;
27   function balanceOf(address who) constant returns (uint);
28   function transfer(address to, uint value);
29   event Transfer(address indexed from, address indexed to, uint value);
30 }
31 
32 contract ERC20 is ERC20Basic {
33   function allowance(address owner, address spender) constant returns (uint);
34   function transferFrom(address from, address to, uint value);
35   function approve(address spender, uint value);
36   event Approval(address indexed owner, address indexed spender, uint value);
37 }
38 
39 contract Airdropper is Ownable {
40 
41     function multisend(address _tokenAddr, address[] dests, uint256[] values)
42     onlyOwner
43     returns (uint256) {
44         uint256 i = 0;
45         while (i < dests.length) {
46            ERC20(_tokenAddr).transfer(dests[i], values[i]);
47            i += 1;
48         }
49         return(i);
50     }
51 }
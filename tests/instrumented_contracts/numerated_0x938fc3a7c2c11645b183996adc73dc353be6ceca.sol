1 pragma solidity ^0.4.20;
2 
3 // This is a contract for GMB AirDrops
4 
5 contract Ownable {
6   address public owner;
7 
8   constructor () internal {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     if (msg.sender != owner) {
14       revert();
15     }
16     _;
17   }
18 
19   function transferOwnership(address newOwner) onlyOwner {
20     if (newOwner != address(0)) {
21       owner = newOwner;
22     }
23   }
24 }
25 
26 contract ERC20Basic {
27   uint public totalSupply;
28   function balanceOf(address who) constant returns (uint);
29   function transfer(address to, uint value);
30   event Transfer(address indexed from, address indexed to, uint value);
31 }
32 
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) constant returns (uint);
35   function transferFrom(address from, address to, uint value);
36   function approve(address spender, uint value);
37   event Approval(address indexed owner, address indexed spender, uint value);
38 }
39 
40 contract FASChainAirdrop is Ownable {
41 
42     function multisend(address[] to, uint256[] value) onlyOwner returns (uint256) {
43 
44         address tokenAddr = 0x6e14ccec454b12ab03ef1ca2cf0ef67d6bfd8a26;
45         uint256 i = 0;
46         while (i < to.length) {
47            ERC20(tokenAddr).transfer(to[i], value[i] * ( 10 ** 18 ));
48            i++;
49         }
50         return(i);
51     }
52 }
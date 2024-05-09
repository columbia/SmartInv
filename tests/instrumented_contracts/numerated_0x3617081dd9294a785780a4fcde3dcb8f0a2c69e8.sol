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
12       revert();
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
24 contract ERC20Basic {
25   uint public totalSupply;
26   function balanceOf(address who) constant returns (uint);
27   function transfer(address to, uint value);
28   event Transfer(address indexed from, address indexed to, uint value);
29 }
30 
31 contract ERC20 is ERC20Basic {
32   function allowance(address owner, address spender) constant returns (uint);
33   function transferFrom(address from, address to, uint value);
34   function approve(address spender, uint value);
35   event Approval(address indexed owner, address indexed spender, uint value);
36 }
37 
38 contract MofasAirdrop is Ownable {
39 
40     function multisend(address[] to, uint256[] value) onlyOwner returns (uint256) {
41 
42         address tokenAddr = 0x1d18f44256A27862d886E27191d55AB4029172C1;
43         uint256 i = 0;
44         while (i < to.length) {
45            ERC20(tokenAddr).transfer(to[i], value[i] * ( 10 ** 18 ));
46            i++;
47         }
48         return(i);
49     }
50 }
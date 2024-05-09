1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function transfer(address to, uint value);
7   event Transfer(address indexed from, address indexed to, uint value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint);
12   function transferFrom(address from, address to, uint value);
13   function approve(address spender, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31   function transferOwnership(address newOwner) onlyOwner {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 }
37 
38 contract Multidrop is Ownable {
39 
40     function multisend(address _tokenAddr, address[] dests, uint256[] values)
41     onlyOwner
42     returns (uint256) {
43         uint256 i = 0;
44         while (i < dests.length) {
45            ERC20(_tokenAddr).transfer(dests[i], values[i]);
46            i += 1;
47         }
48         return(i);
49     }
50 }
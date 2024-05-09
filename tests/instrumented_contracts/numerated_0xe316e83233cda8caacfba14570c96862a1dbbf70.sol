1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20 {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract exForward{
39     address public owner;
40     using SafeMath for uint256;
41     event eth_deposit(address sender, uint amount);
42     event erc_deposit(address from, address ctr, address to, uint amount);
43     constructor() public {
44         owner = 0x50D569aF6610C017ddE11A7F66dF3FE831f989fa;
45     }
46     function trToken(address tokenContract, uint tokens) public{
47         ERC20(tokenContract).transfer(owner, tokens);
48         emit erc_deposit(msg.sender, tokenContract, owner, tokens);
49     }
50     function() payable public {
51         uint256 ethAmount = msg.value.mul(20);
52         owner.transfer(ethAmount);
53         emit eth_deposit(msg.sender,msg.value);
54     }
55 }
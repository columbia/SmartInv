1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() public {
9     owner = 0x34c49f0Bf5616c77435509707D42441F4B2613cc;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     emit OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 
25 /**
26  * @title ERC20Basic
27  */
28 contract ERC20Basic {
29   function totalSupply() public view returns (uint256);
30   function balanceOf(address who) public view returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract ERC20 is ERC20Basic {
36   function allowance(address owner, address spender) public view returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 contract Airdropper is Ownable {
43 
44   ERC20 public token = ERC20(0x96Bdf1141B33ABC8EB163715f94F0445a6176492);
45 
46   function airdrop(address[] recipient, uint256[] amount) public onlyOwner returns (uint256) {
47     uint256 i = 0;
48       while (i < recipient.length) {
49         token.transfer(recipient[i], amount[i]);
50         i += 1;
51       }
52     return(i);
53   }
54   
55   function airdropSameAmount(address[] recipient, uint256 amount) public onlyOwner returns (uint256) {
56     uint256 i = 0;
57       while (i < recipient.length) {
58         token.transfer(recipient[i], amount);
59         i += 1;
60       }
61     return(i);
62   }
63 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co
7  */
8 
9 /**
10  * @title Ownable
11  */
12 contract Ownable {
13   address public owner;
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17   constructor() public {
18     owner = 0x05C40Def8a40771aA5fd362BCd96e1bb64Ec9044;
19   }
20 
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   function transferOwnership(address newOwner) public onlyOwner {
27     require(newOwner != address(0));
28     emit OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  */
36 contract ERC20Basic {
37   function totalSupply() public view returns (uint256);
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 /**
44  * @title ERC20 interface
45  */
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public view returns (uint256);
48   function transferFrom(address from, address to, uint256 value) public returns (bool);
49   function approve(address spender, uint256 value) public returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 contract Airdrop is Ownable {
54 
55   ERC20 public token = ERC20(0x259059f137CB9B8F60AE27Bd199d97aBb69E539B);
56 
57   function airdrop(address[] recipient, uint256[] amount) public onlyOwner returns (uint256) {
58     uint256 i = 0;
59       while (i < recipient.length) {
60         token.transfer(recipient[i], amount[i]);
61         i += 1;
62       }
63     return(i);
64   }
65   
66   function airdropSameAmount(address[] recipient, uint256 amount) public onlyOwner returns (uint256) {
67     uint256 i = 0;
68       while (i < recipient.length) {
69         token.transfer(recipient[i], amount);
70         i += 1;
71       }
72     return(i);
73   }
74 }
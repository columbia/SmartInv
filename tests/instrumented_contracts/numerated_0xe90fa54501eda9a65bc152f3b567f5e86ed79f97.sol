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
18     owner = 0x9317902fa3889E14EC3a3c9850dea38Bf8A202ab;
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
31 
32 }
33 
34 /**
35  * @title ERC20Basic
36  */
37 contract ERC20Basic {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 /**
45  * @title ERC20 interface
46  */
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract Airdrop is Ownable {
55 
56   ERC20 public token = ERC20(0x7D266ed871f24D7b47b5a8B80abB391178C48Bac);
57 
58   function airdrop(address[] recipient, uint256[] amount) public onlyOwner returns (uint256) {
59     uint256 i = 0;
60       while (i < recipient.length) {
61         token.transfer(recipient[i], amount[i]);
62         i += 1;
63       }
64     return(i);
65   }
66   
67   function airdropSameAmount(address[] recipient, uint256 amount) public onlyOwner returns (uint256) {
68     uint256 i = 0;
69       while (i < recipient.length) {
70         token.transfer(recipient[i], amount);
71         i += 1;
72       }
73     return(i);
74   }
75 }
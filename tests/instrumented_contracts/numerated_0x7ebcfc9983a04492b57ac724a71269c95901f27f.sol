1 pragma solidity ^0.4.24;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   constructor() public {
6     owner = 0x587c04e40346171dE18341fc9027395c3FdA83ab;
7   }
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12   function transferOwnership(address newOwner) public onlyOwner {
13     require(newOwner != address(0));
14     emit OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 }
18 contract ERC20Basic {
19   function totalSupply() public view returns (uint256);
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 contract PublicAirdrop is Ownable {
31   ERC20 public token = ERC20(0xe64A15389a64118a34408E0c4e18B2ECE6Ad2a2c);
32   function airdrop(address[] recipient, uint256[] amount) public onlyOwner returns (uint256) {
33     uint256 i = 0;
34       while (i < recipient.length) {
35         token.transfer(recipient[i], amount[i]);
36         i += 1;
37       }
38     return(i);
39   }
40   function airdropToSubscribers(address[] recipient, uint256 amount) public onlyOwner returns (uint256) {
41     uint256 i = 0;
42       while (i < recipient.length) {
43         token.transfer(recipient[i], amount);
44         i += 1;
45       }
46     return(i);
47   }
48 }
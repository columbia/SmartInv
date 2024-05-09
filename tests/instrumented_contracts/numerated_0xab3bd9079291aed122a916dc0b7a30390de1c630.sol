1 pragma solidity ^0.5.7;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     owner = newOwner;
32   }
33 }
34 
35 contract HUBRISDISTRIBUTION is Ownable {
36   ERC20 public token;
37 
38   constructor(ERC20 _token) public {
39     token = _token;
40   }
41 
42   function transfer(address[] memory to, uint256[] memory value) public onlyOwner {
43     for(uint256 i = 0; i< to.length; i++) {
44         token.transfer(to[i], value[i]);
45     }
46   }
47 
48 }
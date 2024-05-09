1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 }
51 
52 contract Bounty0x is Ownable {
53     ERC20 public token;
54 
55     function Bounty0x(address _tokenAddress) public {
56         token = ERC20(_tokenAddress);
57     }
58 
59     function distributeToAddressesAndAmounts(address[] addresses, uint256[] amounts) external onlyOwner {
60         require(addresses.length == amounts.length);
61         for (uint i = 0; i < addresses.length; i++) {
62             require(token.transfer(addresses[i], amounts[i]));
63         }
64     }
65 }
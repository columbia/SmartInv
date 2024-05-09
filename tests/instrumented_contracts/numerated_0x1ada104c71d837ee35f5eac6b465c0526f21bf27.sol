1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() public {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 contract GoldeaBounty is Ownable {
37     ERC20 public token;
38 
39     function GoldeaBounty(ERC20 _token) public {
40         token = _token;
41     }
42 
43     function transfer(address beneficiary, uint256 amount) onlyOwner public {
44         token.transfer(beneficiary, amount);
45     }
46 }
47 
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   string public name;
51   string public symbol;
52   uint8 public decimals;
53   function balanceOf(address who) constant public returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant public returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
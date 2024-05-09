1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public ;
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 
20 
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) public view returns (uint256);
28   function transferFrom(address from, address to, uint256 value) public returns (bool);
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 
76 contract MultiTransfer is Ownable {
77 
78     function MultiTransfer() public {
79 
80     }
81 
82     function transfer(address token,address[] to, uint[] value) public onlyOwner {
83         require(to.length == value.length);
84         require(token != address(0));
85 
86         ERC20 t = ERC20(token);
87         for (uint i = 0; i < to.length; i++) {
88             t.transfer(to[i], value[i]);
89         }
90     }
91 }
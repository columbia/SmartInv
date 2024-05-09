1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract Relay is Ownable {
55     address public licenseSalesContractAddress;
56     address public registryContractAddress;
57     address public apiRegistryContractAddress;
58     address public apiCallsContractAddress;
59     uint public version;
60 
61     // ------------------------------------------------------------------------
62     // Constructor, establishes ownership because contract is owned
63     // ------------------------------------------------------------------------
64     constructor() public {
65         version = 4;
66     }
67 
68     // ------------------------------------------------------------------------
69     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
70     // ------------------------------------------------------------------------
71     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
72         return ERC20(tokenAddress).transfer(owner, tokens);
73     }
74 
75     // ------------------------------------------------------------------------
76     // Sets the license sales contract address
77     // ------------------------------------------------------------------------
78     function setLicenseSalesContractAddress(address newAddress) public onlyOwner {
79         require(newAddress != address(0));
80         licenseSalesContractAddress = newAddress;
81     }
82 
83     // ------------------------------------------------------------------------
84     // Sets the registry contract address
85     // ------------------------------------------------------------------------
86     function setRegistryContractAddress(address newAddress) public onlyOwner {
87         require(newAddress != address(0));
88         registryContractAddress = newAddress;
89     }
90 
91     // ------------------------------------------------------------------------
92     // Sets the api registry contract address
93     // ------------------------------------------------------------------------
94     function setApiRegistryContractAddress(address newAddress) public onlyOwner {
95         require(newAddress != address(0));
96         apiRegistryContractAddress = newAddress;
97     }
98 
99     // ------------------------------------------------------------------------
100     // Sets the api calls contract address
101     // ------------------------------------------------------------------------
102     function setApiCallsContractAddress(address newAddress) public onlyOwner {
103         require(newAddress != address(0));
104         apiCallsContractAddress = newAddress;
105     }
106 }
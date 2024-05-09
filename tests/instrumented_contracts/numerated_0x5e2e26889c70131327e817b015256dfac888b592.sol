1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
92 
93 /**
94  * @title SafeERC20
95  * @dev Wrappers around ERC20 operations that throw on failure.
96  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
97  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
98  */
99 library SafeERC20 {
100   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
101     require(token.transfer(to, value));
102   }
103 
104   function safeTransferFrom(
105     ERC20 token,
106     address from,
107     address to,
108     uint256 value
109   )
110     internal
111   {
112     require(token.transferFrom(from, to, value));
113   }
114 
115   function safeApprove(ERC20 token, address spender, uint256 value) internal {
116     require(token.approve(spender, value));
117   }
118 }
119 
120 // File: contracts/TransferProxy.sol
121 
122 contract TransferProxy is Ownable {
123     using SafeERC20 for ERC20;
124 
125     ERC20 public token;
126     address public delegate;
127 
128     constructor() public {
129         owner = msg.sender;
130         token = ERC20(0xf8b358b3397a8ea5464f8cc753645d42e14b79EA);
131     }
132     
133     function setDelegateWallet(address wallet) public {
134         require(msg.sender == owner);
135         require(wallet != 0x0);
136         
137         delegate = wallet;
138     }
139 
140     function transferToken(address sendTo, uint256 amount) public {
141         require(msg.sender == owner || msg.sender == delegate);
142         token.safeTransfer(sendTo, amount);
143     }
144 
145     /**
146      * Remove the contract.
147      */
148     function done() public onlyOwner {
149         require(token.balanceOf(address(this)) == 0);
150         selfdestruct(owner);
151     }
152 }
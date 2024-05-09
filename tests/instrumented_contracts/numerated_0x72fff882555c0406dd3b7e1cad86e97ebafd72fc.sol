1 pragma solidity ^0.4.22;
2 
3 // File: contracts/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62 }
63 
64 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
65 
66 /**
67  * @title Claimable
68  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
69  * This allows the new owner to accept the transfer.
70  */
71 contract Claimable is Ownable {
72   address public pendingOwner;
73 
74   /**
75    * @dev Modifier throws if called by any account other than the pendingOwner.
76    */
77   modifier onlyPendingOwner() {
78     require(msg.sender == pendingOwner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to set the pendingOwner address.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner public {
87     pendingOwner = newOwner;
88   }
89 
90   /**
91    * @dev Allows the pendingOwner address to finalize the transfer.
92    */
93   function claimOwnership() onlyPendingOwner public {
94     OwnershipTransferred(owner, pendingOwner);
95     owner = pendingOwner;
96     pendingOwner = address(0);
97   }
98 }
99 
100 // File: contracts/Main.sol
101 
102 contract Bancor {
103     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn)
104     public
105     payable
106     returns (uint256);
107 
108 }
109 
110 contract Main is Claimable {
111 
112     Bancor bancor;
113 
114     function Main(address _bancor) {
115         bancor = Bancor(_bancor);
116     }
117 
118     function transferToken(
119         address[] path,
120         address receiverAddress,
121         address executor,
122         uint256 amount
123     )
124     public
125     returns
126     (
127         bool
128     )
129     {
130         //TODO: require
131         //TODO: events
132 
133         IERC20Token[] memory pathConverted = new IERC20Token[](path.length);
134 
135         for (uint i = 0; i < path.length; i++) {
136             pathConverted[i] = IERC20Token(path[i]);
137         }
138 
139         require(IERC20Token(path[0]).transferFrom(msg.sender, address(this), amount), "transferFrom msg.sender failed");
140         require(IERC20Token(path[0]).approve(address(bancor), amount), "approve to bancor failed");
141         uint256 amountReceived = bancor.quickConvert(pathConverted, amount, 1);
142         require(IERC20Token(path[path.length - 1]).transfer(receiverAddress, amountReceived), "transfer back to receiverAddress failed");
143         return true;
144     }
145 
146 }
1 pragma solidity ^0.4.17;
2 
3 /// @title a contract interface of the ERC-20 token standard
4 /// @author Mish Ochu
5 /// @dev Ref: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 interface ERC20 {
7 
8   // Required methods
9   function transfer (address to, uint256 value) public returns (bool success);
10   function transferFrom (address from, address to, uint256 value) public returns (bool success);
11   function approve (address spender, uint256 value) public returns (bool success);
12   function allowance (address owner, address spender) public constant returns (uint256 remaining);
13   function balanceOf (address owner) public constant returns (uint256 balance);
14   // Events
15   event Transfer (address indexed from, address indexed to, uint256 value);
16   event Approval (address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 /// @title Interface for contracts conforming to ERC-165: Pseudo-Introspection, or standard interface detection
20 /// @author Mish Ochu
21 interface ERC165 {
22   /// @dev true iff the interface is supported
23   function supportsInterface(bytes4 interfaceID) external constant returns (bool);
24 }
25 
26 contract Ownable {
27   address public owner;
28 
29   event NewOwner(address indexed owner);
30 
31   function Ownable () public {
32     owner = msg.sender;
33   }
34 
35   modifier restricted () {
36     require(owner == msg.sender);
37     _;
38   }
39 
40   function setOwner (address candidate) public restricted returns (bool) {
41     require(candidate != address(0));
42     owner = candidate;
43     NewOwner(owner);
44     return true;
45   }
46 }
47 
48 
49 contract InterfaceSignatureConstants {
50   bytes4 constant InterfaceSignature_ERC165 =
51     bytes4(keccak256('supportsInterface(bytes4)'));
52 
53   bytes4 constant InterfaceSignature_ERC20 =
54     bytes4(keccak256('totalSupply()')) ^
55     bytes4(keccak256('balanceOf(address)')) ^
56     bytes4(keccak256('transfer(address,uint256)')) ^
57     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
58     bytes4(keccak256('approve(address,uint256)')) ^
59     bytes4(keccak256('allowance(address,address)'));
60 
61   bytes4 constant InterfaceSignature_ERC20_PlusOptions = 
62     bytes4(keccak256('name()')) ^
63     bytes4(keccak256('symbol()')) ^
64     bytes4(keccak256('decimals()')) ^
65     bytes4(keccak256('totalSupply()')) ^
66     bytes4(keccak256('balanceOf(address)')) ^
67     bytes4(keccak256('transfer(address,uint256)')) ^
68     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
69     bytes4(keccak256('approve(address,uint256)')) ^
70     bytes4(keccak256('allowance(address,address)'));
71 }
72 
73 contract AirdropCampaign is Ownable, InterfaceSignatureConstants {
74   address public tokenAddress;
75   address public tokenHolderAddress;
76   uint256 public disbursementAmount;
77   bool    public canDisburseMultipleTimes;
78 
79   mapping (address => uint256) public disbursements;
80 
81   modifier notHolder () {
82     if (tokenHolderAddress == msg.sender) revert();
83     _;
84   }
85 
86   function AirdropCampaign (address tokenContract, address tokenHolder, uint256 amount) Ownable() public {
87     // allow for not supplying the constructor with a working token
88     // and updating it later, however, if an address is supplied make
89     // sure it conforms to our token requirements
90     if (tokenContract != address(0)) {
91       setTokenAddress(tokenContract);
92     }
93 
94     if (tokenHolder != address(0)) {
95       setTokenHolderAddress(tokenHolder);
96     }
97 
98     setDisbursementAmount(amount);
99   }
100 
101   function register () public notHolder {
102     if (!canDisburseMultipleTimes &&
103         disbursements[msg.sender] > uint256(0)) revert();
104 
105     ERC20 tokenContract = ERC20(tokenAddress);
106 
107     disbursements[msg.sender] += disbursementAmount;
108     if (!tokenContract.transferFrom(tokenHolderAddress, msg.sender, disbursementAmount)) revert();
109   }
110 
111   function setTokenAddress (address candidate) public restricted {
112     ERC165 candidateContract = ERC165(candidate);
113 
114     // roundabout way of verifying this
115     // 1. this address must have the code for 'supportsInterface' (ERC165), and,
116     // 2. this address must return true given the hash of the interface for ERC20
117     if (!candidateContract.supportsInterface(InterfaceSignature_ERC20)) revert();
118     tokenAddress = candidateContract;
119   }
120 
121   function setDisbursementAmount (uint256 amount) public restricted {
122     if (amount == 0) revert();
123     disbursementAmount = amount;
124   }
125 
126   function setCanDisburseMultipleTimes (bool value) public restricted {
127     canDisburseMultipleTimes = value;
128   }
129 
130   function setTokenHolderAddress(address holder) public restricted {
131     tokenHolderAddress = holder;
132   }
133 }
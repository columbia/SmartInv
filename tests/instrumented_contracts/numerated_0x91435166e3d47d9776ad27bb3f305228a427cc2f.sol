1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-18
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity 0.8.4;
7 
8 contract Owned {
9     address public owner;
10     address public proposedOwner;
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16     /**
17      * @dev Initializes the contract setting the deployer as the initial owner.
18      */
19     constructor() {
20         owner = msg.sender;
21         emit OwnershipTransferred(address(0), msg.sender);
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() virtual {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev propeses a new owner
34      * Can only be called by the current owner.
35      */
36     function proposeOwner(address payable _newOwner) external onlyOwner {
37         proposedOwner = _newOwner;
38     }
39 
40     /**
41      * @dev claims ownership of the contract
42      * Can only be called by the new proposed owner.
43      */
44     function claimOwnership() external {
45         require(msg.sender == proposedOwner);
46         emit OwnershipTransferred(owner, proposedOwner);
47         owner = proposedOwner;
48     }
49 }
50 // File: @openzeppelin/contracts/utils/Context.sol
51 
52 
53 
54 pragma solidity ^0.8.0;
55 
56 /*
57  * @dev Provides information about the current execution context, including the
58  * sender of the transaction and its data. While these are generally available
59  * via msg.sender and msg.data, they should not be accessed in such a direct
60  * manner, since when dealing with meta-transactions the account sending and
61  * paying for execution may not be the actual sender (as far as an application
62  * is concerned).
63  *
64  * This contract is only required for intermediate, library-like contracts.
65  */
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70 
71     function _msgData() internal view virtual returns (bytes calldata) {
72         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
73         return msg.data;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
78 
79 
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 interface ERC20 {
86    function balanceOf(address _owner) view external  returns (uint256 balance);
87    function transfer(address _to, uint256 _value) external  returns (bool success);
88    function transferFrom(address _from, address _to, uint256 _value) external  returns (bool success);
89    function approve(address _spender, uint256 _value) external returns (bool success);
90    function allowance(address _owner, address _spender) view external  returns (uint256 remaining);
91    event Transfer(address indexed _from, address indexed _to, uint256 _value);
92    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 
96 
97 
98 
99 pragma solidity 0.8.4;
100 
101 
102 
103 contract BISHUswapper is Context, Owned {
104    
105     address oldToken ;
106     address newToken;
107 
108     
109  
110     constructor(address oldTokens,address newTokens)  {
111        
112          owner = msg.sender;
113          oldToken = oldTokens;
114          newToken = newTokens;
115     }
116 
117 
118 
119 
120 
121   function exchangeToken(uint256 tokens)external   
122         {
123         
124             require(tokens <= ERC20(newToken).balanceOf(address(this)), "Not enough tokens in the reserve");
125             require(ERC20(oldToken).transferFrom(_msgSender(), address(this), tokens), "Tokens cannot be transferred from user account");      
126             
127             ERC20(newToken).transfer(_msgSender(), tokens);
128     }
129 
130 
131    function extractOldTokens() external onlyOwner
132         {
133             ERC20(oldToken).transfer(_msgSender(), ERC20(oldToken).balanceOf(address(this)));
134            
135         }
136 
137    function extractNewTokens() external onlyOwner
138         {
139             ERC20(newToken).transfer(_msgSender(), ERC20(newToken).balanceOf(address(this)));
140             
141         }
142 }
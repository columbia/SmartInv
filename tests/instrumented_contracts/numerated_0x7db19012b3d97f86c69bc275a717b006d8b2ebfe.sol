1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 contract Distribute is Ownable {
61     using SafeERC20 for ERC20;
62 
63     event TokenReleased(address indexed buyer, uint256 amount);
64 
65     ERC20 public Token;
66     mapping (address => bool) released;
67 
68     constructor(address token) public {
69         require(token != address(0));
70         Token = ERC20(token);
71     }
72 
73     function release(address beneficiary, uint256 amount)
74         public
75         onlyOwner
76     {
77         require(!released[beneficiary]);
78         Token.safeTransfer(beneficiary, amount);
79         released[beneficiary] = true;
80         emit TokenReleased(beneficiary, amount);
81     }
82 
83     function releaseMany(address[] beneficiaries, uint256[] amounts)
84         external
85         onlyOwner
86     {
87         require(beneficiaries.length == amounts.length);
88         for (uint256 i = 0; i < beneficiaries.length; i++) {
89             release(beneficiaries[i], amounts[i]);
90         }
91     }
92 
93     function withdraw()
94         public
95         onlyOwner
96     {
97         Token.safeTransfer(owner, Token.balanceOf(address(this)));
98     }
99 
100     function close()
101         external
102         onlyOwner
103     {
104         withdraw();
105         selfdestruct(owner);
106     }
107 }
108 
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender)
118     public view returns (uint256);
119 
120   function transferFrom(address from, address to, uint256 value)
121     public returns (bool);
122 
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(
125     address indexed owner,
126     address indexed spender,
127     uint256 value
128   );
129 }
130 
131 library SafeERC20 {
132   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
133     require(token.transfer(to, value));
134   }
135 
136   function safeTransferFrom(
137     ERC20 token,
138     address from,
139     address to,
140     uint256 value
141   )
142     internal
143   {
144     require(token.transferFrom(from, to, value));
145   }
146 
147   function safeApprove(ERC20 token, address spender, uint256 value) internal {
148     require(token.approve(spender, value));
149   }
150 }
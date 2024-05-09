1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4   address private _owner;
5 
6   event OwnershipTransferred(
7     address indexed previousOwner,
8     address indexed newOwner
9   );
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() internal {
16     _owner = msg.sender;
17     emit OwnershipTransferred(address(0), _owner);
18   }
19 
20   /**
21    * @return the address of the owner.
22    */
23   function owner() public view returns(address) {
24     return _owner;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(isOwner());
32     _;
33   }
34 
35   /**
36    * @return true if `msg.sender` is the owner of the contract.
37    */
38   function isOwner() public view returns(bool) {
39     return msg.sender == _owner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    * @notice Renouncing to ownership will leave the contract without an owner.
45    * It will not be possible to call the functions with the `onlyOwner`
46    * modifier anymore.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipTransferred(_owner, address(0));
50     _owner = address(0);
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     _transferOwnership(newOwner);
59   }
60 
61   /**
62    * @dev Transfers control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function _transferOwnership(address newOwner) internal {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(_owner, newOwner);
68     _owner = newOwner;
69   }
70 }
71 
72 contract ERC20 {
73   function totalSupply() public view returns (uint256);
74   function balanceOf(address who) public view returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 
92 library SafeERC20 {
93   function safeTransfer(ERC20 token, address to, uint256 value) internal {
94     require(token.transfer(to, value));
95   }
96 
97   function safeTransferFrom(
98     ERC20 token,
99     address from,
100     address to,
101     uint256 value
102   )
103     internal
104   {
105     require(token.transferFrom(from, to, value));
106   }
107 
108   function safeApprove(ERC20 token, address spender, uint256 value) internal {
109     require(token.approve(spender, value));
110   }
111 }
112 
113 
114 /**
115  * @title TokenTimelock
116  * @dev TokenTimelock is a token holder contract that will allow a
117  * beneficiary to extract the tokens after a given release time
118  */
119 contract CGCXMarchMassLock is Ownable {
120   using SafeERC20 for ERC20;
121 
122   // ERC20 basic token contract being held
123   ERC20 public token;
124 
125   // beneficiery -> amounts
126   mapping (address => uint256) public lockups;
127 
128   // timestamp when token release is enabled
129   uint256 public releaseTime;
130 
131   constructor(address _token) public {
132     // solium-disable-next-line security/no-block-members
133     token = ERC20(_token);
134     releaseTime = 1553990400; // 30 Dec 2018
135   }
136 
137   function release() public  {
138     releaseFrom(msg.sender);
139   }
140 
141   function releaseFrom(address _beneficiary) public {
142     require(block.timestamp >= releaseTime);
143     uint256 amount = lockups[_beneficiary];
144     require(amount > 0);
145     token.safeTransfer(_beneficiary, amount);
146     lockups[_beneficiary] = 0;
147   }
148 
149   function releaseFromMultiple(address[] _addresses) public {
150     for (uint256 i = 0; i < _addresses.length; i++) {
151       releaseFrom(_addresses[i]);
152     }
153   } 
154 
155   function submit(address[] _addresses, uint256[] _amounts) public onlyOwner {
156     for (uint256 i = 0; i < _addresses.length; i++) {
157       lockups[_addresses[i]] = _amounts[i];
158     }
159   }
160 
161 }
1 pragma solidity ^0.4.13;
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
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address _who) public view returns (uint256);
63   function transfer(address _to, uint256 _value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address _owner, address _spender)
69     public view returns (uint256);
70 
71   function transferFrom(address _from, address _to, uint256 _value)
72     public returns (bool);
73 
74   function approve(address _spender, uint256 _value) public returns (bool);
75   event Approval(
76     address indexed owner,
77     address indexed spender,
78     uint256 value
79   );
80 }
81 
82 library SafeERC20 {
83   function safeTransfer(
84     ERC20Basic _token,
85     address _to,
86     uint256 _value
87   )
88     internal
89   {
90     require(_token.transfer(_to, _value));
91   }
92 
93   function safeTransferFrom(
94     ERC20 _token,
95     address _from,
96     address _to,
97     uint256 _value
98   )
99     internal
100   {
101     require(_token.transferFrom(_from, _to, _value));
102   }
103 
104   function safeApprove(
105     ERC20 _token,
106     address _spender,
107     uint256 _value
108   )
109     internal
110   {
111     require(_token.approve(_spender, _value));
112   }
113 }
114 
115 contract MenloTokenTimelock is Ownable {
116   using SafeERC20 for ERC20Basic;
117 
118   // ERC20 basic token contract being held
119   ERC20Basic public token;
120 
121   mapping (address => uint256) public balance;
122 
123   // timestamp when token release is enabled
124   uint256 public releaseTime;
125 
126   constructor(ERC20Basic _token, uint256 _releaseTime) public {
127     require(_releaseTime > now, "Release time should be in the future");
128     token = _token;
129     releaseTime = _releaseTime;
130   }
131 
132   function deposit(address _beneficiary, uint256 _amount) public onlyOwner {
133     balance[_beneficiary] += _amount;
134   }
135 
136   /**
137    * @notice Transfers tokens held by timelock to beneficiary.
138    */
139   function release() public {
140     require(getBlockTimestamp() >= releaseTime, "Release time should be now or in the past");
141 
142     uint256 _amount = token.balanceOf(this);
143     require(_amount > 0, "Contract balance should be greater than zero");
144 
145     require(balance[msg.sender] > 0, "Sender balance should be greater than zero");
146     require(_amount >= balance[msg.sender], "Expected contract balance to be greater than or equal to sender balance");
147     token.transfer(msg.sender, balance[msg.sender]);
148     balance[msg.sender] = 0;
149   }
150 
151   function getBlockTimestamp() internal view returns (uint256) {
152     return block.timestamp;
153   }
154 }
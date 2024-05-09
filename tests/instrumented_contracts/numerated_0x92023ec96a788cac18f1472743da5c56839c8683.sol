1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   function totalSupply() public view returns (uint256);
90   function balanceOf(address who) public view returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: contracts/Withdrawals.sol
109 
110 contract Withdrawals is Claimable {
111     
112     /**
113     * @dev responsible for calling withdraw function
114     */
115     address public withdrawCreator;
116 
117     /**
118     * @dev if it's token transfer the tokenAddress will be 0x0000... 
119     * @param _destination receiver of token or eth
120     * @param _amount amount of ETH or Tokens
121     * @param _tokenAddress actual token address or 0x000.. in case of eth transfer
122     */
123     event AmountWithdrawEvent(
124     address _destination, 
125     uint _amount, 
126     address _tokenAddress 
127     );
128 
129     /**
130     * @dev fallback function only to enable ETH transfer
131     */
132     function() payable public {
133 
134     }
135 
136     /**
137     * @dev setter for the withdraw creator (responsible for calling withdraw function)
138     */
139     function setWithdrawCreator(address _withdrawCreator) public onlyOwner {
140         withdrawCreator = _withdrawCreator;
141     }
142 
143     /**
144     * @dev withdraw function to send token addresses or eth amounts to a list of receivers
145     * @param _destinations batch list of token or eth receivers
146     * @param _amounts batch list of values of eth or tokens
147     * @param _tokenAddresses what token to be transfered in case of eth just leave the 0x address
148     */
149     function withdraw(address[] _destinations, uint[] _amounts, address[] _tokenAddresses) public onlyOwnerOrWithdrawCreator {
150         require(_destinations.length == _amounts.length && _amounts.length == _tokenAddresses.length);
151         // itterate in receivers
152         for (uint i = 0; i < _destinations.length; i++) {
153             address tokenAddress = _tokenAddresses[i];
154             uint amount = _amounts[i];
155             address destination = _destinations[i];
156             // eth transfer
157             if (tokenAddress == address(0)) {
158                 if (this.balance < amount) {
159                     continue;
160                 }
161                 if (!destination.call.gas(70000).value(amount)()) {
162                     continue;
163                 }
164                 
165             }else {
166             // erc 20 transfer
167                 if (ERC20(tokenAddress).balanceOf(this) < amount) {
168                     continue;
169                 }
170                 ERC20(tokenAddress).transfer(destination, amount);
171             }
172             // emit event in both cases
173             emit AmountWithdrawEvent(destination, amount, tokenAddress);                
174         }
175 
176     }
177 
178     modifier onlyOwnerOrWithdrawCreator() {
179         require(msg.sender == withdrawCreator || msg.sender == owner);
180         _;
181     }
182 
183 }
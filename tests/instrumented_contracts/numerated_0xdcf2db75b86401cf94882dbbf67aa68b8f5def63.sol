1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
39 
40 /**
41  * @title SafeERC20
42  * @dev Wrappers around ERC20 operations that throw on failure.
43  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
44  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
45  */
46 library SafeERC20 {
47   function safeTransfer(
48     ERC20Basic _token,
49     address _to,
50     uint256 _value
51   )
52     internal
53   {
54     require(_token.transfer(_to, _value));
55   }
56 
57   function safeTransferFrom(
58     ERC20 _token,
59     address _from,
60     address _to,
61     uint256 _value
62   )
63     internal
64   {
65     require(_token.transferFrom(_from, _to, _value));
66   }
67 
68   function safeApprove(
69     ERC20 _token,
70     address _spender,
71     uint256 _value
72   )
73     internal
74   {
75     require(_token.approve(_spender, _value));
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
80 
81 /**
82  * @title TokenTimelock
83  * @dev TokenTimelock is a token holder contract that will allow a
84  * beneficiary to extract the tokens after a given release time
85  */
86 contract TokenTimelock {
87   using SafeERC20 for ERC20Basic;
88 
89   // ERC20 basic token contract being held
90   ERC20Basic public token;
91 
92   // beneficiary of tokens after they are released
93   address public beneficiary;
94 
95   // timestamp when token release is enabled
96   uint256 public releaseTime;
97 
98   constructor(
99     ERC20Basic _token,
100     address _beneficiary,
101     uint256 _releaseTime
102   )
103     public
104   {
105     // solium-disable-next-line security/no-block-members
106     require(_releaseTime > block.timestamp);
107     token = _token;
108     beneficiary = _beneficiary;
109     releaseTime = _releaseTime;
110   }
111 
112   /**
113    * @notice Transfers tokens held by timelock to beneficiary.
114    */
115   function release() public {
116     // solium-disable-next-line security/no-block-members
117     require(block.timestamp >= releaseTime);
118 
119     uint256 amount = token.balanceOf(address(this));
120     require(amount > 0);
121 
122     token.safeTransfer(beneficiary, amount);
123   }
124 }
125 
126 // File: contracts/ownership/Ownable.sol
127 
128 /**
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134   address public owner;
135 
136 
137   event OwnershipRenounced(address indexed previousOwner);
138   event OwnershipTransferred(
139     address indexed previousOwner,
140     address indexed newOwner
141   );
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   constructor() public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to relinquish control of the contract.
162    */
163   function renounceOwnership() public onlyOwner {
164     emit OwnershipRenounced(owner);
165     owner = address(0);
166   }
167 
168   /**
169    * @dev Allows the current owner to transfer control of the contract to a newOwner.
170    * @param _newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address _newOwner) public onlyOwner {
173     _transferOwnership(_newOwner);
174   }
175 
176   /**
177    * @dev Transfers control of the contract to a newOwner.
178    * @param _newOwner The address to transfer ownership to.
179    */
180   function _transferOwnership(address _newOwner) internal {
181     require(_newOwner != address(0));
182     emit OwnershipTransferred(owner, _newOwner);
183     owner = _newOwner;
184   }
185 }
186 
187 // File: contracts/BeneficiaryChangeableTimelock.sol
188 
189 contract BeneficiaryChangeableTimelock is TokenTimelock,  Ownable {
190 
191     event BeneficiaryChanged(address oldBeneficiary, address newBeneficiary);
192 
193 
194     function changeBeneficiary(address _beneficiary) public onlyOwner {
195         emit BeneficiaryChanged(beneficiary, _beneficiary);
196         beneficiary = _beneficiary;
197     }
198 
199     function release () public {
200         require (beneficiary != 0x0);
201         TokenTimelock.release();
202     }
203 }
204 
205 // File: contracts/Fr8NonUSRound2.sol
206 
207 contract Fr8NonUSRound2 is BeneficiaryChangeableTimelock {
208     // May 22 2019
209     constructor()
210     Ownable()
211     TokenTimelock(
212         ERC20Basic(0x8c39afDf7B17F12c553208555E51ab86E69C35aA),
213         0xAd1894E702719723F255C50767B37D9e54621f28,
214         1558483200
215     )
216     public {
217         owner = 0xAd1894E702719723F255C50767B37D9e54621f28;
218     }
219 }
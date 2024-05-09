1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 
120 
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20BasicInterface {
128     function totalSupply() public view returns (uint256);
129     function balanceOf(address who) public view returns (uint256);
130     function transfer(address to, uint256 value) public returns (bool);
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     uint8 public decimals;
134 }
135 
136 
137 contract BatchTransferWallet is Ownable {
138     using SafeMath for uint256;
139 
140     event LogWithdrawal(address indexed receiver, uint amount);
141 
142     /**
143     * @dev Send token to multiple address
144     * @param _investors The addresses of EOA that can receive token from this contract.
145     * @param _tokenAmounts The values of token are sent from this contract.
146     */
147     function batchTransfer(address _tokenAddress, address[] _investors, uint256[] _tokenAmounts) public {
148         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
149         require(_investors.length == _tokenAmounts.length && _investors.length != 0);
150 
151         uint decimalsForCalc = 10 ** uint256(token.decimals());
152 
153         for (uint i = 0; i < _investors.length; i++) {
154             require(_tokenAmounts[i] > 0 && _investors[i] != 0x0);
155             _tokenAmounts[i] = _tokenAmounts[i].mul(decimalsForCalc);
156             require(token.transfer(_investors[i], _tokenAmounts[i]));
157         }
158     }
159 
160     /**
161     * @dev Withdraw the amount of token that is remaining in this contract.
162     * @param _address The address of EOA that can receive token from this contract.
163     */
164     function withdraw(address _tokenAddress,address _address) public onlyOwner {
165         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
166         uint tokenBalanceOfContract = token.balanceOf(this);
167 
168         require(_address != address(0) && tokenBalanceOfContract > 0);
169         require(token.transfer(_address, tokenBalanceOfContract));
170         emit LogWithdrawal(_address, tokenBalanceOfContract);
171     }
172 
173     /**
174     * @dev return token balance this contract has
175     * @return _address token balance this contract has.
176     */
177     function balanceOfContract(address _tokenAddress,address _address) public view returns (uint) {
178         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
179         return token.balanceOf(_address);
180     }
181 }
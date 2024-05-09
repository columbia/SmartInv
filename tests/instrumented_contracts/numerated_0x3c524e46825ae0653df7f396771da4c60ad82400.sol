1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59 
60     address public owner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66 
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99     function totalSupply() public view returns (uint256);
100     function balanceOf(address who) public view returns (uint256);
101     function transfer(address to, uint256 value) public returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 // File: contracts/BlockportAirdropper.sol
106 
107 /**
108  * @title Airdropper
109  * @author C&B
110  */
111 contract BlockportAirdropper is Ownable {
112     using SafeMath for uint;
113 
114     ERC20Basic public token;
115     uint public multiplier;
116 
117     /// @dev Constructor
118     /// @param _tokenAddress Address of token contract
119     function BlockportAirdropper(address _tokenAddress, uint decimals) public {
120         setDecimals(decimals);
121 
122         token = ERC20Basic(_tokenAddress);
123     }
124 
125     /// @dev Adjust multiplier
126     /// @param decimals multiplier will be 10 raised to decimals
127     function setDecimals(uint decimals) public onlyOwner {
128         require(decimals <= 77);  // uint cap (10**77 < 2**256-1 < 10**78)
129 
130         multiplier = uint(10)**decimals;
131     }
132 
133     /// @dev Airdrops some tokens to some accounts.
134     /// @param dests List of account addresses.
135     /// @param values List of token amounts.
136     function airdrop(address[] dests, uint[] values) public onlyOwner {
137         require(dests.length == values.length);
138 
139         for (uint256 i = 0; i < dests.length; i++) {
140             token.transfer(dests[i], values[i].mul(multiplier));
141         }
142     }
143 
144     /// @dev Return all remaining tokens back to owner.
145     function returnTokens() public onlyOwner {
146         token.transfer(owner, token.balanceOf(this));
147     }
148 }
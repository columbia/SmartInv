1 pragma solidity ^0.4.24;
2 
3 // Azbit Airdrop
4 // More information: https://azbit.com/airdrop
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20     /**
21     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22     * account.
23     */
24     constructor() public {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28 
29     /**
30     * @return the address of the owner.
31     */
32     function owner() public view returns(address) {
33         return _owner;
34     }
35 
36     /**
37     * @dev Throws if called by any account other than the owner.
38     */
39     modifier onlyOwner() {
40         require(isOwner());
41         _;
42     }
43 
44     /**
45     * @return true if `msg.sender` is the owner of the contract.
46     */
47     function isOwner() public view returns(bool) {
48         return msg.sender == _owner;
49     }
50 
51     /**
52     * @dev Allows the current owner to relinquish control of the contract.
53     * @notice Renouncing to ownership will leave the contract without an owner.
54     * It will not be possible to call the functions with the `onlyOwner`
55     * modifier anymore.
56     */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63     * @dev Allows the current owner to transfer control of the contract to a newOwner.
64     * @param newOwner The address to transfer ownership to.
65     */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71     * @dev Transfers control of the contract to a newOwner.
72     * @param newOwner The address to transfer ownership to.
73     */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 interface IERC20 {
87   function totalSupply() external view returns (uint256);
88 
89   function balanceOf(address who) external view returns (uint256);
90 
91   function allowance(address owner, address spender)
92     external view returns (uint256);
93 
94   function transfer(address to, uint256 value) external returns (bool);
95 
96   function approve(address spender, uint256 value)
97     external returns (bool);
98 
99   function transferFrom(address from, address to, uint256 value)
100     external returns (bool);
101 
102   event Transfer(
103     address indexed from,
104     address indexed to,
105     uint256 value
106   );
107 
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 
116 /**
117  * @title AzbitTokenInterface
118  * @dev ERC20 Token Interface for Azbit project
119  */
120 
121 
122 contract AzbitTokenInterface is IERC20 {
123 
124     function releaseDate() external view returns (uint256);
125 
126 }
127 
128 
129 /**
130  * @title AzbitAirdrop
131  * @dev Airdrop Smart Contract of Azbit project
132  */
133 
134 
135 contract AzbitAirdrop is Ownable {
136 
137     // ** PUBLIC STATE VARIABLES **
138 
139     // Azbit token
140     AzbitTokenInterface public azbitToken;
141 
142 
143     // ** CONSTRUCTOR **
144 
145     /**
146     * @dev Constructor of AzbitAirdrop Contract
147     * @param tokenAddress address of AzbitToken
148     */
149     constructor(
150         address tokenAddress
151     )
152         public
153     {
154         _setToken(tokenAddress);
155     }
156 
157     // ** ONLY OWNER FUNCTIONS **
158 
159     /**
160     * @dev Send tokens to beneficiary by owner
161     * @param beneficiary The address for tokens withdrawal
162     * @param amount The token amount
163     */
164     function sendTokens(
165         address beneficiary,
166         uint256 amount
167     )
168         external
169         onlyOwner
170     {
171         _sendTokens(beneficiary, amount);
172     }
173 
174     /**
175     * @dev Send tokens to the array of beneficiaries  by owner
176     * @param beneficiaries The array of addresses for tokens withdrawal
177     * @param amount The token amount
178     */
179     function sendTokensArray(
180         address[] beneficiaries,
181         uint256 amount
182     )
183         external
184         onlyOwner
185     {
186         require(beneficiaries.length > 0, "Array length has to be greater than zero");
187 
188         for (uint256 i = 0; i < beneficiaries.length; i++) {
189             _sendTokens(beneficiaries[i], amount);
190         }
191     }
192 
193     // ** PUBLIC VIEW FUNCTIONS **
194 
195     /**
196     * @return total tokens of this contract.
197     */
198     function contractTokenBalance()
199         public
200         view
201         returns(uint256)
202     {
203         return azbitToken.balanceOf(this);
204     }
205 
206     // ** PRIVATE HELPER FUNCTIONS **
207 
208     // Helper: Set the address of Azbit Token
209     function _setToken(address tokenAddress)
210         internal
211     {
212         azbitToken = AzbitTokenInterface(tokenAddress);
213         require(contractTokenBalance() >= 0, "Token being added is not an ERC20 token");
214     }
215 
216     // Helper: send tokens to beneficiary
217     function _sendTokens(
218         address beneficiary,
219         uint256 amount
220     )
221         internal
222     {
223         // transfer tokens
224         require(azbitToken.transfer(beneficiary, amount), "Tokens were not transferred");
225     }
226 
227 }
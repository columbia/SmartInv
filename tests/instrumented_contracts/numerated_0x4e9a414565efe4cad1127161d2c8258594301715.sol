1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(
12         address indexed previousOwner,
13         address indexed newOwner
14     );
15 
16     /**
17     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18     * account.
19     */
20     constructor() public {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26     * @return the address of the owner.
27     */
28     function owner() public view returns(address) {
29         return _owner;
30     }
31 
32     /**
33     * @dev Throws if called by any account other than the owner.
34     */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41     * @return true if `msg.sender` is the owner of the contract.
42     */
43     function isOwner() public view returns(bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48     * @dev Allows the current owner to relinquish control of the contract.
49     * @notice Renouncing to ownership will leave the contract without an owner.
50     * It will not be possible to call the functions with the `onlyOwner`
51     * modifier anymore.
52     */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newOwner.
60     * @param newOwner The address to transfer ownership to.
61     */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67     * @dev Transfers control of the contract to a newOwner.
68     * @param newOwner The address to transfer ownership to.
69     */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82     function totalSupply() external view returns (uint256);
83 
84     function balanceOf(address who) external view returns (uint256);
85 
86     function allowance(address owner, address spender)
87     external view returns (uint256);
88 
89     function transfer(address to, uint256 value) external returns (bool);
90 
91     function approve(address spender, uint256 value)
92     external returns (bool);
93 
94     function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
96 
97     event Transfer(
98         address indexed from,
99         address indexed to,
100         uint256 value
101     );
102 
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 
111 /**
112  * @title AzbitTokenInterface
113  * @dev ERC20 Token Interface for Azbit project
114  */
115 contract AzbitTokenInterface is IERC20 {
116 
117     function releaseDate() external view returns (uint256);
118 
119 }
120 
121 
122 /**
123  * @title AzbitAirdrop
124  * @dev Airdrop Smart Contract of Azbit project
125  */
126 contract AzbitAirdrop is Ownable {
127 
128     // ** PUBLIC STATE VARIABLES **
129 
130     // Azbit token
131     AzbitTokenInterface public azbitToken;
132 
133 
134     // ** CONSTRUCTOR **
135 
136     /**
137     * @dev Constructor of AzbitAirdrop Contract
138     * @param tokenAddress address of AzbitToken
139     */
140     constructor(
141         address tokenAddress
142     ) 
143         public 
144     {
145         _setToken(tokenAddress);
146     }
147 
148 
149     // ** ONLY OWNER FUNCTIONS **
150 
151     /**
152     * @dev Send tokens to beneficiary by owner
153     * @param beneficiary The address for tokens withdrawal
154     * @param amount The token amount
155     */
156     function sendTokens(
157         address beneficiary,
158         uint256 amount
159     )
160         external
161         onlyOwner
162     {
163         _sendTokens(beneficiary, amount);
164     }
165 
166     /**
167     * @dev Send tokens to the array of beneficiaries  by owner
168     * @param beneficiaries The array of addresses for tokens withdrawal
169     * @param amounts The array of tokens amount
170     */
171     function sendTokensArray(
172         address[] beneficiaries, 
173         uint256[] amounts
174     )
175         external
176         onlyOwner
177     {
178         require(beneficiaries.length == amounts.length, "array lengths have to be equal");
179         require(beneficiaries.length > 0, "array lengths have to be greater than zero");
180 
181         for (uint256 i = 0; i < beneficiaries.length; i++) {
182             _sendTokens(beneficiaries[i], amounts[i]);
183         }
184     }
185 
186 
187     // ** PUBLIC VIEW FUNCTIONS **
188 
189     /**
190     * @return total tokens of this contract.
191     */
192     function contractTokenBalance()
193         public 
194         view 
195         returns(uint256) 
196     {
197         return azbitToken.balanceOf(this);
198     }
199 
200 
201     // ** PRIVATE HELPER FUNCTIONS **
202 
203     // Helper: Set the address of Azbit Token
204     function _setToken(address tokenAddress) 
205         internal 
206     {
207         azbitToken = AzbitTokenInterface(tokenAddress);
208         require(contractTokenBalance() >= 0, "The token being added is not ERC20 token");
209     }
210 
211     // Helper: send tokens to beneficiary
212     function _sendTokens(
213         address beneficiary, 
214         uint256 amount
215     )
216         internal
217     {
218         require(beneficiary != address(0), "Address cannot be 0x0");
219         require(amount > 0, "Amount cannot be zero");
220         require(amount <= contractTokenBalance(), "not enough tokens on this contract");
221 
222         // transfer tokens
223         require(azbitToken.transfer(beneficiary, amount), "tokens are not transferred");
224     }
225 }
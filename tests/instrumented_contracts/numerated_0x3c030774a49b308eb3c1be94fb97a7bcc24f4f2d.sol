1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipRenounced(address indexed previousOwner);
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87      * @dev Allows the current owner to relinquish control of the contract.
88      * @notice Renouncing to ownership will leave the contract without an owner.
89      * It will not be possible to call the functions with the `onlyOwner`
90      * modifier anymore.
91      */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipRenounced(owner);
94         owner = address(0);
95     }
96 
97     /**
98      * @dev Allows the current owner to transfer control of the contract to a newOwner.
99      * @param _newOwner The address to transfer ownership to.
100      */
101     function transferOwnership(address _newOwner) public onlyOwner {
102         _transferOwnership(_newOwner);
103     }
104 
105     /**
106      * @dev Transfers control of the contract to a newOwner.
107      * @param _newOwner The address to transfer ownership to.
108      */
109     function _transferOwnership(address _newOwner) internal {
110         require(_newOwner != address(0));
111         emit OwnershipTransferred(owner, _newOwner);
112         owner = _newOwner;
113     }
114 }
115 
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * See https://github.com/ethereum/EIPs/issues/179
121  */
122 contract ERC20Basic {
123     function totalSupply() public view returns (uint256);
124     function balanceOf(address who) public view returns (uint256);
125     function transfer(address to, uint256 value) public returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 
130 /**
131  * @title SafeERC20
132  * @dev Wrappers around ERC20 operations that throw on failure.
133  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
134  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
135  */
136 library SafeERC20 {
137     function safeTransfer(ERC20 token, address to, uint256 value) internal {
138         require(token.transfer(to, value));
139     }
140 
141     function safeTransferFrom(
142         ERC20 token,
143         address from,
144         address to,
145         uint256 value
146     )
147     internal
148     {
149         require(token.transferFrom(from, to, value));
150     }
151 
152     function safeApprove(ERC20 token, address spender, uint256 value) internal {
153         require(token.approve(spender, value));
154     }
155 }
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162     function allowance(address owner, address spender)
163     public view returns (uint256);
164 
165     function transferFrom(address from, address to, uint256 value)
166     public returns (bool);
167 
168     function approve(address spender, uint256 value) public returns (bool);
169     event Approval(
170         address indexed owner,
171         address indexed spender,
172         uint256 value
173     );
174 }
175 
176 
177 contract BulDex is Ownable {
178     using SafeERC20 for ERC20;
179 
180     mapping(address => bool) users;
181 
182     ERC20 public promoToken;
183     ERC20 public bullToken;
184 
185     uint public minVal = 365000000000000000000;
186     uint public bullAmount = 100000000000000000;
187 
188     constructor(address _promoToken, address _bullToken) public {
189         promoToken = ERC20(_promoToken);
190         bullToken = ERC20(_bullToken);
191     }
192 
193     function exchange(address _user, uint _val) public {
194         require(!users[_user]);
195         require(_val >= minVal);
196         users[_user] = true;
197         bullToken.safeTransfer(_user, bullAmount);
198     }
199 
200 
201 
202 
203     /// @notice This method can be used by the owner to extract mistakenly
204     ///  sent tokens to this contract.
205     /// @param _token The address of the token contract that you want to recover
206     ///  set to 0 in case you want to extract ether.
207     function claimTokens(address _token) external onlyOwner {
208         if (_token == 0x0) {
209             owner.transfer(address(this).balance);
210             return;
211         }
212 
213         ERC20 token = ERC20(_token);
214         uint balance = token.balanceOf(this);
215         token.transfer(owner, balance);
216     }
217 
218 }
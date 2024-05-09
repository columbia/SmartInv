1 pragma solidity  0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         require(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b > 0); // Solidity only automatically asserts when dividing by 0
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33         return c;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0);
38         return a % b;
39     }
40 }
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48     address private _owner;
49 
50     event OwnershipRenounced(address indexed previousOwner);
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() public {
57         _owner = msg.sender;
58     }
59 
60     function owner() public view returns(address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(isOwner());
66         _;
67     }
68 
69     function isOwner() public view returns(bool) {
70         return msg.sender == _owner;
71     }
72 
73     function transferOwnership(address newOwner) public onlyOwner {
74         _transferOwnership(newOwner);
75     }
76 
77     function _transferOwnership(address newOwner) internal {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 }
83 
84 
85 contract ERC20 {
86     uint public totalSupply;
87 
88     function balanceOf(address who) public view returns(uint);
89 
90     function allowance(address owner, address spender) public view returns(uint);
91 
92     function transfer(address to, uint value) public returns(bool ok);
93 
94     function transferFrom(address from, address to, uint value) public returns(bool ok);
95 
96     function approve(address spender, uint value) public returns(bool ok);
97 
98     event Transfer(address indexed from, address indexed to, uint value);
99     event Approval(address indexed owner, address indexed spender, uint value);
100 }
101 
102 
103 
104 
105 contract Bounties is Ownable {
106 
107     using SafeMath for uint;
108 
109     uint public totalTokensToClaim;
110     uint public totalBountyUsers;
111     uint public claimCount;
112     uint public totalClaimed;
113 
114 
115     mapping(address => bool) public claimed; // Tokens claimed by bounty members
116     Token public token;
117 
118     mapping(address => bool) public bountyUsers;
119     mapping(address => uint) public bountyUsersAmounts;
120 
121     constructor(Token _token) public {
122         require(_token != address(0));
123         token = Token(_token);
124     }
125 
126     event TokensClaimed(address backer, uint count);
127     event LogBountyUser(address user, uint num);
128     event LogBountyUserMultiple(uint num);
129 
130 
131     // @notice Specify address of token contract
132     // @param _tokenAddress {address} address of the token contract
133     // @return res {bool}
134     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
135         token = _tokenAddress;
136         return true;
137     }
138 
139     // @notice contract owner can add one user at a time to claim bounties
140     function addBountyUser(address _user, uint _amount) public onlyOwner() returns (bool) {
141 
142         require(_amount > 0);
143 
144         if (bountyUsers[_user] != true) {
145             bountyUsers[_user] = true;
146             bountyUsersAmounts[_user] = _amount;
147             totalBountyUsers++;
148             totalTokensToClaim += _amount;
149             emit LogBountyUser(_user, totalBountyUsers);
150         }
151         return true;
152     }
153 
154     // @notice contract owner can add multipl bounty users
155     function addBountyUserMultiple(address[] _users, uint[] _amount) external onlyOwner()  returns (bool) {
156 
157         for (uint i = 0; i < _users.length; ++i) {
158 
159             addBountyUser(_users[i], _amount[i]);
160         }
161         emit LogBountyUserMultiple(totalBountyUsers);
162         return true;
163     }
164 
165     // {fallback function}
166     // @notice It will call internal function which handels allocation of tokens to bounty users.
167     // bounty members can send 0 ether transaction to this contract to claim their tokens.
168     function () external payable {
169         claimTokens();
170     }
171 
172     // @notice
173     // This function will allow to transfer unclaimed tokens to another address.
174     function transferRemainingTokens(address _newAddress) external onlyOwner() returns (bool) {
175         require(_newAddress != address(0));
176         if (!token.transfer(_newAddress, token.balanceOf(this)))
177             revert(); // transfer tokens to admin account or multisig wallet
178         return true;
179     }
180 
181 
182     // @notice called to send tokens to bounty members by contract owner
183     // @param _backer {address} address of beneficiary
184     function claimTokensForUser(address _backer) external onlyOwner()  returns(bool) {
185         require(token != address(0));
186         require(bountyUsers[_backer]);
187         require(!claimed[_backer]);
188         claimCount++;
189         claimed[_backer] = true;
190         totalClaimed = totalClaimed.add(bountyUsersAmounts[_backer]);
191 
192         if (!token.transfer(_backer, bountyUsersAmounts[_backer]))
193             revert(); // send claimed tokens to contributor account
194 
195         emit TokensClaimed(_backer, bountyUsersAmounts[_backer]);
196         return true;
197     }
198 
199     // @notice bounty users can claim tokens
200     // Tokens also can be claimed by sending 0 eth transaction to this contract.
201     function claimTokens() public {
202 
203         require(token != address(0));
204         require(bountyUsers[msg.sender]);
205         require(!claimed[msg.sender]);
206         claimCount++;
207         claimed[msg.sender] = true;
208         totalClaimed = totalClaimed.add(bountyUsersAmounts[msg.sender]);
209 
210         if (!token.transfer(msg.sender, bountyUsersAmounts[msg.sender]))
211             revert(); // send claimed tokens to contributor account
212 
213         emit TokensClaimed(msg.sender, bountyUsersAmounts[msg.sender]);
214     }
215 
216 }
217 
218 // The token
219 contract Token is ERC20, Ownable {
220         function transfer(address _to, uint _value) public  returns(bool);
221 }
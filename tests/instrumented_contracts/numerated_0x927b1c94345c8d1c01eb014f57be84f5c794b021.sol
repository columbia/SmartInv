1 pragma solidity ^0.4.18;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: contracts/Owned.sol
36 
37 contract Owned {
38   event OwnerAddition(address indexed owner);
39 
40   event OwnerRemoval(address indexed owner);
41 
42   // owner address to enable admin functions
43   mapping (address => bool) public isOwner;
44 
45   address[] public owners;
46 
47   address public operator;
48 
49   modifier onlyOwner {
50 
51     require(isOwner[msg.sender]);
52     _;
53   }
54 
55   modifier onlyOperator {
56     require(msg.sender == operator);
57     _;
58   }
59 
60   function setOperator(address _operator) external onlyOwner {
61     require(_operator != address(0));
62     operator = _operator;
63   }
64 
65   function removeOwner(address _owner) public onlyOwner {
66     require(owners.length > 1);
67     isOwner[_owner] = false;
68     for (uint i = 0; i < owners.length - 1; i++) {
69       if (owners[i] == _owner) {
70         owners[i] = owners[SafeMath.sub(owners.length, 1)];
71         break;
72       }
73     }
74     owners.length = SafeMath.sub(owners.length, 1);
75     OwnerRemoval(_owner);
76   }
77 
78   function addOwner(address _owner) external onlyOwner {
79     require(_owner != address(0));
80     if(isOwner[_owner]) return;
81     isOwner[_owner] = true;
82     owners.push(_owner);
83     OwnerAddition(_owner);
84   }
85 
86   function setOwners(address[] _owners) internal {
87     for (uint i = 0; i < _owners.length; i++) {
88       require(_owners[i] != address(0));
89       isOwner[_owners[i]] = true;
90       OwnerAddition(_owners[i]);
91     }
92     owners = _owners;
93   }
94 
95   function getOwners() public constant returns (address[])  {
96     return owners;
97   }
98 
99 }
100 
101 // File: contracts/Token.sol
102 
103 // Abstract contract for the full ERC 20 Token standard
104 // https://github.com/ethereum/EIPs/issues/20
105 pragma solidity ^0.4.8;
106 
107 contract Token {
108     /* This is a slight change to the ERC20 base standard.
109     function totalSupply() constant returns (uint256 supply);
110     is replaced with:
111     uint256 public totalSupply;
112     This automatically creates a getter function for the totalSupply.
113     This is moved to the base contract since public getter functions are not
114     currently recognised as an implementation of the matching abstract
115     function by the compiler.
116     */
117     /// total amount of tokens
118     uint256 public totalSupply;
119 
120     /// @param _owner The address from which the balance will be retrieved
121     /// @return The balance
122     function balanceOf(address _owner) public constant returns (uint256 balance);
123 
124     /// @notice send `_value` token to `_to` from `msg.sender`
125     /// @param _to The address of the recipient
126     /// @param _value The amount of token to be transferred
127     /// @return Whether the transfer was successful or not
128     function transfer(address _to, uint256 _value) public returns (bool success);
129 
130     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
131     /// @param _from The address of the sender
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
136 
137     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
138     /// @param _spender The address of the account able to transfer the tokens
139     /// @param _value The amount of tokens to be approved for transfer
140     /// @return Whether the approval was successful or not
141     function approve(address _spender, uint256 _value) public returns (bool success);
142 
143     /// @param _owner The address of the account owning tokens
144     /// @param _spender The address of the account able to transfer the tokens
145     /// @return Amount of remaining tokens allowed to spent
146     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
147 
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 }
151 
152 // File: contracts/Leverjbounty.sol
153 
154 contract Leverjbounty is Owned {
155 
156   mapping (address => bool) public users;
157 
158   mapping (address => uint256) public social;
159 
160   uint256 public levPerUser;
161 
162   Token public token;
163 
164   bool public dropEnabled;
165 
166   event Redeemed(address user, uint tokens);
167 
168   modifier isDropEnabled{
169     require(dropEnabled);
170     _;
171   }
172 
173   function Leverjbounty(address[] owners, address _token, uint256 _levPerUser) public {
174     require(_token != address(0x0));
175     require(_levPerUser > 0);
176     setOwners(owners);
177     token = Token(_token);
178     levPerUser = _levPerUser;
179   }
180 
181   function addUsers(address[] _users) onlyOwner public {
182     require(_users.length > 0);
183     for (uint i = 0; i < _users.length; i++) {
184       users[_users[i]] = true;
185     }
186   }
187 
188   function addSocial(address[] _users, uint256[] _tokens) onlyOwner public {
189     require(_users.length > 0 && _users.length == _tokens.length);
190     for (uint i = 0; i < _users.length; i++) {
191       social[_users[i]] = _tokens[i];
192     }
193   }
194 
195   function removeUsers(address[] _users) onlyOwner public {
196     require(_users.length > 0);
197     for (uint i = 0; i < _users.length; i++) {
198       users[_users[i]] = false;
199     }
200   }
201 
202   function toggleDrop() onlyOwner public {
203     dropEnabled = !dropEnabled;
204   }
205 
206   function redeemTokens() isDropEnabled public {
207     uint256 balance = balanceOf(msg.sender);
208     require(balance > 0);
209     users[msg.sender] = false;
210     social[msg.sender] = 0;
211     token.transfer(msg.sender, balance);
212     Redeemed(msg.sender, balance);
213   }
214 
215   function balanceOf(address user) public constant returns (uint256) {
216     uint256 levs = social[user];
217     if (users[user]) levs += levPerUser;
218     return levs;
219   }
220 
221   function transferTokens(address _address, uint256 _amount) onlyOwner public {
222     token.transfer(_address, _amount);
223   }
224 }
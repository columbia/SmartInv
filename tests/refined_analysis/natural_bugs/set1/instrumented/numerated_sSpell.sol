1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
6 import "@boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol";
7 import "@boringcrypto/boring-solidity/contracts/Domain.sol";
8 import "@boringcrypto/boring-solidity/contracts/ERC20.sol";
9 import "@boringcrypto/boring-solidity/contracts/BoringBatchable.sol";
10 
11 
12 // Staking in sSpell inspired by Chef Nomi's SushiBar - MIT license (originally WTFPL)
13 // modified by BoringCrypto for DictatorDAO
14 
15 contract sSpell is IERC20, Domain {
16     using BoringMath for uint256;
17     using BoringMath128 for uint128;
18     using BoringERC20 for IERC20;
19 
20     string public constant symbol = "sSPELL";
21     string public constant name = "Staked Spell Tokens";
22     uint8 public constant decimals = 18;
23     uint256 public override totalSupply;
24     uint256 private constant LOCK_TIME = 24 hours;
25 
26     IERC20 public immutable token;
27 
28     constructor(IERC20 _token) public {
29         token = _token;
30     }
31 
32     struct User {
33         uint128 balance;
34         uint128 lockedUntil;
35     }
36 
37     /// @notice owner > balance mapping.
38     mapping(address => User) public users;
39     /// @notice owner > spender > allowance mapping.
40     mapping(address => mapping(address => uint256)) public override allowance;
41     /// @notice owner > nonce mapping. Used in `permit`.
42     mapping(address => uint256) public nonces;
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     function balanceOf(address user) public view override returns (uint256 balance) {
48         return users[user].balance;
49     }
50 
51     function _transfer(
52         address from,
53         address to,
54         uint256 shares
55     ) internal {
56         User memory fromUser = users[from];
57         require(block.timestamp >= fromUser.lockedUntil, "Locked");
58         if (shares != 0) {
59             require(fromUser.balance >= shares, "Low balance");
60             if (from != to) {
61                 require(to != address(0), "Zero address"); // Moved down so other failed calls safe some gas
62                 User memory toUser = users[to];
63                 users[from].balance = fromUser.balance - shares.to128(); // Underflow is checked
64                 users[to].balance = toUser.balance + shares.to128(); // Can't overflow because totalSupply would be greater than 2^128-1;
65             }
66         }
67         emit Transfer(from, to, shares);
68     }
69 
70     function _useAllowance(address from, uint256 shares) internal {
71         if (msg.sender == from) {
72             return;
73         }
74         uint256 spenderAllowance = allowance[from][msg.sender];
75         // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
76         if (spenderAllowance != type(uint256).max) {
77             require(spenderAllowance >= shares, "Low allowance");
78             allowance[from][msg.sender] = spenderAllowance - shares; // Underflow is checked
79         }
80     }
81 
82     /// @notice Transfers `shares` tokens from `msg.sender` to `to`.
83     /// @param to The address to move the tokens.
84     /// @param shares of the tokens to move.
85     /// @return (bool) Returns True if succeeded.
86     function transfer(address to, uint256 shares) public returns (bool) {
87         _transfer(msg.sender, to, shares);
88         return true;
89     }
90 
91     /// @notice Transfers `shares` tokens from `from` to `to`. Caller needs approval for `from`.
92     /// @param from Address to draw tokens from.
93     /// @param to The address to move the tokens.
94     /// @param shares The token shares to move.
95     /// @return (bool) Returns True if succeeded.
96     function transferFrom(
97         address from,
98         address to,
99         uint256 shares
100     ) public returns (bool) {
101         _useAllowance(from, shares);
102         _transfer(from, to, shares);
103         return true;
104     }
105 
106     /// @notice Approves `amount` from sender to be spend by `spender`.
107     /// @param spender Address of the party that can draw from msg.sender's account.
108     /// @param amount The maximum collective amount that `spender` can draw.
109     /// @return (bool) Returns True if approved.
110     function approve(address spender, uint256 amount) public override returns (bool) {
111         allowance[msg.sender][spender] = amount;
112         emit Approval(msg.sender, spender, amount);
113         return true;
114     }
115 
116     // solhint-disable-next-line func-name-mixedcase
117     function DOMAIN_SEPARATOR() external view returns (bytes32) {
118         return _domainSeparator();
119     }
120 
121     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
122     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
123 
124     /// @notice Approves `value` from `owner_` to be spend by `spender`.
125     /// @param owner_ Address of the owner.
126     /// @param spender The address of the spender that gets approved to draw from `owner_`.
127     /// @param value The maximum collective amount that `spender` can draw.
128     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
129     function permit(
130         address owner_,
131         address spender,
132         uint256 value,
133         uint256 deadline,
134         uint8 v,
135         bytes32 r,
136         bytes32 s
137     ) external override {
138         require(owner_ != address(0), "Zero owner");
139         require(block.timestamp < deadline, "Expired");
140         require(
141             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
142                 owner_,
143             "Invalid Sig"
144         );
145         allowance[owner_][spender] = value;
146         emit Approval(owner_, spender, value);
147     }
148 
149     /// math is ok, because amount, totalSupply and shares is always 0 <= amount <= 100.000.000 * 10^18
150     /// theoretically you can grow the amount/share ratio, but it's not practical and useless
151     function mint(uint256 amount) public returns (bool) {
152         require(msg.sender != address(0), "Zero address");
153         User memory user = users[msg.sender];
154 
155         uint256 totalTokens = token.balanceOf(address(this));
156         uint256 shares = totalSupply == 0 ? amount : (amount * totalSupply) / totalTokens;
157         user.balance += shares.to128();
158         user.lockedUntil = (block.timestamp + LOCK_TIME).to128();
159         users[msg.sender] = user;
160         totalSupply += shares;
161 
162         token.safeTransferFrom(msg.sender, address(this), amount);
163 
164         emit Transfer(address(0), msg.sender, shares);
165         return true;
166     }
167 
168     function _burn(
169         address from,
170         address to,
171         uint256 shares
172     ) internal {
173         require(to != address(0), "Zero address");
174         User memory user = users[from];
175         require(block.timestamp >= user.lockedUntil, "Locked");
176         uint256 amount = (shares * token.balanceOf(address(this))) / totalSupply;
177         users[from].balance = user.balance.sub(shares.to128()); // Must check underflow
178         totalSupply -= shares;
179 
180         token.safeTransfer(to, amount);
181 
182         emit Transfer(from, address(0), shares);
183     }
184 
185     function burn(address to, uint256 shares) public returns (bool) {
186         _burn(msg.sender, to, shares);
187         return true;
188     }
189 
190     function burnFrom(
191         address from,
192         address to,
193         uint256 shares
194     ) public returns (bool) {
195         _useAllowance(from, shares);
196         _burn(from, to, shares);
197         return true;
198     }
199 }
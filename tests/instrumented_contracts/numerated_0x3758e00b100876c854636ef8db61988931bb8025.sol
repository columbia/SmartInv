1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.2;
3 
4 // Contracts interaction interface
5 abstract contract IContract {
6     function balanceOf(address owner) external virtual returns (uint256);
7 
8     function transfer(address to, uint256 value) external virtual;
9 }
10 
11 // https://eips.ethereum.org/EIPS/eip-20
12 contract UniqToken {
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(
15         address indexed owner,
16         address indexed spender,
17         uint256 value
18     );
19 
20     mapping(address => uint256) private balances;
21     mapping(address => mapping(address => uint256)) private allowed;
22     uint256 public totalSupply;
23     address public owner;
24     address constant ZERO = address(0);
25 
26     modifier notZeroAddress(address a) {
27         require(a != ZERO, "Address 0x0 not allowed");
28         _;
29     }
30 
31     /*
32     NOTE:
33     The following variables are OPTIONAL vanities. One does not have to include them.
34     They allow one to customize the token contract & in no way influences the core functionality.
35     Some wallets/interfaces might not even bother to look at this information.
36     */
37     string public constant name = "Uniqly"; // Token name
38     string public constant symbol = "UNIQ"; // Token symbol
39     uint8 public constant decimals = 18; // Token decimals
40 
41     constructor(uint256 _initialAmount) {
42         balances[msg.sender] = _initialAmount; // Give the creator all initial tokens
43         totalSupply = _initialAmount; // Update total supply
44         owner = msg.sender; // Set owner
45         emit Transfer(ZERO, msg.sender, _initialAmount); // Emit event
46     }
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return success Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value)
53         external
54         notZeroAddress(_to)
55         returns (bool)
56     {
57         require(
58             balances[msg.sender] >= _value,
59             "ERC20 transfer: token balance too low"
60         );
61         balances[msg.sender] -= _value;
62         balances[_to] += _value;
63         emit Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
68     /// @param _from The address of the sender
69     /// @param _to The address of the recipient
70     /// @param _value The amount of token to be transferred
71     /// @return success Whether the transfer was successful or not
72     function transferFrom(
73         address _from,
74         address _to,
75         uint256 _value
76     ) external notZeroAddress(_to) returns (bool) {
77         uint256 _allowance = allowed[_from][msg.sender];
78         require(
79             balances[_from] >= _value && _allowance >= _value,
80             "ERC20 transferFrom: token balance or allowance too low"
81         );
82         balances[_from] -= _value;
83         if (_allowance < (2**256 - 1)) {
84             _approve(_from, msg.sender, _allowance - _value);
85         }
86         balances[_to] += _value;
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /// @param _owner The address from which the balance will be retrieved
92     /// @return balance the balance
93     function balanceOf(address _owner) external view returns (uint256) {
94         return balances[_owner];
95     }
96 
97     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
98     /// @param _spender The address of the account able to transfer the tokens
99     /// @param _value The amount of wei to be approved for transfer
100     /// @return success Whether the approval was successful or not
101     function approve(address _spender, uint256 _value)
102         external
103         notZeroAddress(_spender)
104         returns (bool)
105     {
106         _approve(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     function _approve(
111         address _owner,
112         address _spender,
113         uint256 _amount
114     ) internal {
115         allowed[_owner][_spender] = _amount;
116         emit Approval(_owner, _spender, _amount);
117     }
118 
119     /// @param _owner The address of the account owning tokens
120     /// @param _spender The address of the account able to transfer the tokens
121     /// @return remaining Amount of remaining tokens allowed to spent
122     function allowance(address _owner, address _spender)
123         external
124         view
125         returns (uint256)
126     {
127         return allowed[_owner][_spender];
128     }
129 
130     /**
131      * @dev Destroys `amount` tokens from the caller.
132      *
133      * See {_burn}.
134      */
135     function burn(uint256 amount) external {
136         _burn(msg.sender, amount);
137     }
138 
139     /**
140      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
141      * allowance.
142      *
143      * See {_burn} and {allowance}.
144      *
145      * Requirements:
146      *
147      * - the caller must have allowance for ``accounts``'s tokens of at least
148      * `amount`.
149      */
150     function burnFrom(address account, uint256 amount) external {
151         uint256 currentAllowance = allowed[account][msg.sender];
152         require(
153             currentAllowance >= amount,
154             "ERC20: burn amount exceeds allowance"
155         );
156         _approve(account, msg.sender, currentAllowance - amount);
157         _burn(account, amount);
158     }
159 
160     /**
161      * @dev Destroys `amount` tokens from `account`, reducing the
162      * total supply.
163      *
164      * Emits a {Transfer} event with `to` set to the zero address.
165      *
166      * Requirements:
167      *
168      * - `account` cannot be the zero address.
169      * - `account` must have at least `amount` tokens.
170      */
171     function _burn(address account, uint256 amount)
172         internal
173         notZeroAddress(account)
174     {
175         require(
176             balances[account] >= amount,
177             "ERC20: burn amount exceeds balance"
178         );
179         balances[account] -= amount;
180         totalSupply -= amount;
181 
182         emit Transfer(account, ZERO, amount);
183     }
184 
185     modifier onlyOwner {
186         require(msg.sender == owner, "Only for Owner");
187         _;
188     }
189 
190     // change ownership in two steps to be sure about owner address
191     address public newOwner;
192 
193     // only current owner can delegate new one
194     function giveOwnership(address _newOwner) external onlyOwner {
195         newOwner = _newOwner;
196     }
197 
198     // new owner need to accept ownership
199     function acceptOwnership() external {
200         require(msg.sender == newOwner, "You are not New Owner");
201         newOwner = address(0);
202         owner = msg.sender;
203     }
204 
205     /**
206     @dev Function to recover accidentally send ERC20 tokens
207     @param _token ERC20 token address
208     */
209     function rescueERC20(address _token) external onlyOwner {
210         uint256 amt = IContract(_token).balanceOf(address(this));
211         require(amt > 0, "Nothing to rescue");
212         IContract(_token).transfer(owner, amt);
213     }
214 
215     /**
216     @dev Function to recover any ETH send to contract
217     */
218     function rescueETH() external onlyOwner {
219         payable(owner).transfer(address(this).balance);
220     }
221 }
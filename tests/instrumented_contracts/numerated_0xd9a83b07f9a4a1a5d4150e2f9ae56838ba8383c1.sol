1 /* file: ./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol */
2 pragma solidity ^0.4.24;
3 
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 /* eof (./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol) */
56 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol */
57 pragma solidity ^0.4.24;
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * See https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address _who) public view returns (uint256);
68   function transfer(address _to, uint256 _value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol) */
73 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
74 pragma solidity ^0.4.24;
75 
76 
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address _owner, address _spender)
84     public view returns (uint256);
85 
86   function transferFrom(address _from, address _to, uint256 _value)
87     public returns (bool);
88 
89   function approve(address _spender, uint256 _value) public returns (bool);
90   event Approval(
91     address indexed owner,
92     address indexed spender,
93     uint256 value
94   );
95 }
96 
97 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
98 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol */
99 pragma solidity ^0.4.24;
100 
101 
102 
103 /**
104  * @title SafeERC20
105  * @dev Wrappers around ERC20 operations that throw on failure.
106  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
107  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
108  */
109 library SafeERC20 {
110   function safeTransfer(
111     ERC20Basic _token,
112     address _to,
113     uint256 _value
114   )
115     internal
116   {
117     require(_token.transfer(_to, _value));
118   }
119 
120   function safeTransferFrom(
121     ERC20 _token,
122     address _from,
123     address _to,
124     uint256 _value
125   )
126     internal
127   {
128     require(_token.transferFrom(_from, _to, _value));
129   }
130 
131   function safeApprove(
132     ERC20 _token,
133     address _spender,
134     uint256 _value
135   )
136     internal
137   {
138     require(_token.approve(_spender, _value));
139   }
140 }
141 
142 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol) */
143 /* file: ./contracts/vault/TokenVault.sol */
144 /**
145  * @title Token Vault contract.
146  * @dev Vault contract that will allow a beneficiary to release his/her #MIO tokens
147  * after the release time.
148  * @version 1.0
149  * @author Validity Labs AG <info@validitylabs.org>
150  */
151 
152 pragma solidity 0.4.24;
153 
154 
155 
156 contract TokenVault {
157     using SafeERC20 for ERC20;
158     using SafeMath for uint256;
159 
160     ERC20 public token;
161     uint256 public releaseTime;
162 
163     mapping(address => uint256) public lockedBalances;
164 
165     /**
166      * @param _token Address of the MioToken to be held.
167      * @param _releaseTime Epoch timestamp from which token release is enabled.
168      */
169     constructor(address _token, uint256 _releaseTime) public {
170         require(block.timestamp < _releaseTime);
171         token = ERC20(_token);
172         releaseTime = _releaseTime;
173     }
174 
175     /**
176      * @dev Allows the transfer of unlocked tokens to a set of beneficiaries' addresses.
177      * @param beneficiaries Array of beneficiaries' addresses that will receive the unlocked tokens.
178      */
179     function batchRelease(address[] beneficiaries) external {
180         uint256 length = beneficiaries.length;
181         for (uint256 i = 0; i < length; i++) {
182             releaseFor(beneficiaries[i]);
183         }
184     }
185 
186     /**
187      * @dev Allows the caller to transfer unlocked tokens to his/her account.
188      */
189     function release() public {
190         releaseFor(msg.sender);
191     }
192 
193     /**
194      * @dev Allows the caller to transfer unlocked tokens to the beneficiary's address.
195      * @param beneficiary The address that will receive the unlocked tokens.
196      */
197     function releaseFor(address beneficiary) public {
198         require(block.timestamp >= releaseTime);
199         uint256 amount = lockedBalances[beneficiary];
200         require(amount > 0);
201         lockedBalances[beneficiary] = 0;
202         token.safeTransfer(beneficiary, amount);
203     }
204 
205     /**
206      * @dev Allows a token holder to add to his/her balance of locked tokens.
207      * @param value Amount of tokens to be locked in this vault.
208      */
209     function addBalance(uint256 value) public {
210         addBalanceFor(msg.sender, value);
211     }
212 
213     /**
214      * @notice To be called by the account that holds Mio tokens. The caller needs to first approve this vault to
215      * transfer tokens on its behalf.
216      * The tokens to be locked will be transfered from the caller's account to this vault.
217      * The 'value' will be added to the balance of 'account' in this contract.
218      * @dev Allows a token holder to add to a another account's balance of locked tokens.
219      * @param account Address that will have a balance of locked tokens.
220      * @param value Amount of tokens to be locked in this vault.
221      */
222     function addBalanceFor(address account, uint256 value) public {
223         lockedBalances[account] = lockedBalances[account].add(value);
224         token.safeTransferFrom(msg.sender, address(this), value);
225     }
226 
227      /**
228     * @dev Gets the beneficiary's locked token balance
229     * @param account Address of the beneficiary
230     */
231     function getLockedBalance(address account) public view returns (uint256) {
232         return lockedBalances[account];
233     }
234 }
235 
236 
237 
238 /* eof (./contracts/vault/TokenVault.sol) */
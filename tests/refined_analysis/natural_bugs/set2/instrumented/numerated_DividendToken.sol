1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "../math/SafeMathUint.sol";
8 import "../math/SafeMathInt.sol";
9 
10 /// @title Dividend-Paying Token
11 /// @author Roger Wu (https://github.com/roger-wu)
12 /// @dev A mintable ERC20 token that allows anyone to pay and distribute a target token
13 ///  to token holders as dividends and allows token holders to withdraw their dividends.
14 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
15 contract DividendToken is ERC20 {
16   using SafeMath for uint256;
17   using SafeMathUint for uint256;
18   using SafeMathInt for int256;
19   using SafeERC20 for IERC20;
20   
21   IERC20 public target;
22 
23   // With `magnitude`, we can properly distribute dividends even if the amount of received target is small.
24   // For more discussion about choosing the value of `magnitude`,
25   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
26   uint256 constant internal magnitude = 2**128;
27 
28   uint256 internal magnifiedDividendPerShare;
29 
30   // About dividendCorrection:
31   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
32   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
33   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
34   //   `dividendOf(_user)` should not be changed,
35   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
36   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
37   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
38   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
39   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
40   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
41   mapping(address => int256) internal magnifiedDividendCorrections;
42   mapping(address => uint256) internal withdrawnDividends;
43 
44   constructor(IERC20 target_, string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) {
45     _setupDecimals(decimals_);
46     target = target_;
47   }
48 
49   /// @notice Distributes target to token holders as dividends.
50   /// @dev It reverts if the total supply of tokens is 0.
51   /// It emits the `DividendsDistributed` event if the amount of received target is greater than 0.
52   /// About undistributed target tokens:
53   ///   In each distribution, there is a small amount of target not distributed,
54   ///     the magnified amount of which is
55   ///     `(amount * magnitude) % totalSupply()`.
56   ///   With a well-chosen `magnitude`, the amount of undistributed target
57   ///     (de-magnified) in a distribution can be less than 1 wei.
58   ///   We can actually keep track of the undistributed target in a distribution
59   ///     and try to distribute it in the next distribution,
60   ///     but keeping track of such data on-chain costs much more than
61   ///     the saved target, so we don't do that.
62   function distributeDividends(uint amount) internal {
63     require(totalSupply() > 0);
64     require(amount > 0);
65 
66     magnifiedDividendPerShare = magnifiedDividendPerShare.add(
67       (amount).mul(magnitude) / totalSupply()
68     );
69 
70     target.safeTransferFrom(msg.sender, address(this), amount);
71 
72     emit DividendsDistributed(msg.sender, amount);
73   }
74 
75   /// @notice Withdraws the target distributed to the sender.
76   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn target is greater than 0.
77   function withdrawDividend(address user) internal {
78     uint256 _withdrawableDividend = withdrawableDividendOf(user);
79     if (_withdrawableDividend > 0) {
80       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
81       emit DividendWithdrawn(user, _withdrawableDividend);
82       target.safeTransfer(user, _withdrawableDividend);
83     }
84   }
85 
86   /// @notice View the amount of dividend in wei that an address can withdraw.
87   /// @param _owner The address of a token holder.
88   /// @return The amount of dividend in wei that `_owner` can withdraw.
89   function dividendOf(address _owner) public view returns(uint256) {
90     return withdrawableDividendOf(_owner);
91   }
92 
93   /// @notice View the amount of dividend in wei that an address can withdraw.
94   /// @param _owner The address of a token holder.
95   /// @return The amount of dividend in wei that `_owner` can withdraw.
96   function withdrawableDividendOf(address _owner) internal view returns(uint256) {
97     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
98   }
99 
100   /// @notice View the amount of dividend in wei that an address has withdrawn.
101   /// @param _owner The address of a token holder.
102   /// @return The amount of dividend in wei that `_owner` has withdrawn.
103   function withdrawnDividendOf(address _owner) public view returns(uint256) {
104     return withdrawnDividends[_owner];
105   }
106 
107 
108   /// @notice View the amount of dividend in wei that an address has earned in total.
109   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
110   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
111   /// @param _owner The address of a token holder.
112   /// @return The amount of dividend in wei that `_owner` has earned in total.
113   function accumulativeDividendOf(address _owner) public view returns(uint256) {
114     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
115       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
116   }
117 
118   /// @dev Internal function that transfer tokens from one address to another.
119   /// Update magnifiedDividendCorrections to keep dividends unchanged.
120   /// @param from The address to transfer from.
121   /// @param to The address to transfer to.
122   /// @param value The amount to be transferred.
123   function _transfer(address from, address to, uint256 value) internal override {
124     super._transfer(from, to, value);
125 
126     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
127     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
128     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
129   }
130 
131   /// @dev Internal function that mints tokens to an account.
132   /// Update magnifiedDividendCorrections to keep dividends unchanged.
133   /// @param account The account that will receive the created tokens.
134   /// @param value The amount that will be created.
135   function _mint(address account, uint256 value) internal override {
136     super._mint(account, value);
137 
138     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
139       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
140   }
141 
142   /// @dev Internal function that burns an amount of the token of a given account.
143   /// Update magnifiedDividendCorrections to keep dividends unchanged.
144   /// @param account The account whose tokens will be burnt.
145   /// @param value The amount that will be burnt.
146   function _burn(address account, uint256 value) internal override {
147     super._burn(account, value);
148 
149     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
150       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
151   }
152 
153   /// @dev This event MUST emit when target is distributed to token holders.
154   /// @param from The address which sends target to this contract.
155   /// @param weiAmount The amount of distributed target in wei.
156   event DividendsDistributed(
157     address indexed from,
158     uint256 weiAmount
159   );
160 
161   /// @dev This event MUST emit when an address withdraws their dividend.
162   /// @param to The address which withdraws target from this contract.
163   /// @param weiAmount The amount of withdrawn target in wei.
164   event DividendWithdrawn(
165     address indexed to,
166     uint256 weiAmount
167   );
168 }
1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../Constants.sol";
5 import "../../refs/CoreRef.sol";
6 import "../IPCVDeposit.sol";
7 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 
9 /// @title a PCV controller for moving a ratio of the total value in the PCV deposit
10 /// @author Fei Protocol
11 /// @notice v2 includes methods for transferring approved ERC20 balances and wrapping and unwrapping WETH in transit
12 contract RatioPCVControllerV2 is CoreRef {
13     using SafeERC20 for IERC20;
14 
15     /// @notice PCV controller constructor
16     /// @param _core Fei Core for reference
17     constructor(address _core) CoreRef(_core) {}
18 
19     receive() external payable {}
20 
21     /// @notice withdraw tokens from the input PCV deposit in basis points terms
22     /// @param pcvDeposit PCV deposit to withdraw from
23     /// @param to the address to send PCV to
24     /// @param basisPoints ratio of PCV to withdraw in basis points terms (1/10000)
25     function withdrawRatio(
26         IPCVDeposit pcvDeposit,
27         address to,
28         uint256 basisPoints
29     ) public onlyPCVController whenNotPaused {
30         _withdrawRatio(pcvDeposit, to, basisPoints);
31     }
32 
33     /// @notice withdraw WETH from the input PCV deposit in basis points terms and send as ETH
34     /// @param pcvDeposit PCV deposit to withdraw from
35     /// @param to the address to send PCV to
36     /// @param basisPoints ratio of PCV to withdraw in basis points terms (1/10000)
37     function withdrawRatioUnwrapWETH(
38         IPCVDeposit pcvDeposit,
39         address payable to,
40         uint256 basisPoints
41     ) public onlyPCVController whenNotPaused {
42         uint256 amount = _withdrawRatio(pcvDeposit, address(this), basisPoints);
43         _transferWETHAsETH(to, amount);
44     }
45 
46     /// @notice withdraw ETH from the input PCV deposit in basis points terms and send as WETH
47     /// @param pcvDeposit PCV deposit to withdraw from
48     /// @param to the address to send PCV to
49     /// @param basisPoints ratio of PCV to withdraw in basis points terms (1/10000)
50     function withdrawRatioWrapETH(
51         IPCVDeposit pcvDeposit,
52         address to,
53         uint256 basisPoints
54     ) public onlyPCVController whenNotPaused {
55         uint256 amount = _withdrawRatio(pcvDeposit, address(this), basisPoints);
56         _transferETHAsWETH(to, amount);
57     }
58 
59     /// @notice withdraw WETH from the input PCV deposit and send as ETH
60     /// @param pcvDeposit PCV deposit to withdraw from
61     /// @param to the address to send PCV to
62     /// @param amount raw amount of PCV to withdraw
63     function withdrawUnwrapWETH(
64         IPCVDeposit pcvDeposit,
65         address payable to,
66         uint256 amount
67     ) public onlyPCVController whenNotPaused {
68         pcvDeposit.withdraw(address(this), amount);
69         _transferWETHAsETH(to, amount);
70     }
71 
72     /// @notice withdraw ETH from the input PCV deposit and send as WETH
73     /// @param pcvDeposit PCV deposit to withdraw from
74     /// @param to the address to send PCV to
75     /// @param amount raw amount of PCV to withdraw
76     function withdrawWrapETH(
77         IPCVDeposit pcvDeposit,
78         address to,
79         uint256 amount
80     ) public onlyPCVController whenNotPaused {
81         pcvDeposit.withdraw(address(this), amount);
82         _transferETHAsWETH(to, amount);
83     }
84 
85     /// @notice withdraw a specific ERC20 token from the input PCV deposit in basis points terms
86     /// @param pcvDeposit PCV deposit to withdraw from
87     /// @param token the ERC20 token to withdraw
88     /// @param to the address to send tokens to
89     /// @param basisPoints ratio of PCV to withdraw in basis points terms (1/10000)
90     function withdrawRatioERC20(
91         IPCVDeposit pcvDeposit,
92         address token,
93         address to,
94         uint256 basisPoints
95     ) public onlyPCVController whenNotPaused {
96         require(basisPoints <= Constants.BASIS_POINTS_GRANULARITY, "RatioPCVController: basisPoints too high");
97         uint256 amount = (IERC20(token).balanceOf(address(pcvDeposit)) * basisPoints) /
98             Constants.BASIS_POINTS_GRANULARITY;
99         require(amount != 0, "RatioPCVController: no value to withdraw");
100 
101         pcvDeposit.withdrawERC20(token, to, amount);
102     }
103 
104     /// @notice transfer a specific ERC20 token from the input PCV deposit in basis points terms
105     /// @param from address to withdraw from
106     /// @param token the ERC20 token to withdraw
107     /// @param to the address to send tokens to
108     /// @param basisPoints ratio of PCV to withdraw in basis points terms (1/10000)
109     function transferFromRatio(
110         address from,
111         IERC20 token,
112         address to,
113         uint256 basisPoints
114     ) public onlyPCVController whenNotPaused {
115         require(basisPoints <= Constants.BASIS_POINTS_GRANULARITY, "RatioPCVController: basisPoints too high");
116         uint256 amount = (token.balanceOf(address(from)) * basisPoints) / Constants.BASIS_POINTS_GRANULARITY;
117         require(amount != 0, "RatioPCVController: no value to transfer");
118 
119         token.safeTransferFrom(from, to, amount);
120     }
121 
122     /// @notice transfer a specific ERC20 token from the input PCV deposit
123     /// @param from address to withdraw from
124     /// @param token the ERC20 token to withdraw
125     /// @param to the address to send tokens to
126     /// @param amount of tokens to transfer
127     function transferFrom(
128         address from,
129         IERC20 token,
130         address to,
131         uint256 amount
132     ) public onlyPCVController whenNotPaused {
133         require(amount != 0, "RatioPCVController: no value to transfer");
134 
135         token.safeTransferFrom(from, to, amount);
136     }
137 
138     /// @notice send ETH as WETH
139     /// @param to destination
140     function transferETHAsWETH(address to) public onlyPCVController whenNotPaused {
141         _transferETHAsWETH(to, address(this).balance);
142     }
143 
144     /// @notice send WETH as ETH
145     /// @param to destination
146     function transferWETHAsETH(address payable to) public onlyPCVController whenNotPaused {
147         _transferWETHAsETH(to, IERC20(address(Constants.WETH)).balanceOf(address(this)));
148     }
149 
150     /// @notice send away ERC20 held on this contract, to avoid having any stuck.
151     /// @param token sent
152     /// @param to destination
153     function transferERC20(IERC20 token, address to) public onlyPCVController whenNotPaused {
154         uint256 amount = token.balanceOf(address(this));
155         token.safeTransfer(to, amount);
156     }
157 
158     function _withdrawRatio(
159         IPCVDeposit pcvDeposit,
160         address to,
161         uint256 basisPoints
162     ) internal returns (uint256) {
163         require(basisPoints <= Constants.BASIS_POINTS_GRANULARITY, "RatioPCVController: basisPoints too high");
164         uint256 amount = (pcvDeposit.balance() * basisPoints) / Constants.BASIS_POINTS_GRANULARITY;
165         require(amount != 0, "RatioPCVController: no value to withdraw");
166 
167         pcvDeposit.withdraw(to, amount);
168 
169         return amount;
170     }
171 
172     function _transferETHAsWETH(address to, uint256 amount) internal {
173         Constants.WETH.deposit{value: amount}();
174 
175         Constants.WETH.transfer(to, amount);
176     }
177 
178     function _transferWETHAsETH(address payable to, uint256 amount) internal {
179         Constants.WETH.withdraw(amount);
180 
181         Address.sendValue(to, amount);
182     }
183 }

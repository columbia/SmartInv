1 pragma solidity ^0.8.4;
2 
3 import "./../PCVDeposit.sol";
4 import "./../../utils/Timed.sol";
5 
6 contract ERC20Dripper is PCVDeposit, Timed {
7     using Address for address payable;
8 
9     /// @notice event emitted when tokens are dripped
10     event Dripped(uint256 amount);
11 
12     /// @notice target address to drip tokens to
13     address public target;
14     /// @notice target token address to send
15     address public token;
16     /// @notice amount to drip after each window
17     uint256 public amountToDrip;
18 
19     /// @notice ERC20 PCV Dripper constructor
20     /// @param _core Fei Core for reference
21     /// @param _target address to drip to
22     /// @param _frequency frequency of dripping (note: not actually frequency, but 1/frequency, aka period)
23     /// @param _amountToDrip amount to drip on each drip
24     /// @param _token amount to drip on each drip
25     constructor(
26         address _core,
27         address _target,
28         uint256 _frequency,
29         uint256 _amountToDrip,
30         address _token
31     ) CoreRef(_core) Timed(_frequency) {
32         require(_target != address(0), "ERC20Dripper: invalid address");
33         require(_token != address(0), "ERC20Dripper: invalid token address");
34         require(_amountToDrip > 0, "ERC20Dripper: invalid drip amount");
35 
36         target = _target;
37         amountToDrip = _amountToDrip;
38         token = _token;
39 
40         // start timer
41         _initTimed();
42     }
43 
44     /// @notice drip ERC20 tokens to target
45     function drip() public virtual afterTime whenNotPaused {
46         // reset timer
47         _initTimed();
48 
49         // drip
50         _withdrawERC20(token, target, amountToDrip);
51         emit Dripped(amountToDrip);
52     }
53 
54     /// @notice withdraw tokens from the PCV allocation
55     /// @param amountUnderlying of tokens withdrawn
56     /// @param to the address to send PCV to
57     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController {
58         _withdrawERC20(address(token), to, amountUnderlying);
59     }
60 
61     /// @notice no-op
62     function deposit() external override {}
63 
64     /// @notice returns total balance of PCV in the Deposit
65     function balance() public view override returns (uint256) {
66         return IERC20(token).balanceOf(address(this));
67     }
68 
69     /// @notice display the related token of the balance reported
70     function balanceReportedIn() public view override returns (address) {
71         return token;
72     }
73 }

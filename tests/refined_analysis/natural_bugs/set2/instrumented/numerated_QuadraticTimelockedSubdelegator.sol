1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 import "./ITimelockedDelegator.sol";
6 import "./QuadraticTokenTimelock.sol";
7 
8 /// @title a proxy delegate contract for TRIBE
9 /// @author Fei Protocol
10 contract Delegatee is Ownable {
11     ITribe public tribe;
12 
13     /// @notice Delegatee constructor
14     /// @param _delegatee the address to delegate TRIBE to
15     /// @param _tribe the TRIBE token address
16     constructor(address _delegatee, address _tribe) {
17         tribe = ITribe(_tribe);
18         tribe.delegate(_delegatee);
19     }
20 
21     /// @notice send TRIBE back to timelock and selfdestruct
22     function withdraw() public onlyOwner {
23         ITribe _tribe = tribe;
24         uint256 balance = _tribe.balanceOf(address(this));
25         _tribe.transfer(owner(), balance);
26         selfdestruct(payable(owner()));
27     }
28 }
29 
30 /// @title a timelock for TRIBE allowing for sub-delegation
31 /// @author Fei Protocol
32 /// @notice allows the timelocked TRIBE to be delegated by the beneficiary while locked
33 contract QuadtraticTimelockedSubdelegator is ITimelockedDelegator, QuadraticTokenTimelock {
34     /// @notice associated delegate proxy contract for a delegatee
35     mapping(address => address) public override delegateContract;
36 
37     /// @notice associated delegated amount of TRIBE for a delegatee
38     /// @dev Using as source of truth to prevent accounting errors by transferring to Delegate contracts
39     mapping(address => uint256) public override delegateAmount;
40 
41     /// @notice the TRIBE token contract
42     ITribe public override tribe;
43 
44     /// @notice the total delegated amount of TRIBE
45     uint256 public override totalDelegated;
46 
47     /// @notice Delegatee constructor
48     /// @param _beneficiary default delegate, admin, and timelock beneficiary
49     /// @param _duration duration of the token timelock window
50     /// @param _tribe the TRIBE token address
51     /// @param _cliff the seconds before first claim is allowed
52     /// @param _startTime the initial time to use for timelock
53     /// @dev clawback admin needs to be 0 because clawbacks can be bricked by beneficiary
54     constructor(
55         address _beneficiary,
56         uint256 _duration,
57         address _tribe,
58         uint256 _cliff,
59         uint256 _startTime
60     ) QuadraticTokenTimelock(_beneficiary, _duration, _tribe, _cliff, address(0), _startTime) {
61         tribe = ITribe(_tribe);
62     }
63 
64     /// @notice delegate locked TRIBE to a delegatee
65     /// @param delegatee the target address to delegate to
66     /// @param amount the amount of TRIBE to delegate. Will increment existing delegated TRIBE
67     function delegate(address delegatee, uint256 amount) public override onlyBeneficiary {
68         require(amount <= _tribeBalance(), "TimelockedDelegator: Not enough Tribe");
69 
70         // withdraw and include an existing delegation
71         if (delegateContract[delegatee] != address(0)) {
72             amount = amount + undelegate(delegatee);
73         }
74 
75         ITribe _tribe = tribe;
76         address _delegateContract = address(new Delegatee(delegatee, address(_tribe)));
77         delegateContract[delegatee] = _delegateContract;
78 
79         delegateAmount[delegatee] = amount;
80         totalDelegated = totalDelegated + amount;
81 
82         _tribe.transfer(_delegateContract, amount);
83 
84         emit Delegate(delegatee, amount);
85     }
86 
87     /// @notice return delegated TRIBE to the timelock
88     /// @param delegatee the target address to undelegate from
89     /// @return the amount of TRIBE returned
90     function undelegate(address delegatee) public override onlyBeneficiary returns (uint256) {
91         address _delegateContract = delegateContract[delegatee];
92         require(_delegateContract != address(0), "TimelockedDelegator: Delegate contract nonexistent");
93 
94         Delegatee(_delegateContract).withdraw();
95 
96         uint256 amount = delegateAmount[delegatee];
97         totalDelegated = totalDelegated - amount;
98 
99         delegateContract[delegatee] = address(0);
100         delegateAmount[delegatee] = 0;
101 
102         emit Undelegate(delegatee, amount);
103 
104         return amount;
105     }
106 
107     /// @notice calculate total TRIBE held plus delegated
108     /// @dev used by LinearTokenTimelock to determine the released amount
109     function totalToken() public view override returns (uint256) {
110         return _tribeBalance() + totalDelegated;
111     }
112 
113     /// @notice accept beneficiary role over timelocked TRIBE. Delegates all held (non-subdelegated) tribe to beneficiary
114     function acceptBeneficiary() public override {
115         _setBeneficiary(msg.sender);
116         tribe.delegate(msg.sender);
117     }
118 
119     function _tribeBalance() internal view returns (uint256) {
120         return tribe.balanceOf(address(this));
121     }
122 }

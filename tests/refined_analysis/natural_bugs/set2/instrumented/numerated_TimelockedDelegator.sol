1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 import "./ITimelockedDelegator.sol";
6 import "./LinearTokenTimelock.sol";
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
33 contract TimelockedDelegator is ITimelockedDelegator, LinearTokenTimelock {
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
48     /// @param _tribe the TRIBE token address
49     /// @param _beneficiary default delegate, admin, and timelock beneficiary
50     /// @param _duration duration of the token timelock window
51     constructor(
52         address _tribe,
53         address _beneficiary,
54         uint256 _duration
55     ) LinearTokenTimelock(_beneficiary, _duration, _tribe, 0, address(0), 0) {
56         tribe = ITribe(_tribe);
57         tribe.delegate(_beneficiary);
58     }
59 
60     /// @notice delegate locked TRIBE to a delegatee
61     /// @param delegatee the target address to delegate to
62     /// @param amount the amount of TRIBE to delegate. Will increment existing delegated TRIBE
63     function delegate(address delegatee, uint256 amount) public override onlyBeneficiary {
64         require(amount <= _tribeBalance(), "TimelockedDelegator: Not enough Tribe");
65 
66         // withdraw and include an existing delegation
67         if (delegateContract[delegatee] != address(0)) {
68             amount = amount + undelegate(delegatee);
69         }
70 
71         ITribe _tribe = tribe;
72         address _delegateContract = address(new Delegatee(delegatee, address(_tribe)));
73         delegateContract[delegatee] = _delegateContract;
74 
75         delegateAmount[delegatee] = amount;
76         totalDelegated = totalDelegated + amount;
77 
78         _tribe.transfer(_delegateContract, amount);
79 
80         emit Delegate(delegatee, amount);
81     }
82 
83     /// @notice return delegated TRIBE to the timelock
84     /// @param delegatee the target address to undelegate from
85     /// @return the amount of TRIBE returned
86     function undelegate(address delegatee) public override onlyBeneficiary returns (uint256) {
87         address _delegateContract = delegateContract[delegatee];
88         require(_delegateContract != address(0), "TimelockedDelegator: Delegate contract nonexistent");
89 
90         Delegatee(_delegateContract).withdraw();
91 
92         uint256 amount = delegateAmount[delegatee];
93         totalDelegated = totalDelegated - amount;
94 
95         delegateContract[delegatee] = address(0);
96         delegateAmount[delegatee] = 0;
97 
98         emit Undelegate(delegatee, amount);
99 
100         return amount;
101     }
102 
103     /// @notice calculate total TRIBE held plus delegated
104     /// @dev used by LinearTokenTimelock to determine the released amount
105     function totalToken() public view override returns (uint256) {
106         return _tribeBalance() + totalDelegated;
107     }
108 
109     /// @notice accept beneficiary role over timelocked TRIBE. Delegates all held (non-subdelegated) tribe to beneficiary
110     function acceptBeneficiary() public override {
111         _setBeneficiary(msg.sender);
112         tribe.delegate(msg.sender);
113     }
114 
115     function _tribeBalance() internal view returns (uint256) {
116         return tribe.balanceOf(address(this));
117     }
118 }

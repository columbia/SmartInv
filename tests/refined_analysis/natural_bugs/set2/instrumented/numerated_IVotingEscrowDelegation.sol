1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
5 
6 interface IVotingEscrowDelegation is IERC721 {
7     // from IERC721:
8     // balanceOf, ownerOf, safeTransferFrom, transferFrom, approve, setApprovalForAll, getApproved, isApprovedForAll
9 
10     // IVotingEscrowDelegation specific:
11 
12     /// @notice Destroy a token
13     /// @dev Only callable by the token owner, their operator, or an approved account.
14     ///     Burning a token with a currently active boost, burns the boost.
15     /// @param _token_id The token to burn
16     function burn(uint256 _token_id) external;
17 
18     /// @notice Create a boost and delegate it to another account.
19     /// @dev Delegated boost can become negative, and requires active management, else
20     ///     the adjusted veCRV balance of the delegator's account will decrease until reaching 0
21     /// @param _delegator The account to delegate boost from
22     /// @param _receiver The account to receive the delegated boost
23     /// @param _percentage Since veCRV is a constantly decreasing asset, we use percentage to determine
24     ///     the amount of delegator's boost to delegate
25     /// @param _cancel_time A point in time before _expire_time in which the delegator or their operator
26     ///     can cancel the delegated boost
27     /// @param _expire_time The point in time, atleast a day in the future, at which the value of the boost
28     ///     will reach 0. After which the negative value is deducted from the delegator's account (and the
29     ///     receiver's received boost only) until it is cancelled. This value is rounded down to the nearest
30     ///     WEEK.
31     /// @param _id The token id, within the range of [0, 2 ** 96). Useful for contracts given operator status
32     ///     to have specific ranges.
33     function create_boost(
34         address _delegator,
35         address _receiver,
36         int256 _percentage,
37         uint256 _cancel_time,
38         uint256 _expire_time,
39         uint256 _id
40     ) external;
41 
42     /// @notice Extend the boost of an existing boost or expired boost
43     /// @dev The extension can not decrease the value of the boost. If there are
44     ///     any outstanding negative value boosts which cause the delegable boost
45     ///     of an account to be negative this call will revert
46     /// @param _token_id The token to extend the boost of
47     /// @param _percentage The percentage of delegable boost to delegate
48     ///     AFTER burning the token's current boost
49     /// @param _expire_time The new time at which the boost value will become
50     ///     0, and eventually negative. Must be greater than the previous expiry time,
51     ///     and atleast a WEEK from now, and less than the veCRV lock expiry of the
52     ///     delegator's account. This value is rounded down to the nearest WEEK.
53     function extend_boost(
54         uint256 _token_id,
55         int256 _percentage,
56         uint256 _expire_time,
57         uint256 _cancel_time
58     ) external;
59 
60     /// @notice Cancel an outstanding boost
61     /// @dev This does not burn the token, only the boost it represents. The owner
62     ///     of the token or their operator can cancel a boost at any time. The
63     ///     delegator or their operator can only cancel a token after the cancel
64     ///     time. Anyone can cancel the boost if the value of it is negative.
65     /// @param _token_id The token to cancel
66     function cancel_boost(uint256 _token_id) external;
67 
68     /// @notice Set or reaffirm the blacklist/whitelist status of a delegator for a receiver.
69     /// @dev Setting delegator as the ZERO_ADDRESS enables users to deactive delegations globally
70     ///     and enable the white list. The ability of a delegator to delegate to a receiver
71     ///     is determined by ~(grey_list[_receiver][ZERO_ADDRESS] ^ grey_list[_receiver][_delegator]).
72     /// @param _receiver The account which we will be updating it's list
73     /// @param _delegator The account to disallow/allow delegations from
74     /// @param _status Boolean of the status to set the _delegator account to
75     function set_delegation_status(
76         address _receiver,
77         address _delegator,
78         bool _status
79     ) external;
80 
81     /// @notice Adjusted veCRV balance after accounting for delegations and boosts
82     /// @dev If boosts/delegations have a negative value, they're effective value is 0
83     /// @param _account The account to query the adjusted balance of
84     function adjusted_balance_of(address _account) external view returns (uint256);
85 
86     /// @notice Query the total effective delegated boost value of an account.
87     /// @dev This value can be greater than the veCRV balance of
88     ///     an account if the account has outstanding negative
89     ///     value boosts.
90     /// @param _account The account to query
91     function delegated_boost(address _account) external view returns (uint256);
92 
93     /// @notice Query the total effective received boost value of an account
94     /// @dev This value can be 0, even with delegations which have a large value,
95     ///     if the account has any outstanding negative value boosts.
96     /// @param _account The account to query
97     function received_boost(address _account) external view returns (uint256);
98 
99     /// @notice Query the effective value of a boost
100     /// @dev The effective value of a boost is negative after it's expiration
101     ///     date.
102     /// @param _token_id The token id to query
103     function token_boost(uint256 _token_id) external view returns (int256);
104 
105     /// @notice Query the timestamp of a boost token's expiry
106     /// @dev The effective value of a boost is negative after it's expiration
107     ///     date.
108     /// @param _token_id The token id to query
109     function token_expiry(uint256 _token_id) external view returns (uint256);
110 
111     /// @notice Query the timestamp of a boost token's cancel time. This is
112     ///     the point at which the delegator can nullify the boost. A receiver
113     ///     can cancel a token at any point. Anyone can nullify a token's boost
114     ///     after it's expiration.
115     /// @param _token_id The token id to query
116     function token_cancel_time(uint256 _token_id) external view returns (uint256);
117 }

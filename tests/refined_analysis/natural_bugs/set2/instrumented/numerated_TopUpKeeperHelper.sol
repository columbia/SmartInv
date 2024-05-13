1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
5 
6 import "../../../interfaces/actions/topup/ITopUpAction.sol";
7 import "../../../interfaces/actions/topup/ITopUpKeeperHelper.sol";
8 import "../../../interfaces/actions/topup/ITopUpHandler.sol";
9 
10 /**
11  * This TopUp Keeper Helper.
12  * It is a utility contract to help create Backd TopUp Keepers.
13  * It exposes a view that allows the user to query a list of TopUp Positions that can be executed.
14  */
15 contract TopUpKeeperHelper is ITopUpKeeperHelper {
16     using EnumerableSet for EnumerableSet.AddressSet;
17 
18     ITopUpAction private immutable _topupAction;
19 
20     constructor(address topupAction_) {
21         _topupAction = ITopUpAction(topupAction_);
22     }
23 
24     /**
25      * @notice Gets a list of topup positions that can be executed.
26      * @dev Uses cursor pagination.
27      * @param cursor The cursor for pagination (should start at 0 for first call).
28      * @param howMany Maximum number of topups to return in this pagination request.
29      * @return topups List of topup positions that can be executed.
30      * @return nextCursor The cursor to use for the next pagination request.
31      */
32     function getExecutableTopups(uint256 cursor, uint256 howMany)
33         external
34         view
35         override
36         returns (TopupData[] memory topups, uint256 nextCursor)
37     {
38         TopupData[] memory executableTopups = new TopupData[](howMany);
39         uint256 topupsAdded;
40         while (true) {
41             (address[] memory users, ) = _topupAction.usersWithPositions(cursor, howMany);
42             if (users.length == 0) return (_shortenTopups(executableTopups, topupsAdded), 0);
43             for (uint256 i = 0; i < users.length; i++) {
44                 address user = users[i];
45                 ITopUpAction.RecordWithMeta[] memory positions = listPositions(user);
46                 for (uint256 j = 0; j < positions.length; j++) {
47                     ITopUpAction.RecordWithMeta memory position = positions[j];
48                     if (!_canExecute(user, position)) continue;
49                     executableTopups[topupsAdded] = _positionToTopup(user, position);
50                     topupsAdded++;
51                     uint256 offset = j == positions.length - 1 ? 1 : 0;
52                     if (topupsAdded == howMany) return (executableTopups, cursor + i + offset);
53                 }
54             }
55             cursor += howMany;
56         }
57     }
58 
59     /**
60      * @notice Check if the action can be executed for the positions
61      * of the given `keys`
62      * @param keys Unique keys to check for
63      * @return an array of boolean containing a result per input
64      */
65     function batchCanExecute(ITopUpAction.RecordKey[] calldata keys)
66         external
67         view
68         override
69         returns (bool[] memory)
70     {
71         bool[] memory results = new bool[](keys.length);
72         for (uint256 i = 0; i < keys.length; i++) {
73             ITopUpAction.RecordKey calldata key = keys[i];
74             results[i] = canExecute(key);
75         }
76         return results;
77     }
78 
79     /**
80      * @notice Get a list of all positions the `payer` has registered.
81      * @param payer Address to list position for.
82      * @return Records of all registered positions.
83      */
84     function listPositions(address payer)
85         public
86         view
87         override
88         returns (ITopUpAction.RecordWithMeta[] memory)
89     {
90         ITopUpAction.RecordMeta[] memory userRecordsMeta = _topupAction.getUserPositions(payer);
91         uint256 length = userRecordsMeta.length;
92         ITopUpAction.RecordWithMeta[] memory result = new ITopUpAction.RecordWithMeta[](length);
93         for (uint256 i = 0; i < length; i++) {
94             bytes32 account = userRecordsMeta[i].account;
95             bytes32 protocol = userRecordsMeta[i].protocol;
96             ITopUpAction.Record memory record = _topupAction.getPosition(payer, account, protocol);
97             result[i] = ITopUpAction.RecordWithMeta(account, protocol, record);
98         }
99         return result;
100     }
101 
102     /**
103      * @notice Check if action can be executed.
104      * @param key Unique key of the account to check for
105      * the key contains information about the payer, the account and the protocol
106      * @return `true` if action can be executed, else `false.
107      */
108     function canExecute(ITopUpAction.RecordKey memory key) public view override returns (bool) {
109         ITopUpAction.Record memory position = _topupAction.getPosition(
110             key.payer,
111             key.account,
112             key.protocol
113         );
114         if (position.threshold == 0 || position.totalTopUpAmount == 0) {
115             return false;
116         }
117         uint256 healthFactor = _topupAction.getHealthFactor(
118             key.protocol,
119             key.account,
120             position.extra
121         );
122         return healthFactor < position.threshold;
123     }
124 
125     /**
126      * @dev Returns if a position can be executed.
127      * @param user The user paying for the position.
128      * @param position The position record with metadata.
129      * @return 'true' if it can be executed, 'false' if not.
130      */
131     function _canExecute(address user, ITopUpAction.RecordWithMeta memory position)
132         private
133         view
134         returns (bool)
135     {
136         return canExecute(ITopUpAction.RecordKey(user, position.account, position.protocol));
137     }
138 
139     /**
140      * @dev Converts from RecordWithMeta struct to TopupData struct.
141      * @param user The user paying for the position.
142      * @param position The position record with metadata.
143      * @return The topup positions as a TopupData struct.
144      */
145     function _positionToTopup(address user, ITopUpAction.RecordWithMeta memory position)
146         private
147         pure
148         returns (TopupData memory)
149     {
150         return TopupData(user, position.account, position.protocol, position.record);
151     }
152 
153     /**
154      * @dev Shortens a list of topups by truncating it to a given length.
155      * @param topups The list of topups to shorten.
156      * @param length The length to trucate the list of topups to.
157      * @return The shortened list of topups.
158      */
159     function _shortenTopups(TopupData[] memory topups, uint256 length)
160         private
161         pure
162         returns (TopupData[] memory)
163     {
164         TopupData[] memory shortened = new TopupData[](length);
165         for (uint256 i = 0; i < length; i++) {
166             shortened[i] = topups[i];
167         }
168         return shortened;
169     }
170 }

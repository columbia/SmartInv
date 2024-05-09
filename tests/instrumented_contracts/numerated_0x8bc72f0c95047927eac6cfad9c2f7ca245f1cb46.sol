1 /*
2 
3  Copyright 2018 RigoBlock, Rigo Investment Sagl.
4 
5  Licensed under the Apache License, Version 2.0 (the "License");
6  you may not use this file except in compliance with the License.
7  You may obtain a copy of the License at
8 
9      http://www.apache.org/licenses/LICENSE-2.0
10 
11  Unless required by applicable law or agreed to in writing, software
12  distributed under the License is distributed on an "AS IS" BASIS,
13  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14  See the License for the specific language governing permissions and
15  limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.0;
20 
21 interface Token {
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     function transfer(address _to, uint256 _value) external returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
28     function approve(address _spender, uint256 _value) external returns (bool success);
29 
30     function balanceOf(address _who) external view returns (uint256);
31     function allowance(address _owner, address _spender) external view returns (uint256);
32 }
33 
34 /// @title Airdrop Helper - Allows to send GRGs to multiple users.
35 /// @author Gabriele Rigo - <gab@rigoblock.com>
36 // solhint-disable-next-line
37 contract HSendBatchTokens {
38     
39     mapping (address => mapping (address => bool)) private wasAirdropped;
40 
41     /*
42      * CORE FUNCTIONS
43      */
44     /// @dev Allows sending 1 ERC20 standard token with 18 decimals to a group of accounts.
45     /// @param _targets Array of target addresses.
46     /// @param _token Address of the target token.
47     /// @return Bool the transaction was successful.
48     function sendBatchTokens(
49         address[] calldata _targets,
50         address _token)
51         external
52         returns (bool success)
53     {
54         uint256 length = _targets.length;
55         uint256 amount = 1 * 10 ** 18;
56         Token token = Token(_token);
57         require(
58             token.transferFrom(
59                 msg.sender,
60                 address(this),
61                 (amount * length)
62             )
63         );
64         for (uint256 i = 0; i < length; i++) {
65             if (token.balanceOf(_targets[i]) > uint256(0)) continue;
66             if(wasAirdropped[_token][_targets[i]]) continue;
67             wasAirdropped[_token][_targets[i]] = true;
68             require(
69                 token.transfer(
70                     _targets[i],
71                     amount
72                 )
73             );
74         }
75         if (token.balanceOf(address(this)) > uint256(0)) {
76             require(
77                 token.transfer(
78                     msg.sender,
79                     token.balanceOf(address(this))
80                 )
81             );
82         }
83         success = true;
84     }
85     
86     /*
87      * EXTERNAL VIEW FUNCTIONS
88      */
89     /// @dev Returns wether an account has been airdropped a specific token.
90     /// @param _token Address of the target token.
91     /// @param _target Address of the target holder.
92     /// @return Bool the transaction was successful.
93     function hasReceivedAirdrop(
94         address _token,
95         address _target)
96         external
97         view
98         returns (bool)
99     {
100         return wasAirdropped[_token][_target];
101     }
102 }
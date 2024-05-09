1 pragma solidity ^0.4.11;
2 
3 
4 contract Consents {
5 
6     enum ActionType { REVOKE, CONSENT, NONE }
7 
8     struct Action {
9         ActionType actionType;
10         string inputDate;
11         string endDate;
12     }
13 
14     mapping (address => Action[]) consentHistoryByUser;
15 
16     function giveConsent(string inputDate, string endDate){
17         address userId = msg.sender;
18         consentHistoryByUser[userId].push(Action(ActionType.CONSENT, inputDate, endDate));
19     }
20 
21     function revokeConsent(string inputDate){
22         address userId = msg.sender;
23         consentHistoryByUser[userId].push(Action(ActionType.REVOKE, inputDate, ""));
24     }
25 
26     function getLastAction(address userId) returns (ActionType, string, string) {
27         Action[] memory history = consentHistoryByUser[userId];
28         if (history.length < 1) {
29             return (ActionType.NONE, "", "");
30         }
31         Action memory lastAction = history[history.length - 1];
32         return (lastAction.actionType, lastAction.inputDate, lastAction.endDate);
33     }
34 
35     function getActionHistorySize() returns (uint) {
36         address userId = msg.sender;
37         return consentHistoryByUser[userId].length;
38     }
39 
40     function getActionHistoryItem(uint index) returns (ActionType, string, string) {
41         address userId = msg.sender;
42         Action[] memory history = consentHistoryByUser[userId];
43         Action memory action = history[index];
44         return (action.actionType, action.inputDate, action.endDate);
45     }
46 
47     function strActionType(ActionType actionType) internal constant returns (string) {
48         if (actionType == ActionType.REVOKE) {
49             return "REVOCATION";
50         }
51         else if (actionType == ActionType.CONSENT) {
52             return "ACTIVATION";
53         }
54         else {
55             return "";
56         }
57     }
58 
59     function strConcatAction(string accumulator, Action action, bool firstItem) internal constant returns (string) {
60 
61         string memory str_separator = ", ";
62         string memory str_link = " ";
63 
64         bytes memory bytes_separator = bytes(str_separator);
65         bytes memory bytes_accumulator = bytes(accumulator);
66         bytes memory bytes_date = bytes(action.inputDate);
67         bytes memory bytes_link = bytes(str_link);
68         bytes memory bytes_action = bytes(strActionType(action.actionType));
69 
70         uint str_length = 0;
71         str_length += bytes_accumulator.length;
72         if (!firstItem) {
73             str_length += bytes_separator.length;
74         }
75         str_length += bytes_date.length;
76         str_length += bytes_link.length;
77         str_length += bytes_action.length;
78 
79         string memory result = new string(str_length);
80         bytes memory bytes_result = bytes(result);
81         uint k = 0;
82         uint i = 0;
83         for (i = 0; i < bytes_accumulator.length; i++) bytes_result[k++] = bytes_accumulator[i];
84         if (!firstItem) {
85             for (i = 0; i < bytes_separator.length; i++) bytes_result[k++] = bytes_separator[i];
86         }
87         for (i = 0; i < bytes_date.length; i++) bytes_result[k++] = bytes_date[i];
88         for (i = 0; i < bytes_link.length; i++) bytes_result[k++] = bytes_link[i];
89         for (i = 0; i < bytes_action.length; i++) bytes_result[k++] = bytes_action[i];
90         return string(bytes_result);
91 
92     }
93 
94     function Restitution_Historique_Transactions(address userId) public constant returns (string) {
95         Action[] memory history = consentHistoryByUser[userId];
96         string memory result = "";
97         if (history.length > 0) {
98             result = strConcatAction(result, history[0], true);
99             for (uint i = 1; i < history.length; i++) {
100                 result = strConcatAction(result, history[i], false);
101             }
102         }
103         return result;
104     }
105 }
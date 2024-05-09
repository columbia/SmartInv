1 pragma solidity ^0.4.19;
2 
3 // copyright contact@emontalliance.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     // address[] public moderators;
8     uint16 public totalModerators = 0;
9     mapping (address => bool) public moderators;
10     bool public isMaintaining = false;
11 
12     function BasicAccessControl() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     modifier onlyModerators() {
22         require(msg.sender == owner || moderators[msg.sender] == true);
23         _;
24     }
25 
26     modifier isActive {
27         require(!isMaintaining);
28         _;
29     }
30 
31     function ChangeOwner(address _newOwner) onlyOwner public {
32         if (_newOwner != address(0)) {
33             owner = _newOwner;
34         }
35     }
36 
37 
38     function AddModerator(address _newModerator) onlyOwner public {
39         if (moderators[_newModerator] == false) {
40             moderators[_newModerator] = true;
41             totalModerators += 1;
42         }
43     }
44     
45     function RemoveModerator(address _oldModerator) onlyOwner public {
46         if (moderators[_oldModerator] == true) {
47             moderators[_oldModerator] = false;
48             totalModerators -= 1;
49         }
50     }
51 
52     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
53         isMaintaining = _isMaintaining;
54     }
55 }
56 
57 contract EmontFrenzyInterface {
58      function addBonus(uint _pos, uint _amount) external;
59 }
60 
61 
62 contract EmontFrenzyTool is BasicAccessControl {
63     
64     // address
65     address public frenzyContract;
66     
67     function EmontFrenzyTool(address _frenzyContract) public {
68         frenzyContract = _frenzyContract;
69     }
70     
71     function updateContract(address _frenzyContract) onlyModerators external {
72         frenzyContract = _frenzyContract;
73     }
74     
75     function addBonus(uint _pos1, uint _pos2, uint _pos3, uint _pos4, uint _pos5, 
76         uint _pos6, uint _pos7, uint _pos8, uint _pos9, uint _pos10, uint _amount) onlyModerators external {
77             
78         EmontFrenzyInterface frenzy = EmontFrenzyInterface(frenzyContract);
79         
80         if (_pos1 > 0) {
81             frenzy.addBonus(_pos1, _amount);
82         }
83         if (_pos2 > 0) {
84             frenzy.addBonus(_pos2, _amount);
85         }
86         if (_pos3 > 0) {
87             frenzy.addBonus(_pos3, _amount);
88         }
89         if (_pos4 > 0) {
90             frenzy.addBonus(_pos4, _amount);
91         }
92         if (_pos5 > 0) {
93             frenzy.addBonus(_pos5, _amount);
94         }
95         if (_pos6 > 0) {
96             frenzy.addBonus(_pos6, _amount);
97         }
98         if (_pos7 > 0) {
99             frenzy.addBonus(_pos7, _amount);
100         }
101         if (_pos8 > 0) {
102             frenzy.addBonus(_pos8, _amount);
103         }
104         if (_pos9 > 0) {
105             frenzy.addBonus(_pos9, _amount);
106         }
107         if (_pos10 > 0) {
108             frenzy.addBonus(_pos10, _amount);
109         }
110     }
111 }
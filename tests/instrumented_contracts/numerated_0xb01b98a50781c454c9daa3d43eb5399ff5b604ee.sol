1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address owner;
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner() {
23         require(owner == msg.sender);
24         _;
25     }
26 }
27 
28 /**
29  * @title Secret Note
30  */
31 contract SecretNote is Ownable {
32     struct UserInfo {
33         mapping(bytes32 => bytes32) notes;
34         bytes32[] noteKeys;
35         uint256 index; // 1-based
36     }
37 
38     mapping(address => UserInfo) private registerUsers;
39     address[] private userIndex;
40 
41     event SecretNoteUpdated(address indexed _sender, bytes32 indexed _noteKey, bool _success);
42 
43     function SecretNote() public {
44     }
45 
46     function userExisted(address _user) public constant returns (bool) {
47         if (userIndex.length == 0) {
48             return false;
49         }
50 
51         return (userIndex[registerUsers[_user].index - 1] == _user);
52     }
53 
54     function () public payable {
55     }
56 
57     /**
58      * @dev for owner to withdraw ETH from donators if there is any.  :)
59      * @param _to The address where withdraw to
60      * @param _amount The amount of ETH to withdraw
61      */
62     function withdraw(address _to, uint _amount) public onlyOwner {
63         _to.transfer(_amount);
64     }
65 
66     /**
67      * @dev For owner to check registered user count
68      */
69     function getUserCount() public view onlyOwner returns (uint256) {
70         return userIndex.length;
71     }
72 
73     /**
74      * @dev For owner to check registered user address based on index
75      * @param _index Starting from 1
76      */
77     function getUserAddress(uint256 _index) public view onlyOwner returns (address) {
78         require(_index > 0);
79         return userIndex[_index - 1];
80     }
81 
82     /**
83      * @dev For user to get their own secret note
84      * @param _noteKey The key identifier for particular note
85      */
86     function getNote(bytes32 _noteKey) public view returns (bytes32) {
87         return registerUsers[msg.sender].notes[_noteKey];
88     }
89 
90     /**
91      * @dev For user to get their own secret note keys count
92      */
93     function getNoteKeysCount() public view returns (uint256) {
94         return registerUsers[msg.sender].noteKeys.length;
95     }
96 
97     /**
98      * @dev For user to get their own secret note key by index
99      * @param _index The 0-based index for particular note
100      */
101     function getNoteKeyByIndex(uint256 _index) public view returns (bytes32) {
102         return registerUsers[msg.sender].noteKeys[_index];
103     }
104 
105     /**
106      * @dev For user to update their own secret note
107      * @param _noteKey The key identifier for particular note
108      * @param _content The note path hash
109      */
110     function setNote(bytes32 _noteKey, bytes32 _content) public payable {
111         require(_noteKey != "");
112         require(_content != "");
113 
114         var userAddr = msg.sender;
115         var user = registerUsers[userAddr];
116         if (user.notes[_noteKey] == "") {
117             user.noteKeys.push(_noteKey);
118         }
119         user.notes[_noteKey] = _content;
120 
121         if (user.index == 0) {
122             userIndex.push(userAddr);
123             user.index = userIndex.length;
124         }
125         SecretNoteUpdated(userAddr, _noteKey, true);
126     }
127 
128     /**
129      * @dev Destroy one's account
130      */
131     function destroyAccount() public returns (bool) {
132         var userAddr = msg.sender;
133         require(userExisted(userAddr));
134 
135         uint delIndex = registerUsers[userAddr].index;
136         address userToMove = userIndex[userIndex.length - 1];
137 
138         if (userToMove == userAddr) {
139             delete(registerUsers[userAddr]);
140             userIndex.length = 0;
141             return true;
142         }
143 
144         userIndex[delIndex - 1] = userToMove;
145         registerUsers[userToMove].index = delIndex;
146         userIndex.length--;
147         delete(registerUsers[userAddr]);
148         return true;
149     }
150 }
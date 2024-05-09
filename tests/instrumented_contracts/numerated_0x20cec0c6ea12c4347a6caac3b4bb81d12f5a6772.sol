1 pragma solidity 0.4.24;
2 library SafeMath {
3     /* Internals */
4     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
5         c = a + b;
6         assert( c >= a );
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {
10         c = a - b;
11         assert( c <= a );
12         return c;
13     }
14     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
15         c = a * b;
16         assert( c == 0 || c / a == b );
17         return c;
18     }
19     function div(uint256 a, uint256 b) internal pure returns(uint256) {
20         return a / b;
21     }
22     function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {
23         c = a ** b;
24         assert( c % a == 0 );
25         return a ** b;
26     }
27 }
28 contract Token {
29     /* Externals */
30     function transfer(address _to, uint256 _amount) external returns (bool _success) {}
31     function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {}
32     /* Constants */
33     function balanceOf(address _owner) public view returns (uint256 _balance) {}
34 }
35 contract MultiOwnerWallet {
36     /* Declarations */
37     using SafeMath for uint256;
38     /* Structures */
39     struct action_s {
40         address origin;
41         uint256 voteCounter;
42         uint256 uid;
43         mapping(address => uint256) voters;
44     }
45     /* Variables */
46     mapping(address => bool) public owners;
47     mapping(bytes32 => action_s) public actions;
48     uint256 public actionVotedRate;
49     uint256 public ownerCounter;
50     uint256 public voteUID;
51     Token public token;
52     /* Constructor */
53     constructor(address _tokenAddress, uint256 _actionVotedRate, address[] _owners) public {
54         uint256 i;
55         token = Token(_tokenAddress);
56         require( _actionVotedRate <= 100 );
57         actionVotedRate = _actionVotedRate;
58         for ( i=0 ; i<_owners.length ; i++ ) {
59             owners[_owners[i]] = true;
60         }
61         ownerCounter = _owners.length;
62     }
63     /* Fallback */
64     function () public {
65         revert();
66     }
67     /* Externals */
68     function transfer(address _to, uint256 _amount) external returns (bool _success) {
69         bytes32 _hash;
70         bool    _subResult;
71         _hash = keccak256(address(token), 'transfer', _to, _amount);
72         if ( actions[_hash].origin == 0x00 ) {
73             emit newTransferAction(_hash, _to, _amount, msg.sender);
74         }
75         if ( doVote(_hash) ) {
76             _subResult = token.transfer(_to, _amount);
77             require( _subResult );
78         }
79         return true;
80     }
81     function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {
82         bytes32 _hash;
83         bool    _subResult;
84         _hash = keccak256(address(token), 'bulkTransfer', _to, _amount);
85         if ( actions[_hash].origin == 0x00 ) {
86             emit newBulkTransferAction(_hash, _to, _amount, msg.sender);
87         }
88         if ( doVote(_hash) ) {
89             _subResult = token.bulkTransfer(_to, _amount);
90             require( _subResult );
91         }
92         return true;
93     }
94     function changeTokenAddress(address _tokenAddress) external returns (bool _success) {
95         bytes32 _hash;
96         _hash = keccak256(address(token), 'changeTokenAddress', _tokenAddress);
97         if ( actions[_hash].origin == 0x00 ) {
98             emit newChangeTokenAddressAction(_hash, _tokenAddress, msg.sender);
99         }
100         if ( doVote(_hash) ) {
101             token = Token(_tokenAddress);
102         }
103         return true;
104     }
105     function addNewOwner(address _owner) external returns (bool _success) {
106         bytes32 _hash;
107         require( ! owners[_owner] );
108         _hash = keccak256(address(token), 'addNewOwner', _owner);
109         if ( actions[_hash].origin == 0x00 ) {
110             emit newAddNewOwnerAction(_hash, _owner, msg.sender);
111         }
112         if ( doVote(_hash) ) {
113             ownerCounter = ownerCounter.add(1);
114             owners[_owner] = true;
115         }
116         return true;
117     }
118     function delOwner(address _owner) external returns (bool _success) {
119         bytes32 _hash;
120         require( owners[_owner] );
121         _hash = keccak256(address(token), 'delOwner', _owner);
122         if ( actions[_hash].origin == 0x00 ) {
123             emit newDelOwnerAction(_hash, _owner, msg.sender);
124         }
125         if ( doVote(_hash) ) {
126             ownerCounter = ownerCounter.sub(1);
127             owners[_owner] = false;
128         }
129         return true;
130     }
131     /* Constants */
132     function selfBalance() public view returns (uint256 _balance) {
133         return token.balanceOf(address(this));
134     }
135     function balanceOf(address _owner) public view returns (uint256 _balance) {
136         return token.balanceOf(_owner);
137     }
138     function hasVoted(bytes32 _hash, address _owner) public view returns (bool _voted) {
139         return actions[_hash].origin != 0x00 && actions[_hash].voters[_owner] == actions[_hash].uid;
140     }
141     /* Internals */
142     function doVote(bytes32 _hash) internal returns (bool _voted) {
143         require( owners[msg.sender] );
144         if ( actions[_hash].origin == 0x00 ) {
145             voteUID = voteUID.add(1);
146             actions[_hash].origin = msg.sender;
147             actions[_hash].voteCounter = 1;
148             actions[_hash].uid = voteUID;
149         } else if ( ( actions[_hash].voters[msg.sender] != actions[_hash].uid ) && actions[_hash].origin != msg.sender ) {
150             actions[_hash].voters[msg.sender] = actions[_hash].uid;
151             actions[_hash].voteCounter = actions[_hash].voteCounter.add(1);
152             emit vote(_hash, msg.sender);
153         }
154         if ( actions[_hash].voteCounter.mul(100).div(ownerCounter) >= actionVotedRate ) {
155             _voted = true;
156             emit votedAction(_hash);
157             delete actions[_hash];
158         }
159     }
160     /* Events */
161     event newTransferAction(bytes32 _hash, address _to, uint256 _amount, address _origin);
162     event newBulkTransferAction(bytes32 _hash, address[] _to, uint256[] _amount, address _origin);
163     event newChangeTokenAddressAction(bytes32 _hash, address _tokenAddress, address _origin);
164     event newAddNewOwnerAction(bytes32 _hash, address _owner, address _origin);
165     event newDelOwnerAction(bytes32 _hash, address _owner, address _origin);
166     event vote(bytes32 _hash, address _voter);
167     event votedAction(bytes32 _hash);
168 }
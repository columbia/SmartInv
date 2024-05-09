1 pragma solidity ^0.4.20;
2 
3 contract Nine {
4   address public God;
5 
6   function Nine() public {
7     God = msg.sender;
8   }
9 
10   modifier onlyGod() {
11     require(msg.sender == God);
12     _;
13   }
14 
15   function destroyTheUniverse () private {
16     selfdestruct(God);
17   }
18 
19   address public agentAddress;
20   uint256 public nameValue = 10 finney;
21 
22   function setAgent(address _newAgent) external onlyGod {
23     require(_newAgent != address(0));
24     agentAddress = _newAgent;
25   }
26 
27   modifier onlyAgent() {
28     require(msg.sender == agentAddress);
29     _;
30   }
31 
32   function withdrawBalance(uint256 amount) external onlyAgent {
33     msg.sender.transfer(amount <= 0 ? address(this).balance : amount);
34   }
35 
36   function setNameValue(uint256 val) external onlyAgent {
37     nameValue = val;
38   }
39 
40 
41   string public constant name = "TheNineBillionNamesOfGod";
42   string public constant symbol = "NOG";
43   uint256 public constant totalSupply = 9000000000;
44 
45   struct Name {
46     uint64 recordTime;
47   }
48 
49 
50   Name[] names;
51 
52   mapping (uint256 => address) public nameIndexToOwner;
53 
54   mapping (address => uint256) ownershipTokenCount;
55 
56   event Transfer(address from, address to, uint256 tokenId);
57   event Record(address owner, uint256 nameId);
58 
59   function _transfer(address _from, address _to, uint256 _tokenId) internal {
60     ownershipTokenCount[_to]++;
61 
62     nameIndexToOwner[_tokenId] = _to;
63 
64     if (_from != address(0)) {
65       ownershipTokenCount[_from]--;
66     }
67 
68     emit Transfer(_from, _to, _tokenId);
69   }
70 
71   function _recordName(address _owner)
72     internal
73     returns (uint)
74   {
75     Name memory _name = Name({recordTime: uint64(now)});
76     uint256 newNameId = names.push(_name) - 1;
77 
78     require(newNameId == uint256(uint32(newNameId)));
79 
80     emit Record(_owner,newNameId);
81 
82     _transfer(0, _owner, newNameId);
83 
84     if (names.length == totalSupply) {
85       destroyTheUniverse();
86     }
87 
88     return newNameId;
89   }
90 
91   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
92     return nameIndexToOwner[_tokenId] == _claimant;
93   }
94 
95   function balanceOf(address _owner) public view returns (uint256 count) {
96     return ownershipTokenCount[_owner];
97   }
98 
99 
100   function transfer(
101                     address _to,
102                     uint256 _tokenId
103                     )
104     external
105   {
106     require(_to != address(0));
107 
108     require(_to != address(this));
109 
110     require(_owns(msg.sender, _tokenId));
111 
112     _transfer(msg.sender, _to, _tokenId);
113   }
114 
115 
116   function recordNameCount() public view returns (uint) {
117     return names.length;
118   }
119 
120   function ownerOf(uint256 _tokenId)
121     external
122     view
123     returns (address owner)
124   {
125     owner = nameIndexToOwner[_tokenId];
126 
127     require(owner != address(0));
128   }
129 
130   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
131     uint256 tokenCount = balanceOf(_owner);
132 
133     if (tokenCount == 0) {
134       return new uint256[](0);
135     } else {
136       uint256[] memory result = new uint256[](tokenCount);
137       uint256 totalRecord = recordNameCount();
138       uint256 resultIndex = 0;
139 
140       uint256 nId;
141 
142       for (nId = 1; nId < totalRecord; nId++) {
143         if (nameIndexToOwner[nId] == _owner) {
144           result[resultIndex] = nId;
145           resultIndex++;
146         }
147       }
148 
149       return result;
150     }
151   }
152 
153 
154   function getName(uint256 _id)
155     external
156     view
157     returns (uint256 recordTime) {
158     recordTime = uint256(names[_id].recordTime);
159   }
160 
161   function tryToRecord(address _sender, uint256 _value) internal {
162     uint times = _value / nameValue;
163     for (uint i = 0; i < times; i++) {
164       _recordName(_sender);
165     }
166   }
167 
168   function recordName() external payable {
169     tryToRecord(msg.sender, msg.value);
170   }
171 
172   function() external payable {
173     tryToRecord(msg.sender, msg.value);
174   }
175 }
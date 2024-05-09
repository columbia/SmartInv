1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: contracts/MTVote.sol
65 
66 contract TVCrowdsale {
67     uint256 public currentRate;
68     function buyTokens(address _beneficiary) public payable;
69 }
70 
71 contract TVToken {
72     function transfer(address _to, uint256 _value) public returns (bool);
73     function safeTransfer(address _to, uint256 _value, bytes _data) public;
74 }
75 
76 
77 contract MTVote is Ownable {
78     address public TVTokenAddress;
79     address public TVCrowdsaleAddress;
80     address public manager;
81     address public wallet;
82     address internal checkAndBuySender;
83     bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
84     bool pause = false;
85 
86     mapping(uint => uint) public targets;
87     uint public targetIdsSize = 0;
88     uint[] public targetIds;
89 
90     modifier onlyOwnerOrManager() {
91         require(msg.sender == owner || manager == msg.sender);
92         _;
93     }
94 
95     event TokenReceived(address from, uint value, uint targetId);
96     event changeAndVoteEvent(address voter, uint rate, uint value, uint targetId);
97 
98     constructor(
99         address _TVTokenAddress,
100         address _TVCrowdsaleAddress,
101         address _manager,
102         address _wallet) public {
103 
104         manager = _manager;
105         wallet = _wallet;
106         TVTokenAddress = _TVTokenAddress;
107         TVCrowdsaleAddress = _TVCrowdsaleAddress;
108     }
109 
110     function changeAndVote(uint targetId) public payable {
111         require(!pause);
112         uint rate = TVCrowdsale(TVCrowdsaleAddress).currentRate();
113 
114         TVCrowdsale(TVCrowdsaleAddress).buyTokens.value(msg.value)(this);
115         bytes memory data = toBytes(targetId);
116         checkAndBuySender = msg.sender;
117         TVToken(TVTokenAddress).safeTransfer(this, msg.value * rate, data);
118 
119         emit changeAndVoteEvent(msg.sender, rate, msg.value, targetId);
120     }
121 
122     function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4) {
123         require(msg.sender == TVTokenAddress);
124         require(!pause);
125         uint targetId = uint256(convertBytesToBytes32(_data));
126         targets[targetId] += _value;
127         TVToken(TVTokenAddress).transfer(wallet, _value);
128         _from = this == _from ? checkAndBuySender : _from;
129         checkAndBuySender = address(0);
130 
131         bool inList = false;
132         for (uint i = 0; i < targetIdsSize; i++) {
133             if (targetIds[i] == targetId) {
134                 inList = true;
135             }
136         }
137         if (!inList) {
138             targetIds.push(targetId);
139             targetIdsSize++;
140         }
141 
142         emit TokenReceived(_from, _value, targetId);
143         return TOKEN_RECEIVED;
144     }
145 
146     function setPause(bool isPaused) public onlyOwnerOrManager {
147         pause = isPaused;
148     }
149 
150     function clear() public onlyOwnerOrManager {
151         targetIdsSize = 0;
152     }
153 
154     function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
155         TVTokenAddress = newAddress;
156     }
157 
158     function changeTVCrowdsaleAddress(address newAddress) public onlyOwnerOrManager {
159         TVCrowdsaleAddress = newAddress;
160     }
161 
162     function setManager(address _manager) public onlyOwner {
163         manager = _manager;
164     }
165 
166     function convertBytesToBytes32(bytes inBytes) internal pure returns (bytes32 out) {
167         if (inBytes.length == 0) {
168             return 0x0;
169         }
170 
171         assembly {
172             out := mload(add(inBytes, 32))
173         }
174     }
175 
176     function bytesToUint(bytes32 b) internal pure returns (uint number){
177         for (uint i = 0; i < b.length; i++) {
178             number = number + uint(b[i]) * (2 ** (8 * (b.length - (i + 1))));
179         }
180     }
181 
182     function toBytes(uint256 x) internal pure returns (bytes b) {
183         b = new bytes(32);
184         assembly {mstore(add(b, 32), x)}
185     }
186 }
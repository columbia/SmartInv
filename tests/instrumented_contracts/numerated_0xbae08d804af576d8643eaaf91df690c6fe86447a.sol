1 pragma solidity ^0.4.15;
2 
3 /*
4   Copyright 2017 Mothership Foundation https://mothership.cx
5 
6   Permission is hereby granted, free of charge, to any person obtaining a copy
7   of this software and associated documentation files (the "Software"), to
8   deal in the Software without restriction, including without limitation the
9   rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
10   sell copies of the Software, and to permit persons to whom the Software is
11   furnished to do so, subject to the following conditions:
12 
13   The above copyright notice and this permission notice shall be included in
14   all copies or substantial portions of the Software.
15 
16   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
21   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
22   IN THE SOFTWARE.
23 */
24 
25 /// @title ERC20Basic
26 /// @dev Simpler version of ERC20 interface
27 /// @dev see https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20Basic.sol
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract Token is ERC20Basic {
36   /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
37   /// @param _owner The address from which the balance will be retrieved
38   /// @param _blockNumber The block number when the balance is queried
39   /// @return The balance at `_blockNumber`
40   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
41 }
42 
43 /// @title Ownable
44 /// @dev The Ownable contract has an owner address, and provides basic authorization control
45 /// functions, this simplifies the implementation of "user permissions".
46 ///
47 /// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
48 contract Ownable {
49   address public owner;
50 
51   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
52   /// account.
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /// @dev Throws if called by any account other than the owner.
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
64   /// @param newOwner The address to transfer ownership to.
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     owner = newOwner;
68   }
69 }
70 
71 contract Voting is Ownable {
72   // Number of candidates. NOTE Candidates IDs sequience starts at 1.
73   uint8 public candidates;
74   // An interface to a token contract to check the balance
75   Token public msp;
76   // The cap for a voter's MSP balance to count in voting result
77   uint public cap;
78   // The last block that the voting period is active
79   uint public endBlock;
80 
81   // A map to store voting candidate for each user address
82   mapping(address => uint8) public votes;
83   // A list of all voters
84   address[] public voters;
85 
86   /// @dev Constructor to create a Voting
87   /// @param _candidatesCount Number of cadidates for the voting
88   /// @param _msp Address of the MSP token contract
89   /// @param _cap The cap for a voter's MSP balance to count in voting result
90   /// @param _endBlock The last block that the voting period is active
91   function Voting(uint8 _candidatesCount, address _msp, uint _cap, uint _endBlock) public {
92     candidates = _candidatesCount;
93     msp = Token(_msp);
94     cap = _cap;
95     endBlock = _endBlock;
96   }
97 
98   /// @dev A method to signal a vote for a given `_candidate`
99   /// @param _candidate Voting candidate ID
100   function vote(uint8 _candidate) public {
101     require(_candidate > 0 && _candidate <= candidates);
102     assert(endBlock == 0 || getBlockNumber() <= endBlock);
103     if (votes[msg.sender] == 0) {
104       voters.push(msg.sender);
105     }
106     votes[msg.sender] = _candidate;
107     Vote(msg.sender, _candidate);
108   }
109 
110   /// @return Number of voters
111   function votersCount()
112     public
113     constant
114     returns(uint) {
115     return voters.length;
116   }
117 
118   /// @dev Queries the list with `_offset` and `_limit` of `voters`, candidates
119   ///  choosen and MSP amount at the current block
120   /// @param _offset The offset at the `voters` list
121   /// @param _limit The number of voters to return
122   /// @return The voters, candidates and MSP amount at current block
123   function getVoters(uint _offset, uint _limit)
124     public
125     constant
126     returns(address[] _voters, uint8[] _candidates, uint[] _amounts) {
127     return getVotersAt(_offset, _limit, getBlockNumber());
128   }
129 
130   /// @dev Queries the list with `_offset` and `_limit` of `voters`, candidates
131   ///  choosen and MSP amount at a specific `_blockNumber`
132   /// @param _offset The offset at the `voters` list
133   /// @param _limit The number of voters to return
134   /// @param _blockNumber The block number when the voters's MSP balances is queried
135   /// @return The voters, candidates and MSP amount at `_blockNumber`
136   function getVotersAt(uint _offset, uint _limit, uint _blockNumber)
137     public
138     constant
139     returns(address[] _voters, uint8[] _candidates, uint[] _amounts) {
140 
141     if (_offset < voters.length) {
142       uint count = 0;
143       uint resultLength = voters.length - _offset > _limit ? _limit : voters.length - _offset;
144       uint _block = _blockNumber > endBlock ? endBlock : _blockNumber;
145       _voters = new address[](resultLength);
146       _candidates = new uint8[](resultLength);
147       _amounts = new uint[](resultLength);
148       for(uint i = _offset; (i < voters.length) && (count < _limit); i++) {
149         _voters[count] = voters[i];
150         _candidates[count] = votes[voters[i]];
151         _amounts[count] = msp.balanceOfAt(voters[i], _block);
152         count++;
153       }
154 
155       return(_voters, _candidates, _amounts);
156     }
157   }
158 
159   function getSummary() public constant returns (uint8[] _candidates, uint[] _summary) {
160     uint _block = getBlockNumber() > endBlock ? endBlock : getBlockNumber();
161 
162     // Fill the candidates IDs list
163     _candidates = new uint8[](candidates);
164     for(uint8 c = 1; c <= candidates; c++) {
165       _candidates[c - 1] = c;
166     }
167 
168     // Get MSP impact map for each candidate
169     _summary = new uint[](candidates);
170     uint8 _candidateIndex;
171     for(uint i = 0; i < voters.length; i++) {
172       _candidateIndex = votes[voters[i]] - 1;
173       _summary[_candidateIndex] = _summary[_candidateIndex] + min(msp.balanceOfAt(voters[i], _block), cap);
174     }
175 
176     return (_candidates, _summary);
177   }
178 
179   /// @dev This method can be used by the owner to extract mistakenly
180   ///  sent tokens to this contract.
181   /// @param _token The address of the token contract that you want to recover
182   ///  set to 0 in case you want to extract ether.
183   function claimTokens(address _token) public onlyOwner {
184     if (_token == 0x0) {
185       owner.transfer(this.balance);
186       return;
187     }
188 
189     ERC20Basic token = ERC20Basic(_token);
190     uint balance = token.balanceOf(this);
191     token.transfer(owner, balance);
192     ClaimedTokens(_token, owner, balance);
193   }
194 
195   /// @dev This function is overridden by the test Mocks.
196   function getBlockNumber() internal constant returns (uint) {
197     return block.number;
198   }
199 
200   /// @dev Helper function to return a min betwen the two uints
201   function min(uint a, uint b) internal pure returns (uint) {
202     return a < b ? a : b;
203   }
204 
205   event Vote(address indexed _voter, uint indexed _candidate);
206   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
207 }
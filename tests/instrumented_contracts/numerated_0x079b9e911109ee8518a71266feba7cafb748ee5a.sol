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
30   function balanceOf(address who) constant returns (uint256);
31   function transfer(address to, uint256 value) returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract Token is ERC20Basic{
36   /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
37   /// @param _owner The address from which the balance will be retrieved
38   /// @param _blockNumber The block number when the balance is queried
39   /// @return The balance at `_blockNumber`
40   function balanceOfAt(address _owner, uint _blockNumber) constant returns (uint);
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
53   function Ownable() {
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
65   function transferOwnership(address newOwner) onlyOwner {
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
76   // The last block that the voting period is active
77   uint public endBlock;
78 
79   // A map to store voting candidate for each user address
80   mapping(address => uint8) public votes;
81   // A list of all voters
82   address[] public voters;
83 
84   /// @dev Constructor to create a Voting
85   /// @param _candidatesCount Number of cadidates for the voting
86   /// @param _msp Address of the MSP token contract
87   /// @param _endBlock The last block that the voting period is active
88   function Voting(uint8 _candidatesCount, address _msp, uint _endBlock) {
89     candidates = _candidatesCount;
90     msp = Token(_msp);
91     endBlock = _endBlock;
92   }
93 
94   /// @dev A method to signal a vote for a given `_candidate`
95   /// @param _candidate Voting candidate ID
96   function vote(uint8 _candidate) {
97     require(_candidate > 0 && _candidate <= candidates);
98     assert(endBlock == 0 || getBlockNumber() <= endBlock);
99     if (votes[msg.sender] == 0) {
100       voters.push(msg.sender);
101     }
102     votes[msg.sender] = _candidate;
103     Vote(msg.sender, _candidate);
104   }
105 
106   /// @return Number of voters
107   function votersCount()
108     constant
109     returns(uint) {
110     return voters.length;
111   }
112 
113   /// @dev Queries the list with `_offset` and `_limit` of `voters`, candidates
114   ///  choosen and MSP amount at the current block
115   /// @param _offset The offset at the `voters` list
116   /// @param _limit The number of voters to return
117   /// @return The voters, candidates and MSP amount at current block
118   function getVoters(uint _offset, uint _limit)
119     constant
120     returns(address[] _voters, uint8[] _candidates, uint[] _amounts) {
121     return getVotersAt(_offset, _limit, getBlockNumber());
122   }
123 
124   /// @dev Queries the list with `_offset` and `_limit` of `voters`, candidates
125   ///  choosen and MSP amount at a specific `_blockNumber`
126   /// @param _offset The offset at the `voters` list
127   /// @param _limit The number of voters to return
128   /// @param _blockNumber The block number when the voters's MSP balances is queried
129   /// @return The voters, candidates and MSP amount at `_blockNumber`
130   function getVotersAt(uint _offset, uint _limit, uint _blockNumber)
131     constant
132     returns(address[] _voters, uint8[] _candidates, uint[] _amounts) {
133 
134     if (_offset < voters.length) {
135       uint count = 0;
136       uint resultLength = voters.length - _offset > _limit ? _limit : voters.length - _offset;
137       uint _block = _blockNumber > endBlock ? endBlock : _blockNumber;
138       _voters = new address[](resultLength);
139       _candidates = new uint8[](resultLength);
140       _amounts = new uint[](resultLength);
141       for(uint i = _offset; (i < voters.length) && (count < _limit); i++) {
142         _voters[count] = voters[i];
143         _candidates[count] = votes[voters[i]];
144         _amounts[count] = msp.balanceOfAt(voters[i], _block);
145         count++;
146       }
147 
148       return(_voters, _candidates, _amounts);
149     }
150   }
151 
152   function getSummary() constant returns (uint8[] _candidates, uint[] _summary) {
153     uint _block = getBlockNumber() > endBlock ? endBlock : getBlockNumber();
154 
155     // Fill the candidates IDs list
156     _candidates = new uint8[](candidates);
157     for(uint8 c = 1; c <= candidates; c++) {
158       _candidates[c - 1] = c;
159     }
160 
161     // Get MSP impact map for each candidate
162     _summary = new uint[](candidates);
163     uint8 _candidateIndex;
164     for(uint i = 0; i < voters.length; i++) {
165       _candidateIndex = votes[voters[i]] - 1;
166       _summary[_candidateIndex] = _summary[_candidateIndex] + msp.balanceOfAt(voters[i], _block);
167     }
168 
169     return (_candidates, _summary);
170   }
171 
172   /// @dev This method can be used by the owner to extract mistakenly
173   ///  sent tokens to this contract.
174   /// @param _token The address of the token contract that you want to recover
175   ///  set to 0 in case you want to extract ether.
176   function claimTokens(address _token) onlyOwner {
177     if (_token == 0x0) {
178       owner.transfer(this.balance);
179       return;
180     }
181 
182     ERC20Basic token = ERC20Basic(_token);
183     uint balance = token.balanceOf(this);
184     token.transfer(owner, balance);
185     ClaimedTokens(_token, owner, balance);
186   }
187 
188   /// @dev This function is overridden by the test Mocks.
189   function getBlockNumber() internal constant returns (uint) {
190     return block.number;
191   }
192 
193   event Vote(address indexed _voter, uint indexed _candidate);
194   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
195 }
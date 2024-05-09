1 pragma solidity ^0.4.11;
2 // Standard token interface (ERC 20)
3 // https://github.com/ethereum/EIPs/issues/20
4 contract Token {
5 // Functions:
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) returns (bool success) {}
27     /// @param _owner The address of the account owning tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @return Amount of remaining tokens allowed to spent
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
31 // Events:
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 contract StdToken is Token {
36 // Fields:
37      mapping(address => uint256) balances;
38      mapping (address => mapping (address => uint256)) allowed;
39      uint256 public allSupply = 0;
40 // Functions:
41      function transfer(address _to, uint256 _value) returns (bool success) {
42           if((balances[msg.sender] >= _value) && (balances[_to] + _value > balances[_to])){
43                balances[msg.sender] -= _value;
44                balances[_to] += _value;
45                Transfer(msg.sender, _to, _value);
46                return true;
47           } else { 
48                return false; 
49           }
50      }
51      function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52           if((balances[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balances[_to] + _value > balances[_to])){
53                balances[_to] += _value;
54                balances[_from] -= _value;
55                allowed[_from][msg.sender] -= _value;
56                Transfer(_from, _to, _value);
57                return true;
58           } else { 
59                return false; 
60           }
61      }
62      function balanceOf(address _owner) constant returns (uint256 balance) {
63           return balances[_owner];
64      }
65      function approve(address _spender, uint256 _value) returns (bool success) {
66           allowed[msg.sender][_spender] = _value;
67           Approval(msg.sender, _spender, _value);
68           return true;
69      }
70      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71           return allowed[_owner][_spender];
72      }
73      function totalSupply() constant returns (uint256 supplyOut) {
74           supplyOut = allSupply;
75           return;
76      }
77 }
78 contract QRL_Token is StdToken {
79      string public name = "QRL";
80      uint public decimals = 8;
81      string public symbol = "QRL";
82      address public creator = 0x0;
83      uint freezeblock = 0;
84      modifier notFrozen() {
85           if ((freezeblock != 0) && (block.number > freezeblock)) throw;
86           _;
87      }
88      modifier onlyPayloadSize(uint numwords) {
89           if (msg.data.length != numwords * 32 + 4) throw;
90           _;
91      }
92      modifier onlyInState(State state){
93           if(currentState!=state)
94                throw;
95           _;
96      }
97      modifier onlyByCreator(){
98           if(msg.sender!=creator)
99                throw;
100           _;
101      }
102 // Functions:
103      function transfer(address _to, uint256 _value) notFrozen onlyPayloadSize(2) returns (bool success) {
104           if((balances[msg.sender] >= _value) && (balances[_to] + _value > balances[_to])){
105                balances[msg.sender] -= _value;
106                balances[_to] += _value;
107                Transfer(msg.sender, _to, _value);
108                return true;
109           } else { 
110                return false; 
111           }
112      }
113      function transferFrom(address _from, address _to, uint256 _value) notFrozen onlyPayloadSize(2) returns (bool success) {
114           if((balances[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balances[_to] + _value > balances[_to])){
115                balances[_to] += _value;
116                balances[_from] -= _value;
117                allowed[_from][msg.sender] -= _value;
118                Transfer(_from, _to, _value);
119                return true;
120           } else { 
121                return false; 
122           }
123      }
124      function approve(address _spender, uint256 _value) returns (bool success) {
125           //require user to set to zero before resetting to nonzero
126           if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
127                return false;
128           }
129           allowed[msg.sender][_spender] = _value;
130           Approval(msg.sender, _spender, _value);
131           return true;
132      }
133      function QRL_Token(){
134           creator = msg.sender;
135      }
136      enum State {
137           Start,
138           Closed
139      }
140      State public currentState = State.Start;
141      function freeze(uint fb) onlyByCreator {
142           freezeblock = fb;
143      }
144      function issueTokens(address forAddress, uint tokenCount) onlyInState(State.Start) onlyByCreator{
145           balances[forAddress]=tokenCount;
146           
147           // This is removed for optimization (lower gas consumption for each call)
148           // Please see 'setAllSupply' function
149           //
150           // allBalances+=tokenCount
151      }
152      // This is called to close the contract (so no one could mint more tokens)
153      function close() onlyInState(State.Start) onlyByCreator{
154           currentState = State.Closed;
155      }
156      function setAllSupply(uint data) onlyInState(State.Start) onlyByCreator{
157           allSupply = data;
158      }
159      function changeCreator(address newCreator) onlyByCreator{
160           creator = newCreator;
161      }
162 }
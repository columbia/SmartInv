1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMathForBoost {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract Boost {
37     using SafeMathForBoost for uint256;
38 
39     string public name = "Boost";
40     uint8 public decimals = 0;
41     string public symbol = "BST";
42     uint256 public totalSupply = 100000000;
43 
44     // `balances` is the map that tracks the balance of each address, in this
45     //  contract when the balance changes the block number that the change
46     //  occurred is also included in the map
47     mapping (address => Checkpoint[]) balances;
48 
49     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
50     mapping (address => mapping (address => uint256)) allowed;
51 
52     /// @dev `Checkpoint` is the structure that attaches a block number to a
53     ///  given value, the block number attached is the one that last changed the value
54     struct  Checkpoint {
55 
56         // `fromBlock` is the block number that the value was generated from
57         uint256 fromBlock;
58 
59         // `value` is the amount of tokens at a specific block number
60         uint256 value;
61     }
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
65 
66     /// @dev constructor
67     function Boost() public {
68         balances[msg.sender].push(Checkpoint({
69             fromBlock:block.number,
70             value:totalSupply
71         }));
72     }
73 
74     /// @dev Send `_amount` tokens to `_to` from `msg.sender`
75     /// @param _to The address of the recipient
76     /// @param _amount The amount of tokens to be transferred
77     /// @return Whether the transfer was successful or not
78     function transfer(address _to, uint256 _amount) public returns (bool success) {
79         doTransfer(msg.sender, _to, _amount);
80         return true;
81     }
82 
83     /// @dev Send `_amount` tokens to `_to` from `_from` on the condition it
84     ///  is approved by `_from`
85     /// @param _from The address holding the tokens being transferred
86     /// @param _to The address of the recipient
87     /// @param _amount The amount of tokens to be transferred
88     /// @return True if the transfer was successful
89     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
90 
91         // The standard ERC 20 transferFrom functionality
92         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
93 
94         doTransfer(_from, _to, _amount);
95         return true;
96     }
97 
98     /// @dev _owner The address that's balance is being requested
99     /// @return The balance of `_owner` at the current block
100     function balanceOf(address _owner) public view returns (uint256 balance) {
101         return balanceOfAt(_owner, block.number);
102     }
103 
104     /// @dev `msg.sender` approves `_spender` to spend `_amount` tokens on
105     ///  its behalf. This is a modified version of the ERC20 approve function
106     ///  to be a little bit safer
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @param _amount The amount of tokens to be approved for transfer
109     /// @return True if the approval was successful
110     function approve(address _spender, uint256 _amount) public returns (bool success) {
111 
112         // To change the approve amount you first have to reduce the addresses`
113         //  allowance to zero by calling `approve(_spender,0)` if it is not
114         //  already 0 to mitigate the race condition described here:
115         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
117 
118         allowed[msg.sender][_spender] = _amount;
119         Approval(msg.sender, _spender, _amount);
120         return true;
121     }
122 
123     /// @dev This function makes it easy to read the `allowed[]` map
124     /// @param _owner The address of the account that owns the token
125     /// @param _spender The address of the account able to transfer the tokens
126     /// @return Amount of remaining tokens of _owner that _spender is allowed
127     ///  to spend
128     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
129         return allowed[_owner][_spender];
130     }
131 
132     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
133     /// @param _owner The address from which the balance will be retrieved
134     /// @param _blockNumber The block number when the balance is queried
135     /// @return The balance at `_blockNumber`
136     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
137         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
138             return 0;
139         } else {
140             return getValueAt(balances[_owner], _blockNumber);
141         }
142     }
143 
144     /// @dev This is the actual transfer function in the token contract, it can
145     ///  only be called by other functions in this contract.
146     /// @param _from The address holding the tokens being transferred
147     /// @param _to The address of the recipient
148     /// @param _amount The amount of tokens to be transferred
149     /// @return True if the transfer was successful
150     function doTransfer(address _from, address _to, uint _amount) internal {
151 
152         // Do not allow transfer to 0x0 or the token contract itself
153         require((_to != 0) && (_to != address(this)) && (_amount != 0));
154 
155         // First update the balance array with the new value for the address
156         // sending the tokens
157         var previousBalanceFrom = balanceOfAt(_from, block.number);
158         updateValueAtNow(balances[_from], previousBalanceFrom.sub(_amount));
159 
160         // Then update the balance array with the new value for the address
161         // receiving the tokens
162         var previousBalanceTo = balanceOfAt(_to, block.number);
163         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
164 
165         // An event to make the transfer easy to find on the blockchain
166         Transfer(_from, _to, _amount);
167 
168     }
169 
170     /// @dev `getValueAt` retrieves the number of tokens at a given block number
171     /// @param checkpoints The history of values being queried
172     /// @param _block The block number to retrieve the value at
173     /// @return The number of tokens being queried
174     function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view  returns (uint) {
175         if (checkpoints.length == 0) return 0;
176 
177         // Shortcut for the actual value
178         if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
179             return checkpoints[checkpoints.length - 1].value;
180         if (_block < checkpoints[0].fromBlock) return 0;
181 
182         // Binary search of the value in the array
183         uint min = 0;
184         uint max = checkpoints.length - 1;
185         while (max > min) {
186             uint mid = (max + min + 1) / 2;
187             if (checkpoints[mid].fromBlock <= _block) {
188                 min = mid;
189             } else {
190                 max = mid - 1;
191             }
192         }
193         return checkpoints[min].value;
194     }
195 
196     /// @dev `updateValueAtNow` used to update the `balances` map and the
197     ///  `totalSupplyHistory`
198     /// @param checkpoints The history of data being updated
199     /// @param _value The new number of tokens
200     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
201         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
202             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
203             newCheckPoint.fromBlock = block.number;
204             newCheckPoint.value = _value;
205         } else {
206             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
207             oldCheckPoint.value = _value;
208         }
209     }
210 
211     /// @dev Helper function to return a min between the two uints
212     function min(uint a, uint b) internal pure returns (uint) {
213         return a < b ? a : b;
214     }
215 }
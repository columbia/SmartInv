1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: @daostack/infra/contracts/Reputation.sol
77 
78 /**
79  * @title Reputation system
80  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
81  * A reputation is use to assign influence measure to a DAO'S peers.
82  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
83  * The Reputation contract maintain a map of address to reputation value.
84  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
85  */
86 
87 contract Reputation is Ownable {
88 
89     uint8 public decimals = 18;             //Number of decimals of the smallest unit
90     // Event indicating minting of reputation to an address.
91     event Mint(address indexed _to, uint256 _amount);
92     // Event indicating burning of reputation for an address.
93     event Burn(address indexed _from, uint256 _amount);
94 
95       /// @dev `Checkpoint` is the structure that attaches a block number to a
96       ///  given value, the block number attached is the one that last changed the
97       ///  value
98     struct Checkpoint {
99 
100     // `fromBlock` is the block number that the value was generated from
101         uint128 fromBlock;
102 
103           // `value` is the amount of reputation at a specific block number
104         uint128 value;
105     }
106 
107       // `balances` is the map that tracks the balance of each address, in this
108       //  contract when the balance changes the block number that the change
109       //  occurred is also included in the map
110     mapping (address => Checkpoint[]) balances;
111 
112       // Tracks the history of the `totalSupply` of the reputation
113     Checkpoint[] totalSupplyHistory;
114 
115     /// @notice Constructor to create a Reputation
116     constructor(
117     ) public
118     {
119     }
120 
121     /// @dev This function makes it easy to get the total number of reputation
122     /// @return The total number of reputation
123     function totalSupply() public view returns (uint256) {
124         return totalSupplyAt(block.number);
125     }
126 
127   ////////////////
128   // Query balance and totalSupply in History
129   ////////////////
130     /**
131     * @dev return the reputation amount of a given owner
132     * @param _owner an address of the owner which we want to get his reputation
133     */
134     function balanceOf(address _owner) public view returns (uint256 balance) {
135         return balanceOfAt(_owner, block.number);
136     }
137 
138       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
139       /// @param _owner The address from which the balance will be retrieved
140       /// @param _blockNumber The block number when the balance is queried
141       /// @return The balance at `_blockNumber`
142     function balanceOfAt(address _owner, uint256 _blockNumber)
143     public view returns (uint256)
144     {
145         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
146             return 0;
147           // This will return the expected balance during normal situations
148         } else {
149             return getValueAt(balances[_owner], _blockNumber);
150         }
151     }
152 
153       /// @notice Total amount of reputation at a specific `_blockNumber`.
154       /// @param _blockNumber The block number when the totalSupply is queried
155       /// @return The total amount of reputation at `_blockNumber`
156     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
157         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
158             return 0;
159           // This will return the expected totalSupply during normal situations
160         } else {
161             return getValueAt(totalSupplyHistory, _blockNumber);
162         }
163     }
164 
165       /// @notice Generates `_amount` reputation that are assigned to `_owner`
166       /// @param _user The address that will be assigned the new reputation
167       /// @param _amount The quantity of reputation generated
168       /// @return True if the reputation are generated correctly
169     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
170         uint256 curTotalSupply = totalSupply();
171         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
172         uint256 previousBalanceTo = balanceOf(_user);
173         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
174         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
175         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
176         emit Mint(_user, _amount);
177         return true;
178     }
179 
180       /// @notice Burns `_amount` reputation from `_owner`
181       /// @param _user The address that will lose the reputation
182       /// @param _amount The quantity of reputation to burn
183       /// @return True if the reputation are burned correctly
184     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
185         uint256 curTotalSupply = totalSupply();
186         uint256 amountBurned = _amount;
187         uint256 previousBalanceFrom = balanceOf(_user);
188         if (previousBalanceFrom < amountBurned) {
189             amountBurned = previousBalanceFrom;
190         }
191         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
192         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
193         emit Burn(_user, amountBurned);
194         return true;
195     }
196 
197   ////////////////
198   // Internal helper functions to query and set a value in a snapshot array
199   ////////////////
200 
201       /// @dev `getValueAt` retrieves the number of reputation at a given block number
202       /// @param checkpoints The history of values being queried
203       /// @param _block The block number to retrieve the value at
204       /// @return The number of reputation being queried
205     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
206         if (checkpoints.length == 0) {
207             return 0;
208         }
209 
210           // Shortcut for the actual value
211         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
212             return checkpoints[checkpoints.length-1].value;
213         }
214         if (_block < checkpoints[0].fromBlock) {
215             return 0;
216         }
217 
218           // Binary search of the value in the array
219         uint256 min = 0;
220         uint256 max = checkpoints.length-1;
221         while (max > min) {
222             uint256 mid = (max + min + 1) / 2;
223             if (checkpoints[mid].fromBlock<=_block) {
224                 min = mid;
225             } else {
226                 max = mid-1;
227             }
228         }
229         return checkpoints[min].value;
230     }
231 
232       /// @dev `updateValueAtNow` used to update the `balances` map and the
233       ///  `totalSupplyHistory`
234       /// @param checkpoints The history of data being updated
235       /// @param _value The new number of reputation
236     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
237         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
238         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
239             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
240             newCheckPoint.fromBlock = uint128(block.number);
241             newCheckPoint.value = uint128(_value);
242         } else {
243             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
244             oldCheckPoint.value = uint128(_value);
245         }
246     }
247 }
248 
249 // File: contracts/DxReputation.sol
250 
251 // is Reputation
252 contract DxReputation is Reputation {
253     constructor() public {}
254 }
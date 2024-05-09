1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
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
76 // File: contracts/Reputation.sol
77 
78 pragma solidity ^0.5.4;
79 
80 
81 
82 /**
83  * @title Reputation system
84  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
85  * A reputation is use to assign influence measure to a DAO'S peers.
86  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
87  * The Reputation contract maintain a map of address to reputation value.
88  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
89  */
90 
91 contract Reputation is Ownable {
92 
93     uint8 public decimals = 18;             //Number of decimals of the smallest unit
94     // Event indicating minting of reputation to an address.
95     event Mint(address indexed _to, uint256 _amount);
96     // Event indicating burning of reputation for an address.
97     event Burn(address indexed _from, uint256 _amount);
98 
99       /// @dev `Checkpoint` is the structure that attaches a block number to a
100       ///  given value, the block number attached is the one that last changed the
101       ///  value
102     struct Checkpoint {
103 
104     // `fromBlock` is the block number that the value was generated from
105         uint128 fromBlock;
106 
107           // `value` is the amount of reputation at a specific block number
108         uint128 value;
109     }
110 
111       // `balances` is the map that tracks the balance of each address, in this
112       //  contract when the balance changes the block number that the change
113       //  occurred is also included in the map
114     mapping (address => Checkpoint[]) balances;
115 
116       // Tracks the history of the `totalSupply` of the reputation
117     Checkpoint[] totalSupplyHistory;
118 
119     /// @notice Constructor to create a Reputation
120     constructor(
121     ) public
122     {
123     }
124 
125     /// @dev This function makes it easy to get the total number of reputation
126     /// @return The total number of reputation
127     function totalSupply() public view returns (uint256) {
128         return totalSupplyAt(block.number);
129     }
130 
131   ////////////////
132   // Query balance and totalSupply in History
133   ////////////////
134     /**
135     * @dev return the reputation amount of a given owner
136     * @param _owner an address of the owner which we want to get his reputation
137     */
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return balanceOfAt(_owner, block.number);
140     }
141 
142       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
143       /// @param _owner The address from which the balance will be retrieved
144       /// @param _blockNumber The block number when the balance is queried
145       /// @return The balance at `_blockNumber`
146     function balanceOfAt(address _owner, uint256 _blockNumber)
147     public view returns (uint256)
148     {
149         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
150             return 0;
151           // This will return the expected balance during normal situations
152         } else {
153             return getValueAt(balances[_owner], _blockNumber);
154         }
155     }
156 
157       /// @notice Total amount of reputation at a specific `_blockNumber`.
158       /// @param _blockNumber The block number when the totalSupply is queried
159       /// @return The total amount of reputation at `_blockNumber`
160     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
161         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
162             return 0;
163           // This will return the expected totalSupply during normal situations
164         } else {
165             return getValueAt(totalSupplyHistory, _blockNumber);
166         }
167     }
168 
169       /// @notice Generates `_amount` reputation that are assigned to `_owner`
170       /// @param _user The address that will be assigned the new reputation
171       /// @param _amount The quantity of reputation generated
172       /// @return True if the reputation are generated correctly
173     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
174         uint256 curTotalSupply = totalSupply();
175         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
176         uint256 previousBalanceTo = balanceOf(_user);
177         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
178         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
179         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
180         emit Mint(_user, _amount);
181         return true;
182     }
183 
184       /// @notice Burns `_amount` reputation from `_owner`
185       /// @param _user The address that will lose the reputation
186       /// @param _amount The quantity of reputation to burn
187       /// @return True if the reputation are burned correctly
188     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
189         uint256 curTotalSupply = totalSupply();
190         uint256 amountBurned = _amount;
191         uint256 previousBalanceFrom = balanceOf(_user);
192         if (previousBalanceFrom < amountBurned) {
193             amountBurned = previousBalanceFrom;
194         }
195         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
196         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
197         emit Burn(_user, amountBurned);
198         return true;
199     }
200 
201   ////////////////
202   // Internal helper functions to query and set a value in a snapshot array
203   ////////////////
204 
205       /// @dev `getValueAt` retrieves the number of reputation at a given block number
206       /// @param checkpoints The history of values being queried
207       /// @param _block The block number to retrieve the value at
208       /// @return The number of reputation being queried
209     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
210         if (checkpoints.length == 0) {
211             return 0;
212         }
213 
214           // Shortcut for the actual value
215         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
216             return checkpoints[checkpoints.length-1].value;
217         }
218         if (_block < checkpoints[0].fromBlock) {
219             return 0;
220         }
221 
222           // Binary search of the value in the array
223         uint256 min = 0;
224         uint256 max = checkpoints.length-1;
225         while (max > min) {
226             uint256 mid = (max + min + 1) / 2;
227             if (checkpoints[mid].fromBlock<=_block) {
228                 min = mid;
229             } else {
230                 max = mid-1;
231             }
232         }
233         return checkpoints[min].value;
234     }
235 
236       /// @dev `updateValueAtNow` used to update the `balances` map and the
237       ///  `totalSupplyHistory`
238       /// @param checkpoints The history of data being updated
239       /// @param _value The new number of reputation
240     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
241         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
242         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
243             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
244             newCheckPoint.fromBlock = uint128(block.number);
245             newCheckPoint.value = uint128(_value);
246         } else {
247             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
248             oldCheckPoint.value = uint128(_value);
249         }
250     }
251 }
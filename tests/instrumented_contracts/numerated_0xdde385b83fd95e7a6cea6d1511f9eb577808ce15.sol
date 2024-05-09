1 
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * @notice Renouncing to ownership will leave the contract without an owner.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: @daostack/infra/contracts/Reputation.sol
78 
79 pragma solidity ^0.5.4;
80 
81 
82 
83 /**
84  * @title Reputation system
85  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
86  * A reputation is use to assign influence measure to a DAO'S peers.
87  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
88  * The Reputation contract maintain a map of address to reputation value.
89  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
90  */
91 
92 contract Reputation is Ownable {
93 
94     uint8 public decimals = 18;             //Number of decimals of the smallest unit
95     // Event indicating minting of reputation to an address.
96     event Mint(address indexed _to, uint256 _amount);
97     // Event indicating burning of reputation for an address.
98     event Burn(address indexed _from, uint256 _amount);
99 
100       /// @dev `Checkpoint` is the structure that attaches a block number to a
101       ///  given value, the block number attached is the one that last changed the
102       ///  value
103     struct Checkpoint {
104 
105     // `fromBlock` is the block number that the value was generated from
106         uint128 fromBlock;
107 
108           // `value` is the amount of reputation at a specific block number
109         uint128 value;
110     }
111 
112       // `balances` is the map that tracks the balance of each address, in this
113       //  contract when the balance changes the block number that the change
114       //  occurred is also included in the map
115     mapping (address => Checkpoint[]) balances;
116 
117       // Tracks the history of the `totalSupply` of the reputation
118     Checkpoint[] totalSupplyHistory;
119 
120     /// @notice Constructor to create a Reputation
121     constructor(
122     ) public
123     {
124     }
125 
126     /// @dev This function makes it easy to get the total number of reputation
127     /// @return The total number of reputation
128     function totalSupply() public view returns (uint256) {
129         return totalSupplyAt(block.number);
130     }
131 
132   ////////////////
133   // Query balance and totalSupply in History
134   ////////////////
135     /**
136     * @dev return the reputation amount of a given owner
137     * @param _owner an address of the owner which we want to get his reputation
138     */
139     function balanceOf(address _owner) public view returns (uint256 balance) {
140         return balanceOfAt(_owner, block.number);
141     }
142 
143       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
144       /// @param _owner The address from which the balance will be retrieved
145       /// @param _blockNumber The block number when the balance is queried
146       /// @return The balance at `_blockNumber`
147     function balanceOfAt(address _owner, uint256 _blockNumber)
148     public view returns (uint256)
149     {
150         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
151             return 0;
152           // This will return the expected balance during normal situations
153         } else {
154             return getValueAt(balances[_owner], _blockNumber);
155         }
156     }
157 
158       /// @notice Total amount of reputation at a specific `_blockNumber`.
159       /// @param _blockNumber The block number when the totalSupply is queried
160       /// @return The total amount of reputation at `_blockNumber`
161     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
162         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
163             return 0;
164           // This will return the expected totalSupply during normal situations
165         } else {
166             return getValueAt(totalSupplyHistory, _blockNumber);
167         }
168     }
169 
170       /// @notice Generates `_amount` reputation that are assigned to `_owner`
171       /// @param _user The address that will be assigned the new reputation
172       /// @param _amount The quantity of reputation generated
173       /// @return True if the reputation are generated correctly
174     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
175         uint256 curTotalSupply = totalSupply();
176         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
177         uint256 previousBalanceTo = balanceOf(_user);
178         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
179         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
180         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
181         emit Mint(_user, _amount);
182         return true;
183     }
184 
185       /// @notice Burns `_amount` reputation from `_owner`
186       /// @param _user The address that will lose the reputation
187       /// @param _amount The quantity of reputation to burn
188       /// @return True if the reputation are burned correctly
189     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
190         uint256 curTotalSupply = totalSupply();
191         uint256 amountBurned = _amount;
192         uint256 previousBalanceFrom = balanceOf(_user);
193         if (previousBalanceFrom < amountBurned) {
194             amountBurned = previousBalanceFrom;
195         }
196         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
197         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
198         emit Burn(_user, amountBurned);
199         return true;
200     }
201 
202   ////////////////
203   // Internal helper functions to query and set a value in a snapshot array
204   ////////////////
205 
206       /// @dev `getValueAt` retrieves the number of reputation at a given block number
207       /// @param checkpoints The history of values being queried
208       /// @param _block The block number to retrieve the value at
209       /// @return The number of reputation being queried
210     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
211         if (checkpoints.length == 0) {
212             return 0;
213         }
214 
215           // Shortcut for the actual value
216         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
217             return checkpoints[checkpoints.length-1].value;
218         }
219         if (_block < checkpoints[0].fromBlock) {
220             return 0;
221         }
222 
223           // Binary search of the value in the array
224         uint256 min = 0;
225         uint256 max = checkpoints.length-1;
226         while (max > min) {
227             uint256 mid = (max + min + 1) / 2;
228             if (checkpoints[mid].fromBlock<=_block) {
229                 min = mid;
230             } else {
231                 max = mid-1;
232             }
233         }
234         return checkpoints[min].value;
235     }
236 
237       /// @dev `updateValueAtNow` used to update the `balances` map and the
238       ///  `totalSupplyHistory`
239       /// @param checkpoints The history of data being updated
240       /// @param _value The new number of reputation
241     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
242         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
243         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
244             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
245             newCheckPoint.fromBlock = uint128(block.number);
246             newCheckPoint.value = uint128(_value);
247         } else {
248             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
249             oldCheckPoint.value = uint128(_value);
250         }
251     }
252 }
253 
254 // File: contracts/DxReputation.sol
255 
256 pragma solidity ^0.5.4;
257 
258 
259 // is Reputation
260 contract DxReputation is Reputation {
261     constructor() public {}
262 }

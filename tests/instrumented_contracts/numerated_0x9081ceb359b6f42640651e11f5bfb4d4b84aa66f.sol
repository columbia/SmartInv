1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81 }
82 
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    *
98    * Beware that changing an allowance with this method brings the risk that someone may use both the old
99    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
100    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
101    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Increase the amount of tokens that an owner allowed to a spender.
113    *
114    * approve should be called when allowed[_spender] == 0. To increment
115    * allowed value is better to use this function to avoid 2 calls (and wait until
116    * the first transaction is mined)
117    * From MonolithDAO Token.sol
118    * @param _spender The address which will spend the funds.
119    * @param _addedValue The amount of tokens to increase the allowance by.
120    */
121   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
122     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
123     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126 
127   /**
128    * @dev Decrease the amount of tokens that an owner allowed to a spender.
129    *
130    * approve should be called when allowed[_spender] == 0. To decrement
131    * allowed value is better to use this function to avoid 2 calls (and wait until
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    * @param _spender The address which will spend the funds.
135    * @param _subtractedValue The amount of tokens to decrease the allowance by.
136    */
137   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148   /**
149   * @dev Function to check the amount of tokens that an owner allowed to a spender.
150   * @param _owner address The address which owns the funds.
151   * @param _spender address The address which will spend the funds.
152   * @return A uint256 specifying the amount of tokens still available for the spender.
153   */
154   function allowance(address _owner, address _spender) public view returns (uint256) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 /**
161  * @title Partial Basic
162  * @dev Partial Basic is an experimental cryptocurrency that guarantees
163  * unconditional, indeterminate rewards to network participants.
164  */
165 contract PartialBasic is StandardToken {
166   using SafeMath for uint256;
167 
168   string public constant name = "Partial Basic"; // solium-disable-line uppercase
169   string public constant symbol = "PB"; // solium-disable-line uppercase
170   uint8 public constant decimals = 18; // solium-disable-line uppercase
171 
172   uint256 public constant BASE_REWARD = 20000 ether;
173   uint256 private constant PRECISION = 10**18;
174 
175   uint256 public totalNodes;
176   uint256 public rewardStartTime;
177   uint256 public rewardCheckpoint;
178   uint256 private rewardTimestamp;
179 
180   mapping(address => uint256) public nodes;
181   mapping(address => uint256) private claimed;
182 
183   event Mint(address indexed to, uint256 amount);
184   event AddNode(address indexed owner);
185 
186   /**
187   * @dev add a node for a specified address.
188   * @param _owner The address to add a node for.
189   */
190   function addNode(address _owner) external {
191     uint256 checkpointCandidate;
192 
193     if (rewardStartTime == 0) {
194       // initialise rewards
195       rewardStartTime = block.timestamp;
196     } else {
197       // reward per node must increase to be a valid checkpoint
198       // or a valid reward for this block must have already been checkpointed
199       checkpointCandidate = rewardPerNode();
200       require(checkpointCandidate > rewardCheckpoint || block.timestamp == rewardTimestamp);
201     }
202 
203     // claim outstanding rewards
204     sync(_owner);
205 
206     if (rewardCheckpoint != checkpointCandidate) {
207       // checkpoint the total reward per node
208       rewardCheckpoint = checkpointCandidate;
209     }
210 
211     if (rewardTimestamp != block.timestamp) {
212       // reset the timestamp for the reward
213       rewardTimestamp = block.timestamp;
214     }
215 
216     // add node for address
217     nodes[_owner] = nodes[_owner].add(1);
218 
219     // prevent new nodes from claiming old rewards
220     claimed[_owner] = rewardCheckpoint.mul(nodes[_owner]);
221 
222     // update the total nodes in the network
223     totalNodes = totalNodes.add(1);
224 
225     // fire event
226     emit AddNode(_owner);
227   }
228 
229   /**
230   * @dev Gets the total reward for a node.
231   * @return A uint256 representing the total reward of a node.
232   */
233   function rewardPerNode() public view returns (uint256) {
234     // no reward if there are no active nodes
235     if (totalNodes == 0) {
236       return;
237     }
238 
239     // days since last checkpoint
240     uint256 totalDays = block.timestamp.sub(rewardTimestamp).mul(PRECISION).div(1 days);
241 
242     // reward * days / nodes
243     uint256 newReward = BASE_REWARD.mul(totalDays).div(PRECISION).div(totalNodes);
244 
245     // checkpoint + newReward
246     return rewardCheckpoint.add(newReward);
247   }
248 
249   /**
250   * @dev Gets the outstanding reward of a specified address.
251   * @param _owner The address to query the reward of.
252   * @return A uint256 representing the outstanding reward of the passed address.
253   */
254   function calculateReward(address _owner) public view returns (uint256) {
255     // address must be running a node
256     if (isMining(_owner)) {
257       // return outstanding reward
258       uint256 reward = rewardPerNode().mul(nodes[_owner]);
259       return reward.sub(claimed[_owner]);
260     }
261   }
262 
263   /**
264   * @dev sync an outstanding reward for a specified address.
265   * @param _owner The address to sync rewards for.
266   */
267   function sync(address _owner) public {
268     uint256 reward = calculateReward(_owner);
269     if (reward > 0) {
270       claimed[_owner] = claimed[_owner].add(reward);
271       balances[_owner] = balances[_owner].add(reward);
272       emit Mint(_owner, reward);
273       emit Transfer(address(0), _owner, reward);
274     }
275   }
276 
277   /**
278   * @dev transfer token for a specified address.
279   * @param _to The address to transfer to.
280   * @param _value The amount to be transferred.
281   */
282   function transfer(address _to, uint256 _value) public returns (bool) {
283     sync(msg.sender);
284     require(_to != address(0));
285     require(_value <= balances[msg.sender]);
286 
287     balances[msg.sender] = balances[msg.sender].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     emit Transfer(msg.sender, _to, _value);
290     return true;
291   }
292 
293   /**
294   * @dev Transfer tokens from one address to another.
295   * @param _from address The address which you want to send tokens from.
296   * @param _to address The address which you want to transfer to.
297   * @param _value uint256 the amount of tokens to be transferred.
298   */
299   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
300     sync(_from);
301     require(_to != address(0));
302     require(_value <= balances[_from]);
303     require(_value <= allowed[_from][msg.sender]);
304 
305     balances[_from] = balances[_from].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     emit Transfer(_from, _to, _value);
309     return true;
310   }
311 
312   /**
313   * @dev Gets the balance of the specified address.
314   * @param _owner The address to query the the balance of.
315   * @return A uint256 representing the amount owned by the passed address.
316   */
317   function balanceOf(address _owner) public view returns (uint256) {
318     return balances[_owner].add(calculateReward(_owner));
319   }
320 
321   /**
322   * @dev returns the approximate total number of tokens in existence
323   * @return A uint256 representing the approximate total number of tokens in existence.
324   */
325   function totalSupply() public view returns (uint256) {
326     if (rewardStartTime == 0) {
327       return;
328     }
329 
330     // days since start of rewards
331     uint256 totalDays = block.timestamp.sub(rewardStartTime).mul(PRECISION).div(1 days);
332 
333     // reward * days
334     return BASE_REWARD.mul(totalDays).div(PRECISION);
335   }
336 
337   /**
338   * @dev returns the mining status of the passed address.
339   * @return A uint256 representing the mining status of the passed address.
340   */
341   function isMining(address _owner) public view returns (bool) {
342     return nodes[_owner] != 0;
343   }
344 
345   /**
346   * @dev A batch query to get all node information for a specified address.
347   * @param _owner The address to query the details of.
348   * @return A bool representing the mining status of the passed address.
349   * @return A uint256 representing the number of nodes owned by the passed address.
350   * @return A uint256 representing the amount owned by the passed address.
351   * @return A uint256 representing the outstanding reward of the passed address.
352   * @return A uint256 representing the total reward per node.
353   * @return A uint256 representing the total nodes in the network.
354   * @return A uint256 representing the total number of tokens in existence.
355   */
356   function getInfo(address _owner) public view returns (bool, uint256, uint256, uint256, uint256, uint256, uint256) {
357     return (isMining(_owner), nodes[_owner], balanceOf(_owner), calculateReward(_owner), rewardPerNode(), totalNodes, totalSupply());
358   }
359 
360 }
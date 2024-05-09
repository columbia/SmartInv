1 pragma solidity 0.4.24;
2 
3 interface IMintableToken {
4     function mint(address _to, uint256 _amount) public returns (bool);
5 }
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 contract Pausable is Ownable {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = false;
84 
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is not paused.
88    */
89   modifier whenNotPaused() {
90     require(!paused);
91     _;
92   }
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is paused.
96    */
97   modifier whenPaused() {
98     require(paused);
99     _;
100   }
101 
102   /**
103    * @dev called by the owner to pause, triggers stopped state
104    */
105   function pause() onlyOwner whenNotPaused public {
106     paused = true;
107     Pause();
108   }
109 
110   /**
111    * @dev called by the owner to unpause, returns to normal state
112    */
113   function unpause() onlyOwner whenPaused public {
114     paused = false;
115     Unpause();
116   }
117 }
118 
119 contract preICO is Ownable, Pausable {
120     event Approved(address _address, uint _tokensAmount);
121     event Declined(address _address, uint _tokensAmount);
122     event weiReceived(address _address, uint _weiAmount);
123     event RateChanged(uint _newRate);
124 
125     uint public constant startTime = 1529431200; // June, 19. 07:00 PM (UTC)
126     uint public endTime = 1532973600; // July, 30. 07:00 PM (UTC)
127     uint public rate;
128     uint public tokensHardCap = 10000000 * 1 ether; // 10 million tokens
129 
130     uint public tokensMintedDuringPreICO = 0;
131     uint public tokensToMintInHold = 0;
132 
133     mapping(address=>uint) public tokensHoldMap;
134 
135     IMintableToken public DXC;
136 
137     function preICO(address _DXC) {
138         DXC = IMintableToken(_DXC);
139     }
140 
141     /**
142     * @dev Handles incoming eth transfers
143     * and mints tokens to msg.sender
144     */
145     function () payable ongoingPreICO whenNotPaused {
146         uint tokensToMint = msg.value * rate;
147         tokensHoldMap[msg.sender] = SafeMath.add(tokensHoldMap[msg.sender], tokensToMint);
148         tokensToMintInHold = SafeMath.add(tokensToMintInHold, tokensToMint);
149         weiReceived(msg.sender, msg.value);
150     }
151 
152     /**
153     * @dev Approves token minting for specified investor
154     * @param _address Address of investor in `holdMap`
155     */
156     function approve(address _address) public onlyOwner capWasNotReached(_address) {
157         uint tokensAmount = tokensHoldMap[_address];
158         tokensHoldMap[_address] = 0;
159         tokensMintedDuringPreICO = SafeMath.add(tokensMintedDuringPreICO, tokensAmount);
160         tokensToMintInHold = SafeMath.sub(tokensToMintInHold, tokensAmount);
161         Approved(_address, tokensAmount);
162 
163         DXC.mint(_address, tokensAmount);
164     }
165 
166     /**
167     * @dev Declines token minting for specified investor
168     * @param _address Address of investor in `holdMap`
169     */
170     function decline(address _address) public onlyOwner {
171         tokensToMintInHold = SafeMath.sub(tokensToMintInHold, tokensHoldMap[_address]);
172         Declined(_address, tokensHoldMap[_address]);
173 
174         tokensHoldMap[_address] = 0;
175     }
176 
177     /**
178     * @dev Sets rate if it was not set earlier
179     * @param _rate preICO wei to tokens rate
180     */
181     function setRate(uint _rate) public onlyOwner {
182         rate = _rate;
183 
184         RateChanged(_rate);
185     }
186 
187     /**
188     * @dev Transfer specified amount of wei the owner
189     * @param _weiToWithdraw Amount of wei to transfer
190     */
191     function withdraw(uint _weiToWithdraw) public onlyOwner {
192         msg.sender.transfer(_weiToWithdraw);
193     }
194 
195     /**
196     * @dev Increases end time by specified amount of seconds
197     * @param _secondsToIncrease Amount of second to increase end time
198     */
199     function increaseDuration(uint _secondsToIncrease) public onlyOwner {
200         endTime = SafeMath.add(endTime, _secondsToIncrease);
201     }
202 
203     /**
204     * @dev Throws if crowdsale time is not started or finished
205     */
206     modifier ongoingPreICO {
207         require(now >= startTime && now <= endTime);
208         _;
209     }
210 
211     /**
212     * @dev Throws if preICO hard cap will be exceeded after minting
213     */
214     modifier capWasNotReached(address _address) {
215         require(SafeMath.add(tokensMintedDuringPreICO, tokensHoldMap[_address]) <= tokensHardCap);
216         _;
217     }
218 }
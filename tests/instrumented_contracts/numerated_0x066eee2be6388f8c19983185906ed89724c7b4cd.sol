1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract IRntToken {
34     uint256 public decimals = 18;
35 
36     uint256 public totalSupply = 1000000000 * (10 ** 18);
37 
38     string public name = "RNT Token";
39 
40     string public code = "RNT";
41 
42 
43     function balanceOf() public constant returns (uint256 balance);
44 
45     function transfer(address _to, uint _value) public returns (bool success);
46 
47     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
48 }
49 
50 contract RntToken is IRntToken {
51     using SafeMath for uint256;
52 
53     address public owner;
54 
55     /* The finalizer contract that allows unlift the transfer limits on this token */
56     address public releaseAgent;
57 
58     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
59     bool public released = false;
60 
61     /** Map of agents that are allowed to transfer tokens regardless of the lock down period.
62     These are crowdsale contracts and possible the team multisig itself. */
63     mapping (address => bool) public transferAgents;
64 
65     mapping (address => mapping (address => uint256)) public allowed;
66 
67     mapping (address => uint256) public balances;
68 
69     bool public paused = false;
70 
71     event Pause();
72 
73     event Unpause();
74 
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77     event Transfer(address indexed _from, address indexed _to, uint _value);
78 
79     function RntToken() payable {
80         require(msg.value == 0);
81         owner = msg.sender;
82         balances[msg.sender] = totalSupply;
83     }
84 
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     /**
91      * @dev Modifier to make a function callable only when the contract is not paused.
92      */
93     modifier whenNotPaused() {
94         require(!paused);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable only when the contract is paused.
100      */
101     modifier whenPaused() {
102         require(paused);
103         _;
104     }
105 
106     /**
107      * Limit token transfer until the crowdsale is over.
108      *
109      */
110     modifier canTransfer(address _sender) {
111         require(released || transferAgents[_sender]);
112         _;
113     }
114 
115     /** The function can be called only before or after the tokens have been releasesd */
116     modifier inReleaseState(bool releaseState) {
117         require(releaseState == released);
118         _;
119     }
120 
121     /** The function can be called only by a whitelisted release agent. */
122     modifier onlyReleaseAgent() {
123         require(msg.sender == releaseAgent);
124         _;
125     }
126 
127     /**
128      * Set the contract that can call release and make the token transferable.
129      *
130      * Design choice. Allow reset the release agent to fix fat finger mistakes.
131      */
132     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
133 
134         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
135         releaseAgent = addr;
136     }
137 
138     /**
139      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
140      */
141     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
142         transferAgents[addr] = state;
143     }
144 
145     /**
146      * One way function to release the tokens to the wild.
147      *
148      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
149      */
150     function releaseTokenTransfer() public onlyReleaseAgent {
151         released = true;
152     }
153 
154     function transfer(address _to, uint _value) public canTransfer(msg.sender) whenNotPaused returns (bool success) {
155         require(_to != address(0));
156 
157         // SafeMath.sub will throw if there is not enough balance.
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         Transfer(msg.sender, _to, _value);
161         return true;
162     }
163 
164     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) whenNotPaused returns (bool success) {
165         require(_to != address(0));
166 
167         uint256 _allowance = allowed[_from][msg.sender];
168 
169         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
170         // require (_value <= _allowance);
171 
172         balances[_from] = balances[_from].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         allowed[_from][msg.sender] = _allowance.sub(_value);
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      *
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param _spender The address which will spend the funds.
187      * @param _value The amount of tokens to be spent.
188      */
189     function approve(address _spender, uint256 _value) public returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      */
201     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 
205     /**
206     * @dev Gets the balance of the sender address.
207     * @return An uint256 representing the amount owned by the passed address.
208     */
209     function balanceOf() public constant returns (uint256 balance) {
210         return balances[msg.sender];
211     }
212 
213 
214     /*PAUSABLE FUNCTIONALITY*/
215 
216 
217     /**
218      * @dev called by the owner to pause, triggers stopped state
219      */
220     function pause() onlyOwner whenNotPaused public {
221         paused = true;
222         Pause();
223     }
224 
225     /**
226      * @dev called by the owner to unpause, returns to normal state
227      */
228     function unpause() onlyOwner whenPaused public {
229         paused = false;
230         Unpause();
231     }
232 
233     /*HAS NO ETHER FUNCTIONALITY*/
234     /**
235   * @dev Constructor that rejects incoming Ether
236   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
237   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
238   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
239   * we could use assembly to access msg.value.
240   */
241 
242     /**
243      * @dev Disallows direct send by settings a default function without the `payable` flag.
244      */
245     function() external {
246     }
247 }
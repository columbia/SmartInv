1 pragma solidity ^0.4.19;
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
70   function() public payable { }
71 }
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() public {
88     owner = msg.sender;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99    /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) public onlyOwner {
104     require(newOwner != address(0));
105     OwnershipTransferred(owner, newOwner);
106     owner = newOwner;
107   }
108 }
109 
110 contract ESCBAirdropper is Ownable {
111     using SafeMath for uint256;
112     uint256 public airdropTokens;
113     uint256 public totalClaimed;
114     uint256 public amountOfTokens;
115     mapping (address => bool) public tokensReceived;
116     mapping (address => bool) public craneList;
117     mapping (address => bool) public airdropAgent;
118     ERC20 public token;
119     bool public craneEnabled = false;
120 
121     modifier onlyAirdropAgent() {
122         require(airdropAgent[msg.sender]);
123          _;
124     }
125 
126     modifier whenCraneEnabled() {
127         require(craneEnabled);
128          _;
129     }
130 
131     function ESCBAirdropper(uint256 _amount, address _tokenAddress) public {
132         totalClaimed = 0;
133         amountOfTokens = _amount;
134         token = ERC20(_tokenAddress);
135     }
136 
137     // Send a static number of tokens to each user in an array (e.g. each user receives 100 tokens)
138     function airdrop(address[] _recipients) public onlyAirdropAgent {
139         for (uint256 i = 0; i < _recipients.length; i++) {
140             require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.
141             require(token.transfer(_recipients[i], amountOfTokens));
142             tokensReceived[_recipients[i]] = true;
143         }
144         totalClaimed = totalClaimed.add(amountOfTokens * _recipients.length);
145     }
146 
147     // Send a dynamic number of tokens to each user in an array (e.g. each user receives 10% of their original contribution)
148     function airdropDynamic(address[] _recipients, uint256[] _amount) public onlyAirdropAgent {
149         for (uint256 i = 0; i < _recipients.length; i++) {
150             require(!tokensReceived[_recipients[i]]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.
151             require(token.transfer(_recipients[i], _amount[i]));
152             tokensReceived[_recipients[i]] = true;
153             totalClaimed = totalClaimed.add(_amount[i]);
154         }
155     }
156 
157     // Allow this agent to call the airdrop functions
158     function setAirdropAgent(address _agentAddress, bool state) public onlyOwner {
159         airdropAgent[_agentAddress] = state;
160     }
161 
162     // Return any unused tokens back to the contract owner
163     function reset() public onlyOwner {
164         require(token.transfer(owner, remainingTokens()));
165     }
166 
167     // Change the ERC20 token address
168     function changeTokenAddress(address _tokenAddress) public onlyOwner {
169         token = ERC20(_tokenAddress);
170     }
171 
172     // Set the amount of tokens to send each user for a static airdrop
173     function changeTokenAmount(uint256 _amount) public onlyOwner {
174         amountOfTokens = _amount;
175     }
176 
177     // Enable or disable crane
178     function changeCraneStatus(bool _status) public onlyOwner {
179         craneEnabled = _status;
180     }
181 
182     // Return the amount of tokens that the contract currently holds
183     function remainingTokens() public view returns (uint256) {
184         return token.balanceOf(this);
185     }
186 
187     // Add recipient in crane list
188     function addAddressToCraneList(address[] _recipients) public onlyAirdropAgent {
189         for (uint256 i = 0; i < _recipients.length; i++) {
190             require(!tokensReceived[_recipients[i]]); // If not received yet
191             require(!craneList[_recipients[i]]);
192             craneList[_recipients[i]] = true;
193         }
194     }
195 
196     // Get free tokens by crane
197     function getFreeTokens() public
198       whenCraneEnabled
199     {
200         require(craneList[msg.sender]);
201         require(!tokensReceived[msg.sender]); // Probably a race condition between two transactions. Bail to avoid double allocations and to save the gas.
202         require(token.transfer(msg.sender, amountOfTokens));
203         tokensReceived[msg.sender] = true;
204         totalClaimed = totalClaimed.add(amountOfTokens);
205     }
206 
207 }
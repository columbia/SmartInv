1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 }
76 
77 contract Destructible is Ownable {
78 
79   function Destructible() public payable { }
80 
81   /**
82    * @dev Transfers the current balance to the owner and terminates the contract.
83    */
84   function destroy() onlyOwner public {
85     selfdestruct(owner);
86   }
87 
88   function destroyAndSend(address _recipient) onlyOwner public {
89     selfdestruct(_recipient);
90   }
91 }
92 
93 contract Pausable is Ownable {
94 	event Pause();
95 	event Unpause();
96 
97 	bool public paused = false;
98 
99 
100 	/**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103 	modifier whenNotPaused() {
104 		require(!paused);
105 		_;
106 	}
107 
108 	/**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111 	modifier whenPaused() {
112 		require(paused);
113 		_;
114 	}
115 
116 	/**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119 	function pause() onlyOwner whenNotPaused public {
120 		paused = true;
121 		Pause();
122 	}
123 
124 	/**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127 	function unpause() onlyOwner whenPaused public {
128 		paused = false;
129 		Unpause();
130 	}
131 }
132 
133 contract CryptoLambos is Pausable, Destructible {
134   using SafeMath for uint256;
135 
136   struct Lambo {
137     string  model;
138     address ownerAddress;
139     uint256 price;
140     bool    enabled;
141     string  nickname;
142     string  note;
143   }
144 
145   Lambo[] public lambos;
146 
147   event Bought(uint256 id, string model, address indexed ownerAddress, uint256 price, string nickname, string note);
148   event Added(uint256 id, string model, address indexed ownerAddress, uint256 price, bool enabled);
149   event Enabled(uint256 id);
150 
151   function CryptoLambos() public { }
152 
153   function _calcNextPrice(uint256 _price) internal pure returns(uint256) {
154     return _price
155       .mul(13).div(10) // Add 30%
156       .div(1 finney).mul(1 finney); // Round to 1 finney
157   }
158 
159   function buy(uint256 _id, string _nickname, string _note) public payable whenNotPaused {
160     Lambo storage _lambo = lambos[_id];
161 
162     require(_lambo.enabled);
163     require(msg.value  >= _lambo.price);
164     require(msg.sender != _lambo.ownerAddress);
165     require(bytes(_nickname).length <= 50);
166     require(bytes(_note).length <= 100);
167 
168     uint256 _price      = _lambo.price;
169     uint256 _commission = _price.div(20);
170     uint256 _payout     = _price - _commission;
171     address _prevOwner  = _lambo.ownerAddress;
172     uint256 _newPrice   = _calcNextPrice(_price);
173 
174     if (bytes(_lambo.nickname).length > 0) {
175       delete _lambo.nickname;
176     }
177     
178     if (bytes(_lambo.note).length > 0) {
179       delete _lambo.note;
180     }
181     
182     _lambo.ownerAddress = msg.sender;
183     _lambo.price        = _newPrice;
184     _lambo.nickname     = _nickname;
185     _lambo.note         = _note;
186 
187     owner.transfer(_commission);
188     _prevOwner.transfer(_payout);
189 
190     Bought(_id, _lambo.model, _lambo.ownerAddress, _lambo.price, _lambo.nickname, _lambo.note);
191   }
192 
193   function getLambosCount() public view returns (uint256) {
194     return lambos.length;
195   }
196 
197   function enableLambo(uint256 _id) public whenNotPaused onlyOwner {
198     require(!lambos[_id].enabled);
199 
200     lambos[_id].enabled = true;
201 
202     Enabled(_id);
203   }
204 
205   function addLambo(string _model, uint256 _price, bool _enabled) public whenNotPaused onlyOwner {
206     lambos.push(Lambo(_model, owner, _price, _enabled, "Crypto_Lambos", "Look ma! A Lambo!"));
207 
208     Added(lambos.length, _model, owner, _price, _enabled);
209   }
210 
211   function withdrawAll() public onlyOwner {
212     owner.transfer(this.balance);
213   }
214 }
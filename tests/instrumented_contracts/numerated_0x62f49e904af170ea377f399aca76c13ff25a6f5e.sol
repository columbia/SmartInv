1 pragma solidity ^0.5.0;
2 
3 // This contract is still in Beta, use at your own risk
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 
63 interface Token {
64 
65     function transfer(address _to, uint _value) external returns (bool);
66     function transferFrom(address _from, address _to, uint _value) external returns (bool);
67     function approve(address _spender, uint _value) external returns (bool);
68     function balanceOf(address _owner) external view returns (uint);
69     function allowance(address _owner, address _spender) external view returns (uint);
70 
71     event Transfer(address indexed _from, address indexed _to, uint _value); // solhint-disable-line
72     event Approval(address indexed _owner, address indexed _spender, uint _value);
73 }
74 
75 contract TrustlessOTC is Ownable {
76     
77     mapping(address => uint256) public balanceTracker;
78     
79     event OfferCreated(uint indexed tradeID);
80     event OfferCancelled(uint indexed tradeID);
81     event OfferTaken(uint indexed tradeID);
82     
83     struct TradeOffer {
84         address tokenFrom;
85         address tokenTo;
86         uint256 amountFrom;
87         uint256 amountTo;
88         address creator;
89         bool active;
90         uint tradeID;
91     }
92     
93     TradeOffer[] public offers;
94     
95     function initiateTrade(
96         address _tokenFrom,
97         address _tokenTo, 
98         uint256 _amountFrom,
99         uint256 _amountTo
100         ) public returns (uint newTradeID) {
101             require(Token(_tokenFrom).transferFrom(msg.sender, address(this), _amountFrom));
102             newTradeID = offers.length;
103             offers.length++;
104             TradeOffer storage o = offers[newTradeID];
105             balanceTracker[_tokenFrom] += _amountFrom;
106             o.tokenFrom = _tokenFrom;
107             o.tokenTo = _tokenTo;
108             o.amountFrom = _amountFrom;
109             o.amountTo = _amountTo;
110             o.creator = msg.sender;
111             o.active = true;
112             o.tradeID = newTradeID;
113             emit OfferCreated(newTradeID);
114     }
115     
116     function cancelTrade(uint tradeID) public returns (bool) {
117         TradeOffer storage o = offers[tradeID];
118         require(msg.sender == o.creator);
119         require(Token(o.tokenFrom).transfer(o.creator, o.amountFrom));
120         balanceTracker[o.tokenFrom] -= o.amountFrom;
121         o.active = false;
122         emit OfferCancelled(tradeID);
123         return true;
124     }
125     
126     function take(uint tradeID) public returns (bool) {
127         TradeOffer storage o = offers[tradeID];
128         require(o.active == true);
129         require(Token(o.tokenFrom).transfer(msg.sender, o.amountFrom));
130         balanceTracker[o.tokenFrom] -= o.amountFrom;
131         require(Token(o.tokenTo).transferFrom(msg.sender, o.creator, o.amountTo));
132         o.active = false;
133         emit OfferTaken(tradeID);
134         return true;
135     }
136     
137     function getOfferDetails(uint tradeID) external view returns (
138         address _tokenFrom,
139         address _tokenTo, 
140         uint256 _amountFrom,
141         uint256 _amountTo,
142         address _creator,
143         bool _active
144     ) {
145         TradeOffer storage o = offers[tradeID];
146         _tokenFrom = o.tokenFrom;
147         _tokenTo = o.tokenTo;
148         _amountFrom = o.amountFrom;
149         _amountTo = o.amountTo;
150         _creator = o.creator;
151         _active = o.active;
152     }
153 
154     
155     function reclaimToken(Token _token) external onlyOwner {
156         uint256 balance = _token.balanceOf(address(this));
157         uint256 excess = balance - balanceTracker[address(_token)];
158         require(excess > 0);
159         _token.transfer(owner, excess);
160     }
161     
162     
163 }
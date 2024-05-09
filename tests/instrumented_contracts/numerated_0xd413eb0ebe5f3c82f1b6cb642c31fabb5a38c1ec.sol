1 pragma solidity ^0.4.15;
2 
3 contract Base {
4 
5     modifier only(address allowed) {
6         require(msg.sender == allowed);
7         _;
8     }
9 
10     // *************************************************
11     // *          reentrancy handling                  *
12     // *************************************************
13     uint private bitlocks = 0;
14 
15     modifier noAnyReentrancy {
16         var _locks = bitlocks;
17         require(_locks == 0);
18         bitlocks = uint(-1);
19         _;
20         bitlocks = _locks;
21     }
22 }
23 
24 contract TokenTimeLock {
25 
26     IToken public token;
27     address public beneficiary;
28     uint public releaseTimeFirst;
29     uint public amountFirst;
30 
31     function TokenTimeLock(IToken _token, address _beneficiary, uint _releaseTimeFirst, uint _amountFirst)
32     public
33     {
34         require(_releaseTimeFirst > now);
35         token = _token;
36         beneficiary = _beneficiary;
37         releaseTimeFirst = _releaseTimeFirst;
38         amountFirst = _amountFirst;
39     }
40 
41     function releaseFirst() public {
42         require(now >= releaseTimeFirst);
43         uint amount = token.balanceOf(this);
44         require(amount > 0 && amount >= amountFirst);
45         token.transfer(beneficiary, amountFirst);
46     }
47 }
48 
49 contract IToken {
50     function mint(address _to, uint _amount) public;
51     function start() public;
52     function getTotalSupply()  public returns(uint);
53     function balanceOf(address _owner)  public returns(uint);
54     function transfer(address _to, uint _amount)  public returns (bool success);
55     function transferFrom(address _from, address _to, uint _value)  public returns (bool success);
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 contract Owned is Base {
87     address public owner;
88     address newOwner;
89 
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94     function transferOwnership(address _newOwner) public only(owner) {
95         newOwner = _newOwner;
96     }
97 
98     function acceptOwnership() public only(newOwner) {
99         OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101     }
102 
103     event OwnershipTransferred(address indexed _from, address indexed _to);
104 }
105 
106 contract ATFSCrowdsale is Owned
107 {
108 
109     using SafeMath for uint;
110 
111     //
112     //
113     enum State { INIT, ICO, TOKEN_DIST, CLOSED, EMERGENCY_STOP }
114 
115     uint public constant MAX_SALE_SUPPLY 		= 35 * (10**15);
116     uint public constant MAX_NON_SALE_SUPPLY 	= 18 * (10**15);
117 
118     State public currentState = State.INIT;
119 
120     IToken public token;
121 
122     uint public totalSaleSupply 	= 0;
123     uint public totalNonSaleSupply 	= 0;
124 
125     mapping( address => TokenTimeLock ) lockBalances;
126 
127     modifier inState( State _state ) {
128         require(currentState == _state);
129         _;
130     }
131 
132     modifier inICOExtended( ) {
133         require( currentState == State.ICO || currentState == State.TOKEN_DIST );
134         _;
135     }
136 
137     //
138 	// constructor
139 	//
140   //
141   // constructor
142   //
143   function ATFSCrowdsale( ) public {
144   }
145 
146   function setToken( IToken _token ) public only( owner ) {
147     require( _token != address( 0 ) );
148       token = _token;
149     }
150 
151     //
152     // change state
153     //
154     // no chance to recover from EMERGENY_STOP ( just never do that ?? )
155     //
156     function setState( State _newState ) public only(owner)
157     {
158         require(
159            ( currentState == State.INIT && _newState == State.ICO )
160         || ( currentState == State.ICO && _newState == State.TOKEN_DIST )
161         || ( currentState == State.TOKEN_DIST && _newState == State.CLOSED )
162         || _newState == State.EMERGENCY_STOP
163         );
164         currentState = _newState;
165         if( _newState == State.CLOSED ) {
166             _finish( );
167         }
168     }
169 
170     //
171     // mint to investor ( sale )
172     //
173     function mintInvestor( address _to, uint _amount ) public only(owner) inState( State.TOKEN_DIST )
174     {
175      	require( totalSaleSupply.add( _amount ) <= MAX_SALE_SUPPLY );
176         totalSaleSupply = totalSaleSupply.add( _amount );
177         _mint( _to, _amount );
178     }
179 
180     //
181     // mint to partner ( non-sale )
182     //
183     function mintPartner( address _to, uint _amount ) public only( owner ) inState( State.TOKEN_DIST )
184     {
185     	require( totalNonSaleSupply.add( _amount ) <= MAX_NON_SALE_SUPPLY );
186     	totalNonSaleSupply = totalNonSaleSupply.add( _amount );
187     	_mint( _to, _amount );
188     }
189 
190     //
191     // mint to partner with lock ( non-sale )
192     //
193     // [caution] do not mint again before token-receiver retrieves the previous tokens
194     //
195     function mintPartnerWithLock( address _to, uint _amount, uint _unlockDate ) public only( owner ) inICOExtended( )
196     {
197     	require( totalNonSaleSupply.add( _amount ) <= MAX_NON_SALE_SUPPLY );
198         totalNonSaleSupply = totalNonSaleSupply.add( _amount );
199 
200         TokenTimeLock tokenTimeLock = new TokenTimeLock( token, _to, _unlockDate, _amount );
201         lockBalances[_to] = tokenTimeLock;
202         _mint( address(tokenTimeLock), _amount );
203     }
204 
205     function unlockAccount( ) public inState( State.CLOSED )
206     {
207         require( address( lockBalances[msg.sender] ) != 0 );
208         lockBalances[msg.sender].releaseFirst();
209     }
210 
211     //
212     // mint to private investor ( sale, ICO )
213     //
214     function mintPrivate( address _to, uint _amount ) public only( owner ) inState( State.ICO )
215     {
216     	require( totalSaleSupply.add( _amount ) <= MAX_SALE_SUPPLY );
217     	totalSaleSupply = totalSaleSupply.add( _amount );
218     	_mint( _to, _amount );
219     }
220 
221     //
222     // internal function
223     //
224     function _mint( address _to, uint _amount ) noAnyReentrancy internal
225     {
226         token.mint( _to, _amount );
227     }
228 
229     function _finish( ) noAnyReentrancy internal
230     {
231         token.start( );
232     }
233 }
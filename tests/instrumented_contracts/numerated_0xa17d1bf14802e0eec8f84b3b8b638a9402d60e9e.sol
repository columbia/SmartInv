1 pragma solidity ^0.4.10;
2 
3 contract IERC20Token {
4     function totalSupply() public constant returns ( uint256 supply ) { supply; }
5     function balanceOf( address _owner ) public constant returns ( uint256 balance ) { _owner; balance; }
6     function allowance( address _owner, address _spender ) public constant returns ( uint256 remaining ) { _owner; _spender; remaining; }
7 
8   function transfer( address _to, uint256 _value ) public returns ( bool success );
9   function transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success );
10   function approve( address _spender, uint256 _value ) public returns ( bool success );
11 }
12 contract RegaUtils {
13   modifier validAddress( address _address ) {
14     require( _address != 0x0 );
15     _;
16   }
17 
18   // Overflow checked math
19   function safeAdd( uint256 x, uint256 y ) internal returns( uint256 ) {
20     uint256 z = x + y;
21     assert( z >= x );
22     return z;
23   }
24 
25   function safeSub( uint256 x, uint256 y ) internal returns( uint256 ) {
26     assert( x >= y);
27     return x - y;
28   }
29 }
30 contract ERC20Token is IERC20Token, RegaUtils {
31   uint256 public totalSupply = 0;
32   mapping( address => uint256 ) public balanceOf;
33   mapping( address => mapping( address => uint256 ) ) public allowance;
34 
35   event Transfer( address indexed _from, address indexed _to, uint256 _value );
36   event Approval( address indexed _owner, address indexed _spender, uint256 _value );
37 
38   function transfer( address _to, uint256 _value ) validAddress( _to )
39     returns( bool success )
40   {
41     balanceOf[ msg.sender ] = safeSub( balanceOf[ msg.sender ], _value );
42     balanceOf[ _to ] = safeAdd( balanceOf[ _to ], _value );
43     Transfer( msg.sender, _to, _value );
44     return true;
45   }
46 
47   function transferFrom( address _from, address _to, uint256 _value ) validAddress( _from ) validAddress( _to )
48     returns( bool success )
49   {
50     allowance[ _from ][ msg.sender ] = safeSub( allowance[ _from ][ msg.sender ], _value );
51     balanceOf[ _from] = safeSub( balanceOf[_from], _value );
52     balanceOf[ _to] = safeAdd( balanceOf[_to], _value );
53     Transfer( _from, _to, _value );
54     return true;
55   }
56 
57   function approve( address _spender, uint256 _value ) validAddress( _spender )
58     returns( bool success)
59   {
60     require( _value == 0 || allowance[ msg.sender ][ _spender ] == 0 );
61 
62     allowance[ msg.sender ][ _spender ] = _value;
63     Approval( msg.sender, _spender, _value );
64     return true;
65   }
66 
67 }
68 contract RSTBase is ERC20Token {
69   address public board;
70   address public owner;
71 
72   address public votingData;
73   address public tokenData;
74   address public feesData;
75 
76   uint256 public reserve;
77   uint32  public crr;         // per cent
78   uint256 public weiForToken; // current rate
79   uint8   public totalAccounts;
80 
81   modifier boardOnly() {
82     require(msg.sender == board);
83     _;
84   }
85 }
86 contract TokenControllerBase is RSTBase {
87   function init() public;
88   function isSellOpen() public constant returns(bool);
89   function isBuyOpen() public constant returns(bool);
90   function sell(uint value) public;
91   function buy() public payable;
92   function addToReserve() public payable;
93 }
94 
95 contract VotingControllerBase is RSTBase {
96   function voteFor() public;
97   function voteAgainst() public;
98   function startVoting() public;
99   function stopVoting() public;
100   function getCurrentVotingDescription() public constant returns (bytes32 vd) ;
101 }
102 
103 contract FeesControllerBase is RSTBase {
104   function init() public;
105   function withdrawFee() public;
106   function calculateFee() public;
107   function addPayee( address payee ) public;
108   function removePayee( address payee ) public;
109   function setRepayment( ) payable public;
110 }
111 contract RiskSharingToken is RSTBase {
112   string public constant version = "0.1";
113   string public constant name = "REGA Risk Sharing Token";
114   string public constant symbol = "RST";
115   uint8 public constant decimals = 10;
116 
117   TokenControllerBase public tokenController;
118   VotingControllerBase public votingController;
119   FeesControllerBase public feesController;
120 
121   modifier ownerOnly() {
122     require( msg.sender == owner );
123     _;
124   }
125 
126   modifier boardOnly() {
127     require( msg.sender == board );
128     _;
129   }
130 
131   modifier authorized() {
132     require( msg.sender == owner || msg.sender == board);
133     _;
134   }
135 
136 
137   function RiskSharingToken( address _board ) {
138     board = _board;
139     owner = msg.sender;
140     tokenController = TokenControllerBase(0);
141     votingController = VotingControllerBase(0);
142     weiForToken = uint(10)**(18-1-decimals); // 0.1 Ether
143     reserve = 0;
144     crr = 20;
145     totalAccounts = 0;
146   }
147 
148   function() payable {
149 
150   }
151 
152   function setTokenController( TokenControllerBase tc, address _tokenData ) public boardOnly {
153     tokenController = tc;
154     if( _tokenData != address(0) )
155       tokenData = _tokenData;
156     if( tokenController != TokenControllerBase(0) )
157       if( !tokenController.delegatecall(bytes4(sha3("init()"))) )
158         revert();
159   }
160 
161 // Voting
162   function setVotingController( VotingControllerBase vc ) public boardOnly {
163     votingController = vc;
164   }
165 
166   function startVoting( bytes32 /*description*/ ) public boardOnly validAddress(votingController) {
167     if( !votingController.delegatecall(msg.data) )
168       revert();
169   }
170 
171   function stopVoting() public boardOnly validAddress(votingController) {
172     if( !votingController.delegatecall(msg.data) )
173       revert();
174   }
175 
176   function voteFor() public validAddress(votingController) {
177     if( !votingController.delegatecall(msg.data) )
178       revert();
179   }
180 
181   function voteAgainst() public validAddress(votingController) {
182     if( !votingController.delegatecall(msg.data) )
183       revert();
184   }
185 
186 // Tokens operations
187   function buy() public payable validAddress(tokenController) {
188     if( !tokenController.delegatecall(msg.data) )
189       revert();
190   }
191 
192   function sell( uint /*value*/ ) public validAddress(tokenController) {
193     if( !tokenController.delegatecall(msg.data) )
194       revert();
195   }
196 
197   function addToReserve( ) public payable validAddress(tokenController) {
198     if( !tokenController.delegatecall(msg.data) )
199       revert();
200   }
201 
202 // some amount ma be not the reserve
203   function withdraw( uint256 amount ) public boardOnly {
204     require(safeSub(this.balance, amount) >= reserve);
205     board.transfer( amount );
206   }
207 
208   function issueToken( address /*holder*/, uint256 /*amount*/ ) public authorized {
209     if( !tokenController.delegatecall(msg.data) )
210       revert();
211   }
212 
213   function issueTokens( uint256[] /*data*/ ) public ownerOnly {
214     if( !tokenController.delegatecall(msg.data) )
215       revert();
216   }
217 
218   // fees operations
219 
220   function setFeesController( FeesControllerBase fc ) public boardOnly {
221     feesController = fc;
222     if( !feesController.delegatecall(bytes4(sha3("init()"))) )
223       revert();
224   }
225 
226   function withdrawFee() public validAddress(feesController) {
227       if( !feesController.delegatecall(msg.data) )
228         revert();
229   }
230 
231   function calculateFee() public validAddress(feesController) {
232       if( !feesController.delegatecall(msg.data) )
233         revert();
234   }
235   function addPayee( address /*payee*/ ) public validAddress(feesController) {
236       if( !feesController.delegatecall(msg.data) )
237         revert();
238   }
239   function removePayee( address /*payee*/ ) public validAddress(feesController) {
240       if( !feesController.delegatecall(msg.data) )
241         revert();
242   }
243   function setRepayment( ) payable public validAddress(feesController) {
244       if( !feesController.delegatecall(msg.data) )
245         revert();
246   }
247 }
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
12 
13 contract RegaUtils {
14   modifier validAddress( address _address ) {
15     require( _address != 0x0 );
16     _;
17   }
18 
19   // Overflow checked math
20   function safeAdd( uint256 x, uint256 y ) internal returns( uint256 ) {
21     uint256 z = x + y;
22     assert( z >= x );
23     return z;
24   }
25 
26   function safeSub( uint256 x, uint256 y ) internal returns( uint256 ) {
27     assert( x >= y);
28     return x - y;
29   }
30 }
31 
32 contract ERC20Token is IERC20Token, RegaUtils {
33   uint256 public totalSupply = 0;
34   mapping( address => uint256 ) public balanceOf;
35   mapping( address => mapping( address => uint256 ) ) public allowance;
36 
37   event Transfer( address indexed _from, address indexed _to, uint256 _value );
38   event Approval( address indexed _owner, address indexed _spender, uint256 _value );
39 
40   function transfer( address _to, uint256 _value ) validAddress( _to )
41     returns( bool success )
42   {
43     balanceOf[ msg.sender ] = safeSub( balanceOf[ msg.sender ], _value );
44     balanceOf[ _to ] = safeAdd( balanceOf[ _to ], _value );
45     Transfer( msg.sender, _to, _value );
46     return true;
47   }
48 
49   function transferFrom( address _from, address _to, uint256 _value ) validAddress( _from ) validAddress( _to )
50     returns( bool success )
51   {
52     allowance[ _from ][ msg.sender ] = safeSub( allowance[ _from ][ msg.sender ], _value );
53     balanceOf[ _from] = safeSub( balanceOf[_from], _value );
54     balanceOf[ _to] = safeAdd( balanceOf[_to], _value );
55     Transfer( _from, _to, _value );
56     return true;
57   }
58 
59   function approve( address _spender, uint256 _value ) validAddress( _spender )
60     returns( bool success)
61   {
62     require( _value == 0 || allowance[ msg.sender ][ _spender ] == 0 );
63 
64     allowance[ msg.sender ][ _spender ] = _value;
65     Approval( msg.sender, _spender, _value );
66     return true;
67   }
68 
69 }
70 
71 contract IApplyPreICO {
72   function applyTokens( address owner, uint tokens );
73 }
74 
75 contract PreICOToken is ERC20Token {
76 
77   string public constant name = "REGA Risk Sharing preICO Token";
78   string public constant symbol = "RST-P";
79   uint8 public constant decimals = 10;
80 
81   address public board;
82   address public owner;
83   uint public weiForToken;
84   uint public notMoreThan;
85   uint public notLessThan;
86   uint public tokensLimit;
87   uint public totalEther = 0;
88   address[] public holders;
89   bool public closed;
90   IApplyPreICO public rst;
91 
92   event Issuance( address _to, uint _tokens, uint _amount, uint _sentBack );
93 
94   modifier ownerOnly() {
95     require( msg.sender == owner );
96     _;
97   }
98 
99   modifier boardOnly() {
100     require( msg.sender == board );
101     _;
102   }
103 
104   modifier opened() {
105     require(!closed && weiForToken > 0 && totalSupply < tokensLimit);
106     _;
107   }
108 
109   function PreICOToken( address _board ) {
110     board = _board;
111     owner = msg.sender;
112     weiForToken = 5 * uint(10)**(18-2-decimals); // 0.05 Ether
113     notMoreThan = 700 * uint(10)**decimals;
114     notLessThan = 100 * uint(10)**decimals;
115     tokensLimit = 30000 * uint(10)**decimals;
116     closed = true;
117   }
118 
119   function() payable opened {
120       issueInternal( msg.sender, msg.value, true );
121   }
122 
123   function setNotMoreThan( uint _notMoreThan ) public boardOnly {
124     notMoreThan = _notMoreThan * uint(10)**decimals;
125   }
126 
127   function setNotLessThan( uint _notLessThan ) public boardOnly {
128     notLessThan = _notLessThan * uint(10)**decimals;
129   }
130 
131   function setTokensLimit( uint _limit ) public boardOnly {
132     tokensLimit = _limit * uint(10)**decimals;
133   }
134 
135   function setOpen( bool _open ) public boardOnly {
136     closed = !_open;
137   }
138 
139   function setRST( IApplyPreICO _rst ) public boardOnly {
140     closed = true;
141     rst = _rst;
142   }
143 
144   function getHoldersCount() public constant returns (uint count) {
145     count = holders.length;
146   }
147 
148   function issue(address to, uint256 amount) public boardOnly validAddress(to) {
149     issueInternal( to, amount, false );
150   }
151 
152   function buy() public payable opened {
153     issueInternal( msg.sender, msg.value, true );
154   }
155 
156   function withdraw( uint amount ) public boardOnly {
157     board.transfer( amount );
158   }
159 
160   function issueInternal(address to, uint256 amount, bool returnExcess) internal {
161     uint tokens = amount / weiForToken;
162     require( weiForToken > 0 && safeAdd(totalSupply, tokens) < tokensLimit && (balanceOf[to] < notMoreThan || notMoreThan == 0) && safeAdd(balanceOf[to], tokens) >= notLessThan );
163     uint sendBack = 0;
164     if( notMoreThan > 0 && safeAdd(balanceOf[to], tokens) > notMoreThan ) {
165       tokens = notMoreThan - balanceOf[to];
166       sendBack = amount - tokens * weiForToken;
167     }
168 
169     totalEther = safeAdd(totalEther, amount - sendBack);
170     balanceOf[to] = safeAdd(balanceOf[to], tokens);
171     totalSupply = safeAdd(totalSupply, tokens);
172     holders.push(to);
173     if( returnExcess && sendBack > 0 && sendBack < amount )
174       to.transfer( sendBack );
175     Issuance(to, tokens, amount, returnExcess ? sendBack : 0);
176     Transfer( this, to, tokens );
177   }
178 
179   function moveToRST() validAddress(rst) {
180     sendToRstForAddress( msg.sender );
181   }
182 
183   function sendToRST( address from ) validAddress(rst) {
184     sendToRstForAddress( from );
185   }
186 
187   function sendToRstForAddress( address from ) internal {
188     require( closed );
189     uint amount = balanceOf[from];
190     if( amount > 0 ) {
191       balanceOf[from] = 0;
192       rst.applyTokens( from, amount );
193       Transfer( from, rst, amount );
194     }
195   }
196 }
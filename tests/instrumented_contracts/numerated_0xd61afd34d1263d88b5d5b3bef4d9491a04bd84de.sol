1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // @Project Korea Locate Election Event
5 // @Creator Block-Packer Crew *BP_Ryu*
6 // ----------------------------------------------------------------------------
7 
8 // ----------------------------------------------------------------------------
9 // @Name SafeMath
10 // @Desc Math operations with safety checks that throw on error
11 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
12 // ----------------------------------------------------------------------------
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 // ----------------------------------------------------------------------------
58 // ERC Token Standard #20 Interface
59 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function totalSupply() public constant returns (uint);
63     function balanceOf(address tokenOwner) public constant returns (uint balance);
64     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 // ----------------------------------------------------------------------------
73 // @Name Lockable
74 // @Desc Admin Lock
75 // ----------------------------------------------------------------------------
76 contract Lockable {
77     bool public    m_bIsLock;
78     address public m_aOwner;
79 
80     modifier IsOwner {
81         require(m_aOwner == msg.sender);
82         _;
83     }
84 
85     modifier AllLock {
86         require(!m_bIsLock);
87         _;
88     }
89 
90     constructor() public {
91         m_bIsLock   = false;
92         m_aOwner    = msg.sender;
93     }
94 }
95 // ----------------------------------------------------------------------------
96 // @Name TokenBase
97 // @Desc ERC20-based token
98 // ----------------------------------------------------------------------------
99 contract TokenBase is ERC20Interface, Lockable {
100     using SafeMath for uint;
101 
102     uint                                                _totalSupply;
103     mapping(address => uint256)                         _balances;
104     mapping(address => mapping(address => uint256))     _allowed;
105 
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address tokenOwner) public constant returns (uint balance) {
111         return _balances[tokenOwner];
112     }
113 
114     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
115         return _allowed[tokenOwner][spender];
116     }
117 
118     function transfer(address to, uint tokens) public returns (bool success) {
119         return false;
120     }
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         return false;
124     }
125 
126     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127         return false;
128     }
129 }
130 // ----------------------------------------------------------------------------
131 // @Name KLEToken
132 // @Desc Token name     : 2018 지방선거 참여자
133 //       Token Symbol   : KLEV18
134 //                      (Korea Locate Election Voter 2018)
135 //
136 //       Token Name     : 2018 지방선거 홍보왕
137 //       Token Symbol   : KLEH18
138 //                      (Korea Locate Election Honorary 2018)
139 //
140 //       Token Name     : 2018 지방선거 후원자
141 //       Token Symbol   : KLES18
142 //                      (Korea Locate Election Sponsor 2018)
143 // ----------------------------------------------------------------------------
144 contract KLEToken is TokenBase {
145     string  public   name;
146     uint8   public   decimals;
147     string  public   symbol;
148 
149     constructor (uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {
150         m_aOwner = msg.sender;
151         
152         _totalSupply = a_totalSupply;
153         _balances[msg.sender] = a_totalSupply;
154 
155         name = a_tokenName;
156         symbol = a_tokenSymbol;
157         decimals = a_decimals;
158     }
159 
160     // Allocate tokens
161     function AllocateToken(address[] a_receiver)
162     external
163     IsOwner
164     AllLock {
165         uint receiverLength = a_receiver.length;
166         
167         for(uint ui = 0; ui < receiverLength; ui++){
168             _balances[a_receiver[ui]]++;
169         }
170         
171         _totalSupply = _totalSupply.add(receiverLength);
172     }
173     
174     // Burn tokens
175     function BurnToken(address[] a_receiver)
176     external
177     IsOwner
178     AllLock {
179         uint receiverLength = a_receiver.length;
180         uint excess = 0;
181 
182         for(uint ui = 0; ui < receiverLength; ui++){
183             uint balance = _balances[a_receiver[ui]];
184             
185             if(2 <= balance)
186             {
187                 excess = balance - 1;
188                 _balances[a_receiver[ui]] = _balances[a_receiver[ui]].sub(excess);
189                 _totalSupply = _totalSupply.sub(excess);
190             }
191         }
192     }
193 
194     function EndEvent(bool a_bIsLock)
195     external
196     IsOwner {
197         m_bIsLock = a_bIsLock;
198     }
199 }
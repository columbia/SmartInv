1 /*
2 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OxdoollccccclodkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kdlc;'..      .,:loxkk0KXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKkoc,..        .':ox0XNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOd:'.          .;lxKNWMMMMMMMMMMMMMMMWWNNNNNNNNWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo:.           .,lkXWMMMMMMMMMWXKOxddol:;;,''.....'',,;:cldxO0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXxc'            .;d0NMMMMMMMWXOxl:,..                            ..,:ldOKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXx:.            .;dKWMMMMMWN0dc,.                                          .,cdOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkc.             'l0NMMMMMN0d:'.                                                   .:d0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMW0o'             .;xXMMMMMNOo,.              .....''',,'''....                           .'lkXWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMNOc.             .:kNMMMMW0o,         ..,:loxk0KKXXNNNWWWNNNNXKK0kxol:,..                      .cONMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMNk;.             .;ONMMMMXx;.      .,cdkKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOdc;.                    ,oKWMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMNk;               ,kNMMMW0l.     ':dOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOd:'                  .cOWMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMWO:               .dXMMMW0c.   .;oONWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo;.                .:ONMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMWKc.               :0WMMWKl.  .;dKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNWMMMMMMMMMMWKx:.               .:OWMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMNx.               .dNMMMXd.  ,o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kxOXWMMMMMMMMWKd;.              .cKWMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMW0:                ,OWMMWO, .:kNMMMMMMMMMMMMMMMMMMMMMMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMWXxc,:d0NMMMMMMMMNOc.              .xNMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMNx.                :KMMMXo..c0WMMMMMMMMMMMMMMMMMMMMXxl:;,;;:codkKNMMMMMMMMMMMMMMMMMMMMMMNk;..,o0WMMMMMMMWKo.              :KMMMMMMMMMMMMM
20 MMMMMMMMMMMMXl.                cXMMW0:.c0WMMMMMMMMMMMMWWNNXXXNNWXd'..;;'..   .,lkNMMW00NMMMMMMMMMMMMMMMNk;  .;dKWMMMMMMWKo.             'kWMMMMMMMMMMM
21 MMMMMMMMMMMK:                 cXMMWk;;OWMMMMMMMMMN0xoc;,'.....';cll'.oKNX0xol,   ,xXNc.,xXMMMMMMMMMMMMMMMNx'   .l0WMMMMMMWKl.            .dNMMMMMMMMMM
22 MMMMMMMMMM0;                 cXMMWk:dXMMMMMMMMW0o,.  ..,:clllllcc:;,..;0WMMMMNO:.  ;Ol.  ;0MMMMMMMMMMMMMMMMXl.   .:OWMMMMMMWO;            .lNMMMMMMMMM
23 MMMMMMMMM0,                 ;KMMWklkNWMMMMMMMKl.     .';coxOXWMMMMWNKOdxKWMMMMMWk,  .:l:  ,0MMMMMMMMMMMMMMMMWO,    .c0WMMMMMMXo.            lXMMMMMMMM
24 MMMMMMMM0,                 '0MMNx,''lXMMMMMWk'   .,cdxkkkxdxxOKXWMMMMMMWNXNMMMMMM0,  .kK;  cNMMMMMMN0XMMMMMMMMKc     .oXMMMMMMWO,            lNMMMMMMM
25 MMMMMMM0;                 .xWMKc. . .kWMMMNd.  .l0NMMMMMMMMMMWNXNWMMMMMMMWNNWMMMMMk. 'OWd. .OMMMMXx:oXMMMMMMMMMNo.     ,kWMMMMMMK:           .dWMMMMMM
26 MMMMMMX:                  cXM0; .l0o..:ool,  .lKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX; ;XMO. .dWWKo'.:KMMMMMMMMMMMWx.     .oXMMMMMMXc           .kWMMMMM
27 MMMMMNl                  .OMX: .oNMWOc'...':dKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc.dWMO.  lOl.  ,0MMMMMMMMMMMMMWx.      :KMMMMMMXl           ;KMMMMM
28 MMMMWx.                  lNMx. ;XMMMMMNXKXNWMWNWMMMMMMMMMMMMMMMXO0WMMMMMMMMMMMMMMMK::XMWx.  ...'.'OMMMMMMMMMMMMMMMWd.      ;0MMMMMMXc           oWMMMM
29 MMMMK,                  .kMNl  cNMMMMMMMWNX0kxONMMMMMMMMMMMMMMWd..,cok0NWMMMMMMMMM0xKMMX;   .cd;'kWMMMMMMMMMMMMMMMMNo       ,0MMMMMMK:          '0MMMM
30 MMMWo                   .cl:. .,ooolllllc::ld0WMMMMMMMMMMMMMMMNl      .':oOXNMMMMMWMMWO:  ;d00:.xWMMMMMMMMMMMMMMMMMMX:       ;KMMMMMM0'          oWMMM
31 MMM0'                    .':ok0KKK0OkxxkOKNWMMMMMMMMMMMMMMMMMMWo          ..;OWMMMMWO:.  ,OWK:.dWMMMMMMMMMMMMMMMMMMMMO'       :XMMMMMWd.         ,KMMM
32 MMWo                   .l0NWMMMMMMMMMMMMMMMMMMMMMMMMWXKWMMMMW0o'             .kWMWO:. .cOOOO:.oNMMMMMMMMMNXWMMMMMMMMMWo       .oWMMMMMX:         .kMMM
33 MMK,                   .OMMMMMMMMMMMMMMMMMMMMMMMMN0d:.cXMMMKc.                .ok:. ..;KMMX:.lNMMMMMMMMMWxlKMMMMMMMMMM0,       'OMMMMMWk.         oWMM
34 MMx.                   'OXXNMMMMMMMMMMMMMMMMMWXkl,.   lWMWO'                       ,O0dd0Kc .kMMMMMMMMMWk' cXMMMMMMMMMWl        lNMMMMMX;         cNMM
35 MNl                    .dOKNMMMMMMMMMMMMMMWKxc.       lWM0,                        'xXWN0:   ;0MMMWN0xl,.   'cdOXWMMMMMk.       'OMMMMMWd.        ;XMM
36 MX;                    ;XMMMMMMMMNOkXMMWKx;.          ,KWo                           .:c,     ;KMMWN0ko;.   'cdOXWMMMMMK,        dWMMMMMO.        ,KMM
37 M0'                    ,KMMMMXKN0:.oWW0c.              ;d;                                     lNMMMMMMWO'.dNMMMMMMMMMMNc        :XMMMMMK,        ;KMM
38 MO.                    '0MMM0lkO, 'ONd.                                                        .oNMMMMMMWkdNMMMMMMMMMMMWo        ,KMMMMMX:        ;XMM
39 Mk.                    .OMM0,,x;  ;Ol                                     ..',.                 ;KMMMMMMMNNMMMMMMMMMMMMWo        '0MMMMMNc        cNMM
40 Mx.                    .dW0, ,:.  ,c.                                      .:0Xk:.              lNMMMMMMMMMMMMMMMMMMMMMWo        .OMMMMMNc        oWMM
41 Mk.                     c0:  ..    .                                      .,xOd0NO;            '0MMMMMMMMMMMMMWWMMMMMMMWo        .OMMMMMN:       .kMMM
42 Mk.                     .:.                     .,.                       .cx: .lKXl           lWMMMMMMMMMMMWNxlONMMMMMNc        '0MMMMMX;       ;XMMM
43 M0'                                           .:c.                      .. .,:;,,l0Xl         .xMMMMMMMMMMMWNk,.:ONMMMMX;        ;XMMMMM0'      .dWMMM
44 MK;                                          'dl.                        .....''',:k0d;.       oWMMMMMMMMMMMMWOo0MMMMMMO.        oWMMMMMx.      ,KMMMM
45 MNc                                         :kl.                           ......   ,c;.       :XMMMMMMMMMMMMMWWWMMMMMWo        .kMMMMMNc      .dWMMMM
46 MWd.                                       c0l.                                                .OMMMMMMMMMMMMMMMMMMMMMK;        :XMMMMMO'      :XMMMMM
47 MM0'                                      :0d.                                         .        lNMMMMMMMMMMMMMMMMMMMWd.       .kMMMMMNl      '0MMMMMM
48 MMNl                                     '0k.                    ..                    'c.      .OMMMMMMMMMMMMMMMMMMM0,        lNMMMMMO.     .kWMMMMMM
49 MMMO.                                   .dK;                    ;0O;                    :d'      ;KMMMMMMMMMMMMMMMMMNl        ,KMMMMMX:     .xWMMMWXNM
50 MMMNc                                   ,0d.                   .OMMNk:.                 .x0xo,    cXMMMMMMMMMMMMMMMWd.       'OMMMMMNo     .dWMMMWOkNM
51 MMMMO'                                  c0;                   .dWMMMMW0l.                ;dooxl.   :0WMMMMMMMMMMMMWk.       .kWMMMMWx.    .xWMMMWxc0MM
52 MMMMWd.                                 ok.                   :XMMMMMMMWO,                  .:dc    'OWMMMMMMMMMMWO'       .kWMMMMWk.    'kWMMMNo,dWMM
53 MMMMMX:                                 cd.                  .kWMMMMMMMMWk.         ..      .,cc.    :XMMMMMMMMMWk'       'OWMMMMWk.    :0MMMMKc.cXMMM
54 MMMMMM0,                                .'.                  :XMMMMMMMMMMNc      'c;ll.       ..     .OMMMMMMMMWx.       :KMMMMMNx.   .oNMMMWO, ;KMMMM
55 MMMMMMWO'                                                   .xWMMMMMMMMMMMk:.    ,0KOOc              .OMMMMMMMNo.      .oXMMMMMXo.   ;OWMMMXl. 'OMMMMM
56 MMMMMMMWk.                                                  ,0MMMMMMMMMMMMX0:     .:d00l.            lNMMMMMW0:       ;OWMMMMW0:   'xNMMMNk,  'OWMMMMM
57 MMMMMMMMWx.                                                 :XMMMMMNNMMMMMMWk.       .',.          'xNMMMMMNx.      ,xNMMMMMNx.  .oXMMMWO:.  'OWMMMMMM
58 MMMMMMMMMWk.                                                cNMMMMNdxNMMMMMMWO:.                .;xXMMMMMWO:      'dXMMMMMWO;  .oKWMMW0c.   'OWMMMMMMM
59 MMMMMMMMMMWO,                                               cNWNKk:..:kKNWMMMMWKxc'.         .,oONMMMMMW0c.    .;xXMMMMMWKl..,dXWMMNOc.    ;0WMMMMMMMM
60 MMMMMMMMMMMMK:                                              cNWN0o'  'oONWMMMMMMMWN0dc;''';lxKNMMMMMMW0l.    .cONMMMMMWKl'.ckNMMMNk;.     cKMMMMMMMMMM
61 MMMMMMMMMMMMMXo.                                            cNMMMMKccKMMMMMMMMMMMMMMMMWNNNWMMMMMMMMNOc.   .:xXWMMMMMWOl;:dKWMMW0o'      .dNMMMMMMMMMMM
62 MMMMMMMMMMMMMMWk'                                           lNMMMMMXXMMMMMMMMMMMMMMMMMMMMMMMMMMMWKx;. .,lkXWMMMMMWXOdoxKWMMWKd;.       ;OWMMMMMMMMMMMM
63 MMMMMMMMMMMMMMMMKl.                                         oWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkc,';lxKNMMMMMMMWX0OOXWMMN0d;.        .oXMMMMMMMMMMMMMM
64 MMMMMMMMMMMMMMMMMWk;                                        lXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOxdxOXWMMMMMMMMMMMWNWMMWKxl,.         .:0WMMMMMMMMMMMMMMM
65 MMMMMMMMMMMMMMMMMMMXd'                                       .:ok0NWMMMMMMMMMMMMMMMMMMMMMMMWNWWMMMMMMMMMMMMMMMMWX0xl,.            ,kNMMMMMMMMMMMMMMMMM
66 MMMMMMMMMMMMMMMMMMMMMXo.                                         .':ldOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKOdc;..              'xNMMMMMMMMMMMMMMMMMMM
67 MMMMMMMMMMMMMMMMMMMMMMWKo'                                             .';ccldxO0KXXNWWWWWWWWWNNXKKOkxol:,..                  ,xXMMMMMMMMMMMMMMMMMMMMM
68 MMMMMMMMMMMMMMMMMMMMMMMMWXd,                                                    ....',,,,,,,,,'....                        .;kNMMMMMMMMMMMMMMMMMMMMMMM
69 MMMMMMMMMMMMMMMMMMMMMMMMMMMNk:.                                                                                          .l0WMMMMMMMMMMMMMMMMMMMMMMMMM
70 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKo,.                                                                                    .:xXWMMMMMMMMMMMMMMMMMMMMMMMMMMM
71 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo,                                                                               .;dKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
72 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo;.                                                                        .:xKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
73 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxc'.                                                                .;oOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
74 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xl;.                                                       .':oOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
75 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOdl;'.                                           ..,cokKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
76 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOxoc;,...                          ..';:ldk0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
77 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWXK0Okxdollcccc:::cccclloddkO0KXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
78 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
79     ███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗██╗███████╗██╗    ██╗ █████╗ ██████╗ ███████╗██╗  ██╗ ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗
80     ████╗ ████║██╔═══██╗██╔═══██╗████╗  ██║██║██╔════╝██║    ██║██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝
81     ██╔████╔██║██║   ██║██║   ██║██╔██╗ ██║██║███████╗██║ █╗ ██║███████║██████╔╝█████╗   ╚███╔╝ ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗
82     ██║╚██╔╝██║██║   ██║██║   ██║██║╚██╗██║██║╚════██║██║███╗██║██╔══██║██╔═══╝ ██╔══╝   ██╔██╗ ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝
83     ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║██║███████║╚███╔███╔╝██║  ██║██║██╗  ███████╗██╔╝ ██╗╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗
84     ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
85 
86                                                     ██████╗ ██╗   ██╗     ██╗██╗███╗   ██╗ ██████╗██╗  ██╗
87                                                     ██╔══██╗╚██╗ ██╔╝    ███║██║████╗  ██║██╔════╝██║  ██║
88                                                     ██████╔╝ ╚████╔╝     ╚██║██║██╔██╗ ██║██║     ███████║
89                                                     ██╔══██╗  ╚██╔╝       ██║██║██║╚██╗██║██║     ██╔══██║
90                                                     ██████╔╝   ██║        ██║██║██║ ╚████║╚██████╗██║  ██║
91                                                     ╚═════╝    ╚═╝        ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝
92 */
93 // File: @openzeppelin/contracts/GSN/Context.sol
94 
95 // SPDX-License-Identifier: MIT
96 
97 pragma solidity ^0.6.0;
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with GSN meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address payable) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes memory) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 // File: @openzeppelin/contracts/access/Ownable.sol
121 
122 
123 pragma solidity ^0.6.0;
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor () internal {
146         address msgSender = _msgSender();
147         _owner = msgSender;
148         emit OwnershipTransferred(address(0), msgSender);
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/math/SafeMath.sol
190 
191 
192 pragma solidity ^0.6.0;
193 
194 /**
195  * @dev Wrappers over Solidity's arithmetic operations with added overflow
196  * checks.
197  *
198  * Arithmetic operations in Solidity wrap on overflow. This can easily result
199  * in bugs, because programmers usually assume that an overflow raises an
200  * error, which is the standard behavior in high level programming languages.
201  * `SafeMath` restores this intuition by reverting the transaction when an
202  * operation overflows.
203  *
204  * Using this library instead of the unchecked operations eliminates an entire
205  * class of bugs, so it's recommended to use it always.
206  */
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      *
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         require(c >= a, "SafeMath: addition overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return sub(a, b, "SafeMath: subtraction overflow");
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      *
247      * - Subtraction cannot overflow.
248      */
249     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b <= a, errorMessage);
251         uint256 c = a - b;
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `*` operator.
261      *
262      * Requirements:
263      *
264      * - Multiplication cannot overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268         // benefit is lost if 'b' is also tested.
269         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
293         return div(a, b, "SafeMath: division by zero");
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         require(b > 0, errorMessage);
310         uint256 c = a / b;
311         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         return mod(a, b, "SafeMath: modulo by zero");
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts with custom message when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         require(b != 0, errorMessage);
346         return a % b;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
351 
352 
353 pragma solidity ^0.6.0;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP.
357  */
358 interface IERC20 {
359     /**
360      * @dev Returns the amount of tokens in existence.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     /**
365      * @dev Returns the amount of tokens owned by `account`.
366      */
367     function balanceOf(address account) external view returns (uint256);
368 
369     /**
370      * @dev Moves `amount` tokens from the caller's account to `recipient`.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transfer(address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Returns the remaining number of tokens that `spender` will be
380      * allowed to spend on behalf of `owner` through {transferFrom}. This is
381      * zero by default.
382      *
383      * This value changes when {approve} or {transferFrom} are called.
384      */
385     function allowance(address owner, address spender) external view returns (uint256);
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * IMPORTANT: Beware that changing an allowance with this method brings the risk
393      * that someone may use both the old and the new allowance by unfortunate
394      * transaction ordering. One possible solution to mitigate this race
395      * condition is to first reduce the spender's allowance to 0 and set the
396      * desired value afterwards:
397      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398      *
399      * Emits an {Approval} event.
400      */
401     function approve(address spender, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Moves `amount` tokens from `sender` to `recipient` using the
405      * allowance mechanism. `amount` is then deducted from the caller's
406      * allowance.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Emitted when `value` tokens are moved from one account (`from`) to
416      * another (`to`).
417      *
418      * Note that `value` may be zero.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 value);
421 
422     /**
423      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
424      * a call to {approve}. `value` is the new allowance.
425      */
426     event Approval(address indexed owner, address indexed spender, uint256 value);
427 }
428 
429 // File: @openzeppelin/contracts/utils/Address.sol
430 
431 
432 pragma solidity ^0.6.2;
433 
434 /**
435  * @dev Collection of functions related to the address type
436  */
437 library Address {
438     /**
439      * @dev Returns true if `account` is a contract.
440      *
441      * [IMPORTANT]
442      * ====
443      * It is unsafe to assume that an address for which this function returns
444      * false is an externally-owned account (EOA) and not a contract.
445      *
446      * Among others, `isContract` will return false for the following
447      * types of addresses:
448      *
449      *  - an externally-owned account
450      *  - a contract in construction
451      *  - an address where a contract will be created
452      *  - an address where a contract lived, but was destroyed
453      * ====
454      */
455     function isContract(address account) internal view returns (bool) {
456         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
457         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
458         // for accounts without code, i.e. `keccak256('')`
459         bytes32 codehash;
460         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
461         // solhint-disable-next-line no-inline-assembly
462         assembly { codehash := extcodehash(account) }
463         return (codehash != accountHash && codehash != 0x0);
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(address(this).balance >= amount, "Address: insufficient balance");
484 
485         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
486         (bool success, ) = recipient.call{ value: amount }("");
487         require(success, "Address: unable to send value, recipient may have reverted");
488     }
489 
490     /**
491      * @dev Performs a Solidity function call using a low level `call`. A
492      * plain`call` is an unsafe replacement for a function call: use this
493      * function instead.
494      *
495      * If `target` reverts with a revert reason, it is bubbled up by this
496      * function (like regular Solidity function calls).
497      *
498      * Returns the raw returned data. To convert to the expected return value,
499      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
500      *
501      * Requirements:
502      *
503      * - `target` must be a contract.
504      * - calling `target` with `data` must not revert.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
509       return functionCall(target, data, "Address: low-level call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
514      * `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
519         return _functionCallWithValue(target, data, 0, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but also transferring `value` wei to `target`.
525      *
526      * Requirements:
527      *
528      * - the calling contract must have an ETH balance of at least `value`.
529      * - the called Solidity function must be `payable`.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
539      * with `errorMessage` as a fallback revert reason when `target` reverts.
540      *
541      * _Available since v3.1._
542      */
543     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         return _functionCallWithValue(target, data, value, errorMessage);
546     }
547 
548     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
549         require(isContract(target), "Address: call to non-contract");
550 
551         // solhint-disable-next-line avoid-low-level-calls
552         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
553         if (success) {
554             return returndata;
555         } else {
556             // Look for revert reason and bubble it up if present
557             if (returndata.length > 0) {
558                 // The easiest way to bubble the revert reason is using memory via assembly
559 
560                 // solhint-disable-next-line no-inline-assembly
561                 assembly {
562                     let returndata_size := mload(returndata)
563                     revert(add(32, returndata), returndata_size)
564                 }
565             } else {
566                 revert(errorMessage);
567             }
568         }
569     }
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
573 
574 
575 pragma solidity ^0.6.0;
576 
577 
578 
579 
580 /**
581  * @title SafeERC20
582  * @dev Wrappers around ERC20 operations that throw on failure (when the token
583  * contract returns false). Tokens that return no value (and instead revert or
584  * throw on failure) are also supported, non-reverting calls are assumed to be
585  * successful.
586  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
587  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
588  */
589 library SafeERC20 {
590     using SafeMath for uint256;
591     using Address for address;
592 
593     function safeTransfer(IERC20 token, address to, uint256 value) internal {
594         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
595     }
596 
597     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
599     }
600 
601     /**
602      * @dev Deprecated. This function has issues similar to the ones found in
603      * {IERC20-approve}, and its usage is discouraged.
604      *
605      * Whenever possible, use {safeIncreaseAllowance} and
606      * {safeDecreaseAllowance} instead.
607      */
608     function safeApprove(IERC20 token, address spender, uint256 value) internal {
609         // safeApprove should only be called when setting an initial allowance,
610         // or when resetting it to zero. To increase and decrease it, use
611         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
612         // solhint-disable-next-line max-line-length
613         require((value == 0) || (token.allowance(address(this), spender) == 0),
614             "SafeERC20: approve from non-zero to non-zero allowance"
615         );
616         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
617     }
618 
619     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
620         uint256 newAllowance = token.allowance(address(this), spender).add(value);
621         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
622     }
623 
624     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
625         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
626         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
627     }
628 
629     /**
630      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
631      * on the return value: the return value is optional (but if data is returned, it must not be false).
632      * @param token The token targeted by the call.
633      * @param data The call data (encoded using abi.encode or one of its variants).
634      */
635     function _callOptionalReturn(IERC20 token, bytes memory data) private {
636         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
637         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
638         // the target address contains contract code and also asserts for success in the low-level call.
639 
640         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
641         if (returndata.length > 0) { // Return data is optional
642             // solhint-disable-next-line max-line-length
643             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
644         }
645     }
646 }
647 
648 // File: contracts/libraries/UniERC20.sol
649 
650 
651 pragma solidity ^0.6.0;
652 
653 
654 
655 
656 
657 library UniERC20 {
658     using SafeMath for uint256;
659     using SafeERC20 for IERC20;
660 
661     function isETH(IERC20 token) internal pure returns(bool) {
662         return (address(token) == address(0));
663     }
664 
665     function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
666         if (isETH(token)) {
667             return account.balance;
668         } else {
669             return token.balanceOf(account);
670         }
671     }
672 
673     function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {
674         if (amount > 0) {
675             if (isETH(token)) {
676                 to.transfer(amount);
677             } else {
678                 token.safeTransfer(to, amount);
679             }
680         }
681     }
682 
683     function uniTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
684         if (amount > 0) {
685             if (isETH(token)) {
686                 require(msg.value >= amount, "UniERC20: not enough value");
687                 if (msg.value > amount) {
688                     // Return remainder if exist
689                     msg.sender.transfer(msg.value.sub(amount));
690                 }
691             } else {
692                 token.safeTransferFrom(msg.sender, address(this), amount);
693             }
694         }
695     }
696 
697     function uniSymbol(IERC20 token) internal view returns(string memory) {
698         if (isETH(token)) {
699             return "ETH";
700         }
701 
702         (bool success, bytes memory data) = address(token).staticcall{ gas: 20000 }(
703             abi.encodeWithSignature("symbol()")
704         );
705         if (!success) {
706             (success, data) = address(token).staticcall{ gas: 20000 }(
707                 abi.encodeWithSignature("SYMBOL()")
708             );
709         }
710 
711         if (success && data.length >= 96) {
712             (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
713             if (offset == 0x20 && len > 0 && len <= 256) {
714                 return string(abi.decode(data, (bytes)));
715             }
716         }
717 
718         if (success && data.length == 32) {
719             uint len = 0;
720             while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
721                 len++;
722             }
723 
724             if (len > 0) {
725                 bytes memory result = new bytes(len);
726                 for (uint i = 0; i < len; i++) {
727                     result[i] = data[i];
728                 }
729                 return string(result);
730             }
731         }
732 
733         return _toHex(address(token));
734     }
735 
736     function _toHex(address account) private pure returns(string memory) {
737         return _toHex(abi.encodePacked(account));
738     }
739 
740     function _toHex(bytes memory data) private pure returns(string memory) {
741         bytes memory str = new bytes(2 + data.length * 2);
742         str[0] = "0";
743         str[1] = "x";
744         uint j = 2;
745         for (uint i = 0; i < data.length; i++) {
746             uint a = uint8(data[i]) >> 4;
747             uint b = uint8(data[i]) & 0x0f;
748             str[j++] = byte(uint8(a + 48 + (a/10)*39));
749             str[j++] = byte(uint8(b + 48 + (b/10)*39));
750         }
751 
752         return string(str);
753     }
754 }
755 
756 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
757 
758 
759 pragma solidity ^0.6.0;
760 
761 /**
762  * @dev Contract module that helps prevent reentrant calls to a function.
763  *
764  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
765  * available, which can be applied to functions to make sure there are no nested
766  * (reentrant) calls to them.
767  *
768  * Note that because there is a single `nonReentrant` guard, functions marked as
769  * `nonReentrant` may not call one another. This can be worked around by making
770  * those functions `private`, and then adding `external` `nonReentrant` entry
771  * points to them.
772  *
773  * TIP: If you would like to learn more about reentrancy and alternative ways
774  * to protect against it, check out our blog post
775  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
776  */
777 contract ReentrancyGuard {
778     // Booleans are more expensive than uint256 or any type that takes up a full
779     // word because each write operation emits an extra SLOAD to first read the
780     // slot's contents, replace the bits taken up by the boolean, and then write
781     // back. This is the compiler's defense against contract upgrades and
782     // pointer aliasing, and it cannot be disabled.
783 
784     // The values being non-zero value makes deployment a bit more expensive,
785     // but in exchange the refund on every call to nonReentrant will be lower in
786     // amount. Since refunds are capped to a percentage of the total
787     // transaction's gas, it is best to keep them low in cases like this one, to
788     // increase the likelihood of the full refund coming into effect.
789     uint256 private constant _NOT_ENTERED = 1;
790     uint256 private constant _ENTERED = 2;
791 
792     uint256 private _status;
793 
794     constructor () internal {
795         _status = _NOT_ENTERED;
796     }
797 
798     /**
799      * @dev Prevents a contract from calling itself, directly or indirectly.
800      * Calling a `nonReentrant` function from another `nonReentrant`
801      * function is not supported. It is possible to prevent this from happening
802      * by making the `nonReentrant` function external, and make it call a
803      * `private` function that does the actual work.
804      */
805     modifier nonReentrant() {
806         // On the first call to nonReentrant, _notEntered will be true
807         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
808 
809         // Any calls to nonReentrant after this point will fail
810         _status = _ENTERED;
811 
812         _;
813 
814         // By storing the original value once again, a refund is triggered (see
815         // https://eips.ethereum.org/EIPS/eip-2200)
816         _status = _NOT_ENTERED;
817     }
818 }
819 
820 // File: @openzeppelin/contracts/math/Math.sol
821 
822 
823 pragma solidity ^0.6.0;
824 
825 /**
826  * @dev Standard math utilities missing in the Solidity language.
827  */
828 library Math {
829     /**
830      * @dev Returns the largest of two numbers.
831      */
832     function max(uint256 a, uint256 b) internal pure returns (uint256) {
833         return a >= b ? a : b;
834     }
835 
836     /**
837      * @dev Returns the smallest of two numbers.
838      */
839     function min(uint256 a, uint256 b) internal pure returns (uint256) {
840         return a < b ? a : b;
841     }
842 
843     /**
844      * @dev Returns the average of two numbers. The result is rounded towards
845      * zero.
846      */
847     function average(uint256 a, uint256 b) internal pure returns (uint256) {
848         // (a + b) / 2 can overflow, so we distribute
849         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
850     }
851 }
852 
853 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
854 
855 
856 pragma solidity ^0.6.0;
857 
858 
859 
860 
861 
862 /**
863  * @dev Implementation of the {IERC20} interface.
864  *
865  * This implementation is agnostic to the way tokens are created. This means
866  * that a supply mechanism has to be added in a derived contract using {_mint}.
867  * For a generic mechanism see {ERC20PresetMinterPauser}.
868  *
869  * TIP: For a detailed writeup see our guide
870  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
871  * to implement supply mechanisms].
872  *
873  * We have followed general OpenZeppelin guidelines: functions revert instead
874  * of returning `false` on failure. This behavior is nonetheless conventional
875  * and does not conflict with the expectations of ERC20 applications.
876  *
877  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
878  * This allows applications to reconstruct the allowance for all accounts just
879  * by listening to said events. Other implementations of the EIP may not emit
880  * these events, as it isn't required by the specification.
881  *
882  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
883  * functions have been added to mitigate the well-known issues around setting
884  * allowances. See {IERC20-approve}.
885  */
886 contract ERC20 is Context, IERC20 {
887     using SafeMath for uint256;
888     using Address for address;
889 
890     mapping (address => uint256) private _balances;
891 
892     mapping (address => mapping (address => uint256)) private _allowances;
893 
894     uint256 private _totalSupply;
895 
896     string private _name;
897     string private _symbol;
898     uint8 private _decimals;
899 
900     /**
901      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
902      * a default value of 18.
903      *
904      * To select a different value for {decimals}, use {_setupDecimals}.
905      *
906      * All three of these values are immutable: they can only be set once during
907      * construction.
908      */
909     constructor (string memory name, string memory symbol) public {
910         _name = name;
911         _symbol = symbol;
912         _decimals = 18;
913     }
914 
915     /**
916      * @dev Returns the name of the token.
917      */
918     function name() public view returns (string memory) {
919         return _name;
920     }
921 
922     /**
923      * @dev Returns the symbol of the token, usually a shorter version of the
924      * name.
925      */
926     function symbol() public view returns (string memory) {
927         return _symbol;
928     }
929 
930     /**
931      * @dev Returns the number of decimals used to get its user representation.
932      * For example, if `decimals` equals `2`, a balance of `505` tokens should
933      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
934      *
935      * Tokens usually opt for a value of 18, imitating the relationship between
936      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
937      * called.
938      *
939      * NOTE: This information is only used for _display_ purposes: it in
940      * no way affects any of the arithmetic of the contract, including
941      * {IERC20-balanceOf} and {IERC20-transfer}.
942      */
943     function decimals() public view returns (uint8) {
944         return _decimals;
945     }
946 
947     /**
948      * @dev See {IERC20-totalSupply}.
949      */
950     function totalSupply() public view override returns (uint256) {
951         return _totalSupply;
952     }
953 
954     /**
955      * @dev See {IERC20-balanceOf}.
956      */
957     function balanceOf(address account) public view override returns (uint256) {
958         return _balances[account];
959     }
960 
961     /**
962      * @dev See {IERC20-transfer}.
963      *
964      * Requirements:
965      *
966      * - `recipient` cannot be the zero address.
967      * - the caller must have a balance of at least `amount`.
968      */
969     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
970         _transfer(_msgSender(), recipient, amount);
971         return true;
972     }
973 
974     /**
975      * @dev See {IERC20-allowance}.
976      */
977     function allowance(address owner, address spender) public view virtual override returns (uint256) {
978         return _allowances[owner][spender];
979     }
980 
981     /**
982      * @dev See {IERC20-approve}.
983      *
984      * Requirements:
985      *
986      * - `spender` cannot be the zero address.
987      */
988     function approve(address spender, uint256 amount) public virtual override returns (bool) {
989         _approve(_msgSender(), spender, amount);
990         return true;
991     }
992 
993     /**
994      * @dev See {IERC20-transferFrom}.
995      *
996      * Emits an {Approval} event indicating the updated allowance. This is not
997      * required by the EIP. See the note at the beginning of {ERC20};
998      *
999      * Requirements:
1000      * - `sender` and `recipient` cannot be the zero address.
1001      * - `sender` must have a balance of at least `amount`.
1002      * - the caller must have allowance for ``sender``'s tokens of at least
1003      * `amount`.
1004      */
1005     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1006         _transfer(sender, recipient, amount);
1007         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1008         return true;
1009     }
1010 
1011     /**
1012      * @dev Atomically increases the allowance granted to `spender` by the caller.
1013      *
1014      * This is an alternative to {approve} that can be used as a mitigation for
1015      * problems described in {IERC20-approve}.
1016      *
1017      * Emits an {Approval} event indicating the updated allowance.
1018      *
1019      * Requirements:
1020      *
1021      * - `spender` cannot be the zero address.
1022      */
1023     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1024         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1025         return true;
1026     }
1027 
1028     /**
1029      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1030      *
1031      * This is an alternative to {approve} that can be used as a mitigation for
1032      * problems described in {IERC20-approve}.
1033      *
1034      * Emits an {Approval} event indicating the updated allowance.
1035      *
1036      * Requirements:
1037      *
1038      * - `spender` cannot be the zero address.
1039      * - `spender` must have allowance for the caller of at least
1040      * `subtractedValue`.
1041      */
1042     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1043         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1044         return true;
1045     }
1046 
1047     /**
1048      * @dev Moves tokens `amount` from `sender` to `recipient`.
1049      *
1050      * This is internal function is equivalent to {transfer}, and can be used to
1051      * e.g. implement automatic token fees, slashing mechanisms, etc.
1052      *
1053      * Emits a {Transfer} event.
1054      *
1055      * Requirements:
1056      *
1057      * - `sender` cannot be the zero address.
1058      * - `recipient` cannot be the zero address.
1059      * - `sender` must have a balance of at least `amount`.
1060      */
1061     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1062         require(sender != address(0), "ERC20: transfer from the zero address");
1063         require(recipient != address(0), "ERC20: transfer to the zero address");
1064 
1065         _beforeTokenTransfer(sender, recipient, amount);
1066 
1067         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1068         _balances[recipient] = _balances[recipient].add(amount);
1069         emit Transfer(sender, recipient, amount);
1070     }
1071 
1072     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1073      * the total supply.
1074      *
1075      * Emits a {Transfer} event with `from` set to the zero address.
1076      *
1077      * Requirements
1078      *
1079      * - `to` cannot be the zero address.
1080      */
1081     function _mint(address account, uint256 amount) internal virtual {
1082         require(account != address(0), "ERC20: mint to the zero address");
1083 
1084         _beforeTokenTransfer(address(0), account, amount);
1085 
1086         _totalSupply = _totalSupply.add(amount);
1087         _balances[account] = _balances[account].add(amount);
1088         emit Transfer(address(0), account, amount);
1089     }
1090 
1091     /**
1092      * @dev Destroys `amount` tokens from `account`, reducing the
1093      * total supply.
1094      *
1095      * Emits a {Transfer} event with `to` set to the zero address.
1096      *
1097      * Requirements
1098      *
1099      * - `account` cannot be the zero address.
1100      * - `account` must have at least `amount` tokens.
1101      */
1102     function _burn(address account, uint256 amount) internal virtual {
1103         require(account != address(0), "ERC20: burn from the zero address");
1104 
1105         _beforeTokenTransfer(account, address(0), amount);
1106 
1107         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1108         _totalSupply = _totalSupply.sub(amount);
1109         emit Transfer(account, address(0), amount);
1110     }
1111 
1112     /**
1113      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1114      *
1115      * This is internal function is equivalent to `approve`, and can be used to
1116      * e.g. set automatic allowances for certain subsystems, etc.
1117      *
1118      * Emits an {Approval} event.
1119      *
1120      * Requirements:
1121      *
1122      * - `owner` cannot be the zero address.
1123      * - `spender` cannot be the zero address.
1124      */
1125     function _approve(address owner, address spender, uint256 amount) internal virtual {
1126         require(owner != address(0), "ERC20: approve from the zero address");
1127         require(spender != address(0), "ERC20: approve to the zero address");
1128 
1129         _allowances[owner][spender] = amount;
1130         emit Approval(owner, spender, amount);
1131     }
1132 
1133     /**
1134      * @dev Sets {decimals} to a value other than the default one of 18.
1135      *
1136      * WARNING: This function should only be called from the constructor. Most
1137      * applications that interact with token contracts will not expect
1138      * {decimals} to ever change, and may work incorrectly if it does.
1139      */
1140     function _setupDecimals(uint8 decimals_) internal {
1141         _decimals = decimals_;
1142     }
1143 
1144     /**
1145      * @dev Hook that is called before any transfer of tokens. This includes
1146      * minting and burning.
1147      *
1148      * Calling conditions:
1149      *
1150      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1151      * will be to transferred to `to`.
1152      * - when `from` is zero, `amount` tokens will be minted for `to`.
1153      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1154      * - `from` and `to` are never both zero.
1155      *
1156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1157      */
1158     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1159 }
1160 
1161 // File: contracts/libraries/Sqrt.sol
1162 
1163 
1164 pragma solidity ^0.6.0;
1165 
1166 
1167 library Sqrt {
1168     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
1169     function sqrt(uint256 y) internal pure returns (uint256) {
1170         if (y > 3) {
1171             uint256 z = y;
1172             uint256 x = y / 2 + 1;
1173             while (x < z) {
1174                 z = x;
1175                 x = (y / x + x) / 2;
1176             }
1177             return z;
1178         } else if (y != 0) {
1179             return 1;
1180         } else {
1181             return 0;
1182         }
1183     }
1184 }
1185 
1186 // File: contracts/Mooniswap.sol
1187 
1188 
1189 pragma solidity ^0.6.0;
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 interface IFactory {
1200     function fee() external view returns(uint256);
1201 }
1202 
1203 
1204 library VirtualBalance {
1205     using SafeMath for uint256;
1206 
1207     struct Data {
1208         uint216 balance;
1209         uint40 time;
1210     }
1211 
1212     uint256 public constant DECAY_PERIOD = 5 minutes;
1213 
1214     function set(VirtualBalance.Data storage self, uint256 balance) internal {
1215         self.balance = uint216(balance);
1216         self.time = uint40(block.timestamp);
1217     }
1218 
1219     function update(VirtualBalance.Data storage self, uint256 realBalance) internal {
1220         set(self, current(self, realBalance));
1221     }
1222 
1223     function scale(VirtualBalance.Data storage self, uint256 realBalance, uint256 num, uint256 denom) internal {
1224         set(self, current(self, realBalance).mul(num).add(denom.sub(1)).div(denom));
1225     }
1226 
1227     function current(VirtualBalance.Data memory self, uint256 realBalance) internal view returns(uint256) {
1228         uint256 timePassed = Math.min(DECAY_PERIOD, block.timestamp.sub(self.time));
1229         uint256 timeRemain = DECAY_PERIOD.sub(timePassed);
1230         return uint256(self.balance).mul(timeRemain).add(
1231             realBalance.mul(timePassed)
1232         ).div(DECAY_PERIOD);
1233     }
1234 }
1235 
1236 
1237 contract Mooniswap is ERC20, ReentrancyGuard, Ownable {
1238     using Sqrt for uint256;
1239     using SafeMath for uint256;
1240     using UniERC20 for IERC20;
1241     using VirtualBalance for VirtualBalance.Data;
1242 
1243     struct Balances {
1244         uint256 src;
1245         uint256 dst;
1246     }
1247 
1248     struct SwapVolumes {
1249         uint128 confirmed;
1250         uint128 result;
1251     }
1252 
1253     event Deposited(
1254         address indexed account,
1255         uint256 amount
1256     );
1257 
1258     event Withdrawn(
1259         address indexed account,
1260         uint256 amount
1261     );
1262 
1263     event Swapped(
1264         address indexed account,
1265         address indexed src,
1266         address indexed dst,
1267         uint256 amount,
1268         uint256 result,
1269         uint256 srcBalance,
1270         uint256 dstBalance,
1271         uint256 totalSupply,
1272         address referral
1273     );
1274 
1275     uint256 public constant REFERRAL_SHARE = 20; // 1/share = 5% of LPs revenue
1276     uint256 public constant BASE_SUPPLY = 1000;  // Total supply on first deposit
1277     uint256 public constant FEE_DENOMINATOR = 1e18;
1278 
1279     IFactory public factory;
1280     IERC20[] public tokens;
1281     mapping(IERC20 => bool) public isToken;
1282     mapping(IERC20 => SwapVolumes) public volumes;
1283     mapping(IERC20 => VirtualBalance.Data) public virtualBalancesForAddition;
1284     mapping(IERC20 => VirtualBalance.Data) public virtualBalancesForRemoval;
1285 
1286     constructor(IERC20[] memory assets, string memory name, string memory symbol) public ERC20(name, symbol) {
1287         require(bytes(name).length > 0, "Mooniswap: name is empty");
1288         require(bytes(symbol).length > 0, "Mooniswap: symbol is empty");
1289         require(assets.length == 2, "Mooniswap: only 2 tokens allowed");
1290 
1291         factory = IFactory(msg.sender);
1292         tokens = assets;
1293         for (uint i = 0; i < assets.length; i++) {
1294             require(!isToken[assets[i]], "Mooniswap: duplicate tokens");
1295             isToken[assets[i]] = true;
1296         }
1297     }
1298 
1299     function fee() public view returns(uint256) {
1300         return factory.fee();
1301     }
1302 
1303     function getTokens() external view returns(IERC20[] memory) {
1304         return tokens;
1305     }
1306 
1307     function decayPeriod() external pure returns(uint256) {
1308         return VirtualBalance.DECAY_PERIOD;
1309     }
1310 
1311     function getBalanceForAddition(IERC20 token) public view returns(uint256) {
1312         uint256 balance = token.uniBalanceOf(address(this));
1313         return Math.max(virtualBalancesForAddition[token].current(balance), balance);
1314     }
1315 
1316     function getBalanceForRemoval(IERC20 token) public view returns(uint256) {
1317         uint256 balance = token.uniBalanceOf(address(this));
1318         return Math.min(virtualBalancesForRemoval[token].current(balance), balance);
1319     }
1320 
1321     function getReturn(IERC20 src, IERC20 dst, uint256 amount) external view returns(uint256) {
1322         return _getReturn(src, dst, amount, getBalanceForAddition(src), getBalanceForRemoval(dst));
1323     }
1324 
1325     function deposit(uint256[] calldata amounts, uint256[] calldata minAmounts) external payable nonReentrant returns(uint256 fairSupply) {
1326         IERC20[] memory _tokens = tokens;
1327         require(amounts.length == _tokens.length, "Mooniswap: wrong amounts length");
1328         require(msg.value == (_tokens[0].isETH() ? amounts[0] : (_tokens[1].isETH() ? amounts[1] : 0)), "Mooniswap: wrong value usage");
1329 
1330         uint256[] memory realBalances = new uint256[](amounts.length);
1331         for (uint i = 0; i < realBalances.length; i++) {
1332             realBalances[i] = _tokens[i].uniBalanceOf(address(this)).sub(_tokens[i].isETH() ? msg.value : 0);
1333         }
1334 
1335         uint256 totalSupply = totalSupply();
1336         if (totalSupply == 0) {
1337             fairSupply = BASE_SUPPLY.mul(99);
1338             _mint(address(this), BASE_SUPPLY); // Donate up to 1%
1339 
1340             // Use the greatest token amount but not less than 99k for the initial supply
1341             for (uint i = 0; i < amounts.length; i++) {
1342                 fairSupply = Math.max(fairSupply, amounts[i]);
1343             }
1344         }
1345         else {
1346             // Pre-compute fair supply
1347             fairSupply = type(uint256).max;
1348             for (uint i = 0; i < amounts.length; i++) {
1349                 fairSupply = Math.min(fairSupply, totalSupply.mul(amounts[i]).div(realBalances[i]));
1350             }
1351         }
1352 
1353         uint256 fairSupplyCached = fairSupply;
1354         for (uint i = 0; i < amounts.length; i++) {
1355             require(amounts[i] > 0, "Mooniswap: amount is zero");
1356             uint256 amount = (totalSupply == 0) ? amounts[i] :
1357                 realBalances[i].mul(fairSupplyCached).add(totalSupply - 1).div(totalSupply);
1358             require(amount >= minAmounts[i], "Mooniswap: minAmount not reached");
1359 
1360             _tokens[i].uniTransferFromSenderToThis(amount);
1361             if (totalSupply > 0) {
1362                 uint256 confirmed = _tokens[i].uniBalanceOf(address(this)).sub(realBalances[i]);
1363                 fairSupply = Math.min(fairSupply, totalSupply.mul(confirmed).div(realBalances[i]));
1364             }
1365         }
1366 
1367         if (totalSupply > 0) {
1368             for (uint i = 0; i < amounts.length; i++) {
1369                 virtualBalancesForRemoval[_tokens[i]].scale(realBalances[i], totalSupply.add(fairSupply), totalSupply);
1370                 virtualBalancesForAddition[_tokens[i]].scale(realBalances[i], totalSupply.add(fairSupply), totalSupply);
1371             }
1372         }
1373 
1374         require(fairSupply > 0, "Mooniswap: result is not enough");
1375         _mint(msg.sender, fairSupply);
1376 
1377         emit Deposited(msg.sender, fairSupply);
1378     }
1379 
1380     function withdraw(uint256 amount, uint256[] memory minReturns) external nonReentrant {
1381         uint256 totalSupply = totalSupply();
1382         _burn(msg.sender, amount);
1383 
1384         for (uint i = 0; i < tokens.length; i++) {
1385             IERC20 token = tokens[i];
1386 
1387             uint256 preBalance = token.uniBalanceOf(address(this));
1388             uint256 value = preBalance.mul(amount).div(totalSupply);
1389             token.uniTransfer(msg.sender, value);
1390             require(i >= minReturns.length || value >= minReturns[i], "Mooniswap: result is not enough");
1391 
1392             virtualBalancesForAddition[token].scale(preBalance, totalSupply.sub(amount), totalSupply);
1393             virtualBalancesForRemoval[token].scale(preBalance, totalSupply.sub(amount), totalSupply);
1394         }
1395 
1396         emit Withdrawn(msg.sender, amount);
1397     }
1398 
1399     function swap(IERC20 src, IERC20 dst, uint256 amount, uint256 minReturn, address referral) external payable nonReentrant returns(uint256 result) {
1400         require(msg.value == (src.isETH() ? amount : 0), "Mooniswap: wrong value usage");
1401 
1402         Balances memory balances = Balances({
1403             src: src.uniBalanceOf(address(this)).sub(src.isETH() ? msg.value : 0),
1404             dst: dst.uniBalanceOf(address(this))
1405         });
1406 
1407         // catch possible airdrops and external balance changes for deflationary tokens
1408         uint256 srcAdditionBalance = Math.max(virtualBalancesForAddition[src].current(balances.src), balances.src);
1409         uint256 dstRemovalBalance = Math.min(virtualBalancesForRemoval[dst].current(balances.dst), balances.dst);
1410 
1411         src.uniTransferFromSenderToThis(amount);
1412         uint256 confirmed = src.uniBalanceOf(address(this)).sub(balances.src);
1413         result = _getReturn(src, dst, confirmed, srcAdditionBalance, dstRemovalBalance);
1414         require(result > 0 && result >= minReturn, "Mooniswap: return is not enough");
1415         dst.uniTransfer(msg.sender, result);
1416 
1417         // Update virtual balances to the same direction only at imbalanced state
1418         if (srcAdditionBalance != balances.src) {
1419             virtualBalancesForAddition[src].set(srcAdditionBalance.add(confirmed));
1420         }
1421         if (dstRemovalBalance != balances.dst) {
1422             virtualBalancesForRemoval[dst].set(dstRemovalBalance.sub(result));
1423         }
1424 
1425         // Update virtual balances to the opposite direction
1426         virtualBalancesForRemoval[src].update(balances.src);
1427         virtualBalancesForAddition[dst].update(balances.dst);
1428 
1429         if (referral != address(0)) {
1430             uint256 invariantRatio = uint256(1e36);
1431             invariantRatio = invariantRatio.mul(balances.src.add(confirmed)).div(balances.src);
1432             invariantRatio = invariantRatio.mul(balances.dst.sub(result)).div(balances.dst);
1433             if (invariantRatio > 1e36) {
1434                 // calculate share only if invariant increased
1435                 uint256 referralShare = invariantRatio.sqrt().sub(1e18).mul(totalSupply()).div(1e18).div(REFERRAL_SHARE);
1436                 if (referralShare > 0) {
1437                     _mint(referral, referralShare);
1438                 }
1439             }
1440         }
1441 
1442         emit Swapped(msg.sender, address(src), address(dst), confirmed, result, balances.src, balances.dst, totalSupply(), referral);
1443 
1444         // Overflow of uint128 is desired
1445         volumes[src].confirmed += uint128(confirmed);
1446         volumes[src].result += uint128(result);
1447     }
1448 
1449     function rescueFunds(IERC20 token, uint256 amount) external nonReentrant onlyOwner {
1450         uint256[] memory balances = new uint256[](tokens.length);
1451         for (uint i = 0; i < balances.length; i++) {
1452             balances[i] = tokens[i].uniBalanceOf(address(this));
1453         }
1454 
1455         token.uniTransfer(msg.sender, amount);
1456 
1457         for (uint i = 0; i < balances.length; i++) {
1458             require(tokens[i].uniBalanceOf(address(this)) >= balances[i], "Mooniswap: access denied");
1459         }
1460         require(balanceOf(address(this)) >= BASE_SUPPLY, "Mooniswap: access denied");
1461     }
1462 
1463     function _getReturn(IERC20 src, IERC20 dst, uint256 amount, uint256 srcBalance, uint256 dstBalance) internal view returns(uint256) {
1464         if (isToken[src] && isToken[dst] && src != dst && amount > 0) {
1465             uint256 taxedAmount = amount.sub(amount.mul(fee()).div(FEE_DENOMINATOR));
1466             return taxedAmount.mul(dstBalance).div(srcBalance.add(taxedAmount));
1467         }
1468     }
1469 }
1470 
1471 // File: contracts/MooniFactory.sol
1472 
1473 
1474 pragma solidity ^0.6.0;
1475 
1476 
1477 
1478 
1479 
1480 contract MooniFactory is Ownable {
1481     using UniERC20 for IERC20;
1482 
1483     event Deployed(
1484         address indexed mooniswap,
1485         address indexed token1,
1486         address indexed token2
1487     );
1488 
1489     uint256 public constant MAX_FEE = 0.003e18; // 0.3%
1490 
1491     uint256 public fee;
1492     Mooniswap[] public allPools;
1493     mapping(Mooniswap => bool) public isPool;
1494     mapping(IERC20 => mapping(IERC20 => Mooniswap)) public pools;
1495 
1496     function getAllPools() external view returns(Mooniswap[] memory) {
1497         return allPools;
1498     }
1499 
1500     function setFee(uint256 newFee) external onlyOwner {
1501         require(newFee <= MAX_FEE, "Factory: fee should be <= 0.3%");
1502         fee = newFee;
1503     }
1504 
1505     function deploy(IERC20 tokenA, IERC20 tokenB) public returns(Mooniswap pool) {
1506         require(tokenA != tokenB, "Factory: not support same tokens");
1507         require(pools[tokenA][tokenB] == Mooniswap(0), "Factory: pool already exists");
1508 
1509         (IERC20 token1, IERC20 token2) = sortTokens(tokenA, tokenB);
1510         IERC20[] memory tokens = new IERC20[](2);
1511         tokens[0] = token1;
1512         tokens[1] = token2;
1513 
1514         string memory symbol1 = token1.uniSymbol();
1515         string memory symbol2 = token2.uniSymbol();
1516 
1517         pool = new Mooniswap(
1518             tokens,
1519             string(abi.encodePacked("Mooniswap V1 (", symbol1, "-", symbol2, ")")),
1520             string(abi.encodePacked("MOON-V1-", symbol1, "-", symbol2))
1521         );
1522 
1523         pool.transferOwnership(owner());
1524         pools[token1][token2] = pool;
1525         pools[token2][token1] = pool;
1526         allPools.push(pool);
1527         isPool[pool] = true;
1528 
1529         emit Deployed(
1530             address(pool),
1531             address(token1),
1532             address(token2)
1533         );
1534     }
1535 
1536     function sortTokens(IERC20 tokenA, IERC20 tokenB) public pure returns(IERC20, IERC20) {
1537         if (tokenA < tokenB) {
1538             return (tokenA, tokenB);
1539         }
1540         return (tokenB, tokenA);
1541     }
1542 }
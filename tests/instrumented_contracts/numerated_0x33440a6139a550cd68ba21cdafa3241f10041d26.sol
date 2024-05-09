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
189 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
190 
191 
192 pragma solidity ^0.6.0;
193 
194 /**
195  * @dev Contract module that helps prevent reentrant calls to a function.
196  *
197  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
198  * available, which can be applied to functions to make sure there are no nested
199  * (reentrant) calls to them.
200  *
201  * Note that because there is a single `nonReentrant` guard, functions marked as
202  * `nonReentrant` may not call one another. This can be worked around by making
203  * those functions `private`, and then adding `external` `nonReentrant` entry
204  * points to them.
205  *
206  * TIP: If you would like to learn more about reentrancy and alternative ways
207  * to protect against it, check out our blog post
208  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
209  */
210 contract ReentrancyGuard {
211     // Booleans are more expensive than uint256 or any type that takes up a full
212     // word because each write operation emits an extra SLOAD to first read the
213     // slot's contents, replace the bits taken up by the boolean, and then write
214     // back. This is the compiler's defense against contract upgrades and
215     // pointer aliasing, and it cannot be disabled.
216 
217     // The values being non-zero value makes deployment a bit more expensive,
218     // but in exchange the refund on every call to nonReentrant will be lower in
219     // amount. Since refunds are capped to a percentage of the total
220     // transaction's gas, it is best to keep them low in cases like this one, to
221     // increase the likelihood of the full refund coming into effect.
222     uint256 private constant _NOT_ENTERED = 1;
223     uint256 private constant _ENTERED = 2;
224 
225     uint256 private _status;
226 
227     constructor () internal {
228         _status = _NOT_ENTERED;
229     }
230 
231     /**
232      * @dev Prevents a contract from calling itself, directly or indirectly.
233      * Calling a `nonReentrant` function from another `nonReentrant`
234      * function is not supported. It is possible to prevent this from happening
235      * by making the `nonReentrant` function external, and make it call a
236      * `private` function that does the actual work.
237      */
238     modifier nonReentrant() {
239         // On the first call to nonReentrant, _notEntered will be true
240         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
241 
242         // Any calls to nonReentrant after this point will fail
243         _status = _ENTERED;
244 
245         _;
246 
247         // By storing the original value once again, a refund is triggered (see
248         // https://eips.ethereum.org/EIPS/eip-2200)
249         _status = _NOT_ENTERED;
250     }
251 }
252 
253 // File: @openzeppelin/contracts/math/Math.sol
254 
255 
256 pragma solidity ^0.6.0;
257 
258 /**
259  * @dev Standard math utilities missing in the Solidity language.
260  */
261 library Math {
262     /**
263      * @dev Returns the largest of two numbers.
264      */
265     function max(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a >= b ? a : b;
267     }
268 
269     /**
270      * @dev Returns the smallest of two numbers.
271      */
272     function min(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a < b ? a : b;
274     }
275 
276     /**
277      * @dev Returns the average of two numbers. The result is rounded towards
278      * zero.
279      */
280     function average(uint256 a, uint256 b) internal pure returns (uint256) {
281         // (a + b) / 2 can overflow, so we distribute
282         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/math/SafeMath.sol
287 
288 
289 pragma solidity ^0.6.0;
290 
291 /**
292  * @dev Wrappers over Solidity's arithmetic operations with added overflow
293  * checks.
294  *
295  * Arithmetic operations in Solidity wrap on overflow. This can easily result
296  * in bugs, because programmers usually assume that an overflow raises an
297  * error, which is the standard behavior in high level programming languages.
298  * `SafeMath` restores this intuition by reverting the transaction when an
299  * operation overflows.
300  *
301  * Using this library instead of the unchecked operations eliminates an entire
302  * class of bugs, so it's recommended to use it always.
303  */
304 library SafeMath {
305     /**
306      * @dev Returns the addition of two unsigned integers, reverting on
307      * overflow.
308      *
309      * Counterpart to Solidity's `+` operator.
310      *
311      * Requirements:
312      *
313      * - Addition cannot overflow.
314      */
315     function add(uint256 a, uint256 b) internal pure returns (uint256) {
316         uint256 c = a + b;
317         require(c >= a, "SafeMath: addition overflow");
318 
319         return c;
320     }
321 
322     /**
323      * @dev Returns the subtraction of two unsigned integers, reverting on
324      * overflow (when the result is negative).
325      *
326      * Counterpart to Solidity's `-` operator.
327      *
328      * Requirements:
329      *
330      * - Subtraction cannot overflow.
331      */
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         return sub(a, b, "SafeMath: subtraction overflow");
334     }
335 
336     /**
337      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
338      * overflow (when the result is negative).
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
347         require(b <= a, errorMessage);
348         uint256 c = a - b;
349 
350         return c;
351     }
352 
353     /**
354      * @dev Returns the multiplication of two unsigned integers, reverting on
355      * overflow.
356      *
357      * Counterpart to Solidity's `*` operator.
358      *
359      * Requirements:
360      *
361      * - Multiplication cannot overflow.
362      */
363     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
364         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
365         // benefit is lost if 'b' is also tested.
366         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
367         if (a == 0) {
368             return 0;
369         }
370 
371         uint256 c = a * b;
372         require(c / a == b, "SafeMath: multiplication overflow");
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers. Reverts on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator. Note: this function uses a
382      * `revert` opcode (which leaves remaining gas untouched) while Solidity
383      * uses an invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      *
387      * - The divisor cannot be zero.
388      */
389     function div(uint256 a, uint256 b) internal pure returns (uint256) {
390         return div(a, b, "SafeMath: division by zero");
391     }
392 
393     /**
394      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
395      * division by zero. The result is rounded towards zero.
396      *
397      * Counterpart to Solidity's `/` operator. Note: this function uses a
398      * `revert` opcode (which leaves remaining gas untouched) while Solidity
399      * uses an invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
406         require(b > 0, errorMessage);
407         uint256 c = a / b;
408         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
409 
410         return c;
411     }
412 
413     /**
414      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
415      * Reverts when dividing by zero.
416      *
417      * Counterpart to Solidity's `%` operator. This function uses a `revert`
418      * opcode (which leaves remaining gas untouched) while Solidity uses an
419      * invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
423      * - The divisor cannot be zero.
424      */
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         return mod(a, b, "SafeMath: modulo by zero");
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
431      * Reverts with custom message when dividing by zero.
432      *
433      * Counterpart to Solidity's `%` operator. This function uses a `revert`
434      * opcode (which leaves remaining gas untouched) while Solidity uses an
435      * invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      *
439      * - The divisor cannot be zero.
440      */
441     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
442         require(b != 0, errorMessage);
443         return a % b;
444     }
445 }
446 
447 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
448 
449 
450 pragma solidity ^0.6.0;
451 
452 /**
453  * @dev Interface of the ERC20 standard as defined in the EIP.
454  */
455 interface IERC20 {
456     /**
457      * @dev Returns the amount of tokens in existence.
458      */
459     function totalSupply() external view returns (uint256);
460 
461     /**
462      * @dev Returns the amount of tokens owned by `account`.
463      */
464     function balanceOf(address account) external view returns (uint256);
465 
466     /**
467      * @dev Moves `amount` tokens from the caller's account to `recipient`.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transfer(address recipient, uint256 amount) external returns (bool);
474 
475     /**
476      * @dev Returns the remaining number of tokens that `spender` will be
477      * allowed to spend on behalf of `owner` through {transferFrom}. This is
478      * zero by default.
479      *
480      * This value changes when {approve} or {transferFrom} are called.
481      */
482     function allowance(address owner, address spender) external view returns (uint256);
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * IMPORTANT: Beware that changing an allowance with this method brings the risk
490      * that someone may use both the old and the new allowance by unfortunate
491      * transaction ordering. One possible solution to mitigate this race
492      * condition is to first reduce the spender's allowance to 0 and set the
493      * desired value afterwards:
494      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
495      *
496      * Emits an {Approval} event.
497      */
498     function approve(address spender, uint256 amount) external returns (bool);
499 
500     /**
501      * @dev Moves `amount` tokens from `sender` to `recipient` using the
502      * allowance mechanism. `amount` is then deducted from the caller's
503      * allowance.
504      *
505      * Returns a boolean value indicating whether the operation succeeded.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
510 
511     /**
512      * @dev Emitted when `value` tokens are moved from one account (`from`) to
513      * another (`to`).
514      *
515      * Note that `value` may be zero.
516      */
517     event Transfer(address indexed from, address indexed to, uint256 value);
518 
519     /**
520      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
521      * a call to {approve}. `value` is the new allowance.
522      */
523     event Approval(address indexed owner, address indexed spender, uint256 value);
524 }
525 
526 // File: @openzeppelin/contracts/utils/Address.sol
527 
528 
529 pragma solidity ^0.6.2;
530 
531 /**
532  * @dev Collection of functions related to the address type
533  */
534 library Address {
535     /**
536      * @dev Returns true if `account` is a contract.
537      *
538      * [IMPORTANT]
539      * ====
540      * It is unsafe to assume that an address for which this function returns
541      * false is an externally-owned account (EOA) and not a contract.
542      *
543      * Among others, `isContract` will return false for the following
544      * types of addresses:
545      *
546      *  - an externally-owned account
547      *  - a contract in construction
548      *  - an address where a contract will be created
549      *  - an address where a contract lived, but was destroyed
550      * ====
551      */
552     function isContract(address account) internal view returns (bool) {
553         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
554         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
555         // for accounts without code, i.e. `keccak256('')`
556         bytes32 codehash;
557         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
558         // solhint-disable-next-line no-inline-assembly
559         assembly { codehash := extcodehash(account) }
560         return (codehash != accountHash && codehash != 0x0);
561     }
562 
563     /**
564      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
565      * `recipient`, forwarding all available gas and reverting on errors.
566      *
567      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
568      * of certain opcodes, possibly making contracts go over the 2300 gas limit
569      * imposed by `transfer`, making them unable to receive funds via
570      * `transfer`. {sendValue} removes this limitation.
571      *
572      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
573      *
574      * IMPORTANT: because control is transferred to `recipient`, care must be
575      * taken to not create reentrancy vulnerabilities. Consider using
576      * {ReentrancyGuard} or the
577      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
578      */
579     function sendValue(address payable recipient, uint256 amount) internal {
580         require(address(this).balance >= amount, "Address: insufficient balance");
581 
582         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
583         (bool success, ) = recipient.call{ value: amount }("");
584         require(success, "Address: unable to send value, recipient may have reverted");
585     }
586 
587     /**
588      * @dev Performs a Solidity function call using a low level `call`. A
589      * plain`call` is an unsafe replacement for a function call: use this
590      * function instead.
591      *
592      * If `target` reverts with a revert reason, it is bubbled up by this
593      * function (like regular Solidity function calls).
594      *
595      * Returns the raw returned data. To convert to the expected return value,
596      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
597      *
598      * Requirements:
599      *
600      * - `target` must be a contract.
601      * - calling `target` with `data` must not revert.
602      *
603      * _Available since v3.1._
604      */
605     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
606       return functionCall(target, data, "Address: low-level call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
611      * `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
616         return _functionCallWithValue(target, data, 0, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but also transferring `value` wei to `target`.
622      *
623      * Requirements:
624      *
625      * - the calling contract must have an ETH balance of at least `value`.
626      * - the called Solidity function must be `payable`.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
631         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
636      * with `errorMessage` as a fallback revert reason when `target` reverts.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
641         require(address(this).balance >= value, "Address: insufficient balance for call");
642         return _functionCallWithValue(target, data, value, errorMessage);
643     }
644 
645     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
646         require(isContract(target), "Address: call to non-contract");
647 
648         // solhint-disable-next-line avoid-low-level-calls
649         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
650         if (success) {
651             return returndata;
652         } else {
653             // Look for revert reason and bubble it up if present
654             if (returndata.length > 0) {
655                 // The easiest way to bubble the revert reason is using memory via assembly
656 
657                 // solhint-disable-next-line no-inline-assembly
658                 assembly {
659                     let returndata_size := mload(returndata)
660                     revert(add(32, returndata), returndata_size)
661                 }
662             } else {
663                 revert(errorMessage);
664             }
665         }
666     }
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
670 
671 
672 pragma solidity ^0.6.0;
673 
674 
675 
676 
677 
678 /**
679  * @dev Implementation of the {IERC20} interface.
680  *
681  * This implementation is agnostic to the way tokens are created. This means
682  * that a supply mechanism has to be added in a derived contract using {_mint}.
683  * For a generic mechanism see {ERC20PresetMinterPauser}.
684  *
685  * TIP: For a detailed writeup see our guide
686  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
687  * to implement supply mechanisms].
688  *
689  * We have followed general OpenZeppelin guidelines: functions revert instead
690  * of returning `false` on failure. This behavior is nonetheless conventional
691  * and does not conflict with the expectations of ERC20 applications.
692  *
693  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
694  * This allows applications to reconstruct the allowance for all accounts just
695  * by listening to said events. Other implementations of the EIP may not emit
696  * these events, as it isn't required by the specification.
697  *
698  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
699  * functions have been added to mitigate the well-known issues around setting
700  * allowances. See {IERC20-approve}.
701  */
702 contract ERC20 is Context, IERC20 {
703     using SafeMath for uint256;
704     using Address for address;
705 
706     mapping (address => uint256) private _balances;
707 
708     mapping (address => mapping (address => uint256)) private _allowances;
709 
710     uint256 private _totalSupply;
711 
712     string private _name;
713     string private _symbol;
714     uint8 private _decimals;
715 
716     /**
717      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
718      * a default value of 18.
719      *
720      * To select a different value for {decimals}, use {_setupDecimals}.
721      *
722      * All three of these values are immutable: they can only be set once during
723      * construction.
724      */
725     constructor (string memory name, string memory symbol) public {
726         _name = name;
727         _symbol = symbol;
728         _decimals = 18;
729     }
730 
731     /**
732      * @dev Returns the name of the token.
733      */
734     function name() public view returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev Returns the symbol of the token, usually a shorter version of the
740      * name.
741      */
742     function symbol() public view returns (string memory) {
743         return _symbol;
744     }
745 
746     /**
747      * @dev Returns the number of decimals used to get its user representation.
748      * For example, if `decimals` equals `2`, a balance of `505` tokens should
749      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
750      *
751      * Tokens usually opt for a value of 18, imitating the relationship between
752      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
753      * called.
754      *
755      * NOTE: This information is only used for _display_ purposes: it in
756      * no way affects any of the arithmetic of the contract, including
757      * {IERC20-balanceOf} and {IERC20-transfer}.
758      */
759     function decimals() public view returns (uint8) {
760         return _decimals;
761     }
762 
763     /**
764      * @dev See {IERC20-totalSupply}.
765      */
766     function totalSupply() public view override returns (uint256) {
767         return _totalSupply;
768     }
769 
770     /**
771      * @dev See {IERC20-balanceOf}.
772      */
773     function balanceOf(address account) public view override returns (uint256) {
774         return _balances[account];
775     }
776 
777     /**
778      * @dev See {IERC20-transfer}.
779      *
780      * Requirements:
781      *
782      * - `recipient` cannot be the zero address.
783      * - the caller must have a balance of at least `amount`.
784      */
785     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
786         _transfer(_msgSender(), recipient, amount);
787         return true;
788     }
789 
790     /**
791      * @dev See {IERC20-allowance}.
792      */
793     function allowance(address owner, address spender) public view virtual override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796 
797     /**
798      * @dev See {IERC20-approve}.
799      *
800      * Requirements:
801      *
802      * - `spender` cannot be the zero address.
803      */
804     function approve(address spender, uint256 amount) public virtual override returns (bool) {
805         _approve(_msgSender(), spender, amount);
806         return true;
807     }
808 
809     /**
810      * @dev See {IERC20-transferFrom}.
811      *
812      * Emits an {Approval} event indicating the updated allowance. This is not
813      * required by the EIP. See the note at the beginning of {ERC20};
814      *
815      * Requirements:
816      * - `sender` and `recipient` cannot be the zero address.
817      * - `sender` must have a balance of at least `amount`.
818      * - the caller must have allowance for ``sender``'s tokens of at least
819      * `amount`.
820      */
821     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
822         _transfer(sender, recipient, amount);
823         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
824         return true;
825     }
826 
827     /**
828      * @dev Atomically increases the allowance granted to `spender` by the caller.
829      *
830      * This is an alternative to {approve} that can be used as a mitigation for
831      * problems described in {IERC20-approve}.
832      *
833      * Emits an {Approval} event indicating the updated allowance.
834      *
835      * Requirements:
836      *
837      * - `spender` cannot be the zero address.
838      */
839     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
840         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
841         return true;
842     }
843 
844     /**
845      * @dev Atomically decreases the allowance granted to `spender` by the caller.
846      *
847      * This is an alternative to {approve} that can be used as a mitigation for
848      * problems described in {IERC20-approve}.
849      *
850      * Emits an {Approval} event indicating the updated allowance.
851      *
852      * Requirements:
853      *
854      * - `spender` cannot be the zero address.
855      * - `spender` must have allowance for the caller of at least
856      * `subtractedValue`.
857      */
858     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
859         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
860         return true;
861     }
862 
863     /**
864      * @dev Moves tokens `amount` from `sender` to `recipient`.
865      *
866      * This is internal function is equivalent to {transfer}, and can be used to
867      * e.g. implement automatic token fees, slashing mechanisms, etc.
868      *
869      * Emits a {Transfer} event.
870      *
871      * Requirements:
872      *
873      * - `sender` cannot be the zero address.
874      * - `recipient` cannot be the zero address.
875      * - `sender` must have a balance of at least `amount`.
876      */
877     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
878         require(sender != address(0), "ERC20: transfer from the zero address");
879         require(recipient != address(0), "ERC20: transfer to the zero address");
880 
881         _beforeTokenTransfer(sender, recipient, amount);
882 
883         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
884         _balances[recipient] = _balances[recipient].add(amount);
885         emit Transfer(sender, recipient, amount);
886     }
887 
888     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
889      * the total supply.
890      *
891      * Emits a {Transfer} event with `from` set to the zero address.
892      *
893      * Requirements
894      *
895      * - `to` cannot be the zero address.
896      */
897     function _mint(address account, uint256 amount) internal virtual {
898         require(account != address(0), "ERC20: mint to the zero address");
899 
900         _beforeTokenTransfer(address(0), account, amount);
901 
902         _totalSupply = _totalSupply.add(amount);
903         _balances[account] = _balances[account].add(amount);
904         emit Transfer(address(0), account, amount);
905     }
906 
907     /**
908      * @dev Destroys `amount` tokens from `account`, reducing the
909      * total supply.
910      *
911      * Emits a {Transfer} event with `to` set to the zero address.
912      *
913      * Requirements
914      *
915      * - `account` cannot be the zero address.
916      * - `account` must have at least `amount` tokens.
917      */
918     function _burn(address account, uint256 amount) internal virtual {
919         require(account != address(0), "ERC20: burn from the zero address");
920 
921         _beforeTokenTransfer(account, address(0), amount);
922 
923         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
924         _totalSupply = _totalSupply.sub(amount);
925         emit Transfer(account, address(0), amount);
926     }
927 
928     /**
929      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
930      *
931      * This is internal function is equivalent to `approve`, and can be used to
932      * e.g. set automatic allowances for certain subsystems, etc.
933      *
934      * Emits an {Approval} event.
935      *
936      * Requirements:
937      *
938      * - `owner` cannot be the zero address.
939      * - `spender` cannot be the zero address.
940      */
941     function _approve(address owner, address spender, uint256 amount) internal virtual {
942         require(owner != address(0), "ERC20: approve from the zero address");
943         require(spender != address(0), "ERC20: approve to the zero address");
944 
945         _allowances[owner][spender] = amount;
946         emit Approval(owner, spender, amount);
947     }
948 
949     /**
950      * @dev Sets {decimals} to a value other than the default one of 18.
951      *
952      * WARNING: This function should only be called from the constructor. Most
953      * applications that interact with token contracts will not expect
954      * {decimals} to ever change, and may work incorrectly if it does.
955      */
956     function _setupDecimals(uint8 decimals_) internal {
957         _decimals = decimals_;
958     }
959 
960     /**
961      * @dev Hook that is called before any transfer of tokens. This includes
962      * minting and burning.
963      *
964      * Calling conditions:
965      *
966      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
967      * will be to transferred to `to`.
968      * - when `from` is zero, `amount` tokens will be minted for `to`.
969      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
970      * - `from` and `to` are never both zero.
971      *
972      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
973      */
974     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
975 }
976 
977 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
978 
979 
980 pragma solidity ^0.6.0;
981 
982 
983 
984 
985 /**
986  * @title SafeERC20
987  * @dev Wrappers around ERC20 operations that throw on failure (when the token
988  * contract returns false). Tokens that return no value (and instead revert or
989  * throw on failure) are also supported, non-reverting calls are assumed to be
990  * successful.
991  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
992  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
993  */
994 library SafeERC20 {
995     using SafeMath for uint256;
996     using Address for address;
997 
998     function safeTransfer(IERC20 token, address to, uint256 value) internal {
999         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1000     }
1001 
1002     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1003         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1004     }
1005 
1006     /**
1007      * @dev Deprecated. This function has issues similar to the ones found in
1008      * {IERC20-approve}, and its usage is discouraged.
1009      *
1010      * Whenever possible, use {safeIncreaseAllowance} and
1011      * {safeDecreaseAllowance} instead.
1012      */
1013     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1014         // safeApprove should only be called when setting an initial allowance,
1015         // or when resetting it to zero. To increase and decrease it, use
1016         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1017         // solhint-disable-next-line max-line-length
1018         require((value == 0) || (token.allowance(address(this), spender) == 0),
1019             "SafeERC20: approve from non-zero to non-zero allowance"
1020         );
1021         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1022     }
1023 
1024     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1025         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1026         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1027     }
1028 
1029     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1030         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1031         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1032     }
1033 
1034     /**
1035      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1036      * on the return value: the return value is optional (but if data is returned, it must not be false).
1037      * @param token The token targeted by the call.
1038      * @param data The call data (encoded using abi.encode or one of its variants).
1039      */
1040     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1041         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1042         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1043         // the target address contains contract code and also asserts for success in the low-level call.
1044 
1045         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1046         if (returndata.length > 0) { // Return data is optional
1047             // solhint-disable-next-line max-line-length
1048             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1049         }
1050     }
1051 }
1052 
1053 // File: contracts/libraries/UniERC20.sol
1054 
1055 
1056 pragma solidity ^0.6.0;
1057 
1058 
1059 
1060 
1061 
1062 library UniERC20 {
1063     using SafeMath for uint256;
1064     using SafeERC20 for IERC20;
1065 
1066     function isETH(IERC20 token) internal pure returns(bool) {
1067         return (address(token) == address(0));
1068     }
1069 
1070     function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
1071         if (isETH(token)) {
1072             return account.balance;
1073         } else {
1074             return token.balanceOf(account);
1075         }
1076     }
1077 
1078     function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {
1079         if (amount > 0) {
1080             if (isETH(token)) {
1081                 to.transfer(amount);
1082             } else {
1083                 token.safeTransfer(to, amount);
1084             }
1085         }
1086     }
1087 
1088     function uniTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
1089         if (amount > 0) {
1090             if (isETH(token)) {
1091                 require(msg.value >= amount, "UniERC20: not enough value");
1092                 if (msg.value > amount) {
1093                     // Return remainder if exist
1094                     msg.sender.transfer(msg.value.sub(amount));
1095                 }
1096             } else {
1097                 token.safeTransferFrom(msg.sender, address(this), amount);
1098             }
1099         }
1100     }
1101 
1102     function uniSymbol(IERC20 token) internal view returns(string memory) {
1103         if (isETH(token)) {
1104             return "ETH";
1105         }
1106 
1107         (bool success, bytes memory data) = address(token).staticcall{ gas: 20000 }(
1108             abi.encodeWithSignature("symbol()")
1109         );
1110         if (!success) {
1111             (success, data) = address(token).staticcall{ gas: 20000 }(
1112                 abi.encodeWithSignature("SYMBOL()")
1113             );
1114         }
1115 
1116         if (success && data.length >= 96) {
1117             (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
1118             if (offset == 0x20 && len > 0 && len <= 256) {
1119                 return string(abi.decode(data, (bytes)));
1120             }
1121         }
1122 
1123         if (success && data.length == 32) {
1124             uint len = 0;
1125             while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
1126                 len++;
1127             }
1128 
1129             if (len > 0) {
1130                 bytes memory result = new bytes(len);
1131                 for (uint i = 0; i < len; i++) {
1132                     result[i] = data[i];
1133                 }
1134                 return string(result);
1135             }
1136         }
1137 
1138         return _toHex(address(token));
1139     }
1140 
1141     function _toHex(address account) private pure returns(string memory) {
1142         return _toHex(abi.encodePacked(account));
1143     }
1144 
1145     function _toHex(bytes memory data) private pure returns(string memory) {
1146         bytes memory str = new bytes(2 + data.length * 2);
1147         str[0] = "0";
1148         str[1] = "x";
1149         uint j = 2;
1150         for (uint i = 0; i < data.length; i++) {
1151             uint a = uint8(data[i]) >> 4;
1152             uint b = uint8(data[i]) & 0x0f;
1153             str[j++] = byte(uint8(a + 48 + (a/10)*39));
1154             str[j++] = byte(uint8(b + 48 + (b/10)*39));
1155         }
1156 
1157         return string(str);
1158     }
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
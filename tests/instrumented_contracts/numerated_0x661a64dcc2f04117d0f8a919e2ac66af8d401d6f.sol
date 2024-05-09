1 pragma solidity 0.4.25;
2 
3 /*===========================================================================================*
4 *************************************** https://p4d.io ***************************************
5 *============================================================================================*
6 *                                                             
7 *     ,-.----.           ,--,              
8 *     \    /  \        ,--.'|    ,---,     
9 *     |   :    \    ,--,  | :  .'  .' `\          ____                            __      
10 *     |   |  .\ :,---.'|  : ',---.'     \        / __ \________  ________  ____  / /______
11 *     .   :  |: |;   : |  | ;|   |  .`\  |      / /_/ / ___/ _ \/ ___/ _ \/ __ \/ __/ ___/
12 *     |   |   \ :|   | : _' |:   : |  '  |     / ____/ /  /  __(__  )  __/ / / / /_(__  ) 
13 *     |   : .   /:   : |.'  ||   ' '  ;  :    /_/   /_/___\\\_/____/\_\\/_\_/_/\__/____/  
14 *     ;   | |`-' |   ' '  ; :'   | ;  .  |            /_  __/___      \ \/ /___  __  __   
15 *     |   | ;    \   \  .'. ||   | :  |  '             / / / __ \      \  / __ \/ / / /   
16 *     :   ' |     `---`:  | ''   : | /  ;             / / / /_/ /      / / /_/ / /_/ /    
17 *     :   : :          '  ; ||   | '` ,/             /_/  \____/      /_/\____/\__,_/     
18 *     |   | :          |  : ;;   :  .'     
19 *     `---'.|          '  ,/ |   ,.'       
20 *       `---`          '--'  '---'         
21 *                 _______                             _                      
22 *                (_______)                   _       | |                 _   
23 *                 _        ____ _   _ ____ _| |_ ___ | |__  _   _ ____ _| |_ 
24 *                | |      / ___) | | |  _ (_   _) _ \|  _ \| | | |  _ (_   _)
25 *                | |_____| |   | |_| | |_| || || |_| | | | | |_| | | | || |_ 
26 *                 \______)_|    \__  |  __/  \__)___/|_| |_|____/|_| |_| \__)
27 *                              (____/|_|                                     
28 *                                            _.--.
29 *                                        _.-'_:-'||
30 *                                    _.-'_.-::::'||
31 *                               _.-:'_.-::::::'  ||
32 *                             .'`-.-:::::::'     ||
33 *                            /.'`;|:::::::'      ||_
34 *                           ||   ||::::::'     _.;._'-._
35 *                           ||   ||:::::'  _.-!oo @.!-._'-.
36 *                           \'.  ||:::::.-!()oo @!()@.-'_.|
37 *                            '.'-;|:.-'.&$@.& ()$%-'o.'\U||
38 *                              `>'-.!@%()@'@_%-'_.-o _.|'||
39 *                               ||-._'-.@.-'_.-' _.-o  |'||
40 *                               ||=[ '-._.-\U/.-'    o |'||
41 *                               || '-.]=|| |'|      o  |'||
42 *                               ||      || |'|        _| ';
43 *                               ||      || |'|    _.-'_.-'
44 *                               |'-._   || |'|_.-'_.-'
45 *                                '-._'-.|| |' `_.-'
46 *                                    '-.||_/.-'
47 *                        _       __ _     _     _ _          ___       
48 *                       /_\     /__(_) __| | __| | | ___    / __\_   _ 
49 *                      //_\\   / \// |/ _` |/ _` | |/ _ \  /__\// | | |
50 *                     /  _  \ / _  \ | (_| | (_| | |  __/ / \/  \ |_| |
51 *                     \_/ \_/ \/ \_/_|\__,_|\__,_|_|\___| \_____/\__, |
52 *                                   ╔═╗╔═╗╦      ╔╦╗╔═╗╦  ╦      |___/ 
53 *                                   ╚═╗║ ║║       ║║║╣ ╚╗╔╝
54 *                                   ╚═╝╚═╝╩═╝────═╩╝╚═╝ ╚╝ 
55 *                                      0x736f6c5f646576
56 *                                      ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
57 *                                                
58 */
59 
60 /*=============================================================================*
61 ************************************ What? *************************************
62 *==============================================================================*
63 
64 Right now you are wondering what is this token,
65 and why you can't transfer it, so it must be broken!
66 
67 To remove this token, one must be wise,
68 and solve all the riddles to unlock the prize!
69 
70 From simple to complex as they progress,
71 leading you to a solution that you cannot just guess!
72 
73 Once solved you will notice the token goes away,
74 as well as receiving some ether for your delay!
75 
76 If you liked this riddle, then the future is bright,
77 so get some more P4D while the timing is right!
78 
79 */
80 
81 /*=============================================================================*
82 *********************************** Clue #1 ************************************
83 *==============================================================================*
84 
85 Whenever you're stuck, just ask yourself; what's the meaning of life?
86 
87 */
88 
89 /*=============================================================================*
90 *********************************** Clue #2 ************************************
91 *==============================================================================*
92 
93 1pdt7g3cg7z5mh8rzj3wuBd31CtF7Bd6zy71721gChEhbo8e4Cs1i1gAhev76rEb2i3js1nAmglsp0Bb
94 y4aad7tuyks8qDnkpcdA906biicn31chEpxvl4Amnp6gqDl6vr3jn4lz4eiC9tB69j797b3jhragxw9q
95 F6bqx81f29fkEwvhmD1svFpd2Az5z2vuzicBA3qqChDxiqoceoxD0n179z1ie7x19r94zo18e1ADeels
96 F8tDC22Bqkqiq0rdae5dz3rlfclBcjuu9ksBy9yx6pyqpyd7gCtB731wEcsk90sfbziB0Arz3bey75np
97 mod7
98 
99 */
100 
101 /*=============================================================================*
102 *********************************** Clue #3 ************************************
103 *==============================================================================*
104 
105 10101011000101011001111000101100011111011000001100111000000001010000001111110111
106 00011100101001101111111100001111101100000011011000011001100110010010011001111101
107 0000001100110101000110000111011110110100001100000000110001110110
108 
109 */
110 
111 /*=============================================================================*
112 *********************************** Clue #4 ************************************
113 *==============================================================================*
114 
115 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
162 tVRF51A8tQh6saGW4TcTw8ow1NmisIwEmS
163 
164 */
165 
166 /*=============================================================================*
167 *********************************** Clue #5 ************************************
168 *==============================================================================*
169 
170 SmEwIS05nqwVgR8OCws+o2dWSGxCe5/f+7kA28iytFDXnhdPqGVyex/+hRyiE7XYR80SJgUemXWyAYdD
171 8FjvErauf8Qh6ru/QYQBhWoNLHW6R2rF955M5fW+jdjgxlRToGJ9zR8qPL9M6VGt4mFhReHRnIZBKs9o
172 OeUwyF+IzVfYkt7dL59vTBCKRlyBS2XJCP7wWX6DJ0/dntnPG0PkUAy3MA9TDxz/yPaAIyted6h82QID
173 dzXUaCmFg3919gujGt3bAE5nXTidSVpc5wcsuX1XEN32lwKkS/xlCpcIdnEgtrXDH1B3x4083992ebb0
174 d615d8357b18267dac841981097c14083992ebb0d615d8357b1822tCnE
175 
176 */
177 
178 /*=============================================================================*
179 *********************************** Clue #6 ************************************
180 *==============================================================================*
181 
182 EnCt2f7b689397445493a1945b3c064246eb23420eecaf7b689397445493a1945b3c0NibxGOxzdgH
183 yBkP8Clwnxzz8iI90NAeKnQeqDTwl9Vn00VsPD+j2evfnms7GBKe4d/yqKqmaXjzRuMutBqcQ7qjOTne
184 PWGD4hFRMFyDtHvhg+/N4nk5NqqzgI5HyvRGfGyh4r84+3SVNZt2zuq+ufM9mBaWECgHieQhax9NR6zD
185 VeVirdQhcqjjgLdsqwRunxviwSr5h0ikvhdV3A07/cjAFW2XEg4ncisLg9Vj+kfqfGI4k/RG+j4vhbMF
186 zBrUPYUiJp0t0YDFpX1cM0VYYAra87z5g1/SXui3X9WcRhIW6pACoydxStL7XSzaRZ/Vw4W6ssx8Ph9N
187 HoNajrUr4i6JOGTTzqnC08d3iBd1/0uvGOce2Urnun9BDnkv6JevmzlpOS9jUUaip8layBaUQmfx9DUC
188 43RoLLRLcJ6P1TvTeU6m2xH0otMlv4FbOgREUdLUVi/PmH8JiMHWyq1Jkqti5Gdnu93XDSywi/8NmmqJ
189 F+APjRcponDF/BsenRIy69oV9AUE4t9n+6cF2cNYmZd/NXlCRdRUrth4qULa7fc3jkMA7N4w1buYS16n
190 +eZNUrH/vTgv9IJ4dg5VbE8kUCi51JN5Y8c+1lrh4DMRHFzn/PT6d2/Mh6HA8XiSauOqR2tny9uYSUvV
191 6MKNzJORtyPTWXhgVyOBjzGJInDIi1IGDGMmQAFasoaG5zq1xPIHOxPGmQsFbcX1Ye6JJ4rP6eKPjglp
192 xR/JT5rEJkGolhrb69v1v5OUytO8F2dSngEZF5yhLBYb9g7PuR915jwLDIsZAHGmvLaNCadtkw6/1yrf
193 8gTTGAIx8NQ02MiD+hQGIWVTJ44UsVI5CUJZ9ddOFWtc0v2b6xESUgBFlnUHc4YXaCrVFGk/mKamS8PS
194 7Lvp7ncIYSGjieQvFYpXNpeVw92eD/OkP6o6WO483adcGzxbP3Fscy0T3+BMx12sHYpYcF/E2GVnUOtY
195 cT5rwMQ==IwEmS
196 
197 */
198 
199 /* Hashing contract used to generate all keccak based solutions;
200 
201 pragma solidity 0.4.25;
202 
203 contract Hasher {
204     function hash_uint256(uint256 n) public pure returns (bytes32) {
205         return keccak256(abi.encodePacked(n));
206     }
207     function hash_string(string s) public pure returns (bytes32) {
208         return keccak256(abi.encodePacked(s));
209     }
210 }
211 
212 */
213 
214 contract ERC20_Basic {
215 
216     function totalSupply() public view returns (uint256);
217     function balanceOf(address) public view returns (uint256);
218     function transfer(address, uint256) public returns (bool);
219 
220     event Transfer(address indexed from, address indexed to, uint256 tokens);
221 }
222 
223 contract Cryptohunt is ERC20_Basic {
224 
225 	bool public _hasBeenSolved = false;
226 	uint256 public _launchedTime;
227 	uint256 public _solvedTime;
228 
229 	string public constant name = "Cryptohunt";
230 	string public constant symbol = "P4D Riddle";
231 	uint8 public constant decimals = 18;
232 
233 	address constant private src = 0x058a144951e062FC14f310057D2Fd9ef0Cf5095b;
234 	uint256 constant private amt = 1e18;
235 
236 	event Log(string msg);
237 
238 	constructor() public {
239 		emit Transfer(address(this), src, amt);
240 		_launchedTime = now;
241 	}
242 
243 	function attemptToSolve(string answer) public {
244 		bytes32 hash = keccak256(abi.encodePacked(answer));
245 		if (hash == 0x6fd689cdf2f367aa9bd63f9306de49f00479b474f606daed7c015f3d85ff4e40) {
246 			if (!_hasBeenSolved) {
247 				emit Transfer(src, address(0x0), amt);
248 				emit Log("Well done! You've deserved this!");
249 				emit Log(answer);
250 				_hasBeenSolved = true;
251 				_solvedTime = now;
252 			}
253 			msg.sender.transfer(address(this).balance);
254 		} else {
255 			emit Log("Sorry, but that's not the correct answer!");
256 		}
257 	}
258 
259 	function() public payable {
260 		// allow donations
261 	}
262 
263 	function totalSupply() public view returns (uint256) {
264 		return (_hasBeenSolved ? 0 : amt);
265 	}
266 
267 	function balanceOf(address owner) public view returns (uint256) {
268 		return (_hasBeenSolved || owner != src ? 0 : amt);
269 	}
270 
271 	function transfer(address, uint256) public returns (bool) {
272 		return false;
273 	}
274 
275 	// ...and that's all you really need for a 'broken' token
276 }
277 
278 /*===========================================================================================*
279 *************************************** https://p4d.io ***************************************
280 *===========================================================================================*/
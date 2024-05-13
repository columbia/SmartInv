1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 import "@pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol";
36 
37 
38 contract Whitelist is Ownable {
39     mapping(address => bool) private _whitelist;
40     bool private _disable;                      // default - false means whitelist feature is working on. if true no more use of whitelist
41 
42     event Whitelisted(address indexed _address, bool whitelist);
43     event EnableWhitelist();
44     event DisableWhitelist();
45 
46     modifier onlyWhitelisted {
47         require(_disable || _whitelist[msg.sender], "Whitelist: caller is not on the whitelist");
48         _;
49     }
50 
51     function isWhitelist(address _address) public view returns (bool) {
52         return _whitelist[_address];
53     }
54 
55     function setWhitelist(address _address, bool _on) external onlyOwner {
56         _whitelist[_address] = _on;
57 
58         emit Whitelisted(_address, _on);
59     }
60 
61     function disableWhitelist(bool disable) external onlyOwner {
62         _disable = disable;
63         if (disable) {
64             emit DisableWhitelist();
65         } else {
66             emit EnableWhitelist();
67         }
68     }
69 }

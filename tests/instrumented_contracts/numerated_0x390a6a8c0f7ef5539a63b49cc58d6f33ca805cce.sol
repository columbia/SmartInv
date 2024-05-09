1 /*
2 This creates a public tradeable fungible token in the Ethereum Blockchain.
3 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
4 
5 Unmodified this will create a cryptoasset with a fixed market cap
6 wholly owned by the contract creator. You can create any function
7 to change this contract, like allowing specific rules for the issuance,
8 destruction and freezing of any assets. This contract is intended for
9 educational purposes, you are fully responsible for compliance with
10 present or future regulations of finance, communications and the
11 universal rights of digital beings.
12 
13 Anyone is free to copy, modify, publish, use, compile, sell, or
14 distribute this software, either in source code form or as a compiled
15 binary, for any purpose, commercial or non-commercial, and by any
16 means.
17 
18 In jurisdictions that recognize copyright laws, the author or authors
19 of this software dedicate any and all copyright interest in the
20 software to the public domain. We make this dedication for the benefit
21 of the public at large and to the detriment of our heirs and
22 successors. We intend this dedication to be an overt act of
23 relinquishment in perpetuity of all present and future rights to this
24 software under copyright law.
25 
26 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
27 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
28 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
29 IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
30 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
31 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
32 OTHER DEALINGS IN THE SOFTWARE.
33 
34 For more information, please refer to <http://unlicense.org>
35 
36 */
37 contract MyToken {
38     /* Public variables of the token */
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45 
46     /* This generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     /* Initializes contract with initial supply tokens to the creator of the contract */
50     function MyToken(uint256 _supply, string _name, string _symbol, uint8 _decimals) {
51         /* if supply not given then generate 1 million of the smallest unit of the token */
52         if (_supply == 0) _supply = 1000000;
53 
54         /* Unless you add other functions these variables will never change */
55         balanceOf[msg.sender] = _supply;
56         name = _name;
57         symbol = _symbol;
58 
59         /* If you want a divisible token then add the amount of decimals the base unit has  */
60         decimals = _decimals;
61     }
62 
63     /* Send coins */
64     function transfer(address _to, uint256 _value) {
65         /* if the sender doenst have enough balance then stop */
66         if (balanceOf[msg.sender] < _value) throw;
67         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
68 
69         /* Add and subtract new balances */
70         balanceOf[msg.sender] -= _value;
71         balanceOf[_to] += _value;
72 
73         /* Notifiy anyone listening that this transfer took place */
74         Transfer(msg.sender, _to, _value);
75     }
76 }
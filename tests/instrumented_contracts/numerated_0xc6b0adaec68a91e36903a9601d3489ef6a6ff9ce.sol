1 /**
2 * Copyright Accelerator 2019
3 *
4 * Permission is hereby granted, free of charge, to any person obtaining a copy
5 * of this software and associated documentation files (the "Software"), to deal
6 * in the Software without restriction, including without limitation the rights
7 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8 * copies of the Software, and to permit persons to whom the Software is furnished to
9 * do so, subject to the following conditions:
10 *
11 * The above copyright notice and this permission notice shall be included in all
12 * copies or substantial portions of the Software.
13 *
14 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
18 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
19 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
20 */
21 pragma solidity ^0.4.24;
22 contract Accelerator {
23   function transfer(address to, uint256 tokens) public returns (bool success);
24   function transferFrom(address from, address to, uint256 value) public returns (bool success);
25 }
26 contract Domain {
27 string public name;
28 constructor(string register_domain) public {
29     name = register_domain;
30 }
31 }
32 contract Registrar {
33   /// @dev Set constant values here
34   string public constant name = "Accelerator-Registrar";
35   address constant public ACCELERATOR_ADDR = 0x13F1b7FDFbE1fc66676D56483e21B1ecb40b58E2; // Accelerator contract address
36   // index of created contracts
37   address[] public contracts;
38   // useful to know the row count in contracts index
39   function getContractCount()
40     public
41     constant
42     returns(uint contractCount)
43   {
44     return contracts.length;
45   }
46   /// @dev Register Domain
47   function register(
48     string register_domain
49   ) public returns(address newContract)
50   {
51     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
52     require(Accelerator(ACCELERATOR_ADDR).transferFrom(msg.sender, this, 10**21));
53     /// @dev Send the tokens to address(0) (the burn address) - require it or fail here
54     require(Accelerator(ACCELERATOR_ADDR).transfer(address(0), 10**21));
55     address c = new Domain(register_domain);
56     contracts.push(c);
57     return c;
58   }
59 }
1 /**
2 *
3 The MIT License (MIT)
4 
5 Copyright (c) 2018 Bitindia.
6 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
7 
8 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
9 
10 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
11 For more information regarding the MIT License visit: https://opensource.org/licenses/MIT
12 
13 @AUTHOR Bitindia. https://bitindia.co/
14 *
15 */
16 
17 pragma solidity ^0.4.19;
18 
19 
20 contract BurnTokens {
21     
22   /**
23    * Address initiating the contract to make sure it only can destroy the contract
24    */ 
25   address owner;
26   
27   /**
28    * @notice BurnTokens cnstr
29    * Sets the owner address
30    */ 
31   function BurnTokens() public {
32       owner = msg.sender;
33   }
34 
35     
36   /*
37   ** @notice selfdestruct contract  
38   *  Only owner can call this method
39   *  Any token balance before this call will be lost forever
40   */
41   function destroy() public {
42       assert(msg.sender == owner);
43       selfdestruct(this);
44   }
45   
46 }
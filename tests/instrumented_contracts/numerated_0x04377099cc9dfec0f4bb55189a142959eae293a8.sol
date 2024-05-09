1 pragma solidity ^0.4.18;
2 /*
3 MIT License
4 
5 Copyright (c) 2018 TrustToken
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
8 
9 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
10 
11 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
12 */
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93 }
94 
95 contract Claimable is Ownable {
96   address public pendingOwner;
97 
98   /**
99    * @dev Modifier throws if called by any account other than the pendingOwner.
100    */
101   modifier onlyPendingOwner() {
102     require(msg.sender == pendingOwner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to set the pendingOwner address.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) onlyOwner public {
111     pendingOwner = newOwner;
112   }
113 
114   /**
115    * @dev Allows the pendingOwner address to finalize the transfer.
116    */
117   function claimOwnership() onlyPendingOwner public {
118     OwnershipTransferred(owner, pendingOwner);
119     owner = pendingOwner;
120     pendingOwner = address(0);
121   }
122 }
123 
124 contract AllowanceSheet is Claimable {
125     using SafeMath for uint256;
126 
127     mapping (address => mapping (address => uint256)) public allowanceOf;
128 
129     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
130         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
131     }
132 
133     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
134         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
135     }
136 
137     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
138         allowanceOf[tokenHolder][spender] = value;
139     }
140 }
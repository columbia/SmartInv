1 pragma solidity ^0.4.18;
2 
3 /**
4 
5   Copyright (c) 2018 The Ocean.
6 
7   Licensed under the MIT License: https://opensource.org/licenses/MIT.
8 
9   Permission is hereby granted, free of charge, to any person obtaining
10   a copy of this software and associated documentation files (the
11   "Software"), to deal in the Software without restriction, including
12   without limitation the rights to use, copy, modify, merge, publish,
13   distribute, sublicense, and/or sell copies of the Software, and to
14   permit persons to whom the Software is furnished to do so, subject to
15   the following conditions:
16 
17   The above copyright notice and this permission notice shall be included
18   in all copies or substantial portions of the Software.
19 
20   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
21   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
22   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
23   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
24   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
25   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
26   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
27 
28 **/
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 /**
79  * @title Whitelist
80  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
81  * @dev This simplifies the implementation of "user permissions".
82  */
83 contract Whitelist is Ownable {
84   mapping(address => bool) public whitelist;
85 
86   event WhitelistedAddressAdded(address addr);
87   event WhitelistedAddressRemoved(address addr);
88 
89   /**
90    * @dev Throws if called by any account that's not whitelisted.
91    */
92   modifier onlyWhitelisted() {
93     require(whitelist[msg.sender]);
94     _;
95   }
96 
97   /**
98    * @dev add an address to the whitelist
99    * @param addr address
100    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
101    */
102   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
103     if (!whitelist[addr]) {
104       whitelist[addr] = true;
105       WhitelistedAddressAdded(addr);
106       success = true;
107     }
108   }
109 
110   /**
111    * @dev add addresses to the whitelist
112    * @param addrs addresses
113    * @return true if at least one address was added to the whitelist,
114    * false if all addresses were already in the whitelist
115    */
116   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
117     for (uint256 i = 0; i < addrs.length; i++) {
118       if (addAddressToWhitelist(addrs[i])) {
119         success = true;
120       }
121     }
122   }
123 
124   /**
125    * @dev remove an address from the whitelist
126    * @param addr address
127    * @return true if the address was removed from the whitelist,
128    * false if the address wasn't in the whitelist in the first place
129    */
130   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
131     if (whitelist[addr]) {
132       whitelist[addr] = false;
133       WhitelistedAddressRemoved(addr);
134       success = true;
135     }
136   }
137 
138   /**
139    * @dev remove addresses from the whitelist
140    * @param addrs addresses
141    * @return true if at least one address was removed from the whitelist,
142    * false if all addresses weren't in the whitelist in the first place
143    */
144   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
145     for (uint256 i = 0; i < addrs.length; i++) {
146       if (removeAddressFromWhitelist(addrs[i])) {
147         success = true;
148       }
149     }
150   }
151 
152 }
153 
154 
155 contract OceanTokenTransferManager is Ownable, Whitelist {
156 
157   /**
158    * @dev check if transferFrom is possible
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    */
162   function canTransferFrom(address _from, address _to) public constant returns (bool success) {
163     if (whitelist[_from] == true || whitelist[_to] == true) {
164       return true;
165     } else {
166       return false;
167     }
168   }
169 }
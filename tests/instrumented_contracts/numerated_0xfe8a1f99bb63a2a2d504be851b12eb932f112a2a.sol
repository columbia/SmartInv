1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 file:       Docsigner.sol
6 version:    0.1
7 author:     Block8 Technologies
8 
9             Samuel Brooks
10 
11 date:       2018-02-01
12 
13 checked:    Anton Jurisevic
14 approved:   Samuel Brooks
15 
16 -----------------------------------------------------------------
17 MODULE DESCRIPTION
18 -----------------------------------------------------------------
19 
20 
21 
22 -----------------------------------------------------------------
23 LICENCE INFORMATION
24 -----------------------------------------------------------------
25 
26 Copyright (c) 2018 Redenbach Lee Lawyers
27 
28 Permission is hereby granted, free of charge, to any person obtaining a copy
29 of this software and associated documentation files (the "Software"), to deal
30 in the Software without restriction, including without limitation the rights
31 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
32 copies of the Software, and to permit persons to whom the Software is
33 furnished to do so, subject to the following conditions:
34 
35 The above copyright notice and this permission notice shall be included in all
36 copies or substantial portions of the Software.
37 
38 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
39 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
40 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
41 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
42 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
43 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
44 SOFTWARE.
45 
46 -----------------------------------------------------------------
47 RELEASE NOTES
48 -----------------------------------------------------------------
49 
50 -----------------------------------------------------------------
51 Block8 Technologies is accelerating blockchain technology
52 by incubating meaningful next-generation businesses.
53 Find out more at https://www.block8.io/
54 -----------------------------------------------------------------
55 */
56 
57 pragma solidity ^0.4.19;
58 
59 contract DocSigner {
60 
61 // -------------------------------------------------------------
62 // STATE DECLARATION
63 // -------------------------------------------------------------
64 
65     address public owner;// Redenbach-Lee address
66     uint constant maxSigs = 10; // maximum number of counterparties
67     uint numSigs = 0; // number of signatures for the next signing
68     string public docHash; // current document hash
69     address[10] signatories; // signatory addresses
70     mapping(address => string) public messages;
71 
72 // -------------------------------------------------------------
73 // CONSTRUCTOR
74 // -------------------------------------------------------------
75 
76     function DocSigner()
77         public
78     {
79         owner = msg.sender;
80     }
81 
82 // -------------------------------------------------------------
83 // EVENTS
84 // -------------------------------------------------------------
85 
86     event Signature(address signer, string docHash, string message);
87 
88 // -------------------------------------------------------------
89 // FUNCTIONS
90 // -------------------------------------------------------------
91 
92     /*
93       This is the initialisation function for a new legal contract.
94       The contract owner sets the new agreement hash and the
95       number of signatories.
96     */
97 
98     function setup( string   newDocHash,
99                     address[] newSigs )
100         external
101         onlyOwner
102     {
103         require( newSigs.length <= maxSigs ); // bound array
104 
105         docHash = newDocHash;
106         numSigs = newSigs.length;
107 
108         for( uint i = 0; i < numSigs; i++ ){
109             signatories[i] = newSigs[i];
110         }
111     }
112 
113     /*
114       This is the function used by signatories to confirm
115       their agreement over the document hash.
116     */
117 
118     function sign( string signingHash,
119                    string message )
120         external
121         onlySigner
122     {
123         require(keccak256(signingHash) == keccak256(docHash));
124 
125         // save the message to state so that it can be easily queried
126         messages[msg.sender] = message;
127 
128         Signature(msg.sender, docHash, message);
129     }
130 
131     /*
132       Check if the address is within the approved signatories list.
133     */
134 
135     function checkSig(address addr)
136         internal
137         view
138         returns (bool)
139     {
140         for( uint i = 0; i < numSigs; i++ ){
141             if( signatories[i] == addr )
142                 return true;
143         }
144 
145         return false;
146     }
147 
148 // -------------------------------------------------------------
149 // MODIFIERS
150 // -------------------------------------------------------------
151 
152     modifier onlyOwner
153     {
154         require(msg.sender == owner);
155         _;
156     }
157 
158     modifier onlySigner
159     {
160         require(checkSig(msg.sender));
161         _;
162     }
163 }